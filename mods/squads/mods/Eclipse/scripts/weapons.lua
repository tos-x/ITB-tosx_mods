local wt2 = {	
	Ecl_Prime_Longrifle_Upgrade1 = "Scope",
	Ecl_Prime_Longrifle_Upgrade2 = "+1 Use",
	
	Ecl_Support_Autoloader_Upgrade1 = "Acid Rounds",
	Ecl_Support_Autoloader_Upgrade2 = "Reposition" ,
	
	Ecl_Ranged_Orion_Upgrade1 = "Airburst",
	Ecl_Ranged_Orion_Upgrade2 = "Smoke",
	
	Ecl_Science_Gravpulse_Upgrade1 = "+1 Range",
	Ecl_Science_Gravpulse_Upgrade2 = "Crush",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

-----------------------------
-- Reaper Mech weapons
-----------------------------
Ecl_Prime_Longrifle = TankDefault:new	{
	Name = "Long Rifle",
	Description = "Fire a powerful projectile at a target 2 or more tiles away, pushing yourself back.",
	Class = "Prime",
	Damage = 4,
	Icon = "weapons/ecl_longrifle.png",
	Rarity = 3,
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Push = 1,
	PowerCost = 0,
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	--ProjectileArt = "effects/shot_longrifle",
	Limited = 1,
	PushBack = true,
	Scope = 0,
	Upgrades = 2,
	--UpgradeList = { "Scope","+1 Use" },
	UpgradeCost = { 1 , 2 },
	TipImage = StandardTips.Ranged
}
modApi:addWeaponDrop("Ecl_Prime_Longrifle")

function Ecl_Prime_Longrifle:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local curr = point
		for i = 1, 8 do
			curr = point + DIR_VECTORS[dir]*i
			
			if i ~= 1 then
				ret:push_back(curr)
			end
			
			if Board:IsBlocked(curr, PATH_PROJECTILE) then
				if self.Scope == 0 then
					break
				elseif not (Board:IsBuilding(curr) or Board:GetPawnTeam(curr) == TEAM_PLAYER) then
					break
				end
			end
			
		end
	end
	
	return ret
end
			
function Ecl_Prime_Longrifle:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local beforep2 = p2 - DIR_VECTORS[direction]
	local target = GetProjectileEnd(beforep2,p2)
	
	if self.Scope == 1 then
		for i = 1,6 do
			if Board:IsBuilding(target) or Board:GetPawnTeam(target) == TEAM_PLAYER then
				target = GetProjectileEnd(target,target + DIR_VECTORS[direction])
			else
				break
			end
		end
	end
	
	local damage = SpaceDamage(target, self.Damage)
	ret:AddProjectile(damage, "effects/shot_longrifle",NO_DELAY)
	
	if self.PushBack then
		local backdir = GetDirection(p1-p2)
		damage = SpaceDamage(p1, 0, backdir)
		damage.sAnimation = "airpush_"..backdir
		ret:AddDamage(damage)
	end
	
	if Board:IsPawnSpace(target) then
		if Board:GetPawnTeam(target) == TEAM_ENEMY and Board:GetPawn(target):IsAcid() then
			ret:AddScript("tosx_eclipsesquad_Chievo('tosx_eclipse_shot')")
		end
	end
	
	return ret
end

Ecl_Prime_Longrifle_A = Ecl_Prime_Longrifle:new{
	UpgradeDescription = "Shoot through buildings and friendly units.",
	Scope = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,2),
		Target = Point(2,1)
	}
}

Ecl_Prime_Longrifle_B = Ecl_Prime_Longrifle:new{
	UpgradeDescription = "Increases uses per battle by 1.",
	Limited = 2,
}

Ecl_Prime_Longrifle_AB = Ecl_Prime_Longrifle:new{
	Scope = 1,
	Limited = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Building = Point(2,2),
		Target = Point(2,1)
	}
}
--
Ecl_Support_Autoloader = Skill:new{  
	Name = "Autoloader",
	Description = "Push a tile and refill weapon uses.",
	PathSize = 1,
	Icon = "weapons/ecl_reload.png",
	Rarity = 2,
	LaunchSound = "/weapons/science_repulse",
	Range = 1,
	PathSize = 1,
	Damage = 0,
	PowerCost = 0,
	Acid = 0,
	Push = 1,
	Upgrades = 2,
	TwoClick = false,
	--UpgradeList = { "Acid Rounds",  "Reposition"  },
	UpgradeCost = { 1,1 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "ECL_ReaperMech",
	}
}
modApi:addWeaponDrop("Ecl_Support_Autoloader")

