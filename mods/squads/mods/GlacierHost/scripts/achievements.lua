
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_GlacierHost" -- Also the squad id

function tosx_glaciersquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_glacier_creeping" then
		modApi.achievements:trigger(modid,"tosx_glacier_secret", {aa = true})
	elseif id == "tosx_glacier_permafrost" then
		modApi.achievements:trigger(modid,"tosx_glacier_secret", {bb = true})
	elseif id == "tosx_glacier_thaw" then
		modApi.achievements:trigger(modid,"tosx_glacier_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_glacier_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_glacier_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_glacier_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_glacierUnlock())
	end
end

local imgs = {
	"creeping",
	"permafrost",
	"thaw",
	"secret",
}

local achname = "tosx_glacier_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_glacier_creeping",
	name = "Creeping Cold",
	tip = "Transfer ice between enemies 3 times in a single battle",
	img = "img/achievements/tosx_glacier_creeping.png",
	squad = "tosx_GlacierHost",
}

modApi.achievements:add{
	id = "tosx_glacier_permafrost",
	name = "Permafrost",
	tip = "Block 6 emerging Vek with Frozen units in a single battle",
	img = "img/achievements/tosx_glacier_permafrost.png",
	squad = "tosx_GlacierHost",
}

modApi.achievements:add{
	id = "tosx_glacier_thaw",
	name = "Fast Thaw",
	tip = "Activate the Cryoburst 4 times in a single battle",
	img = "img/achievements/tosx_glacier_thaw.png",
	squad = "tosx_GlacierHost",
}

modApi.achievements:add{
		id = "tosx_glacier_secret",
		name = "Glacier Host Secret Reward",
		tip = "Complete all 3 Glacier Host achievements\n\nCreeping Cold: $aa\nPermafrost: $bb\nFast Thaw: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_glacier_secret.png",
		squad = "tosx_GlacierHost",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_glacierUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Watchtower',
		tip = 'Watchtower unlocked. This structure can now appear in future missions on Pinnacle.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this