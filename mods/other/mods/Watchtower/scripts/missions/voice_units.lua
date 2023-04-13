
local pawns = {
	tosx_SonicTower = "Mission_tosx_Sonic_Destroyed",
	tosx_Tanker1 = "Mission_tosx_Tanker_Destroyed",
	tosx_Rig1 = "Mission_tosx_Rig_Destroyed",
	tosx_Rig2 = "Mission_tosx_Rig_Destroyed",
	tosx_Rig3 = "Mission_tosx_Rig_Destroyed",
}

local function onModsLoaded()
	modapiext:addPawnKilledHook(function(mission, pawn)
		local pawnType = pawn:GetType()
		
		local voice = pawns[pawnType]		
		if not voice then return end
		
		--Unique dialog for tanker, if full
		if voice == "Mission_tosx_Tanker_Destroyed" then
			if mission.Siphon and mission.Siphon > 3 then
				voice = "Mission_tosx_TankerFull_Destroyed"
			end
		end
		
		local chance = math.random()
		if chance > 0.5 then
			local fx = SkillEffect()
			fx:AddVoice(voice, -1)
			Board:AddEffect(fx)
		end
	end)
end

modApi.events.onModsLoaded:subscribe(onModsLoaded)