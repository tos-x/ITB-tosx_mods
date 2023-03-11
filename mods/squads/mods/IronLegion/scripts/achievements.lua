
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_IronLegion"

function tosx_legionsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end

	modApi.achievements:trigger(modid,id)
	if id == "tosx_legion_placement" then
		modApi.achievements:trigger(modid,"tosx_legion_secret", {aa = true})
	elseif id == "tosx_legion_spares" then
		modApi.achievements:trigger(modid,"tosx_legion_secret", {bb = true})
	elseif id == "tosx_legion_wave" then
		modApi.achievements:trigger(modid,"tosx_legion_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_legion_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_legion_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_legion_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
	
		modApi.toasts:add(tosx_legionUnlock())
	end
end

local imgs = {
	"placement",
	"spares",
	"wave",
	"secret",
}

local achname = "tosx_legion_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_legion_placement",
	name = "Perfect Placement",
	tip = "Win a battle without ever moving a Fighter",
	img = "img/achievements/tosx_legion_placement.png",
	squad = "tosx_IronLegion",
}

modApi.achievements:add{
	id = "tosx_legion_spares",
	name = "No Spares",
	tip = "Win a battle without ever losing a Fighter",
	img = "img/achievements/tosx_legion_spares.png",
	squad = "tosx_IronLegion",
}

modApi.achievements:add{
	id = "tosx_legion_wave",
	name = "Do The Wave",
	tip = "Confuse 3 enemies using the Seismic Wave",
	img = "img/achievements/tosx_legion_wave.png",
	squad = "tosx_IronLegion",
}

modApi.achievements:add{
		id = "tosx_legion_secret",
		name = "Iron Legion Secret Reward",
		tip = "Complete all 3 Iron Legion achievements\n\nPerfect Placement: $aa\nNo Spares: $bb\nDo The Wave: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_legion_secret.png",
		squad = "tosx_IronLegion",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_legionUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Construction Platform',
		tip = 'Construction Platform unlocked. This structure can now appear in future missions on Detritus.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this