local mod = mod_loader.mods[modApi.currentMod]
require(mod.scriptPath.."libs/boardEvents")

local wt2 = {
	tosx_Prime_Boomerang_Upgrade1 = "Range & Damage",
	tosx_Prime_Boomerang_Upgrade2 = "Pierce & Damage",
	
	tosx_Brute_Pincer_Upgrade1 = "Building Anchor",
	tosx_Brute_Pincer_Upgrade2 = "+1 Damage",
	
	tosx_Ranged_Trap_Upgrade1 = "Ally Immune",
	tosx_Ranged_Trap_Upgrade2 = "+2 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end



tosx_Prime_Boomerang = Skill:new{  
	Name = "Arc Blade",
	Description = "Launch a returning blade that damages and pushes.",
	Icon = "weapons/tosx_weapon_arc.png",
	Damage = 1,
	Range = 2,
	Class = "Prime",
	ProjectileArt = "effects/tosx_shot_disc",
	Exploart = "SwipeClaw2",
	LaunchSound = "/weapons/sword",
	TurnSound = "/weapons/sword",
	TwoClick = true,
	Pierce = false,
	Upgrades = 2,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(1,2),
		Second_Click = Point(1,1),
	},
}
modApi:addWeaponDrop("tosx_Prime_Boomerang")

function tosx_Prime_Boomerang:GetTargetArea(p1)
	--This new target style doesn't let you select a unit, only empty tiles.
	local ret = PointList()

	for dir = DIR_START, DIR_END do
		for i = 1, self.Range do
			local curr = Point(p1 + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
		
			ret:push_back(curr)  --Normally, this would go before the if statement above.
			
			if Board:IsBlocked(curr,PATH_PROJECTILE) then
				break
			end
		end
	end

	return ret
	
end

function tosx_Prime_Boomerang:IsTwoClickException(p1,p2)
	if Board:IsBlocked(p2, PATH_PROJECTILE) and (not self.Pierce) then
		return true
	end
	
	return false
end

function tosx_Prime_Boomerang:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	if Board:IsBlocked(p2, PATH_PROJECTILE) and (not self.Pierce) then
		local damage = SpaceDamage(p2, self.Damage, dir)
		damage.sAnimation = self.Exploart
		ret:AddProjectile(damage, self.ProjectileArt, FULL_DELAY)
	else
		local damage = SpaceDamage(p2)
		if self.Pierce and Board:IsBlocked(p2, PATH_PROJECTILE) then
			damage.iDamage = self.Damage
		else
			damage.sSound = self.TurnSound
		end
		ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
		ret:AddDelay(0.1 * p1:Manhattan(p2))
	end
	return ret
end

function tosx_Prime_Boomerang:GetSecondTargetArea(p1,p2)
	if Board:IsBlocked(p2, PATH_PROJECTILE) and (not self.Pierce) then
		return PointList()
	end
	local ret = PointList()
	
	local dir0 = GetDirection(p1 - p2)
	local dir00 = GetDirection(p2 - p1)
	for dir = DIR_START, DIR_END do
		if (dir ~= dir0) and (dir ~= dir00) then
			for i = 1, self.Range do
				local curr = Point(p2 + DIR_VECTORS[dir] * i)
				if not Board:IsValid(curr) then
					break
				end
			
				ret:push_back(curr)  --Normally, this would go before the if statement above.
				
				if Board:IsBlocked(curr,PATH_PROJECTILE) then
					break
				end
			end
		end
	end

	return ret
end

function tosx_Prime_Boomerang:GetFinalEffect(p1,p2,p3)
	local ret = self:GetSkillEffect(p1,p2)
	
	local r1 = p1:Manhattan(p2)
	local r2 = p2:Manhattan(p3)
	local dir = GetDirection(p3 - p2)
	local dir1 = GetDirection(p1 - p2)
	local dir2 = GetDirection(p2 - p3)
	local p4 = p1 + DIR_VECTORS[dir] * r2
	local catch = false
	
	local eart = self.Exploart
	if ((dir - dir1 == 1) or (dir - dir1 == -3)) then
		eart = "tosx_SwipeClaw2b" --CCW
	end
	
	if Board:IsBlocked(p2, PATH_PROJECTILE) then
		local damage0 = SpaceDamage(p2)
		damage0.sAnimation = eart
		damage0.bHide = true
		ret:AddDamage(damage0)
	end
	
	if Board:IsBlocked(p3, PATH_PROJECTILE) then
		local damage = SpaceDamage(p3, self.Damage, dir)
		damage.sAnimation = eart
		ret:AddProjectile(p2, damage, self.ProjectileArt, FULL_DELAY)
	else
		local damage = SpaceDamage(p3, 0)
		damage.sSound = self.TurnSound
		ret:AddProjectile(p2, damage, self.ProjectileArt, NO_DELAY)
		ret:AddDelay(0.1 * r2)
		
		local temptarget = GetProjectileEnd(p3,p4,PATH_PROJECTILE)
		if temptarget:Manhattan(p3) > r1 then
			temptarget = p4
		end
		if Board:IsBlocked(temptarget, PATH_PROJECTILE) then
			local damage1 = SpaceDamage(temptarget, self.Damage, dir1)
			damage1.sAnimation = eart
			ret:AddProjectile(p3, damage1, self.ProjectileArt, FULL_DELAY)
		else
			local damage1 = SpaceDamage(p4, 0)
			damage1.sSound = self.TurnSound
			ret:AddProjectile(p3, damage1, self.ProjectileArt, NO_DELAY)
			ret:AddDelay(0.1 * r1)
			
			temptarget = GetProjectileEnd(p4,p1,PATH_PROJECTILE)
			local damage2 = SpaceDamage(temptarget, self.Damage, dir2)
			damage2.sAnimation = eart
			if temptarget == p1 then
				damage2.iDamage = 0
				damage2.sAnimation = eart
				catch = true
			end
			ret:AddProjectile(p4, damage2, self.ProjectileArt, FULL_DELAY)			
		end
	end
	
	if catch and not Board:IsTipImage() then
		local count = Board:GetEnemyCount()
		ret:AddScript(string.format([[
			local fx = SkillEffect();
			fx:AddScript("if %s - Board:GetEnemyCount() >= 2 then tosx_junglesquad_Chievo('tosx_jungle_return') end")
			Board:AddEffect(fx);
		]], count))
	end
	
	return ret
end

tosx_Prime_Boomerang_A = tosx_Prime_Boomerang:new{
	UpgradeDescription = "Increases range and damage by 1.",
	Damage = 2,
	Range = 3,
}

tosx_Prime_Boomerang_B = tosx_Prime_Boomerang:new{
	UpgradeDescription = "Increases damage by 1, and pierces targets at the first turn.",
	Damage = 2,
	Pierce = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(1,2),
		Enemy2 = Point(2,1),
		Second_Click = Point(1,1),
	},
}

