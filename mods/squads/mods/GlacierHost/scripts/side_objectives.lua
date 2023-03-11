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
    Id = "tosx_watchtower",
    Name = "Watchtower",
    Path = "img/structures/",
    Image = "watchtower",
    ImageOffset = Point(-13,-4),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("pinnacle")
corpStructureList:addAssets("tosx_watchtower")