local wt2 = {	
	tosx_Prime_AeroThrusters_Upgrade1 = "+1 Range",
	tosx_Prime_AeroThrusters_Upgrade2 = "+2 Range",
	
	tosx_Brute_Microburst_Upgrade1 = "+1 Range",
	tosx_Brute_Microburst_Upgrade2 = "+1 Range",
	
	tosx_Ranged_Cyclone_Upgrade1 = "+1 Range",
	tosx_Ranged_Cyclone_Upgrade2 = "+2 Range",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end


tosx_Prime_AeroThrusters = Skill:new{  
	Name = "Aero Thrusters",
	Description = "Leap away several tiles, taking enemies on either side with you.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_wind1.png",
	Rarity = 2,
	PowerCost = 0,
	Upgrades = 2,
	LaunchSound = "/weapons/wind",
	ImpactSound = "/impact/generic/mech",
	Range = 3,
	--UpgradeList = { "-1 Self Damage" , "+2 Damage"},
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,3),
		Enemy2 = Point(3,3),
		Enemy3 = Point(2,2),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Prime_AeroThrusters")

function tosx_Prime_AeroThrusters:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for k = 1, self.Range do
			local point = p1 + DIR_VECTORS[dir]*k
			if not Board:IsBlocked(point, PATH_FLYER) then
				ret:push_back(point)
			end
		end
	end
	
	return ret
end

function tosx_Prime_AeroThrusters:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local dirs = {(direction + 1)% 4,(direction - 1)% 4}
	local distance = p1:Manhattan(p2)
	local pcount = 0
	
	ret:AddBounce(p1,6)
	for i = 1,2 do
		local target = p1 + DIR_VECTORS[dirs[i]]
		local damage = SpaceDamage(target)
		damage.sAnimation = "tosx_windspin"
		damage.bHide = true
		ret:AddBounce(target,6)
		ret:AddDamage(damage)
	end
	
	local damage = SpaceDamage(p1)
	damage.bHide = true
	damage.sAnimation = "tosx_windspin"
	ret:AddDamage(damage)
	
	ret:AddDelay(0.2)

	for i = 1,2 do
		local origin = p1 + DIR_VECTORS[dirs[i]]
		local target = p2 + DIR_VECTORS[dirs[i]]
		if Board:IsPawnSpace(origin)
		and not Board:GetPawn(origin):IsGuarding()
		and not Board:IsBlocked(target, PATH_FLYER) then
			local move = PointList()
			move:push_back(origin)
			move:push_back(target)
			ret:AddLeap(move, NO_DELAY)
			
			if Board:GetPawn(origin):GetTeam() == TEAM_ENEMY then
				pcount = pcount + 1
			end
		else		
			local damage2 = SpaceDamage(origin)
			damage2.sImageMark = "advanced/combat/throw_"..GetDirection(p2-p1).."_off.png"
			ret:AddDamage(damage2)
		end
	end
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	ret:AddLeap(move, FULL_DELAY)
	ret:AddSound(self.ImpactSound)
	
	if distance >= 4 and pcount == 2 then
		ret:AddScript("tosx_windsquad_Chievo('tosx_wind_goride')")
	end
	
	return ret
end

tosx_Prime_AeroThrusters_A = tosx_Prime_AeroThrusters:new{
	UpgradeDescription = "Allows leaping over additional tiles.",
	Range = 4,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,3),
		Enemy2 = Point(3,3),
		Enemy3 = Point(2,2),
		Target = Point(2,0),
	}
}

tosx_Prime_AeroThrusters_B = tosx_Prime_AeroThrusters:new{
	UpgradeDescription = "Allows leaping over additional tiles.",
	Range = 5,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,3),
		Enemy2 = Point(3,3),
		Enemy3 = Point(2,2),
		Target = Point(2,0),
	}
}

tosx_Prime_AeroThrusters_AB = tosx_Prime_AeroThrusters:new{
	Range = 6,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,3),
		Enemy2 = Point(3,3),
		Enemy3 = Point(2,2),
		Target = Point(2,0),
	}
}

tosx_Brute_Microburst = Skill:new{  
	Name = "Microburst",
	Description = "Push all nearby units in a single direction.",
	Class = "Brute",
	Icon = "weapons/tosx_weapon_wind2.png",
	Rarity = 3,
	PowerCost = 1,
	PathSize = 1,
	Upgrades = 2,
	--UpgradeList = { "+1 Range",  "+1 Damage"  },
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Enemy3 = Point(1,1),
		Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Brute_Microburst")

function tosx_Brute_Microburst:GetTargetArea(p1)			
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for k = 1, self.PathSize do
			local point = p1 + DIR_VECTORS[dir]*k
			ret:push_back(point)
			if not Board:IsValid(point) then
				break
			end
		end
	end	
	
	return ret
end

function tosx_Brute_Microburst:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local distance = p1:Manhattan(p2)
	local dir = GetDirection(p2 - p1)
	local pcount = 0
	
	ret:AddSound("/props/snow_storm")
	ret:AddEmitter(p1,"tosx_Emitter_Windburst_"..dir)

	for i = -distance, distance do
		for j = -distance, distance do
			local point = Point(p1.x+j,p1.y+i) -- DIR_LEFT
			if dir == DIR_RIGHT then
				point = Point(p1.x-j, p1.y+i)
			elseif dir == DIR_UP then
				point = Point(p1.x+i,p1.y+j)
			elseif dir == DIR_DOWN then
				point = Point(p1.x+i,p1.y-j)
			end
			
			--!!! guarding pawns? doesn't preview right unless we exclude
			if Board:IsPawnSpace(point) and not Board:GetPawn(point):IsGuarding() then
				if not (IsTipImage() and point == Point(0,0)) then --Protection against modApiExt 
					ret:AddDamage(SpaceDamage(point, 0, dir))
					pcount = pcount + 1
				end
				ret:AddDelay(0.1)
			end
		end
	end
	
	if pcount >= 8 then
		ret:AddScript("tosx_windsquad_Chievo('tosx_wind_crowded')")
	end
	
	return ret
end

tosx_Brute_Microburst_A = tosx_Brute_Microburst:new{
	UpgradeDescription = "Extends range by 1 tile.",
	PathSize = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Enemy3 = Point(1,1),
		Target = Point(2,1),
	}
}

