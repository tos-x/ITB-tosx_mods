
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_HydroLeviathans"

function tosx_hydrosquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_hydro_tide" then
		modApi.achievements:trigger(modid,"tosx_hydro_secret", {aa = true})
	elseif id == "tosx_hydro_torpedo" then
		modApi.achievements:trigger(modid,"tosx_hydro_secret", {bb = true})
	--elseif id == "tosx_hydro_thirsty" then
		--modApi.achievements:trigger(modid,"tosx_hydro_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_hydro_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_hydro_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_hydro_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_hydroUnlock())
	end
end

function tosx_triggerThirsty(element)
	if GAME.additionalSquadData.squad ~= modid then return end
	if element == "acid" then
		if not modApi.achievements:isProgress(modid,"tosx_hydro_thirsty", { acid = true,} ) then
			modApi.achievements:trigger(modid,"tosx_hydro_thirsty", {progress = 1})
			modApi.achievements:trigger(modid,"tosx_hydro_thirsty", {acid = true})
		end
	else
		if not modApi.achievements:isProgress(modid,"tosx_hydro_thirsty", { fire = true,} ) then
			modApi.achievements:trigger(modid,"tosx_hydro_thirsty", {progress = 1})
			modApi.achievements:trigger(modid,"tosx_hydro_thirsty", {fire = true})
		end
	end
	if modApi.achievements:getProgress(modid,"tosx_hydro_thirsty") then
		modApi.achievements:trigger(modid,"tosx_hydro_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_hydro_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_hydro_secret", {aa = true, bb = true, cc = true,}) then	
		modApi.achievements:trigger(modid,"tosx_hydro_secret", {reward = true })	
		modApi.toasts:add(tosx_hydroUnlock())
	end
end

local imgs = {
	"tide",
	"torpedo",
	"thirsty",
	"secret",
}

local achname = "tosx_hydro_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_hydro_tide",
	name = "High Tide",
	tip = "Create 6 water tiles in a single battle",
	img = "img/achievements/tosx_hydro_tide.png",
	squad = "tosx_HydroLeviathans",
}

modApi.achievements:add{
	id = "tosx_hydro_torpedo",
	name = "Damn the Torpedoes",
	tip = "Kill 3 enemies with a single use of the Dowsing Charge",
	img = "img/achievements/tosx_hydro_torpedo.png",
	squad = "tosx_HydroLeviathans",
}

modApi.achievements:add{
	id = "tosx_hydro_thirsty",
	name = "Thirsty",
	tip = "Inflict 2 different statuses using the Hydro Cannon\n\nProgress: $progress",
	img = "img/achievements/tosx_hydro_thirsty.png",
	squad = "tosx_HydroLeviathans",
	objective = {
		progress = 2,
		acid = true,
		fire = true,
	}
}

modApi.achievements:add{
		id = "tosx_hydro_secret",
		name = "Hydro Leviathans Secret Reward",
		tip = "Complete all 3 Hydro Leviathans achievements\n\nHigh Tide: $aa\nDamn the Torpedoes: $bb\nThirsty: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_hydro_secret.png",
		squad = "tosx_HydroLeviathans",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_hydroUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Shipyard',
		tip = 'Shipyard unlocked. This structure can now appear in future missions on Archive.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this