function Ecl_Support_Autoloader:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		ret:push_back(DIR_VECTORS[i] + point)
	end
	
	return ret
end

function Ecl_Support_Autoloader:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p2
	
	local dload = SpaceDamage(p1)
	dload.sImageMark = "combat/icons/tosx_doubleshot_glow.png"
	ret:AddDamage(dload)
	
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "airpush_"..direction
	ret:AddBounce(p1,2)
	
	damage.iAcid = self.Acid
	
	ret:AddMelee(p2 - DIR_VECTORS[direction], damage, 0.2) --0.2 is the delay before the ammo animation
	ret:AddScript([[Pawn:ResetUses()]])
	
	local selfDamage = SpaceDamage(p1,0)
	selfDamage.sAnimation = "AmmoDrop1"
	selfDamage.bHide = true
	ret:AddDamage(selfDamage)
	
	return ret
end

Ecl_Support_Autoloader_A = Ecl_Support_Autoloader:new{
	UpgradeDescription = "Apply A.C.I.D. to target.",
	Acid = 1,
}

Ecl_Support_Autoloader_B = Ecl_Support_Autoloader:new{
	UpgradeDescription = "Leap away from the target.",
	Range = 7,
	TwoClick = true,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
		Second_Click = Point(2,4),
		CustomPawn = "ECL_ReaperMech",
	}
}

function Ecl_Support_Autoloader_B:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	local backwards = GetDirection(p1 - p2)
	
	for k = 1, self.Range do
		local curr = DIR_VECTORS[backwards]*k + p1
		if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
			ret:push_back(curr)
		end
	end
	return ret
end

function Ecl_Support_Autoloader_B:IsTwoClickException(p1,p2)
	local second_area = self:GetSecondTargetArea(p1,p2)
	if second_area:size() == 0 then
		return true
	end
	return false
end

function Ecl_Support_Autoloader_B:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage, direction)
	local move = PointList()
	
	local dload = SpaceDamage(p1)
	dload.sImageMark = "combat/icons/tosx_doubleshot_glow.png"
	ret:AddDamage(dload)
	
	damage = SpaceDamage(p2, self.Damage, direction)
	move:push_back(p1)
	move:push_back(p3)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)
	ret:AddLeap(move, NO_DELAY)
	damage.sAnimation = "airpush_"..direction
	ret:AddBounce(p1,2)
	
	damage.iAcid = self.Acid
	
	ret:AddMelee(p2 - DIR_VECTORS[direction], damage, 0.2) --0.2 is the delay before the ammo animation
	ret:AddScript([[Pawn:ResetUses()]])
	
	local selfDamage = SpaceDamage(p1,0)
	selfDamage.sAnimation = "AmmoDrop1"	
	selfDamage.bHide = true
	ret:AddDamage(selfDamage)
	
	return ret
end

Ecl_Support_Autoloader_AB = Ecl_Support_Autoloader_B:new{
	Acid = 1,
	Range = 7,
	TwoClick = true,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
		Second_Click = Point(2,4),
		CustomPawn = "ECL_ReaperMech",
	}
}

-----------------------------
-- Archangel Mech weapons
-----------------------------
Ecl_Ranged_Orion = ArtilleryDefault:new{
	Name = "Orion Missiles",
	Description = "Launch missiles at 2 tiles, pushing tiles in front of and behind them.",
	Class = "Ranged",
	Icon = "weapons/ecl_orionmissiles.png",
	Rarity = 2,
	Explosion = "",
	ExploArt = "explopush1_",
	Damage = 1,
	BounceAmount = 2,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList = {  "Airburst", "Smoke" },
	LaunchSound = "/weapons/dual_missiles",
	ImpactSound = "/impact/generic/explosion",
	Smoke = 0,
	Airburst = 0,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(1,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(3,1),
		Target = Point(2,2)
	}
}
modApi:addWeaponDrop("Ecl_Ranged_Orion")

