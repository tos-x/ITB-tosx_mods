
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_Eclipse" -- also Squad id

function tosx_eclipsesquad_Chievo(id)
	-- exit if not our squad
	if Board:GetSize() == Point(6,6) then return end -- TipImage
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end

	modApi.achievements:trigger(modid,id)
	if id == "tosx_eclipse_shot" then
		modApi.achievements:trigger(modid,"tosx_eclipse_secret", {aa = true})
	elseif id == "tosx_eclipse_hug" then
		modApi.achievements:trigger(modid,"tosx_eclipse_secret", {bb = true})
	elseif id == "tosx_eclipse_dust" then
		modApi.achievements:trigger(modid,"tosx_eclipse_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_eclipse_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_eclipse_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_eclipse_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_eclipseUnlock())
	end
end

local imgs = {
	"shot",
	"hug",
	"dust",
	"secret",
}

local achname = "tosx_eclipse_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_eclipse_shot",
	name = "Execute",
	tip = "Deal 8 damage with a single shot of the Long Rifle",
	img = "img/achievements/tosx_eclipse_shot.png",
	squad = "tosx_Eclipse",
}

modApi.achievements:add{
	id = "tosx_eclipse_hug",
	name = "Group Hug",
	tip = "Use the Grav Pulse to crush a fully surrounded target",
	img = "img/achievements/tosx_eclipse_hug.png",
	squad = "tosx_Eclipse",
}

modApi.achievements:add{
	id = "tosx_eclipse_dust",
	name = "Coming Storm",
	tip = "Create Smoke on 2 enemies at once using the Orion Missiles",
	img = "img/achievements/tosx_eclipse_dust.png",
	squad = "tosx_Eclipse",
}

modApi.achievements:add{
		id = "tosx_eclipse_secret",
		name = "Eclipse Secret Reward",
		tip = "Complete all 3 Eclipse achievements\n\nExecute: $aa\nGroup Hug: $bb\nComing Storm: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_eclipse_secret.png",
		squad = "tosx_Eclipse",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_eclipseUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Secret Command Post',
		tip = 'Command Post unlocked. This structure can now appear in future missions on R.S.T.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end

return this