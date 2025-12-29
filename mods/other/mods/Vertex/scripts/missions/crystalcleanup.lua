-- mission Mission_tosx_CrystalCleanup
local mod = modApi:getCurrentMod()
local path = mod.scriptPath

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

Mission_tosx_CrystalCleanup = Mission_Infinite:new{
	Name = "Crystal Cleanup",
	MapTags = {"satellite", "tosx_towers"},
	Objectives = Objective("Destroy the Halcyte Crystals",2,2),
    CrystalCount = 2,
	CrystalPawn = "tosx_DeathCrystal",
	CrystalPawn2 = "tosx_FrostCrystal",
	Criticals = nil,
	UseBonus = false,
}

-- Add CEO dialog
local dialog = require(path .."missions/crystalcleanup_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_CrystalCleanup", dialogTable)
end

function Mission_tosx_CrystalCleanup:StartMission()
	self.Criticals = {}    
	local zone = extract_table(Board:GetZone("satellite"))
	
    local ctype = self.CrystalPawn 
    if random_int(4) == 3 then --0,1,2,3
        ctype = self.CrystalPawn2 --25% chance to do ice crystals
    end
    
	for i = 1, self.CrystalCount do
		local pawn = PAWN_FACTORY:CreatePawn(ctype)
		local choice = random_removal(zone)
		Board:ClearSpace(choice)
		Board:AddPawn(pawn, choice)
		table.insert(self.Criticals, pawn:GetId())
	end
end

function Mission_tosx_CrystalCleanup:UpdateObjectives()
	local status = countAlive(self.Criticals) == 0 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the Halcyte Crystals",status, REWARD_REP, 2)
end

function Mission_tosx_CrystalCleanup:GetCompletedObjectives()
	local crystal_count = countAlive(self.Criticals)
	if crystal_count == 0 then
		return self.Objectives
	elseif crystal_count == 1 then
		return Objective("Destroy the Halcyte Crystals (One Remains)",1,2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_CrystalCleanup:GetCompletedStatus()
	if countAlive(self.Criticals) > 0 then	
		return "Failure"
	else
		return "Success"
	end
end

tosx_DeathCrystal = Pawn:new{
	Name = "Halcyte Crystal",
	Health = 2,
	Image = "tosx_deathcrystal",
	MoveSpeed = 0,
	Neutral = true,
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Tooltip = "tosx_DeathCrystal_Tooltip",
	IsDeathEffect = true,
}
function tosx_DeathCrystal:GetDeathEffect(p1)
	local ret = SkillEffect()
	
    ret:AddSound("/impact/generic/explosion")
	local damage0 = SpaceDamage(p1)
    damage0.sAnimation = "tosx_explocrysmain1"
	ret:AddDamage(damage0)
	
	for i = DIR_START,DIR_END do
        local damage = SpaceDamage(p1 + DIR_VECTORS[i], DAMAGE_DEATH)
		damage.sAnimation = "tosx_explocrys_"..i
		ret:AddDamage(damage)
	end
	
	return ret
end

tosx_DeathCrystal_Tooltip = SelfTarget:new{
	Name = "Deadly Energies",
	Class = "Death",
    Description = "Explode when destroyed, killing anything adjacent.",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Building = Point(1,2),
		Enemy = Point(2,1),
		CustomPawn = "tosx_DeathCrystal"
	}
}

function tosx_DeathCrystal_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(1)
	return ret
end

modApi:appendAsset("img/units/mission/tosx_deathcrystal.png", mod.resourcePath .."img/units/mission/deathcrystal.png")
modApi:appendAsset("img/units/mission/tosx_deathcrystal_ns.png", mod.resourcePath .."img/units/mission/deathcrystal_ns.png")
modApi:appendAsset("img/units/mission/tosx_deathcrystal_d.png", mod.resourcePath .."img/units/mission/deathcrystal_d.png")
modApi:appendAsset("img/units/mission/tosx_deathcrystal_a.png", mod.resourcePath .."img/units/mission/deathcrystal_a.png")

