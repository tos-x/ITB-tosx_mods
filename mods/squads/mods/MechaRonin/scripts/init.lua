--INIT.LUA--

local description = "Commandeered from ruthless mercenaries, these Mechs are deadly at close range."
local icon = ""
local colorMaps
local hunterdrone

local function init(self)
	local sprites = require(self.scriptPath.."libs/sprites")
	sprites.addMechs(
		{
			Name = "ronin_mech_blade",
			Default =           { PosX = -24, PosY = -9 },
			Animated =          { PosX = -24, PosY = -9, NumFrames = 4},
			Broken =            { PosX = -22, PosY = -6 },
			Submerged =         { PosX = -20, PosY = 6 },
			SubmergedBroken =   { PosX = -19, PosY = 8 },
			Icon =              {},
		},
		{
			Name = "ronin_mech_stealth",
			Default =           { PosX = -18, PosY = -3 },
			Animated =          { PosX = -18, PosY = -3, NumFrames = 12},
			Broken =            { PosX = -18, PosY = -10 },
			Submerged =         { PosX = -16, PosY = 11 },
			SubmergedBroken =   { PosX = -15, PosY = 11 },
			Icon =              {},
		},
		{
			Name = "ronin_mech_hunter",
			Default =           { PosX = -27, PosY = -13 },
			Animated =          { PosX = -27, PosY = -13, NumFrames = 4},
			Broken =            { PosX = -27, PosY = -13 },
			Submerged =         { PosX = -20, PosY = 8 },
			SubmergedBroken =   { PosX = -13, PosY = 7 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Ronin Grey", 
		image = "img/units/player/ronin_mech_blade.png",
		colorMap = {
			lights =         {242, 132, 34},	--lights
			main_highlight = {116, 125, 127},	--main hi
			main_light =     {62, 71, 73},	--main light
			main_mid =       {29, 38, 40},	--main mid
			main_dark =      {7, 12, 13},	--main dark
			metal_dark =     {15, 17, 17},	--metal dark
			metal_mid =      {30, 35, 34},	--metal mid
			metal_light =    {61, 69, 63},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	hunterdrone = require(self.scriptPath .."hunterdrone")
	hunterdrone:init(self)
	
	modApi:appendAsset("img/weapons/ronin_katana.png",self.resourcePath.."img/weapons/ronin_katana.png")
	modApi:appendAsset("img/weapons/ronin_warp.png",self.resourcePath.."img/weapons/ronin_warp.png")
	modApi:appendAsset("img/weapons/ronin_pursuit.png",self.resourcePath.."img/weapons/ronin_pursuit.png")
	
	modApi:appendAsset("img/effects/shot_warp_R.png",self.resourcePath.."img/effects/shot_warp_R.png")
	modApi:appendAsset("img/effects/shot_warp_U.png",self.resourcePath.."img/effects/shot_warp_U.png")
	
	modApi:appendAsset("img/effects/shot_katana_R.png",self.resourcePath.."img/effects/shot_katana_R.png")
	modApi:appendAsset("img/effects/shot_katana_U.png",self.resourcePath.."img/effects/shot_katana_U.png")

	modApi:appendAsset("img/effects/hunter_mark_circle_in.png",self.resourcePath.."img/effects/hunter_mark_circle_in.png")
	modApi:appendAsset("img/combat/icons/hunter_mark_circle1.png",self.resourcePath.."img/combat/icons/hunter_mark_circle1.png")
		Location["combat/icons/hunter_mark_circle1.png"] = Point(-15,5)
			
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_ronin_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_ronin_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
		
end


local function load(self, options, version)	
	modApi:addSquad({"Mecha Ronin","Ronin_BladeMech", "Ronin_HunterMech", "Ronin_StealthMech", id = "tosx_MechaRonin"}, "Mecha Ronin", description, self.resourcePath .. "img/icons/squad_icon.png")
	
	local addHooks = require(self.scriptPath.."weapons")	
	modApi:addMissionEndHook(addHooks.ResetMarkVars)
	modApi:addMissionStartHook(addHooks.ResetMarkVars)
	modApi:addTestMechEnteredHook(addHooks.ResetMarkVars)
	modApi:addTestMechExitedHook(addHooks.ResetMarkVars)
	
	require(self.scriptPath .."achievementTriggers"):load()
	
end


return {
	id = "tosx_MechaRonin",
	name = "Mecha Ronin",
	version = "0.15",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",
	description = description,
	init = init,
	load = load,
	dependencies = { easyEdit = "2.0.2" },
}