
-- create mission list
local missionList = easyEdit.missionList:add("Vertex")

missionList.name = "Vertex"

local HIGH_THREAT = true
local LOW_THREAT = false

-- add our missions to the mission list
missionList:addMission("Mission_tosx_Retract", LOW_THREAT)
missionList:addMission("Mission_tosx_Meltdown", LOW_THREAT)
missionList:addMission("Mission_tosx_NewCrystals", LOW_THREAT)
missionList:addMission("Mission_tosx_Shieldstorm", LOW_THREAT)
missionList:addMission("Mission_tosx_ScoutShip", LOW_THREAT)

missionList:addMission("Mission_tosx_BeamTank", HIGH_THREAT)
missionList:addMission("Mission_tosx_CrystalCleanup", HIGH_THREAT)
missionList:addMission("Mission_tosx_Evac", HIGH_THREAT)
missionList:addMission("Mission_tosx_Resurrect", HIGH_THREAT)
missionList:addMission("Mission_tosx_HealCrystal", HIGH_THREAT)

if mod_loader.mods["tosx_island_missons"] and mod_loader.mods["tosx_island_missons"].initialized then
	missionList:addMission("Mission_tosx_Disease", HIGH_THREAT)
	missionList:addMission("Mission_tosx_Siege", HIGH_THREAT)
end