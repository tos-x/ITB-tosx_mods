
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_Mercurials" -- Also the squad id

function tosx_mercurysquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_mercury_rebuild" then
		modApi.achievements:trigger(modid,"tosx_mercury_secret", {aa = true})
	elseif id == "tosx_mercury_soulless" then
		modApi.achievements:trigger(modid,"tosx_mercury_secret", {bb = true})
	elseif id == "tosx_mercury_mutual" then
		modApi.achievements:trigger(modid,"tosx_mercury_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_mercury_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_mercury_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_mercury_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_mercuryUnlock())
	end
end

local imgs = {
	"rebuild",
	"soulless",
	"mutual",
	"secret",
}

local achname = "tosx_mercury_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_mercury_rebuild",
	name = "Can't Stay Dead",
	tip = "Disable and revive each of the 3 Mechs during a single battle",
	img = "img/achievements/tosx_mercury_rebuild.png",
	squad = "tosx_Mercurials",
}

modApi.achievements:add{
	id = "tosx_mercury_soulless",
	name = "Soulless Army",
	tip = "Have 3 Husks active at once",
	img = "img/achievements/tosx_mercury_soulless.png",
	squad = "tosx_Mercurials",
}

modApi.achievements:add{
	id = "tosx_mercury_mutual",
	name = "Taking You With Me",
	tip = "Kill 2 enemies and disable a Mech with a single use of the Ablative Spines",
	img = "img/achievements/tosx_mercury_mutual.png",
	squad = "tosx_Mercurials",
}

modApi.achievements:add{
		id = "tosx_mercury_secret",
		name = "Mercurials Secret Reward",
		tip = "Complete all 3 Mercurials achievements\n\nCan't Stay Dead: $aa\nSoulless Army: $bb\nTaking You With Me: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_mercury_secret.png",
		squad = "tosx_Mercurials",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_mercuryUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Ore Silo',
		tip = 'Ore Silo. This structure can now appear in future missions on Detritus.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this