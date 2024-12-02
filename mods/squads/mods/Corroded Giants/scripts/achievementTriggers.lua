
local path = mod_loader.mods[modApi.currentMod].scriptPath

local this = {}

function this:load()
	modapiext:addPawnKilledHook(function(mission, pawn)
		if (pawn:GetTeam() == TEAM_ENEMY) and pawn:IsAcid() and not IsTestMechScenario() then
			GAME.tosx_steam_rain = GAME.tosx_steam_rain or 0
			GAME.tosx_steam_rain = GAME.tosx_steam_rain + 1
			--LOG("acid kills so far: "..GAME.tosx_steam_rain)
            
			-- Increase and check kill count
			if GAME.tosx_steam_rain >= 80 then
				tosx_steamsquad_Chievo("tosx_steam_rain")
			end
		end
	end)
end

return this