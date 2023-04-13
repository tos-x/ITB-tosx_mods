
-- create boss list
local bossList = easyEdit.bossList:add("Watchtower")

bossList.name = "Watchtower"

local other_bossList = easyEdit.bossList:get("archive")
bossList:copy(other_bossList)

-- add our boss missions to the boss list
-- bossList:addBoss("Mission_ScorpionBoss")
-- bossList:addBoss("Mission_HornetBoss")
-- bossList:addBoss("Mission_BlobBoss")
