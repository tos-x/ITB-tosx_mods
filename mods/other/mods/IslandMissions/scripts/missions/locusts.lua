-- mission Mission_tosx_Locusts

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Locusts"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")

Mission_tosx_Locusts = Mission_Infinite:new{
	Name = "Nanoswarm",
	Environment = "tosx_env_locust",	
	GlobalSpawnMod = 1,
	BonusPool = {BONUS_GRID, BONUS_KILL_FIVE, BONUS_BLOCK, BONUS_SELFDAMAGE},--removed pacifist (unreasonably hard) + debris (crowded map as-is) + mech health
	BlockedUnits = {"Jelly_Explode", "Jelly_Spider", "Dung", "Spider", "Blobber", "Burrower"},
	Objectives = Objective("Protect the Guardian Tank", 1, 1),
	Target = -1,
}

function Mission_tosx_Locusts:StartMission()
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_Shielder")
	Board:AddPawn(pawn)	
	self.Target = pawn:GetId()
	if Board:IsPawnAlive(self.Target) then
		Board:GetPawn(self.Target):SetMissionCritical(true)
	end
end

function Mission_tosx_Locusts:GetCompletedObjectives()
	if Board:IsPawnAlive(self.Target) then
		return self.Objectives
	end
	return self.Objectives:Failed()
end

function Mission_tosx_Locusts:UpdateObjectives()
	local status = not Board:IsPawnAlive(self.Target) and OBJ_FAILED or OBJ_STANDARD
	Game:AddObjective("Protect the Guardian Tank",status)
end

-------------------------------------------------------------------- 
tosx_Shielder = Pawn:new{
	Name = "Guardian Tank",	
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_ShieldTank", --!!!
	SkillList = { "tosx_w_UnitShield" , "tosx_w_Revive" },
	SoundLocation = "/mech/brute/tank",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = true,
	Armor = true,
}

tosx_w_UnitShield = Skill:new{
	Name = "Achilles Array",
	Description = "Apply a Shield to units within 2 tiles.",
	Class = "Unique",
	Icon = "weapons/tosx_shieldtank_wep.png",
	LaunchSound = "/weapons/localized_burst",
	WideArea = 2,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Enemy = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "tosx_Shielder"
	}
}
		
function tosx_w_UnitShield:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
		
		if self.WideArea > 1 then
			ret:push_back(point + DIR_VECTORS[i] + DIR_VECTORS[i])
			ret:push_back(point + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4])
		end
		if self.WideArea > 2 then
			ret:push_back(point + DIR_VECTORS[i] * 3)
			ret:push_back(point + DIR_VECTORS[i] * 2 + DIR_VECTORS[(i+1)%4])
			ret:push_back(point + DIR_VECTORS[i]  + DIR_VECTORS[(i+1)%4] * 2)
		end
	end
	
	return ret
end

function tosx_w_UnitShield:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,0)
	damage.iShield = 1
	
	for i = DIR_START, DIR_END do
		local p = p1 + DIR_VECTORS[i]
		damage.loc = p
		if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
		
		if self.WideArea > 1 then
			p = p1 + DIR_VECTORS[i] + DIR_VECTORS[i]
			damage.loc = p
			if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
			p = p1 + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]
			damage.loc = p
			if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
		end
		if self.WideArea > 2 then
			p = p1 + DIR_VECTORS[i]*3
			damage.loc = p
			if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
			p = p1 + DIR_VECTORS[i]*2 + DIR_VECTORS[(i+1)%4]
			damage.loc = p
			if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
			p = p1 + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]*2
			damage.loc = p
			if Board:IsPawnSpace(p) then ret:AddDamage(damage) end
		end
	end
	
	return ret
end

tosx_w_Revive = Skill:new{
	Name = "Repair Armature",
	Description = "Repair 1 damage to an adjacent Mech.",
	Icon = "weapons/tosx_repairtank_wep.png",
	Class = "Unique",
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Shielder"
	}
}

function tosx_w_Revive:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local p = point + DIR_VECTORS[i]
		if Board:IsPawnSpace(p) and Board:GetPawnTeam(p) == TEAM_PLAYER then
			ret:push_back(p)
		end
	end	
	return ret
end

function tosx_w_Revive:GetSkillEffect(p1, p2)
	local ret = SkillEffect()	
	local spaceDamage = SpaceDamage(p2, -1)
	ret:AddDamage(spaceDamage)	
	return ret
end	

