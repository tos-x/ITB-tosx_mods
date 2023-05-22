
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local astar = require(path .."libs/astar")
local worldConstants = require(path .."libs/worldConstants")
local utils = require(path .."libs/utils")
require(mod.scriptPath.. "libs/swimmingIcon")

-- returns number of pawns alive
-- in a list of pawn id's.
local function countAlive(list)
	assert(type(list) == 'table', "table ".. tostring(list) .." not a table")
	local ret = 0
	for _, id in ipairs(list) do
		if type(id) == 'number' then
			ret = ret + (Board:IsPawnAlive(id) and 1 or 0)
		else
			error("variable of type ".. type(id) .." is not a number")
		end
	end
	
	return ret
end

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Ships\n(0/2 undamaged)", OBJ_FAILED, REWARD_REP, 2)
	end,
	[1] = function()
		Game:AddObjective("Defend the Ships\n(1/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	[2] = function()
		Game:AddObjective("Defend the Ships\n(2/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Ships", 2):Failed() end,
	[1] = function() return Objective("Defend the Ships (1 destroyed)", 1, 2) end,
	[2] = function() return Objective("Defend the Ships", 2) end,
	default = function() return nil end,
}

Mission_tosx_Ocean = Mission_Infinite:new{
	Name = "Open Ocean",
	Objectives = objAfterMission:case(2),
	MapTags = {"tosx_ocean"},
	Criticals = nil,
	BonusPool = {},
	UseBonus = false,
	SpawnStart = 0,
	SpawnStart_Easy = 0,
	SpawnStart_Unfair = 0,
	VekCount = 3,
	Fliers = nil,
	GlobalSpawnMod = -10,
}

-- Add CEO dialog
local dialog = require(path .."missions/ocean_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Ocean", dialogTable)
end

-- During the mission start, override default start barks with custom
local oldTriggerVoice = TriggerVoiceEvent
function TriggerVoiceEvent(event, custom_odds)
	local mission = GetCurrentMission()
	if mission and
	mission.ID == "Mission_tosx_Ocean" and
	event.id == "MissionStart" then
		if not mission.tosx_ocean_text then
			event.id = "Mission_tosx_OceanStart"
			custom_odds = 100
			mission.tosx_ocean_text = true
		else
			custom_odds = 0
		end
	end
	oldTriggerVoice(event, custom_odds)
end

