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
    Id = "tosx_armory",
    Name = "Armory",
    Path = "img/structures/",
    Image = "armory",
    ImageOffset = Point(-18,-4),
    Reward = REWARD_TECH
}

local corpStructureList = easyEdit.structureList:get("rst")
corpStructureList:addAssets("tosx_armory")