tosx_Prime_Boomerang_AB = tosx_Prime_Boomerang:new{
	Damage = 3,
	Range = 3,
	Pierce = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(1,2),
		Enemy2 = Point(2,1),
		Second_Click = Point(1,1),
	},
} 



tosx_Brute_Pincer = Skill:new{  
	Name = "Retracting Claws",
	Description = "Damage and pull tiles on either side.",
	Icon = "weapons/tosx_weapon_pincer.png",
	Damage = 1,
	Class = "Brute",
	LaunchSound = "/weapons/titan_fist",
	Upgrades = 2,
	Anchor = false,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy = Point(1,2),
		Building = Point(3,2),
	},
}
modApi:addWeaponDrop("tosx_Brute_Pincer")

function tosx_Brute_Pincer:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		ret:push_back(curr)
	end
	
	return ret		
end

function tosx_Brute_Pincer:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local dir2 = GetDirection(p1 - p2)
	
	ret:AddSound("/weapons/grapple")
	
	local d = self.Anchor and self.MinDamage or self.Damage
	
	if self.Anchor then
		for i = 1,3,2 do
			local p = p2 + DIR_VECTORS[(dir+i)%4]
			if Board:IsValid(p) and Board:IsBuilding(p) then
				d = self.Damage
				break -- Max one building that matters
			end
		end
	end
	
	for i = 1,3,2 do
		local p = p2 + DIR_VECTORS[(dir+i)%4]
		if Board:IsValid(p) then
			local damage = SpaceDamage(p, d, dir2)
			damage.sAnimation = "explopunch1_"..dir2
			if self.Anchor and Board:IsBuilding(p) then
				damage.iDamage = DAMAGE_ZERO
				damage.sAnimation = "airpush_"..dir2
			end
			ret:AddDamage(damage)
		end
	end
	
	local damage0 = SpaceDamage(p2)
	ret:AddMelee(p1, damage0)
	
	return ret
