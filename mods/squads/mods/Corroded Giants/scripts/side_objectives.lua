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
    Id = "tosx_teslacoil",
    Name = "Tesla Coil",
    Path = "img/structures/",
    Image = "teslacoil",
    ImageOffset = Point(-15,-4),
    Reward = REWARD_POWER
}

local corpStructureList = easyEdit.structureList:get("pinnacle")
corpStructureList:addAssets("tosx_teslacoil")