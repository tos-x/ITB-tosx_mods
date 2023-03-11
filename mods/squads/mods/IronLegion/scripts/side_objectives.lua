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
    Id = "tosx_construction",
    Name = "Construction Platform",
    Path = "img/structures/",
    Image = "construction",
    ImageOffset = Point(-18,-6),
    Reward = REWARD_TECH
}

local corpStructureList = easyEdit.structureList:get("detritus")
corpStructureList:addAssets("tosx_construction")