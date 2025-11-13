local mod = mod_loader.mods[modApi.currentMod]

local wt2 = {
	tosx_Prime_Axes_Upgrade1 = "+1 Damage",
	tosx_Prime_Axes_Upgrade2 = "Finishing Blow",
    
	tosx_Brute_Machinegun_Upgrade1 = "+1 Damage",
	tosx_Brute_Machinegun_Upgrade2 = "Kill Chain",	
	
	tosx_Science_LineShift_Upgrade1 = "Heal Allies",
	tosx_Science_LineShift_Upgrade2 = "Boost Allies",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end


tosx_Prime_Axes = Skill:new{  
	Name = "Prime Axes",
	Description = "Strike an adjacent tile, damaging it and pushing it to either side.",
	Icon = "weapons/tosx_weapon_axes.png",
	PowerCost = 0,
	Class = "Prime",
	Damage = 1,
    Finisher = false,
	TwoClick = true,
	LaunchSound = "/weapons/sword",
	ImpactSound = "/impact/generic/explosion_large",
	Upgrades = 2,
	UpgradeCost = {2, 2},
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy = Point(2,1),
		Second_Click = Point(1,1),
	},
}
modApi:addWeaponDrop("tosx_Prime_Axes")

function tosx_Prime_Axes:GetTargetArea(p1)
	local ret = PointList()
    
	for dir = DIR_START, DIR_END do
        local curr = p1 + DIR_VECTORS[dir]
        if Board:IsValid(curr) then
            ret:push_back(curr)
		end
	end
    
	return ret
end

function tosx_Prime_Axes:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	local dir = GetDirection(p2 - p1)
    
	for j = 1, 3, 2 do
        local curr = p2 + DIR_VECTORS[(dir+j)%4]
        if Board:IsValid(curr) then
            ret:push_back(curr)
		end
	end
	
	return ret
end

function tosx_Prime_Axes:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
    
    local damage = SpaceDamage(p2, self.Damage)
    if Board:IsPawnSpace(p2) then
        local pawn = Board:GetPawn(p2)
        if self.Finisher and (pawn:GetHealth() < pawn:GetMaxHealth()) then
            damage.iDamage = DAMAGE_DEATH
        end
    end
	ret:AddDamage(damage)
    
	return ret
end

function tosx_Prime_Axes:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local dir = GetDirection(p3 - p2)
	local dir0 = GetDirection(p2 - p1)
    local cw = "C"
    if (dir0 + 1)%4 == dir then cw = "" end
    
    local damage = SpaceDamage(p2,self.Damage,dir)
    damage.sAnimation = "tosx_axe"..cw.."_"..dir
    if Board:IsPawnSpace(p2) then
        local pawn = Board:GetPawn(p2)
        if self.Finisher and (pawn:GetHealth() < pawn:GetMaxHealth()) then
            damage.iDamage = DAMAGE_DEATH
            damage.sAnimation = "tosx_Saxe"..cw.."_"..dir
            damage.sSound = "/ui/map/seismic_activity"
            
            if not Board:IsTipImage() and Board:GetPawnTeam(p2) == TEAM_ENEMY then
                ret:AddScript([[
                    local mission = GetCurrentMission()
                    if mission then
                        if not mission.tosx_gunner_fin then mission.tosx_gunner_fin = 0 end
                        mission.tosx_gunner_fin = mission.tosx_gunner_fin + 1
                        if mission.tosx_gunner_fin > 3 then
                            tosx_gunnersquad_Chievo('tosx_gunner_axefall')
                        end
                    end
                ]])
            end
        end
    end
    
	ret:AddMelee(p1,damage)
	
	return ret
end

tosx_Prime_Axes_A = tosx_Prime_Axes:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Prime_Axes_B = tosx_Prime_Axes:new{
	UpgradeDescription = "Instantly kills wounded enemies.",
	Finisher = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy_Damaged = Point(2,1),
		Second_Click = Point(1,1),
	},
}

tosx_Prime_Axes_AB = tosx_Prime_Axes:new{
	Damage = 2,
	Finisher = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy_Damaged = Point(2,1),
		Second_Click = Point(1,1),
	},
}


