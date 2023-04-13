
-- create mission list
local missionList = easyEdit.missionList:add("Watchtower")

missionList.name = "Watchtower"

local HIGH_THREAT = true
local LOW_THREAT = false

-- add our missions to the mission list
missionList:addMission("Mission_tosx_BoostMine", LOW_THREAT)
missionList:addMission("Mission_tosx_Guided", LOW_THREAT)
missionList:addMission("Mission_tosx_Nuclear", LOW_THREAT)
missionList:addMission("Mission_tosx_Sonic", LOW_THREAT)
missionList:addMission("Mission_tosx_Battlefield", LOW_THREAT)

missionList:addMission("Mission_tosx_Upgrader", HIGH_THREAT)
missionList:addMission("Mission_tosx_Tanker", HIGH_THREAT)
missionList:addMission("Mission_tosx_Trading", HIGH_THREAT)
missionList:addMission("Mission_tosx_TrainRocks", HIGH_THREAT)
missionList:addMission("Mission_tosx_Rallyrace", HIGH_THREAT)
