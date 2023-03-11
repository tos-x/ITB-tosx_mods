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
    Id = "tosx_clocktower",
    Name = "Clocktower",
    Path = "img/structures/",
    Image = "clocktower",
    ImageOffset = Point(-16,-13),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("archive")
corpStructureList:addAssets("tosx_clocktower")