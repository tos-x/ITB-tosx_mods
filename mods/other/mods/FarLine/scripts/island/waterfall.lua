local mod = mod_loader.mods[modApi.currentMod]
local customAnim = require(mod.scriptPath.."libs/customAnim")
require(mod.scriptPath.."libs/boardEvents")

--waterfall name and tileset
local TILESET = "FarLine"
local WATERFALL = TILESET .. "_Waterfall"

----------------
-- ANIMATIONS --
----------------

-- Base waterfall
ANIMS[WATERFALL] = Animation:new{
	NumFrames = 3,
	Time = 0.19,
	Loop = true,
	Layer = LAYER_FLOOR--LAYER_BACK
}

--Perspective of the hole
ANIMS['3'..WATERFALL] = ANIMS[WATERFALL]:new{
    Image = "combat/tiles_"..TILESET.."/waterfall_U.png", PosX = -28, PosY = 25
}

ANIMS['2'..WATERFALL] = ANIMS[WATERFALL]:new{
    Image = "combat/tiles_"..TILESET.."/waterfall_L.png", PosX = -10, PosY = 25
}

ANIMS['1'..WATERFALL] = ANIMS[WATERFALL]:new{
    Image = "combat/tiles_"..TILESET.."/waterfall_D.png", PosX = -11, PosY = 7
}

ANIMS['0'..WATERFALL] = ANIMS[WATERFALL]:new{
    Image = "combat/tiles_"..TILESET.."/waterfall_R.png", PosX = -27, PosY = 7
}

local order = {3,0,1,2} -- needed to align waterfall position and sprite display order

---------------
-- FUNCTIONS --
---------------

local EVENT_onTerrainChanged = function(point, newTerrain, oldTerrain)
	if modApi:getCurrentTileset() == TILESET then
		if false
			or newTerrain == TERRAIN_WATER
			or newTerrain == TERRAIN_HOLE
			or oldTerrain == TERRAIN_WATER
			or oldTerrain == TERRAIN_HOLE
		then
			for i,j in ipairs(order) do -- re-do waterfalls on tile
				customAnim:rem(point,(i-1)..WATERFALL)
				if Board:GetTerrain(point) == TERRAIN_HOLE then
					local curr = point + DIR_VECTORS[j]
					if Board:IsValid(curr) then
						if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
							if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
								customAnim:add(point,(i-1)..WATERFALL)
							end
						end
					end
				end
			end
			for d = DIR_START, DIR_END do -- re-do waterfalls on adjacent
				local loc = point + DIR_VECTORS[d]
				for i,j in ipairs(order) do
					customAnim:rem(loc,(i-1)..WATERFALL)
					if Board:IsValid(loc) and Board:GetTerrain(loc) == TERRAIN_HOLE then
						local curr = loc + DIR_VECTORS[j]
						if Board:IsValid(curr) then
							if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
								if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
									customAnim:add(loc,(i-1)..WATERFALL)
								end
							end
						end
					end
				end
			end
		end
	end
end

local EVENT_onTerrainChanged = function(point, newTerrain, oldTerrain)
	if modApi:getCurrentTileset() == TILESET then
		if false
			or newTerrain == TERRAIN_WATER
			or newTerrain == TERRAIN_HOLE
			or oldTerrain == TERRAIN_WATER
			or oldTerrain == TERRAIN_HOLE
		then
			for i,j in ipairs(order) do -- re-do waterfalls on tile
				customAnim:rem(point,(i-1)..WATERFALL)
				if Board:GetTerrain(point) == TERRAIN_HOLE then
					local curr = point + DIR_VECTORS[j]
					if Board:IsValid(curr) then
						if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
							if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
								customAnim:add(point,(i-1)..WATERFALL)
							end
						end
					end
				end
			end
			for d = DIR_START, DIR_END do -- re-do waterfalls on adjacent
				local loc = point + DIR_VECTORS[d]
				for i,j in ipairs(order) do
					customAnim:rem(loc,(i-1)..WATERFALL)
					if Board:IsValid(loc) and Board:GetTerrain(loc) == TERRAIN_HOLE then
						local curr = loc + DIR_VECTORS[j]
						if Board:IsValid(curr) then
							if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
								if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
									customAnim:add(loc,(i-1)..WATERFALL)
								end
							end
						end
					end
				end
			end
		end
	end
