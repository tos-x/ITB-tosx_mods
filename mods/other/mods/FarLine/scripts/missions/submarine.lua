
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")
local switch = require(path .."libs/switch")
require(mod.scriptPath.."libs/pawnKilledLoc")

local objInMission1 = switch{
	[0] = function()
		Game:AddObjective("Defend the Submarine", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the Submarine", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Defend the Submarine", 1):Failed() end,
	[1] = function() return Objective("Defend the Submarine", 1) end,
	default = function() return nil end,
}

Mission_tosx_Submarine = Mission_Infinite:new{
	Name = "Submarine",
	MapTags = {"tosx_smallisland"},
	Objectives = { objAfterMission1:case(1), Objective("Drown 4 Enemies", 1) },
	BonusPool = copy_table(missionTemplates.bonusNoMercyOrDebris),
	UseBonus = false,
	SubId = -1,
	Drown = 0,
	SpawnMod = 1,
}

-- Add CEO dialog
local dialog = require(path .."missions/submarine_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Submarine", dialogTable)
end

function Mission_tosx_Submarine:StartMission()
	local submarine = PAWN_FACTORY:CreatePawn("tosx_mission_sub1")
	self.SubId = submarine:GetId()
	
	local choices = {}	
	for x = 0, 5 do
		for y = 1, 6 do
			local p = Point(x,y)
			if not Board:IsBlocked(p,PATH_PROJECTILE) and Board:GetTerrain(p) == TERRAIN_WATER then
				choices[#choices+1] = p
			end
		end
	end
	if #choices == 0 then 
		LOG("ERROR NO VALID SUB SPACE") 
		return
	end
	local choice = random_removal(choices)
	Board:AddPawn(submarine, choice)	
end

function Mission_tosx_Submarine:UpdateMission()
	if self:IsSubAlive() then
		local pawn = Board:GetPawn(self.SubId)
		if pawn then
			local point = pawn:GetSpace()
			if Board:IsValid(point) and Board:GetTerrain(point) ~= TERRAIN_WATER then
				if not pawn:IsFrozen() or Board:GetTerrain(point) ~= TERRAIN_ICE then
					Board:RemovePawn(pawn)
					Game:TriggerSound("/impact/generic/explosion")
					Board:AddAnimation(point, "tosx_sub1dg", ANIM_NO_DELAY)
					Board:AddAnimation(point, "ExploArt2", ANIM_NO_DELAY)
				end
			end
		end
	end
end

function Mission_tosx_Submarine:IsSubAlive()
	if Board:GetPawn(self.SubId) ~= nil and Board:IsPawnAlive(self.SubId) then
		return 1
	end
	return 0
end

function Mission_tosx_Submarine:UpdateObjectives()
	objInMission1:case(self:IsSubAlive())
	local status = self.Drown >= 4 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Drown 4 Enemies\n("..tostring(self.Drown).."/4 drowned)", status, REWARD_REP, 1)
end

function Mission_tosx_Submarine:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(self:IsSubAlive())
	
	local status = 0
	if self.Drown >= 4 then status = 1 end
	ret[2] = Objective("Drown 4 Enemies", status, 1)
	
	return ret
end

local submove = 3
tosx_mission_sub1 = Pawn:new{
	Name = "Submarine",
	Health = 1,
	Image = "tosx_sub1",
	MoveSpeed = submove,
	SkillList = { "tosx_mission_subAtk" },
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
Pawn_Texts.tosx_mission_sub1 = "Submarine" -- Needed to better detect when pawn type is highlighted from unit menu

tosx_mission_subAtk = LineArtillery:new{
	Name = "Searaven Missile", 
	Description = "Damage a tile and push surrounding tiles.",
	Range = RANGE_ARTILLERY,
	Icon = "weapons/tosx_submissile.png",
	UpShot = "effects/tosx_shotup_submissile.png",
	Damage = 1,
	Explosion = "ExploArt1",
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	Class = "Unique",
	TipImage = {
		--Water = Point(2,1),
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "tosx_mission_sub1",
	}	
}

function tosx_mission_subAtk:GetTargetArea(p1)
	-- Easier way for TipImage to show lots of water
	if Board:IsTipImage() and Board:GetTerrain(Point(2,3)) ~= TERRAIN_WATER then
		for x = 0,5 do
			for y = 2,5 do
				Board:SetTerrain(Point(x,y), TERRAIN_WATER)
			end
		end
	end
	
	return LineArtillery:GetTargetArea(p1)
end

function tosx_mission_subAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = self.Explosion
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, self.UpShot)
	
	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],0,dir)
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end

	return ret
