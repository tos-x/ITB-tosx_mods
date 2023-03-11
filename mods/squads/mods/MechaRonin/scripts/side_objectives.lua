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
    Id = "tosx_sanctuary",
    Name = "Sanctuary",
    Path = "img/structures/",
    Image = "sanctuary",
    ImageOffset = Point(-28,-8),
    Reward = REWARD_TECH
}

local corpStructureList = easyEdit.structureList:get("pinnacle")
corpStructureList:addAssets("tosx_sanctuary")