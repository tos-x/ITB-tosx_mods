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
    Id = "tosx_command",
    Name = "Command Post",
    Path = "img/structures/",
    Image = "command",
    ImageOffset = Point(-23,-4),
    Reward = REWARD_TECH
}

local corpStructureList = easyEdit.structureList:get("rst")
corpStructureList:addAssets("tosx_command")