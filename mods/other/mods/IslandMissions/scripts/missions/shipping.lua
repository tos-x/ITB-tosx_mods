-- mission Mission_tosx_Shipping

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Shipping"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")
local astar = require(path .."libs/astar")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

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

Mission_tosx_Shipping = Mission_Infinite:new{
--At this point, self is the table defining the whole mission type
	Name = "Clear the Channel",
	Objectives = { Objective("Defend the Battleship",1), Objective("Clear the Ice", 1),  }, 
	MapTags = {"tosx_shipping"},
	Criticals = nil,
	TurnLimit = 4,
	BonusPool = {},
	IceAmount = 2,
	UseBonus = false,
}

function Mission_tosx_Shipping:StartMission()
	self.Criticals = {}
	local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_battleship")
	table.insert(self.Criticals, pawn:GetId())
	Board:AddPawn(pawn, Board:GetZone("tosx_shipping_zone"):index(1))
	pawn:SetTeam(TEAM_PLAYER)
	
	local icetiles = self:GetTerrainList(TERRAIN_ICE)
	if icetiles then
		for i = 1, #icetiles do
			if #icetiles == 0 then
				break
			end
			if i <= self.IceAmount then
				Board:DamageSpace(random_removal(icetiles),1)
			else
				Board:SetTerrain(random_removal(icetiles),TERRAIN_WATER)
			end
		end
	end
end

function Mission_tosx_Shipping:UpdateMission()
	if self.Criticals then
		local pawn = Board:GetPawn(self.Criticals[1])
		
		if pawn and not pawn:IsDead() then
			local point = pawn:GetSpace()
			if Board:IsValid(point) and Board:GetTerrain(point) ~= TERRAIN_WATER then
				if not pawn:IsFrozen() or Board:GetTerrain(point) ~= TERRAIN_ICE then
					Board:RemovePawn(pawn)
					Game:TriggerSound("/impact/generic/explosion")
					Board:AddAnimation(point, "tosx_battleshipdg", ANIM_NO_DELAY)
					Board:AddAnimation(point, "ExploArt2", ANIM_NO_DELAY)
				end
			end
		end
	end
end

function Mission_tosx_Shipping:UpdateObjectives()	
	if countAlive(self.Criticals) == 0 then
		Game:AddObjective("Defend the Battleship", OBJ_FAILED, REWARD_REP, 1)
	else
		Game:AddObjective("Defend the Battleship", OBJ_STANDARD, REWARD_REP, 1)	
	end
	
	local icetiles = self:GetTerrainList(TERRAIN_ICE)
	if #icetiles >0 then
		Game:AddObjective("Clear the Ice", OBJ_STANDARD, REWARD_REP, 1)
	else
		Game:AddObjective("Clear the Ice", OBJ_COMPLETE, REWARD_REP, 1)
	end
end

function Mission_tosx_Shipping:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	
	if countAlive(self.Criticals) == 0 then
		ret[1] = ret[1]:Failed()
	end
	
	local icetiles = self:GetTerrainList(TERRAIN_ICE)
	if #icetiles > 0 then
		ret[2] = ret[2]:Failed()
	end
	
	return ret
end

function Mission_tosx_Shipping:GetCompletedStatus()
	local icetiles = self:GetTerrainList(TERRAIN_ICE)
	if countAlive(self.Criticals) > 0 and #icetiles == 0 then
		return "Success"
	elseif countAlive(self.Criticals) > 0 and #icetiles > 0 then
		return "StillIce"
	elseif countAlive(self.Criticals) == 0 and #icetiles == 0 then
		return "NoShip"
	else
		return "Failure"
	end
end

function Mission_tosx_Shipping:UpdateSpawning()
	local count = self:GetSpawnCount()
	for i = 1, count do 
		if i == 1 then -- Make first spawn a hornet each turn
			Board:SpawnPawn(self:NextPawn( { "Hornet" } ), "")
		else
			Board:SpawnPawn(self:NextPawn(),"")
		end
	end
end

tosx_mission_battleship = Pawn:new{
	Name = "Ancient Battleship",
	Health = 1,
	Image = "tosx_battleship",
	MoveSpeed = 3,
	SkillList = { "tosx_mission_battleshipAtk" },
	SoundLocation = "/support/train",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true,
	Mission = true,
	Pushable = false,
	--Massive = true,
	Flying = true,
	tosx_trait_swimming = true,
}
Pawn_Texts.tosx_mission_battleship = "Ancient Battleship" -- Needed to better detect when pawn type is highlighted from unit menu

tosx_mission_battleshipAtk = ArtilleryDefault:new{
	Name = "Ancient Cannons",
	Description = "Powerful artillery strike, damaging a single tile.",
	Icon = "weapons/tosx_battleship_gun.png",
	Damage = 2,
	ArtillerySize = 8,
	Class = "Unique",
	UpShot = "effects/tosx_shotup_battleship.png",
	LaunchSound = "/weapons/dual_shot",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Water = Point(0,3),
		Water = Point(1,3),
		Water = Point(2,3),
		Water = Point(3,3),
		Water = Point(4,3),
		Water = Point(5,3),
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_mission_battleship",
	},
}
	
