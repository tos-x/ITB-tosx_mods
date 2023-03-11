
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tosx_squadname = "Hydro Leviathans"
local tosx_achvname = "tosx_hydro_"

local this = {}

function this:load()
	modApi:addMissionStartHook(function(mission)
		mission.tosx_hydro_tide = 0
	end)
	
	modApi:addMissionEndHook(function(mission)
		if mission.tosx_hydro_tide and mission.tosx_hydro_tide > 5 then
			tosx_hydrosquad_Chievo("tosx_hydro_tide")
		end
	end)
end

return this