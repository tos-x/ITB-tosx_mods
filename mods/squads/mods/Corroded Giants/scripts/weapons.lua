local mod = mod_loader.mods[modApi.currentMod]

local wt2 = {
	tosx_Prime_SteamClaw_Upgrade1 = "Pierce",
	tosx_Prime_SteamClaw_Upgrade2 = "+1 Damage",
	
	tosx_Ranged_Smoker_Upgrade1 = "+1 Damage",
	tosx_Ranged_Smoker_Upgrade2 = "+1 Damage",
	
	tosx_Science_Smokeline_Upgrade1 = "+1 Range",
	tosx_Science_Smokeline_Upgrade2 = "+1 Range",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end



tosx_Prime_SteamClaw = Skill:new{  
	Name = "Grapple Claw",
	Description = "Damage a target and pull it any distance.",
	Icon = "weapons/tosx_weapon_winch.png",
	Class = "Prime",
	Rarity = 2,
	Damage = 2,
	PowerCost = 1,
	Range = INT_MAX,
	Pierce = 0,
	LaunchSound = "/weapons/grapple",
    ClawSound = "/impact/generic/grapple",
	Upgrades = 2,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Prime_SteamClaw")

function tosx_Prime_SteamClaw:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
        local pierce = 0
		for i = 1, self.Range do
			local p = p1 + DIR_VECTORS[dir]*i
			if Board:IsValid(p) then
				ret:push_back(p)
			end
			if not Board:IsValid(p) then
				break
			end
			if Board:IsBlocked(p, PATH_PROJECTILE) then
				if pierce < self.Pierce then
                    pierce = pierce + 1
                else
                    break
                end
			end
		end
	end
	
	return ret
end

function tosx_Prime_SteamClaw:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local target1 = GetProjectileEnd(p1,p2) -- grapple start
    local distance1 = p1:Manhattan(target1)
    local distance2 = p1:Manhattan(p2)
    local pierce = false
    if distance2 > distance1 then
        pierce = target1 -- middle target
        target1 = GetProjectileEnd(pierce,p2) -- final target/grapple start
    end
    
	local target2 = target1 -- grapple end
	if Board:IsPawnSpace(target1) and not Board:GetPawn(target1):IsGuarding() then
		target2 = p2
	end
	
	local damage = SpaceDamage(target1)
	damage.bHide = true
	damage.sSound = self.ClawSound
	ret:AddProjectile(damage, "effects/shot_grapple", FULL_DELAY)
	
	if target1 ~= target2 then
		ret:AddCharge(Board:GetSimplePath(target1, target2), FULL_DELAY)
    
        if not Board:IsTipImage() and Board:GetPawn(target1):IsMech() then
            local dist = target1:Manhattan(target2)
            LOG("dist: "..dist)
            ret:AddScript([[
                local mission = GetCurrentMission()
                if mission then
                    if not mission.tosx_steam_harvest then mission.tosx_steam_harvest = 0 end
                    mission.tosx_steam_harvest = mission.tosx_steam_harvest + ]]..dist..[[
                    
                    if mission.tosx_steam_harvest >= 8 then
                        tosx_steamsquad_Chievo("tosx_steam_harvest")
                    end
                end
            ]])	
        end
	end
	local damage1 = SpaceDamage(target2)
    ret:AddProjectile(damage1, "", NO_DELAY) -- path dots
    damage1.iDamage = self.Damage
    ret:AddDamage(damage1) -- instant damage
    
    if pierce then
        local damagem = SpaceDamage(pierce, self.Damage)
        damagem.sSound = self.ClawSound
        ret:AddDamage(damagem)
    end
	
	return ret
end

tosx_Prime_SteamClaw_A = tosx_Prime_SteamClaw:new{
	UpgradeDescription = "Attack can pierce through 1 target, pulling the second.",
	Pierce = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Enemy2 = Point(2,2),
		Target = Point(2,1),
	},
}

tosx_Prime_SteamClaw_B = tosx_Prime_SteamClaw:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

tosx_Prime_SteamClaw_AB = tosx_Prime_SteamClaw:new{
	Pierce = 1,
	Damage = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Enemy2 = Point(2,2),
		Target = Point(2,1),
	},
}

