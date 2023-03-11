--INIT.LUA--

local description = "These Mechs create magnetic fields to attack the Vek and reposition themselves."
local icon = ""

local function init(self)
	local sprites = require(self.scriptPath.."libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_mag1",
			Default =           { PosX = -27, PosY = -18 },
			Animated =          { PosX = -27, PosY = -18, NumFrames = 4},
			Broken =            { PosX = -23, PosY = 0 },
			Submerged =         { PosX = -21, PosY = -4 },
			SubmergedBroken =   { PosX = -16, PosY = 11 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_mag2",
			Default =           { PosX = -25, PosY = -2 },
			Animated =          { PosX = -25, PosY = -2, NumFrames = 4},
			Broken =            { PosX = -20, PosY = 8 },
			Submerged =         { PosX = -24, PosY = 4 },
			SubmergedBroken =   { PosX = -15, PosY = 14 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_mag3",
			Default =           { PosX = -15, PosY = -7 },
			Animated =          { PosX = -15, PosY = -7, NumFrames = 4},
			Broken =            { PosX = -14, PosY = 4 },
			Submerged =         { PosX = -16, PosY = 0 },
			SubmergedBroken =   { PosX = -16, PosY = 10 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Magnetic Purple", 
		image = "img/units/player/tosx_mech_mag1.png",
		colorMap = {
			lights =         {0, 240, 176},	--lights
			main_highlight = {125, 112, 169},	--main highli
			main_light =     {51, 61, 118},	--main light
			main_mid =       {24, 30, 54},	--main mid
			main_dark =      { 11, 15, 25},	--main dark
			metal_dark =     {33, 29, 35},	--metal dark
			metal_mid =      {64, 60, 66},	--metal mid
			metal_light =    {130, 119, 126},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_mag1.png",self.resourcePath.."img/weapons/tosx_weapon_mag1.png")
	modApi:appendAsset("img/weapons/tosx_weapon_mag2.png",self.resourcePath.."img/weapons/tosx_weapon_mag2.png")
	modApi:appendAsset("img/weapons/tosx_weapon_mag3.png",self.resourcePath.."img/weapons/tosx_weapon_mag3.png")

	modApi:appendAsset("img/combat/icons/tosx_polarity1_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_polarity1_icon_glow.png")
		Location["combat/icons/tosx_polarity1_icon_glow.png"] = Point(-28,10)
	modApi:appendAsset("img/combat/icons/tosx_polarity2d_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_polarity2_icon_glow.png")
		Location["combat/icons/tosx_polarity2d_icon_glow.png"] = Point(-28,10)
	modApi:appendAsset("img/combat/icons/tosx_polarity2_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_polarity2_icon_glow.png")
		Location["combat/icons/tosx_polarity2_icon_glow.png"] = Point(-13,10)
	modApi:appendAsset("img/combat/tosx_push_square.png",self.resourcePath.."img/combat/push_square.png")
		
	modApi:appendAsset("img/effects/tosx_magflare1.png",self.resourcePath.."img/effects/tosx_magflare1.png")
	modApi:appendAsset("img/effects/tosx_magpush_U.png",self.resourcePath.."img/effects/tosx_magpush_U.png")
	modApi:appendAsset("img/effects/tosx_magpush_D.png",self.resourcePath.."img/effects/tosx_magpush_D.png")
	modApi:appendAsset("img/effects/tosx_magpush_R.png",self.resourcePath.."img/effects/tosx_magpush_R.png")
	modApi:appendAsset("img/effects/tosx_magpush_L.png",self.resourcePath.."img/effects/tosx_magpush_L.png")
	modApi:appendAsset("img/effects/tosx_shotup_flux1.png",self.resourcePath.."img/effects/tosx_shotup_flux1.png")
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_magnet_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_magnet_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end


local function load(self, options, version)
	modApi:addSquad({"Magnetic Golems","tosx_MagnetMech", "tosx_CatapultMech", "tosx_FluxMech", id = "tosx_MagneticGolems"}, "Magnetic Golems", description, self.resourcePath .. "img/icons/squad_icon.png")
	
	local addHooks = require(self.scriptPath.."weapons")	
	modApi:addMissionStartHook(addHooks.ResetMagVars)
	modApi:addMissionNextPhaseCreatedHook(addHooks.ResetMagVars)
	modApi:addTestMechEnteredHook(addHooks.ResetMagVars)
	
	require(self.scriptPath .."achievementTriggers"):load()
end


return {
	id = "tosx_MagneticGolems",
	name = "Magnetic Golems",
	version = "0.16",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",
	description = description,
	init = init,
	load = load,
	dependencies = { easyEdit = "2.0.2" },
}