function Ecl_Ranged_Orion:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local backwards = GetDirection(p1 - p2)
	
	local damage = SpaceDamage(p2 + DIR_VECTORS[(direction+1)%4], self.Damage)
	local push1a = SpaceDamage(damage.loc + DIR_VECTORS[(direction)], 0, direction)
	local push1b = SpaceDamage(damage.loc + DIR_VECTORS[(direction+2)%4], 0, backwards)
	
	local damage2 = SpaceDamage(p2 + DIR_VECTORS[(direction-1)%4], self.Damage)
	local push2a = SpaceDamage(damage2.loc + DIR_VECTORS[(direction)], 0, direction)
	local push2b = SpaceDamage(damage2.loc + DIR_VECTORS[(direction+2)%4], 0, backwards)
		
	ret:AddBounce(p1, 1)
	
	damage.sAnimation = self.ExploArt..direction
	damage2.sAnimation = self.ExploArt..direction
	if self.Smoke == 1 then
		damage.iSmoke = EFFECT_CREATE
		damage2.iSmoke = EFFECT_CREATE
	end
	
	---dummy artillery shots for the visual
	---it has actual art when fired, but hidden when aiming
	local dummy = SpaceDamage(damage.loc)
	dummy.bHide = true
	--dummy.sAnimation = self.ExploArt..direction
	ret:AddArtillery(dummy,"effects/shotup_orion_missile.png",NO_DELAY)
	dummy.loc = damage2.loc
	ret:AddArtillery(dummy,"effects/shotup_orion_missile.png",NO_DELAY)
	
	--invisible artillery shot for actual damage and projectile pathing
	--it has no art when fired, but visuals when aiming
	ret:AddArtillery(SpaceDamage(p2),"")
	
	ret:AddBounce(p2 + DIR_VECTORS[(direction+1)%4], self.BounceAmount)
	ret:AddBounce(p2 + DIR_VECTORS[(direction-1)%4], self.BounceAmount)
	
	if self.Airburst == 1 then
		local target = {damage.loc, damage2.loc}
		local middamage = false
		for i = 1, 2 do
			if Board:IsSmoke(target[i]) then
			
				if i == 1 then
					damage.iSmoke = EFFECT_REMOVE
					damage.sAnimation = ""
					damage.sImageMark = "combat/icons/tosx_smoke_immune_glow.png"
				else
					damage2.iSmoke = EFFECT_REMOVE
					damage2.sAnimation = ""
					damage2.sImageMark = "combat/icons/tosx_smoke_immune_glow.png"
				end
				--[[
				local unsmoke = SpaceDamage(target[i])
				unsmoke.iSmoke = EFFECT_REMOVE
				ret:AddDamage(unsmoke)--]]
				--negate building damage?
				
				
				for dir = DIR_START, DIR_END do
					point = target[i] + DIR_VECTORS[dir]
					if not Board:IsBuilding(point) then
						if point ~= p2 or (point == p2 and middamage == false) then
						
							if point == push1a.loc then
								push1a.iDamage = 2
								push1a.sAnimation = self.ExploArt..GetDirection(point - target[i])
							elseif point == push1b.loc then
								push1b.iDamage = 2
								push1b.sAnimation = self.ExploArt..GetDirection(point - target[i])
							elseif point == push2a.loc then
								push2a.iDamage = 2
								push2a.sAnimation = self.ExploArt..GetDirection(point - target[i])
							elseif point == push2b.loc then
								push2b.iDamage = 2
								push2b.sAnimation = self.ExploArt..GetDirection(point - target[i])
							else
								damage3 = SpaceDamage(point, 2)
								damage3.sAnimation = "ExploAir1"
								ret:AddDamage(damage3)
							end
							
							if point == p2 then
								middamage = true
							end
						end
					end
				end
			end
		end
	end
	
	ret:AddDamage(damage)
	ret:AddDamage(push1a)
	ret:AddDamage(push1b)
	ret:AddDamage(damage2)
	ret:AddDamage(push2a)
	ret:AddDamage(push2b)
		
	if self.Smoke == 1 and damage.iSmoke == EFFECT_CREATE and damage2.iSmoke == EFFECT_CREATE then
		if Board:IsPawnSpace(damage.loc) and Board:IsPawnSpace(damage2.loc) then
			if Board:GetPawnTeam(damage.loc) == TEAM_ENEMY and Board:GetPawnTeam(damage2.loc) == TEAM_ENEMY then
				ret:AddScript("tosx_eclipsesquad_Chievo('tosx_eclipse_dust')")
			end
		end
	end
	
	return ret
end	

Ecl_Ranged_Orion_A = Ecl_Ranged_Orion:new{
	UpgradeDescription = "Targeting Smoke deals 2 damage to adjacent tiles and removes the Smoke.",
	Airburst = 1,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(1,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(3,1),
		Target = Point(2,2),
		Building = Point(0,2),
		SmokeTile = Point(1,2)
	}
}	

