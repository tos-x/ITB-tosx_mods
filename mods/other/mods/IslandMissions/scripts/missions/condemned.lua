-- mission Mission_tosx_Condemned

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Condemned"}
local corpMissions = require(path .."corpMissions")

Mission_tosx_Condemned = Mission_Infinite:new{
	Name = "Condemned",
	Objectives = Objective("Destroy the empty buildings",1,1),
	Tiles = {},
}
	
function Mission_tosx_Condemned:StartMission()
	local choices = self:GetReplaceableBuildings()
	
	local choice = random_removal(choices)
	Board:SetPopulated(false, choice)
	Board:SetHealth(choice,2,2) -- point, current hp, max hp
	self.Tiles[#self.Tiles+1] = choice
end

function Mission_tosx_Condemned:CountTiles()
	local count = 0
	for i, v in ipairs(self.Tiles) do
		if Board:GetTerrain(v) == TERRAIN_BUILDING then
			count = count + 1
		end
	end
	
	return count
end

function Mission_tosx_Condemned:GetCompletedObjectives()
	local count = self:CountTiles()
	if count == 0 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_Condemned:UpdateObjectives()
	local status = self:CountTiles() == 0 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the empty buildings",status, REWARD_REP, 1)
end

function this:init(mod)
end

function this:load(mod, options, version)
	corpMissions.Add_Missions_Low("Mission_tosx_Condemned")
end

return this