function Mission_tosx_Ocean:StartMission()
	self.Criticals = {}
	self.Fliers = {}
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_rigship")
	table.insert(self.Criticals, pawn:GetId())	
	Board:AddPawn(pawn)
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_rigship")
	table.insert(self.Criticals, pawn:GetId())	
	Board:AddPawn(pawn)
	
	local hornet = false
	local spawnlist = shallow_copy(GAME:GetSpawnList(Spawner.spawn_island))
	--LOG("start, default spawn list: ",save_table(spawnlist))
	for _, v in pairs(spawnlist) do
		if _G[v.."1"].Flying then
			self.Fliers[#self.Fliers + 1] = v
			if v == "Hornet" then hornet = true end
		end
	end
	if not hornet then
		self.Fliers[#self.Fliers + 1] = "Hornet"
	end
	--LOG("start, final spawn list: ",save_table(self.Fliers))

	local choices = {}	
	for x = 4, 7 do
		for y = 1, 6 do
			if not Board:IsBlocked(Point(x,y),PATH_PROJECTILE) then
				choices[#choices+1] = Point(x,y)
			end
		end
	end	
	
	if GetDifficulty () == DIFF_UNFAIR then
		self.VekCount = self.VekCount + 1
	end
	
	for i = 1, self.VekCount do	
		if #choices == 0 then 
			return 
			end
		
		local pawn = nil
		--LOG("next pawn, starting flier: ",save_table(self.Fliers))
		pawn = self:NextPawn(self.Fliers)
		local choice = random_removal(choices)
		Board:AddPawn(pawn,choice)
	end
end

function Mission_tosx_Ocean:UpdateMission()
	if self.Criticals then
		for i = 1,2 do
			local pawn = Board:GetPawn(self.Criticals[i])
			
			if pawn and not pawn:IsDead() then
				local point = pawn:GetSpace()
				if Board:IsValid(point) and Board:GetTerrain(point) ~= TERRAIN_WATER then
					if not pawn:IsFrozen() or Board:GetTerrain(point) ~= TERRAIN_ICE then
						Board:RemovePawn(pawn)
						Game:TriggerSound("/impact/generic/explosion")
						Board:AddAnimation(point, "tosx_rigshipdg", ANIM_NO_DELAY)
						Board:AddAnimation(point, "ExploArt2", ANIM_NO_DELAY)
					end
				end
			end
		end
	end
end

function Mission_tosx_Ocean:NextTurn()
	if Game:GetTeamTurn() ~= TEAM_ENEMY or Game:GetTurnCount() == 0 then return end
	local choices = {}	
	for x = 4, 7 do
		for y = 1, 6 do
			if not Board:IsBlocked(Point(x,y),PATH_PROJECTILE) then
				choices[#choices+1] = Point(x,y)
			end
		end
	end	
	
	local count = 3
	local alive = #extract_table(Board:GetPawns(TEAM_ENEMY_MAJOR))
	if alive > 0 then count = 2 end
	if alive > 2 then count = 1 end
	if alive > 5 then count = 0 end
	if GetDifficulty () == DIFF_EASY and alive == 0 then
		count = 2
	end	
	if GetDifficulty () == DIFF_UNFAIR and alive == 1 then
		count = 3
	end	
	if count < 1 or #choices == 0 then return end
	
	for i = 1, count do
		local pawn = nil
		--LOG("next pawn, turn flier: ",save_table(self.Fliers))
		pawn = self:NextPawn(self.Fliers)
		local choice = random_removal(choices)
		Board:AddPawn(pawn,choice)
		
		local vacant = utils.getSpace(function(p)
			return not Board:IsPawnSpace(p) and p ~= choice and Board:GetTerrain(p) == TERRAIN_WATER
		end)

		pawn = vacant and pawn or nil

		if pawn then
			pawn:SetSpace(vacant)
			pawn:SetInvisible(true)
			pawn:SetTeam(TEAM_NONE)
			local fx = SkillEffect()
			local pawnId = pawn:GetId()

			local leap = PointList()
			leap:push_back(vacant)
			leap:push_back(choice)

			worldConstants:setHeight(fx, 50)
			fx:AddLeap(leap, NO_DELAY)
			worldConstants:resetHeight(fx)

			fx:AddDelay(0.25)
			fx:AddScript(string.format("Board:GetPawn(%s):SetInvisible(false)", pawnId))
			fx:AddScript(string.format("Board:GetPawn(%s):SetTeam(TEAM_ENEMY)", pawnId))
			--fx:AddDelay(0.25)
			Board:AddEffect(fx)
		end
	end
end

function Mission_tosx_Ocean:UpdateSpawning()
end

function Mission_tosx_Ocean:UpdateObjectives()	
	objInMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Ocean:GetCompletedObjectives()
	return objAfterMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Ocean:GetCompletedStatus()
	if countAlive(self.Criticals) > 1 then
		return "Success"
	elseif countAlive(self.Criticals) == 1 then
		return "OneShip"
	else
		return "Failure"
	end
end

local rigmove = 4

tosx_mission_rigship = Pawn:new{
	Name = "Construction Ship",
	Health = 1,
	Image = "tosx_rigship",
	MoveSpeed = rigmove,
	SkillList = { "tosx_mission_rigshipAtk" },
	SoundLocation = "/support/train",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true,
	Mission = true,
	Pushable = false,
	IgnoreFire = true,
	Flying = true,
	tosx_trait_swimming = true,
}
Pawn_Texts.tosx_mission_rigship = "Construction Ship" -- Needed to better detect when pawn type is highlighted from unit menu

tosx_mission_rigshipAtk = Skill:new{
	Name = "Construction Scaffold",
	Description = "Create 3 Ground tiles on nearby Water.",
	Icon = "weapons/tosx_rigmaker.png",
	Class = "Unique",
	LaunchSound = "/weapons/leap",
	TipImage = {
		--Water = Point(2,1),
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "tosx_mission_rigship",
	},
}
	
function tosx_mission_rigshipAtk:GetTargetArea(p1)
	-- Easier way for TipImage to show lots of water
	if Board:IsTipImage() and Board:GetTerrain(Point(2,3)) ~= TERRAIN_WATER then
		for x = 0,5 do
			for y = 0,5 do
				Board:SetTerrain(Point(x,y), TERRAIN_WATER)
			end
		end
	end

	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		if self:Create(curr) then
			ret:push_back(curr)
		end
	end	
	return ret
end

function tosx_mission_rigshipAtk:Create(p)
	if Board:GetTerrain(p) ~= TERRAIN_WATER then return false end
	if Board:IsPawnSpace(p) then
		if _G[Board:GetPawn(p):GetType()].tosx_trait_swimming then
			return false
		end
	end
	return true
end
	
function tosx_mission_rigshipAtk:GetSkillEffect(p1, p2)		
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local bounce = 5
	
	local d0 = SpaceDamage(p2)
	d0.sAnimation = "Splash"
	ret:AddDamage(d0)
	ret:AddBounce(p2, bounce*3)
	ret:AddDelay(0.1)
	for i = -1, 1, 2 do
		local p = p2 + DIR_VECTORS[(direction + i)% 4]
		ret:AddBounce(p, bounce*3)
		d0.loc = p
		ret:AddDamage(d0)
	end
	ret:AddDelay(0.2)
	
	ret:AddSound("/props/water/splash")
	
	local damage = SpaceDamage(p2)
	if self:Create(p2) then
		damage.iTerrain = TERRAIN_ROAD
		damage.sScript = [[Board:SetCustomTile(]]..p2:GetString()..[[,"tosx_rig_1.png")]]
		--damage.sAnimation = "Splash"
		damage.sImageMark = "combat/icons/tosx_rig_icon_glow.png"
	else
		damage.sImageMark = "combat/icons/tosx_rig_icon_miss_glow.png"
	end	
	ret:AddDamage(damage)
	--ret:AddBounce(p2, bounce)
	
	ret:AddDelay(0.1)
	
	for i = -1, 1, 2 do
		local p = p2 + DIR_VECTORS[(direction + i)% 4]
		local damage2 = SpaceDamage(p)
		if self:Create(p) then
			damage2.iTerrain = TERRAIN_ROAD
			damage2.sScript = [[Board:SetCustomTile(]]..p:GetString()..[[,"tosx_rig_1.png")]]
			--damage2.sAnimation = "Splash"
			damage2.sImageMark = "combat/icons/tosx_rig_icon_glow.png"
		else
			damage2.sImageMark = "combat/icons/tosx_rig_icon_miss_glow.png"
		end
		ret:AddDamage(damage2)
		--ret:AddBounce(p, bounce)
	end

	return ret
end

-------- Swimming movement override ------------
tosx_rigship_swim_skill = {}

local function isValidTile(p, moved)
	local blocked = Board:IsBlocked(p, PATH_PROJECTILE)
	if blocked and Board:IsPawnSpace(p) and Board:GetPawn(p):GetTeam() == TEAM_PLAYER then
		blocked = false
	end	
	
    return not blocked and Board:IsTerrain(p, TERRAIN_WATER) and  moved < rigmove + 1
end

function tosx_rigship_swim_skill:GetTargetArea(p1)
    local ret = PointList()
    
    local traversable = astar.GetTraversable(p1, isValidTile)
    
    for _, node in pairs(traversable) do
		if not Board:IsBlocked(node.loc, PATH_PROJECTILE) then
			ret:push_back(node.loc)
		end
    end
    
    return ret
end

function tosx_rigship_swim_skill:GetSkillEffect(p1, p2)
    local ret = SkillEffect()
	local path = astar.GetPath(p1, p2, isValidTile)

	local plist = PointList()
	for i = 1, #path do
		plist:push_back(path[i])
	end
	
	ret:AddMove(plist, FULL_DELAY)
	return ret
end

---------------------

modApi:appendAsset("img/units/mission/tosx_rigship.png", mod.resourcePath .."img/units/mission/rigship.png")
modApi:appendAsset("img/units/mission/tosx_rigship_ns.png", mod.resourcePath .."img/units/mission/rigship_ns.png")
modApi:appendAsset("img/units/mission/tosx_rigship_w.png", mod.resourcePath .."img/units/mission/rigship_w.png")
modApi:appendAsset("img/units/mission/tosx_rigship_d.png", mod.resourcePath .."img/units/mission/rigship_d.png")
modApi:appendAsset("img/units/mission/tosx_rigship_dg.png", mod.resourcePath .."img/units/mission/rigship_dg.png")

modApi:appendAsset("img/weapons/tosx_rigmaker.png", mod.resourcePath.. "img/weapons/tosx_rigmaker.png")

modApi:appendAsset("img/combat/icons/tosx_rig_icon_glow.png",mod.resourcePath.."img/combat/icons/tosx_rig_icon_glow.png")
	Location["combat/icons/tosx_rig_icon_glow.png"] = Point(-13,22)
modApi:appendAsset("img/combat/icons/tosx_rig_icon_miss_glow.png",mod.resourcePath.."img/combat/icons/tosx_rig_icon_miss_glow.png")
	Location["combat/icons/tosx_rig_icon_miss_glow.png"] = Point(-13,22)

local a = ANIMS
a.tosx_rigship = a.BaseUnit:new{Image = "units/mission/tosx_rigship.png", PosX = -18, PosY = 12}
a.tosx_rigshipw = a.tosx_rigship:new{Image = "units/mission/tosx_rigship_w.png", NumFrames = 4, Time = 0.5 }
a.tosx_rigshipa = a.tosx_rigshipw:new{}
a.tosx_rigship_ns = a.tosx_rigship:new{Image = "units/mission/tosx_rigship_ns.png", PosX = -17, PosY = 13}
a.tosx_rigshipd = a.tosx_rigship:new{Image = "units/mission/tosx_rigship_d.png", PosX = -17, PosY = 15, NumFrames = 9, Time = 0.14, Loop = false}
a.tosx_rigshipdg = a.tosx_rigship:new{Image = "units/mission/tosx_rigship_dg.png", PosX = -21, PosY = 6, NumFrames = 1, Time = 0.4, Loop = false}

-------- Swimming movement override ------------
local originalMove = {
	GetDescription = Move.GetDescription,
	GetTargetArea = Move.GetTargetArea,
	GetSkillEffect = Move.GetSkillEffect,
}

function Move:GetTargetArea(p1)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_rigship" then
		moveSkill = tosx_rigship_swim_skill
	end

	if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
		return moveSkill:GetTargetArea(p1)
	end

	return originalMove.GetTargetArea(self, p1)
end

function Move:GetSkillEffect(p1, p2)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_rigship" then
		moveSkill = tosx_rigship_swim_skill
	end
	
	if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
		return moveSkill:GetSkillEffect(p1, p2)
	end
	
	return originalMove.GetSkillEffect(self, p1, p2)
end


local function onModsLoaded()
	modapiext:addPawnKilledHook(function(mission, pawn)
		-- Pawns over water don't play death animations on death; do it manually. There will also be a splash from the unit dying over water
		if pawn:GetType() == "tosx_mission_rigship" then
			local point = pawn:GetSpace()
			if Board:GetTerrain(point) == TERRAIN_WATER then
				Game:TriggerSound("/impact/generic/explosion")
				Board:AddAnimation(point, "tosx_rigshipd", ANIM_NO_DELAY)
			end
		end
	end)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)