Ecl_Ranged_Orion_B = Ecl_Ranged_Orion:new{
	UpgradeDescription = "Applies Smoke on targets.",
	Smoke = 1,
}

Ecl_Ranged_Orion_AB = Ecl_Ranged_Orion:new{
	Smoke = 1,
	Airburst = 1,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(1,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(3,1),
		Target = Point(2,2),
		Building = Point(0,2),
		SmokeTile = Point(1,2)
	}
}

-----------------------------
-- Force Mech weapons
-----------------------------
Ecl_Science_Gravpulse = TankDefault:new{
	Name = "Grav Pulse",
	Description = "Pushes adjacent units away from a nearby unoccupied tile.",
	Class = "Science",
	Icon = "weapons/ecl_gravpulse.png",
	Rarity = 3,
	Damage = 0,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList = { "+1 Range","Crush" },
	LaunchSound = "/weapons/enhanced_tractor",
	ImpactSound = "/impact/generic/tractor_beam",
	Crush = 0,
	Range = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Enemy3 = Point(2,0),
		Building = Point(1,2),
		Target = Point(1,2)
	}
}
modApi:addWeaponDrop("Ecl_Science_Gravpulse")

function Ecl_Science_Gravpulse:GetTargetArea(p1)	
	local ret = PointList()
	local size = self.Range
	
	local corner = p1 - Point(size, size)	
	local p = Point(corner)
		
	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = p1 - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and dist <= size then
			if not Board:IsPawnSpace(p) or self.Crush == 1 then
				ret:push_back(p)
			end
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end
	
	return ret
end

function Ecl_Science_Gravpulse:GetSkillEffect(p1, p2)--2
    local ret = SkillEffect()
	local count = 0
	
	local selfDamage = SpaceDamage(p2,0)
	selfDamage.sAnimation = "GravBlast1"
	ret:AddDamage(selfDamage)	
	--[[
	if not Board:IsPawnSpace(p2) then
		for dir = DIR_START, DIR_END do
			local point2 = p2 + DIR_VECTORS[dir]
			local damage2 = SpaceDamage(point2, 0, dir)
			damage2.sAnimation = "airpush_"..dir
			ret:AddDamage(damage2)
		end
	else
		for dir = DIR_START, DIR_END do
			local point2 = p2 + DIR_VECTORS[dir]
			local damage2 = SpaceDamage(point2, 0, (dir+2)%4)
			damage2.sAnimation = "airpush_"..(dir+2)%4
			ret:AddDamage(damage2)
		end
	end
	--]]
	for dir = DIR_START, DIR_END do
		local point2 = p2 + DIR_VECTORS[dir]
		if Board:IsValid(point2) then
			if not Board:IsPawnSpace(p2) then
				local damage2 = SpaceDamage(point2, 0, dir)
				damage2.sAnimation = "airpush_"..dir
				ret:AddDamage(damage2)
			else
				if Board:IsPawnSpace(point2) then count = count + 1 end
				local damage2 = SpaceDamage(point2, 0, (dir+2)%4)
				damage2.sAnimation = "airpush_"..(dir+2)%4
				ret:AddDamage(damage2)
			end
		end
	end
	ret:AddBoardShake(0.2)
    
	if count == 4 then
		ret:AddScript("tosx_eclipsesquad_Chievo('tosx_eclipse_hug')")
	end
	
	return ret
end

Ecl_Science_Gravpulse_A = Ecl_Science_Gravpulse:new{
	UpgradeDescription = "Extends range by 1 tile.",
	Range = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Enemy3 = Point(2,0),
		Building = Point(1,2),
		Target = Point(1,1)
	}
}

Ecl_Science_Gravpulse_B = Ecl_Science_Gravpulse:new{
	UpgradeDescription = "Can target units, pulling adjacent units into them.",
	Crush = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Friendly = Point(2,2),
		Enemy3 = Point(2,0),
		Building = Point(1,2),
		Target = Point(2,1),
		Second_Target = Point(1,2)
	}
}

Ecl_Science_Gravpulse_AB = Ecl_Science_Gravpulse:new{
	Range = 3,
	Crush = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Friendly = Point(2,2),
		Enemy3 = Point(2,0),
		Building = Point(1,2),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(1,1)
	}
}