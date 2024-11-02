local descriptiontext = "These nimble Mechs use a variety of weapons to strike the Vek from unexpected angles."

local mod = {
	id = "tosx_JungleStalkers",
	name = "Jungle Stalkers",
	version = "0.01",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
	dependencies = {
        memedit = "1.0.4",	-- for mines
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
			Name = "tosx_mech_stalkers1",
			Default =           { PosX = -22, PosY = -11 },
			Animated =          { PosX = -22, PosY = -11, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -17, PosY = -3 },
			Submerged =         { PosX = -16, PosY = 8 },
			SubmergedBroken =   { PosX = -13, PosY = 9 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_stalkers2",			
			Default =           { PosX = -23, PosY = -3 },
			Animated =          { PosX = -23, PosY = -3, NumFrames = 4},
			Broken =            { PosX = -19, PosY = 6 },
			Submerged =         { PosX = -19, PosY = 10 },
			SubmergedBroken =   { PosX = -19, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_stalkers3",
			Default =           { PosX = -26, PosY = -4 },
			Animated =          { PosX = -26, PosY = -4, NumFrames = 4},
			Broken =            { PosX = -21, PosY = 6 },
			Submerged =         { PosX = -26, PosY = -4 },
			SubmergedBroken =   { PosX = -21, PosY = 13 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Jungle Green", 
		image = "img/units/player/tosx_mech_stalkers1.png",
		colorMap = {
		
			lights =         { 122, 255, 249 },--{ 255, 96, 96 },
			main_highlight = { 129, 164, 81 },
			main_light =     { 65, 91, 71 },
			main_mid =       { 35, 52, 51 },
			main_dark =      { 22, 33, 16 },
			metal_light =    { 150, 180, 179 },
			metal_mid =      { 71, 85, 85 },
			metal_dark =     { 36, 50, 50 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_arc.png",self.resourcePath.."img/weapons/tosx_weapon_arc.png")
	modApi:appendAsset("img/weapons/tosx_weapon_pincer.png",self.resourcePath.."img/weapons/tosx_weapon_pincer.png")
	modApi:appendAsset("img/weapons/tosx_weapon_trap.png",self.resourcePath.."img/weapons/tosx_weapon_trap.png")
	modApi:appendAsset("img/effects/tosx_shot_disc_U.png",self.resourcePath.."img/effects/tosx_shot_disc_U.png")
	modApi:appendAsset("img/effects/tosx_shot_disc_R.png",self.resourcePath.."img/effects/tosx_shot_disc_R.png")
	modApi:appendAsset("img/effects/tosx_shotup_trap.png",self.resourcePath.."img/effects/tosx_shotup_trap.png")
	modApi:appendAsset("img/effects/tosx_swipe_claw_2b.png",self.resourcePath.."img/effects/tosx_swipe_claw_2b.png")
	
	modApi:copyAsset("img/advanced/combat/icons/icon_boosted_glow.png", "img/combat/icons/tosx_icon_boosted_glow2.png")
		Location["combat/icons/tosx_icon_boosted_glow2.png"] = Point(-13,8)
	
	modApi:copyAsset("img/combat/icons/icon_mine_glow.png", "img/combat/icons/tosx_icon_itrap_glow.png")
		Location["combat/icons/tosx_icon_itrap_glow.png"] = Point(-13,8)
	modApi:appendAsset("img/combat/icons/tosx_icon_itrap_off_glow.png",self.resourcePath.."img/combat/icons/icon_itrap_off_glow.png")
		Location["combat/icons/tosx_icon_itrap_off_glow.png"] = Point(-13,8)
		
	modApi:appendAsset("img/combat/tosx_itrap0.png",self.resourcePath.."img/combat/itrap0.png")
		Location["combat/tosx_itrap0.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/tosx_itrap0a.png",self.resourcePath.."img/combat/itrap0a.png")
		Location["combat/tosx_itrap0a.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/tosx_itrap1.png",self.resourcePath.."img/combat/itrap1.png")
		Location["combat/tosx_itrap1.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/tosx_itrap1a.png",self.resourcePath.."img/combat/itrap1a.png")
		Location["combat/tosx_itrap1a.png"] = Point(-14,-4)
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_jungle_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_jungle_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Jungle Stalkers","tosx_Stalker1Mech", "tosx_Stalker2Mech", "tosx_Stalker3Mech", id = "tosx_JungleStalkers",}, "Jungle Stalkers", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers"):load()
end

return mod