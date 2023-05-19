
-- create corporation
local corporation = easyEdit.corporation:add("FarLine")
corporation.Name = "Far Line Charters"
corporation.Bark_Name = "Far Line"
corporation.Description = "Far Line Charters sends its cargo fleet to ply the dangerous oceans and supply humanity's remnants."
corporation.Color = GL_Color(57,87,38)
corporation.Map = { "/music/sand/map" }
corporation.Music = {
	"/music/grass/combat_delta",
	"/music/acid/combat_synth",
	"/music/sand/combat_eastwood",
	"/music/snow/combat_train",
}

-- reference the pilot id created in pilot.lua
corporation.Pilot = "Pilot_FarLine"
