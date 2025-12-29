-- mission Mission_tosx_HealCrystal
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")

local objInMission2 = switch{
	[0] = function()
		Game:AddObjective("Kill an enemy while the Blood Halcyte is intact", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Kill an enemy while the Blood Halcyte is intact", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[2] = function()
		Game:AddObjective("Kill an enemy while the Blood Halcyte is intact", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Destroy the Blood Halcyte", 1) end,
	[1] = function() return Objective("Destroy the Blood Halcyte", 1):Failed() end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Kill an enemy while the Blood Halcyte is intact", 1):Failed() end,
	[1] = function() return Objective("Kill an enemy while the Blood Halcyte is intact", 1) end,
	default = function() return nil end,
}

Mission_tosx_HealCrystal = Mission_Infinite:new{
	Name = "Blood Halcyte",
	Objectives = {objAfterMission1:case(0),objAfterMission2:case(1)},
	MapTags = {"tosx_crystal" , "mountain", "generic"},
	UseBonus = false,
	CrsytalId = -1,
	CrystalPawn = "tosx_HealCrystal",
	Environment = "tosx_env_healcrystal",
    HealKill = false,
	BlockedUnits = {"Jelly_Regen"},
}

-- Add CEO dialog
local dialog = require(path .."missions/healcrystal_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_HealCrystal", dialogTable)
end

function Mission_tosx_HealCrystal:StartMission()
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end

	local choices = self:GetReplaceableBuildings()
	local choice = random_removal(choices)
	Board:ClearSpace(choice)
    
	local crystal = PAWN_FACTORY:CreatePawn(self.CrystalPawn)
	self.CrsytalId = crystal:GetId()
	Board:AddPawn(crystal, choice)
end

function Mission_tosx_HealCrystal:CanKill()
    if not Board:IsPawnAlive(self.CrsytalId) and not self.HealKill then
        return 0
    elseif self.HealKill then
        return 2
    end
    return 1
end

function Mission_tosx_HealCrystal:UpdateObjectives()
	local status = Board:IsPawnAlive(self.CrsytalId) and OBJ_STANDARD or OBJ_COMPLETE
	Game:AddObjective("Destroy the Blood Halcyte",status)
    
	objInMission2:case(self:CanKill())
end

function Mission_tosx_HealCrystal:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(Board:IsPawnAlive(self.CrsytalId) and 0 or 1)
	ret[2] = objAfterMission2:case(self.HealKill and 1 or 0)
	return ret
end

function Mission_tosx_HealCrystal:GetCompletedStatus()
	if self.HealKill and not Board:IsPawnAlive(self.CrsytalId)then
		return "Success"
	elseif not Board:IsPawnAlive(self.CrsytalId) then
		return "CrystalOnly"
	elseif self.HealKill then
		return "KillOnly"
	else
		return "Failure"
	end
end

tosx_env_healcrystal = Environment:new{
	Name = "Blood Halcyte",
	Text = "While the Blood Halcyte is intact, all units will heal 1 each turn.",
	--Decription = "",
	StratText = "BLOOD HALCYTE",
	CombatIcon = "combat/tile_icon/tosx_icon_env_vekheal.png",
	CombatName = "BLOOD HALCYTE",
}

function tosx_env_healcrystal:Plan()
	return false
end

function tosx_env_healcrystal:IsEffect()
	return true
end

function tosx_env_healcrystal:ApplyEffect()
	if Game:GetTurnCount() == 0 then return false end
    
	local mission = GetCurrentMission()
	if not mission then return end
	if not Board:IsPawnAlive(mission.CrsytalId) then return false end
    
	local effect = SkillEffect()
	effect.iOwner = ENV_EFFECT
    
    local p0 = Board:GetPawnSpace(mission.CrsytalId)
    if Board:IsValid(p0) then
        local d0 = SpaceDamage(p0)
        d0.sAnimation = "tosx_explocrysmain3"
        effect:AddDamage(d0)
    end
    
    effect:AddSound("/enemy/shaman_2/attack_launch")
    effect:AddDelay(0.5)
    effect:AddSound("/weapons/science_enrage_launch")
	
	local pawns = extract_table(Board:GetPawns(TEAM_ANY))
	for i, v in ipairs(pawns) do
        local p = Board:GetPawnSpace(v)
        if p ~= p0 then --don't heal crystal itself
            damage = SpaceDamage(p,-1)
            effect:AddDamage(damage)
        end
    end
    Board:AddEffect(effect)	
    
    return false
end

tosx_HealCrystal = Pawn:new{
	Name = "Blood Halcyte",
	Health = 3,
	Image = "tosx_healcrystal",
	MoveSpeed = 0,
	Neutral = true,
	DefaultTeam = TEAM_ENEMY,
	SoundLocation = "/support/rock",
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Tooltip = "tosx_HealCrystal_Tooltip",
}

tosx_HealCrystal_Tooltip = Skill:new{
    Name = "Healing Energies",
	Class = "Passive",
    Description = "Heals all other units for 1 each turn.",
	PathSize = 5,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Friendly = Point(2,1),
		Enemy1 = Point(1,1),
		CustomPawn = "tosx_HealCrystal",
		Length = 4
	}
}

function tosx_HealCrystal_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local d0 = SpaceDamage(p1)
	d0.bHide = true
    d0.sAnimation = "tosx_explocrysmain3"
	ret:AddDamage(d0)
    ret:AddDelay(0.3)
    
	local heals = SpaceDamage(Point(2,1), -1)
	heals.bHide = true
	ret:AddDamage(heals)
    
    heals.loc = Point(1,1)
	ret:AddDamage(heals)
	
	ret:AddDelay(1)
	
	return ret	
end

modApi:appendAsset("img/units/mission/tosx_healcrystal.png", mod.resourcePath .."img/units/mission/healcrystal.png")
modApi:appendAsset("img/units/mission/tosx_healcrystal_ns.png", mod.resourcePath .."img/units/mission/healcrystal_ns.png")
modApi:appendAsset("img/units/mission/tosx_healcrystal_d.png", mod.resourcePath .."img/units/mission/healcrystal_d.png")
modApi:appendAsset("img/units/mission/tosx_healcrystal_a.png", mod.resourcePath .."img/units/mission/healcrystal_a.png")
modApi:appendAsset("img/effects/tosx_explo_crysmain3.png", mod.resourcePath .."img/effects/explo_crysmain3.png")

modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_vekheal.png", mod.resourcePath .."img/combat/tile_icon/icon_env_vekheal.png")
Location["combat/tile_icon/tosx_icon_env_vekheal.png"] = Point(-27,2) -- Needed for it to appear on tiles

TILE_TOOLTIPS.tosx_env_healcrystal_tile = {tosx_env_healcrystal.Name, tosx_env_healcrystal.Decription}
Global_Texts["TipTitle_".."tosx_env_healcrystal"] = tosx_env_healcrystal.Name
Global_Texts["TipText_".."tosx_env_healcrystal"] = tosx_env_healcrystal.Text

local a = ANIMS
a.tosx_healcrystal 	  = a.BaseUnit:new{ Image = "units/mission/tosx_healcrystal.png", PosX = -15, PosY = 1}
a.tosx_healcrystala   = a.tosx_healcrystal:new{ Image = "units/mission/tosx_healcrystal_a.png", PosY = 0, NumFrames = 4 }
a.tosx_healcrystal_ns = a.tosx_healcrystal:new{ Image = "units/mission/tosx_healcrystal_ns.png"}
a.tosx_healcrystald   = a.tosx_healcrystal:new{ Image = "units/mission/tosx_healcrystal_d.png", PosX = -24, PosY = -6, NumFrames = 13, Time = 0.09, Loop = false }

a.tosx_explocrysmain3 = a.ExploArt1:new{
    Image = "effects/tosx_explo_crysmain3.png",
    PosX = -34, PosY = -11,
    Time = 0.075,
    Loop = false,
    NumFrames = 8
}
    
local function onPawnKilled(mission, pawn)
    if not mission or mission.ID ~= "Mission_tosx_HealCrystal" then return end
	if pawn:IsEnemy() and Board:IsPawnAlive(mission.CrsytalId) then
		mission.HealKill = true
	end
end

modapiext.events.onPawnKilled:subscribe(onPawnKilled)