
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Disruptor", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the Disruptor", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Disruptor", 1):Failed() end,
	[1] = function() return Objective("Defend the Disruptor", 1) end,
	default = function() return nil end,
}

Mission_tosx_Sonic = Mission_Infinite:new{
	Name = "Sonic Disruptor",
	MapTags = {"tosx_rocky" , "mountain"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	Objectives = objAfterMission:case(1),
	UseBonus = true,
	MineCount = 8, 
	SonicId = -1,
	SpawnMod = 1,
}

-- Add CEO dialog
local dialog = require(path .."missions/sonic_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Sonic", dialogTable)
end

function Mission_tosx_Sonic:StartMission()
	local sonic = PAWN_FACTORY:CreatePawn("tosx_SonicTower")
	self.SonicId = sonic:GetId()
	Board:AddPawn(sonic)
end	

function Mission_tosx_Sonic:IsSonicAlive()
	if Board:GetPawn(self.SonicId) ~= nil and Board:IsPawnAlive(self.SonicId) then
		return 1
	end
	return 0
end

function Mission_tosx_Sonic:UpdateObjectives()
	objInMission:case(self:IsSonicAlive())
end

function Mission_tosx_Sonic:GetCompletedObjectives()
	return objAfterMission:case(self:IsSonicAlive())
end






modApi:appendAsset("img/units/mission/tosx_sonic.png", mod.resourcePath.."img/units/mission/sonic.png")
modApi:appendAsset("img/units/mission/tosx_sonic_ns.png", mod.resourcePath.."img/units/mission/sonic_ns.png")
modApi:appendAsset("img/units/mission/tosx_sonica.png", mod.resourcePath.."img/units/mission/sonica.png")
modApi:appendAsset("img/units/mission/tosx_sonicd.png", mod.resourcePath.."img/units/mission/sonicd.png")

modApi:appendAsset("img/weapons/tosx_tanker_siphon.png", mod.resourcePath.."img/weapons/tanker_siphon.png")
modApi:appendAsset("img/effects/tosx_navring_a.png", mod.resourcePath.."img/effects/tosx_navring_a.png")

modApi:appendAsset("img/weapons/tosx_sonic_wave.png", mod.resourcePath.."img/weapons/sonic_wave.png")

local a = ANIMS
a.tosx_sonic = a.BaseUnit:new{Image = "units/mission/tosx_sonic.png", PosX = -14, PosY = -9}
a.tosx_sonica = a.tosx_sonic:new{Image = "units/mission/tosx_sonica.png", NumFrames = 4, Time = 0.3}
a.tosx_sonicd = a.tosx_sonic:new{Image = "units/mission/tosx_sonicd.png", PosX = -20, PosY = -6, NumFrames = 11, Time = 0.12, Loop = false }
a.tosx_sonic_ns = a.tosx_sonic:new{Image = "units/mission/tosx_sonic_ns.png", PosY = -6}

a.tosx_NavRing = Animation:new{
	Image = "effects/tosx_navring_a.png",
	NumFrames = 5,
	Time = .06,
	PosX = -37,
	PosY = -7
}
a.tosx_NavRing2 = a.tosx_NavRing:new{Frames = {4,3,2,1,0}}

tosx_SonicTower = {
	Name = "Disruptor Tower",
	Health = 2,
	MoveSpeed = 0,
	Neutral = false,
	Image = "tosx_sonic",
	SkillList = { "tosx_Sonic_Weapon" },
	SoundLocation = "/support/terraformer/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true,	
	Pushable = false,
	NonGrid = true,
	IgnoreSmoke = true,
}
AddPawn("tosx_SonicTower")

tosx_Sonic_Weapon = Grenade_Base:new{
	Name = "Sonic Scrambler",
	Description = "Confuse all enemies on target tiles, flipping their attack directions.",
	Icon = "weapons/tosx_sonic_wave.png",
	Class = "Unique",
	LaunchSound = "/weapons/grid_defense",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,1),
		Target = Point(2,1),
		Enemy1 = Point(1,1),
		Queued1 = Point(2,1),
		Enemy2 = Point(3,1),
		Queued2 = Point(2,1),
		CustomPawn = "tosx_SonicTower"
	}
}

function tosx_Sonic_Weapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local sonic0 = SpaceDamage(p1)
	sonic0.sAnimation = "tosx_NavRing"
	ret:AddDamage(sonic0)
	ret:AddDelay(0.15)
	ret:AddDamage(sonic0)
	ret:AddDelay(0.15)
	ret:AddDamage(sonic0)
	ret:AddBoardShake(0.25)
	ret:AddDelay(0.25)
	
	sonic0.loc = p2
	sonic0.sAnimation = "tosx_NavRing2"
	ret:AddDamage(sonic0)
	
	local sonic = SpaceDamage(p2,0,DIR_FLIP)
	ret:AddDamage(sonic)
	for i = DIR_START, DIR_END do
		sonic.loc = p2 + DIR_VECTORS[i]
		ret:AddDamage(sonic)
	end
	ret:AddBoardShake(0.25)
	ret:AddSound("/weapons/grid_defense")
	ret:AddSound("/weapons/enhanced_tractor")
	
	ret:AddDelay(0.15)
	ret:AddDamage(sonic0)
	ret:AddDelay(0.15)
	ret:AddDamage(sonic0)
	
	return ret
end