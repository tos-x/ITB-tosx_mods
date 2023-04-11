local wt2 = {	
	tosx_DeploySkill_Fighter_Upgrade1 = "Explode",
	tosx_DeploySkill_Fighter_Upgrade2 = "Shatter Missile",
		
	tosx_Ranged_Shield_Upgrade1 = "Shield Behind",
	tosx_Ranged_Shield_Upgrade2 = "Damage Enemies",
	
	tosx_Science_Seismic_Upgrade1 = "Disorient",
	tosx_Science_Seismic_Upgrade2 = "+3 Piercing",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

tosx_DeploySkill_Fighter = Skill:new{
	Name = "Launch Fighter",
	Description = "Deploy a Fighter to help in combat. Destroys existing Fighters.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_launchfighter.png",
	Rarity = 3,
	Deployed = "tosx_Deploy_Fighter",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	Limited = 0,
	Explode = 0,
	DiveSound = "/impact/generic/mech",
	UpgradeCost = {1,2},
	--UpgradeList = { "Explode" , "Shatter Missile"},
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1),
	},
}
modApi:addWeaponDrop("tosx_DeploySkill_Fighter")

function tosx_DeploySkill_Fighter:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 1, 8 do
			local point = p1 + DIR_VECTORS[dir]*i
			
			if Board:IsBlocked(point, PATH_PROJECTILE) then
				break
			end
			
			if i ~= 1 then
				ret:push_back(point)
			end
		end
	end	
	return ret
end

function tosx_DeploySkill_Fighter:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local p3 = p1 + DIR_VECTORS[direction]
	
	local stringname = "tosx_Deploy_Fighter" -- Catch all fighter variants
	local fleet = extract_table(Board:GetPawns(TEAM_PLAYER))
	for i,id in pairs(fleet) do
		local pawn = Board:GetPawn(id)
		local point2 = Board:GetPawnSpace(id)
		if pawn:GetType():sub(1,stringname:len()) == stringname then
			--this is a fighter
			if not (self.Hangar == 1 and p1:Manhattan(point2) == 1) then
				local damage = SpaceDamage(point2, DAMAGE_DEATH)
				ret:AddDamage(damage)
				
				if self.Explode == 1 then
					ret:AddSound("/impact/generic/explosion")
					for dir = DIR_START, DIR_END do
						local point3 = point2 +  DIR_VECTORS[dir]
						if point3 ~= p2 and not Board:IsBuilding(point3) then
							local damage2 = SpaceDamage(point3, 1)
							damage2.sAnimation = "exploout1_"..dir
							ret:AddDamage(damage2)
						end
					end
				end
				
			end
		end
	end
	
	local dummy = SpaceDamage(p1, 0)
	dummy.sAnimation = "airpush_"..direction
	ret:AddDamage(dummy)
	
	local offset0 = _G[self.Deployed].ImageOffset
	local colorid = Pawn:GetId() + 1
	if GAME and not IsTipImage() then
		ret:AddScript(self.Deployed..".ImageOffset = Board:GetPawn("..colorid.."):GetImageOffset()")
	end
	
	local damage = SpaceDamage(p2, 0)
	damage.sPawn = self.Deployed
	ret:AddDamage(damage)
	
	if GAME and not IsTipImage() then
		ret:AddScript(self.Deployed..".ImageOffset = "..offset0)
	end
	
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		local p3 = Point(]]..p3:GetString()..[[)
		local pawn = Board:GetPawn(p2)
		
		pawn:SetSpace(p3)
		]])
	ret:AddCharge(Board:GetPath(p3, p2, PATH_FLYER), NO_DELAY)
	
	return ret	
end

tosx_DeploySkill_Fighter_A = tosx_DeploySkill_Fighter:new{
	UpgradeDescription = "When launching, existing fighters explode, damaging adjacent non-building tiles.",
	Explode = 1,
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(3,1),
		Enemy2 = Point(0,1),
		Building = Point(1,0),
		Second_Origin = Point(1,3),
		Second_Target = Point(3,3),
	},
}

tosx_DeploySkill_Fighter_B = tosx_DeploySkill_Fighter:new{
	UpgradeDescription = "Fighters gain a long-range, high damage secondary weapon.",
	Deployed = "tosx_Deploy_FighterA",
}

tosx_DeploySkill_Fighter_AB = tosx_DeploySkill_Fighter:new{
	Explode = 1,
	Deployed = "tosx_Deploy_FighterA",
}

