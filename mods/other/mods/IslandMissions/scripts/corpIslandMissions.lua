
----------------------------------------------------------------------------------------
-- Corp Missions v1.0* - code library
--
-- Edited by tosx into Corp Island Missions
-- Includes logic to compare with easyEdit corp names
-- Your mod must include the following in its init, so easyEdit will load first:
--		requirements = { "easyEdit" },
--
-- Vanilla easyEdit corp names that are used as input argument:
-- 		archive
-- 		rst
-- 		pinnacle
-- 		detritus
--		...or custom easyEdit corporation name
-- True vanilla corp names that also still function as inputs (no easyEdit equivalent):
--		Corp_Grass
--      Corp_Desert
--      Corp_Snow
--      Corp_Factory
----------------------------------------------------------------------------------------
-- small library intended to provide functions to add/remove mission to corporations.
-- required to make mission mods compatible with island replacement mods.
--
-- NOTE that islands do not get swapped until after init, so if you want to add
-- a mission to a custom corporation on an island, you need to do so at load.
--
----------------------------------------------------------------------------------------


-- Usage:
----------------------------------------------------------------------------------------
-- place the following at the top of any lua file that wants to use the library.
--
-- local path = mod_loader.mods[modApi.currentMod].scriptPath
-- local corpMissions = require(path .."corpMissions")
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


-- Signature of all addition functions:
----------------------------------------------------------------------------------------
-- corpMissions.Add_Missions_High(mission, corp, force)
----------------------------------------------------------------------------------------
-- adds a mission to a corporation.
-- if corp is nil, the mission will be added to all default corps.
--
-- arg      - type        - description
-- ------     -----------   ------------------------------------------------------------
-- mission  - string      - mission we want to add.
-- corp     - string      - corporation we want to add the mission to.
-- force    - boolean     - if we should allow duplicate additions of mission. (optional)
----------------------------------------------------------------------------------------

-- Signature of all removal functions:
----------------------------------------------------------------------------------------
-- corpMissions.Rem_Missions_High(mission, corp, once)
----------------------------------------------------------------------------------------
-- removes a mission from a corporation.
-- if corp is nil, the mission will be removed from all default corps.
--
-- arg      - type        - description
-- ------     -----------   ------------------------------------------------------------
-- mission  - string      - mission we want to remove.
-- corp     - string      - corporation we want to remove the mission from.
-- once     - number      - if true, it will only attempt to remove the mission once. (optional)
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


-- Examples:
----------------------------------------------------------------------------------------
-- corpMissions.Add_Missions_High("Mission_Survive", "Corp_Grass")
-- corpMissions.Add_Missions_Low("Mission_Survive", "Corp_Grass")
-- corpMissions.Add_Bosses("Mission_BotBoss", "Corp_Grass")
-- corpMissions.Add_UniqueBosses("Mission_BotBoss", "Corp_Grass")
-- corpMissions.Rem_Missions_High("Mission_Survive", "Corp_Grass")
-- corpMissions.Rem_Missions_Low("Mission_Survive", "Corp_Grass")
-- corpMissions.Rem_Bosses("Mission_BotBoss", "Corp_Grass")
-- corpMissions.Rem_UniqueBosses("Mission_BotBoss", "Corp_Grass")
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local this = {}

local corps = {
	"Corp_Grass",
	"Corp_Desert",
	"Corp_Snow",
	"Corp_Factory"
}

local corpsEasyEdit = {
	"archive",
	"rst",
	"pinnacle",
	"detritus",
}

-- set id for default corporations.
for i, v in ipairs(corps) do
	_G[v].id = _G[v].id or v
end

_G["Corp_Default"].id = "Corp_Default"

local function Add(tbl)
	this['Add_'.. tbl] = function(mission, corp, force)	
		-- Adjust our corp to match easyEdit if necessary
		if easyEdit and easyEdit.world then
			for i = 1, 4 do
				if easyEdit.world[i].corporation == corp then
					-- This is the island where easyEdit has our corp
					corp = corps[i]
					break
				end
			end
		else
			-- No easyEdit, so convert from easyEdit corp name to vanilla corp name
			for i = 1, 4 do
				if corp == corpsEasyEdit[i] or corp == corps[i] then
					corp = corps[i]
					break
				end
			end
		end
	
		for _, v in ipairs(corps) do
			if corp == _G[v].id or (not corp and list_contains(corps, _G[v].id)) then
				if force or not list_contains(_G[v][tbl], mission) then
					table.insert(_G[v][tbl], mission)
				end
			end
		end
	end
	
	this['Rem_'.. tbl] = function(mission, corp, once)	
		-- Adjust our corp to match easyEdit if necessary
		if easyEdit and easyEdit.world then
			for i = 1, 4 do
				if easyEdit.world[i].corporation == corp then
					-- This is the island where easyEdit has our corp
					corp = corps[i]
				end
			end
		else
			-- No easyEdit, so convert from easyEdit corp name to vanilla corp name
			for i = 1, 4 do
				if corp == corpsEasyEdit[i] then
					corp = corps[i]
				end
			end
		end
		
		for _, v in ipairs(corps) do
			if not corp or corp == _G[v].id then
				while list_contains(_G[v][tbl], mission) do
					remove_element(mission, _G[v][tbl])
				end
			end
		end
	end
end

Add("Missions_High")
Add("Missions_Low")
Add("Bosses")
Add("UniqueBosses")

return this