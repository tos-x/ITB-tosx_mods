local mod = mod_loader.mods[modApi.currentMod]

local wt2 = {
	tosx_Prime_Distorter_Upgrade1 = "Teleport",
	tosx_Prime_Distorter_Upgrade2 = "Shield Friendly",
	
	tosx_Ranged_Portals_Upgrade1 = "Shield Friendly",
	
	tosx_Science_Nomad_Upgrade1 = "+3 Range",
	tosx_Science_Nomad_Upgrade2 = "+3 Range",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end


local function IsImovable(point)
	-- True if obstacle (mountain, building) or guarding pawn; false otherwise
	if Board:IsPawnSpace(point) then return Board:GetPawn(point):IsGuarding() end
	return Board:IsBlocked(point,PATH_PROJECTILE)
end


tosx_Prime_Distorter = Skill:new{  
	Name = "Spatial Prism",
	Description = "Flip the attack direction of enemies on either side.",
	Icon = "weapons/tosx_weapon_prism.png",
	PowerCost = 0,
	Class = "Prime",
	Dash = false,
    Shield = false,
	Upgrades = 2,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy1 = Point(2,1),
		Queued1 = Point(3,1),
		Enemy2 = Point(2,3),
		Queued2 = Point(2,2),
		Building = Point(3,1),
	},
}
modApi:addWeaponDrop("tosx_Prime_Distorter")

function tosx_Prime_Distorter:GetTargetArea(p1)
	local ret = PointList()
	
    local range = self.Dash and 8 or 1
	for dir = DIR_START, DIR_END do
		for i = 1, range do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			
			if (i == 1) or not Board:IsBlocked(curr,PATH_PROJECTILE) then
				ret:push_back(curr)
			end
		end
	end
	
	return ret
end

function tosx_Prime_Distorter:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local direction0 = GetDirection(p1 - p2)
	local moved = p1
	
    if self.Dash and not Board:IsBlocked(p2,PATH_PROJECTILE) then
        moved = p2
        ret:AddSound("/weapons/swap")
        ret:AddTeleport(p1, p2, FULL_DELAY)
	end
	
    ret:AddSound("/weapons/prism_beam")
    local targets = {moved + DIR_VECTORS[direction], moved + DIR_VECTORS[direction0]}
    
    local lights = 0
    for j = 1,2 do
        if Board:IsValid(targets[j]) then
            local damage = SpaceDamage(targets[j], 0, DIR_FLIP)
            damage.sAnimation = "tosx_SwipePurple"
            
            if self.Shield and (Board:IsBuilding(targets[j]) or Board:GetPawnTeam(targets[j]) == TEAM_PLAYER) and targets[j] ~= p1 then
                damage.iShield = 1
                damage.iPush = DIR_NONE
                
                if Board:IsBuilding(targets[j]) then
                    lights = lights + 1
                end
            end
            ret:AddDamage(damage)
        end
    end
    if Board:IsTipImage() then
        ret:AddDelay(1)
    elseif lights > 0 then
        ret:AddScript([[
            local mission = GetCurrentMission()
            if mission then
                if not mission.tosx_warp_lights then mission.tosx_warp_lights = 0 end
                mission.tosx_warp_lights = mission.tosx_warp_lights + ]]..lights..[[
                if mission.tosx_warp_lights > 5 then
                    tosx_warpsquad_Chievo('tosx_warp_lights')
                end
            end
        ]])
    end
    
	return ret
end

tosx_Prime_Distorter_A = tosx_Prime_Distorter:new{
	UpgradeDescription = "Teleport to an empty tile before attacking.",
	Dash = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy1 = Point(2,2),
		Queued1 = Point(3,2),
		Enemy2 = Point(2,0),
		Queued2 = Point(3,0),
		Building = Point(3,0),
		Building2 = Point(3,2),
	},
}

