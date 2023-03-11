local descriptiontext = "These advanced Mechs are constructed from liquid metal, which they can expend for powerful attacks."

local mod = {
	id = "tosx_Mercurials",
	name = "Mercurials",
	version = "0.03",
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
			Name = "tosx_mech_mercury1",
			Default =           { PosX = -24, PosY = -11 },
			Animated =          { PosX = -24, PosY = -11, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -18, PosY = 2 },
			Submerged =         { PosX = -19, PosY = 5 },
			SubmergedBroken =   { PosX = -15, PosY = 13 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_mercury2",			
			Default =           { PosX = -32, PosY = -16 },
			Animated =          { PosX = -32, PosY = -16, NumFrames = 4},
			Broken =            { PosX = -21, PosY = 3 },
			Submerged =         { PosX = -19, PosY = 6 },
			SubmergedBroken =   { PosX = -17, PosY = 9 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_mercury3",
			Default =           { PosX = -19, PosY = -11 },
			Animated =          { PosX = -19, PosY = -11, NumFrames = 4},
			Broken =            { PosX = -12, PosY = 7 },
			Submerged =         { PosX = -19, PosY = -11 },
			SubmergedBroken =   { PosX = -12, PosY = 15 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Mercurial Silver", 
		image = "img/units/player/tosx_mech_mercury1.png",
		colorMap = {
			lights =         { 189, 240, 50 },
			main_highlight = { 84, 84, 85 },
			main_light =     { 33, 32, 31 },
			main_mid =       { 9, 8, 6 },
			main_dark =      { 5, 5, 5 },
			metal_dark =     { 53, 55, 68 },
			metal_mid =      { 90, 95, 122 },
			metal_light =    { 171, 191, 230 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/weapons/tosx_weapon_metalskin.png",self.resourcePath.."img/weapons/tosx_weapon_metalskin.png")
	modApi:appendAsset("img/weapons/tosx_weapon_metalskin_b.png",self.resourcePath.."img/weapons/tosx_weapon_metalskin_b.png")
	modApi:appendAsset("img/weapons/tosx_weapon_spines.png",self.resourcePath.."img/weapons/tosx_weapon_spines.png")
	modApi:appendAsset("img/weapons/tosx_weapon_needle.png",self.resourcePath.."img/weapons/tosx_weapon_needle.png")
	modApi:appendAsset("img/effects/tosx_metal_spike_U.png",self.resourcePath.."img/effects/tosx_metal_spike_U.png")
	modApi:appendAsset("img/effects/tosx_metal_spike_R.png",self.resourcePath.."img/effects/tosx_metal_spike_R.png")
	modApi:appendAsset("img/effects/tosx_metal_spike_L.png",self.resourcePath.."img/effects/tosx_metal_spike_L.png")
	modApi:appendAsset("img/effects/tosx_metal_spike_D.png",self.resourcePath.."img/effects/tosx_metal_spike_D.png")
	
	modApi:appendAsset("img/effects/tosx_liquidmetal.png",mod.resourcePath.."img/effects/tosx_liquidmetal.png")
	
	modApi:appendAsset("img/effects/tosx_shotup_needle1.png",self.resourcePath.."img/effects/tosx_shotup_needle1.png")
	modApi:appendAsset("img/effects/tosx_shotup_needle2.png",self.resourcePath.."img/effects/tosx_shotup_needle2.png")
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_mercury_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_mercury_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Mercurials","tosx_Mercury1Mech", "tosx_Mercury2Mech", "tosx_Mercury3Mech", id = "tosx_Mercurials",}, "Mercurials", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers"):load()
end

return mod