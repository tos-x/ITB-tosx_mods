local descriptiontext = "This ruthless Squad was assembled to execute tough Vek outright."

local mod = {
	id = "tosx_DeathDealers",
	name = "Death Dealers",
	version = "0.01",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
	dependencies = {
        memedit = "1.0.4",	-- for GetMaxHealth
        modApiExt = "1.21",	-- for achievement hook
    }
}

-- Helper function to load mod scripts
function mod:loadScript(path)
	return require(self.scriptPath..path)
end

function mod:init()
	local sprites = self:loadScript("libs/sprites")
	sprites.addMechs(
		{
			Name = "tosx_mech_gunner1",
			Default =           { PosX = -16, PosY = -1 },
			Animated =          { PosX = -16, PosY = -1, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -14, PosY = 3 },
			Submerged =         { PosX = -14, PosY = 18 },
			SubmergedBroken =   { PosX = -14, PosY = 18 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_gunner2",			
			Default =           { PosX = -16, PosY = -1 },
			Animated =          { PosX = -16, PosY = -1, NumFrames = 4},
			Broken =            { PosX = -14, PosY = 2 },
			Submerged =         { PosX = -17, PosY = 14 },
			SubmergedBroken =   { PosX = -19, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_gunner3",
			Default =           { PosX = -12, PosY = 0 },
			Animated =          { PosX = -12, PosY = -1, NumFrames = 4},
			Broken =            { PosX = -8, PosY = 8 },
			Submerged =         { PosX = -12, PosY = 0 },
			SubmergedBroken =   { PosX = -11, PosY = 16 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Gunmetal Grey",
		image = "img/units/player/tosx_mech_gunner1.png",
		colorMap = {
		
			lights =         { 255, 61, 61 },
            main_highlight = { 70, 87, 90 },
            main_light =     { 41, 52, 54 },
            main_mid =       { 23, 29, 30 },
            main_dark =      { 12, 15, 15 },
			metal_light =    { 146, 149, 141 },
			metal_mid =      { 75, 78, 73 },
			metal_dark =     { 36, 40, 34 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_axes.png",self.resourcePath.."img/weapons/tosx_weapon_axes.png")
	modApi:appendAsset("img/weapons/tosx_weapon_lineshift.png",self.resourcePath.."img/weapons/tosx_weapon_lineshift.png")
	modApi:appendAsset("img/weapons/tosx_weapon_machinegun.png",self.resourcePath.."img/weapons/tosx_weapon_machinegun.png")
    
	modApi:appendAsset("img/effects/tosx_axe_U.png",self.resourcePath.."img/effects/axe_U.png")
	modApi:appendAsset("img/effects/tosx_axe_D.png",self.resourcePath.."img/effects/axe_D.png")
	modApi:appendAsset("img/effects/tosx_axe_L.png",self.resourcePath.."img/effects/axe_L.png")
	modApi:appendAsset("img/effects/tosx_axe_R.png",self.resourcePath.."img/effects/axe_R.png")
	modApi:appendAsset("img/effects/tosx_axeC_U.png",self.resourcePath.."img/effects/axeC_U.png")
	modApi:appendAsset("img/effects/tosx_axeC_D.png",self.resourcePath.."img/effects/axeC_D.png")
	modApi:appendAsset("img/effects/tosx_axeC_L.png",self.resourcePath.."img/effects/axeC_L.png")
	modApi:appendAsset("img/effects/tosx_axeC_R.png",self.resourcePath.."img/effects/axeC_R.png")
	modApi:appendAsset("img/effects/tosx_Saxe_U.png",self.resourcePath.."img/effects/Saxe_U.png")
	modApi:appendAsset("img/effects/tosx_Saxe_D.png",self.resourcePath.."img/effects/Saxe_D.png")
	modApi:appendAsset("img/effects/tosx_Saxe_L.png",self.resourcePath.."img/effects/Saxe_L.png")
	modApi:appendAsset("img/effects/tosx_Saxe_R.png",self.resourcePath.."img/effects/Saxe_R.png")
	modApi:appendAsset("img/effects/tosx_SaxeC_U.png",self.resourcePath.."img/effects/SaxeC_U.png")
	modApi:appendAsset("img/effects/tosx_SaxeC_D.png",self.resourcePath.."img/effects/SaxeC_D.png")
	modApi:appendAsset("img/effects/tosx_SaxeC_L.png",self.resourcePath.."img/effects/SaxeC_L.png")
	modApi:appendAsset("img/effects/tosx_SaxeC_R.png",self.resourcePath.."img/effects/SaxeC_R.png")
    
	modApi:appendAsset("img/effects/tosx_redpulse.png",self.resourcePath.."img/effects/tosx_redpulse.png")
    
	modApi:appendAsset("img/effects/tosx_shot_bullets_U.png",self.resourcePath.."img/effects/tosx_shot_bullets_U.png")
	modApi:appendAsset("img/effects/tosx_shot_bullets_R.png",self.resourcePath.."img/effects/tosx_shot_bullets_R.png")
	
	modApi:copyAsset("img/advanced/combat/icons/icon_boosted_glow.png", "img/combat/icons/tosx_icon_boosted_glow2.png")
		Location["combat/icons/tosx_icon_boosted_glow2.png"] = Point(-13,8)
	modApi:appendAsset("img/combat/icons/tosx_icon_itrap_off_glow.png",self.resourcePath.."img/combat/icons/icon_itrap_off_glow.png")
		Location["combat/icons/tosx_icon_itrap_off_glow.png"] = Point(-13,8)
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_gunner_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_gunner_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Death Dealers","tosx_Gunner1Mech", "tosx_Gunner2Mech", "tosx_Gunner3Mech", id = "tosx_DeathDealers",}, "Death Dealers", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers")
end

return mod