
local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_DeathDealers" -- Also the squad id

function tosx_gunnersquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_gunner_axefall" then
		modApi.achievements:trigger(modid,"tosx_gunner_secret", {aa = true})
	elseif id == "tosx_gunner_leaderkill" then
		modApi.achievements:trigger(modid,"tosx_gunner_secret", {bb = true})
	elseif id == "tosx_gunner_cheap" then
		modApi.achievements:trigger(modid,"tosx_gunner_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_gunner_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_gunner_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_gunner_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_gunnerUnlock())
	end
end

local imgs = {
	"axefall",
	"leaderkill",
	"cheap",
	"secret",
}

local achname = "tosx_gunner_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_gunner_axefall",
	name = "Fall of the Axe",
	tip = "Finish off 4 wounded enemies in a single battle with the Prime Axes",
	img = "img/achievements/tosx_gunner_axefall.png",
	squad = "tosx_DeathDealers",
}

modApi.achievements:add{
	id = "tosx_gunner_leaderkill",
	name = "Not So Tough",
	tip = "Execute 3 Vek Leaders with the Machine Gun in one game",
	img = "img/achievements/tosx_gunner_leaderkill.png",
	squad = "tosx_DeathDealers",
}

modApi.achievements:add{
	id = "tosx_gunner_cheap",
	name = "Death is Cheap",
	tip = "Use the Line Shift to revive a Mech",
	img = "img/achievements/tosx_gunner_cheap.png",
	squad = "tosx_DeathDealers",
}

modApi.achievements:add{
		id = "tosx_gunner_secret",
		name = "Death Dealers Secret Reward",
		tip = "Complete all 3 Death Dealers achievements\n\nFall of the Axe: $aa\nNot So Tough: $bb\nDeath is Cheap: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_gunner_secret.png",
		squad = "tosx_DeathDealers",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_gunnerUnlock()
	axefall {
		unlockTitle = 'Structure Unlocked!',
		name = 'Armory',
		tip = 'Armory. This structure can now appear in future missions on Archive.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end