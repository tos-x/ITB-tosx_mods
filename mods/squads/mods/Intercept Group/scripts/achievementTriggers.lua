
local path = mod_loader.mods[modApi.currentMod].scriptPath

local this = {}

function this:load()	
	modApi:addPreEnvironmentHook(function(mission)
		local edgecount = 0
		
		local edge = {0,0,0,0} --x0,x7,y0,y7
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			local p = Board:GetPawn(id):GetSpace()
			if Board:IsValid(p) and p.x == 0 or p.x == 7 or p.y == 0 or p.y == 7 then
				if (p.x == 0 or p.x == 7) and (p.y == 0 or p.y == 7) then --corner; skip
				elseif p.x == 0 then
					edge[1]=1
				elseif p.x == 7 then
					edge[2]=1
				elseif p.y == 0 then
					edge[3]=1
				elseif p.y == 7 then
					edge[4]=1
				end
			end
		end
		
		for i,v in pairs(edge) do
			edgecount = edgecount + v
		end
		
		if edgecount >= 3 then
			tosx_interceptsquad_Chievo("tosx_intercept_wide")
		end
	end)
end

return this