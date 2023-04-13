
local path = GetParentPath(...)
local pilot_dialog = require(path.."pilot_dialog")

local mod = modApi:getCurrentMod()
local resourcePath = mod.resourcePath

-- add pilot images
modApi:appendAsset("img/portraits/npcs/tosx_rocks1.png", resourcePath.."img/corp/pilot.png")
modApi:appendAsset("img/portraits/npcs/tosx_rocks1_2.png", resourcePath.."img/corp/pilot_2.png")
modApi:appendAsset("img/portraits/npcs/tosx_rocks1_blink.png", resourcePath.."img/corp/pilot_blink.png")

-- create personality
local personality = CreatePilotPersonality("Watchtower")
personality:AddDialogTable(pilot_dialog)

-- add our personality to the global personality table
Personality["Watchtower"] = personality

-- create pilot
-- reference the personality we created
-- reference the pilot images we added
CreatePilot{
	Id = "Pilot_Watchtower",
	Personality = "Watchtower",
	Rarity = 0,
	Cost = 1,
	Portrait = "npcs/tosx_rocks1",
	Voice = "/voice/detritus",
}

modApi:addPilotDrop{id = "Pilot_Watchtower", recruit = true }