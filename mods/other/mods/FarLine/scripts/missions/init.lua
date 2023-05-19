
local path = GetParentPath(...)
local mod = modApi:getCurrentMod()

local missions = {
	"ocean",
	"submarine",
	"icevek",
	"seamine",
	"navigation",
	"waves",
	"lighthouse",
	"spillway",
	"delivery",
	"runawaytrain",
}

for _, mission in ipairs(missions) do
	require(path..mission)
end

modApi:appendAssets("img/strategy/mission/", "img/missions/", "")
modApi:appendAssets("img/strategy/mission/small/", "img/missions/small/", "")

-- Add maps here, since some are used by multiple missions
for i = 0, 20 do
	modApi:addMap(mod.resourcePath .."maps/tosx_smallisland".. i ..".map")
end
for i = 0, 3 do
	modApi:addMap(mod.resourcePath .."maps/tosx_bigisland".. i ..".map")
end
for i = 0, 37 do
	modApi:addMap(mod.resourcePath .."maps/tosx_island".. i ..".map")
end
for i = 0, 13 do
	modApi:addMap(mod.resourcePath .."maps/tosx_ocean".. i ..".map")
end
for i = 0, 10 do
	modApi:addMap(mod.resourcePath .."maps/tosx_waves".. i ..".map")
end
for i = 0, 10 do
	modApi:addMap(mod.resourcePath .."maps/tosx_lighthouse".. i ..".map")
end
for i = 0, 6 do
	modApi:addMap(mod.resourcePath .."maps/tosx_delivery".. i ..".map")
end



require(path.."voice_units")

-- AE pilots don't use the old method; have to make old-style personalities
local AEpilots = {
	"Chemical",
	"Arrogant",
	"Caretaker",
	"Delusional",
}

for _, personalityId in ipairs(AEpilots) do
	if not Personality[personalityId] then
		local personality = CreatePilotPersonality(personalityId)
		Personality[personalityId] = personality
		
	end
end

local extraDialog = require(path.."extra_dialog")
for personalityId, dialogTable in pairs(extraDialog) do
	Personality[personalityId]:AddDialogTable(dialogTable)
end