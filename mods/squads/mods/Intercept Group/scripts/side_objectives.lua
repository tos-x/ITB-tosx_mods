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
    Id = "tosx_garage",
    Name = "Garage",
    Path = "img/structures/",
    Image = "garage",--!!!
    ImageOffset = Point(-20,-2),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("rst")
corpStructureList:addAssets("tosx_garage")