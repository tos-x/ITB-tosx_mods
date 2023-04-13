
local path = GetParentPath(...)
local mod = modApi:getCurrentMod()

local missions = {
	"boostmine",
	"upgrader",
	"tanker",
	"guided",
	"trading",
	"trainrocks",
	"nuclear",
	"sonic",
	"race",
	"battlefield",
}

for _, mission in ipairs(missions) do
	require(path..mission)
end

modApi:appendAssets("img/strategy/mission/", "img/missions/", "")
modApi:appendAssets("img/strategy/mission/small/", "img/missions/small/", "")

-- Add maps here, since some are used by multiple missions
for i = 0, 10 do
	modApi:addMap(mod.resourcePath .."maps/tosx_items".. i ..".map")
end
for i = 0, 7 do
	modApi:addMap(mod.resourcePath .."maps/tosx_water".. i ..".map")
end
for i = 0, 13 do
	modApi:addMap(mod.resourcePath .."maps/tosx_trainrocks".. i ..".map")
end
for i = 0, 10 do
	modApi:addMap(mod.resourcePath .."maps/tosx_race".. i ..".map")
end
for i = 0, 9 do
	modApi:addMap(mod.resourcePath .."maps/tosx_rocky".. i ..".map")
end

-- Bonus objective: add here
-- require(path.."bonusRocks")
-- local bonusRocks = require(path.."bonusRocks_dialog")
-- for personalityId, dialogTable in pairs(bonusRocks) do
	-- Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Rockbreaker", dialogTable)
-- end

--[[
	For some reason, I can't get the bonus objective to work.
	It doesn't always seem to override the mission start and count rocks.
	Also, if I recall, on the off chance it did need to add rocks,
	doing it during start (instead of pre-start) might make them pop in
	when selecting the map (I tried overriding mission start in
	terrainRocks originally, and this happened)
]]

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
