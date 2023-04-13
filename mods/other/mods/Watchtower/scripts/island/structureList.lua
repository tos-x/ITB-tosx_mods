
-- create structure list
local structureList = easyEdit.structureList:add("Watchtower")

structureList.name = "Watchtower"

-- add our structures to the structure list
structureList:addAssets(
	"Str_Trading_Post_tosx",
	"Str_Pumpjack_tosx",
	"Str_Pumpjack_tosx", -- 2 of these, to match the 2 coal plants in vanilla
	"Str_Turbine_tosx",
	"Str_Quarry_tosx",
	"Str_Refinery_tosx"
)