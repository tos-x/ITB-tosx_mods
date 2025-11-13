
local function onModsLoaded()
	modApi:addMissionStartHook(function(mission)
		mission.tosx_gunner_fin = 0
	end)
end

modApi.events.onModsLoaded:subscribe(onModsLoaded)