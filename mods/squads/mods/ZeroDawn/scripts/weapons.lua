local wt2 = {		
	ZeroDawn_Science_NavRelay_Upgrade1 = "Charge",
	ZeroDawn_Science_NavRelay_Upgrade2 = "Reactivate",

	ZeroDawn_Prime_ZetaCannon_Upgrade1 = "+1 Damage End",
	ZeroDawn_Prime_ZetaCannon_Upgrade2 = "+1 Damage All",

	ZeroDawn_Brute_ForceLoader_Upgrade1 = "Impact",
	ZeroDawn_Brute_ForceLoader_Upgrade2 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

-----------------------------
-- Tall Mech weapons
-----------------------------
ZeroDawn_Science_NavRelay = Skill:new{  
	Name = "Navigation Relay",
	Description = "Command all Mechs to push in the same direction. Upgrade to command other actions.",
	Class = "Science",
	Icon = "weapons/gaia_science_navpulse.png",
	Rarity = 2,
	Damage = 0,
	PowerCost = 0,
	Charge = 0,
	Reactivate = 0,
	Upgrades = 2,
	ScorpControl = 0, --Used for testing; commands Scorpions as well
	--UpgradeList = { "Charge",  "Reactivate"  },
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(2,2),
		Friendly = Point(1,3),
		Friendly2 = Point(1,2),
		Target = Point(3,2),
	}
}
modApi:addWeaponDrop("ZeroDawn_Science_NavRelay")

function ZeroDawn_Science_NavRelay:GetTargetArea(p1)
	local ret = PointList()
	
	ret:push_back(Point(2,3))
	ret:push_back(Point(2,4))
	
	ret:push_back(Point(5,3))
	ret:push_back(Point(5,4))
	
	ret:push_back(Point(3,2))
	ret:push_back(Point(4,2))
	
	ret:push_back(Point(3,5))
	ret:push_back(Point(4,5))
	
	if self.Charge == 1 then
		ret:push_back(Point(1,3))
		ret:push_back(Point(1,4))
		
		ret:push_back(Point(6,3))
		ret:push_back(Point(6,4))
		
		ret:push_back(Point(3,1))
		ret:push_back(Point(4,1))
		
		ret:push_back(Point(3,6))
		ret:push_back(Point(4,6))
	end
	
	local returncenter = 0
	if Board:GetSize() == Point(6, 6) then
		returncenter = 1
	else
		local mechs = extract_table(Board:GetPawns(TEAM_MECH))
		-- First check each pawn to find the psions
		for i,id in pairs(mechs) do		
			local pawn = Board:GetPawn(id)
			if not pawn:IsActive() then
				returncenter = 1
				break
			end
		end
		if self.ScorpControl == 1 then
			local foes = extract_table(Board:GetPawns(TEAM_ANY))
			-- First check each pawn to find the psions
			for i,id in pairs(foes) do		
				local pawn = Board:GetPawn(id)
				if pawn:GetType() == "Scorpion1" then
					returncenter = 1
					break
				end
			end
		end
	end
	
	if self.Reactivate == 1 and returncenter == 1 then
		ret:push_back(Point(3,3))
		ret:push_back(Point(3,4))
		
		ret:push_back(Point(4,3))
		ret:push_back(Point(4,4))
	end
	
	return ret
end

