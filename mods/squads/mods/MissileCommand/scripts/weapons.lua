local mod = mod_loader.mods[modApi.currentMod]
local worldConstants = require(mod.scriptPath.."libs/worldConstants")

local wt2 = {
	tosx_Prime_Ballistic_Upgrade1 = "+1 Damage",
	tosx_Prime_Ballistic_Upgrade2 = "+1 Damage",
	
	tosx_Brute_Standoff_Upgrade1 = "+1 Damage End",
	tosx_Brute_Standoff_Upgrade2 = "+1 Damage Sides",
	
	tosx_Ranged_PointDef_Upgrade1 = "+1 Damage",
	tosx_Ranged_PointDef_Upgrade2 = "+1 Damage All",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end



tosx_Prime_Ballistic = Skill:new{
	Name = "Ballistic Missile",
	Description = "Push adjacent tiles and launch a damaging long-range missile.",
	Icon = "weapons/tosx_weapon_icbm.png",
	PowerCost = 1,
	Damage = 1,
	Class = "Prime",
	MinSize = 3,
	ArtillerySize = 8,
	LaunchSound = "/weapons/bomb_strafe",
	ImpactSound = "/weapons/mercury_fist",
	UpShot = "effects/tosx_shotup_ballistic.png",
	Explo = "ExploArt1",
	Upgrades = 2,
	UpgradeCost = {1, 3},
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,0),
		Enemy = Point(2,0),
		Enemy2 = Point(3,3),
	},
}
modApi:addWeaponDrop("tosx_Prime_Ballistic")

function tosx_Prime_Ballistic:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = self.MinSize, self.ArtillerySize do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then
				break
			end
			ret:push_back(curr)
		end
	end
	return ret	
end

function tosx_Prime_Ballistic:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
    
    ret:AddSound("/props/satellite_launch")
    
	for dir = DIR_START, DIR_END do
        local p = p1 + DIR_VECTORS[dir]
        local damage0 = SpaceDamage(p,0,dir)
        damage0.sAnimation = "airpush_"..dir
        ret:AddDamage(damage0)
    end
    
    ret:AddBoardShake(0.5)
    
	local damage = SpaceDamage(p2,self.Damage)
    damage.sScript = [[
        local p = ]]..p2:GetString()..[[
        local fx = SkillEffect()
        fx:AddBoardShake(0.5)
        fx:AddBounce(p,3)
        fx:AddAnimation(p,"]]..self.Explo..[[",ANIM_NO_DELAY)
        Board:AddEffect(fx)
        ]]
	
	ret:AddBounce(p1, 5)
    worldConstants.SetHeight(ret, 44)
	ret:AddArtillery(damage, self.UpShot, NO_DELAY)
    worldConstants.ResetHeight(ret)
    
    if not Board:IsTipImage() and Board:IsPawnSpace(p2) and Board:GetPawn(p2):GetType() == "Jelly_Explode1" then
        local id = Board:GetPawn(p2):GetId()
        ret:AddScript(string.format([[
            local fx = SkillEffect();
            fx:AddScript("if Board:GetPawn(%s):IsDead() then tosx_missilesquad_Chievo('tosx_missile_yield') end")
            Board:AddEffect(fx);
        ]], id))
    end
    
	return ret
end

tosx_Prime_Ballistic_A = tosx_Prime_Ballistic:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
	Explo = "ExploArt2",
}

tosx_Prime_Ballistic_B = tosx_Prime_Ballistic:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
	Explo = "ExploArt2",
}

tosx_Prime_Ballistic_AB = tosx_Prime_Ballistic:new{
	Damage = 3,
	Explo = "ExploArt3",
} 



tosx_Brute_Standoff = Skill:new{  
	Name = "Phobos Cannon",
	Description = "Fire a damaging shell with a delayed side burst.",
	Icon = "weapons/tosx_weapon_standoff.png",
	PowerCost = 1,
	Damage = 1,
	DamageF = 1,
	DamageD = 1,
	Class = "Brute",
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion_large",
	ProjectileArt = "effects/tosx_shot_closemissile",
    Explo = "explopush1_",
    ExploD = "exploout1_",
    PathSize = INT_MAX,
	Upgrades = 2,
	UpgradeCost = {2, 3},
	TipImage = {
		Unit = Point(2,4),
		Target = Point(2,2),
		Enemy = Point(2,0),
		Enemy2 = Point(1,2),
	},
}
modApi:addWeaponDrop("tosx_Brute_Standoff")

function tosx_Brute_Standoff:GetTargetArea(p1)
    return Board:GetSimpleReachable(p1, self.PathSize, self.CornersAllowed)
end

