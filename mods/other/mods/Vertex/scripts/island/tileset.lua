
-- create tileset
local tileset = easyEdit.tileset:add("Vertex", "grass")

tileset.name = "Crystal"

-- appends all assets in the path relative to mod's resource path
tileset:appendAssets("img/tileset/") --destination example: img/combat/tiles_Watchtower/ground_0.png

-- display name of the tileset in game
tileset:setClimate("Crystal")

-- percentage chance of a mission having rain
tileset:setRainChance(30)

-- percentage chance of a tile having cracks
tileset:setCrackChance(0)

-- percentage chance that a regular ground tile gets changed to the following
tileset:setEnvironmentChance{
	[TERRAIN_ACID] = 0,
	[TERRAIN_FOREST] = 0,
	[TERRAIN_SAND] = 0,
	[TERRAIN_ICE] = 0,
	[TERRAIN_CRYSTALMTN] = 10,
}