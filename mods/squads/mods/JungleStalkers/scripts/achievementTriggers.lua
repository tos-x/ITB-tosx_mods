
local path = mod_loader.mods[modApi.currentMod].scriptPath

local this = {}

function this:load()
	modApi:addNextTurnHook(function(mission)
		if Game:GetTeamTurn() == TEAM_PLAYER then
			-- Reset kill counter at start of player turn
			mission.tosx_jungle_ambush = 0
		end
	end)

	modapiext:addPawnKilledHook(function(mission, pawn)
		if (pawn:GetTeam() == TEAM_ENEMY) then
			mission.tosx_jungle_ambush = mission.tosx_jungle_ambush or 0
			mission.tosx_jungle_ambush = mission.tosx_jungle_ambush + 1
			
			-- Increase and check kill count
			if mission.tosx_jungle_ambush > 5 then
				tosx_junglesquad_Chievo("tosx_jungle_ambush")
			end
		end
	end)
end

return this