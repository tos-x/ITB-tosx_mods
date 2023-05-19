
local mod = modApi:getCurrentMod()
local path = mod.scriptPath

Mission_tosx_RunawayTrain = Mission_Infinite:new{
	Name = "Runaway Train",
	MapTags = {"train"},
	Objectives = Objective("Stop the Runaway Train",1,1),
	TrainPawn = "tosx_RunawayTrain",
	RTrain = -1,
	TrainLoc = Point(-1,-1),
	TurnLimit = 3,
	UseBonus = false,
}

-- Add CEO dialog
local dialog = require(path .."missions/runawaytrain_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_RunawayTrain", dialogTable)
end

function Mission_tosx_RunawayTrain:StartMission()
	local train = PAWN_FACTORY:CreatePawn(self.TrainPawn)
	self.RTrain = train:GetId()
	Board:AddPawn(train,Point(4,6))
end

function Mission_tosx_RunawayTrain:MissionEnd()
	if Board:IsPawnAlive(self.RTrain) then
		-- Prevent train from dying as the mission ends
		Board:GetPawn(self.RTrain):SetTeam(TEAM_NONE)
	end
end

function Mission_tosx_RunawayTrain:UpdateObjectives()
	local status = not Board:IsPawnAlive(self.RTrain) and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the Train",status)
end

function Mission_tosx_RunawayTrain:GetCompletedObjectives()
	if Board:IsPawnAlive(self.RTrain) then
		return self.Objectives:Failed()
	end
	return self.Objectives
end

function Mission_tosx_RunawayTrain:GetCompletedStatus()
	if not Board:IsPawnAlive(self.RTrain) then
		return "Success"
	else
		return "Failure"
	end
end

tosx_RunawayTrain = Pawn:new{
	Name = "Runaway Train",
	Health = 2,
	Image = "tosx_Rtrain_dual",
	MoveSpeed = 0,
	SkillList = { "tosx_RTrain_Move" },
	DefaultTeam = TEAM_ENEMY,
	IgnoreSmoke = true,
	IgnoreFlip = true,
	IgnoreFire = true,
	ExtraSpaces = { Point(0,1) },
	SoundLocation = "/support/train",
	Pushable = false,
	Corporate = true,
	IsPortrait = false,
	Minor = true,
}

tosx_RTrain_Move = Armored_Train_Move:new{
	Name = "Runaway Charge!",
	Description = "Move forward 2 spaces, destroying anything in its path.",
	Class = "Enemy",
	AttackAnimation = "ExploArt2",
	LaunchSound = "/support/train/move",
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "tosx_RunawayTrain",
	}
}

modApi:appendAsset("img/units/mission/tosx_Rtrain.png", mod.resourcePath .."img/units/mission/Rtrain.png")
modApi:appendAsset("img/units/mission/tosx_Rtrain_death.png", mod.resourcePath .."img/units/mission/Rtrain_death.png")
modApi:appendAsset("img/units/mission/tosx_Rtraina.png", mod.resourcePath .."img/units/mission/Rtraina.png")

local a = ANIMS
a.tosx_Rtrain_dual =	a.BaseUnit:new{ Image = "units/mission/tosx_Rtrain.png", PosX = -51, PosY = 3 }
a.tosx_Rtrain_duald =	a.tosx_Rtrain_dual:new{ Image = "units/mission/tosx_Rtrain_death.png", NumFrames = 12, Time = 0.14, Loop = false }
a.tosx_Rtrain_duala =	a.tosx_Rtrain_dual:new{ Image = "units/mission/tosx_Rtraina.png", NumFrames = 4, Time = 0.2 }