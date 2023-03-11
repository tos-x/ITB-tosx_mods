--INIT.LUA--

local description = "These Mechs hail from beyond the known Islands, drawing power from water."
local icon = ""

local function init(self)
	local sprites = require(self.scriptPath.."libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_surge",
			Default =           { PosX = -20, PosY = -4 },
			Animated =          { PosX = -20, PosY = -4, NumFrames = 4},
			Broken =            { PosX = -18, PosY = -1 },
			Submerged =         { PosX = -17, PosY = 6 },
			SubmergedBroken =   { PosX = -17, PosY = 11 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_hydro",
			Default =           { PosX = -28, PosY = -19 },
			Animated =          { PosX = -28, PosY = -19, NumFrames = 4},
			Broken =            { PosX = -19, PosY = -1 },
			Submerged =         { PosX = -23, PosY = -5 },
			SubmergedBroken =   { PosX = -16, PosY = 8 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_cargo",
			Default =           { PosX = -23, PosY = -9 },
			Animated =          { PosX = -23, PosY = -9, NumFrames = 4},
			Broken =            { PosX = -22, PosY = 2 },
			Submerged =         { PosX = -23, PosY = -9 },
			SubmergedBroken =   { PosX = -18, PosY = 10 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Levithan Teal", 
		image = "img/units/player/tosx_mech_cargo.png",
		colorMap = {
			lights =         {255, 115, 68},	--lights
			main_highlight = {39, 78, 95},	--main highlight
			main_light =     {21, 33, 46},	--main light
			main_mid =       { 12, 15, 28},	--main mid
			main_dark =      { 8, 10, 12},	--main dark
			metal_dark =     {12, 22, 26},	--metal dark
			metal_mid =      {44, 96, 106},	--metal mid
			metal_light =    {104, 166, 176},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_dowsingcharge.png",self.resourcePath.."img/weapons/tosx_weapon_dowsingcharge.png")
	modApi:appendAsset("img/weapons/tosx_weapon_hydrocannon.png",self.resourcePath.."img/weapons/tosx_weapon_hydrocannon.png")
	modApi:appendAsset("img/weapons/tosx_weapon_cargo.png",self.resourcePath.."img/weapons/tosx_weapon_cargo.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher1.png",self.resourcePath.."img/effects/tosx_shotup_splasher1.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher2.png",self.resourcePath.."img/effects/tosx_shotup_splasher2.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher3.png",self.resourcePath.."img/effects/tosx_shotup_splasher3.png")
	modApi:appendAsset("img/effects/tosx_drain_a.png",self.resourcePath.."img/effects/tosx_drain_a.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher2_lava.png",self.resourcePath.."img/effects/tosx_shotup_splasher2_lava.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher3_lava.png",self.resourcePath.."img/effects/tosx_shotup_splasher3_lava.png")
	modApi:appendAsset("img/effects/tosx_drain_a_lava.png",self.resourcePath.."img/effects/tosx_drain_a_lava.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher2_acid.png",self.resourcePath.."img/effects/tosx_shotup_splasher2_acid.png")
	modApi:appendAsset("img/effects/tosx_shotup_splasher3_acid.png",self.resourcePath.."img/effects/tosx_shotup_splasher3_acid.png")
	modApi:appendAsset("img/effects/tosx_drain_a_acid.png",self.resourcePath.."img/effects/tosx_drain_a_acid.png")
	modApi:appendAsset("img/units/mission/train_w_broken.png",self.resourcePath.."img/units/mission/train_w_broken.png")
	modApi:appendAsset("img/units/mission/missilesilo_w_broken.png",self.resourcePath.."img/units/mission/missilesilo_w_broken.png")
	modApi:appendAsset("img/units/mission/generator_3_w_broken.png",self.resourcePath.."img/units/mission/generator_3_w_broken.png")

	modApi:appendAsset("img/combat/icons/tosx_cargo_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_cargo_icon_glow.png")
		Location["combat/icons/tosx_cargo_icon_glow.png"] = Point(-28,10)
	modApi:appendAsset("img/combat/icons/tosx_create_water_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_create_water_icon_glow.png")
		Location["combat/icons/tosx_create_water_icon_glow.png"] = Point(-13,10)
	modApi:appendAsset("img/combat/icons/tosx_create_water_icon_glowU.png",self.resourcePath.."img/combat/icons/tosx_create_water_icon_glow.png")
		Location["combat/icons/tosx_create_water_icon_glowU.png"] = Point(-28,10)
	modApi:copyAsset("img/combat/icons/icon_water_immune_glow.png", "img/combat/icons/tosx_create_water_icon_glowX.png")
		Location["combat/icons/tosx_create_water_icon_glowX.png"] = Point(-13,10)
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_hydro_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_hydro_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
	
end


local function load(self, options, version)
	
	modApi:addSquad({"Hydro Leviathans","tosx_SurgeMech", "tosx_HydroMech", "tosx_CargoMech", id = "tosx_HydroLeviathans"}, "Hydro Leviathans", description, self.resourcePath .. "img/icons/squad_icon.png")
	
	local addHooks = require(self.scriptPath.."weapons")	
	modApi:addMissionEndHook(addHooks.ResetStorageVars)
	modApi:addMissionStartHook(addHooks.ResetStorageVars)
	modApi:addMissionNextPhaseCreatedHook(addHooks.ResetStorageVars)
	modApi:addTestMechEnteredHook(addHooks.ResetStorageVars)
	modApi:addTestMechExitedHook(addHooks.ResetStorageVars)
	require(self.scriptPath .."achievementTriggers"):load()
end


return {
	id = "tosx_HydroLeviathans",
	name = "Hydro Leviathans",
	version = "0.23",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",
	description = description,
	init = init,
	load = load,
	dependencies = { easyEdit = "2.0.2" },
}