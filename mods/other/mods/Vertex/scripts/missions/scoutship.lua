-- mission Mission_tosx_ScoutShip
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")
local artiArrows = require(path .."libs/artiArrows/artiArrows")
local pawnSpace = require(path .."libs/pawnSpace")

local objAfterMission1 = switch{
	[0] = function() return Objective("Protect the Airship", 1):Failed() end,
	[1] = function() return Objective("Protect the Airship", 1) end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Escort the Airship", 1):Failed() end,
	[1] = function() return Objective("Escort the Airship", 1) end,
	default = function() return nil end,
}

Mission_tosx_ScoutShip = Mission_Infinite:new{
	Name = "Scout Airship",
	MapTags = {"train", "tosx_airship"},
	Objectives = Objective("Protect the Airship", 1),
	UseBonus = true,
	BonusPool = copy_table(missionTemplates.bonusNoKill),
	AirshipPawn = "tosx_ScoutAirship",
	AirshipId = -1,
	TurnLimit = 3,
}

-- Add CEO dialog
local dialog = require(path .."missions/scoutship_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_ScoutShip", dialogTable)
end

function Mission_tosx_ScoutShip:StartMission()
	local airship = PAWN_FACTORY:CreatePawn(self.AirshipPawn)
	self.AirshipId = airship:GetId()
	Board:AddPawn(airship,Point(4,0))
    
    -- Use code to modify train maps; add 0-2 water tiles along route, clear tracks
    if Board:GetCustomTile(Point(4,0)) == "ground_rail.png" then
        local path = {}
        for y = 0,7 do
            local p = Point(4,y)
            Board:SetCustomTile(p,"")
            if y > 0 and y < 7 then
                path[y] = p
            end
        end
        local count = random_int(3) --0,1,2
        for i = 1,count do
            local p = random_removal(path)
            Board:SetTerrain(p,TERRAIN_WATER)
        end
    end
end

function Mission_tosx_ScoutShip:MissionEnd()
	if Board:IsPawnAlive(self.AirshipId) then
		-- Prevent airship from dying as the mission ends
		Board:GetPawn(self.AirshipId):SetTeam(TEAM_NONE)
	end
end

function Mission_tosx_ScoutShip:UpdateObjectives()
	local status = Board:IsPawnAlive(self.AirshipId) and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Protect the Airship",status)
end

function Mission_tosx_ScoutShip:GetCompletedObjectives()
	if Board:IsPawnAlive(self.AirshipId) then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_ScoutShip:GetCompletedStatus()
	if Board:IsPawnAlive(self.AirshipId) then
		return "Success"
	else
		return "Failure"
	end
end

tosx_ScoutAirship = Pawn:new{
	Name = "Scout Airship",
	Health = 1,
	Neutral = true,
	Image = "tosx_scoutship",
	MoveSpeed = 0,
	SkillList = { "tosx_Scoutship_Move" },
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	IgnoreFlip = true,
	IgnoreFire = true,
	SoundLocation = "/mech/flying/jet_mech/",
	Corporate = true,
	IsPortrait = false,
    Flying = true,
	Minor = true,
}

tosx_Scoutship_Move = Skill:new{
	Name = "Scout Ahead!",
	Description = "Leap forward 2 spaces, but will be destroyed if final tile is blocked.",
	Class = "Enemy",
	LaunchSound = "/weapons/bomb_strafe",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,1),
		Enemy = Point(2,2),
		Enemy2 = Point(2,3),
		Target = Point(2,3),
		CustomPawn = "tosx_ScoutAirship",
	}
}

function tosx_Scoutship_Move:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point + VEC_DOWN*2)
	return ret
end

function tosx_Scoutship_Move:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
    
    local move = PointList()
    move:push_back(p1)
    move:push_back(p2)

    -- preview pawn moving,
    -- but hide pawn so it fails.
    pawnSpace.QueuedClearSpace(ret, p1)
    ret:AddQueuedMove(move, NO_DELAY)
    pawnSpace.QueuedRewind(ret)

    local d = SpaceDamage(p1)
    d.sImageMark = artiArrows.ColorUp(2) --2 = VEC_DOWN direction
    ret:AddQueuedDamage(d)

    -- actual leap via script to hide preview.
    ret:AddQueuedScript(string.format([[
        local leap = PointList();
        leap:push_back(%s);
        leap:push_back(%s);
        fx = SkillEffect();
        fx:AddLeap(leap, NO_DELAY);
        Board:AddEffect(fx);
    ]], p1:GetString(), p2:GetString()))    

    local d = SpaceDamage(p2)
    d.sImageMark = artiArrows.ColorDown(2) --2 = VEC_DOWN direction
    if Board:IsBlocked(p2, PATH_PROJECTILE) then
        ret:AddQueuedDelay(.7)
        d.sImageMark = "combat/arrow_hit.png" --crash
        d.iDamage = DAMAGE_DEATH
    end
    ret:AddQueuedDamage(d)
    
	return ret
end

function tosx_Scoutship_Move:GetTargetScore(p1, p2)
	return 100
end

modApi:appendAsset("img/units/mission/tosx_scoutship.png", mod.resourcePath .."img/units/mission/scoutship.png")
modApi:appendAsset("img/units/mission/tosx_scoutship_ns.png", mod.resourcePath .."img/units/mission/scoutship_ns.png")
modApi:appendAsset("img/units/mission/tosx_scoutship_d.png", mod.resourcePath .."img/units/mission/scoutship_d.png")
modApi:appendAsset("img/units/mission/tosx_scoutship_a.png", mod.resourcePath .."img/units/mission/scoutship_a.png")

local a = ANIMS
a.tosx_scoutship 	  = a.BaseUnit:new{ Image = "units/mission/tosx_scoutship.png", PosX = -22, PosY = -10 }
a.tosx_scoutshipa   = a.tosx_scoutship:new{ Image = "units/mission/tosx_scoutship_a.png", PosY = -11, Time = 0.5, NumFrames = 4 }
a.tosx_scoutship_ns = a.tosx_scoutship:new{ Image = "units/mission/tosx_scoutship_ns.png"}
a.tosx_scoutshipd   = a.tosx_scoutship:new{ Image = "units/mission/tosx_scoutship_d.png", PosX = -22, PosY = -11, NumFrames = 11, Time = 0.14, Loop = false }