
local icon = sdlext.surface("img/combat/icons/icon_flying.png")
local path = mod_loader.mods[modApi.currentMod].scriptPath
local menu = require(path .."libs/menu")
local UiCover = require(path .."ui/cover")
local selected = require(path .."libs/selected")
local highlighted = require(path .."libs/highlighted")
local clip = require(path .."libs/clip")

local this = {
	icon = icon,
	title = Global_Texts.TipTitle_HangarFlying,
	desc = Global_Texts.TipText_HangarFlying,
}

local function isMenu()
	local isMenuDimentions = sdlext.CurrentWindowRect.w == 275 and sdlext.CurrentWindowRect.h == 500
	
	return isMenuDimentions
end

--[[local function isMenu()
	local isMenuDimentions = sdlext.CurrentWindowRect.w == 275 and sdlext.CurrentWindowRect.h == 500
	
	return isMenuDimentions or menu.isOpen()
end]]

local function IsAmphibious(pawn)
	if not pawn then return
		false
	end
	
	local pawnType = pawn:GetType()
	local pawnData = _G[pawnType]
	local flyingPilot = pawn:IsAbility("Flying")
	
	return pawnData and pawnData.tosx_trait_swimming and pawnData.Flying and not flyingPilot
end

local function SetIcon(icon)
	this.icon = sdlext.surface(icon)
end

local function SetTooltip(title, desc)
	this.title = title
	this.desc = desc
end

-- returns the pawnId of pawn
-- currentlty having it's UI drawn.
local function GetUIEnabledPawn()
	local pawn = selected:Get()
	
	if not pawn then
		local highlighted = highlighted:Get()
		
		if highlighted and Board then
			pawn = Board:GetPawn(highlighted)
		end
	end
	
	return pawn
end

local missionSmallWidget
local missionLargeWidget
--local decoColorMissionBlack = sdl.rgb(22, 23, 25)

sdlext.addUiRootCreatedHook(function(screen, uiRoot)
	
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
		--:decorate({ DecoSolid(decoColorMissionBlack) })
		:addTo(uiRoot)
	local mask = UiCover({size = {25, 21}})
		:addTo(missionSmallWidget)
	local child = Ui()
		:widthpx(25):heightpx(21)
		:decorate({ DecoSurfaceOutlined(this.icon, 1, deco.colors.buttonborder, deco.colors.focus, 1) })
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
		--:decorate({ DecoSolid(deco.colors.framebg) })
		:addTo(uiRoot)
	local child = Ui()
		:widthpx(50):heightpx(42)
		:decorate({ DecoSurfaceOutlined(this.icon, 1, deco.colors.buttonborder, deco.colors.buttonborder, 2) })
		:addTo(missionLargeWidget)
	child.translucent = true
	missionLargeWidget.translucent = true
	missionLargeWidget.visible = false
	
	-- TODO:
	-- the tooltip width might depend on unit name, traits, screen resolution,
	-- or maybe other things. For now, it might be a good idea to fine tune
	-- this value for the unit type indended to use this icon
	--
	-- The function will in any case be unable to detect the tooltip
	-- whenever another vanilla UI element is drawn on top of the tooltip. i.e. the main menu.
	local function IsLargeTooltip()
		return sdlext.CurrentWindowRect.w == 296 or sdlext.CurrentWindowRect.w == 556
		-- 296 = single column of statuses
		-- 556 = double column of statuses
	end
	
	missionSmallWidget.draw = function(self, screen)
		self.visible = false
		if	icon:wasDrawn()					and
			GetCurrentMission()				and
			not missionSmallWidget.isMasked then
			
			local pawn = GetUIEnabledPawn()
			if IsAmphibious(pawn) then
				
				if isMenu() then
					
				elseif IsLargeTooltip() then
					self.children[2].decorations[1].surface = self.children[2].decorations[1].surfacehl
				else
					self.x = icon.x
					self.y = icon.y
					
					self.children[2].decorations[1].surface = self.children[2].decorations[1].surfacenormal
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
				
				if IsLargeTooltip() and not isMenu() then
				
					self.x = icon.x
					self.y = icon.y
					
					self.visible = true
				end
			end
		end
		
		Ui.draw(self, screen)
	end
end)

function this:init(mod)
	SetIcon(mod.resourcePath .."img/combat/icons/icon_swimming.png")
	SetTooltip("Swimming", "Swimming units can only move on Water.")
end

return this