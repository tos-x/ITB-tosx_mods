
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_MechaRonin" -- Also the squad id

function tosx_roninsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end

	modApi.achievements:trigger(modid,id)
	if id == "tosx_ronin_katana" then
		modApi.achievements:trigger(modid,"tosx_ronin_secret", {aa = true})
	elseif id == "tosx_ronin_pursuit" then
		modApi.achievements:trigger(modid,"tosx_ronin_secret", {bb = true})
	elseif id == "tosx_ronin_margin" then
		modApi.achievements:trigger(modid,"tosx_ronin_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_ronin_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_ronin_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_ronin_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_roninUnlock())
	end
end

local imgs = {
	"katana",
	"pursuit",
	"margin",
	"secret",
}

local achname = "tosx_ronin_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_ronin_katana",
	name = "The Sharp End",
	tip = "Kill 3 enemies at once using the Titan Katana",
	img = "img/achievements/tosx_ronin_katana.png",
	squad = "tosx_MechaRonin",
}

modApi.achievements:add{
	id = "tosx_ronin_pursuit",
	name = "Easy Prey",
	tip = "Use the Pursuit Drone to mark 3 enemies at once",
	img = "img/achievements/tosx_ronin_pursuit.png",
	squad = "tosx_MechaRonin",
}

modApi.achievements:add{
	id = "tosx_ronin_margin",
	name = "Narrow Margin",
	tip = "Win a battle with all Mechs at 1 Health",
	img = "img/achievements/tosx_ronin_margin.png",
	squad = "tosx_MechaRonin",
}

modApi.achievements:add{
		id = "tosx_ronin_secret",
		name = "Mecha Ronin Secret Reward",
		tip = "Complete all 3 Mecha Ronin achievements\n\nThe Sharp End: $aa\nEasy Prey: $bb\nNarrow Margin: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_ronin_secret.png",
		squad = "tosx_MechaRonin",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_roninUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Sanctuary',
		tip = 'Sanctuary unlocked. This structure can now appear in future missions on Pinnacle.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this