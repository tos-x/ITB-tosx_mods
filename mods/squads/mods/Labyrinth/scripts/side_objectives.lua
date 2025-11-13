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
    Id = "tosx_datacenter",
    Name = "Data Center",
    Path = "img/structures/",
    Image = "datacenter",
    ImageOffset = Point(-23,-6),
    Reward = REWARD_POWER
}

local corpStructureList = easyEdit.structureList:get("pinnacle")
corpStructureList:addAssets("tosx_datacenter")