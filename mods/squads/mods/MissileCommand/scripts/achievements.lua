
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_MissileCommand" -- Also the squad id

function tosx_missilesquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_missile_rain" then
		modApi.achievements:trigger(modid,"tosx_missile_secret", {aa = true})
	elseif id == "tosx_missile_yield" then
		modApi.achievements:trigger(modid,"tosx_missile_secret", {bb = true})
	elseif id == "tosx_missile_fuse" then
		modApi.achievements:trigger(modid,"tosx_missile_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_missile_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_missile_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_missile_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_missileUnlock())
	end
end

local imgs = {
	"rain",
	"yield",
	"fuse",
	"secret",
}

local achname = "tosx_missile_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_missile_rain",
	name = "Rain of Fire",
	tip = "Kill 4 enemies with a single use of the Proximity Rockets",
	img = "img/achievements/tosx_missile_rain.png",
	squad = "tosx_MissileCommand",
}

modApi.achievements:add{
	id = "tosx_missile_yield",
	name = "High Yield",
	tip = "Kill a Blast Psion with a Ballistic Missile",
	img = "img/achievements/tosx_missile_yield.png",
	squad = "tosx_MissileCommand",
}

modApi.achievements:add{
	id = "tosx_missile_fuse",
	name = "Set the Fuse",
	tip = "Strike 2 enemies that are at least 6 tiles apart with a single use of the Phobos Cannon",
	img = "img/achievements/tosx_missile_fuse.png",
	squad = "tosx_MissileCommand",
}

modApi.achievements:add{
		id = "tosx_missile_secret",
		name = "Missile Command Secret Reward",
		tip = "Complete all 3 Missile Command achievements\n\nRain of Fire: $aa\nHigh Yield: $bb\nSet the Fuse: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_missile_secret.png",
		squad = "tosx_MissileCommand",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_missileUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Bunker',
		tip = 'Bunker. This structure can now appear in future missions on Archive.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this