tosx_Brute_Machinegun = Skill:new{
	Name = "Machine Gun",
	Description = "Fire a damaging burst and push yourself back.",
	Icon = "weapons/tosx_weapon_machinegun.png",
	PowerCost = 0,
	Class = "Brute",
	Damage = 2,
    Chain = false,
    PathSize = INT_MAX,
	LaunchSound = "/props/pod_impact",
	ImpactSound = "/props/pod_impact",
	ProjectileArt = "effects/tosx_shot_bullets",
	Explo = "ExploAir1",
	Upgrades = 2,
	UpgradeCost = {2, 3},
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,0),
		Enemy = Point(2,0),
		CustomEnemy = "Leaper1",
        Mountain = Point(2,3),
	},
}
modApi:addWeaponDrop("tosx_Brute_Machinegun")

function tosx_Brute_Machinegun:GetTargetArea(p1)
    return Board:GetSimpleReachable(p1, self.PathSize, self.CornersAllowed)
end

function tosx_Brute_Machinegun:GetSkillEffect(p1, p2)
	local myid = Pawn:GetId()
	local ret = SkillEffect()
	local dir2 = GetDirection(p1 - p2)
    
    local damage0 = SpaceDamage(p1,0,dir2)
    damage0.sAnimation = "airpush_"..dir2
    ret:AddDamage(damage0)
    
    if not Board:IsTipImage() and GAME and self.Chain then
        GAME.tosx_GunnerChain = GAME.tosx_GunnerChain or {}
        GAME.tosx_GunnerChain[myid] = GAME.tosx_GunnerChain[myid] or false
    end
    
    local p3 = GetProjectileEnd(p1,p2)
    local damage = SpaceDamage(p3,self.Damage)
    damage.sAnimation = self.Explo
    if not Board:IsTipImage() and self.Chain and GAME.tosx_GunnerChain[myid] then
        damage.iDamage = DAMAGE_DEATH
        damage.sAnimation = "ExploArt3"
        damage.sSound = "/ui/map/seismic_activity"
        ret:AddScript(string.format("GAME.tosx_GunnerChain[%s] = false", myid))
        
        if Board:IsPawnSpace(p3) and
           not IsTestMechScenario() and
           _G[Board:GetPawn(p3):GetType()].Tier == TIER_BOSS then
            ret:AddScript([[
                if GAME then
                    if not GAME.tosx_gunner_boss then GAME.tosx_gunner_boss = 0 end
                    GAME.tosx_gunner_boss = GAME.tosx_gunner_boss + 1
                    if GAME.tosx_gunner_boss > 2 then
                        tosx_gunnersquad_Chievo('tosx_gunner_leaderkill')
                    end
                end
            ]])
        end
            
    elseif self.Chain then
        if Board:IsTipImage() and p2 == Point(1,2) then
            -- Second attack
            damage.iDamage = DAMAGE_DEATH
            damage.sAnimation = "ExploArt3"
        else
            damage.bKO_Effect = Board:IsDeadly(damage, Pawn)
        end
    end
    ret:AddProjectile(damage,self.ProjectileArt,NO_DELAY)
        
	if not Board:IsTipImage() and self.Chain and damage.bKO_Effect then
        ret:AddScript(string.format("GAME.tosx_GunnerChain[%s] = true", myid))
	end
    
    -- Brrr
    local reps = 2
    for i = 1,reps do
        ret:AddDelay(0.05)
        ret:AddSound(self.LaunchSound)
    end
        
    for i = 1,self.Damage-1 do
        local dummy = SpaceDamage(p3)
        dummy.bHide = true
        ret:AddProjectile(dummy,self.ProjectileArt,NO_DELAY)
        ret:AddDelay(0.05*reps)
    end
    
	if self.Chain and damage.bKO_Effect then
            ret:AddDelay(0.5)
			ret:AddScript([[
				local pawn = Board:GetPawn(]].. Board:GetPawn(p1):GetId() .. [[)
				Game:TriggerSound("/ui/map/flyin_rewards");
				Board:Ping(pawn:GetSpace(), GL_Color(0, 0, 0));
			]])
    end
    
	return ret
end

tosx_Brute_Machinegun_A = tosx_Brute_Machinegun:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
	Explo = "ExploAir2",
}

