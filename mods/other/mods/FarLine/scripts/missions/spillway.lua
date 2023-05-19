
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Spillway = Mission_Infinite:new{
	Name = "Spillways",
	--MapTags = {"tosx_buoy"},
	Objectives = Objective("Open the Spillways", 1),
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = true,
	Environment = "tosx_env_spillway",
	VentLocs = nil,
	VentPawns = nil,
	Open = 0,
	Vents = 2,
}

-- Add CEO dialog
local dialog = require(path .."missions/spillway_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Spillway", dialogTable)
end

function Mission_tosx_Spillway:StartMission()
	Board:SetWeather(1, RAIN_NORMAL, Point(0,0), Point(8,8), -1)
	
	self.VentLocs = {}
	self.VentPawns = {}
	
	local vents = 0
	local quarters = Environment:GetQuarters()
	
	for i,options in pairs(quarters) do
		local curr = options[1]
		if curr.x > 3 and vents < self.Vents then -- Only use the last 2 quarters (vek side, x = 4-7)
			curr = Point(-1,-1)
			while #options > 0 and (not Board:IsValid(curr) or Board:IsBlocked(curr,PATH_GROUND)) do
				curr = random_removal(options)
			end
			self.VentLocs[#self.VentLocs+1] = curr
			Board:SetCustomTile(curr,"tosx_vent_closed.png")
			vents = vents + 1
		end
	end
end

local timer = 0
function Mission_tosx_Spillway:UpdateMission()
	Board:SetWeather(0,RAIN_NORMAL,Point(0,0),Point(8,8),-1)
	if timer > 0 then timer = timer -1 end

	for i = 1, #self.VentLocs do
		local p = self.VentLocs[i]
		if Board:GetCustomTile(p) == "tosx_vent_closed.png" and Board:GetTerrain(p) == TERRAIN_ROAD then
			if Board:IsPawnSpace(p) and Board:GetPawnTeam(p) == TEAM_PLAYER and not Board:IsBusy() then
				Board:SetCustomTile(p, "tosx_vent_open.png")
				self.Open = self.Open + 1
				self.VentPawns = self.VentPawns or {}
				self.VentPawns[p2idx(p)] = Board:GetPawn(p):GetId()
				Game:TriggerSound("/weapons/leap")

				local effect = SkillEffect()
				local chance = math.random()
				if chance > 0.2 and Game:GetTurnCount() > 0 and timer == 0 then
					local cast = Board:GetPawn(p):GetId()
					effect:AddVoice("Mission_tosx_SpillwayOpen", cast)
					timer = 500
				end
				Board:AddEffect(effect)	
	
			else
				Board:MarkSpaceDesc(p,"tosx_env_spillway_tile")
			end
		elseif Board:GetCustomTile(p) == "tosx_vent_open.png" then
			Board:MarkSpaceImage(p,"combat/tile_icon/tosx_icon_env_spillway.png", GL_Color(255,226,88,0.75))
			Board:MarkSpaceDesc(p,"tosx_env_spillway_tile2")
		end
	end
end

function Mission_tosx_Spillway:UpdateObjectives()
	local status = self.Open == self.Vents and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Open the Spillways ("..tostring(self.Open).." / "..tostring(self.Vents).." open)", status, REWARD_REP, 1)
end

function Mission_tosx_Spillway:GetCompletedObjectives()
	local status = self.Open == self.Vents and 1 or 0
	return Objective("Open the Spillways ("..tostring(self.Open).." / "..tostring(self.Vents).." open)", status, 1)
end

function Mission_tosx_Spillway:GetCompletedStatus()
	if self.Open < self.Vents then
		return "Failure"
	else
		return "Success"
	end
end

---
modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_spillway.png", mod.resourcePath .."img/combat/tile_icon/icon_env_spillway.png")
Location["combat/tile_icon/tosx_icon_env_spillway.png"] = Point(-27,2) -- Needed for it to appear on tiles
	
tosx_env_spillway = Environment:new{
	Name = "Spillways",
	NameTile = "Spillway",
	Text = "Move Mechs onto Spillways to open them. Open Spillways flood at the start of each turn.",
	Decription = "Moving a friendly unit here will open this Spillway.",
	Decription2 = "This Spillway will become a Water tile.",
	StratText = "SPILLWAYS",
	CombatIcon = "combat/tile_icon/tosx_icon_env_spillway.png",
	CombatName = "SPILLWAYS",
}
	
TILE_TOOLTIPS.tosx_env_spillway_tile = {tosx_env_spillway.NameTile, tosx_env_spillway.Decription}
TILE_TOOLTIPS.tosx_env_spillway_tile2 = {tosx_env_spillway.NameTile, tosx_env_spillway.Decription2}
Global_Texts["TipTitle_".."tosx_env_spillway"] = tosx_env_spillway.Name
Global_Texts["TipText_".."tosx_env_spillway"] = tosx_env_spillway.Text

function tosx_env_spillway:Plan()
	return false
end

function tosx_env_spillway:IsEffect()
	return true
end

function tosx_env_spillway:ApplyEffect()
	local mission = GetCurrentMission()
	if not mission or not mission.VentLocs then return end
	
	local effect = SkillEffect()
	effect.iOwner = ENV_EFFECT
	
	for i = 1, #mission.VentLocs do
		local p = mission.VentLocs[i]
		if Board:GetCustomTile(p) == "tosx_vent_open.png" and Board:GetTerrain(p) == TERRAIN_ROAD then
			effect:AddBoardShake(1)
			
			local damage = SpaceDamage(p)
			damage.iTerrain = TERRAIN_WATER
			damage.sSound = "/props/water_splash"
			damage.sAnimation = "Splash"
			damage.sScript = "Board:SetCustomTile("..p:GetString()..", '')"
	
			effect:AddDamage(damage)
			effect:AddBounce(p,-3)
			effect:AddDelay(0.7)
		end
	end
	mission.VentPawns = {}
    Board:AddEffect(effect)	
    
    return false
end

---

local function UndoMoveHook(mission, pawn, undonePosition)
	if not mission or not mission.ID == "Mission_tosx_Spillway" then return end
	if Board:GetCustomTile(undonePosition) == "tosx_vent_open.png" then
		if mission.VentPawns and mission.VentPawns[p2idx(undonePosition)] then
			if pawn:GetId() == mission.VentPawns[p2idx(undonePosition)] then
				Board:SetCustomTile(undonePosition, "tosx_vent_closed.png")
				mission.Open = mission.Open - 1
				mission.VentPawns[p2idx(undonePosition)] = nil
			end
		end
	end
end

local function onModsLoaded()
	modapiext:addPawnUndoMoveHook(UndoMoveHook)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)