
-- create corporation
local corporation = easyEdit.corporation:add("Watchtower")
corporation.Name = "Watchtower Security"
corporation.Bark_Name = "Watchtower"
corporation.Description = "Watchtower's munitions failed to save them from the Vek. Now corporate remnants seek to regain control of the Island."
corporation.Color = GL_Color(57,87,38)
corporation.Map = { "/music/snow/map" }
corporation.Music = {
	"/music/grass/combat_new",
	"/music/acid/combat_new",
	"/music/sand/combat_montage",
	"/music/snow/combat_ice",
}

-- reference the pilot id created in pilot.lua
corporation.Pilot = "Pilot_Watchtower"
