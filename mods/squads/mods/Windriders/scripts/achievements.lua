
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_Windriders"

function tosx_windsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_wind_falling" then
		modApi.achievements:trigger(modid,"tosx_wind_secret", {aa = true})
	elseif id == "tosx_wind_crowded" then
		modApi.achievements:trigger(modid,"tosx_wind_secret", {bb = true})
	elseif id == "tosx_wind_goride" then
		modApi.achievements:trigger(modid,"tosx_wind_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_wind_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_wind_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_wind_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_windUnlock())
	end
end

local imgs = {
	"falling",
	"crowded",
	"goride",
	"secret",
}

local achname = "tosx_wind_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_wind_falling",
	name = "Fear of Falling",
	tip = "Toss an enemy into a Chasm using the Cyclone Launcher",
	img = "img/achievements/tosx_wind_falling.png",
	squad = "tosx_Windriders",
}

modApi.achievements:add{
	id = "tosx_wind_crowded",
	name = "Crowded Sky",
	tip = "Move at least 8 units using the Microburst",
	img = "img/achievements/tosx_wind_crowded.png",
	squad = "tosx_Windriders",
}

modApi.achievements:add{
	id = "tosx_wind_goride",
	name = "Frequent Flyer",
	tip = "Leap at least 4 tiles with 2 enemies using the Aero Thrusters",
	img = "img/achievements/tosx_wind_goride.png",
	squad = "tosx_Windriders",
}

modApi.achievements:add{
		id = "tosx_wind_secret",
		name = "Windriders Secret Reward",
		tip = "Complete all 3 Windriders achievements\n\nFear of Falling: $aa\nCrowded Sky: $bb\nGoing for a Ride: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_wind_secret.png",
		squad = "tosx_Windriders",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_windUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Aerodrome',
		tip = 'Aerodrome unlocked. This structure can now appear in future missions on Detritus.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this