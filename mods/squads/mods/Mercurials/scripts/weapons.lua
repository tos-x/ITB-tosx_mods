local wt2 = {
	tosx_Prime_Tendrils_Upgrade1 = "+1 Damage Each",
	tosx_Prime_Tendrils_Upgrade2 = "+1 Damage",
	
	tosx_Ranged_Needle_Upgrade1 = "+1 Damage Each",
	tosx_Ranged_Needle_Upgrade2 = "+1 Damage",
	
	tosx_Science_Splitter_Upgrade1 = "Artillery",
	tosx_Science_Splitter_Upgrade2 = "+1 Health ",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end



tosx_Prime_Tendrils = Skill:new{  
	Name = "Ablative Spines",
	Description = "Damage and push tiles on opposite sides. Mechs are healed instead.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_spines.png",
	Rarity = 3,
	PowerCost = 0,
	Damage = 2,
	SelfDamage = 1,
	Upgrades = 2,
	LaunchSound = "/weapons/sword",
	--UpgradeList = { "+1 Damage Each",  "+1 Damage"  },
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Friendly_Damaged = Point(2,3),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Prime_Tendrils")

function tosx_Prime_Tendrils:GetTargetArea(p1)	
	local ret = PointList()

	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		ret:push_back(curr)
	end
	
	return ret
end

function tosx_checkmutual(enemycount, m0, m1, m2)
	local mechsalive = {m0, m1, m2}
			
	if enemycount - Board:GetEnemyCount() >= 2 then
		-- 2 enemies were killed
		for i = 0,2 do
			if mechsalive[i+1] == 1 and Board:GetPawn(i) and Board:GetPawn(i):IsDead() then
				-- A mech is now dead that was alive
				tosx_mercurysquad_Chievo("tosx_mercury_mutual")
			end
		end
	end
end

function tosx_Prime_Tendrils:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local dir2 = GetDirection(p1 - p2)
	local p3 = p1 + DIR_VECTORS[dir2]
	
	local damage0 = SpaceDamage(p1, self.SelfDamage)
	ret:AddDamage(damage0)

	local damage1 = SpaceDamage(p2, self.Damage, dir)
	if Board:IsPawnSpace(p2) and Board:GetPawn(p2):IsMech() then
		damage1.iDamage = -1 * self.Damage
	end
	damage1.sAnimation = "tosx_metal_spike_"..dir
	ret:AddDamage(damage1)
	
	local damage2 = SpaceDamage(p3, self.Damage, dir2)
	if Board:IsPawnSpace(p3) and Board:GetPawn(p3):IsMech() then
		damage2.iDamage = -1 * self.Damage
	end
	damage2.sAnimation = "tosx_metal_spike_"..dir2
	ret:AddDamage(damage2)	
	
	if not Board:IsTipImage() then
		local enemycount = Board:GetEnemyCount()
		local m0, m1, m2 = 0, 0, 0
		if Board:GetPawn(0) and not Board:GetPawn(0):IsDead() then m0 = 1 end
		if Board:GetPawn(1) and not Board:GetPawn(1):IsDead() then m1 = 1 end
		if Board:GetPawn(2) and not Board:GetPawn(2):IsDead() then m2 = 1 end
		
		ret:AddScript([[
			local fx = SkillEffect();
			fx:AddScript("tosx_checkmutual(]]..enemycount..[[, ]]..m0..[[, ]]..m1..[[, ]]..m2..[[)")
			Board:AddEffect(fx);
		]])
	end
	
	return ret
end

tosx_Prime_Tendrils_A = tosx_Prime_Tendrils:new{
	UpgradeDescription = "Increases damage to self and targets by 1.",
	SelfDamage = 2,
	Damage = 3,
}

tosx_Prime_Tendrils_B = tosx_Prime_Tendrils:new{
	UpgradeDescription = "Increases damage to targets by 1.",
	Damage = 3,
}

tosx_Prime_Tendrils_AB = tosx_Prime_Tendrils:new{
	SelfDamage = 2,
	Damage = 4,
}



tosx_Ranged_Needle = Skill:new{  
	Name = "Needle Launcher",
	Description = "Launches a liquid metal projectile that deals damage. Mechs are healed instead.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_needle.png",
	Rarity = 2,
	ArtillerySize = 8,
	BounceAmount = 3,
	PowerCost = 0,
	Upgrades = 2,
	Damage = 3,
	SelfDamage = 1,
	LaunchSound = "/weapons/sword",--!!!
	ImpactSound = "/weapons/pierce_shot",--!!!
	--UpgradeList = { "+1 Damage Each, +1 Damage" },
	UpgradeCost = { 1, 3 },
	UpShot = "effects/tosx_shotup_needle1.png",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly_Damaged = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,4),
		Second_Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Ranged_Needle")

function tosx_Ranged_Needle:GetTargetArea(p1)
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

function tosx_Ranged_Needle:GetSkillEffect(p1, p2)
	local ret = SkillEffect()	
	local direction = GetDirection(p2 - p1)
	
	local damage0 = SpaceDamage(p1, self.SelfDamage)
	ret:AddDamage(damage0)
	
	local damage2 = SpaceDamage(p2, self.Damage, direction)
	damage2.sAnimation = "airpush_"..direction
	if Board:IsPawnSpace(p2) and Board:GetPawn(p2):IsMech() then
		damage2.iDamage = -1 * self.Damage
	end
	ret:AddArtillery(damage2, self.UpShot)
	
	ret:AddBounce(p2,self.BounceAmount)
	
	return ret
end

tosx_Ranged_Needle_A = tosx_Ranged_Needle:new{
	UpgradeDescription = "Increases damage to self and target by 1.",
	UpShot = "effects/tosx_shotup_needle2.png",
	SelfDamage = 2,
	Damage = 4,
}

tosx_Ranged_Needle_B = tosx_Ranged_Needle:new{
	UpgradeDescription = "Increases damage to target by 1.",
	UpShot = "effects/tosx_shotup_needle2.png",
	Damage = 4,
}

tosx_Ranged_Needle_AB = tosx_Ranged_Needle:new{
	UpShot = "effects/tosx_shotup_needle2.png",
	SelfDamage = 2,
	Damage = 5,
}



tosx_Science_Splitter = Skill:new{  
	Name = "Mimetic Skin",
	Description = "Shed a Husk and push tiles adjacent to it.\n\nHusk can merge with Mechs to heal them and push adjacent tiles.",
	Class = "Science",
	Icon = "weapons/tosx_weapon_metalskin.png",
	Rarity = 2,
	PowerCost = 1,
	Upgrades = 2,
	LaunchSound = "/weapons/arachnoidatk",--!!!
	--LaunchSound = "/weapons/bombling_throw",
	ImpactSound = "/impact/generic/mech",--!!!
	SelfDamage = 1,
	Range = 1,
	Damage = 0,
	Deploy = "tosx_Husk1",
	Shotup = "effects/tosx_shotup_needle2.png",--!!!
	--UpgradeList = { "Ranged" , "Impale" },
	UpgradeCost = { 2,2 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		Second_Origin = Point(2,2),
		Second_Target = Point(2,3),
	}
}
modApi:addWeaponDrop("tosx_Science_Splitter")

function tosx_Science_Splitter:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 1, self.Range do
			local point = p1 + DIR_VECTORS[dir]*i
			if not Board:IsValid(point) then
				break
			end
			if self.Damage > 0 or not Board:IsBlocked(point,PATH_PROJECTILE) then
				ret:push_back(point)
			end
		end
	end
	
	return ret
end

function tosx_Science_Splitter:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local range = p1:Manhattan(p2)
	
	local damage1 = SpaceDamage(p1, self.SelfDamage)
	damage1.sAnimation = "tosx_liquidmetal"
	ret:AddDamage(damage1)
		
	if range > 1 then
		local damage2 = SpaceDamage(p2)
		if not Board:IsBlocked(p2,PATH_PROJECTILE) then
		else
			damage2.iDamage = self.Damage
		end
		ret:AddArtillery(damage2, self.Shotup, FULL_DELAY)
		ret:AddBounce(p2,3)
		
		local damage2a = SpaceDamage(p2)
		damage2a.sAnimation = "tosx_huske"
		damage2a.bHide = true
		ret:AddDamage(damage2a)
		
	else	
		local damage0 = SpaceDamage(p2)
		damage0.sAnimation = "tosx_huske"
		if not Board:IsBlocked(p2,PATH_PROJECTILE) then
			damage0.bHide = true
		else
			damage0.iDamage = self.Damage
		end
		ret:AddMelee(p1, damage0, NO_DELAY)
		ret:AddBounce(p2,1)
	end
			
	for dir = DIR_START, DIR_END do
		local point = p2 + DIR_VECTORS[dir]
		if Board:IsValid(point) and point ~= p1 then
			local damage = SpaceDamage(point,0,dir)
			damage.sAnimation = "airpush_"..dir
			ret:AddDamage(damage)	
		end
	end
	
	-- Deploy the pawn after a delay so the spawn anim can play
	ret:AddDelay(0.45)
	local d = SpaceDamage(p2)
	d.sPawn = self.Deploy
	ret:AddDamage(d)
	
	if not Board:IsTipImage() then
		local huskcount = 0
		local allies = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(allies) do
			if (Board:GetPawn(id):GetType() == "tosx_Husk1") or (Board:GetPawn(id):GetType() == "tosx_Husk2") then
				huskcount = huskcount + 1
			end
		end
		if huskcount > 1 then
			ret:AddScript([[
				local fx = SkillEffect();
				fx:AddScript("tosx_mercurysquad_Chievo('tosx_mercury_soulless')")
				Board:AddEffect(fx);
			]])
		end
	end
	
	return ret
end

tosx_Science_Splitter_A = tosx_Science_Splitter:new{
	UpgradeDescription = "Sheds the Husk as an artillery projectile.",
	Range = 8,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,0),
	}
}

