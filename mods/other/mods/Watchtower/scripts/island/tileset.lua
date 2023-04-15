
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

local oldonDisabled = tileset.onDisabled
function tileset:onDisabled()
	modApi.modLoaderDictionary["Status_kill_Text"] = nil
	oldonDisabled(self)
end
local oldonEnabled = tileset.onEnabled
function tileset:onEnabled()
	modApi.modLoaderDictionary["Status_kill_Text"] = "The weapon or environment effect on this tile will kill any unit. Rocks, Shields, and Ice will not block."
	oldonEnabled(self)
end