-- Note: having artillery image strings containg "fire"/"missile" will add black/white smoke trails
tosx_Ranged_Smoker = Skill:new{
	Name = "Pressurized Artillery",
	Description = "Artillery shot that damages and applies Smoke.",
	Icon = "weapons/tosx_weapon_pressure.png",
	Class = "Ranged",
	LaunchSound = "/weapons/back_shot",
	ImpactSound = "/impact/generic/explosion",
	Upgrades = 2,
	Damage = 2,
	UpShot = "effects/tosx_shotup_smokemissile.png",
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_Ranged_Smoker")

function tosx_Ranged_Smoker:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 2,7 do
			local point = p1 + DIR_VECTORS[dir]*i
			if Board:IsValid(point) then
				ret:push_back(point)
			else
				break
			end
		end
	end
	return ret
end

function tosx_Ranged_Smoker:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage0 = SpaceDamage(p2, self.Damage)
    damage0.iSmoke = EFFECT_CREATE
	
	ret:AddBounce(p1, 3)
	ret:AddArtillery(damage0, self.UpShot)
	ret:AddBounce(p2, 3)
	
	return ret
end

tosx_Ranged_Smoker_A = tosx_Ranged_Smoker:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

tosx_Ranged_Smoker_B = tosx_Ranged_Smoker:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

tosx_Ranged_Smoker_AB = tosx_Ranged_Smoker:new{
	Damage = 4,
}


tosx_Science_Smokeline = Skill:new{  
	Name = "Cloud Torrent",
	Description = "Add Smoke to a nearby tile, and push existing Smoke in that direction.",
	Icon = "weapons/tosx_weapon_clouds.png",
	Range = 1,
	Smoke = 1,
	Class = "Science",
	LaunchSound = "/weapons/raining_volley_tile",
	Upgrades = 2,
	UpgradeCost = {1, 2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
        Smoke = Point(3,3),
	},
}
modApi:addWeaponDrop("tosx_Science_Smokeline")

function tosx_Science_Smokeline:GetTargetArea(p1)
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

function tosx_Science_Smokeline:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local animdir = GetDirection(p1 - p2)
	local distance = p1:Manhattan(p2)
    local p3 = p2
    
    local remsmoke = SpaceDamage(p1)
    remsmoke.iSmoke = EFFECT_REMOVE
    remsmoke.sImageMark = "combat/icons/vwt_icon_smoke_immune_glow.png"
    remsmoke.sAnimation = "vwt_smoke_move_"..animdir
    
    local addsmoke = SpaceDamage(p1)
    addsmoke.sImageMark = "combat/icons/vwt_icon_smoke_glow.png"
    
    local subsequent = {}
    for i = 1, self.Range do
        subsequent[i] = {}
    end
    
    -- Don't check whole Board in TipImage
    local bmin = (Board:IsTipImage() and 2) or 0
    local bmax = (Board:IsTipImage() and 3) or 7
    
    for i = bmin, bmax do
        for j = bmin, bmax  do
            local point = Point(i,j) -- DIR_LEFT
            if dir == DIR_RIGHT then
                point = Point(7 - i, j)
            elseif dir == DIR_UP then
                point = Point(j,i)
            elseif dir == DIR_DOWN then
                point = Point(j,7-i)
            end

            if Board:IsSmoke(point) or point == p1 then
                remsmoke.loc = point
                if point ~= p1 then
                    ret:AddDamage(remsmoke)
                else
                    local remsmoke1 = SpaceDamage(p1)
                    remsmoke1.sAnimation = "vwt_smoke_move_"..animdir
                    remsmoke1.bHide = true
                    ret:AddDamage(remsmoke1)
                end
                
                for k = 1, distance do
                    local point2 = point + DIR_VECTORS[dir]*k
                    if Board:IsValid(point2) then
                        subsequent[k][#subsequent[k] + 1] = point2
                        if k == distance then
                            addsmoke.loc = point2
                            ret:AddDamage(addsmoke)
                        end
                    end
                end
            end
        end
    end
        
    -- subsequent push and smoke creation
    ret:AddDelay(ANIMS.vwt_smoke_move_0.Time * ANIMS.vwt_smoke_move_0.NumFrames)
    for k = 1, distance do
        for i, v in pairs(subsequent[k]) do
            if k == distance then
                ret:AddScript(string.format(
                    "Board:SetSmoke(%s, true, true)",
                    v:GetString()
                ))
            else
                ret:AddScript(string.format([[
                    local p, dir = %s, %s 
                    Board:SetSmoke(p, false, true) 
                    Board:AddAnimation(p, "vwt_smoke_move_"..dir, NO_DELAY) 
                ]], v:GetString(), animdir))
            end
        end
        ret:AddDelay(ANIMS.vwt_smoke_move_0.Time * ANIMS.vwt_smoke_move_0.NumFrames)
    end
    
	if not Board:IsTipImage() then
		ret:AddScript([[
			local mission = GetCurrentMission()
			if mission then
                local dir = ]]..dir..[[
				if not mission.tosx_steam_winds then mission.tosx_steam_winds = {0,0,0,0} end
				mission.tosx_steam_winds[dir] = 1
                
                local edgecount = 0
                for i,v in pairs(mission.tosx_steam_winds) do
                    edgecount = edgecount + v
                end
                
                if edgecount > 3 then
                    tosx_steamsquad_Chievo("tosx_steam_winds")
                end
			end
		]])	
	end
	
	return ret
end

tosx_Science_Smokeline_A = tosx_Science_Smokeline:new{
	UpgradeDescription = "Smoke can be pushed 1 additional tile.",
	Range = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
        Smoke = Point(3,3),
	},
}

tosx_Science_Smokeline_B = tosx_Science_Smokeline:new{
	UpgradeDescription = "Smoke can be pushed 1 additional tile.",
	Range = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
        Smoke = Point(3,3),
	},
}

tosx_Science_Smokeline_AB = tosx_Science_Smokeline:new{
	Range = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,0),
		Target = Point(2,0),
        Smoke = Point(3,3),
	},
}


tosx_Passive_Smokeboost = PassiveSkill:new {
	Name = "Smog Generator",
	Description = "Smoke applies A.C.I.D. to enemies.",
	Passive = "tosx_PassiveE_Smokeacid",
	Icon = "weapons/tosx_weapon_smoggy.png",
	PowerCost = 0,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,2),
		Smoke1 = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Passive_Smokeboost")

function tosx_Passive_Smokeboost:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddDelay(1)
	ret:AddMove(Board:GetPath(Point(2,0), p2, PATH_GROUND), FULL_DELAY)
	ret.effect:back().bHide = true
	
	local damage = SpaceDamage(p2)
	damage.iAcid = EFFECT_CREATE
    damage.bHide = true
	ret:AddDamage(damage)
	ret:AddDelay(1)
	
	return ret
end
