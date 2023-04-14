
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local boardEvents = require(path .."libs/boardEvents")
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission1 = switch{
	[0] = function()
		Game:AddObjective("Defend the Mercenaries", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the Mercenaries", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Defend the Mercenaries", 1):Failed() end,
	[1] = function() return Objective("Defend the Mercenaries", 1) end,
	default = function() return nil end,
}

Mission_tosx_Trading = Mission_Infinite:new{
	Name = "Mercenaries",
	MapTags = {"tosx_rocky" , "mountain"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	Objectives = { objAfterMission1:case(1), Objective("Collect 4 Mineral caches", 1) },
	UseBonus = false,
	MineCount = 8, 
	MineType = "tosx_Ore_Mine",
	Stock = 0,
	RigId = -1,
}

-- Add CEO dialog
local dialog = require(path .."missions/trading_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Trading", dialogTable)
end

function Mission_tosx_Trading:StartMission()
	self.MineLocations = {}
	
	local choices = {}
	for i = 1, 6 do
		for j = 1, 6 do
			if 	Board:GetTerrain(Point(i,j)) == TERRAIN_ROAD then
			    choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	self.MineCount = math.min(#choices,self.MineCount)
	for i = 1, self.MineCount do
		local point = random_removal(choices)
		self.MineLocations[#self.MineLocations+1] = point
		Board:SetCustomTile(point,"")
		Board:SetItem(point,self.MineType)
	end

	local rig = PAWN_FACTORY:CreatePawn("tosx_RigMerc")
	self.RigId = rig:GetId()
	Board:AddPawn(rig)
	rig:SetPowered(false)
end	

function Mission_tosx_Trading:IsRigAlive()
	if Board:GetPawn(self.RigId) ~= nil and Board:IsPawnAlive(self.RigId) then
		return 1
	end
	return 0
end

function Mission_tosx_Trading:UpdateMission()
	if self:IsRigAlive() > 0 then
		if self.Stock >= 4 and not Board:GetPawn(self.RigId):IsPowered() then
			Board:GetPawn(self.RigId):SetPowered(true)			
			if Game:GetTeamTurn() == TEAM_PLAYER then
				Board:GetPawn(self.RigId):SetActive(true)	
			end
			PrepareVoiceEvent("Mission_tosx_MercsPaid")
		elseif self.Stock < 4 and Board:GetPawn(self.RigId):IsPowered() then
			-- In case of undoMove resetting count
			Board:GetPawn(self.RigId):SetPowered(false)
		end
	end
end

function Mission_tosx_Trading:UpdateObjectives()
	objInMission1:case(self:IsRigAlive())
	
	local status = self.Stock >= 4 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Collect 4 Mineral caches\n("..tostring(self.Stock).." / 4)", status, REWARD_REP, 1)
end

function Mission_tosx_Trading:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(self:IsRigAlive())
	
	local status = self.Stock >= 4 and 1 or 0
	ret[2] = Objective("Collect 4 Mineral caches ("..tostring(self.Stock).." / 4)", status, 1)
	
	return ret
end

function Mission_tosx_Trading:GetCompletedStatus()
	if self:IsRigAlive() > 0 and self.Stock >= 4 then
		return "Success"
	else
		return "Failure"
	end
end





modApi:appendAsset("img/effects/emitters/tosx_ore_shard.png", mod.resourcePath.."img/effects/emitters/ore_shard.png")
modApi:appendAsset("img/combat/tosx_ore_mine.png", mod.resourcePath.."img/combat/ore_mine.png")
Location["combat/tosx_ore_mine.png"] = Point(-16,11)

local a = ANIMS
modApi:appendAsset("img/units/mission/tosx_rig_merc.png", mod.resourcePath.."img/units/mission/rig_merc.png")
modApi:appendAsset("img/units/mission/tosx_rig_merc_ns.png", mod.resourcePath.."img/units/mission/rig_merc_ns.png")
modApi:appendAsset("img/units/mission/tosx_rig_merca.png", mod.resourcePath.."img/units/mission/rig_merca.png")
modApi:appendAsset("img/units/mission/tosx_rig_mercd.png", mod.resourcePath.."img/units/mission/rig_mercd.png")
modApi:appendAsset("img/units/mission/tosx_rig_merc_off.png", mod.resourcePath.."img/units/mission/rig_merc_off.png")

--modApi:appendAsset("img/weapons/tosx_rig_engine.png", mod.resourcePath.."img/weapons/rig_engine.png")

a.tosx_rig_merc = a.BaseUnit:new{Image = "units/mission/tosx_rig_merc.png", PosX = -16, PosY = 7}
a.tosx_rig_merca = a.tosx_rig_merc:new{Image = "units/mission/tosx_rig_merca.png", NumFrames = 2, Time = 0.5}
a.tosx_rig_mercd = a.tosx_rig_merc:new{Image = "units/mission/tosx_rig_mercd.png", PosX = -19, PosY = 5, NumFrames = 11, Time = 0.12, Loop = false }
a.tosx_rig_merc_ns = a.tosx_rig_merc:new{Image = "units/mission/tosx_rig_merc_ns.png"}
a.tosx_rig_mercoff = 	a.tosx_rig_merc:new {Image = "units/mission/tosx_rig_merc_off.png" }

tosx_RigMerc = {
	Name = "Mercenary Rig",
	Health = 2,
	MoveSpeed = 3,
	Neutral = false,
	Image = "tosx_rig_merc",
	SkillList = { "tosx_Merc_Weapon" },
	SoundLocation = "/support/vip_truck/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true
}
AddPawn("tosx_RigMerc")

tosx_Merc_Weapon = Skill:new{
	Name = "Modified Engines",
	Description = "Charge in a line and slam into the target, pushing it.",
	Icon = "weapons/tosx_rig_engine.png", -- reuse war rig
	PathSize = 7,
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	Damage = 2,
	Anim = "explopush2_",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_RigMerc",
	}
}

function tosx_Merc_Weapon:GetTargetArea(p1)
	local ret = PointList()

	local pathing = Pawn:GetPathProf()
	
	for dir = DIR_START, DIR_END do
		for i = 1, self.PathSize do
			local curr = p1 + DIR_VECTORS[dir]*i
			if not Board:IsValid(curr) then break end
			ret:push_back(curr)
			if Board:IsBlocked(curr,pathing) then break end
		end
	end
	
	return ret
end

function tosx_Merc_Weapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local pathing = Pawn:GetPathProf()

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,pathing)
	local distance = p1:Manhattan(target)
	
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = self.Anim .. direction
	damage.sSound = self.ImpactSound
	
	if distance == 1 and doDamage then
		ret:AddMelee(p1,damage, NO_DELAY)
	else
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)		
		if doDamage then
			ret:AddDamage(damage)
		end	
	end
	

	return ret
