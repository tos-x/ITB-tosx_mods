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
    Id = "tosx_shipyard",
    Name = "Shipyard",
    Path = "img/structures/",
    Image = "shipyard",
    ImageOffset = Point(-26,0),
    Reward = REWARD_REP
}

local corpStructureList = easyEdit.structureList:get("archive")
corpStructureList:addAssets("tosx_shipyard")