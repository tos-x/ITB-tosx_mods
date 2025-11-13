
local function onModsLoaded()
	modApi:addMissionStartHook(function(mission)
		mission.tosx_warp_drop = 0
		mission.tosx_warp_lights = 0
	end)
end

modApi.events.onModsLoaded:subscribe(onModsLoaded)