tosx_Science_Splitter_B = tosx_Science_Splitter:new{
	UpgradeDescription = "Increases the Husk's max health to 2.\n\nHusk transfers all health to Mechs when merging.",
	Deploy = "tosx_Husk2",
}

tosx_Science_Splitter_AB = tosx_Science_Splitter:new{
	Deploy = "tosx_Husk2",
	Range = 8,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,0),
	}
}


tosx_Deploy_Splitter = Skill:new{
	Name = "Mimetic Form",
	Description = "Merge with a Mech, transferring your health to it and pushing adjacent tiles.",
	Rarity = 0,
	Damage = 0,
	Class = "Unique",
	Healing = -1,
	SelfDamage = DAMAGE_DEATH,
	Icon = "weapons/tosx_weapon_metalskin_b.png",
	LaunchSound = "/weapons/bombling_throw",
	TipImage = {
		Unit = Point(2,3),
		Friendly_Damaged = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "tosx_Husk1"
	}
}

function tosx_Deploy_Splitter:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[dir]
		if Board:IsPawnSpace(point) and Board:GetPawn(point):IsMech() then
			ret:push_back(point)
		end
	end
	
	return ret
end

function tosx_Deploy_Splitter:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage0 = SpaceDamage(p2,-1 * Pawn:GetHealth())
	damage0.sAnimation = "tosx_liquidmetal"
	ret:AddMelee(p1, damage0, NO_DELAY)
			
	for dir = DIR_START, DIR_END do
		local point = p2 + DIR_VECTORS[dir]
		if Board:IsValid(point) then
		
			local damage = SpaceDamage(point,0,dir)
			damage.sAnimation = "airpush_"..dir			
			if point == p1 then
				damage = SpaceDamage(point,self.SelfDamage)
			end
			
			ret:AddDamage(damage)			
		end
	end
	
	return ret
end