tosx_Deploy_Fighter = Pawn:new{
	Name = "Fighter",
	Health = 1,
	MoveSpeed = 3,
	Image = "tosx_Fighter_img",
	SkillList = { "tosx_Deploy_FighterShot" },
	SoundLocation = "/mech/flying/jet_mech/",
	ImageOffset = imageOffset,
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Flying = true,
	Corpse = false,
}
tosx_Deploy_FighterA = tosx_Deploy_Fighter:new{
	SkillList = { "tosx_Deploy_FighterShot_2" , "tosx_Deploy_FighterShot" },
}
tosx_Deploy_FighterB = tosx_Deploy_Fighter:new{
	SkillList = { "tosx_Deploy_FighterShot_2" },
}
tosx_Deploy_FighterAB = tosx_Deploy_Fighter:new{
	SkillList = { "tosx_Deploy_FighterShot_2" },
	MoveSpeed = 6,
}

tosx_Deploy_FighterShot = Skill:new {
	Name = "Interceptor Missile",
	Description = "Fires a short-range missile that damages and pushes its target.",
	Icon = "weapons/tosx_weapon_fighter1.png",
	PathSize = 3,
	Push = 1,
	Rarity = 0,
	Damage = 1,
	Class = "Unique",
	LaunchSound = "/weapons/stock_cannons",
	ImpactSound = "/impact/generic/explosion",
	ProjectileArt = "effects/shot_fighter1",
	ProjectileAnim = "explopush1_",
	--ProjSpeed = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_Deploy_Fighter"
	}
}

function tosx_Deploy_FighterShot:GetTargetArea(p1)
	return Board:GetSimpleReachable(p1, self.PathSize, self.CornersAllowed)
end

function tosx_Deploy_FighterShot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE) 
	if p1:Manhattan(target) > self.PathSize then
		target = p1 +  DIR_VECTORS[direction] * self.PathSize
	end
	
	local damage = SpaceDamage(target, self.Damage)
	if self.Push == 1 then
		damage.iPush = direction
	end
	damage.sAnimation = self.ProjectileAnim..direction
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end

tosx_Deploy_FighterShot_2 = tosx_Deploy_FighterShot:new {
	Name = "Shatter Missile",
	Description = "Fires a powerful long-range missile.",
	Icon = "weapons/tosx_weapon_fighter2.png",
	PathSize = INT_MAX,
	Push = 0,
	Rarity = 0,
	Damage = 2,
	--ProjSpeed = 1,
	Class = "Unique",
	LaunchSound = "/weapons/stock_cannons",
	ImpactSound = "/impact/generic/explosion",
	ProjectileArt = "effects/shot_fighter2",
	ProjectileAnim = "explopush2_",
}

----------------------------------------------------------



tosx_Ranged_Shield = LineArtillery:new{
	Name = "Remote Shield",
	Description = "Shield a tile from damage, pushing adjacent tiles.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_remote_shield.png",
	Rarity = 2,
	Explosion = "",
	Damage = 0,
	BounceAmount = 1,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {2,2},
	--UpgradeList = { "Shield Behind" , "Damage Enemies" },
	LaunchSound = "/weapons/phase_shot",
	ProjectileArt = "effects/shotup_shield.png",--update!
	Backshield = 0,
	Morepush = 0,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Building = Point(2,1),
		Friendly = Point(2,4),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Ranged_Shield")

function tosx_Ranged_Shield:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	ret:AddBounce(p1,2)
	
	if self.Backshield == 1 then
		local p3 = p1 - DIR_VECTORS[direction]
		local damage = SpaceDamage(p3, 0)
		damage.sAnimation = "tosx_explo_shield"
		if self.Damage > 0 and Board:GetPawnTeam(p3) == TEAM_ENEMY then
			damage.iDamage = self.Damage
			damage.sSound = "/weapons/enhanced_tractor"
		else
			damage.iShield = EFFECT_CREATE
		end
		ret:AddDamage(damage)	
	end
	
	local damage = SpaceDamage(p2, 0)
	if self.Damage > 0 and Board:GetPawnTeam(p2) == TEAM_ENEMY then
		damage.iDamage = self.Damage
	else
		damage.iShield = EFFECT_CREATE
	end
	
	ret:AddArtillery(damage, self.ProjectileArt, FULL_DELAY)
	ret:AddBounce(p2,2)
	
	for dir = DIR_START, DIR_END do
		if dir == (direction+1)%4 or dir == (direction+3)%4 or self.Morepush == 1 then
			local direction2 = (direction+dir)%4
			local p2a = p2 + DIR_VECTORS[dir]
			local damage2 = SpaceDamage(p2a, 0, dir)
			damage2.sAnimation = "airpush_"..dir
			ret:AddDamage(damage2)
		end
	end
	
	local damage0 = SpaceDamage(p2, 0)
	damage0.bHide = true
	damage0.sAnimation = "tosx_explo_shield"
	damage0.sSound = "/weapons/enhanced_tractor"
	ret:AddDamage(damage0)	
	
	return ret
end	

tosx_Ranged_Shield_A = tosx_Ranged_Shield:new{
	UpgradeDescription = "Shield the tile behind the Mech.",
	Backshield = 1,
}
tosx_Ranged_Shield_B = tosx_Ranged_Shield:new{
	UpgradeDescription = "Damages enemies instead of Shielding them.",
	Damage = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Enemy2 = Point(2,0),
		Building = Point(2,1),
		Friendly = Point(2,4),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,0),
	},
}
tosx_Ranged_Shield_AB = tosx_Ranged_Shield:new{
	Backshield = 1,
	Damage = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(3,1),
		Enemy2 = Point(2,0),
		Building = Point(2,1),
		Friendly = Point(2,4),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,0),
	},
}





