
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tosx_squadname = "Mecha Ronin"
local tosx_achvname = "tosx_ronin_"

local this = {}

function this:load()
	modApi:addMissionEndHook(function(mission)
		local count = 0
		for i = 0,2 do
			if Board:GetPawn(i) then
				if Board:GetPawn(i):IsDead() then break end
				if Board:GetPawn(i):GetHealth() == 1 then
					count = count + 1
				end
			end
		end
		if count == 3 then tosx_roninsquad_Chievo("tosx_ronin_margin") end
	end)
end

return this