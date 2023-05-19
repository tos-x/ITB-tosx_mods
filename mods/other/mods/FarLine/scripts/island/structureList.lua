
-- create structure list
local structureList = easyEdit.structureList:add("FarLine")

structureList.name = "Far Line"

-- add our structures to the structure list
structureList:addAssets(
	"Str_Warehouse_tosx",
	"Str_WeatherStation_tosx",
	"Str_Bioreactor_tosx",
	"Str_FuelCell_tosx", -- 2 of these, to match the 2 coal plants in vanilla
	"Str_FuelCell_tosx"
)