local descriptiontext = "Wreathed in noxious smoke, these relics from an ancient war will choke the battlefield."

local mod = {
    id = "tosx_CorrodedGiants",
    name = "Corroded Giants",
    version = "0.02",
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
            Name = "tosx_mech_steam1",
            Default =           { PosX = -21, PosY = -5 },
            Animated =          { PosX = -21, PosY = -5, NumFrames = 4},--[ -37, -18 ]
            Broken =            { PosX = -17, PosY = 2 },
            Submerged =         { PosX = -20, PosY = 6 },
            SubmergedBroken =   { PosX = -17, PosY = 11 },
            Icon =              {},
        },
        {
            Name = "tosx_mech_steam2",
            Default =           { PosX = -24, PosY = -9 },
            Animated =          { PosX = -24, PosY = -9, NumFrames = 4, Frames = {1,2,3,0} },
            Broken =            { PosX = -17, PosY = 3 },
            Submerged =         { PosX = -18, PosY = 7 },
            SubmergedBroken =   { PosX = -15, PosY = 11 },
            Icon =              {},
        },
        {
            Name = "tosx_mech_steam3",
            Default =           { PosX = -25, PosY = -15 },
            Animated =          { PosX = -25, PosY = -15, NumFrames = 4},
            Broken =            { PosX = -17, PosY = 1 },
            Submerged =         { PosX = -25, PosY = -15 },
            SubmergedBroken =   { PosX = -15, PosY = 12 },
            Icon =              {},
        }
    )
    
    local palette = {
        id = self.id,
        name = "Corroded Grey",
        image = "img/units/player/tosx_mech_steam1.png",
        colorMap = {
        
            lights =         { 101, 255, 71 },
            main_highlight = { 122, 121, 108 },
            main_light =     { 70, 69, 56 },
            main_mid =       { 40, 39, 26 },
            main_dark =      { 20, 19, 6 },
            metal_light =    { 168, 168, 168 },
            metal_mid =      { 82, 82, 82 },
            metal_dark =     { 43, 43, 43 },
        }, 
    }
    modApi:addPalette(palette)
    
    modApi:appendAsset("img/weapons/tosx_weapon_winch.png",self.resourcePath.."img/weapons/tosx_weapon_winch.png")
    modApi:appendAsset("img/weapons/tosx_weapon_pressure.png",self.resourcePath.."img/weapons/tosx_weapon_pressure.png")
    modApi:appendAsset("img/weapons/tosx_weapon_clouds.png",self.resourcePath.."img/weapons/tosx_weapon_clouds.png")
    modApi:appendAsset("img/weapons/tosx_weapon_smoggy.png",self.resourcePath.."img/weapons/tosx_weapon_smoggy.png")
    
    modApi:appendAsset("img/effects/tosx_shotup_smokemissile.png",self.resourcePath.."img/effects/tosx_shotup_smokemissile.png")
    modApi:appendAsset("img/effects/vwt_smoke_move_D.png",self.resourcePath.."img/effects/smoke_move_D.png")
    modApi:appendAsset("img/effects/vwt_smoke_move_L.png",self.resourcePath.."img/effects/smoke_move_L.png")
    modApi:appendAsset("img/effects/vwt_smoke_move_R.png",self.resourcePath.."img/effects/smoke_move_R.png")
    modApi:appendAsset("img/effects/vwt_smoke_move_U.png",self.resourcePath.."img/effects/smoke_move_U.png")
        
    require(self.scriptPath.."pawns")
    require(self.scriptPath.."weapons")
    require(self.scriptPath.."passive")
    require(self.scriptPath.."animations")
    
    require(self.scriptPath .."achievements")
    if modApi.achievements:getProgress(self.id,"tosx_steam_secret") and --without this check, will error if no profile
    modApi.achievements:getProgress(self.id,"tosx_steam_secret").reward then
        require(self.scriptPath .."side_objectives")
    end
end

function mod:load(options, version)
    modApi:addSquad({"Corroded Giants","tosx_Steam1Mech", "tosx_Steam2Mech", "tosx_Steam3Mech", id = "tosx_CorrodedGiants",}, "Corroded Giants", descriptiontext, self.resourcePath .. "img/icons/squad_icon.png")
    
    require(self.scriptPath .."achievementTriggers"):load()
end

return mod