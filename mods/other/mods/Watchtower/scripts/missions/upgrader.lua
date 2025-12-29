
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission1 = switch{
	[0] = function()
		Game:AddObjective("Defend the War Rig", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the War Rig", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objInMission2 = switch{
	[0] = function()
		Game:AddObjective("Scavenge 2 Wrecks\n(0/2 scavenged)", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Scavenge 2 Wrecks\n(1/2 scavenged)", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[2] = function()
		Game:AddObjective("Scavenge 2 Wrecks", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	[3] = function()
		Game:AddObjective("Scavenge 2 Wrecks", OBJ_FAILED, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Defend the War Rig", 1):Failed() end,
	[1] = function() return Objective("Defend the War Rig", 1) end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Scavenge 2 Wrecks (0/2 scavenged)", 1):Failed() end,
	[1] = function() return Objective("Scavenge 2 Wrecks (1/2 scavenged)", 1):Failed() end,
	[2] = function() return Objective("Scavenge 2 Wrecks", 1) end,
	default = function() return nil end,
}

Mission_tosx_Upgrader = Mission_Infinite:new{
	Name = "Upgrade the War Rig",
	MapTags = {"tosx_items"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	Objectives = { objAfterMission1:case(1), objAfterMission2:case(2) },
	UseBonus = false,
	SpawnMod = 1,
	RigId = -1,
	Hulks = nil,
	Count = 2,
	Upgrades = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/upgrader_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Upgrader", dialogTable)
end

function Mission_tosx_Upgrader:StartMission()
	self.Hulks = {-1,-1}
	local options = extract_table(Board:GetZone("satellite"))
		
	if #options < self.Count then LOG("ERROR NO VALID SPACE") return end
	
	local hulk = PAWN_FACTORY:CreatePawn("tosx_Rig0")
	self.Hulks[1] = hulk:GetId()
	local choice = random_removal(options)
	Board:SetTerrain(choice, TERRAIN_ROAD)
	Board:AddPawn(hulk,choice)
	
	local choice2 = choice
	while math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 and #options > 0 do
		choice2 = random_removal(options)
	end
	
	if math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 then 
		LOG("ERROR NO VALID SECOND SPACE") 
		return 
	end
		
	hulk = PAWN_FACTORY:CreatePawn("tosx_Rig0")
	self.Hulks[2] = hulk:GetId()
	Board:AddPawn(hulk, choice2)
	Board:SetTerrain(choice2, TERRAIN_ROAD)
	
	local rig = PAWN_FACTORY:CreatePawn("tosx_Rig1")
	self.RigId = rig:GetId()
	Board:AddPawn(rig)
end

function Mission_tosx_Upgrader:IsRigAlive()
	if Board:GetPawn(self.RigId) ~= nil and Board:IsPawnAlive(self.RigId) then
		return 1
	end
	return 0
end

function Mission_tosx_Upgrader:WrecksLeft()
	local count = 0
	for i = 1,2 do
		if Board:GetPawn(self.Hulks[i]) ~= nil and Board:IsPawnAlive(self.Hulks[i]) then
			count = count + 1
		end
	end
	return count
end

function Mission_tosx_Upgrader:UpdateObjectives()
	objInMission1:case(self:IsRigAlive())
	
	if (self:WrecksLeft() + self.Upgrades) >= 2 then
		objInMission2:case(math.min(self.Upgrades,2))
	else
		objInMission2:case(3)
	end
end

function Mission_tosx_Upgrader:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(self:IsRigAlive())
	ret[2] = objAfterMission2:case(self.Upgrades)
	return ret
end

function Mission_tosx_Upgrader:GetCompletedStatus()
	if self.Upgrades > 1 and self:IsRigAlive() then
		return "Success"
	elseif self.Upgrades > 1 then
		return "Dead"
	elseif self:IsRigAlive() then
		return "Weak"
	else
		return "Failure"
	end
end
-- example of briefing entry: Mission_tosx_Upgrader_Dead_CEO_Watchtower_1
-- "Dead" is the status


local a = ANIMS
for i = 1, 3 do
	modApi:appendAsset("img/units/mission/tosx_rig"..i..".png", mod.resourcePath.."img/units/mission/rig"..i..".png")
	modApi:appendAsset("img/units/mission/tosx_rig"..i.."_ns.png", mod.resourcePath.."img/units/mission/rig"..i.."_ns.png")
	modApi:appendAsset("img/units/mission/tosx_rig"..i.."a.png", mod.resourcePath.."img/units/mission/rig"..i.."a.png")
	modApi:appendAsset("img/units/mission/tosx_rig"..i.."d.png", mod.resourcePath.."img/units/mission/rig"..i.."d.png")

	a["tosx_rig"..i] = a.BaseUnit:new{Image = "units/mission/tosx_rig"..i..".png", PosX = -16, PosY = 7}
	a["tosx_rig"..i.."a"] = a["tosx_rig"..i]:new{Image = "units/mission/tosx_rig"..i.."a.png", NumFrames = 2, Time = 0.5}
	a["tosx_rig"..i.."d"] = a["tosx_rig"..i]:new{Image = "units/mission/tosx_rig"..i.."d.png", PosX = -19, PosY = 5, NumFrames = 11, Time = 0.12, Loop = false }
	a["tosx_rig"..i.."_ns"] = a["tosx_rig"..i]:new{Image = "units/mission/tosx_rig"..i.."_ns.png"}
end

modApi:appendAsset("img/units/mission/tosx_rig0.png", mod.resourcePath.."img/units/mission/rig0.png")
modApi:appendAsset("img/units/mission/tosx_rig0d.png", mod.resourcePath.."img/units/mission/rig0d.png")

modApi:appendAsset("img/weapons/tosx_rig_retrofit.png", mod.resourcePath.."img/weapons/rig_retrofit.png")
modApi:appendAsset("img/weapons/tosx_rig_engine.png", mod.resourcePath.."img/weapons/rig_engine.png")

a.tosx_rig0 = a.BaseUnit:new{Image = "units/mission/tosx_rig0.png", PosX = -16, PosY = 7}
a.tosx_rig0a = a.tosx_rig0:new{}
a.tosx_rig0d = a.tosx_rig0:new{Image = "units/mission/tosx_rig0d.png", PosX = -19, PosY = 5, NumFrames = 11, Time = 0.12, Loop = false }

modApi:appendAsset("img/combat/icons/icon_tosx_retrofit_glow.png", mod.resourcePath.."img/combat/icons/icon_retrofit_glow.png")
Location["combat/icons/icon_tosx_retrofit_glow.png"] = Point(-15,7)

tosx_Rig0 = {
	Name = "Wrecked War Rig",
	Health = 2,
	MoveSpeed = 0,
	Image = "tosx_rig0",
	SoundLocation = "/support/vip_truck/",
	ImpactMaterial = IMPACT_METAL,
	Neutral = true,
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,
	Minor = true,
	Mission = true,
}
AddPawn("tosx_Rig0")

tosx_Rig1 = {
	Name = "War Rig Mk.I",
	Health = 1,
	MoveSpeed = 3,
	Neutral = false,
	Image = "tosx_rig1",
	SkillList = { "tosx_Rig1_Weapon" ,  "tosx_Rig_Upgrade" },
	SoundLocation = "/support/vip_truck/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true
}
AddPawn("tosx_Rig1")

tosx_Rig2 = tosx_Rig1:new{
	Name = "War Rig Mk.II",
	Health = 2,
	Image = "tosx_rig2",
	SkillList = { "tosx_Rig2_Weapon" ,  "tosx_Rig_Upgrade" },
}

tosx_Rig3 = tosx_Rig2:new{
	Name = "War Rig Mk.III",
	Health = 3,
	Image = "tosx_rig3",
	SkillList = { "tosx_Rig3_Weapon" },
}

tosx_Rig1_Weapon = Skill:new{
	Name = "Battered Engines",
	Description = "Charge in a line and slam into the target, pushing it.",
	Icon = "weapons/tosx_rig_engine.png",
	Damage = 0,
	PathSize = 7,
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	Anim = "airpush_",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_Rig1",
	}
}

function tosx_Rig1_Weapon:GetTargetArea(p1)
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

function tosx_Rig1_Weapon:GetSkillEffect(p1, p2)
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

tosx_Rig2_Weapon = tosx_Rig1_Weapon:new{
	Name = "Reforged Engines",
	Description = "Charge in a line and slam into the target, pushing and damaging it.",
	Damage = 1,
	Anim = "explopush1_",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_Rig2",
	}
}

tosx_Rig3_Weapon = tosx_Rig2_Weapon:new{
	Name = "Superior Engines",
	Damage = 2,
	Anim = "explopush2_",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_Rig3",
	}
}

tosx_Rig_Upgrade = Skill:new{
	Name = "Retrofit",
	Description = "Scavenge a Wreck to upgrade this unit.",
	Icon = "weapons/tosx_rig_retrofit.png",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_Rig1",
		CustomEnemy = "tosx_Rig0",
	}
}

function tosx_Rig_Upgrade:GetTargetArea(p1)
	local ret = PointList()

	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		if Board:IsPawnSpace(curr) and Board:GetPawn(curr):GetType() == "tosx_Rig0" then
			ret:push_back(curr)
		end
	end
	
	return ret
end

function tosx_Rig_Upgrade:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,DAMAGE_DEATH)
	--damage.sAnimation = "ExploAir1"
	damage.sSound = "/mech/science/napalm_mech/move"
	ret:AddDamage(damage)
	
	local mark = SpaceDamage(p1)
	mark.sImageMark = "combat/icons/icon_tosx_retrofit_glow.png"
	ret:AddDamage(mark)
	
	local level = 2
	if Pawn:GetType() == "tosx_Rig2" then level = 3 end

	if not Board:IsTipImage() then
		ret:AddScript([[
			local rig = PAWN_FACTORY:CreatePawn("tosx_Rig]]..level..[[")
			local mission = GetCurrentMission()
			if mission then
				mission.RigId = rig:GetId()
				mission.Upgrades = mission.Upgrades + 1
			end
			Board:RemovePawn(]]..p1:GetString()..[[)		
			Board:AddPawn(rig,]]..p1:GetString()..[[)
			rig:SetActive(false)
			]])
		ret:AddVoice("Mission_tosx_RigUpgraded", -1)
	else
		ret:AddScript([[
			local rig = PAWN_FACTORY:CreatePawn("tosx_Rig2")
			Board:RemovePawn(]]..p1:GetString()..[[)		
			Board:AddPawn(rig,]]..p1:GetString()..[[)
			rig:SetActive(false)
			]])
	end
	
	local heal = SpaceDamage(p1,-1)
	heal.bHide = true
	ret:AddDamage(heal)
	
	return ret
end