end

tosx_Brute_Pincer_A = tosx_Brute_Pincer:new{
	UpgradeDescription = "This attack will no longer damage Grid Buildings, instead using them to increase damage.",
	MinDamage = 1,
	Damage = 3,
	Anchor = true,
}

tosx_Brute_Pincer_B = tosx_Brute_Pincer:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Brute_Pincer_AB = tosx_Brute_Pincer:new{
	MinDamage = 2,
	Damage = 4,
	Anchor = true,
}



tosx_Ranged_Trap = Skill:new{  
	Name = "Trap Launcher",
	Description = "Launch a trap at an empty tile, pushing tiles in front and behind.\n\nTrap deals damage when stepped on.",
	Icon = "weapons/tosx_weapon_trap.png",
	Damage = 3,
	Class = "Ranged",
	UpShot = "effects/tosx_shotup_trap.png",
	Back = false,
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/weapons/shrapnel",
	Upgrades = 2,
	ArtillerySize = 8,
	UpgradeCost = {1, 3},
	Trap = "tosx_Trap_Mine0",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,0),
		Enemy = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Ranged_Trap")

function tosx_Ranged_Trap:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			if not Board:IsBlocked(curr,PATH_PROJECTILE) then
				ret:push_back(curr)
			end
		end
	end
	
	return ret		
end

function tosx_Ranged_Trap:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local dir2 = GetDirection(p1 - p2)
	local p3 = p1 + DIR_VECTORS[dir2]
	
	if self.Back and Board:IsValid(p3) then
		local damageb = SpaceDamage(p3)
		if Board:IsBlocked(p3, PATH_GROUND) then
			damageb.sImageMark = "combat/icons/tosx_icon_itrap_off_glow.png"
		else
			damageb.sItem = self.Trap
			damageb.sImageMark = "combat/icons/tosx_icon_itrap_glow.png"
		end
		ret:AddDamage(damageb)
		local ds = SpaceDamage(p1)
		ds.sAnimation = "airpush_"..dir2
		ret:AddDamage(ds)
		ret:AddBounce(p3, 1)
	end
	
	local damage = SpaceDamage(p2)
	if Board:IsBlocked(p2, PATH_GROUND) then
		damage.sImageMark = "combat/icons/tosx_icon_itrap_off_glow.png"
	else
		damage.sItem = self.Trap
		damage.sImageMark = "combat/icons/tosx_icon_itrap_glow.png"
	end
	
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, self.UpShot)
	ret:AddBounce(p2, 1)
	
	local damagepush = SpaceDamage(p2 + DIR_VECTORS[dir], 0, dir)
	damagepush.sAnimation = "airpush_"..dir
	ret:AddDamage(damagepush) 
	damagepush = SpaceDamage(p2 + DIR_VECTORS[dir2], 0, dir2)
	damagepush.sAnimation = "airpush_"..dir2
	ret:AddDamage(damagepush)
	
	if Board:IsSpawning(p2) and not Board:IsTipImage() then
		ret:AddScript([[
			local mission = GetCurrentMission()
			if mission then
				if not mission.tosx_jungle_spawntrap then mission.tosx_jungle_spawntrap = 0 end
				mission.tosx_jungle_spawntrap = mission.tosx_jungle_spawntrap + 1
				if mission.tosx_jungle_spawntrap > 2 then
					tosx_junglesquad_Chievo('tosx_jungle_trapdoor')
				end
			end
		]])	
	end
	
	return ret
end

tosx_Ranged_Trap_A = tosx_Ranged_Trap:new{
	UpgradeDescription = "Friendly units will not take damage from traps.",
	Trap = "tosx_Trap_Mine0a",
}

