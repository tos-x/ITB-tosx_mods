
local this = {}
local scriptPath = mod_loader.mods[modApi.currentMod].scriptPath
local path = scriptPath .."missions/"

local function file_exists(name)
	local f = io.open(name, "r")
	if f then io.close(f) return true else return false end
end

local function loadMissionDialog(missionId, file)
	local name = file:sub(1, -5)
	
	if file_exists(file) then
	--	LOG("loading dialog from '".. file .."'")
		local dialog = require(name)
		
		for person, dialogTable in pairs(dialog) do
			Personality[person]:AddMissionDialogTable(missionId, dialogTable)
		end
	else
	--	LOG("unable to find dialog file '".. file .."'")
	end
end

local missions = {
	"juggernaut",
	"zapper",
	"shipping",
	"marathon",
	"healrain",
	"locusts",
	"cannon",
	"earthquake",
	"siege",
	"disease",
}

function this:init(mod)
	for _, mission in ipairs(missions) do
		self[mission] = require(path .. mission)
		self[mission]:init(mod)
	end
	
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
	
	local extraDialog2 = require(path.."extra_dialog2")
	for personalityId, dialogTable in pairs(extraDialog2) do
		Personality[personalityId]:AddDialogTable(dialogTable)
	end
end

function this:load(mod, options, version)
	require(path .."voice_units"):load()
	
	for _, mission in ipairs(missions) do
		self[mission]:load(mod, options, version)
		
		loadMissionDialog(self[mission].id, path .. mission .."_dialog.lua")
	end
end

return this