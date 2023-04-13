local descriptiontext = "These semi-sentient Mechs exist in a strange balance with each other."

local mod = {
	id = "tosx_ZeroDawn",
	name = "Zero Dawn",
	version = "0.25",
	modApiVersion = "2.8.0",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
    dependencies = { modApiExt = "1.2" },
}

local function getModOptions(mod)
    return mod_loader:getModConfig()[mod.id].options
end

local function getOption(options, name, defaultVal)
	if options and options[name] then
		return options[name].enabled
	end
	if defaultVal then return defaultVal end
	return true
end

-- Helper function to load mod scripts
function mod:loadScript(path)
	return require(self.scriptPath..path)
end

function mod:init()
	-- load sprites
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "gaia_mech_thunder",
			Default =           { PosX = -24, PosY = -13 },
			Animated =          { PosX = -24, PosY = -13, NumFrames = 4},
			Broken =            { PosX = -24, PosY = -13 },
			Submerged =         { PosX = -29, PosY = -12 },
			SubmergedBroken =	{ PosX = -29, PosY = -12 },
			Icon =              {},
		},
		{
			Name = "gaia_mech_earth",
			Default =           { PosX = -25, PosY = -9 },
			Animated =          { PosX = -25, PosY = -9, NumFrames = 4},
			Broken =            { PosX = -25, PosY = -9 },
			Submerged =         { PosX = -29, PosY = -12 },
			SubmergedBroken =	{ PosX = -29, PosY = -12 },
			Icon =              {},
		},
		{
			Name = "gaia_mech_tall",
			Default =           { PosX = -26, PosY = -15},
			Animated =          { PosX = -26, PosY = -15, NumFrames = 4},
			Broken =            { PosX = -26, PosY = -15 },
			Submerged =         { PosX = -29, PosY = -12 },
			SubmergedBroken =	{ PosX = -29, PosY = -12 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Zero Dawn White", 
		image = "img/units/player/gaia_mech_thunder.png",
		colorMap = {
			lights =         {0, 191, 243},	--lights,
			main_highlight = {223, 159, 0},	--main highlight
			main_light =     {158, 113, 0},	--main light
			main_mid =       {94, 71, 0},	--main mid
			main_dark =      {26, 26, 21},	--main dark
			metal_dark =     {47, 54, 58},	--metal dark
			metal_mid =      {120, 131, 136},	--metal mid
			metal_light =    {215, 221, 223},	--metal light
		}, 
	}
	modApi:addPalette(palette)

	modApi:appendAsset("img/effects/gaia_shot_zeta1_R.png",self.resourcePath.."img/effects/gaia_shot_zeta1_R.png")
	modApi:appendAsset("img/effects/gaia_shot_zeta1_U.png",self.resourcePath.."img/effects/gaia_shot_zeta1_U.png")
	modApi:appendAsset("img/effects/gaia_shot_zeta0_R.png",self.resourcePath.."img/effects/gaia_shot_zeta0_R.png")
	modApi:appendAsset("img/effects/gaia_shot_zeta0_U.png",self.resourcePath.."img/effects/gaia_shot_zeta0_U.png")
	modApi:appendAsset("img/effects/gaia_nav_explo1.png",self.resourcePath.."img/effects/gaia_nav_explo1.png")
	modApi:appendAsset("img/effects/gaia_nav_explo2.png",self.resourcePath.."img/effects/gaia_nav_explo2.png")
	modApi:appendAsset("img/effects/gaia_nav_explo3.png",self.resourcePath.."img/effects/gaia_nav_explo3.png")
	modApi:appendAsset("img/effects/gaia_nav_ring1.png",self.resourcePath.."img/effects/gaia_nav_ring1.png")
	modApi:appendAsset("img/effects/gaia_nav_ring2.png",self.resourcePath.."img/effects/gaia_nav_ring2.png")
	modApi:appendAsset("img/effects/gaia_nav_ring3.png",self.resourcePath.."img/effects/gaia_nav_ring3.png")
	modApi:appendAsset("img/effects/gaia_zeta_iceblast_U.png",self.resourcePath.."img/effects/gaia_zeta_iceblast_U.png")
	modApi:appendAsset("img/effects/gaia_zeta_iceblast_R.png",self.resourcePath.."img/effects/gaia_zeta_iceblast_R.png")
	modApi:appendAsset("img/effects/gaia_zeta_iceblast_L.png",self.resourcePath.."img/effects/gaia_zeta_iceblast_L.png")
	modApi:appendAsset("img/effects/gaia_zeta_iceblast_D.png",self.resourcePath.."img/effects/gaia_zeta_iceblast_D.png")
	modApi:appendAsset("img/effects/gaia_forceloader_float.png",self.resourcePath.."img/effects/gaia_forceloader_float.png")
	
	modApi:appendAsset("img/weapons/gaia_science_navpulse.png",self.resourcePath.."img/weapons/gaia_science_navpulse.png")
	modApi:appendAsset("img/weapons/gaia_prime_zeta.png",self.resourcePath.."img/weapons/gaia_prime_zeta.png")
	modApi:appendAsset("img/weapons/gaia_brute_forceloader.png",self.resourcePath.."img/weapons/gaia_brute_forceloader.png")

	modApi:copyAsset("img/combat/icons/icon_energized_glow.png", "img/combat/icons/icon_nav_energized_glow.png")
		Location["combat/icons/icon_nav_energized_glow.png"] = Point(-13,10)
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	self.ach2 = require(self.scriptPath .."achievements2")
	self.ach2:init(self)
	
	self.ach1 = require(self.scriptPath.."achievements")
	self.ach1:init()
end

function mod:load(options, version)
	require(self.scriptPath.."achievementTriggers"):load()
	self.ach2:load()
	
	modApi:addSquad({"Zero Dawn","ZeroDawn_ThunderMech", "ZeroDawn_EarthMech", "ZeroDawn_TallMech", id = "tosx_ZeroDawn"}, "Zero Dawn", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
end

return mod