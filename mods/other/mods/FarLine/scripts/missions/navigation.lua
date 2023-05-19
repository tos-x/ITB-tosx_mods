
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")

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

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Buoys\n(0/2 undamaged)", OBJ_FAILED, REWARD_REP, 2)
	end,
	[1] = function()
		Game:AddObjective("Defend the Buoys\n(1/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	[2] = function()
		Game:AddObjective("Defend the Buoys\n(2/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Buoys", 2):Failed() end,
	[1] = function() return Objective("Defend the Buoys (1 destroyed)", 1, 2) end,
	[2] = function() return Objective("Defend the Buoys", 2) end,
	default = function() return nil end,
}

Mission_tosx_Navigation = Mission_Infinite:new{
	Name = "Navigation Buoys",
	MapTags = {"tosx_buoy"},
	Objectives = objAfterMission:case(2),
	Criticals = nil,
	UseBonus = false,
	BuoyCount = 2,
}

-- Add CEO dialog
local dialog = require(path .."missions/navigation_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Navigation", dialogTable)
end

function Mission_tosx_Navigation:StartMission()
	self.Criticals = {}
	local options = extract_table(Board:GetZone("buoy"))
		
	if #options < self.BuoyCount then LOG("ERROR NO VALID SPACE") return end
	
	local choice = random_removal(options)
	local buoy = PAWN_FACTORY:CreatePawn("tosx_buoy1")
	self.Criticals[1] = buoy:GetId()
	Board:AddPawn(buoy, choice)
	
	local choice2 = choice
	while math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 and #options > 0 do
		choice2 = random_removal(options)
	end
	
	if math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 then 
		LOG("ERROR NO VALID SECOND SPACE") 
		return 
	end
		
	buoy = PAWN_FACTORY:CreatePawn("tosx_buoy2")
	self.Criticals[2] = buoy:GetId()
	Board:AddPawn(buoy, choice2)
end

function Mission_tosx_Navigation:UpdateObjectives()
	objInMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Navigation:GetCompletedObjectives()
	return objAfterMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Navigation:GetCompletedStatus()
	if countAlive(self.Criticals) > 1 then
		return "Success"
	elseif countAlive(self.Criticals) == 0 then
		return "Failure"
	else
		return "Partial"
	end
end


tosx_buoy1 = Pawn:new{
	Name = "Navigation Buoy",
	Health = 1,
	Neutral = true,
	Massive = true,
	SpaceColor = false,
	MoveSpeed = 0,
	Image = "tosx_buoy1",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false,
	Mission = true,
}
tosx_buoy2 = tosx_buoy1:new{
	Image = "tosx_buoy2",
}

---------------------

local a = ANIMS
for i = 1,2 do
	modApi:appendAsset("img/units/mission/tosx_buoy"..i..".png", mod.resourcePath .."img/units/mission/buoy"..i..".png")
	modApi:appendAsset("img/units/mission/tosx_buoy"..i.."_ns.png", mod.resourcePath .."img/units/mission/buoy"..i.."_ns.png")
	modApi:appendAsset("img/units/mission/tosx_buoy"..i.."_w.png", mod.resourcePath .."img/units/mission/buoy"..i.."_w.png")

	a["tosx_buoy"..i] = a.BaseUnit:new{Image = "units/mission/tosx_buoy"..i..".png", PosX = -8, PosY = 7}
	a["tosx_buoy"..i.."w"] = a["tosx_buoy"..i]:new{
		Image = "units/mission/tosx_buoy"..i.."_w.png",
		PosX = -11,
		PosY = 2,
		NumFrames = 2,
		Time = 0.6 }
	a["tosx_buoy"..i.."a"] = a["tosx_buoy"..i]:new{}
	a["tosx_buoy"..i.."_ns"] = a["tosx_buoy"..i]:new{Image = "units/mission/tosx_buoy"..i.."_ns.png"}
end