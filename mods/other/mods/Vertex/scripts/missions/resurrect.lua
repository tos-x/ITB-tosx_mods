-- mission Mission_tosx_Resurrect
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")

local objInMission2 = switch{
	[0] = function()
		Game:AddObjective("Revive a Mech with the Phoenix Project", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Revive a Mech with the Phoenix Project", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[2] = function()
		Game:AddObjective("Revive a Mech with the Phoenix Project", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission1 = switch{
	[0] = function() return Objective("Protect the Phoenix Project", 1):Failed() end,
	[1] = function() return Objective("Protect the Phoenix Project", 1) end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Revive a Mech with the Phoenix Project", 1):Failed() end,
	[1] = function() return Objective("Revive a Mech with the Phoenix Project", 1) end,
	default = function() return nil end,
}

Mission_tosx_Resurrect = Mission_Infinite:new{
	Name = "Phoenix Project",
	Objectives = {objAfterMission1:case(1),objAfterMission2:case(1)},
	UseBonus = false,
	PhoenixId = -1,
	PhoenixPawn = "tosx_PhoenixProject",
	SpawnStartMod = 1,
    Revive = false,
}

-- Add CEO dialog
local dialog = require(path .."missions/resurrect_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Resurrect", dialogTable)
end

function Mission_tosx_Resurrect:StartMission()
	local choices = self:GetReplaceableBuildings()
	local choice = random_removal(choices)
	Board:ClearSpace(choice)
    
	local phoenix = PAWN_FACTORY:CreatePawn(self.PhoenixPawn)
	self.PhoenixId = phoenix:GetId()
	Board:AddPawn(phoenix, choice)
end

function Mission_tosx_Resurrect:CanRevive()
    if not Board:IsPawnAlive(self.PhoenixId) and not self.Revive then
        return 0
    elseif self.Revive then
        return 2
    end
    return 1
end

function Mission_tosx_Resurrect:UpdateObjectives()
	local status = Board:IsPawnAlive(self.PhoenixId) and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Protect the Phoenix Project",status)
    
	objInMission2:case(self:CanRevive())
end

function Mission_tosx_Resurrect:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(Board:IsPawnAlive(self.PhoenixId) and 1 or 0)
	ret[2] = objAfterMission2:case(self.Revive and 1 or 0)
	return ret
end

function Mission_tosx_Resurrect:GetCompletedStatus()
	if Board:IsPawnAlive(self.PhoenixId) and self.Revive then
		return "Success"
	elseif Board:IsPawnAlive(self.PhoenixId) then
		return "PhoenixOnly"
	elseif self.Revive then
		return "ReviveOnly"
	else
		return "Failure"
	end
end

tosx_PhoenixProject = Pawn:new{
	Name = "Phoenix Project",
	Image = "tosx_phoenix",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "tosx_PhoenixRevive" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/support/terraformer",
	Pushable = false,
	NonGrid = true,
	Corporate = true,
	IgnoreSmoke = true,
	LargeShield = true,
}

tosx_PhoenixRevive = Skill:new{
	Name = "Core Reactivation",
	Description = "Shield, Boost, and fully repair a destroyed Mech.",
	Class = "Unique",
	Icon = "weapons/tosx_phoenixreviver.png",
	LaunchSound = "/weapons/doubleshot",
	Limited = 1,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tosx_PhoenixProject"
	}
}

function tosx_PhoenixRevive:GetTargetArea(p1)
	local ret = PointList()
    if Board:IsTipImage() then
        local p = Point(2,1)
        ret:push_back(p)
        if not Board:GetPawn(p):IsDead() then
            Board:DamageSpace(p,DAMAGE_DEATH)
            Board:GetPawn(p1):SetPowered(true)
        end
    else
        for i = 0,3 do
            local p = Board:GetPawnSpace(i)
            if Board:IsValid(p) and Board:GetPawn(p):IsMech() and Board:GetPawn(p):IsDead() then
                ret:push_back(p)
            end
        end
    end
	return ret
end

function tosx_PhoenixRevive:GetSkillEffect(p1, p2)    
	local ret = SkillEffect()
    
    ret:AddSound("/impact/generic/ricochet")
    ret:AddSound("/enemy/shared/robot_power_on")
    
    ret:AddBounce(p1, 1)
    ret:AddScript("Board:GetPawn("..p1:GetString().."):SetPowered(false)")
    local dummy = SpaceDamage(p2)
    dummy.sImageMark = "combat/icons/tosx_icon_revive_glow.png"
	ret:AddArtillery(dummy,"effects/tosx_shotup_reviver.png",FULL_DELAY)
    
    ret:AddBoardShake(0.6)
    
    local revive = SpaceDamage(p2,-10)
    revive.bHide = true
    revive.sScript = "Board:GetPawn("..p2:GetString().."):SetBoosted(true)"
    ret:AddDamage(revive)
    
    ret:AddDelay(0.05)
    local reviveS = SpaceDamage(p2)
    reviveS.bHide = true
    reviveS.iShield = EFFECT_CREATE --Can't shield mech at the same time we revive it
    ret:AddDamage(reviveS)
    
    if not Board:IsTipImage() then
        ret:AddScript([[
            local mission = GetCurrentMission() 
            if not mission then return end 
            mission.Revive = true
            ]])
    else
        ret:AddDelay(2)
    end
    
	return ret
end

modApi:appendAsset("img/units/mission/tosx_phoenix.png", mod.resourcePath .."img/units/mission/phoenix.png")
modApi:appendAsset("img/units/mission/tosx_phoenix_ns.png", mod.resourcePath .."img/units/mission/phoenix_ns.png")
modApi:appendAsset("img/units/mission/tosx_phoenix_a.png", mod.resourcePath .."img/units/mission/phoenix_a.png")
modApi:appendAsset("img/units/mission/tosx_phoenix_d.png", mod.resourcePath .."img/units/mission/phoenix_d.png")
modApi:appendAsset("img/units/mission/tosx_phoenix_off.png", mod.resourcePath .."img/units/mission/phoenix_off.png")

modApi:appendAsset("img/effects/tosx_shotup_reviver.png", mod.resourcePath .."img/effects/shotup_reviver.png")
modApi:appendAsset("img/weapons/tosx_phoenixreviver.png", mod.resourcePath .."img/weapons/phoenixreviver.png")

modApi:appendAsset("img/combat/icons/tosx_icon_revive_glow.png", mod.resourcePath.."img/combat/icons/icon_revive_glow.png")
    Location["combat/icons/tosx_icon_revive_glow.png"] = Point(-19,7)
    
local a = ANIMS
a.tosx_phoenix = a.BaseUnit:new{Image = "units/mission/tosx_phoenix.png", PosX = -18, PosY = -10}
a.tosx_phoenixa = a.tosx_phoenix:new{Image = "units/mission/tosx_phoenix_a.png", NumFrames = 4 }
a.tosx_phoenix_ns = a.tosx_phoenix:new{Image = "units/mission/tosx_phoenix_ns.png"}
a.tosx_phoenixoff = a.tosx_phoenix:new{Image = "units/mission/tosx_phoenix_off.png"}
a.tosx_phoenixd = a.tosx_phoenix:new{Image = "units/mission/tosx_phoenix_d.png", PosX = -18, PosY = -10, NumFrames = 11, Time = 0.12, Loop = false }
