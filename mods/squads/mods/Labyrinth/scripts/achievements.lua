
local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_Labyrinth" -- Also the squad id

function tosx_warpsquad_Chievo(id)
	-- exit if not our squad
	if GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then	return end
	modApi.achievements:trigger(modid,id)
	if id == "tosx_warp_fun" then
		modApi.achievements:trigger(modid,"tosx_warp_secret", {aa = true})
	elseif id == "tosx_warp_invite" then
		modApi.achievements:trigger(modid,"tosx_warp_secret", {bb = true})
	elseif id == "tosx_warp_lights" then
		modApi.achievements:trigger(modid,"tosx_warp_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"tosx_warp_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"tosx_warp_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"tosx_warp_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(tosx_warpUnlock())
	end
end

local imgs = {
	"fun",
	"invite",
	"lights",
	"secret",
}

local achname = "tosx_warp_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "tosx_warp_fun",
	name = "Fun With Portals",
	tip = "Drop 4 enemies into water or chasms in a single battle with the Portal Launcher",
	img = "img/achievements/tosx_warp_fun.png",
	squad = "tosx_Labyrinth",
}

modApi.achievements:add{
	id = "tosx_warp_invite",
	name = "The Invitation",
	tip = "Teleport an enemy into the back row using the Long Teleporter",
	img = "img/achievements/tosx_warp_invite.png",
	squad = "tosx_Labyrinth",
}

modApi.achievements:add{
	id = "tosx_warp_lights",
	name = "City of Lights",
	tip = "Shield 6 building tiles with the Spatial Prism in a single battle",
	img = "img/achievements/tosx_warp_lights.png",
	squad = "tosx_Labyrinth",
}

modApi.achievements:add{
		id = "tosx_warp_secret",
		name = "Labyrinth Secret Reward",
		tip = "Complete all 3 Labyrinth achievements\n\nFun With Portals: $aa\nThe Invitation: $bb\nCity of Lights: $cc\n\nReward: $reward",
		img = "img/achievements/tosx_warp_secret.png",
		squad = "tosx_Labyrinth",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Structure"
		}
}

function tosx_warpUnlock()
	return {
		unlockTitle = 'Structure Unlocked!',
		name = 'Data Center',
		tip = 'Data Center. This structure can now appear in future missions on Pinnacle.',
		img = 'img/achievements/'..achname..'secret.png',
	}
end