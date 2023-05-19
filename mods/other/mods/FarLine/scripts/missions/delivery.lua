
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

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

local objInMission1 = switch{
	[0] = function()
		Game:AddObjective("Protect the Supplies", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Protect the Supplies", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objInMission2 = switch{
	[0] = function()
		Game:AddObjective("Deliver the Supplies", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Deliver the Supplies", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[2] = function()
		Game:AddObjective("Deliver the Supplies", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Protect the Supplies", 1):Failed() end,
	[1] = function() return Objective("Protect the Supplies", 1) end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Deliver the Supplies", 1):Failed() end,
	[1] = function() return Objective("Deliver the Supplies", 1) end,
	default = function() return nil end,
}

Mission_tosx_Delivery = Mission_Infinite:new{
	Name = "Delivery",
	MapTags = {"tosx_delivery"},
	Objectives = {objAfterMission1:case(1),objAfterMission2:case(1)},
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = false,
	Criticals = nil,
	Target = Point(-1,-1),
}

-- Add CEO dialog
local dialog = require(path .."missions/delivery_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Delivery", dialogTable)
end

function Mission_tosx_Delivery:StartMission()
	self.Criticals = {}
	
	local options = extract_table(Board:GetZone("target"))
	
	local choice = random_removal(options)
	local crate = PAWN_FACTORY:CreatePawn("tosx_cargocrate1")
	self.Criticals[1] = crate:GetId()
	Board:AddPawn(crate, choice)
	
	local choice2 = random_removal(options)
	self.Target = choice2
	Board:SetCustomTile(choice2,"tosx_receiving.png")
	
	local place = {}
	local copter = PAWN_FACTORY:CreatePawn("tosx_cargocopter1")
	-- Try to place helicopter next to crate
	for dir = DIR_START, DIR_END do
		local p = choice + DIR_VECTORS[dir]
		if Board:IsValid(p) and not Board:IsBlocked(p, PATH_PROJECTILE) then
			place[#place + 1] = p
		end
	end
	if #place > 0 then
		local choice3 = random_removal(place)
		Board:AddPawn(copter,choice3)
	else
		Board:AddPawn(copter)
	end
end

function Mission_tosx_Delivery:Delivered()
	if countAlive(self.Criticals) < 1 then return 0 end
	if Board:GetPawnSpace(self.Criticals[1]) == self.Target then return 2 end
	return 1
end

function Mission_tosx_Delivery:UpdateMission()
	if Board:GetCustomTile(self.Target) == "tosx_receiving.png" and
	   Board:GetTerrain(self.Target) == TERRAIN_ROAD then
		Board:MarkSpaceDesc(self.Target,"tosx_env_delivery_tile")
	end
end

function Mission_tosx_Delivery:UpdateObjectives()
	objInMission1:case(countAlive(self.Criticals))
	objInMission2:case(self:Delivered())
end

function Mission_tosx_Delivery:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(countAlive(self.Criticals))
	ret[2] = objAfterMission2:case(self:Delivered())
	return ret
end

function Mission_tosx_Delivery:GetCompletedStatus()
	if countAlive(self.Criticals) > 0 and self:Delivered() == 2 then
		return "Success"
	elseif countAlive(self.Criticals) > 0 and self:Delivered() < 2 then
		return "ProtectOnly"
	else
		return "Failure"
	end
end

tosx_cargocopter1 = Pawn:new{
	Name = "Cargo Helicopter",
	Health = 1,
	MoveSpeed = 4,
	Image = "tosx_cargocopter",
	DefaultTeam = TEAM_PLAYER,
	Mission = true,
	SkillList = { "tosx_Cargocopter_Attack" },
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/flying/jet_mech/",
	Corporate = true,
	Flying = true,
}

tosx_cargocrate1 = Pawn:new{
	Name = "Supply Crates",
	Health = 2,
	Neutral = true,
	SpaceColor = false,
	MoveSpeed = 0,
	Image = "tosx_cargocrate",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false,
	Mission = true,
}

tosx_Cargocopter_Attack = Skill:new{
	Name = "Cargo Winch",
	Description = "Use a short-range grapple to pull objects towards this unit.",
	Icon = "weapons/tosx_cargowinch.png",
	Class = "Unique",
	Range = 3,
	LaunchSound = "/weapons/grapple",
	ImpactSound = "/impact/generic/grapple",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Water = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "tosx_cargocopter1",
		CustomEnemy = "tosx_cargocrate1",
	}
}

function tosx_Cargocopter_Attack:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local this_path = {}
		
		local target = point + DIR_VECTORS[dir]

		local range = 0
		while not Board:IsBlocked(target, PATH_PROJECTILE) and range < self.Range do
			this_path[#this_path+1] = target
			target = target + DIR_VECTORS[dir]
			range = range + 1
		end
		
		if Board:IsValid(target) and target:Manhattan(point) > 1 then
			this_path[#this_path+1] = target
			for i,v in ipairs(this_path) do 
				ret:push_back(v)
			end
		end
	end
	
	return ret
end

function tosx_Cargocopter_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local target = p1 + DIR_VECTORS[direction]

	local range = 0
	while not Board:IsBlocked(target, PATH_PROJECTILE) and range < self.Range do
		target = target + DIR_VECTORS[direction]
	end
	
	if not Board:IsValid(target) then
		return ret
	end
	
	local damage = SpaceDamage(target)
	damage.bHidePath = true
	ret:AddProjectile(damage,"effects/shot_grapple")
	
	if Board:IsPawnSpace(target) and not Board:GetPawn(target):IsGuarding() then	-- If it's a pawn
		ret:AddCharge(Board:GetSimplePath(target, p1 + DIR_VECTORS[direction]), FULL_DELAY)
	elseif Board:IsBlocked(target, Pawn:GetPathProf()) then     --If it's an obstruction
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)
	end
		
	return ret
end

---------------------

TILE_TOOLTIPS.tosx_env_delivery_tile = {"Receiving Zone", "Deliver the Supply Crates to this location."}

modApi:appendAsset("img/units/mission/tosx_cargocrate.png", mod.resourcePath .."img/units/mission/cargocrate.png")
modApi:appendAsset("img/units/mission/tosx_cargocrate_ns.png", mod.resourcePath .."img/units/mission/cargocrate_ns.png")
modApi:appendAsset("img/units/mission/tosx_cargocrate_d.png", mod.resourcePath .."img/units/mission/cargocrate_d.png")

modApi:appendAsset("img/units/mission/tosx_cargocopter.png", mod.resourcePath .."img/units/mission/cargocopter.png")
modApi:appendAsset("img/units/mission/tosx_cargocopter_ns.png", mod.resourcePath .."img/units/mission/cargocopter_ns.png")
modApi:appendAsset("img/units/mission/tosx_cargocopter_d.png", mod.resourcePath .."img/units/mission/cargocopter_d.png")
modApi:appendAsset("img/units/mission/tosx_cargocopter_a.png", mod.resourcePath .."img/units/mission/cargocopter_a.png")

modApi:appendAsset("img/weapons/tosx_cargowinch.png", mod.resourcePath.. "img/weapons/tosx_cargowinch.png")

local a = ANIMS
a.tosx_cargocrate 	 = a.BaseUnit:new{Image = "units/mission/tosx_cargocrate.png", PosX = -16, PosY = -1}
a.tosx_cargocratea 	 = a.tosx_cargocrate:new{}
a.tosx_cargocrate_ns = a.tosx_cargocrate:new{Image = "units/mission/tosx_cargocrate_ns.png"}
a.tosx_cargocrated 	 = a.tosx_cargocrate:new{Image = "units/mission/tosx_cargocrate_d.png", PosX = -18, PosY = -1, NumFrames = 11, Time = 0.12, Loop = false }

a.tosx_cargocopter 	  = a.BaseUnit:new{ Image = "units/mission/tosx_cargocopter.png", PosX = -15, PosY = 8 }
a.tosx_cargocoptera   = a.tosx_cargocopter:new{ Image = "units/mission/tosx_cargocopter_a.png", NumFrames = 4 }
a.tosx_cargocopter_ns = a.tosx_cargocopter:new{ Image = "units/mission/tosx_cargocopter_ns.png"}
a.tosx_cargocopterd   = a.tosx_cargocopter:new{ Image = "units/mission/tosx_cargocopter_d.png", PosX = -19, PosY = 9, NumFrames = 11, Time = 0.14, Loop = false }