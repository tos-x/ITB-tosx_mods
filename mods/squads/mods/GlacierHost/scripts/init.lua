local descriptiontext = "Slowly but surely, these Mechs will bury any threat under a wall of ice."

local mod = {
	id = "tosx_GlacierHost",
	name = "Glacier Host",
	version = "0.04",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
	dependencies = { easyEdit = "2.0.2" },
}

-- Helper function to load mod scripts
function mod:loadScript(path)
	return require(self.scriptPath..path)
end

function mod:init()
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_glacier1",
			Default =           { PosX = -27, PosY = -9 },
			Animated =          { PosX = -27, PosY = -9, NumFrames = 4},
			Broken =            { PosX = -21, PosY = -7 },
			Submerged =         { PosX = -25, PosY = 6 },
			SubmergedBroken =   { PosX = -18, PosY = 6 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_glacier2",			
			Default =           { PosX = -20, PosY = 5 },
			Animated =          { PosX = -20, PosY = 5, NumFrames = 4},
			Broken =            { PosX = -19, PosY = 6 },
			Submerged =         { PosX = -17, PosY = 13 },
			SubmergedBroken =   { PosX = -17, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_glacier3",
			Default =           { PosX = -20, PosY = -3 },
			Animated =          { PosX = -20, PosY = -3, NumFrames = 4},
			Broken =            { PosX = -18, PosY = 2 },
			Submerged =         { PosX = -18, PosY = 8 },
			SubmergedBroken =   { PosX = -17, PosY = 10 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Glacier Orange", 
		image = "img/units/player/tosx_mech_glacier1.png",
		colorMap = {
			lights =         { 255, 255, 255 },
			main_highlight = { 235, 164, 67 },
			main_light =     { 166, 63, 48 },
			main_mid =       { 86, 42, 41 },
			main_dark =      { 40, 24, 22 },
			metal_dark =     { 25, 27, 33 },
			metal_mid =      { 43, 48, 62 },
			metal_light =    { 99, 105, 119 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_glacier1.png",self.resourcePath.."img/weapons/tosx_weapon_glacier1.png")
	modApi:appendAsset("img/weapons/tosx_weapon_glacier2.png",self.resourcePath.."img/weapons/tosx_weapon_glacier2.png")
	modApi:appendAsset("img/weapons/tosx_weapon_glacier3.png",self.resourcePath.."img/weapons/tosx_weapon_glacier3.png")
	modApi:appendAsset("img/effects/tosx_iceblast_U.png",self.resourcePath.."img/effects/tosx_iceblast_U.png")
	modApi:appendAsset("img/effects/tosx_iceblast_R.png",self.resourcePath.."img/effects/tosx_iceblast_R.png")
	modApi:appendAsset("img/effects/tosx_iceblast_L.png",self.resourcePath.."img/effects/tosx_iceblast_L.png")
	modApi:appendAsset("img/effects/tosx_iceblast_D.png",self.resourcePath.."img/effects/tosx_iceblast_D.png")
	
	modApi:appendAsset("img/effects/tosx_shotup_transfer.png",self.resourcePath.."img/effects/tosx_shotup_transfer.png")
	modApi:appendAsset("img/effects/tosx_shotup_transfer2.png",self.resourcePath.."img/effects/tosx_shotup_transfer2.png")
	
	modApi:appendAsset("img/units/aliens/tosx_icerock_1.png",self.resourcePath.."img/units/aliens/tosx_icerock_1.png")
	modApi:appendAsset("img/units/aliens/tosx_icerock_1_death.png",self.resourcePath.."img/units/aliens/tosx_icerock_1_death.png")
	modApi:appendAsset("img/units/aliens/tosx_icerock_1_emerge.png",self.resourcePath.."img/units/aliens/tosx_icerock_1_emerge.png")
	
	modApi:appendAsset("img/effects/tosx_icerocker_D.png",self.resourcePath.."img/effects/tosx_icerocker_D.png")
	modApi:appendAsset("img/effects/tosx_icerocker_L.png",self.resourcePath.."img/effects/tosx_icerocker_L.png")
	modApi:appendAsset("img/effects/tosx_icerocker_R.png",self.resourcePath.."img/effects/tosx_icerocker_R.png")
	modApi:appendAsset("img/effects/tosx_icerocker_U.png",self.resourcePath.."img/effects/tosx_icerocker_U.png")

	modApi:appendAsset("img/combat/icons/tosx_frozen_remove.png", self.resourcePath.."img/combat/icons/tosx_frozen_remove.png")
		Location["combat/icons/tosx_frozen_remove.png"] = Point(-12,7)
	modApi:appendAsset("img/combat/icons/tosx_frozen_remove_miss.png", self.resourcePath.."img/combat/icons/tosx_frozen_remove_miss.png")
		Location["combat/icons/tosx_frozen_remove_miss.png"] = Point(-12,7)
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_glacier_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_glacier_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Glacier Host","tosx_BlizzardMech", "tosx_WallMech", "tosx_ScatterMech", id = "tosx_GlacierHost",}, "Glacier Host", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers"):load()
end

return mod