local a = ANIMS
a.tosx_deathcrystal 	  = a.BaseUnit:new{ Image = "units/mission/tosx_deathcrystal.png", PosX = -15, PosY = 1}
a.tosx_deathcrystala   = a.tosx_deathcrystal:new{ Image = "units/mission/tosx_deathcrystal_a.png", PosY = 0, NumFrames = 4 }
a.tosx_deathcrystal_ns = a.tosx_deathcrystal:new{ Image = "units/mission/tosx_deathcrystal_ns.png"}
a.tosx_deathcrystald   = a.tosx_deathcrystal:new{ Image = "units/mission/tosx_deathcrystal_d.png", PosX = -24, PosY = -6, NumFrames = 13, Time = 0.09, Loop = false }

---

tosx_FrostCrystal = Pawn:new{
	Name = "Frost Halcyte",
	Health = 2,
	Image = "tosx_icecrystal",
	MoveSpeed = 0,
	Neutral = true,
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Tooltip = "tosx_FrostCrystal_Tooltip",
	IsDeathEffect = true,
}
function tosx_FrostCrystal:GetDeathEffect(p1)
	local ret = SkillEffect()
	
    ret:AddSound("/impact/generic/explosion")
	
	for i = DIR_START,DIR_END do
        local damage = SpaceDamage(p1 + DIR_VECTORS[i])
        damage.iFrozen = EFFECT_CREATE
		damage.sAnimation = "tosx_iceblast_"..i
		ret:AddDamage(damage)
	end
	
	return ret
end

tosx_FrostCrystal_Tooltip = SelfTarget:new{
	Name = "Freezing Energies",
	Class = "Death",
    Description = "Explode when destroyed, Freezing anything adjacent.",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Building = Point(1,2),
		Enemy = Point(2,1),
		CustomPawn = "tosx_FrostCrystal"
	}
}

function tosx_FrostCrystal_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(1)
	return ret
end

modApi:appendAsset("img/effects/tosx_iceblast_U.png",mod.resourcePath.."img/effects/tosx_iceblast_U.png")
modApi:appendAsset("img/effects/tosx_iceblast_R.png",mod.resourcePath.."img/effects/tosx_iceblast_R.png")
modApi:appendAsset("img/effects/tosx_iceblast_L.png",mod.resourcePath.."img/effects/tosx_iceblast_L.png")
modApi:appendAsset("img/effects/tosx_iceblast_D.png",mod.resourcePath.."img/effects/tosx_iceblast_D.png")
modApi:appendAsset("img/units/mission/tosx_icecrystal.png", mod.resourcePath .."img/units/mission/icecrystal.png")
modApi:appendAsset("img/units/mission/tosx_icecrystal_ns.png", mod.resourcePath .."img/units/mission/icecrystal_ns.png")
modApi:appendAsset("img/units/mission/tosx_icecrystal_d.png", mod.resourcePath .."img/units/mission/icecrystal_d.png")
modApi:appendAsset("img/units/mission/tosx_icecrystal_a.png", mod.resourcePath .."img/units/mission/icecrystal_a.png")

local a = ANIMS
a.tosx_icecrystal 	  = a.BaseUnit:new{ Image = "units/mission/tosx_icecrystal.png", PosX = -15, PosY = 1}
a.tosx_icecrystala   = a.tosx_icecrystal:new{ Image = "units/mission/tosx_icecrystal_a.png", PosY = 0, NumFrames = 4 }
a.tosx_icecrystal_ns = a.tosx_icecrystal:new{ Image = "units/mission/tosx_icecrystal_ns.png"}
a.tosx_icecrystald   = a.tosx_icecrystal:new{ Image = "units/mission/tosx_icecrystal_d.png", PosX = -24, PosY = -6, NumFrames = 13, Time = 0.09, Loop = false }

a.tosx_iceblast_0 = Animation:new{
	Image = "effects/tosx_iceblast_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -20
}

a.tosx_iceblast_1 = a.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_R.png",
	PosX = -20
}

a.tosx_iceblast_2 = a.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_D.png",
	PosX = -20
}

a.tosx_iceblast_3 = a.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_L.png",
	PosX = -20
}