end

local EVENT_onAcidLava = function(point)
	if modApi:getCurrentTileset() == TILESET then
		if Board:GetTerrain(point) == TERRAIN_WATER then
			for i,j in ipairs(order) do -- re-do waterfalls on tile
				customAnim:rem(point,(i-1)..WATERFALL)
				if Board:GetTerrain(point) == TERRAIN_HOLE then
					local curr = point + DIR_VECTORS[j]
					if Board:IsValid(curr) then
						if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
							if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
								customAnim:add(point,(i-1)..WATERFALL)
							end
						end
					end
				end
			end
			for d = DIR_START, DIR_END do -- re-do waterfalls on adjacent
				local loc = point + DIR_VECTORS[d]
				for i,j in ipairs(order) do
					customAnim:rem(loc,(i-1)..WATERFALL)
					if Board:IsValid(loc) and Board:GetTerrain(loc) == TERRAIN_HOLE then
						local curr = loc + DIR_VECTORS[j]
						if Board:IsValid(curr) then
							if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
								if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
									customAnim:add(loc,(i-1)..WATERFALL)
								end
							end
						end
					end
				end
			end
		end
	end
end

local function HOOK_mapEntered(mission)
	for x = 0, 7 do
		for y = 0, 7 do
			local point = Point(x,y)
			for i,j in ipairs(order) do -- re-do waterfalls on tile
				customAnim:rem(point,(i-1)..WATERFALL)
				if modApi:getCurrentTileset() == TILESET and Board:GetTerrain(point) == TERRAIN_HOLE then
					local curr = point + DIR_VECTORS[j]
					if Board:IsValid(curr) then
						if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
							if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
								customAnim:add(point,(i-1)..WATERFALL)
							end
						end
					end
				end
			end
		end
	end
end

local function HOOK_missionEnd(mission)
	for x = 0, 7 do
		for y = 0, 7 do
			local point = Point(x,y)
			for i,j in ipairs(order) do -- re-do waterfalls on tile
				customAnim:rem(point,(i-1)..WATERFALL)
				if modApi:getCurrentTileset() == TILESET and Board:GetTerrain(point) == TERRAIN_HOLE then
					local curr = point + DIR_VECTORS[j]
					if Board:IsValid(curr) then
						if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
							if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
								Board:AddAnimation(point,(i-1)..WATERFALL,1)
							end
						end
					end
				end
			end
		end
	end
end

-- for use outside of this script
function AddCustomWaterfall(point)
	if modApi:getCurrentTileset() == TILESET then
		for i,j in ipairs(order) do -- re-do waterfalls on tile
			customAnim:rem(point,(i-1)..WATERFALL)
			local curr = point + DIR_VECTORS[j]
			if Board:IsValid(curr) then
				if Board:GetTerrain(curr) == TERRAIN_WATER and Board:GetTerrain(curr) ~= TERRAIN_ICE then
					if not Board:IsTerrain(curr,TERRAIN_LAVA) and not Board:IsAcid(curr) then
						customAnim:add(curr,(i-1)..WATERFALL)
					end
				end
			end
		end
	end
end

-- add hooks
local function EVENT_onModsLoaded()
	modApi:addTestMechEnteredHook(HOOK_mapEntered)
	modApi:addMissionStartHook(HOOK_mapEntered)
	modApi:addMissionEndHook(HOOK_missionEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
BoardEvents.onTerrainChanged:subscribe(EVENT_onTerrainChanged)
BoardEvents.onAcidCreated:subscribe(EVENT_onAcidLava)
BoardEvents.onAcidRemoved:subscribe(EVENT_onAcidLava)
BoardEvents.onLavaCreated:subscribe(EVENT_onAcidLava)
BoardEvents.onLavaRemoved:subscribe(EVENT_onAcidLava)
