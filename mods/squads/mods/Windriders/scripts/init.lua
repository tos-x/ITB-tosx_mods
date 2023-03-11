local descriptiontext = "R.S.T.'s atmospheric technology allows these Mechs to control the wind and sky, rather than engage the Vek directly."

local mod = {
	id = "tosx_Windriders",
	name = "Windriders",
	version = "0.07",
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
	-- load sprites
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_wind1",
			Default =           { PosX = -30, PosY = -12 },
			Animated =          { PosX = -30, PosY = -12, NumFrames = 4, Time = 0.4},
			Broken =            { PosX = -24, PosY = 2 },
			Submerged =         { PosX = -30, PosY = -12 },
			SubmergedBroken =   { PosX = -24, PosY = 7 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_wind2",			
			Default =           { PosX = -27, PosY = -14 },
			Animated =          { PosX = -27, PosY = -14, NumFrames = 4, Time = 0.4},
			Broken =            { PosX = -21, PosY = 2 },
			Submerged =         { PosX = -27, PosY = -14 },
			SubmergedBroken =   { PosX = -20, PosY = 8 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_wind3",
			Default =           { PosX = -22, PosY = -13 },
			Animated =          { PosX = -22, PosY = -13, NumFrames = 4},
			Broken =            { PosX = -17, PosY = 3 },
			Submerged =         { PosX = -22, PosY = -13 },
			SubmergedBroken =   { PosX = -18, PosY = 7 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Windrider Red", 
		image = "img/units/player/tosx_mech_wind1.png",
		colorMap = {
			lights =         {0, 255, 12},
			main_highlight = {185, 71, 111},	--main highlight
			main_light =     {89, 42, 82},	--main light
			main_mid =       {41, 23, 51},	--main mid			
			main_dark =      {21, 12, 26},	--main dark		
			metal_dark =     {33, 51, 48},	--metal dark
			metal_mid =      {65, 102, 95},	--metal mid
			metal_light =    {131, 192, 168},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/effects/tosx_dustspin.png",self.resourcePath.."img/effects/tosx_dustspin.png")
	
	modApi:appendAsset("img/weapons/tosx_weapon_wind1.png",self.resourcePath.."img/weapons/tosx_weapon_wind1.png")
	modApi:appendAsset("img/weapons/tosx_weapon_wind2.png",self.resourcePath.."img/weapons/tosx_weapon_wind2.png")
	modApi:appendAsset("img/weapons/tosx_weapon_wind3.png",self.resourcePath.."img/weapons/tosx_weapon_wind3.png")
	
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_wind_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_wind_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Windriders","tosx_AeroMech", "tosx_WindMech", "tosx_HurricaneMech", id = "tosx_Windriders",}, "Windriders", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
end

return mod