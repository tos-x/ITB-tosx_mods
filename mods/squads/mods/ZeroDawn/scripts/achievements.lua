
local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "tosx_ZeroDawn" -- Also the squad id

function gaiasquad_Chievo(id)
	-- exit if not our squad
	if GAME and GAME.additionalSquadData.squad ~= modid then return end
	if IsTestMechScenario() then return end	
	-- exit if current one is unlocked
	if Board:GetSize() == Point(6,6) then return end -- TipImage
	if modApi.achievements:getProgress(modid,id) then	return end

	modApi.achievements:trigger(modid,id)
	if id == "gaia_navkills" then
		modApi.achievements:trigger(modid,"gaia_secret", {aa = true})
	elseif id == "gaia_zeta" then
		modApi.achievements:trigger(modid,"gaia_secret", {bb = true})
	elseif id == "gaia_still" then
		modApi.achievements:trigger(modid,"gaia_secret", {cc = true})
	end
	if modApi.achievements:isProgress(modid,"gaia_secret", {reward = true }) then return end
	if modApi.achievements:isProgress(modid,"gaia_secret", {aa = true, bb = true, cc = true,}) then
		-- Suppress the toast for the secret achievement
		local oldtoastadd = modApi.toasts.add
		modApi.toasts.add = function() end
		modApi.achievements:trigger(modid,"gaia_secret", {reward = true })	
		modApi.toasts.add = oldtoastadd
		
		modApi.toasts:add(gaiaUnlock())
	end
end

local imgs = {
	"navkills",
	"zeta",
	"still",
	"secret",
}

local achname = "gaia_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. img ..".png")
end

modApi.achievements:add{
	id = "gaia_navkills",
	name = "Doomed Navigator",
	tip = "Kill 2 enemies with a single use of the Navigation Relay",
	img = "img/achievements/gaia_navkills.png",
	squad = "tosx_ZeroDawn",
}

modApi.achievements:add{
	id = "gaia_zeta",
	name = "Barrage",
	tip = "Kill 2 enemies with a single attack of the Zeta Cannons, while firing across the whole map",
	img = "img/achievements/gaia_zeta.png",
	squad = "tosx_ZeroDawn",
}

modApi.achievements:add{
	id = "gaia_still",
	name = "Immovable",
	tip = "Win a mission without the Tall Mech ever leaving its starting tile",
	img = "img/achievements/gaia_still.png",
	squad = "tosx_ZeroDawn",
}

modApi.achievements:add{
		id = "gaia_secret",
		name = "Zero Dawn Secret Reward",
		tip = "Complete all 3 Zero Dawn achievements\n\nDoomed Navigator: $aa\nBarrage: $bb\nImmovable: $cc\n\nReward: $reward",
		img = "img/achievements/gaia_secret.png",
		squad = "tosx_ZeroDawn",
		global = "Secret Rewards",
		secret = true,
		objective = {
			aa = true,
			bb = true,
			cc = true,
			reward = "?|Secret Pilot"
		}
}

local pilot = {
	Id = "Pilot_Aloy",
	Personality = "Aloy",
	Name = "Aloy",
	Voice = "/voice/bethany",
	Sex = SEX_FEMALE,
	Skill = "AloySkill",
}

function pilot:IsEnabled()
	local available = modApi.achievements:getProgress(modid,"gaia_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(modid,"gaia_secret").reward
	
	return available
end

function this:init()
	return CreatePilot(pilot)	
end

function gaiaUnlock()
	return {
		unlockTitle = 'Pilot Unlocked!',
		name = 'Secret Pilot',
		tip = 'Secret Pilot Aloy unlocked. This pilot can now be found in future runs.',
		img = 'img/achievements/gaia_secret.png',
	}
end

return this