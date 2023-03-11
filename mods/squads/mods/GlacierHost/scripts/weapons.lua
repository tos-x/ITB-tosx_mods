local wt2 = {	
	tosx_Prime_Cryoburst_Upgrade1 = "Freeze Buildings",
	tosx_Prime_Cryoburst_Upgrade2 = "+1 Damage",
	
	tosx_Brute_WallIce_Upgrade1 = "+1 Range",
	tosx_Brute_WallIce_Upgrade2 = "+1 Damage",
	
	tosx_Ranged_Dispersal_Upgrade1 = "+2 Transfer",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end


tosx_Prime_Cryoburst = Skill:new{  
	Name = "Cryoburst",
	Description = "Freeze yourself and damage adjacent tiles.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_glacier1.png",
	Rarity = 2,
	PowerCost = 1,
	Upgrades = 2,
	LaunchSound = "/weapons/shrapnel",
	ImpactSound = "/impact/generic/mech",
	Damage = 2,
	FreezeBuildings = false,
	SelfTarget = true,
	NonSelfTarget = false,
	BuildingDamage = true,
	--UpgradeList = { "Freeze Buildings" , "+1 Damage" },
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(3,2),
		Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Prime_Cryoburst")

function tosx_Prime_Cryoburst:GetTargetArea(p1)
	local ret = PointList()
	
	if self.SelfTarget then
		ret:push_back(p1)
	end
	for dir = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[dir]
		ret:push_back(point)
	end
	
	return ret
end

function tosx_Prime_Cryoburst:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	if not self.NonSelfTarget then
		p2 = p1
	end
	
	local damage = SpaceDamage(p2)
	damage.iFrozen = EFFECT_CREATE
	ret:AddDamage(damage)
	
	for dir = DIR_START, DIR_END do
		local p3 = p2 + DIR_VECTORS[dir]
		if Board:IsValid(p3) then
			local damage2 = SpaceDamage(p3)
			damage2.iDamage = self.Damage
			
			if not self.BuildingDamage and Board:IsBuilding(p3) then
				damage2.iDamage = 0
			elseif self.FreezeBuildings and Board:IsBuilding(p3) then
				damage2.iDamage = 0
				damage2.iFrozen = EFFECT_CREATE				
			else
				damage2.sAnimation = "tosx_icerocker_"..dir
				damage2.sSound = "/enemy/digger_1/attack"
			end		
			ret:AddDamage(damage2)			
		end
	end
	ret:AddScript([[
		local mission = GetCurrentMission()
		mission.tosx_cryo = mission.tosx_cryo + 1		
		if mission.tosx_cryo > 3 then
			tosx_glaciersquad_Chievo("tosx_glacier_thaw")
		end
		]])
	
	return ret
end

tosx_Prime_Cryoburst_A = tosx_Prime_Cryoburst:new{
	UpgradeDescription = "This attack will Freeze buildings instead of damaging them.",
	FreezeBuildings = true,
}

tosx_Prime_Cryoburst_B = tosx_Prime_Cryoburst:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

tosx_Prime_Cryoburst_AB = tosx_Prime_Cryoburst:new{
	FreezeBuildings = true,
	Damage = 3,
}



tosx_Brute_WallIce = Skill:new{  
	Name = "Wall of Ice",
	Description = "Raise Frozen blocks from the ground, pushing the furthest tile.\n\nThe blocks melt after the enemy turn.",
	Class = "Brute",
	Icon = "weapons/tosx_weapon_glacier2.png",
	Rarity = 3,
	PowerCost = 0,
	Range = 2,
	FreezeBuildings = false,
	Frozen = true,
	Damage = 1,
	Upgrades = 2,
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound = "/weapons/dynamic/rock",
	--UpgradeList = { "+1 Range",  "+1 Damage"  },
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Brute_WallIce")

function tosx_Brute_WallIce:GetTargetArea(p1)	
	local ret = PointList()

	for dir = DIR_START, DIR_END do
		for i = 1, self.Range do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			ret:push_back(curr)
		end
	end
	
	return ret
end

function tosx_Brute_WallIce:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local range = p1:Manhattan(p2)
	
	for i = 1, range do
		local rock = false
		local p3 = p1 + DIR_VECTORS[dir]*i
		local damage = SpaceDamage(p3)
		if i == range then
			damage.iPush = dir
		end
		if Board:IsValid(p3) and not Board:IsBlocked(p3,PATH_PROJECTILE) then
			damage.sPawn = "tosx_IceWall"
			rock = true		
		elseif self.FreezeBuildings and Board:IsBuilding(p3) then
			damage.iFrozen = EFFECT_CREATE
		else
			damage.sAnimation = "tosx_icerock1d" 
			damage.iDamage = self.Damage
		end
		ret:AddDamage(damage)
		if rock then
			if self.Frozen then
				local damage2 = SpaceDamage(p3)
				damage2.bHide = true
				damage2.iFrozen = EFFECT_CREATE
				ret:AddDamage(damage2)
			end
			-- Rock doesn't play emerge anim if TEAM_PLAYER, but want mechs to pass through them
			ret:AddScript("Board:GetPawn("..p3:GetString().."):SetTeam(TEAM_PLAYER)")
		end
	end
	
	if IsTipImage() then
		ret:AddDelay(1)
	end
	
	return ret
end

tosx_Brute_WallIce_A = tosx_Brute_WallIce:new{
	UpgradeDescription = "Extends ice wall range by 1 tile.",
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

tosx_Brute_WallIce_B = tosx_Brute_WallIce:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Brute_WallIce_AB = tosx_Brute_WallIce:new{
	Range = 3,
	Damage = 2,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}



tosx_Ranged_Dispersal = Skill:new{  
	Name = "Dispersal Artillery",
	Description = "Artillery strike that transfers Freeze from adjacent tiles to the target.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_glacier3.png",
	Rarity = 2,
	ArtillerySize = 8,
	BounceAmount = 1,
	PowerCost = 0,
	Upgrades = 1,
	SidesOnly = true,
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/weapons/prism_beam",
	--UpgradeList = { "+2 Transfer"  },
	UpgradeCost = { 2 },
	UpShot = "effects/tosx_shotup_transfer.png",
	UpShot2 = "effects/tosx_shotup_transfer2.png",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(1,1),
		Friendly = Point(3,3),
		Building = Point(3,1),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Ranged_Dispersal")

function tosx_Ranged_Dispersal:GetTargetArea(p1)
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
	
	-- TipImage ice
	if IsTipImage() and not Board:GetPawn(Point(3,3)):IsFrozen() then
		Board:GetPawn(Point(3,3)):SetFrozen(true)
	end
	
	return ret	
end

function tosx_Ranged_Dispersal:GetSkillEffect(p1, p2)
	local ret = SkillEffect()	
	local direction = GetDirection(p2 - p1)
	local backwards = GetDirection(p1 - p2)
	local range = p1:Manhattan(p2)
	local xice = 0
	local pX = p1 -- Potential onflict tile
	local projectile = self.UpShot
	local enemy1 = false
	
	-- Mark adjacent tiles for Freeze siphon
	for dir = DIR_START, DIR_END do
		p9 = p1 + DIR_VECTORS[dir]
		if self.SidesOnly and (dir == direction or dir == backwards) then
			-- Skip
		else		
			local damage = SpaceDamage(p9)

			if Board:IsFrozen(p9) or (Board:IsPawnSpace(p9) and Board:GetPawn(p9):IsFrozen()) then
				projectile = self.UpShot2
				xice = xice + 1
				damage.iFrozen = EFFECT_REMOVE
				damage.sAnimation = "tosx_iceblast_"..(dir + 2)%4
				if range == 2 and dir == direction then
					pX = p9
					damage.bHide = true
				else
					damage.sImageMark = "combat/icons/tosx_frozen_remove.png"
				end
				-- Achievement
				if Board:IsPawnSpace(p9) and Board:GetPawnTeam(p9) == TEAM_ENEMY then
					enemy1 = true
				end
			else
				if range == 2 and dir == direction then
					pX = p9
					damage.bHide = true
				else
					damage.sImageMark = "combat/icons/tosx_frozen_remove_miss.png"
				end
			end
			ret:AddDamage(damage)
		end
	end			
	
	local damage = SpaceDamage(p2)	
	-- Freeze center
	if xice > 0 then
		damage.iFrozen = EFFECT_CREATE
		-- Achievement
		if enemy1 and Board:IsPawnSpace(p2) and Board:GetPawnTeam(p2) == TEAM_ENEMY then			 
			ret:AddScript([[
				local mission = GetCurrentMission()
				mission.tosx_icetransfer = mission.tosx_icetransfer + 1
				if mission.tosx_icetransfer > 2 then
					tosx_glaciersquad_Chievo("tosx_glacier_creeping")
				end
				]])
		end
	end
	
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, projectile)
	ret:AddBounce(p2, self.BounceAmount)
	
	for dir = 0, 3 do
		local p3 = p2 + DIR_VECTORS[dir]
		damage2 = SpaceDamage(p3, 0, dir)	
		if p3 == pX then
			if Board:IsFrozen(pX) or (Board:IsPawnSpace(pX) and Board:GetPawn(pX):IsFrozen()) then
				damage2.sImageMark = "combat/icons/tosx_frozen_remove.png"
			else
				damage2.sImageMark = "combat/icons/tosx_frozen_remove_miss.png"
			end
		end	
		damage2.sAnimation = "airpush_"..dir
		ret:AddDamage(damage2)
	end

	if IsTipImage() then
		ret:AddDelay(1)
	end
	
	return ret
end

tosx_Ranged_Dispersal_A = tosx_Ranged_Dispersal:new{
	UpgradeDescription = "Transfers Freeze from all 4 adjacent tiles to the target.",
	SidesOnly = false,
}





local function createIce(count)
	local tiles = extract_table(Board:GetTiles())
	
	local choices = {}
	for i = 0, 7 do
		for j = 0, 7 do
			if (Board:IsPawnSpace(Point(i,j)) and Board:GetPawnTeam(Point(i,j)) ~= TEAM_PLAYER) or Board:IsBuilding(Point(i,j)) then
			    choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	for i = 1, count do
		local point = random_removal(choices)
		Board:SetFrozen(point, true)
	end
end

-- add ice to experiment with in test mech scenario
modApi.events.onTestMechEntered:subscribe(function()
	modApi:runLater(function()
		local pawn = false
			or Game:GetPawn(0)
			or Game:GetPawn(1)
			or Game:GetPawn(2)

		if pawn and pawn:IsWeaponEquipped("tosx_Ranged_Dispersal") then
			createIce(5)
		end
	end)
end)