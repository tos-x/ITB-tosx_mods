
local mod = modApi:getCurrentMod()
local path = mod.scriptPath

Mission_tosx_TrainRocks = Mission_Train:new{
	Name = "Rocky Train",
	MapTags = {"tosx_rocktrain"}, -- converted train0-10, trainAE1-3
	BlockedUnits = {"Digger", "Dung"}, --Limit rocks
}

-- Add CEO dialog
local dialog = require(path .."missions/trainrocks_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_TrainRocks", dialogTable)
end

function Mission_tosx_TrainRocks:StartMission()
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end
	
	local train = PAWN_FACTORY:CreatePawn(self.TrainPawn)
	self.Train = train:GetId()
	Board:AddPawn(train,Point(4,6))
	
	local rock = PAWN_FACTORY:CreatePawn("Wall")
	local options = extract_table(Board:GetZone("rocks"))
	Board:AddPawn(rock,random_removal(options))	
end