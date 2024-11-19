
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_InterceptGroup" -- Also the squad id

function tosx_interceptsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_intercept_peak" then
		modApi.achievements:trigger(modid,"tosx_intercept_secret", {aa = true})
	elseif id == "tosx_intercept_throttle" then
		modApi.achievements:trigger(modid,"tosx_intercept_secret", {bb = true})
	elseif id == "tosx_intercept_wide" then
		modApi.achievements:trigger(modid,"tosx_intercept_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_intercept_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_intercept_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_intercept_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_interceptUnlock())
	end
end

local imgs = {
	"peak",
	"throttle",
	"wide",
	"secret",
}

local achname = "tosx_intercept_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_intercept_peak",
	name = "Peak Efficiency",
	tip = "Shoot the Focused Beam 4 times in a single battle at exactly range 3",
	img = "img/achievements/tosx_intercept_peak.png",
	squad = "tosx_InterceptGroup",
}

modApi.achievements:add{
	id = "tosx_intercept_throttle",
	name = "Full Throttle",
	tip = "Kill 2 enemies with a single use of the Shockwave Engines after traveling 6 tiles",
	img = "img/achievements/tosx_intercept_throttle.png",
	squad = "tosx_InterceptGroup",
}

modApi.achievements:add{
	id = "tosx_intercept_wide",
	name = "Far and Wide",
	tip = "End a turn with Mechs on 3 different edges of the map (excluding corners)",
	img = "img/achievements/tosx_intercept_wide.png",
	squad = "tosx_InterceptGroup",
}

modApi.achievements:add{
		id = "tosx_intercept_secret",
		name = "Intercept Group Secret Reward",
		tip = "Complete all 3 Intercept Group achievements\n\nPeak Efficiency: $aa\nFull Throttle: $bb\nFar and Wide: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_intercept_secret.png",
		squad = "tosx_InterceptGroup",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_interceptUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Garage',
		tip = 'Garage. This structure can now appear in future missions on R.S.T.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this