----------------------------------------------------------



tosx_Science_Seismic = Skill:new{
	Name = "Seismic Wave",
	Description = "Fire a seismic pulse at a target, pushing it. Pulse can travel through 1 obstacle.",
	Class = "Science",
	Icon = "weapons/tosx_weapon_seismic.png",
	Rarity = 2,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,3},
	--UpgradeList = {  "Disorient" , "+3 Piercing" },
	LaunchSound = "/enemy/digger_1/attack_queued",
	Flip = 0,
	Piercing = 1,
	TipImage = {
		Unit = Point(2,4),
		CustomEnemy = "Firefly2",
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Building = Point(1,2),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Science_Seismic")

function tosx_Science_Seismic:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local thisdirection = 0
		local obstacles = 0
		
		for i = 1,7 do
			local point2 = p1 +  DIR_VECTORS[dir]*i
			if Board:IsValid(point2) then
				ret:push_back(point2)
				if Board:IsBlocked(point2, PATH_PROJECTILE) then
					obstacles = obstacles + 1
					if obstacles > self.Piercing then
						break
					end
				end
			else
				break
			end
		end
	end
	return ret
end

function tosx_Science_Seismic:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)
	local extradust = true
	local count = 0
	
	if extradust then
		local damage0 = SpaceDamage(p1,0)
		damage0.bHide = true
		damage0.sAnimation = "tosx_explo_quakeA_0"--..direction
		ret:AddDamage(damage0)
		damage0.sAnimation = "tosx_explo_quakeB_0"--..direction
		ret:AddDamage(damage0)
		ret:AddDelay(0.1)
	end
	
	for i = 0, distance+1 do
		local point = p1 +  DIR_VECTORS[direction]*i
		ret:AddBounce(point,-10)
		if i > 0 then
			local damage = SpaceDamage(point,0)
			if i < distance then 
				if self.Flip == 1 then
					damage.iPush = DIR_FLIP
					
					if Board:IsPawnSpace(point) then
						if Board:GetPawnTeam(point) == TEAM_ENEMY and
						not _G[Board:GetPawn(point):GetType()].IgnoreFlip then
							count = count + 1
						end
					end
					
				end
			elseif i == distance then
				damage.iPush = direction
				damage.sAnimation = "airpush_"..direction
			end
			if i <= distance then
				ret:AddDamage(damage)
			end
		end
		ret:AddDelay(0.08)
	end
	
	if count > 2 then
		ret:AddScript("tosx_legionsquad_Chievo('tosx_legion_wave')")
	end
	
	return ret	
end

tosx_Science_Seismic_A = tosx_Science_Seismic:new{
	UpgradeDescription = "Targets the pulse travels through have their attacks flipped.",
	Flip = 1,
	TipImage = {
		Unit = Point(2,4),
		CustomEnemy = "Firefly2",
		Mountain = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Queued2 = Point(1,2),
		Building = Point(1,2),
		Target = Point(2,1),
	},
}

tosx_Science_Seismic_B = tosx_Science_Seismic:new{
	UpgradeDescription = "Pulse can travel through up to 4 obstacles.",
	Piercing = 4,
	TipImage = {
		Unit = Point(2,4),
		CustomEnemy = "Firefly2",
		Mountain = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Queued2 = Point(1,2),
		Building = Point(1,2),
		Target = Point(2,1),
	},
}

tosx_Science_Seismic_AB = tosx_Science_Seismic:new{
	Piercing = 4,
	Flip = 1,
	TipImage = {
		Unit = Point(2,4),
		CustomEnemy = "Firefly2",
		Mountain = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Queued2 = Point(1,2),
		Building = Point(1,2),
		Target = Point(2,1),
	},
}