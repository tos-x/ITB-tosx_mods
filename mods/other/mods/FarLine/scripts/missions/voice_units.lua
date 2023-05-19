
local pawns = {
	tosx_cargocrate1 = "Mission_tosx_Delivery_Destroyed",
	tosx_mission_sub1 = "Mission_tosx_Sub_Destroyed",
	tosx_buoy1 = "Mission_tosx_Buoy_Destroyed",
	tosx_buoy2 = "Mission_tosx_Buoy_Destroyed",
	tosx_mission_rigship = "Mission_tosx_Rigship_Destroyed",
	tosx_RunawayTrain = "Mission_tosx_RTrain_Destroyed",
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