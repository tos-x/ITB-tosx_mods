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
    Id = "tosx_oresilo",
    Name = "Ore Silo",
    Path = "img/structures/",
    Image = "oresilo",
    ImageOffset = Point(-22,-4),
    Reward = REWARD_POWER
}

local corpStructureList = easyEdit.structureList:get("detritus")
corpStructureList:addAssets("tosx_oresilo")