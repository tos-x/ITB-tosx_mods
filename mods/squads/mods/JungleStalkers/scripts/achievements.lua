
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_JungleStalkers" -- Also the squad id

function tosx_junglesquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_jungle_return" then
		modApi.achievements:trigger(modid,"tosx_jungle_secret", {aa = true})
	elseif id == "tosx_jungle_ambush" then
		modApi.achievements:trigger(modid,"tosx_jungle_secret", {bb = true})
	elseif id == "tosx_jungle_trapdoor" then
		modApi.achievements:trigger(modid,"tosx_jungle_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_jungle_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_jungle_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_jungle_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_jungleUnlock())
	end
end

local imgs = {
	"return",
	"ambush",
	"trapdoor",
	"secret",
}

local achname = "tosx_jungle_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_jungle_return",
	name = "What Goes Around",
	tip = "Kill 2 enemies with a single use of the Arc Blade, while having the Mech catch it",
	img = "img/achievements/tosx_jungle_return.png",
	squad = "tosx_JungleStalkers",
}

modApi.achievements:add{
	id = "tosx_jungle_ambush",
	name = "Ambush!",
	tip = "Kill 6 enemies in a single turn",
	img = "img/achievements/tosx_jungle_ambush.png",
	squad = "tosx_JungleStalkers",
}

modApi.achievements:add{
	id = "tosx_jungle_trapdoor",
	name = "Trap Door",
	tip = "Place 3 traps on spawning Vek in a single mission",
	img = "img/achievements/tosx_jungle_trapdoor.png",
	squad = "tosx_JungleStalkers",
}

modApi.achievements:add{
		id = "tosx_jungle_secret",
		name = "Jungle Stalkers Secret Reward",
		tip = "Complete all 3 Jungle Stalkers achievements\n\nWhat Goes Around: $aa\nAmbush: $bb\nTrap Door: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_jungle_secret.png",
		squad = "tosx_JungleStalkers",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_jungleUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Lumber Mill',
		tip = 'Lumber Mill. This structure can now appear in future missions on Archive.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this