function ZeroDawn_Science_NavRelay:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = DIR_NONE
	local mode = 0
	
	if (p2.x == 3 or p2.x == 4) and (p2.y == 3 or p2.y == 4) then
		dir = DIR_LEFT
		mode = 3
	else
		if p2.x <= 2 then
			dir = DIR_LEFT
			mode = 3 - p2.x --2 = charge 1, 1 = push
		elseif p2.x >= 5 then
			dir = DIR_RIGHT
			mode = p2.x - 4 --2 = charge 1, 1 = push
		elseif p2.y <= 2 then
			dir = DIR_UP
			mode = 3 - p2.y --2 = charge 1, 1 = push
		elseif p2.y >= 5 then
			dir = DIR_DOWN
			mode = p2.y - 4 --2 = charge 1, 1 = push
		end
	end
	
	local damage0 = SpaceDamage(p1, 0)
	if mode == 1 then
		-- Blue pulse (Push)
		damage0.sAnimation = "Gaia_NavPulse1"
		damage0.sSound = "/weapons/science_enrage_launch"
	elseif mode == 2 then
		-- Green pulse (Charge)
		damage0.sAnimation = "Gaia_NavPulse2"
		damage0.sSound = "/weapons/control_enrage"
	else
		-- Purple pulse (Reactivate)
		damage0.sAnimation = "Gaia_NavPulse3"
		damage0.sSound = "/weapons/grid_defense"
	end
	ret:AddDamage(damage0)
	ret:AddDelay(0.5)

	local vacatedpoints = PointList()
	local blockedpoints = PointList()	
	
	for i = 0, 7 do
		for j = 0, 7  do
			local point = Point(i,j) -- DIR_LEFT
			if dir == DIR_RIGHT then
				point = Point(7 - i, j)
			elseif dir == DIR_UP then
				point = Point(j,i)
			elseif dir == DIR_DOWN then
				point = Point(j,7-i)
			end
			
			if Board:IsPawnSpace(point) then
				local pawn = Board:GetPawn(point)
				if (pawn:IsMech() or (pawn:GetType() == "Scorpion1" and self.ScorpControl == 1)) and (not pawn:IsDead()) then --scorpion
					--This is a pawn that's being commanded
					if mode == 1 then
						-- Push
						local damage = SpaceDamage(point, 0)
						damage.sAnimation = "Gaia_NavRing1"
						ret:AddDamage(damage)
						
						local point2 = point + DIR_VECTORS[dir]--direction?
						if Board:IsValid(point2) then
							local damage = SpaceDamage(point2, 0, dir)
							damage.sAnimation = "airpush_"..dir
							ret:AddDamage(damage)
							ret:AddDelay(0.2)
						end
					elseif mode == 3 then
						-- Damage self, reactivate others
						local damage = SpaceDamage(point, 0)						
						if point == p1 then
							damage.iDamage = 3
							ret:AddDamage(damage)
						elseif not pawn:IsDead() and (not pawn:IsActive() or Board:GetSize() == Point(6, 6)) then
							damage.sImageMark = "combat/icons/icon_nav_energized_glow.png"
							damage.sAnimation = "Gaia_NavRing3"
							ret:AddDamage(damage)
							
							ret:AddScript([[
								local self = Point(]].. point:GetString() .. [[)
								Board:GetPawn(self):SetActive(true)
							]])
						end
						ret:AddDelay(0.2)
					else
						-- Move
						local damage = SpaceDamage(point, 0)
						damage.sAnimation = "Gaia_NavRing2"
						ret:AddDamage(damage)
						ret:AddDelay(0.2)
						
						local chargepoint = point
						
						local point2 = point + DIR_VECTORS[dir]
						
						if (not Board:IsBlocked(point2, PATH_PROJECTILE) or 
						list_contains(extract_table(vacatedpoints), point2)) and
						not list_contains(extract_table(blockedpoints), point2) then
							vacatedpoints:push_back(chargepoint)
							chargepoint = point2
						else
							blockedpoints:push_back(chargepoint)
						end
						blockedpoints:push_back(chargepoint)
						ret:AddCharge(Board:GetPath(point, chargepoint, PATH_FLYER), NO_DELAY)
					end
				end
			end
		end
	end
	
	local count = Board:GetEnemyCount()
	ret:AddScript(string.format([[
		local fx = SkillEffect();
		fx:AddScript("if %s - Board:GetEnemyCount() >= 2 then gaiasquad_Chievo('gaia_navkills') end")
		Board:AddEffect(fx);
	]], count))
	
	return ret
end

ZeroDawn_Science_NavRelay_A = ZeroDawn_Science_NavRelay:new{
	UpgradeDescription = "Mechs can be commanded to charge 1 tile.",
	Charge = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(2,2),
		Friendly = Point(1,3),
		Friendly2 = Point(1,2),
		Target = Point(3,2),
		Second_Target = Point(3,1),
		Second_Origin = Point(2,3),
	}
}

ZeroDawn_Science_NavRelay_B = ZeroDawn_Science_NavRelay:new{
	UpgradeDescription = "Damage self to allow other Mechs that have acted this turn to act again.",
	Reactivate = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(2,2),
		Friendly = Point(1,3),
		Friendly2 = Point(1,2),
		Target = Point(3,2),
		Second_Target = Point(3,3),
		Second_Origin = Point(2,3),
	}
}

ZeroDawn_Science_NavRelay_AB = ZeroDawn_Science_NavRelay:new{
	Charge = 1,
	Reactivate = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(2,2),
		Friendly = Point(1,3),
		Friendly2 = Point(1,2),
		Target = Point(3,2),
		Second_Target = Point(3,1),
		Second_Origin = Point(2,3),
	}
}

-----------------------------
-- Thunder Mech weapons
-----------------------------
ZeroDawn_Prime_ZetaCannon = Skill:new{  
	Name = "Zeta Cannon",
	Description = "Fires a piercing barrage that damages all targets in its path, and pushes behind the shooter.",
	Class = "Prime",
	Icon = "weapons/gaia_prime_zeta.png",
	Rarity = 2,
	Range = INT_MAX,
	BurstSound = "/weapons/burst_beam",
	ImpactSound = "/weapons/phase_shot",
	Damage = 1,
	MidDamage = 1,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = { 1,3 },
	--UpgradeList = { "+1 Damage End" , "+1 Damage All" },
	Coolant = 0,
	ScorpControl = 0, --Used for testing; freezes off Scorpions as well
	ProjectileArt = "effects/gaia_shot_zeta",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,4),
		Enemy2 = Point(2,1),
		Enemy3 = Point(2,2),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("ZeroDawn_Prime_ZetaCannon")

