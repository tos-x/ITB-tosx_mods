
local pawns = {
	tosx_ScoutAirship   = "Mission_tosx_Scoutship_Destroyed",
	tosx_BeamTank       = "Mission_tosx_Beamtank_Destroyed",
	tosx_PhoenixProject = "Mission_tosx_Phoenix_Destroyed",
	tosx_Exosuit        = "Mission_tosx_Exosuit_Destroyed",
	tosx_RetractTower   = "Mission_tosx_Retracter_Destroyed",
	tosx_DeathCrystal   = "Mission_tosx_Halcyte_Destroyed", --same bark for all bad crystals
	tosx_FrostCrystal   = "Mission_tosx_Halcyte_Destroyed",
	tosx_HealCrystal    = "Mission_tosx_Halcyte_Destroyed",
}

local function onModsLoaded()
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

modApi.events.onModsLoaded:subscribe(onModsLoaded)