tosx_Ranged_Trap_B = tosx_Ranged_Trap:new{
	UpgradeDescription = "Increases trap damage by 2.",
	Trap = "tosx_Trap_Mine1",
	Damage = 5,
}

tosx_Ranged_Trap_AB = tosx_Ranged_Trap:new{
	Trap = "tosx_Trap_Mine1a",
	Damage = 5,
}


----------------


local mdamage0 = SpaceDamage(3)
mdamage0.sSound = "/props/exploding_mine"
mdamage0.sAnimation = "ExploAir2"

tosx_Trap_Mine0 = {
	Image = "combat/tosx_itrap0.png",
	Damage = mdamage0,
	Tooltip = "tosx_Trap_Mine0",
	Icon = "combat/icons/tosx_icon_itrap_glow.png",
	UsedImage = ""
	}
	
tosx_Trap_Mine0a = {
	Image = "combat/tosx_itrap0a.png",
	Damage = SpaceDamage(0),
	Tooltip = "tosx_Trap_Mine0a",
	Icon = "combat/icons/tosx_icon_itrap_glow.png",
	UsedImage = ""
	}
	
local mdamage1 = SpaceDamage(5)
mdamage1.sSound = "/props/exploding_mine"
mdamage1.sAnimation = "ExploAir2"

tosx_Trap_Mine1 = {
	Image = "combat/tosx_itrap1.png",
	Damage = mdamage1,
	Tooltip = "tosx_Trap_Mine1",
	Icon = "combat/icons/tosx_icon_itrap_glow.png",
	UsedImage = ""
	}
	
tosx_Trap_Mine1a = {
	Image = "combat/tosx_itrap1a.png",
	Damage = SpaceDamage(0),
	Tooltip = "tosx_Trap_Mine1a",
	Icon = "combat/icons/tosx_icon_itrap_glow.png",
	UsedImage = ""
	}
	
TILE_TOOLTIPS[tosx_Trap_Mine0.Tooltip] = {"Trap", "Any unit that steps on this space will trigger the trap and take 3 damage."}
TILE_TOOLTIPS[tosx_Trap_Mine0a.Tooltip] = {"Vek Trap", "Any enemy that steps on this space will trigger the trap and take 3 damage."}
TILE_TOOLTIPS[tosx_Trap_Mine1.Tooltip] = {"Upgraded Trap", "Any unit that steps on this space will trigger the trap and take 5 damage."}
TILE_TOOLTIPS[tosx_Trap_Mine1a.Tooltip] = {"Upgraded Vek Trap", "Any enemy that steps on this space will trigger the trap and take 5 damage."}

BoardEvents.onItemRemoved:subscribe(function(loc, removed_item)
	local d = 0
	if removed_item == "tosx_Trap_Mine0a" then
		d = 3
	elseif removed_item == "tosx_Trap_Mine1a" then
		d = 5
	end
	
	if d > 0 then
		local pawn = Board:GetPawn(loc)
		if pawn then
			if pawn:GetTeam() == TEAM_PLAYER then
				-- do nothing
			else
				local damage2 = SpaceDamage(loc, d)
				damage2.sSound = "/props/exploding_mine"
				damage2.sAnimation = "ExploAir2"
				Board:DamageSpace(damage2)
			end
		end
	end
end)

local function istosxmine(point)
	local item = Board:GetItem(point)
	if item and 
	   item == "tosx_Trap_Mine0" or
	   item == "tosx_Trap_Mine0a" or
	   item == "tosx_Trap_Mine1" or
	   item == "tosx_Trap_Mine1a" then
		return true
	else
		return false
	end
end

BoardEvents.onTerrainChanged:subscribe(function(p, terrain, terrain_prev)
	if istosxmine(p) then
		if terrain == TERRAIN_HOLE or terrain == TERRAIN_WATER then
			Board:RemoveItem(p)
		end
	end
end)

-- Keep tumblebugs from instantly dropping rocks on mines
local oldCanSpawnRock = DungAtk1.CanSpawnRock
function DungAtk1:CanSpawnRock(point)
	if istosxmine(point) then return false end
	return oldCanSpawnRock(self, point)
end