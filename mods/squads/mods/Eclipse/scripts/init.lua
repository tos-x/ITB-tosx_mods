--INIT.LUA--

local descriptiontext = "These Mechs employ powerful, precise attacks that benefit from planning."
local icon = ""

local function init(self)
	local sprites = require(self.scriptPath.."libs/sprites")
	sprites.addMechs(
		{
			Name = "ecl_mech_reaper",
			Default =           { PosX = -18, PosY = -10},
			Animated =          { PosX = -18, PosY = -10, NumFrames = 12},
			Broken =            { PosX = -18, PosY = -10 },
			Submerged =         { PosX = -20, PosY = 0 },
			SubmergedBroken =   { PosX = -20, PosY = -0 },
			Icon =              {},
		},
		{
			Name = "ecl_mech_archangel",
			Default =           { PosX = -24, PosY = -10},
			Animated =          { PosX = -24, PosY = -10, NumFrames = 4},
			Broken =            { PosX = -18, PosY = 6 },
			Submerged =         { PosX = -20, PosY = 0 },
			SubmergedBroken =   { PosX = -16, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "ecl_mech_force",
			Default =           { PosX = -18, PosY = -1},
			Animated =          { PosX = -18, PosY = -1, NumFrames = 4},
			Broken =            { PosX = -15, PosY = -1 },
			Submerged =         { PosX = -15, PosY = 8 },
			SubmergedBroken =   { PosX = -15, PosY = 14 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Eclipse Dark", 
		image = "img/units/player/ecl_mech_reaper.png",
		colorMap = {
			lights =         {255, 91, 138},
			main_highlight = {79, 77, 93},
			main_light =     {37, 36, 45},
			main_mid =       {21, 21, 29},
			main_dark =      {10, 9, 18},
			metal_dark =     {38, 38, 39},
			metal_mid =      {81, 81, 82},
			metal_light =    {127, 127, 128},
		}, 
	}
	modApi:addPalette(palette)

	modApi:appendAsset("img/weapons/ecl_longrifle.png",self.resourcePath.."img/weapons/ecl_longrifle.png")
	modApi:appendAsset("img/weapons/ecl_reload.png",self.resourcePath.."img/weapons/ecl_reload.png")
	modApi:appendAsset("img/weapons/ecl_orionmissiles.png",self.resourcePath.."img/weapons/ecl_orionmissiles.png")
	modApi:appendAsset("img/weapons/ecl_gravpulse.png",self.resourcePath.."img/weapons/ecl_gravpulse.png")
	modApi:appendAsset("img/effects/explo_gravpulse1.png",self.resourcePath.."img/effects/explo_gravpulse1.png")
	modApi:appendAsset("img/effects/misc_ammo1.png",self.resourcePath.."img/effects/misc_ammo1.png")
	modApi:appendAsset("img/effects/shot_longrifle_R.png",self.resourcePath.."img/effects/shot_longrifle_R.png")
	modApi:appendAsset("img/effects/shot_longrifle_U.png",self.resourcePath.."img/effects/shot_longrifle_U.png")
	modApi:appendAsset("img/effects/shotup_orion_missile.png",self.resourcePath.."img/effects/shotup_orion_missile.png")
	
	modApi:copyAsset("img/combat/icons/icon_smoke_immune_glow.png", "img/combat/icons/tosx_smoke_immune_glow.png")
		Location["combat/icons/tosx_smoke_immune_glow.png"] = Point(-28,10)
	modApi:copyAsset("img/combat/icons/icon_doubleshot_glow.png", "img/combat/icons/tosx_doubleshot_glow.png")
		Location["combat/icons/tosx_doubleshot_glow.png"] = Point(-13,10)
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_eclipse_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_eclipse_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
	
end


local function load(self, options, version)
	modApi:addSquad({"Eclipse","ECL_ReaperMech", "ECL_ArchangelMech", "ECL_ForceMech", id = "tosx_Eclipse"}, "Eclipse", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
end


return {
	id = "tosx_Eclipse",
	name = "Eclipse",
	version = "0.20",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",
	description = descriptiontext,
	init = init,
	load = load,
	dependencies = { easyEdit = "2.0.2" },
}