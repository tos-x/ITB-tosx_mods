local descriptiontext = "An endless supply of warheads allow these Mechs to rain death near and far."

local mod = {
	id = "tosx_MissileCommand",
	name = "Missile Command",
	version = "0.01",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
	dependencies = {
        memedit = "1.0.4",	-- for gunner GetMaxHealth
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
			Name = "tosx_mech_missile1",
			Default =           { PosX = -16, PosY = -7 },
			Animated =          { PosX = -16, PosY = -7, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -15, PosY = -4 },
			Submerged =         { PosX = -18, PosY = 7 },
			SubmergedBroken =   { PosX = -18, PosY = 8 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_missile2",
			Default =           { PosX = -20, PosY = 3 },
			Animated =          { PosX = -20, PosY = 3, NumFrames = 3},
			Broken =            { PosX = -19, PosY = 7 },
			Submerged =         { PosX = -18, PosY = 10 },
			SubmergedBroken =   { PosX = -18, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_missile3",			
			Default =           { PosX = -19, PosY = -7 },
			Animated =          { PosX = -19, PosY = -7, NumFrames = 4},
			Broken =            { PosX = -18, PosY = -2 },
			Submerged =         { PosX = -14, PosY = 10 },
			SubmergedBroken =   { PosX = -14, PosY = 12 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Missile Tan",
		image = "img/units/player/tosx_mech_missile1.png",
		colorMap = {
		
			lights =         { 75, 206, 255 },
			main_highlight = { 188, 155, 119 },
			main_light =     { 143, 107, 80 },
			main_mid =       { 81, 56, 45 },
			main_dark =      { 35, 24, 20 },
			metal_light =    { 98, 98, 87 },
			metal_mid =      { 60, 61, 55 },
			metal_dark =     { 39, 40, 37 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/effects/tosx_shotup_ballistic.png",self.resourcePath.."img/effects/tosx_shotup_ballistic.png")
	modApi:appendAsset("img/effects/tosx_shotup_closemissile0.png",self.resourcePath.."img/effects/tosx_shotup_closemissile0.png")
	modApi:appendAsset("img/effects/tosx_shotup_closemissile.png",self.resourcePath.."img/effects/tosx_shotup_closemissile.png")
	modApi:appendAsset("img/effects/tosx_shot_closemissile_U.png",self.resourcePath.."img/effects/tosx_shot_closemissile_U.png")
	modApi:appendAsset("img/effects/tosx_shot_closemissile_R.png",self.resourcePath.."img/effects/tosx_shot_closemissile_R.png")
    
	modApi:appendAsset("img/weapons/tosx_weapon_icbm.png",self.resourcePath.."img/weapons/tosx_weapon_icbm.png")
	modApi:appendAsset("img/weapons/tosx_weapon_proximity.png",self.resourcePath.."img/weapons/tosx_weapon_proximity.png")
	modApi:appendAsset("img/weapons/tosx_weapon_standoff.png",self.resourcePath.."img/weapons/tosx_weapon_standoff.png")
	
	modApi:copyAsset("img/advanced/combat/icons/icon_boosted_glow.png", "img/combat/icons/tosx_icon_boosted_glow2.png")
		Location["combat/icons/tosx_icon_boosted_glow2.png"] = Point(-13,8)
	modApi:appendAsset("img/combat/icons/tosx_icon_itrap_off_glow.png",self.resourcePath.."img/combat/icons/icon_itrap_off_glow.png")
		Location["combat/icons/tosx_icon_itrap_off_glow.png"] = Point(-13,8)
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_missile_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_missile_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Missile Command","tosx_Missile1Mech", "tosx_Missile2Mech", "tosx_Missile3Mech", id = "tosx_MissileCommand",}, "Missile Command", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
end

return mod