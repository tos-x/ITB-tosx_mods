
local this = {}

local pawns = {
	tosx_mission_juggernaut = "Mission_tosx_Juggernaut_Destroyed",
	tosx_mission_zapper = "Mission_tosx_Zapper_Destroyed",
	tosx_mission_warper = "Mission_tosx_Warper_Destroyed",
	tosx_mission_battleship = "Mission_tosx_Battleship_Destroyed",
}

function this:load()
	modapiext:addPawnKilledHook(function(mission, pawn)
		local pawnType = pawn:GetType()
		local voice = pawns[pawnType]
		if not voice then return end
		
		local chance = math.random()
		if chance > 0.5 then
			local fx = SkillEffect()
			fx:AddVoice(voice, -1)
			Board:AddEffect(fx)
		end
	end)
end

return this