function tosx_mission_battleshipAtk:GetTargetArea(p1)
	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(p1 + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end			
			ret:push_back(curr)
		end
	end	
	return ret
end

function tosx_mission_battleshipAtk:GetSkillEffect(p1, p2)		
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "ExploArt2"
	
	ret:AddArtillery(damage, self.UpShot)
	ret:AddBounce(p2, 3)

	return ret
end

-------- Swimming movement override ------------
tosx_battleship_swim_skill = {}

local function isValidTile(p, moved)
	local blocked = Board:IsBlocked(p, PATH_PROJECTILE)
	if blocked and Board:IsPawnSpace(p) and Board:GetPawn(p):GetTeam() == TEAM_PLAYER then
		blocked = false
	end	
	
    return not blocked and Board:IsTerrain(p, TERRAIN_WATER) and  moved < 4
end

function tosx_battleship_swim_skill:GetTargetArea(p1)
    local ret = PointList()
    
    local traversable = astar.GetTraversable(p1, isValidTile)
    
    for _, node in pairs(traversable) do
		if not Board:IsBlocked(node.loc, PATH_PROJECTILE) then
			ret:push_back(node.loc)
		end
    end
    
    return ret
end

function tosx_battleship_swim_skill:GetSkillEffect(p1, p2)
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







function this:init(mod)	
	require(mod.scriptPath.. "libs/swimmingIcon")
	
	modApi:appendAsset("img/units/mission/tosx_battleship.png", mod.resourcePath .."img/units/mission/battleship.png")
	modApi:appendAsset("img/units/mission/tosx_battleship_ns.png", mod.resourcePath .."img/units/mission/battleship_ns.png")
	modApi:appendAsset("img/units/mission/tosx_battleship_w.png", mod.resourcePath .."img/units/mission/battleship_w.png")
	modApi:appendAsset("img/units/mission/tosx_battleship_d.png", mod.resourcePath .."img/units/mission/battleship_d.png")
	modApi:appendAsset("img/units/mission/tosx_battleship_dg.png", mod.resourcePath .."img/units/mission/battleship_dg.png")
	
	modApi:appendAsset("img/effects/tosx_shotup_battleship.png", mod.resourcePath .."img/effects/shotup_battleship.png")
	modApi:appendAsset("img/weapons/tosx_battleship_gun.png", mod.resourcePath.. "img/weapons/tosx_battleship_gun.png")

	
	local a = ANIMS
	a.tosx_battleship = a.BaseUnit:new{Image = "units/mission/tosx_battleship.png", PosX = -37, PosY = -19}
	a.tosx_battleshipw = a.tosx_battleship:new{Image = "units/mission/tosx_battleship_w.png", NumFrames = 4, Time = 0.5 }
	a.tosx_battleshipa = a.tosx_battleshipw:new{}
	a.tosx_battleship_ns = a.tosx_battleship:new{Image = "units/mission/tosx_battleship_ns.png", PosX = -12, PosY = -4}
	a.tosx_battleshipd = a.tosx_battleship:new{Image = "units/mission/tosx_battleship_d.png", PosX = -34, PosY = -5, Frames = {5,6,7,8,9,10,11}, NumFrames = 12, Time = 0.14, Loop = false}
	a.tosx_battleshipdg = a.tosx_battleship:new{Image = "units/mission/tosx_battleship_dg.png", NumFrames = 1, Time = 0.4, Loop = false}
	
-------- Swimming movement override ------------
local originalMove = {
	GetDescription = Move.GetDescription,
	GetTargetArea = Move.GetTargetArea,
	GetSkillEffect = Move.GetSkillEffect,
}

function Move:GetTargetArea(p1)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_battleship" then
		moveSkill = tosx_battleship_swim_skill
	end

	if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
		return moveSkill:GetTargetArea(p1)
	end

	return originalMove.GetTargetArea(self, p1)
end

function Move:GetSkillEffect(p1, p2)
	local moveSkill = nil
	if Board:GetPawn(p1):GetType() == "tosx_mission_battleship" then
		moveSkill = tosx_battleship_swim_skill
	end
	
	if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
		return moveSkill:GetSkillEffect(p1, p2)
	end
	
	return originalMove.GetSkillEffect(self, p1, p2)
end
--------------------
	
	for i = 0, 5 do
		modApi:addMap(mod.resourcePath .."maps/tosx_shipping".. i ..".map")
	end
end

function this:load(mod, options, version)	
	modapiext:addPawnKilledHook(function(mission, pawn)
		-- Pawns over water don't play death animations on death; do it manually. There will also be a splash from the unit dying over water
		if pawn:GetType() == "tosx_mission_battleship" then
			local point = pawn:GetSpace()
			if Board:GetTerrain(point) == TERRAIN_WATER then
				Game:TriggerSound("/impact/generic/explosion")
				Board:AddAnimation(point, "tosx_battleshipd", ANIM_NO_DELAY)
			end
		end
	end)
	
	-- corpMissions.Add_Missions_Low("Mission_tosx_Shipping", "Corp_Grass")
	--corpIslandMissions.Add_Missions_Low("Mission_tosx_Shipping", "archive")
end

return this