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
    Id = "tosx_borehole",
    Name = "Borehole",
    Path = "img/structures/",
    Image = "borehole",
    ImageOffset = Point(-27,-8),
    Reward = REWARD_POWER
}

local corpStructureList = easyEdit.structureList:get("rst")
corpStructureList:addAssets("tosx_borehole")