
-- create mission list
local missionList = easyEdit.missionList:add("FarLine")

missionList.name = "Far Line"

local HIGH_THREAT = true
local LOW_THREAT = false

-- add our missions to the mission list

missionList:addMission("Mission_tosx_IceVek", LOW_THREAT)
missionList:addMission("Mission_tosx_Seamine", LOW_THREAT)
missionList:addMission("Mission_tosx_Waves", LOW_THREAT)
missionList:addMission("Mission_tosx_Spillway", LOW_THREAT)
missionList:addMission("Mission_tosx_RunawayTrain", LOW_THREAT)

missionList:addMission("Mission_tosx_Ocean", HIGH_THREAT)
missionList:addMission("Mission_tosx_Submarine", HIGH_THREAT)
missionList:addMission("Mission_tosx_Navigation", HIGH_THREAT)
missionList:addMission("Mission_tosx_Lighthouse", HIGH_THREAT)
missionList:addMission("Mission_tosx_Delivery", HIGH_THREAT)


if mod_loader.mods["tosx_island_missons"] and mod_loader.mods["tosx_island_missons"].initialized then
	missionList:addMission("Mission_tosx_Disease", HIGH_THREAT)
	missionList:addMission("Mission_tosx_Siege", HIGH_THREAT)
end