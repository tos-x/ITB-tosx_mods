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
    Id = "tosx_bunker",
    Name = "Bunker",
    Path = "img/structures/",
    Image = "bunker",
    ImageOffset = Point(-17,3),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("archive")
corpStructureList:addAssets("tosx_bunker")