
-- create corporation
local corporation = easyEdit.corporation:add("Vertex")
corporation.Name = "Vertex Conglomerate"
corporation.Bark_Name = "Vertex"
corporation.Description = "In their search for new forms of energy, Vertex developed volatile crystals which soon overtook their whole island."
corporation.Color = GL_Color(57,87,38)
corporation.Map = { "/music/acid/map" }
corporation.Music = {
    "/music/snow/combat_new",
    "/music/acid/combat_new",
    "/music/sand/combat_montage",
    "/music/grass/combat_gamma",
}

-- reference the pilot id created in pilot.lua
corporation.Pilot = "Pilot_Vertex"