tosx_Prime_Distorter_B = tosx_Prime_Distorter:new{
	UpgradeDescription = "Shield adjacent ally or Building.",
	Shield = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy1 = Point(2,1),
		Queued1 = Point(3,1),
		Building = Point(2,3),
		Building2 = Point(3,1),
	},
}

tosx_Prime_Distorter_AB = tosx_Prime_Distorter:new{
	Dash = true,
	Shield = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy1 = Point(2,2),
		Queued1 = Point(3,2),
		Building = Point(2,0),
		Building2 = Point(3,2),
	},
} 



tosx_Ranged_Portals = Skill:new{  
	Name = "Portal Launcher",
	Description = "Target two tiles in different directions and swap units on them.",
	Icon = "weapons/tosx_weapon_portals.png",
	PowerCost = 1,
	Class = "Ranged",
	LaunchSound = "/weapons/force_swap",
	ImpactSound = "/weapons/swap",
	UpShot = "effects/tosx_shotup_swapother.png",
	Upgrades = 1,
    ArtillerySize = 8,
	TwoClick = true,
    Same = false,
    Shield = false,
	UpgradeCost = {2},
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(1,1),
		Friendly = Point(3,3),
		Second_Click = Point(3,3),
	},
}
modApi:addWeaponDrop("tosx_Ranged_Portals")

function tosx_Ranged_Portals:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			
			if not IsImovable(curr) then
				ret:push_back(curr)
			end
		end
	end
	
	return ret
end

function tosx_Ranged_Portals:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	local dir = GetDirection(p2 - p1)
    
    local jmax = self.Same and 4 or 3
	for j = 1, jmax do
		for i = 2, self.ArtillerySize do
			local curr = p1 + DIR_VECTORS[(dir+j)%4] * i
			if not Board:IsValid(p1 + DIR_VECTORS[(dir+j)%4] * i) then  
				break
			end
			
			if not IsImovable(curr) and curr ~= p2 then
				ret:push_back(curr)
			end
		end
	end
	
	return ret
end

function tosx_Ranged_Portals:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
    
	local d = SpaceDamage(p2)
    if self.Shield and Board:GetPawnTeam(p2) == TEAM_PLAYER then
        d.iShield = 1
    else
        d.sImageMark = "advanced/combat/icons/icon_teleport_glow.png"
    end
    
    ret:AddDamage(d)
    
	return ret
end

function tosx_Ranged_Portals:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	
	local first_damage = SpaceDamage(p2)
	first_damage.bHide = true
    first_damage.sAnimation = "tosx_warpin"
    
	local second_damage = SpaceDamage(p3)
	second_damage.bHide = true
    second_damage.sAnimation = "tosx_warpin"
    
	ret:AddArtillery(first_damage, self.UpShot, NO_DELAY)
	ret:AddArtillery(second_damage, self.UpShot)
	
    local delay = Board:IsPawnSpace(p3) and 0 or FULL_DELAY
    ret:AddTeleport(p2,p3, delay)
    
    if delay ~= FULL_DELAY then
        ret:AddTeleport(p3,p2, FULL_DELAY)
    end
    
    if self.Shield and Board:GetPawnTeam(p2) == TEAM_PLAYER then
        local shields = SpaceDamage(p3)
        shields.iShield = 1
        if not Board:IsBlocked(p3,PATH_PROJECTILE) then
            shields.sImageMark = "combat/icons/tosx_icon_shield.png"
        end
        ret:AddDamage(shields)
    end
    if self.Shield and Board:GetPawnTeam(p3) == TEAM_PLAYER then
        local shields = SpaceDamage(p2)
        shields.iShield = 1
        if not Board:IsBlocked(p2,PATH_PROJECTILE) then
            shields.sImageMark = "combat/icons/tosx_icon_shield.png"
        end
        ret:AddDamage(shields)
    end
    
    if not Board:IsTipImage() then
        local drops = 0
        local pc2 = p2
        local pc3 = p3
        
        for i = 1,2 do
            if Board:IsPawnSpace(pc2) then
                local pawn = Board:GetPawn(pc2)
                if pawn:GetTeam() == TEAM_ENEMY and not pawn:IsFlying() then
                    if Board:GetTerrain(pc3) == TERRAIN_HOLE then
                        drops = drops + 1
                    elseif Board:GetTerrain(pc3) == TERRAIN_WATER and not pawn:IsMassive() then
                        drops = drops + 1
                    end
                end
            end
            --Now check the other way
            pc2 = p3
            pc3 = p2
        end
        
        if drops > 0 then
            ret:AddScript([[
                local mission = GetCurrentMission()
                if mission then
                    if not mission.tosx_warp_drop then mission.tosx_warp_drop = 0 end
                    mission.tosx_warp_drop = mission.tosx_warp_drop + ]]..drops..[[
                    if mission.tosx_warp_drop > 3 then
                        tosx_warpsquad_Chievo('tosx_warp_fun')
                    end
                end
            ]])
        end
    end
    
	return ret
