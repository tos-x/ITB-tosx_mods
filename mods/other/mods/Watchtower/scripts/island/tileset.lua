
-- create tileset
local tileset = easyEdit.tileset:add("Watchtower", "grass")

tileset.name = "Rocks"

-- appends all assets in the path relative to mod's resource path
tileset:appendAssets("img/tileset/")

-- display name of the tileset in game
tileset:setClimate("Rocky")

-- percentage chance of a mission having rain
tileset:setRainChance(15)

-- percentage chance of a tile having cracks
tileset:setCrackChance(0)

-- percentage chance that a regular ground tile gets changed to the following
tileset:setEnvironmentChance{
	[TERRAIN_ACID] = 0,
	[TERRAIN_FOREST] = 0,
	[TERRAIN_SAND] = 0,
	[TERRAIN_ICE] = 0,
    [TERRAIN_ROCKS] = 15,
}