tosx_Brute_Machinegun_B = tosx_Brute_Machinegun:new{
	UpgradeDescription = "If target is killed, next shot is lethal.",
	Chain = true,
	OnKill = "Next shot lethal",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,0),
		Enemy = Point(2,0),
		CustomEnemy = "Leaper1",
        Mountain = Point(2,3),
		Enemy2 = Point(1,2),
		Second_Origin = Point(2,2),
		Second_Target = Point(1,2),
	},
}

tosx_Brute_Machinegun_AB = tosx_Brute_Machinegun:new{
	Damage = 3,
	Explo = "ExploAir2",
	Chain = true,
	OnKill = "Next shot lethal",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,0),
		Enemy = Point(2,0),
		CustomEnemy = "Leaper1",
        Mountain = Point(2,3),
		Enemy2 = Point(1,2),
		Second_Origin = Point(2,2),
		Second_Target = Point(1,2),
	},
}



tosx_Science_LineShift = Skill:new{  
	Name = "Line Shift",
	Description = "Push self and all tiles in the same row.",
	Icon = "weapons/tosx_weapon_lineshift.png",
	PowerCost = 1,
	Class = "Science",
    Heal = false,
    Boost = false,
	LaunchSound = "/weapons/enhanced_tractor",
	Upgrades = 2,
	UpgradeCost = {1, 3},
	TipImage = {
		Unit = Point(2,3),
		Target = Point(3,3),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Enemy2 = Point(2,4),
	},
}
modApi:addWeaponDrop("tosx_Science_LineShift")

function tosx_Science_LineShift:GetTargetArea(p1)
	local ret = PointList()
    
	for dir = DIR_START, DIR_END do
        local curr = p1 + DIR_VECTORS[dir]
        if Board:IsValid(curr) then
            ret:push_back(curr)
		end
	end
    
	return ret
end

function tosx_Science_LineShift:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
    
    local damage0 = SpaceDamage(p1)
    damage0.sAnimation = "tosx_redpulse"
    damage0.bHide = true
    ret:AddDamage(damage0)
    
    for i = 0,7 do
        local p = Point(0,p1.y) + DIR_VECTORS[DIR_RIGHT]*i
        if p1.x ~= p2.x then
            p = Point(p1.x,0) + DIR_VECTORS[DIR_DOWN]*i
        end
        local damage = SpaceDamage(p,0,dir)
        damage.sAnimation = "airpush_"..dir
        
        if Board:IsPawnSpace(p) and Board:GetPawnTeam(p) == TEAM_PLAYER and p ~= p1 then
            if self.Heal then
                damage.iDamage = -1
                if Board:GetPawn(p):IsDead() and Board:GetPawn(p):IsMech() and not Board:IsTipImage() then
                    ret:AddScript("tosx_gunnersquad_Chievo('tosx_gunner_cheap')")
                end
            end
            if self.Boost then
                damage.sScript = "Board:GetPawn("..p:GetString().."):SetBoosted(true)"
                if not self.Heal then
                    -- Don't overcrowd the icons
                    damage.sImageMark = "advanced/combat/icons/icon_boosted_glow.png"
                end
            end
        end
        
        ret:AddDamage(damage)
        ret:AddDelay(0.01)
    end
	
	return ret
end

tosx_Science_LineShift_A = tosx_Science_LineShift:new{
	UpgradeDescription = "Pushing an ally will heal it for 1.",
    Heal = true,
}

tosx_Science_LineShift_B = tosx_Science_LineShift:new{
	UpgradeDescription = "Pushing an ally will Boost it.",
    Boost = true,
}

tosx_Science_LineShift_AB = tosx_Science_LineShift:new{
    Heal = true,
    Boost = true,
}


local function ResetStorageVars()
	GAME.tosx_GunnerChain = nil
end

local function onModsLoaded()
	modApi:addMissionEndHook(ResetStorageVars)
	modApi:addMissionStartHook(ResetStorageVars)
	modApi:addMissionNextPhaseCreatedHook(ResetStorageVars)
	modApi:addTestMechEnteredHook(ResetStorageVars)
	modApi:addTestMechExitedHook(ResetStorageVars)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)