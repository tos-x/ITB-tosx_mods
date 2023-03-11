--[[
easyEdit corp lists:
	"archive"
	"rst"
	"pinnacle"
	"detritus"
Reward types (defined constants):
	REWARD_REP
	REWARD_POWER
	REWARD_TECH
]]

CreateStructure{
    Id = "tosx_aerodrome",
    Name = "Aerodrome",
    Path = "img/structures/",
    Image = "aerodrome",
    ImageOffset = Point(-19,-1),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("detritus")
corpStructureList:addAssets("tosx_aerodrome")