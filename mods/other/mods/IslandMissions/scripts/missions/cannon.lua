-- mission Mission_tosx_Cannon

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Cannon"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")

Mission_tosx_Cannon = Mission_Infinite:new{
	Name = "Broken Cannon",
	Objectives = Objective("Destroy the Missile Turret",1,1),--!
	CannonPawn = "tosx_MissileTurret",
	Target = -1,
	Attacks = {},
}

function Mission_tosx_Cannon:StartMission()
	local cannon = PAWN_FACTORY:CreatePawn(self.CannonPawn)
	Board:AddPawn(cannon)
	self.Target = cannon:GetId()
end

function Mission_tosx_Cannon:NextTurn()
	self.Attacks = {}	
	
	local quarters = Environment:GetQuarters()	
	for i,v in ipairs(quarters) do
		self.Attacks[#self.Attacks + 1] = random_removal(v)
		self.Attacks[#self.Attacks + 1] = random_removal(v)
	end
end

function Mission_tosx_Cannon:IsGone()
	return not Board:IsPawnAlive(self.Target)
end

function Mission_tosx_Cannon:GetCompletedObjectives()
	if self:IsGone() then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_Cannon:UpdateObjectives()
	local status = self:IsGone() and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the Missile Turret",status, REWARD_REP, 1)
end
-------------------------------------------------------------------- 
tosx_MissileTurret = Pawn:new{
	Name = " Missile Turret",
	Health = 2,
	Neutral = true,
	Image = "tosx_MissileTurret", --!!!
	MoveSpeed = 0,
	SkillList = { "tosx_MissileTurretFire" },
	DefaultTeam = TEAM_NONE, --make it go first
	IgnoreSmoke = true,
	IgnoreFlip = true,
	SoundLocation = "/support/train",
	Pushable = false,
	SpaceColor = false,
	IsPortrait = false,
}
tosx_MissileTurretFire = Skill:new{
	Name = "Rogue Missiles",
	Description = "Launches missiles to damage 8 random tiles.",
	Icon = "weapons/support_missiles.png",
	Class = "Enemy",
	Damage = 2,
	FireSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	UpShot = "effects/shotup_missileswarm.png",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "tosx_MissileTurret"
	}
}

function tosx_MissileTurretFire:GetTargetArea(p1)
	local ret = PointList()
	ret:push_back(p1)
	return ret
end

function tosx_MissileTurretFire:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	if not mission then return end
	
	local ret = SkillEffect()
	
	local targets = {}
	if Board:IsTipImage() then
		targets[1] = Point(1,1)
		targets[2] = Point(3,3)
		targets[3] = Point(2,3)
	else
		targets = mission.Attacks
	end
	
	for i = 1, #targets do
		local dsound = SpaceDamage(p1)
		dsound.bHide = true
		dsound.sSound = self.FireSound
		ret:AddQueuedDamage(dsound)
		
		local damage = SpaceDamage(targets[i], self.Damage)
		damage.sAnimation = "ExploAir1"
		damage.bHidePath = true
		ret:AddQueuedArtillery(damage,self.UpShot, 0.1) --,NO_DELAY
	end
	
	return ret
end

function tosx_MissileTurretFire:GetTargetScore(p1, p2)
	return 100
end
-------------------------------------------------------------------- 

function this:init(mod)		
	modApi:appendAsset("img/units/mission/tosx_turret.png", mod.resourcePath .."img/units/mission/tosx_turret.png")
	modApi:appendAsset("img/units/mission/tosx_turreta.png", mod.resourcePath .."img/units/mission/tosx_turreta.png")
	modApi:appendAsset("img/units/mission/tosx_turret_death.png", mod.resourcePath .."img/units/mission/tosx_turret_death.png")
	modApi:appendAsset("img/units/mission/tosx_turret_ns.png", mod.resourcePath .."img/units/mission/tosx_turret_ns.png")
	
	local a = ANIMS

	a.tosx_MissileTurret 	= a.BaseUnit:new{ Image = "units/mission/tosx_turret.png", PosX = -27, PosY = -19 }
	a.tosx_MissileTurreta 	= a.tosx_MissileTurret:new{ Image = "units/mission/tosx_turreta.png", NumFrames = 4 }
	a.tosx_MissileTurretd 	= a.tosx_MissileTurret:new{ Image = "units/mission/tosx_turret_death.png", PosX = -32, PosY = -9, NumFrames = 11, Time = 0.14, Loop = false }
	a.tosx_MissileTurret_ns	= a.tosx_MissileTurret:new{ Image = "units/mission/tosx_turret_ns.png", }
end

function this:load(mod, options, version)
	--corpMissions.Add_Missions_High("Mission_tosx_Cannon", "Corp_Grass")
	corpIslandMissions.Add_Missions_High("Mission_tosx_Cannon", "archive")
end

return this