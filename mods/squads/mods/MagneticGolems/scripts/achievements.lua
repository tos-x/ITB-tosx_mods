
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_MagneticGolems"

function tosx_magnetsquad_Chievo(id)
	-- exit if not our squad or TipImage	
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	if Board:GetSize() == Point(6, 6) then return end	
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_magnet_yank" then
		modApi.achievements:trigger(modid,"tosx_magnet_secret", {aa = true})
	elseif id == "tosx_magnet_whiplash" then
		modApi.achievements:trigger(modid,"tosx_magnet_secret", {bb = true})
	elseif id == "tosx_magnet_pinball" then
		modApi.achievements:trigger(modid,"tosx_magnet_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_magnet_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_magnet_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_magnet_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_magnetUnlock())
	end
end


local imgs = {
	"yank",
	"whiplash",
	"pinball",
	"secret",
}

local achname = "tosx_magnet_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_magnet_yank",
	name = "Get Over Here",
	tip = "Use the Magnetite Fist to yank a unit through 4 obstacles",
	img = "img/achievements/tosx_magnet_yank.png",
	squad = "tosx_MagneticGolems",
}

modApi.achievements:add{
	id = "tosx_magnet_whiplash",
	name = "Whiplash",
	tip = "Use the Magnetic Sling to fling 4 units at once",
	img = "img/achievements/tosx_magnet_whiplash.png",
	squad = "tosx_MagneticGolems",
}

modApi.achievements:add{
	id = "tosx_magnet_pinball",
	name = "Pinball Wizard",
	tip = "Keep an enemy alive and Magnetized for 3 turns",
	img = "img/achievements/tosx_magnet_pinball.png",
	squad = "tosx_MagneticGolems",
}

modApi.achievements:add{
		id = "tosx_magnet_secret",
		name = "Magnetic Golems Secret Reward",
		tip = "Complete all 3 Magnetic Golems achievements\n\nGet Over Here: $aa\nWhiplash: $bb\nPinball Wizard: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_magnet_secret.png",
		squad = "tosx_MagneticGolems",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_magnetUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Borehole',
		tip = 'Borehole unlocked. This structure can now appear in future missions on R.S.T.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this