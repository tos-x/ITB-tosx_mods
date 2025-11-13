local descriptiontext = "These fragile Mechs use teleporters to reposition Vek rather than engage them."

local mod = {
	id = "tosx_Labyrinth",
	name = "Labyrinth",
	version = "0.01",
	modApiVersion = "2.8.2",
	icon = "img/icons/mod_icon.png",	
	description = descriptiontext,
	dependencies = {
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
			Name = "tosx_mech_warp1",
			Default =           { PosX = -14, PosY = -9 },
			Animated =          { PosX = -14, PosY = -9, NumFrames = 4},--[ -37, -18 ]
			Broken =            { PosX = -12, PosY = 2 },
			Submerged =         { PosX = -15, PosY = 9 },
			SubmergedBroken =   { PosX = -11, PosY = 10 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_warp2",	
			Default =           { PosX = -13, PosY = 1 },
			Animated =          { PosX = -13, PosY = 1, NumFrames = 4, Frames = {1,2,3,0}},--desync squad up/down
			Broken =            { PosX = -12, PosY = 7 },
			Submerged =         { PosX = -13, PosY = 1 },
			SubmergedBroken =   { PosX = -12, PosY = 15 },
			Icon =              {},
		},
		{
			Name = "tosx_mech_warp3",
			Default =           { PosX = -22, PosY = -1 },
			Animated =          { PosX = -22, PosY = -1, NumFrames = 4, Frames = {0,3,2,1}},
			Broken =            { PosX = -21, PosY = 8 },
			Submerged =         { PosX = -14, PosY = 16 },
			SubmergedBroken =   { PosX = -14, PosY = 16 },
			Icon =              {},
		}
	)
	
	local palette = {
		id = self.id,
		name = "Labyrinth Midnight",
		image = "img/units/player/tosx_mech_warp1.png",
		colorMap = {
            
			lights =         { 190, 138, 253 },
            main_highlight = { 80, 98, 118 },
            main_light =     { 34, 40, 63 },
			main_mid =       { 28, 30, 34 },
            main_dark =      { 2, 9, 25 },
			metal_light =    { 132, 205, 213 },
			metal_mid =      { 59, 122, 128 },
			metal_dark =     { 34, 82, 84 },
		}, 
	}
	modApi:addPalette(palette)
	
	modApi:appendAsset("img/effects/tosx_swipe_purple.png",self.resourcePath.."img/effects/tosx_swipe_purple.png")
	modApi:appendAsset("img/effects/tosx_shotup_swapother.png",self.resourcePath.."img/effects/tosx_shotup_swapother.png")
	modApi:appendAsset("img/effects/tosx_warpin.png",self.resourcePath.."img/effects/tosx_warpin.png")
    modApi:copyAsset("img/combat/icons/icon_shield.png", "img/combat/icons/tosx_icon_shield.png")
        Location["combat/icons/tosx_icon_shield.png"] = Point(-10,9)
    
	modApi:appendAsset("img/weapons/tosx_weapon_prism.png",self.resourcePath.."img/weapons/tosx_weapon_prism.png")
	modApi:appendAsset("img/weapons/tosx_weapon_portals.png",self.resourcePath.."img/weapons/tosx_weapon_portals.png")
	modApi:appendAsset("img/weapons/tosx_weapon_longwarp.png",self.resourcePath.."img/weapons/tosx_weapon_longwarp.png")
		
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."animations")
	
	require(self.scriptPath .."achievements")
	if modApi.achievements:getProgress(self.id,"tosx_warp_secret") and --without this check, will error if no profile
	modApi.achievements:getProgress(self.id,"tosx_warp_secret").reward then
		require(self.scriptPath .."side_objectives")
	end
end

function mod:load(options, version)
	modApi:addSquad({"Labyrinth","tosx_Warp1Mech", "tosx_Warp2Mech", "tosx_Warp3Mech", id = "tosx_Labyrinth",}, "Labyrinth", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
	
	require(self.scriptPath .."achievementTriggers")
end

return mod