
-- create enemy list
local enemyList = easyEdit.enemyList:add("FarLine")

enemyList.name = "Far Line"

local other_enemyList = easyEdit.enemyList:get("archive")
enemyList:copy(other_enemyList)

-- add our enemies to the enemy list
-- enemyList:addEnemy("Scorpion", "Core")
-- enemyList:addEnemy("Beetle", "Unique")
-- enemyList:addEnemy("Snowart", "Bot")
-- enemyList:addEnemy("Jelly_Explode", "Leaders")
