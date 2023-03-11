
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tosx_squadname = "Magnetic Golems"
local tosx_achvname = "tosx_magnet_"

local this = {}

function this:load()
	modApi:addNextTurnHook(function(mission)
		if GAME and 
		GAME.tosx_PosPolarities then
			local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
			for i,id in pairs(pawns) do
				if GAME.tosx_PosPolarities[id] and not Board:GetPawn(id):IsDead() then
					if Game:GetTurnCount() - GAME.tosx_PosPolarities[id] > 2 then
						tosx_magnetsquad_Chievo("tosx_magnet_pinball")
					end
				end
			end
		end
	end)
end

return this