function ZeroDawn_Prime_ZetaCannon:GetTargetArea(p1)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.Range do
			local point = p1 + DIR_VECTORS[i]*k
			if not Board:IsValid(point) then
				break
			end
			ret:push_back(point)
		end
	end
	
	return ret
end

function ZeroDawn_Prime_ZetaCannon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local backwards = GetDirection(p1 - p2)
	local target = p2
	
	local targetback = p1 + DIR_VECTORS[backwards]
	local distance = p1:Manhattan(target)	
	
	-- Push behind
	local damage0 = SpaceDamage(targetback, 0, backwards)
	damage0.sAnimation = "airpush_"..backwards	
	ret:AddMelee(p1, damage0, NO_DELAY)
	
	-- Piercing tile projectiles
	local alternate = 0
	if distance > 1 then
		local point2 = p1 + DIR_VECTORS[direction]
		for i = 1,distance-1 do
			local damage = SpaceDamage(point2, self.MidDamage)
			if i == 1 then --hide at range 1 to remove UI dots
				damage.bHide = true
				damage.iDamage = 0
			end
			damage.sAnimation = "ExploArt0"
			ret:AddProjectile(damage, self.ProjectileArt..tostring(alternate), NO_DELAY)	
			ret:AddSound(self.BurstSound)
			ret:AddDelay(0.1)
			alternate = (alternate + 1)%2
			if i == 1 then --add the actual damage at range 1
				local dummy = SpaceDamage(point2, self.MidDamage)	
				ret:AddDamage(dummy)
			end
			point2 = point2 + DIR_VECTORS[direction]
		end
	end
		
	-- Main projectile cluster shot
	local damage = SpaceDamage(target, 0)
	if self.Damage > 1 then
		for i = 1,(self.Damage-1) do
			damage.bHide = true
			ret:AddProjectile(damage, self.ProjectileArt..tostring(alternate), NO_DELAY)	
			ret:AddSound(self.BurstSound)
			ret:AddDelay(0.1)
			alternate = (alternate + 1)%2
		end
	end
	
	damage.bHide = false
	damage.iDamage = self.Damage
	damage.sAnimation = "ExploArt"..tostring(self.Damage-1)
	if distance == 1 then --hide at range 1 to remove UI dots
		damage.bHide = true
		damage.iDamage = 0
	end
	ret:AddProjectile(damage, self.ProjectileArt..tostring(alternate), NO_DELAY)	
	ret:AddSound(self.BurstSound)
	
	if distance == 1 then
		ret:AddDelay(0.2)
		local dummy = SpaceDamage(target, self.Damage)	
		ret:AddDamage(dummy)
	end
	
	-- Add any ice
	local delaysofar = 0
	if self.Coolant == 1 then
		for i = 1,distance do
			local midpoint = p1 + DIR_VECTORS[direction]*i
			if Board:IsPawnSpace(midpoint) then
				if Board:GetPawn(midpoint):IsMech() or (self.ScorpControl == 1 and Board:GetPawn(midpoint):GetType() == "Scorpion1") then --scorpion
					ret:AddDelay(i * 0.08 - delaysofar)
					delaysofar = i * 0.08
					
					for j = 1,2 do
						local sidedir = (direction + j * 2 - 1)%4 --j+1, j+3
						local sidepoint = midpoint + DIR_VECTORS[sidedir]
						if Board:IsValid(sidepoint) then
							local freezedamage = SpaceDamage(sidepoint, 0)
							freezedamage.iFrozen = EFFECT_CREATE
							freezedamage.sAnimation = "gaia_zeta_iceblast_"..sidedir
							ret:AddDamage(freezedamage)
						end
					end
				end
			end
		end
	end
	
	if distance >= 7 then
		local count = Board:GetEnemyCount()
		ret:AddScript(string.format([[
			local fx = SkillEffect();
			fx:AddScript("if %s - Board:GetEnemyCount() >= 2 then gaiasquad_Chievo('gaia_zeta') end")
			Board:AddEffect(fx);
		]], count))
	end
	
	return ret
end

ZeroDawn_Prime_ZetaCannon_A = ZeroDawn_Prime_ZetaCannon:new{
	UpgradeDescription = "Increases damage to last tile by 1.",
	Damage = 2,
}

ZeroDawn_Prime_ZetaCannon_B = ZeroDawn_Prime_ZetaCannon:new{
	UpgradeDescription = "Increases damage to all tiles by 1.",
	Damage = 2,
	MidDamage = 2,
}