end

tosx_Ore_Mine = {
	Image = "combat/tosx_ore_mine.png",
	Damage = SpaceDamage(0),
	Tooltip = "tosx_ore_mine",
	Icon = "",
	UsedImage = ""
	}

tosx_Emitter_Ore = Emitter:new{
	image = "effects/emitters/tosx_ore_shard.png",
	image_count = 1,
	max_alpha = 1.0,
	min_alpha = 0.0,
	rot_speed = 100,
	x = 0,
	y = 23,
	variance_x = 0,
	variance_y = 0,
	angle = 20,
	angle_variance = 220,
	timer = 0.1,
	burst_count = 5,
	speed = 2,
	lifespan = 0.75,
	birth_rate = 10,
	max_particles = 16,
	gravity = true,
	layer = LAYER_FRONT
}

boardEvents.onItemRemoved:subscribe(function(loc, removed_item)
    if removed_item == "tosx_Ore_Mine"  then
        local pawn = Board:GetPawn(loc)
        if pawn then
			local mine_damage = SpaceDamage(loc)
			if pawn:GetTeam() == TEAM_PLAYER then
				mine_damage.sScript = "GetCurrentMission().Stock = GetCurrentMission().Stock + 1"
			end
			mine_damage.sSound = "/impact/generic/grapple"
			Board:DamageSpace(mine_damage)
			
			local effect = SkillEffect()
			effect:AddEmitter(loc,"tosx_Emitter_Ore")
			Board:AddEffect(effect)
        end
    end
end)

local function UndoMoveHook(mission, pawn, undonePosition)
	if Board:IsItem(undonePosition) and mission and mission.ID == "Mission_tosx_Trading" then
		if Board:GetItem(undonePosition) == "tosx_Ore_Mine" then
			mission.Stock = mission.Stock - 1
		end
	end
end

local function onModsLoaded()
	modapiext:addPawnUndoMoveHook(UndoMoveHook)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)

TILE_TOOLTIPS[tosx_Ore_Mine.Tooltip] = {"Mineral Cache", "Any Mech that steps on this space will collect a cache of valuable Minerals."}