function tosx_Brute_Standoff:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
    local p3 = GetProjectileEnd(p1,p2)
    
    local damage = SpaceDamage(p3,self.DamageF,dir)
    damage.sAnimation = self.Explo..dir
    ret:AddProjectile(damage,self.ProjectileArt,NO_DELAY)
    
    local isedge = p2.x == 0 or p2.x == 7 or p2.y == 0 or p2.y == 7
    ret:AddDelay(p1:Manhattan(p2)*.08)
    ret:AddSound("/weapons/shrapnel")
    
    local pe = p1
    for i = 1,3,2 do
        local p = p2 + DIR_VECTORS[(dir+i)%4]
        if Board:IsValid(p) then
            local ds = SpaceDamage(p,self.DamageD,(dir+i)%4)
            ds.sAnimation = self.ExploD..(dir+i)%4
            ret:AddDamage(ds)
            if Board:GetPawnTeam(p) == TEAM_ENEMY then
                pe = p
            end
        end
    end
    
    if pe ~= p1 and Board:GetPawnTeam(p3) == TEAM_ENEMY and pe:Manhattan(p3) > 5 and not Board:IsTipImage() then
        ret:AddDelay(0.6)
        ret:AddScript("tosx_missilesquad_Chievo('tosx_missile_fuse')")
    end
	
	return ret
end

tosx_Brute_Standoff_A = tosx_Brute_Standoff:new{
	UpgradeDescription = "Increases damage to last tile by 1.",
	Damage = 2,
	MinDamage = 1,
	DamageF = 2,
    Explo = "explopush2_",
}

tosx_Brute_Standoff_B = tosx_Brute_Standoff:new{
	UpgradeDescription = "Increases damage of side burst by 1.",
	Damage = 2,
	MinDamage = 1,
	DamageD = 2,
    Explo = "explopush2_",
    ExploD = "exploout2_",
}

tosx_Brute_Standoff_AB = tosx_Brute_Standoff:new{
	Damage = 2,
	DamageD = 2,
	DamageF = 2,
    Explo = "explopush2_",
    ExploD = "exploout2_",
}



tosx_Ranged_PointDef = Skill:new{  
	Name = "Proximity Rockets",
	Description = "Fire a pushing rocket. Additional rockets damage adjacent enemies.",
	Icon = "weapons/tosx_weapon_proximity.png",
	PowerCost = 0,
	Damage = 1,
	DamageP = 1,
	Class = "Ranged",
	UpShot = "effects/tosx_shotup_closemissile0.png",
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/weapons/shrapnel",
    Explo = "ExploArt1",
	ArtillerySize = 8,
	Upgrades = 2,
	UpgradeCost = {2, 3},
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(2,1),
		Enemy2 = Point(1,3),
		Enemy3 = Point(3,3),
	},
}
modApi:addWeaponDrop("tosx_Ranged_PointDef")

function tosx_Ranged_PointDef:GetTargetArea(p1)
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

function tosx_Ranged_PointDef:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
    
	local damage = SpaceDamage(p2,self.Damage,dir)
    damage.sAnimation = self.Explo

	ret:AddArtillery(damage, self.UpShot, NO_DELAY)
	
	for dir = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[dir]
		if (Board:IsValid(point) and Board:IsPawnSpace(point) and Board:GetPawnTeam(point) == TEAM_ENEMY) then
			local damage2 = SpaceDamage(point,self.DamageP)
			damage2.sAnimation = self.Explo
			damage2.bHidePath = true
            ret:AddDelay(0.1)
            ret:AddSound(self.LaunchSound)
			ret:AddArtillery(damage2, self.UpShot, NO_DELAY)
		end
	end
    
	local count = Board:GetEnemyCount()
	ret:AddScript(string.format([[
		local fx = SkillEffect();
		fx:AddScript("if %s - Board:GetEnemyCount() >= 4 then tosx_missilesquad_Chievo('tosx_missile_rain') end")
		Board:AddEffect(fx);
	]], count))
	
	return ret
end

tosx_Ranged_PointDef_A = tosx_Ranged_PointDef:new{
	UpgradeDescription = "Increases damage of the pushing rocket by 1.",
    Damage = 2,
    MinDamage = 1,
    Explo = "ExploArt2",
}

tosx_Ranged_PointDef_B = tosx_Ranged_PointDef:new{
	UpgradeDescription = "Increases damage of all rockets by 1.",
    Damage = 2,
    DamageP = 2,
    Explo = "ExploArt2",
}

tosx_Ranged_PointDef_AB = tosx_Ranged_PointDef:new{
    Damage = 3,
    DamageP = 2,
    MinDamage = 2,
    Explo = "ExploArt3",
}