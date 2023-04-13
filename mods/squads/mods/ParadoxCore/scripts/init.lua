local descriptiontext = "Hailing from a future more distant than any other Squad, these Mechs bend time and space in combat."

local mod = {
	id = "tosx_ParadoxCore",
	name = "Paradox Core",
	version = "0.12",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
    dependencies = {
		modApiExt = "1.2",
		easyEdit = "2.0.2",
	},
}

-- Helper function to load mod scripts
function mod:loadScript(path)
	return require(self.scriptPath..path)
end

local function getOption(options, name, defaultVal)
	if options and options[name] then
		return options[name].enabled
	end
	if defaultVal then return defaultVal end
	return true
end

function mod:metadata()
  modApi:addGenerationOption(
    "resetTutorials",
    "Reset Tutorial Tooltips",
    "Check to reset all tutorial tooltips for this profile",
    { enabled = false }
  )
end

function mod:init()	
	-- Fix BlobBoss portrait, since it missing causes problems
	BlobBoss.Portrait = "enemy/BlobBoss"

	-- load sprites
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_time1",
			Default =           { PosX = -24, PosY = -12 },
			Animated =          { PosX = -24, PosY = -12, NumFrames = 4},
			Broken =            { PosX = -24, PosY = -12 },
			Submerged =         { PosX = -19, PosY = 4 },
			SubmergedBroken =   { PosX = -20, PosY = 2 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_time2",
			Default =           { PosX = -22, PosY = -6 },
			Animated =          { PosX = -22, PosY = -6, NumFrames = 4},
			Broken =            { PosX = -19, PosY = 0 },
			Submerged =         { PosX = -22, PosY = 5 },
			SubmergedBroken =   { PosX = -19, PosY = 10 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_time3",
			Default =           { PosX = -17, PosY = -8 },
			Animated =          { PosX = -17, PosY = -8, NumFrames = 4},
			Broken =            { PosX = -14, PosY = 3 },
			Submerged =         { PosX = -17, PosY = -8 },
			SubmergedBroken =   { PosX = -16, PosY = 3 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Paradox White", 
		image = "img/units/player/tosx_mech_time1.png",
		colorMap = {
			lights =         {0, 185, 238},	--lights		
			main_highlight = {228, 226, 228},	--main highli
			main_light =     {159, 155, 162},	--main light
			main_mid =       {105, 99, 110},	--main mid		
			main_dark =      {28, 29, 32},	--main dark
			metal_dark =     {49, 46, 59},	--metal dark
			metal_mid =      {63, 69, 85},	--metal mid
			metal_light =    {110, 139, 169},	--metal light
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/effects/tosx_loop0.png",self.resourcePath.."img/effects/tosx_loop0.png")
	modApi:appendAsset("img/effects/tosx_loop1.png",self.resourcePath.."img/effects/tosx_loop1.png")
	modApi:appendAsset("img/effects/tosx_loop2.png",self.resourcePath.."img/effects/tosx_loop2.png")
	modApi:appendAsset("img/effects/tosx_loop0a.png",self.resourcePath.."img/effects/tosx_loop0a.png")
	modApi:appendAsset("img/effects/tosx_loop1a.png",self.resourcePath.."img/effects/tosx_loop1a.png")
	modApi:appendAsset("img/effects/tosx_loop2a.png",self.resourcePath.."img/effects/tosx_loop2a.png")
	
	modApi:appendAsset("img/effects/time_spear1_D.png",self.resourcePath.."img/effects/time_spear1_D.png")
	modApi:appendAsset("img/effects/time_spear1_U.png",self.resourcePath.."img/effects/time_spear1_U.png")
	modApi:appendAsset("img/effects/time_spear1_L.png",self.resourcePath.."img/effects/time_spear1_L.png")
	modApi:appendAsset("img/effects/time_spear1_R.png",self.resourcePath.."img/effects/time_spear1_R.png")
	modApi:appendAsset("img/effects/time_spear2_D.png",self.resourcePath.."img/effects/time_spear2_D.png")
	modApi:appendAsset("img/effects/time_spear2_U.png",self.resourcePath.."img/effects/time_spear2_U.png")
	modApi:appendAsset("img/effects/time_spear2_L.png",self.resourcePath.."img/effects/time_spear2_L.png")
	modApi:appendAsset("img/effects/time_spear2_R.png",self.resourcePath.."img/effects/time_spear2_R.png")
	
	modApi:appendAsset("img/effects/tosx_spinclock.png",self.resourcePath.."img/effects/tosx_spinclock.png")
	
	modApi:appendAsset("img/effects/tosx_summonrift.png",self.resourcePath.."img/effects/tosx_summonrift.png")
	
	modApi:appendAsset("img/weapons/tosx_weapon_time1.png",self.resourcePath.."img/weapons/tosx_weapon_time1.png")
	modApi:appendAsset("img/weapons/tosx_weapon_time2.png",self.resourcePath.."img/weapons/tosx_weapon_time2.png")
	modApi:appendAsset("img/weapons/tosx_weapon_time3.png",self.resourcePath.."img/weapons/tosx_weapon_time3.png")
	modApi:appendAsset("img/weapons/tosx_weapon_time4.png",self.resourcePath.."img/weapons/tosx_weapon_time4.png")
	
	modApi:appendAsset("img/combat/icons/tosx_future_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_future_icon_glow.png")
		Location["combat/icons/tosx_future_icon_glow.png"] = Point(-12,8)
	modApi:appendAsset("img/combat/icons/tosx_future_icon_glowX.png",self.resourcePath.."img/combat/icons/tosx_future_icon_glowX.png")
		Location["combat/icons/tosx_future_icon_glowX.png"] = Point(-12,8)
		
	modApi:appendAsset("img/combat/icons/tosx_stasis_icon_glow.png",self.resourcePath.."img/combat/icons/tosx_stasis_icon_glow.png")
		Location["combat/icons/tosx_stasis_icon_glow.png"] = Point(-23,9)
	modApi:appendAsset("img/combat/icons/tosx_stasis_icon_off_glow.png",self.resourcePath.."img/combat/icons/tosx_stasis_icon_off_glow.png")
		Location["combat/icons/tosx_stasis_icon_off_glow.png"] = Point(-23,9)
	modApi:appendAsset("img/combat/icons/tosx_stasis_icon_glowB.png",self.resourcePath.."img/combat/icons/tosx_stasis_icon_glow.png")
		Location["combat/icons/tosx_stasis_icon_glowB.png"] = Point(-15,9)
	modApi:appendAsset("img/combat/icons/tosx_stasis_icon_off_glowB.png",self.resourcePath.."img/combat/icons/tosx_stasis_icon_off_glow.png")
		Location["combat/icons/tosx_stasis_icon_off_glowB.png"] = Point(-15,9)
			
	--require(mod.scriptPath .."LApi/LApi") --Remove LApi dependence (less efficient)
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	self.timeLooping = require(self.scriptPath .."libs/timeLooping")
	self.timeLooping:init(self)
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_time_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_time_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Paradox Core","tosx_LancerMech", "tosx_TimestopperMech", "tosx_TravelerMech", id = self.id}, "Paradox Core", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	self.timeLooping:load()

	-- reset tutorial tooltips if checked
	if options.resetTutorials and options.resetTutorials.enabled then
		require(self.scriptPath .."libs/tutorialTips"):ResetAll()
		options.resetTutorials.enabled = false
	end
end

return mod