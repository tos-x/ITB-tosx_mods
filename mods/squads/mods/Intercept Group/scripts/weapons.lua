local mod = mod_loader.mods[modApi.currentMod]
local worldConstants = require(mod.scriptPath.."libs/worldConstants")

local wt2 = {
	tosx_Prime_ThermalLance_Upgrade1 = "+1 Max Damage",
	tosx_Prime_ThermalLance_Upgrade2 = "+1 Max Damage",
	
	tosx_Brute_Shockwave_Upgrade1 = "+1 Phasing",
	tosx_Brute_Shockwave_Upgrade2 = "+1 Phasing",
	
	tosx_Ranged_Concussion_Upgrade1 = "Ignite",
	tosx_Ranged_Concussion_Upgrade2 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end



tosx_Prime_ThermalLance = Skill:new{  
	Name = "Focused Beam",
	Description = "Fire a controlled beam that decreases in damage the more tiles it hits.",
	Icon = "weapons/tosx_weapon_focusbeam.png",
	Class = "Prime",
	Rarity = 2,
	MinDamage = 1,
	Damage = 3,
	PowerCost = 0,
	Grid = false,
	LaserArt = "effects/tosx_heatlaser",
	LaunchSound = "/weapons/fire_beam",
	Upgrades = 2,
	UpgradeCost = {2, 3},
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,1),
		Enemy = Point(2,2),
		Target = Point(2,0),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Prime_ThermalLance")

local function fireCheck(p)
	return Board:IsFire(p) or (Board:IsPawnSpace(p) and Board:GetPawn(p):IsFire())
end

local function fireUnitCheck(p)
	return Board:IsPawnSpace(p) and (Board:IsFire(p) or Board:GetPawn(p):IsFire())
end

function tosx_Prime_ThermalLance:GetTargetArea(p1)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		for k = 1, self.Damage do
			local curr = p1 + DIR_VECTORS[i]*k
			if Board:IsValid(curr) then
				ret:push_back(curr)
			else
				break
			end
		end
	end
	
	return ret	
end

function tosx_Prime_ThermalLance:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)
	local amount = self.Damage + 1 - distance
	
	for k = 1, distance do
		local curr = p1 + DIR_VECTORS[dir]*k
		local damage = SpaceDamage(curr, amount)
		if Board:IsBuilding(curr) and self.Grid then
			damage.iDamage = DAMAGE_ZERO
		end
		if k == distance then
			ret:AddProjectile(damage,self.LaserArt)
		else
			ret:AddDamage(damage)
		end
	end
	
	if not Board:IsTipImage() and distance == 3 then
		ret:AddScript([[
			local mission = GetCurrentMission()
			if mission then
				if not mission.tosx_intercept_peak then mission.tosx_intercept_peak = 0 end
				mission.tosx_intercept_peak = mission.tosx_intercept_peak + 1
				if mission.tosx_intercept_peak >= 4 then
					tosx_interceptsquad_Chievo("tosx_intercept_peak")
				end
			end
		]])
	end
	
	return ret
end

tosx_Prime_ThermalLance_A = tosx_Prime_ThermalLance:new{
	UpgradeDescription = "Increases max damage by 1.",
	Damage = 4,
}

tosx_Prime_ThermalLance_B = tosx_Prime_ThermalLance:new{
	UpgradeDescription = "Increases max damage by 1.",
	Damage = 4,
}

tosx_Prime_ThermalLance_AB = tosx_Prime_ThermalLance:new{
	Damage = 5,
}


