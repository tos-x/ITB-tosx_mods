local descriptiontext = "These industrial Mechs use targeted shockwaves to disrupt Vek formations."

local mod = {
	id = "tosx_InterceptGroup",
	name = "Intercept Group",
	version = "0.01",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
}

-- Helper function to load mod scripts
function mod:loadScript(path)
	return require(self.scriptPath..path)
end

function mod:init()
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_burn1",
			Default =           { PosX = -23, PosY = 0 },
			Animated =          { PosX = -23, PosY = 0, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -24, PosY = -2 },
			Submerged =         { PosX = -18, PosY = 12 },
			SubmergedBroken =   { PosX = -18, PosY = 11 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_burn2",			
			Default =           { PosX = -19, PosY = 7 },
			Animated =          { PosX = -19, PosY = 7, NumFrames = 4},
			Broken =            { PosX = -16, PosY = 11 },
			Submerged =         { PosX = -13, PosY = 16 },
			SubmergedBroken =   { PosX = -16, PosY = 16 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_burn3",
			Default =           { PosX = -24, PosY = -4 },
			Animated =          { PosX = -24, PosY = -4, NumFrames = 4},
			Broken =            { PosX = -21, PosY = 1 },
			Submerged =         { PosX = -19, PosY = 7 },
			SubmergedBroken =   { PosX = -20, PosY = 10 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Intercept Red",
		image = "img/units/player/tosx_mech_burn1.png",
		colorMap = {
		
			lights =         { 250, 192, 17 },
			main_highlight = { 211, 77, 70 },
			main_light =     { 111, 29, 32 },
			main_mid =       { 55, 20, 26 },
			main_dark =      { 26, 12, 14 },
			metal_light =    { 110, 101, 118 },
			metal_mid =      { 54, 46, 61 },
			metal_dark =     { 32, 25, 38 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_focusbeam.png",self.resourcePath.."img/weapons/tosx_weapon_focusbeam.png")
	modApi:appendAsset("img/weapons/tosx_weapon_concussion.png",self.resourcePath.."img/weapons/tosx_weapon_concussion.png")
	modApi:appendAsset("img/weapons/tosx_weapon_shockwave.png",self.resourcePath.."img/weapons/tosx_weapon_shockwave.png")
	
	modApi:appendAsset("img/effects/tosx_shotup_seeker.png",self.resourcePath.."img/effects/tosx_shotup_seeker.png")
	
	modApi:appendAsset("img/effects/tosx_heatlaser_start.png",self.resourcePath.."img/effects/tosx_heatlaser_start.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_U.png",self.resourcePath.."img/effects/tosx_heatlaser_U.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_U1.png",self.resourcePath.."img/effects/tosx_heatlaser_U1.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_U2.png",self.resourcePath.."img/effects/tosx_heatlaser_U2.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_R.png",self.resourcePath.."img/effects/tosx_heatlaser_R.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_R1.png",self.resourcePath.."img/effects/tosx_heatlaser_R1.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_R2.png",self.resourcePath.."img/effects/tosx_heatlaser_R2.png")
	modApi:appendAsset("img/effects/tosx_heatlaser_hit.png",self.resourcePath.."img/effects/tosx_heatlaser_hit.png")
	local laser_loc = Point(-12,3)
	Location["effects/tosx_heatlaser_start.png"] = laser_loc
	Location["effects/tosx_heatlaser_U.png"] = laser_loc
	Location["effects/tosx_heatlaser_U1.png"] = laser_loc
	Location["effects/tosx_heatlaser_U2.png"] = laser_loc
	Location["effects/tosx_heatlaser_R.png"] = laser_loc
	Location["effects/tosx_heatlaser_R1.png"] = laser_loc
	Location["effects/tosx_heatlaser_R2.png"] = laser_loc
	Location["effects/tosx_heatlaser_hit.png"] = laser_loc
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_intercept_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_intercept_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Intercept Group","tosx_Burn1Mech", "tosx_Burn2Mech", "tosx_Burn3Mech", id = "tosx_InterceptGroup",}, "Intercept Group", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers"):load()
end

return mod