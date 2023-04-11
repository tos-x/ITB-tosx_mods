--INIT.LUA--

local description = "Constructed from Old Earth war machines, these Mechs deploy drones to swarm the enemy."
local icon = ""
local carrierdrone

local function init(self)
	local sprites = require(self.scriptPath.."libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_carrier",
			Default =           { PosX = -29, PosY = -10 },
			Animated =          { PosX = -29, PosY = -10, NumFrames = 4},
			Broken =            { PosX = -22, PosY = -3 },
			Submerged =         { PosX = -29, PosY = -10 },
			SubmergedBroken =   { PosX = -23, PosY = 1 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_guard",
			Default =           { PosX = -22, PosY = -8 },
			Animated =          { PosX = -22, PosY = -8, NumFrames = 4},
			Broken =            { PosX = -22, PosY = -2 },
			Submerged =         { PosX = -19, PosY = 1 },
			SubmergedBroken =   { PosX = -22, PosY = 4 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_quake",
			Default =           { PosX = -24, PosY = -12 },
			Animated =          { PosX = -24, PosY = -12, NumFrames = 4},
			Broken =            { PosX = -22, PosY = -6 },
			Submerged =         { PosX = -23, PosY = -1 },
			SubmergedBroken =   { PosX = -23, PosY = -1 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Legion Iron", 
		image = "img/units/player/tosx_mech_carrier.png",
		colorMap = {
			lights =         {236, 0, 116},	--lights
			main_highlight = {151, 116, 86},	--main highlight
			main_light =     {97, 62, 32},	--main light
			main_mid =       {51, 33, 18},	--main mid
			main_dark =      {33, 16, 1},	--main dark
			metal_dark =     {54, 68, 69},	--metal dark
			metal_mid =      {88, 111, 114},	--metal mid
			metal_light =    {144, 180, 169},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_launchfighter.png",self.resourcePath.."img/weapons/tosx_weapon_launchfighter.png")
	modApi:appendAsset("img/weapons/tosx_weapon_fighter1.png",self.resourcePath.."img/weapons/tosx_weapon_fighter1.png")
	modApi:appendAsset("img/weapons/tosx_weapon_fighter2.png",self.resourcePath.."img/weapons/tosx_weapon_fighter2.png")
	modApi:appendAsset("img/weapons/tosx_weapon_remote_shield.png",self.resourcePath.."img/weapons/tosx_weapon_remote_shield.png")
	modApi:appendAsset("img/weapons/tosx_weapon_seismic.png",self.resourcePath.."img/weapons/tosx_weapon_seismic.png")
	modApi:appendAsset("img/effects/explo_pulse_shield.png",self.resourcePath.."img/effects/explo_pulse_shield.png")
	modApi:appendAsset("img/effects/shotup_shield.png",self.resourcePath.."img/effects/shotup_shield.png")
	modApi:appendAsset("img/effects/shot_fighter1_R.png",self.resourcePath.."img/effects/shot_fighter1_R.png")
	modApi:appendAsset("img/effects/shot_fighter1_U.png",self.resourcePath.."img/effects/shot_fighter1_U.png")
	modApi:appendAsset("img/effects/shot_fighter2_R.png",self.resourcePath.."img/effects/shot_fighter2_R.png")
	modApi:appendAsset("img/effects/shot_fighter2_U.png",self.resourcePath.."img/effects/shot_fighter2_U.png")
	modApi:appendAsset("img/effects/explo_quake_R.png",self.resourcePath.."img/effects/explo_quake_R.png")
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	require(self.scriptPath.."hooks")
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_legion_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_legion_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
	
	carrierdrone = require(self.scriptPath .."carrierdrone")
	carrierdrone:init(self)
	
end


local function load(self, options, version)
	modApi:addSquad({"Iron Legion","tosx_CarrierMech", "tosx_GuardMech", "tosx_QuakeMech", id = "tosx_IronLegion"}, "Iron Legion", description, self.resourcePath .. "img/icons/squad_icon.png")
	require(self.scriptPath .."achievementTriggers"):load()
	
end


return {
	id = "tosx_IronLegion",
	name = "Iron Legion",
	version = "0.17",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",
	description = description,
	init = init,
	load = load,
    dependencies = {
		modApiExt = "1.2",
        memedit = "1.0.2",
		easyEdit = "2.0.2",
	},
}