tosx_Brute_Shockwave = Skill:new{  
	Name = "Shockwave Engine",
	Description = "Dash in a line, pushing 3 tiles on either side when you stop.",
	Icon = "weapons/tosx_weapon_shockwave.png",
	Class = "Brute",
	ShockSound = "/weapons/modified_cannons",
	LaunchSound = "/weapons/charge",
	Upgrades = 2,
	Obstacles = 0,
	Damage = 0,
	UpgradeCost = {1, 2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Enemy2 = Point(1,1),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Brute_Shockwave")

function tosx_Brute_Shockwave:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local max_i = 0
		local obstacles = 0
		for i = 1,7 do
			local point = p1 + DIR_VECTORS[dir]*i
			if not Board:IsBlocked(point, Pawn:GetPathProf()) then
				max_i = i
			end
			if Board:IsBlocked(point, PATH_PROJECTILE) then
				obstacles = obstacles + 1
				if obstacles > self.Obstacles then
					break
				end
			elseif Board:IsBlocked(point, Pawn:GetPathProf()) then
				break
			end
		end
		for i = 1,max_i do
			local point = p1 + DIR_VECTORS[dir]*i
			ret:push_back(point)
		end
	end
	return ret
end

function tosx_Brute_Shockwave:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local dir2 = GetDirection(p1 - p2)	
	local width = 3
	local behind = p1 + DIR_VECTORS[dir2]
	local target = p2
	
	if Board:IsBlocked(target, PATH_PROJECTILE) then
		-- p2 must be on an obstacle we're passing; march forward
		for i = 1, self.Obstacles do
			target = target + DIR_VECTORS[dir]
			if not Board:IsBlocked(target, PATH_PROJECTILE) then
				break
			end
		end
	end
	
	-- melee to emphasize speed.
	local damage0 = SpaceDamage(behind)
	damage0.bHide = true
	ret:AddMelee(p1, damage0, FULL_DELAY)
	
	-- Charge really fast
	local superspeed = 5
	worldConstants.SetSpeed(ret, superspeed)
	ret:AddCharge(Board:GetPath(p1, target, PATH_FLYER), NO_DELAY)
	worldConstants.ResetSpeed(ret)
	
	ret:AddSound(self.ShockSound)
	ret:AddBoardShake(1)
	
	for i = 0, width*2 do
		local p = target + DIR_VECTORS[(dir+1)%4]*(width - i)
		if Board:IsValid(p) and p ~= target then
			local damage = SpaceDamage(p, 0, dir)
			damage.sAnimation = "airpush_"..dir
			ret:AddDamage(damage)
			ret:AddBounce(p, 3)
		end
	end
	
	if not Board:IsTipImage() and p1:Manhattan(target) >= 6 then
		local count = Board:GetEnemyCount()
		ret:AddScript(string.format([[
			local fx = SkillEffect();
			fx:AddScript("if %s - Board:GetEnemyCount() >= 2 then tosx_interceptsquad_Chievo('tosx_intercept_throttle') end")
			Board:AddEffect(fx);
		]], count))
	end
	
	return ret
end

tosx_Brute_Shockwave_A = tosx_Brute_Shockwave:new{
	UpgradeDescription = "Mech can phase through 1 additional obstacle when charging.",
	Obstacles = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Enemy2 = Point(1,1),
		Building = Point(2,2),
		Target = Point(2,1),
	},
}

tosx_Brute_Shockwave_B = tosx_Brute_Shockwave:new{
	UpgradeDescription = "Mech can phase through 1 additional obstacle when charging.",
	Obstacles = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Enemy2 = Point(1,1),
		Building = Point(2,2),
		Target = Point(2,1),
	},
}

tosx_Brute_Shockwave_AB = tosx_Brute_Shockwave:new{
	Obstacles = 2,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(3,1),
		Enemy2 = Point(1,1),
		Building = Point(2,2),
		Building2 = Point(2,3),
		Target = Point(2,1),
	},
}


tosx_Ranged_Concussion = Skill:new{  
	Name = "Concussion Artillery",
	Description = "Damage a tile and push 2 tiles on either side.",
	Icon = "weapons/tosx_weapon_concussion.png",
	Damage = 1,
	Class = "Ranged",
	ArtillerySize = 8,
	LaunchSound = "/weapons/heavy_rocket", 
	ImpactSound = "/weapons/mercury_fist",
	UpShot = "effects/tosx_shotup_seeker.png",
	Explo = "ExploArt1",
	Upgrades = 2,
	Fire = false,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(1,1),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Ranged_Concussion")

function tosx_Ranged_Concussion:GetTargetArea(p1)
	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			ret:push_back(curr)
		end
	end
	return ret	
end

function tosx_Ranged_Concussion:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = self.Explo
	
	if self.Fire then
		damage.iFire = EFFECT_CREATE
	end
	
	ret:AddBounce(p1, 3)
	ret:AddArtillery(damage, self.UpShot)
	ret:AddBounce(p2, 3)
	for j = 2,1,-1 do
		for i = 1,3,2 do
			local d = (direction+i)%4
			local p = p2 + DIR_VECTORS[d]*j
			local damage2 = SpaceDamage(p,0,d)
			damage2.sAnimation = "airpush_"..d
			
			ret:AddDamage(damage2)
		end
		ret:AddDelay(0.1)
	end
	
	return ret
end

tosx_Ranged_Concussion_A = tosx_Ranged_Concussion:new{
	UpgradeDescription = "Lights target tile on Fire.",
	Fire = true,
	Explo = "ExploArt2",
}

tosx_Ranged_Concussion_B = tosx_Ranged_Concussion:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Ranged_Concussion_AB = tosx_Ranged_Concussion:new{
	Fire = true,
	Damage = 2,
	Explo = "ExploArt2",
}