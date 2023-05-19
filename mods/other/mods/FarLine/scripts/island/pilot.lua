
local path = GetParentPath(...)
local pilot_dialog = require(path.."pilot_dialog")

local mod = modApi:getCurrentMod()
local resourcePath = mod.resourcePath

-- add pilot images
modApi:appendAsset("img/portraits/npcs/tosx_ocean.png", resourcePath.."img/corp/pilot.png")
modApi:appendAsset("img/portraits/npcs/tosx_ocean_2.png", resourcePath.."img/corp/pilot_2.png")
modApi:appendAsset("img/portraits/npcs/tosx_ocean_blink.png", resourcePath.."img/corp/pilot_blink.png")

-- create personality
local personality = CreatePilotPersonality("FarLine")
personality:AddDialogTable(pilot_dialog)

-- add our personality to the global personality table
Personality["FarLine"] = personality

-- create pilot
-- reference the personality we created
-- reference the pilot images we added
CreatePilot{
	Id = "Pilot_FarLine",
	Personality = "FarLine",
	Rarity = 0,
	Cost = 1,
	Portrait = "npcs/tosx_ocean",
	Voice = "/voice/archive",
}

modApi:addPilotDrop{id = "Pilot_FarLine", recruit = true }