-------------------------------------------------------------------- 
tosx_env_locust = Environment:new{
	Name = "Nanoswarm",
	Text = "Voracious Nanobots will deal units 1 damage each turn.",
	Decription = "Nanobots will deal 1 damage to this unit each turn.",
	StratText = "NANOSWARM",
	CombatIcon = "combat/tile_icon/tosx_icon_env_locusts.png",
	CombatName = "NANOSWARM",
}

function tosx_env_locust:Plan()
	return false
end

function tosx_env_locust:IsEffect()
	return true
end

function tosx_env_locust:MarkBoard()
	local pawns = extract_table(Board:GetPawns(TEAM_ANY))
	for i, v in ipairs(pawns) do
		if not Board:GetPawn(v):IsDead() then
			local p = Board:GetPawnSpace(v)
			Board:MarkSpaceImage(p,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
			Board:MarkSpaceDesc(p,"tosx_env_locusts_tile")
		end
	end
end

function tosx_env_locust:ApplyEffect()
	if Game:GetTurnCount() == 0 then return false end
	
	local effect = SkillEffect()
	effect.iOwner = ENV_EFFECT
	
	local pawns = extract_table(Board:GetPawns(TEAM_ANY))
	for i, v in ipairs(pawns) do
		if not Board:GetPawn(v):IsDead() then
			local p = Board:GetPawnSpace(v)
			damage = SpaceDamage(p,1)
			damage.sAnimation = "tosx_Polymetal"
			effect:AddSound("/mech/brute/pierce_mech/move")
			effect:AddSound("/mech/distance/scorpio_mech/move")
			effect:AddSound("/mech/distance/trimissile_mech/move")
			effect:AddDamage(damage)
			effect:AddDelay(0.7)
		end
	end	
    Board:AddEffect(effect)	
    
    return false
end
-------------------------------------------------------------------- 

function this:init(mod)
	TILE_TOOLTIPS.tosx_env_locusts_tile = {tosx_env_locust.Name, tosx_env_locust.Decription}
	Global_Texts["TipTitle_".."tosx_env_locust"] = tosx_env_locust.Name
	Global_Texts["TipText_".."tosx_env_locust"] = tosx_env_locust.Text
	
	modApi:appendAsset("img/effects/tosx_polymetal.png",mod.resourcePath.."img/effects/pilot_quicksilver.png")
	
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_locusts.png", mod.resourcePath .."img/combat/icon_env_locusts.png")
	Location["combat/tile_icon/tosx_icon_env_locusts.png"] = Point(-27,2) -- Needed for it to appear on tiles
	
	modApi:appendAsset("img/weapons/tosx_shieldtank_wep.png", mod.resourcePath .."img/weapons/tosx_shieldtank_wep.png")
	modApi:appendAsset("img/weapons/tosx_repairtank_wep.png", mod.resourcePath .."img/weapons/tosx_repairtank_wep.png")
	
	modApi:appendAsset("img/units/mission/tosx_shieldtank.png", mod.resourcePath .."img/units/mission/tosx_shieldtank.png")
	modApi:appendAsset("img/units/mission/tosx_shieldtanka.png", mod.resourcePath .."img/units/mission/tosx_shieldtanka.png")
	modApi:appendAsset("img/units/mission/tosx_shieldtank_death.png", mod.resourcePath .."img/units/mission/tosx_shieldtank_death.png")
	modApi:appendAsset("img/units/mission/tosx_shieldtank_ns.png", mod.resourcePath .."img/units/mission/tosx_shieldtank_ns.png")
	
	local a = ANIMS

	a.tosx_ShieldTank = a.ShieldTank1:new{Image = "units/mission/tosx_shieldtank.png"}
	a.tosx_ShieldTanka = a.ShieldTank1a:new{Image = "units/mission/tosx_shieldtanka.png"}
	a.tosx_ShieldTankd = a.ShieldTank1d:new{Image = "units/mission/tosx_shieldtank_death.png"}
	a.tosx_ShieldTank_ns  = a.ShieldTank1_ns:new{ Image = "units/mission/tosx_shieldtank_ns.png"}
	
	a.tosx_Polymetal = Animation:new{
		Image = "effects/tosx_polymetal.png",
		NumFrames = 10,
		Time = 0.05,
		PosX = -33,
		PosY = -14
	}
end

function this:load(mod, options, version)
	-- corpMissions.Add_Missions_High("Mission_tosx_Locusts", "Corp_Snow")
	corpIslandMissions.Add_Missions_High("Mission_tosx_Locusts", "pinnacle")
end

return this