end

-------- Swimming movement override (sub movement) ------------
tosx_sub1_swim_skill = {}

local function isValidTile(p, moved)
	local blocked = Board:IsBlocked(p, PATH_PROJECTILE)
	if blocked and Board:IsPawnSpace(p) and Board:GetPawn(p):GetTeam() == TEAM_PLAYER then
		blocked = false
	end	
	
    return not blocked and Board:IsTerrain(p, TERRAIN_WATER) and  moved < submove + 1
end

function tosx_sub1_swim_skill:GetTargetArea(p1)
    local ret = PointList()
	local reach = extract_table(general_DiamondTarget(p1, submove))
    for _, p in pairs(reach) do
		if not Board:IsBlocked(p, PATH_PROJECTILE) and Board:IsTerrain(p, TERRAIN_WATER) then
			ret:push_back(p)
		end
	end
    
    return ret
end

function tosx_sub1_swim_skill:GetSkillEffect(p1, p2)
    local ret = SkillEffect()
	local pawnId = Pawn:GetId()

	-- just preview move
	ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", pawnId))
	local leap = PointList()
	leap:push_back(p1)
	leap:push_back(p2)
	--ret:AddMove(Board:GetPath(p1, p2, Pawn:GetPathProf()), NO_DELAY)
	--ret:AddMove(leap, NO_DELAY)
	ret:AddLeap(leap,NO_DELAY) 
	--ret:AddTeleport(p1,p2,NO_DELAY) 
	ret.effect:back().bHide = true 
	ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawnId, p1:GetString()))

	-- move pawn (use a board anim instead! setcustomanim isn't great)
	-- ret:AddSound("/props/water_splash")
	-- ret:AddScript(string.format([[Board:GetPawn(%s):SetCustomAnim("%s")]], pawnId, "tosx_sub1e"))
	-- ret:AddDelay(0.5)
	-- ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", pawnId))
	-- ret:AddDelay(0.05)
	-- ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawnId, p2:GetString()))
	-- ret:AddScript(string.format([[Board:GetPawn(%s):SetCustomAnim("%s")]], pawnId, "tosx_sub1e2"))
	-- ret:AddDelay(0.5)
	-- ret:AddScript(string.format([[Board:GetPawn(%s):SetCustomAnim("%s")]], pawnId, "tosx_sub1a"))
	
	-- move pawn
	ret:AddSound("/props/water_splash")
	ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", pawnId))
	ret:AddScript(string.format([[Board:AddAnimation(%s,"%s",NO_DELAY)]], p1:GetString(), "tosx_sub1e"))
	ret:AddDelay(0.55)
	ret:AddScript(string.format([[Board:AddAnimation(%s,"%s",NO_DELAY)]], p2:GetString(), "tosx_sub1e2"))
	ret:AddDelay(0.99)
	ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawnId, p2:GetString()))
	
	return ret
end

---------------------

require(mod.scriptPath.. "libs/swimmingIcon")

modApi:appendAsset("img/units/mission/tosx_sub1.png", mod.resourcePath .."img/units/mission/sub1.png")
modApi:appendAsset("img/units/mission/tosx_sub1_ns.png", mod.resourcePath .."img/units/mission/sub1_ns.png")
modApi:appendAsset("img/units/mission/tosx_sub1_w.png", mod.resourcePath .."img/units/mission/sub1_w.png")
modApi:appendAsset("img/units/mission/tosx_sub1_e.png", mod.resourcePath .."img/units/mission/sub1_e.png")
modApi:appendAsset("img/units/mission/tosx_sub1_e2.png", mod.resourcePath .."img/units/mission/sub1_e2.png")
modApi:appendAsset("img/units/mission/tosx_sub1_dg.png", mod.resourcePath .."img/units/mission/sub1_dg.png")