tosx_Brute_Microburst_B = tosx_Brute_Microburst:new{
	UpgradeDescription = "Extends range by 1 tile.",
	PathSize = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Enemy3 = Point(1,1),
		Target = Point(2,1),
	}
}

tosx_Brute_Microburst_AB = tosx_Brute_Microburst:new{
	PathSize = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Enemy3 = Point(1,1),
		Target = Point(2,0),
	}
}





tosx_Ranged_Cyclone = Skill:new{  
	Name = "Cyclone Launcher",
	Description = "Launch an adjacent unit up to several tiles away.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_wind3.png",
	Rarity = 2,
	Range = 2,
	PowerCost = 0,
	Upgrades = 2,
	TwoClick = true,
	--UpgradeList = { "Building Immune",  "+1 Damage"  },
	UpgradeCost = { 1,2 },
	ProjectileArt = "effects/shot_phaseshot",
	UpShot = "effects/shotup_smokeblast_missile.png",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,2),
		Second_Click = Point(2,0),
	}
}
modApi:addWeaponDrop("tosx_Ranged_Cyclone")

function tosx_Ranged_Cyclone:GetTargetArea(p1)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		ret:push_back(curr)
	end
	
	return ret
end

function tosx_Ranged_Cyclone:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2)
	local direction = GetDirection(p2 - p1)

	if Board:IsPawnSpace(p2) and not Board:GetPawn(p2):IsGuarding() then
	
		for i = 1, self.Range do
			local curr = p2 + DIR_VECTORS[direction]*i
			if Board:IsValid(curr) and Board:IsBlocked(curr, PATH_FLYER) then
				local block_image = SpaceDamage(curr,0)
				block_image.sImageMark = "advanced/combat/icons/icon_throwblocked_glow.png"
				ret:AddDamage(block_image)
			end
		end
	
		local empty_spaces = self:GetSecondTargetArea(p1, p2)
		if not empty_spaces:empty() then
			damage.sImageMark = "advanced/combat/throw_"..GetDirection(p2-p1)..".png"
			ret:AddDamage(damage)
			return ret			
		end
	end
	
	damage.sImageMark = "advanced/combat/throw_"..GetDirection(p2-p1).."_off.png"
	ret:AddDamage(damage)
	return ret
end

function tosx_Ranged_Cyclone:GetSecondTargetArea(p1,p2)
	local ret = PointList()
	local direction = GetDirection(p2 - p1)
	
	if not Board:IsPawnSpace(p2) or Board:GetPawn(p2):IsGuarding() then
		return ret
	end
	
	for i = 1, self.Range do
		local curr = p2 + DIR_VECTORS[direction]*i
		if Board:IsValid(curr) and not Board:IsBlocked(curr, PATH_FLYER) then
			ret:push_back(curr)
		end
	end
	
	return ret
end

function tosx_Ranged_Cyclone:GetFinalEffect(p1,p2,p3)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2)	
	damage.bHide = true
	damage.sAnimation = "tosx_windspin"
	ret:AddDamage(damage)

	ret:AddSound("/props/pylon_fall")
	ret:AddBounce(p2,6)
	ret:AddDelay(0.1)
	ret:AddSound("/props/smoke_cloud")
	ret:AddDelay(0.1)
	
	local move = PointList()
	move:push_back(p2)
	move:push_back(p3)
	ret:AddLeap(move,FULL_DELAY)
	
	if Board:GetPawn(p2):GetTeam() == TEAM_ENEMY
	and not Board:GetPawn(p2):IsFlying()
	and Board:GetTerrain(p3) == TERRAIN_HOLE then
		ret:AddScript("tosx_windsquad_Chievo('tosx_wind_falling')")
	end
		
	return ret
end

tosx_Ranged_Cyclone_A = tosx_Ranged_Cyclone:new{
	UpgradeDescription = "Extends range of the throw by 1 tile.",
	Range = 3,
}

tosx_Ranged_Cyclone_B = tosx_Ranged_Cyclone:new{
	UpgradeDescription = "Extends range of the throw by 2 tiles.",
	Range = 4,
}

tosx_Ranged_Cyclone_AB = tosx_Ranged_Cyclone:new{
	Range = 5,
}