ZeroDawn_Prime_ZetaCannon_AB = ZeroDawn_Prime_ZetaCannon:new{
	Damage = 3,
	MidDamage = 2,
}

-----------------------------
-- Earth Mech weapons
-----------------------------
ZeroDawn_Brute_ForceLoader = Skill:new{  
	Name = "Force Loader",
	Description = "Fling units on 3 adjacent tiles away from Mech, damaging them.",
	Class = "Brute",
	Icon = "weapons/gaia_brute_forceloader.png",
	Rarity = 2,
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound = "/impact/dynamic/rock",
	Damage = 1,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Impact",  "+1 Damage"  },
	Impact = 0,
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,4),
		Friendly = Point(3,3),
		Enemy = Point(2,3),
		Enemy2 = Point(1,3),
		Enemy3 = Point(1,1),
		Target = Point(2,3)
	}
}
modApi:addWeaponDrop("ZeroDawn_Brute_ForceLoader")

function ZeroDawn_Brute_ForceLoader:GetTargetArea(p1)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[i]
		if Board:IsValid(point) then
			ret:push_back(point)
		end
	end	
	return ret
end

function ZeroDawn_Brute_ForceLoader:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local dir_array = {DIR_NONE, (direction + 1)%4, (direction + 3)%4} -- Order of flung targets
	local delay_array = {-1, -1, -1}
	local landing_array = {Point(-1,-1), Point(-1,-1), Point(-1,-1)}
	
	-- First do floating particles on all tiles, then wait
	for i = 1,3 do
		local point = p2
		if dir_array[i] < 4 then
			point = p2 + DIR_VECTORS[dir_array[i]]
		end
		ret:AddBounce(point,-3)
		
		-- Create some floating particles
		local damage = SpaceDamage(point,0)
		damage.sAnimation = "Gaia_ForceRocks"--update!		
		ret:AddDamage(damage)
		ret:AddEmitter(point,"Emitter_Gaia_ForceLoader")
		
	end
	ret:AddDelay(0.4)

	-- Now damage and fling
	for i = 1,3 do
		local point = p2
		if dir_array[i] < 4 then
			point = p2 + DIR_VECTORS[dir_array[i]]
		end
	
		if Board:IsPawnSpace(point) then
			-- Damage, air animation. Does damage need to be dealt after fling?
			local damage2 = SpaceDamage(point, 0)--self.Damage)
			damage2.sAnimation = "airpush_"..GetDirection(p1 - p2)
			ret:AddDamage(damage2)		
		
			-- Get end of path
			local target = GetProjectileEnd(point,point + DIR_VECTORS[direction],PATH_PROJECTILE)
			local distance = point:Manhattan(target)
			if not Board:IsBlocked(target,PATH_PROJECTILE) then
				target = target + DIR_VECTORS[direction]
			end
			if target ~= point and not Board:GetPawn(point):IsGuarding() then
				ret:AddCharge(Board:GetPath(point, target - DIR_VECTORS[direction], PATH_FLYER), NO_DELAY)
				delay_array[i] = distance * 0.06
				landing_array[i] = target
			else
				-- It's on an edge, still need to damage it
				local damage3 = SpaceDamage(point, self.Damage)
				ret:AddDamage(damage3)
			end
		end
	end
	
	-- Try to get the damage and pushes to correspond with each flung unit reaching its destination
	local sumdelay = 0
	local currdelay = -1
	local i = 0
	while i < 8*0.06 do
		for j = 1,3 do
			if math.abs(delay_array[j] - i) < 0.001 then -- Rounding errors; can't compare exact
				currdelay = i
			end
		end
		if currdelay == i then
			ret:AddDelay(currdelay - sumdelay)
			sumdelay = currdelay
			for j = 1,3 do
				if math.abs(delay_array[j] - i) < 0.001 then
					local midpoint = landing_array[j] - DIR_VECTORS[direction]
					local damage3 = SpaceDamage(midpoint, self.Damage)
					ret:AddDamage(damage3)
					
					if self.Impact == 1 then
						local damage4 = SpaceDamage(landing_array[j], 0, direction)
						damage4.sAnimation = "airpush_"..direction
						ret:AddDamage(damage4)
					end
				end
			end
		end	
		i = i + 0.06
	end
	
	return ret
end

ZeroDawn_Brute_ForceLoader_A = ZeroDawn_Brute_ForceLoader:new{
	UpgradeDescription = "Flung units push whatever they hit.",
	Impact = 1,
}

ZeroDawn_Brute_ForceLoader_B = ZeroDawn_Brute_ForceLoader:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

ZeroDawn_Brute_ForceLoader_AB = ZeroDawn_Brute_ForceLoader:new{
	Impact = 1,
	Damage = 2,
}