modApi:appendAsset("img/weapons/tosx_submissile.png", mod.resourcePath.. "img/weapons/tosx_submissile.png")
modApi:appendAsset("img/effects/tosx_shotup_submissile.png", mod.resourcePath.. "img/effects/tosx_shotup_submissile.png")

local a = ANIMS
a.tosx_sub1 = a.BaseUnit:new{Image = "units/mission/tosx_sub1.png", PosX = -19, PosY = 11}
a.tosx_sub1w = a.tosx_sub1:new{Image = "units/mission/tosx_sub1_w.png", NumFrames = 4, Frames = {0,1}, Time = 0.9 }
a.tosx_sub1a = a.tosx_sub1w:new{}
a.tosx_sub1_ns = a.tosx_sub1:new{Image = "units/mission/tosx_sub1_ns.png", PosX = -17, PosY = 13}
a.tosx_sub1d = a.tosx_sub1:new{Image = "units/mission/tosx_sub1_e.png", NumFrames = 9, Time = 0.11, Loop = false}
a.tosx_sub1e = a.tosx_sub1:new{Image = "units/mission/tosx_sub1_e.png", NumFrames = 9, Time = 0.11, Frames = {0,2,4,5,6,7,8}, Loop = false}
a.tosx_sub1e2 = a.tosx_sub1e:new{Image = "units/mission/tosx_sub1_e2.png", Frames = {8,7,6,5,4,3,2,1,0}}
a.tosx_sub1dg = a.tosx_sub1:new{Image = "units/mission/tosx_sub1_dg.png", PosX = -21, PosY = 6, NumFrames = 1, Time = 0.4, Loop = false}

-------- Swimming movement override ------------
local originalMove = {
	GetDescription = Move.GetDescription,
	GetTargetArea = Move.GetTargetArea,
	GetSkillEffect = Move.GetSkillEffect,
}

function Move:GetTargetArea(p1)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_sub1" then
		moveSkill = tosx_sub1_swim_skill
	end

	if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
		return moveSkill:GetTargetArea(p1)
	end

	return originalMove.GetTargetArea(self, p1)
end

function Move:GetSkillEffect(p1, p2)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_sub1" then
		moveSkill = tosx_sub1_swim_skill
	end
	
	if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
		return moveSkill:GetSkillEffect(p1, p2)
	end
	
	return originalMove.GetSkillEffect(self, p1, p2)
end

-----------------------

local enemies = {}
local function onPawnKilledLoc(mission, id, point)
	if not mission or mission.ID ~= "Mission_tosx_Submarine" then return end
	if next(enemies,nil) and enemies[id] and Board:GetTerrain(point) == TERRAIN_WATER then
		--LOG("drown+")
		enemies[id] = nil
		mission.Drown = mission.Drown + 1
	end
end

local function onPawnKilled(mission, pawn)
	if not mission or mission.ID ~= "Mission_tosx_Submarine" then return end
	-- Pawns over water don't play death animations on death; do it manually. There will also be a splash from the unit dying over water
	if pawn:GetType() == "tosx_mission_sub1" then
		local point = pawn:GetSpace()
		if Board:GetTerrain(point) == TERRAIN_WATER then
			Game:TriggerSound("/impact/generic/explosion")
			Board:AddAnimation(point, "tosx_sub1d", ANIM_NO_DELAY)
		end
	elseif pawn:GetTeam() == TEAM_ENEMY then
		if PawnKilledLoc and PawnKilledLoc.Wait then
			--LOG("wait on id ",pawn:GetId())
			enemies[pawn:GetId()] = true
			return
		end
		local point = pawn:GetSpace()
		if Board:GetTerrain(point) == TERRAIN_WATER then
			--LOG("drown vanilla")
			mission.Drown = mission.Drown + 1
		end
	end
end

local function onModsLoaded()
	modapiext:addPawnKilledHook(onPawnKilled)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)
PawnKilledLoc.onFinalSpace:subscribe(onPawnKilledLoc)