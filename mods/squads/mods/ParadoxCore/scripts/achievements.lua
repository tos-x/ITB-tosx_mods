
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_ParadoxCore"

function tosx_timesquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_time_grandpa" then
		modApi.achievements:trigger(modid,"tosx_time_secret", {aa = true})
	elseif id == "tosx_time_oblivion" then
		modApi.achievements:trigger(modid,"tosx_time_secret", {bb = true})
	elseif id == "tosx_time_groundhog" then
		modApi.achievements:trigger(modid,"tosx_time_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_time_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_time_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_time_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_timeUnlock())
	end
end

local imgs = {
	"grandpa",
	"oblivion",
	"groundhog",
	"secret",
}

local achname = "tosx_time_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_time_grandpa",
	name = "Grandfather Paradox",
	tip = "Remove an enemy by killing its past self",
	img = "img/achievements/tosx_time_grandpa.png",
	squad = "tosx_ParadoxCore",
}

modApi.achievements:add{
	id = "tosx_time_oblivion",
	name = "Time to Kill",
	tip = "Target an enemy's past and present self at the same time using the Oblivion Strike",
	img = "img/achievements/tosx_time_oblivion.png",
	squad = "tosx_ParadoxCore",
}

modApi.achievements:add{
	id = "tosx_time_groundhog",
	name = "Groundhog Day",
	tip = "Bring a dead Mech back to life using the Temporal Tear",
	img = "img/achievements/tosx_time_groundhog.png",
	squad = "tosx_ParadoxCore",
}

modApi.achievements:add{
		id = "tosx_time_secret",
		name = "Paradox Core Secret Reward",
		tip = "Complete all 3 Paradox Core achievements\n\nGrandfather Paradox: $aa\nTime to Kill: $bb\nGroundhog Day: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_time_secret.png",
		squad = "tosx_ParadoxCore",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}


function tosx_timeUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Clocktower',
		tip = 'Clocktower unlocked. This structure can now appear in future missions on Archive.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this