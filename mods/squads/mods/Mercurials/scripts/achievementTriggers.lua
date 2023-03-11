
local path = mod_loader.mods[modApi.currentMod].scriptPath

local this = {}

function this:load()
	modApi:addMissionUpdateHook(function(mission)
		if mission.tosx_mercury_lives then
			for i = 0, 2 do
				if mission.tosx_mercury_lives[i+1] == 0 then
					if Board:GetPawn(i) and Board:GetPawn(i):IsDead() then
						mission.tosx_mercury_lives[i+1] = 1
					end
				elseif mission.tosx_mercury_lives[i+1] == 1 then
					if Board:GetPawn(i) and not Board:GetPawn(i):IsDead() then
						mission.tosx_mercury_lives[i+1] = 2
					end
				end
			end
			if mission.tosx_mercury_lives[1] == 2 and
			mission.tosx_mercury_lives[2] == 2 and
			mission.tosx_mercury_lives[3] == 2 then
				tosx_mercurysquad_Chievo("tosx_mercury_rebuild")
				mission.tosx_mercury_lives = nil
			end
		end
	end)

	modApi:addMissionStartHook(function(mission)
		mission.tosx_mercury_lives = {0, 0, 0}
	end)

	modApi:addMissionNextPhaseCreatedHook(function(_, mission)
		mission.tosx_mercury_lives = {0, 0, 0}
	end)
end

return this