------------------------------------------------------------------------------
-- Sprite Loader Library
-- v1.0
-- https://github.com/KnightMiner/ITB-KnightUtils/blob/master/libs/sprites.lua
------------------------------------------------------------------------------
-- Contains helpers to load sprites and create animations
------------------------------------------------------------------------------
local sprites = {}
local mod = mod_loader.mods[modApi.currentMod]

--[[--
  Adds a sprite to the game

  @param path      Base sprite path
  @param filename  File to add
]]
function sprites.addSprite(path, filename)
  modApi:appendAsset(
    string.format("img/%s/%s.png", path, filename),
    string.format("%simg/%s/%s.png", mod.resourcePath, path, filename)
  )
end

--[[--
  Adds sprites for an achievement, adding both unlocked and greyed out

  @param name        Achievement base filename
  @param objectives  Optional list of objectives images to load, for use with GetImg
]]
function sprites.addAchievement(name, objectives)
  sprites.addSprite("achievements", name)
  sprites.addSprite("achievements", name .. "_gray")
  -- add any extra objective images requested
  if objectives then
    for _, objective in pairs(objectives) do
      sprites.addSprite("achievements", name .. "_" .. objective)
    end
  end
end

--[[--
  Converts a name into a path to a mech sprite

  @param name  Mech sprite name
  @return  Sprite path
]]
local function spritePath(path, name)
  return string.format("%s/%s.png", path, name)
end

--[[--
  Adds a sprite animations

  @param path      Base sprite path
  @param name      Animation name and filename
  @param settings  Animation settings, such as positions and frametime
]]
function sprites.addAnimation(path, name, settings)
  sprites.addSprite(path, name)
  settings = settings or {}
  settings.Image = spritePath(path, name)

  -- base animation is passed in settings
  local base = settings.Base or "Animation"
  settings.Base = nil

  -- create the animation
  ANIMS[name] = ANIMS[base]:new(settings)
end

--[[
  Adds the specific animation for a unit

  @param path        Base folder for the unit
  @param base        Base animation object
  @param name        Mech name
  @param key         Key in object containing animation data
  @param suffix      Suffix for this animation type
  @param fileSuffix  Suffix used in the filepath. If unset, defaults to suffix
]]
local function addUnitAnim(path, base, name, object, suffix, fileSuffix)
  if object then
    -- default fileSuffix to the animation suffix
    fileSuffix = fileSuffix or suffix

    -- add the sprite to the resource list
    local filename = name .. fileSuffix
    sprites.addSprite(path, filename)

    -- add the mech animation to the animation list
    object.Image = spritePath(path, filename)
    ANIMS[name..suffix] = ANIMS[base]:new(object);
  end
end

--- Resource paths for each unit type
local PATHS = {
  mech    = "units/player",
  mission = "units/mission",
  enemy   = "units/aliens",
  bot     = "units/snowbots"
}

--- Base animation for each unit type
local BASES = {
  mech    = "MechUnit",
  mission = "BaseUnit",
  enemy   = "EnemyUnit",
  bot     = "BaseUnit"
}

--- Bases for UI icons for each unit type
local ICON_BASES = {
  mech    = "MechIcon",
  mission = "SingleImage"
}

--[[--
  Adds a list of resources to the game

  @param group   varargs parameter of all mechs to add
  @param objects Animation datas to add
]]
local function addUnitAnims(group, objects)
  local path = PATHS[group]
  local base = BASES[group]
  local iconBase = ICON_BASES[group]

  -- loop through all passed parameters
  for _, object in pairs(objects) do
    local name = object.Name

    -- these types are pretty uniform
    addUnitAnim(path, base, name, object.Default,         ""                     )
    addUnitAnim(path, base, name, object.Animated,        "a",        "_a"       )
    addUnitAnim(path, base, name, object.Broken,          "_broken"              )
    addUnitAnim(path, base, name, object.Death,           "d",        "_death"   )
    addUnitAnim(path, base, name, object.Submerged,       "w",        "_w"       )
    addUnitAnim(path, base, name, object.SubmergedBroken, "w_broken", "_w_broken")
    addUnitAnim(path, base, name, object.Disabled,        "off",      "_off"     )

    -- emerge has a different base
    addUnitAnim(path, "BaseEmerge", name, object.Emerge,  "e",        "_emerge"  )

    -- if we have a base icon, try icon
    if iconBase ~= nil then
      addUnitAnim(path, iconBase, name, object.Icon, "_ns")
    end

    -- mechs have the extra hanger sprite
    if group == "mech" and not object.NoHanger then
      sprites.addSprite(path, name .. "_h")
    end
  end
end

--[[--
  Adds a list of mech sprites and animations to the game

  @param sprites  varargs parameter of all mechs to add
]]
function sprites.addMechs(...)
  addUnitAnims("mech", {...})
end

--[[--
  Adds a list of mission unit sprites and animations to the game

  @param sprites  varargs parameter of all mission units to add
]]
function sprites.addMissionUnits(...)
  addUnitAnims("mission", {...})
end

--[[--
  Adds a list of enemy unit sprites and animations to the game

  @param sprites  varargs parameter of all enemies to add
]]
function sprites.addEnemyUnits(...)
  addUnitAnims("enemy", {...})
end

--[[--
  Adds a list of bot unit sprites and animations to the game

  @param sprites  varargs parameter of all bots to add
]]
function sprites.addBotUnits(...)
  addUnitAnims("bot", {...})
end

return sprites
