
local path = GetParentPath(...)
local pilot_dialog = require(path.."pilot_dialog")

local mod = modApi:getCurrentMod()
local resourcePath = mod.resourcePath

-- add pilot images
modApi:appendAsset("img/portraits/npcs/tosx_crystal.png", resourcePath.."img/corp/pilot.png")
modApi:appendAsset("img/portraits/npcs/tosx_crystal_2.png", resourcePath.."img/corp/pilot_2.png")
modApi:appendAsset("img/portraits/npcs/tosx_crystal_blink.png", resourcePath.."img/corp/pilot_blink.png")

-- create personality
local personality = CreatePilotPersonality("Vertex")
personality:AddDialogTable(pilot_dialog)

-- add our personality to the global personality table
Personality["Vertex"] = personality

-- create pilot
-- reference the personality we created
-- reference the pilot images we added
CreatePilot{
	Id = "Pilot_Vertex",
	Personality = "Vertex",
	Rarity = 0,
	Cost = 1,
	Portrait = "npcs/tosx_crystal",
	Voice = "/voice/archive",
}

modApi:addPilotDrop{id = "Pilot_Vertex", recruit = true }