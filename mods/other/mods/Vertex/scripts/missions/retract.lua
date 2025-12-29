-- mission Mission_tosx_Retract
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

-- returns number of pawns alive
-- in a list of pawn id's.
local function countAlive(list)
	assert(type(list) == 'table', "table ".. tostring(list) .." not a table")
	local ret = 0
	for _, id in ipairs(list) do
		if type(id) == 'number' then
			ret = ret + (Board:IsPawnAlive(id) and 1 or 0)
		else
			error("variable of type ".. type(id) .." is not a number")
		end
	end
	
	return ret
end

Mission_tosx_Retract = Mission_Infinite:new{
	Name = "Retract Antennas",
	MapTags = {"tosx_towers"},
	Objectives = Objective("Retract both Antennas", 1),
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = true,
	Criticals = nil,
	TowerPawn = "tosx_RetractTower",
    Retracted = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/retract_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Retract", dialogTable)
end

function Mission_tosx_Retract:StartMission()
	self.Criticals = {}
	local zone = extract_table(Board:GetZone("satellite"))
    
	local choice = random_removal(zone)
	Board:ClearSpace(choice)    
	local tower = PAWN_FACTORY:CreatePawn(self.TowerPawn)
	self.Criticals[1] = tower:GetId()
	Board:AddPawn(tower, choice)
    Board:SetCustomTile(choice,"tosx_towersite.png")
    
	choice = random_removal(zone)
	Board:ClearSpace(choice)    
	local tower2 = PAWN_FACTORY:CreatePawn(self.TowerPawn)
	self.Criticals[2] = tower2:GetId()
	Board:AddPawn(tower2, choice)
    Board:SetCustomTile(choice,"tosx_towersite.png")
end

local rtimer = 0
function Mission_tosx_Retract:UpdateMission()
	if rtimer > 0 then rtimer = rtimer -1 end
end

function Mission_tosx_Retract:UpdateObjectives()
    if (countAlive(self.Criticals) + self.Retracted) < 2 then
        Game:AddObjective("Retract both Antennas",OBJ_FAILED)
    else
        local status = self.Retracted == 2 and OBJ_COMPLETE or OBJ_STANDARD
        Game:AddObjective("Retract both Antennas\n("..self.Retracted.."/2 retracted)",status)
    end
end

function Mission_tosx_Retract:GetCompletedObjectives()
	if self.Retracted == 2 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_Retract:GetCompletedStatus()
	if self.Retracted == 2 then
		return "Success"
	else
		return "Failure"
	end
end

tosx_RetractTower = Pawn:new{
	Name = "Transmission Antenna",
	Image = "tosx_retracter",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "tosx_Retracter" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/support/satellite/",
	Pushable = false,
	IgnoreSmoke = true,
	LargeShield = true,
	SpaceColor = false,
	Neutral = true,
	IsPortrait = false,
}

tosx_Retracter = Skill:new{
	Name = "Emergency Retraction",
	Description = "Retract underground to avoid danger. Requires an adjacent Mech.",
	Class = "Unique",
	LaunchSound = "/support/civilian_truck/move",
	TipImage = {
		Unit = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Length = 6,
		CustomPawn = "tosx_RetractTower"
	}
}

function tosx_Retracter:GetTargetArea(p1)
	local ret = PointList()
    if Board:IsTipImage() and Board:GetCustomTile(p1) ~= "tosx_towersite.png" then
        Board:SetCustomTile(p1,"tosx_towersite.png")
    end
    for dir = DIR_START, DIR_END do
        local p = p1 + DIR_VECTORS[dir]
        if Board:IsValid(p) and Board:IsPawnSpace(p) and Board:GetPawn(p):IsMech() and not Board:GetPawn(p):IsDead() then
            ret:push_back(p1)
            break
        end
    end
	return ret
end

function tosx_Retracter:GetSkillEffect(p1, p2)    
	local ret = SkillEffect()
    local ismech = false
    
    local dummy = SpaceDamage(p1)
    dummy.sImageMark = "combat/icons/tosx_icon_retract_glow.png"
    dummy.sScript = "Board:GetPawn("..p1:GetString().."):SetCustomAnim('tosx_retractera2')"
    ret:AddQueuedDamage(dummy)
    
    ret:AddQueuedDelay(1.43)
    
    local dummy2 = SpaceDamage(p1)
    dummy2.bHide = true
    dummy2.sScript = [[        
        Board:RemovePawn(]]..p1:GetString()..[[)
        Board:SetCustomTile(]]..p1:GetString()..[[,"tosx_towersite2.png")
    ]]
    ret:AddQueuedDamage(dummy2)
    
    if not Board:IsTipImage() then
        ret:AddQueuedScript([[
            local mission = GetCurrentMission() 
            if not mission then return end 
            mission.Retracted = mission.Retracted + 1
            ]])
    end
    
	return ret
end

function tosx_Retracter:GetTargetScore(p1,p2)
	return 10
end

modApi:appendAsset("img/units/mission/tosx_phoenix.png", mod.resourcePath .."img/units/mission/retracter.png")
modApi:appendAsset("img/units/mission/tosx_retracter_ns.png", mod.resourcePath .."img/units/mission/retracter_ns.png")
modApi:appendAsset("img/units/mission/tosx_retracter_a.png", mod.resourcePath .."img/units/mission/retracter_a.png")
modApi:appendAsset("img/units/mission/tosx_retracter_d.png", mod.resourcePath .."img/units/mission/retracter_d.png")

modApi:appendAsset("img/units/mission/tosx_retracter_a2.png", mod.resourcePath .."img/units/mission/retracter_a2.png")

modApi:appendAsset("img/combat/icons/tosx_icon_retract_glow.png", mod.resourcePath.."img/combat/icons/icon_retract_glow.png")
    Location["combat/icons/tosx_icon_retract_glow.png"] = Point(-15,13)
    
local a = ANIMS
a.tosx_retracter = a.BaseUnit:new{Image = "units/mission/tosx_retracter.png", PosX = -10, PosY = -10}
a.tosx_retractera = a.tosx_retracter:new{Image = "units/mission/tosx_retracter_a.png", NumFrames = 4, PosY = -12 }
a.tosx_retracter_ns = a.tosx_retracter:new{Image = "units/mission/tosx_retracter_ns.png"}
a.tosx_retracterd = a.tosx_retracter:new{Image = "units/mission/tosx_retracter_d.png", PosX = -22, PosY = -10, NumFrames = 11, Time = 0.12, Loop = false }

a.tosx_retractera2 = a.BaseUnit:new{
	Image = "units/mission/tosx_retracter_a2.png",
	NumFrames = 13,
	Time = 0.22,--for some reason, when used as a unit anim, this seems to get cut in half; total time = 13*0.22*0.5 = 1.43
	PosX = -14,
    Loop = false,
    PosY = -10
}

local function resetMove(mission)
	if not mission or mission.ID ~= "Mission_tosx_Retract" then return end
    mission.pMoveCount = 0
    mission.aMoveCount = {}
    mission.aMoveCount[1] = -1
    mission.aMoveCount[2] = -1
end
	
local function onPawnUndoMove(mission, pawn, oldPosition)
	if not mission or mission.ID ~= "Mission_tosx_Retract" then return end
    mission.pMoveCount = mission.pMoveCount or 1
    for i = 1,2 do
        if mission.pMoveCount == mission.aMoveCount[i] then
            Board:GetPawn(mission.Criticals[i]):ClearQueued()
            Game:TriggerSound("/ui/battle/power_down")
            Board:Ping(Board:GetPawnSpace(mission.Criticals[i]), GL_Color(255, 255, 255))
            mission.aMoveCount[i] = -1
        end
    end
    mission.pMoveCount = mission.pMoveCount - 1
end

local function onSkillStart(mission, pawn, weaponId, p1, p2)
	if not mission or mission.ID ~= "Mission_tosx_Retract" then return end
    if not pawn or pawn:GetTeam() ~= TEAM_PLAYER then return end
    if not mission.aMoveCount then resetMove(mission) end
    
	if weaponId == "Move" then
        mission.pMoveCount = mission.pMoveCount or 0
        mission.pMoveCount = mission.pMoveCount + 1
        
        for dir = DIR_START, DIR_END do
            local p = p2 + DIR_VECTORS[dir]
            if Board:IsPawnSpace(p) then
                for i = 1,2 do
                    if Board:GetPawn(p):GetId() == mission.Criticals[i] and mission.aMoveCount[i] == -1 then
                        mission.aMoveCount[i] = mission.pMoveCount
                        local fx = SkillEffect()
                        fx:AddScript("Board:GetPawn("..p:GetString().."):FireWeapon("..p:GetString()..",1)")
                        fx:AddSound("/ui/map/flyin_rewards");
                        fx:AddScript("Board:Ping("..p:GetString()..", GL_Color(255, 255, 255))")
                        
                        local chance = math.random()
                        if chance > 0.2 and Game:GetTurnCount() > 0 and rtimer == 0 then
                            local cast = pawn:GetId()
                            fx:AddVoice("Mission_tosx_Retracting", cast)
                            rtimer = 500
                        end
                        
                        Board:AddEffect(fx)
                    end
                end
            end
        end
	end
end

modApi.events.onMissionStart:subscribe(resetMove)
modApi.events.onNextTurn:subscribe(resetMove)
modapiext.events.onPawnUndoMove:subscribe(onPawnUndoMove)
modapiext.events.onSkillStart:subscribe(onSkillStart)