end	

tosx_Ranged_Portals_A = tosx_Ranged_Portals:new{
	UpgradeDescription = "Shield allies after teleporting them.",
	Shield = true,
}


tosx_Science_Nomad = Skill:new{  
	Name = "Long Teleporter",
	Description = "Swap places with a tile at range 3.",
	Icon = "weapons/tosx_weapon_longwarp.png",
	PowerCost = 0,
	Class = "Science",
	LaunchSound = "/enemy/moth_1/attack_launch",
	MinRange = 3,
	MaxRange = 3,
    Shield = false,
	Upgrades = 2,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(3,2),
		Target = Point(1,1),
		Enemy = Point(1,1),
	},
}
modApi:addWeaponDrop("tosx_Science_Nomad")

function tosx_Science_Nomad:GetTargetArea(p1)
	local ret = PointList()
	local size = self.MaxRange
	
	local corner = p1 - Point(size, size)	
	local p = Point(corner)
		
	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = p1 - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and (dist <= self.MaxRange and dist >= self.MinRange) then
			if not IsImovable(p) then
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

function tosx_Science_Nomad:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
    
	local delay = Board:IsPawnSpace(p2) and 0 or FULL_DELAY
	ret:AddTeleport(p1,p2, delay)
	
	if delay ~= FULL_DELAY then
		ret:AddTeleport(p2,p1, FULL_DELAY)
	end
    
    if self.Shield then
        local damage = SpaceDamage(p2)
        damage.iShield = 1
        if not Board:IsBlocked(p2,PATH_PROJECTILE) then
            damage.sImageMark = "combat/icons/tosx_icon_shield.png"
        end
        ret:AddDamage(damage)
    end
    
    if not Board:IsTipImage() and Board:GetPawnTeam(p2) == TEAM_ENEMY and p1.x == 0 then
        ret:AddScript("tosx_warpsquad_Chievo('tosx_warp_invite')")
    end
	
	return ret
end

tosx_Science_Nomad_A = tosx_Science_Nomad:new{
	UpgradeDescription = "Increases max range of the swap by 3 tiles.",
    MaxRange = 6,
	TipImage = {
		Unit = Point(3,3),
		Target = Point(1,1),
		Enemy = Point(1,1),
	},
}

tosx_Science_Nomad_B = tosx_Science_Nomad:new{
	UpgradeDescription = "Increases max range of the swap by 3 tiles.",
    MaxRange = 6,
	TipImage = {
		Unit = Point(3,3),
		Target = Point(1,1),
		Enemy = Point(1,1),
	},
}

tosx_Science_Nomad_AB = tosx_Science_Nomad:new{
    MaxRange = 9,
	TipImage = {
		Unit = Point(3,3),
		Target = Point(1,1),
		Enemy = Point(1,1),
	},
}