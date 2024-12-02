
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_CorrodedGiants" -- Also the squad id

function tosx_steamsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_steam_harvest" then
		modApi.achievements:trigger(modid,"tosx_steam_secret", {aa = true})
	elseif id == "tosx_steam_rain" then
		modApi.achievements:trigger(modid,"tosx_steam_secret", {bb = true})
	elseif id == "tosx_steam_winds" then
		modApi.achievements:trigger(modid,"tosx_steam_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_steam_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_steam_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_steam_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_steamUnlock())
	end
end

local imgs = {
	"harvest",
	"rain",
	"winds",
	"secret",
}

local achname = "tosx_steam_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_steam_harvest",
	name = "Iron Harvest",
	tip = "Pull Mechs 8 or more tiles in a single battle with the Grapple Claw",
	img = "img/achievements/tosx_steam_harvest.png",
	squad = "tosx_CorrodedGiants",
}

modApi.achievements:add{
	id = "tosx_steam_rain",
	name = "Acid Rain",
	tip = "Kill 80 enemies inflicted with A.C.I.D. in a single run",
	img = "img/achievements/tosx_steam_rain.png",
	squad = "tosx_CorrodedGiants",
}

modApi.achievements:add{
	id = "tosx_steam_winds",
	name = "To the Four Winds",
	tip = "Fire the Cloud Torrent in all 4 directions in a single battle",
	img = "img/achievements/tosx_steam_winds.png",
	squad = "tosx_CorrodedGiants",
}

modApi.achievements:add{
		id = "tosx_steam_secret",
		name = "Corroded Giants Secret Reward",
		tip = "Complete all 3 Corroded Giants achievements\n\nIron Harvest: $aa\nAcid Rain: $bb\nTo the Four Winds: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_steam_secret.png",
		squad = "tosx_CorrodedGiants",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_steamUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Tesla Coil',
		tip = 'Tesla Coil. This structure can now appear in future missions on Pinnacle.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this