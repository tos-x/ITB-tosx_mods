
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local bonus = require(path .."missions/bonusObjective")

local this = {id = "tosx_bonus_rocks"}
local rocksBonus = 2

local function getMissionData(mission)
	if mission.tosx_Watchtower == nil then
		mission.tosx_Watchtower = {}
	end

	return mission.tosx_Watchtower
end

local function RocksCleared(mission)
	local starting = getMissionData(mission).startingRocks
	if not starting then
		return 0
	end
	
	local count = 0
	for i = 0,7 do
		for j = 0,7 do
			local current = Point(i,j)
			if Board:GetCustomTile(current) == "tosx_rocks_0.png" then
				count = count + 1
			end
		end
	end
	return math.max(starting - count,0)
	
	-- local mission = GetCurrentMission()
	-- local specimen = true
		-- and mission ~= nil
		-- and mission ~= Mission_Test
		-- and getMissionData(mission).specimen
end

function this.GetStatus(mission, obj, endstate)
	local default = endstate and OBJ_FAILED or OBJ_STANDARD
	return RocksCleared(mission) >= 2 and OBJ_COMPLETE or default
end

function this.GetObjective(mission, obj)
	return Objective("Clear 2 Rocks", 1)
end

function this.Update(mission, obj)
	local status = mission:GetBonusStatus(obj, false)

	Game:AddObjective("Clear 2 Rocks\n("..RocksCleared(mission).."/2)", status)
end

function this.GetInfo(mission, obj, endstate)
	local info = {}
	info.text_id = "Mission_tosx_Rockbreaker"

	if endstate then
		info.success = mission:GetBonusStatus(obj, endstate) == OBJ_COMPLETE
		info.text_id = info.text_id .. (info.success and "_Success" or "_Failure")
	else
		info.text_id = info.text_id .."_Briefing"
	end

	return info
end

local oldStartMission = Mission.StartMission
function Mission.StartMission(self, ...)
	local isBonusRocks = list_contains(self.BonusObjs, this.id)

	if isBonusRocks then
		local count = 0
		for i = 0,7 do
			for j = 0,7 do
				local current = Point(i,j)
				if Board:GetCustomTile(current) == "tosx_rocks_0.png" then
					count = count + 1
				end
			end
		end
		
		-- Manually insert extra rocks if not enough
		if count < 2 then		
			local choices = {}
			for i = 1,6 do
				for j = 1,6 do
					local current = Point(i,j)
					if Board:GetTerrain(current) == TERRAIN_ROAD and
					not Board:IsCracked(current) and
					not Board:IsSpawning(current) and
					not Board:IsAcid(current) and
					not Board:IsItem(current) and
					Board:GetCustomTile(current) == "" then
						choices[#choices+1] = current
					end
				end
			end
		
			local qty = math.max(2 - count, 0)
			while (#choices ~= 0 and qty > 0) do
				local current = random_removal(choices)		
				-- Set the custom terrain image
				Board:SetCustomTile(current,terrainTileImg)
				qty = qty - 1
				count = count + 1
			end
		end
		
		getMissionData(self).startingRocks = count
	end
	oldStartMission(self, ...)
end

bonus:Add(this)