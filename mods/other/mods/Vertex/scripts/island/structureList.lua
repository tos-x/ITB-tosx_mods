
-- create structure list
local structureList = easyEdit.structureList:add("Vertex")

structureList.name = "Vertex"

-- add our structures to the structure list
structureList:addAssets(
	"Str_EngHall_tosx",
	"Str_Fortress_tosx",
	"Str_Transmission_tosx",
	"Str_EnergyMatrix_tosx", -- 2 of these, to match the 2 coal plants in vanilla
	"Str_EnergyMatrix_tosx"
)