
local HIGH_THREAT = true
local LOW_THREAT = false

-- add default Archive missions
local ml = easyEdit.missionList:get("archive")
ml.addMission(ml._default , "Mission_tosx_Shipping", LOW_THREAT)
ml.addMission(ml._default , "Mission_tosx_Cannon", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Disease", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Siege", HIGH_THREAT)

-- add default Pinnacle missions
local ml = easyEdit.missionList:get("pinnacle")
ml.addMission(ml._default , "Mission_tosx_Juggernaut", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Locusts", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Disease", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Siege", HIGH_THREAT)

-- add default RST missions
local ml = easyEdit.missionList:get("rst")
ml.addMission(ml._default , "Mission_tosx_Zapper", LOW_THREAT)
ml.addMission(ml._default , "Mission_tosx_Earthquake", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Disease", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Siege", HIGH_THREAT)

-- add default Destritus missions
local ml = easyEdit.missionList:get("detritus")
ml.addMission(ml._default , "Mission_tosx_Healrain", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Marathon", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Disease", HIGH_THREAT)
ml.addMission(ml._default , "Mission_tosx_Siege", HIGH_THREAT)
