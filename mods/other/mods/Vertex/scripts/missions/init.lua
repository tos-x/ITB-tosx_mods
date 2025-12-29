
local path = GetParentPath(...)
local mod = modApi:getCurrentMod()

local missions = {
    "resurrect",
    "healcrystal",
    "shieldstorm",
    "evac",
    "scoutship",
    "newcrystals",
    "crystalcleanup",
    "meltdown",
    "beamtank",
    "retract",
}

for _, mission in ipairs(missions) do
	require(path..mission)
end

modApi:appendAssets("img/strategy/mission/", "img/missions/", "")
modApi:appendAssets("img/strategy/mission/small/", "img/missions/small/", "")

-- Add maps here, since some are used by multiple missions
for i = 0, 8 do
	modApi:addMap(mod.resourcePath .."maps/tosx_meltdown".. i ..".map")
end
for i = 0, 6 do
	modApi:addMap(mod.resourcePath .."maps/tosx_airship".. i ..".map")
end
for i = 0, 7 do
	modApi:addMap(mod.resourcePath .."maps/tosx_evac".. i ..".map")
end
for i = 0, 9 do
	modApi:addMap(mod.resourcePath .."maps/tosx_beam".. i ..".map")
end
for i = 0, 10 do
	modApi:addMap(mod.resourcePath .."maps/tosx_towers".. i ..".map")
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