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
    Id = "tosx_lumbermill",
    Name = "Lumber Mill",
    Path = "img/structures/",
    Image = "lumbermill",
    ImageOffset = Point(-20,-2),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("archive")
corpStructureList:addAssets("tosx_lumbermill")