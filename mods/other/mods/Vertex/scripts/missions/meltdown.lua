--mission Mission_tosx_Meltdown
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Meltdown = Mission_Infinite:new{
	Name = "Reactor Meltdown",
	MapTags = {"tosx_meltdown"},
	Objectives = Objective("Destroy the Reactor",1,1),
	ReactorPawn = "tosx_ReactorFailing",
	BonusPool = copy_table(missionTemplates.bonusNoMercy),
	UseBonus = true,
	ReactorID = -1,
	ReactorStrength = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/meltdown_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Meltdown", dialogTable)
end

function Mission_tosx_Meltdown:StartMission()
	local options = extract_table(Board:GetZone("reactor"))	
	local choice = random_removal(options)
    
	local reactor = PAWN_FACTORY:CreatePawn(self.ReactorPawn)
	self.ReactorID = reactor:GetId()
	Board:AddPawn(reactor,choice)
	reactor:SetTeam(TEAM_ENEMY)
end

function Mission_tosx_Meltdown:NextTurn()
	if Game:GetTeamTurn() ~= TEAM_ENEMY then return end
	if self.ReactorStrength < 1 then
        self.ReactorStrength = 0
    end
	if self.ReactorStrength < 14 then
        self.ReactorStrength = self.ReactorStrength + 1
    end
end

function Mission_tosx_Meltdown:IsGone()
	return not Board:IsPawnAlive(self.ReactorID)
end

function Mission_tosx_Meltdown:GetCompletedObjectives()
	if self:IsGone() then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_Meltdown:UpdateObjectives()
	local status = self:IsGone() and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the Reactor",status, REWARD_REP, 1)
end
-------------------------------------------------------------------- 
tosx_ReactorFailing = Pawn:new{
	Name = " Failing Reactor",
	Health = 2,
	Neutral = true,
	Image = "tosx_ReactorFailing",
	MoveSpeed = 0,
	SkillList = { "tosx_ReactorExplode" },
	DefaultTeam = TEAM_ENEMY,
	IgnoreSmoke = true,
	IgnoreFlip = true,
	SoundLocation = "/support/train",
	Pushable = false,
	SpaceColor = false,
	Minor = true,
	IsPortrait = false,
}
tosx_ReactorExplode = Skill:new{
	Name = "Criticality Event",
	Description = "Kills everything nearby. Radius increases each turn.",
	Class = "Enemy",
	Damage = DAMAGE_DEATH,
	--LaunchSound = "/props/pylon_fall",
	ImpactSound = "/impact/generic/explosion_large",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(3,2),
        Building = Point (1,2),
		Target = Point(2,2),
		CustomPawn = "tosx_ReactorFailing"
	}
}

function tosx_ReactorExplode:GetTargetArea(p1)
	local ret = PointList()
	ret:push_back(p1)
	return ret
end

function tosx_NukeGrayDialog(point)
LOG("nuke")
	local effect = SkillEffect()
    effect:AddScript([[
        SuppressDialog(1200,"Death_Revived")
        SuppressDialog(1200,"PilotDeath")
        SuppressDialog(1200,"Mech_Repaired")
        SuppressDialog(1200,"Mech_LowHealth")
        SuppressDialog(1200,"Pilot_Skill_Gray")
    ]])
    -- PilotDeath event has the calls to Death_Main and Death_Response

    effect:AddScript([[
        local cast = { main = ]]..Board:GetPawn(point):GetId()..[[ }
        modapiext.dialog:triggerRuledDialog("Mission_tosx_NuclearGray", cast)
    ]])
	Board:AddEffect(effect)
end

function tosx_ReactorExplode:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	if not mission then return end
	
	local ret = SkillEffect()
    
	local strength = 1
	if not Board:IsTipImage() then
		strength = mission.ReactorStrength
	end
	
    local damage0 = SpaceDamage(p1)
    damage0.bHide = true
    damage0.sAnimation = "tosx_explocrysmain2"
    ret:AddQueuedDamage(damage0)
    
    local dummy = SpaceDamage(p1)
    dummy.bHide = true
    dummy.sSound = "/ui/battle/abandon_timeline_warning"
    for i = 1,3 do
        ret:AddQueuedDamage(dummy)
        ret:AddQueuedDelay(0.2)
    end
    
    local damage = SpaceDamage(p1, self.Damage)
    damage.sSound = self.ImpactSound
    damage.sAnimation = "tosx_explocrysmain1"
        
    local zone = general_DiamondTarget(p1,strength)
    
	for i = 1, zone:size() do
		local point = zone:index(i)
        if point ~= p1 then
            damage.loc = point
            
            -- Special interaction with Gray
            if Board:IsPawnSpace(point) and Board:GetPawn(point):IsAbility("GraySkill") then                
                local gray = SpaceDamage(point)
                gray.sImageMark = "combat/icons/tosx_icon_nuclear1_glow.png"
                gray.sAnimation = "tosx_RadBlast"
                gray.sSound = "/impact/generic/explosion"
                gray.sScript = "tosx_NukeGrayDialog("..point:GetString()..")"
                ret:AddQueuedScript("Board:GetPawn("..point:GetString().."):SetHealth(1)")
                ret:AddQueuedDamage(gray)
            else
                ret:AddQueuedDamage(damage)
            end
        end
	end
	
    ret:AddVoice("Mission_tosx_MeltingDown", -1)
    
	return ret
end

function tosx_ReactorExplode:GetTargetScore(p1, p2)
	return 100
end
	
modApi:appendAsset("img/units/mission/tosx_reactorfail.png", mod.resourcePath .."img/units/mission/reactorfail.png")
modApi:appendAsset("img/units/mission/tosx_reactorfaila.png", mod.resourcePath .."img/units/mission/reactorfail_a.png")
modApi:appendAsset("img/units/mission/tosx_reactorfail_death.png", mod.resourcePath .."img/units/mission/reactorfail_d.png")
modApi:appendAsset("img/units/mission/tosx_reactorfail_ns.png", mod.resourcePath .."img/units/mission/reactorfail_ns.png")

modApi:appendAsset("img/combat/icons/tosx_icon_nuclear1_glow.png", mod.resourcePath.."img/combat/icons/icon_nuclear1_glow.png")
    Location["combat/icons/tosx_icon_nuclear1_glow.png"] = Point(-16,7)

modApi:appendAsset("img/effects/tosx_rad_a.png",mod.resourcePath.."img/effects/tosx_rad_a.png")

local a = ANIMS
a.tosx_ReactorFailing 	= a.BaseUnit:new{ Image = "units/mission/tosx_reactorfail.png", PosX = -18, PosY = 5 }
a.tosx_ReactorFailinga 	= a.tosx_ReactorFailing:new{ Image = "units/mission/tosx_reactorfaila.png", NumFrames = 4 }
a.tosx_ReactorFailingd 	= a.tosx_ReactorFailing:new{ Image = "units/mission/tosx_reactorfail_death.png", PosX = -21, PosY = -9, NumFrames = 11, Time = 0.14, Loop = false }
a.tosx_ReactorFailing_ns	= a.tosx_ReactorFailing:new{ Image = "units/mission/tosx_reactorfail_ns.png", }

a.tosx_RadBlast = Animation:new{
	Image = "effects/tosx_rad_a.png",
	NumFrames = 8,
	Time = 0.08,
	PosX = -33,
	PosY = -14
}

local function onModsLoaded()
	modapiext.dialog:addRuledDialog("Mission_tosx_NuclearGray", {
		Odds = 100,
		{ main = "Mission_tosx_NuclearGray" },
	})
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)