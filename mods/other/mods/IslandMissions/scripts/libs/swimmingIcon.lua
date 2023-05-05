
-- swimmingIcon
-- Created by Lemonymous, updated by tosx

local VERSION = "0.0.2"

local icon = sdlext.surface("img/combat/icons/icon_flying.png")
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local menu = require(path .."libs/menu")
local UiCover = require(path .."ui/cover")
local clip = require(path .."libs/clip")--!!!

local newicon
local pawnTypeShown = false


local function IsAmphibious(pawn)
	local pawnType
	local flyingPilot
	
	if pawn then
		pawnType = pawn:GetType()
		flyingPilot = pawn:IsAbility("Flying")
	elseif pawnTypeShown then
		-- one of our pawntypes is highlighted via unit pane, no pawn selected/highlighted
		-- todo: better way to detect pawns highlighted from the sidebar
		pawnType = pawnTypeShown
		flyingPilot = false -- Can't know; all we have is a type
	else
		return false
	end
	
	local pawnData = _G[pawnType]
	
	return pawnData and pawnData.tosx_trait_swimming and pawnData.Flying and not flyingPilot
end

-- returns the pawnId of pawn
-- currently having it's UI drawn.
function GetUIEnabledPawn()
	local pawn = Board:GetSelectedPawn()
	
	if not pawn then
		local highlighted = Board:GetHighlighted()
		
		if highlighted and Board then
			pawn = Board:GetPawn(highlighted)
		end
	end
	
	return pawn
end

local missionSmallWidget
local missionLargeWidget

local function UiRootCreatedHook(screen, uiRoot)
	
	local decoDrawFn = function(self, screen, widget)
		local oldX = widget.rect.x
		local oldY = widget.rect.y
		
		widget.rect.x = widget.rect.x - 2
		widget.rect.y = widget.rect.y + 2
		
		DecoSurfaceOutlined.draw(self, screen, widget)
		
		widget.rect.x = oldX
		widget.rect.y = oldY
	end
	
	-- 1 widget to cover up flying icon
	-- when hovering/selecting mech in mission
	missionSmallWidget = Ui()
		:widthpx(25):heightpx(21)
		:addTo(uiRoot)
	local mask = UiCover({size = {25, 21}})
		:addTo(missionSmallWidget)
	local child = Ui()
		:widthpx(25):heightpx(21)
		:decorate({ DecoSurfaceOutlined(newicon, 1, deco.colors.buttonborder, deco.colors.focus, 1) })
		:addTo(missionSmallWidget)
	missionSmallWidget.translucent = true
	missionSmallWidget.visible = false
	child.translucent = true
	child.decorations[1].draw = function(self, screen, widget)
		self.surface = self.surface or self.surfacenormal
		DecoSurface.draw(self, screen, widget)
	end
	
	-- 1 widget to cover up flying icon
	-- when hovering a mech's buffs.
	missionLargeWidget = Ui()
		:widthpx(50):heightpx(42)
		:addTo(uiRoot)
	local child = Ui()
		:widthpx(50):heightpx(42)
		:decorate({ DecoSurfaceOutlined(newicon, 1, deco.colors.buttonborder, deco.colors.buttonborder, 2) })
		:addTo(missionLargeWidget)
	child.translucent = true
	missionLargeWidget.translucent = true
	missionLargeWidget.visible = false

	missionSmallWidget.draw = function(self, screen)
		self.visible = false
		if	icon:wasDrawn()					and
			GetCurrentMission()				and
			not missionSmallWidget.isMasked then
			
			local pawn = GetUIEnabledPawn()
			
			if IsAmphibious(pawn) then
				if not sdlext:isStatusTooltipWindowVisible() then
					self.x = icon.x
					self.y = icon.y
					
					self.children[2].decorations[1].surface = self.children[2].decorations[1].surfacenormal
				elseif sdlext:isStatusTooltipWindowVisible() then
					if Board:IsValid(Board:GetHighlighted()) then
						-- Status window due to mousing over a board unit with CTRL; don't highlight small icon
					else
						self.children[2].decorations[1].surface = self.children[2].decorations[1].surfacehl
					end
				end
				
				self.visible = true
			end
		end
		
		clip(Ui, self, screen)
	end
	
	missionLargeWidget.draw = function(self, screen)
		self.visible = false
		if icon:wasDrawn() and GetCurrentMission() then
			
			local pawn = GetUIEnabledPawn()
			if IsAmphibious(pawn) then
				-- to do: make the large icon visible and clipped while escape menu is up
				if sdlext:isStatusTooltipWindowVisible() and not sdlext:isEscapeMenuWindowVisible() then
					self.x = icon.x
					self.y = icon.y
					
					self.visible = true
				end
			end
		end
		
		Ui.draw(self, screen)
	end
end
local delayOnce = 0
local function onModsLoaded()
	require(path .."libs/menu"):load()
	
	modApi.events.onFrameDrawStart:subscribe(function()
		if delayOnce > 0 then
			delayOnce = delayOnce - 1
		else
			pawnTypeShown = false
		end
	end)
end

local function finalizeInit(self)	
	newicon = sdlext.surface(mod.resourcePath .."img/combat/icons/icon_swimming.png")
	
	sdlext.addUiRootCreatedHook(UiRootCreatedHook)
	
	local original_GetStatusTooltip = GetStatusTooltip
	function GetStatusTooltip(id)
		if	id == "flying"		and
			IsAmphibious(Pawn)	then
			
			return {"Swimming", "Swimming units can only move on Water."}
		end
		return original_GetStatusTooltip(id)
	end
	
	modApi.events.onModsLoaded:subscribe(onModsLoaded)
	
	local oldGetText = GetText
	function GetText(id, ...)
		if Pawn_Texts[id] then
			pawnTypeShown = id
			delayOnce = 2 -- don't know why it takes 2 frames to check things
		end

		return oldGetText(id, ...)
	end
end

local function onModsInitialized()
	local isHighestVersion = true
		and SwimmingIcon.initialized ~= true
		and SwimmingIcon.version == VERSION

	if isHighestVersion then
		SwimmingIcon:finalizeInit()
		SwimmingIcon.initialized = true
	end
end


local isNewerVersion = false
	or SwimmingIcon == nil
	or VERSION > SwimmingIcon.version

if isNewerVersion then
	SwimmingIcon = SwimmingIcon or {}
	SwimmingIcon.version = VERSION
	SwimmingIcon.finalizeInit = finalizeInit

	modApi.events.onModsInitialized:subscribe(onModsInitialized)
end

return SwimmingIcon