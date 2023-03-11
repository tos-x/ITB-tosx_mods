
local path = mod_loader.mods[modApi.currentMod].scriptPath

local this = {}

function this:load()
	modApi:addNextTurnHook(function(mission)
		if Game:GetTeamTurn() == TEAM_ENEMY and mission.tosx_glacier_blocks then
			if mission.QueuedSpawns then
				for i, e in ipairs(mission.QueuedSpawns) do
					local p1 = e.location
					if Board:IsPawnSpace(p1) and Board:GetPawn(p1):IsFrozen() then
						mission.tosx_glacier_blocks = mission.tosx_glacier_blocks + 1
					end
				end
			end	
		end
	end)

	modApi:addMissionStartHook(function(mission)
		mission.tosx_glacier_blocks = 0
		mission.tosx_cryo = 0
		mission.tosx_icetransfer = 0
	end)
	
	modApi:addMissionEndHook(function(mission)
		if mission.tosx_glacier_blocks and mission.tosx_glacier_blocks > 5 then
			tosx_glaciersquad_Chievo("tosx_glacier_permafrost")
		end
	end)
end

return this