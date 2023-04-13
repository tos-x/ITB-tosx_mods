
-- create mission list
local missionList = easyEdit.missionList:add("IslandMissions")

missionList.name = "Island Missions"

local HIGH_THREAT = true
local LOW_THREAT = false

-- add our missions to the mission list
missionList:addMission("Mission_tosx_Shipping", LOW_THREAT)
missionList:addMission("Mission_tosx_Zapper", LOW_THREAT)

missionList:addMission("Mission_tosx_Cannon", HIGH_THREAT)
missionList:addMission("Mission_tosx_Disease", HIGH_THREAT)
missionList:addMission("Mission_tosx_Earthquake", HIGH_THREAT)
missionList:addMission("Mission_tosx_Healrain", HIGH_THREAT)
missionList:addMission("Mission_tosx_Juggernaut", HIGH_THREAT)
missionList:addMission("Mission_tosx_Locusts", HIGH_THREAT)
missionList:addMission("Mission_tosx_Marathon", HIGH_THREAT)
missionList:addMission("Mission_tosx_Siege", HIGH_THREAT)