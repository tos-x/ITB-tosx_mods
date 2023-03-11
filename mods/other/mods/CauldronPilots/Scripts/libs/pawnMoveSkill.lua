------------------------------------------------------------------------------------
-- Pawn Move Skill Library
-- v1.3
-- https://github.com/KnightMiner/ITB-KnightUtils/blob/master/libs/pawnMoveSkill.lua
------------------------------------------------------------------------------------
-- Contains helpers to make pilot skills compatible with pawn move skills
------------------------------------------------------------------------------------

--- Library export
local pawnMove = {}


---------------------
-- general helpers --
---------------------

-- copies all data from one damage list to another
-- TODO: switch to modloader functions once the PR is merged
local function appendDamageList(dest, src)
  local size = src:size()
  for i = 1, size do
    dest:push_back(src:index(i))
  end
end


------------------
-- default move --
------------------

--- Recreate default move skill as the modloader one is not safe to extend, between extensions such as modApiExt and modloader patches
--- This extra code causes the weapon ID in the lib to be the inner move skill, so as a result any calls in the outer skill break
local defaultMove = Skill:new{}

--[[--
  Implementation of a default move effect

  @param ret     Skill effect instance
  @param p1      Pawn location
  @param p2      Move destination
  @return  Skill effect instance
]]
function pawnMove.MovePawn(ret, p1, p2)
  if Pawn:IsJumper() then
    local plist = PointList()
    plist:push_back(p1)
    plist:push_back(p2)
    ret:AddLeap(plist, FULL_DELAY)
  elseif Pawn:IsTeleporter() then
    ret:AddTeleport(p1, p2, FULL_DELAY)
  else
    ret:AddMove(Board:GetPath(p1, p2, Pawn:GetPathProf()), FULL_DELAY)
  end
  return ret
end

--[[--
  Custom GetTargetArea supporting a variable move speed

  @param p1    Pawn location
  @param move  Pawn move speed, defaults to Pawn:GetMoveSpeed()
  @return  Target area for this function
]]
function defaultMove:GetTargetAreaExt(p1, move)
  local move = move or Pawn:GetMoveSpeed()
  return Board:GetReachable(p1, move, Pawn:GetPathProf())
end

-- implement vanilla function so you can extend defaultMove
function defaultMove:GetTargetArea(p1)
  return self:GetTargetAreaExt(p1)
end

--[[--
  Default logic for moving to save effort implementing

  @param p1    Pawn location
  @param p2    Target location
  @return  SkillEffect for this action
]]
function defaultMove:GetSkillEffect(p1, p2)
  -- if the move overrides GetSkillEffectExt, use that over default logic
  -- this is for backwards compat with old versions of this lib, newer versions will happily append GetSkillEffect
  if self.GetSkillEffectExt ~= nil then
    return self:GetSkillEffectExt(p1, p2)
  end

  -- default implementation
  local ret = SkillEffect()
  pawnMove.MovePawn(ret, p1, p2)
  return ret
end

-- functions to check if the extended move skill properly extends
-- by making this part of defaultMove which can be extended, we ensure that different versions of this lib can work together
-- this will check if they match the defaultMove from their copy of the library

-- returns true if GetTargetAreaExt will properly support the move parameter
function defaultMove:IsTargetAreaExt()
  -- support extended target area as long as they did not override GetTargetArea without changing GetTargetAreaExt
  return self.GetTargetArea == defaultMove.GetTargetArea or self.GetTargetAreaExt ~= defaultMove.GetTargetAreaExt
end

-- returns true if GetTargetArea is not using default logic
function defaultMove:OverridesTargetArea()
  return self.GetTargetAreaExt ~= defaultMove.GetTargetAreaExt or self.GetTargetArea ~= defaultMove.GetTargetArea
end

-- returns true if GetSkillEffect is not using default logic
function defaultMove:OverridesSkillEffect()
  return self.GetSkillEffect ~= defaultMove.GetSkillEffect
end

-- returns a skill that extends the default move skill
-- note that when extending, you should override GetTargetAreaExt instead of GetTargetArea
function pawnMove:ExtendDefaultMove(fields)
  return defaultMove:new(fields)
end

--[[--
  This function is simply a conveinent and safe way to call the vanilla Move:GetTargetArea

  @param p1   Starting position for the pawn
  @param move  Move speed, if unset defaults to Pawn:GetMoveSpeed()
  @return  PointList of valid move targets
]]
function pawnMove.GetDefaultTargetArea(p1, move)
  return defaultMove:GetTargetAreaExt(p1, move)
end

--[[--
  This function is simply a conveinent and safe way to call vanilla Move:GetSkillEffect

  @param p1   Starting position for the pawn
  @param p2   Target position for the pawn
  @param ret  Skill effect instance to build upon, if unset creates a new one
  @param skipPilotSkills  if true, does not add logic for handling Web_Vek and Adjacent_Heal skills
  @return  SkillEffect for this action
]]
function pawnMove.GetDefaultSkillEffect(p1, p2, ret)
  local ret = ret or SkillEffect()
  pawnMove.MovePawn(ret, p1, p2)
  return ret
end


----------------------------
-- extending move helpers --
----------------------------

--[[
  Gets the move skill from the current pawn

  @return  Pawn's move skill, or nil if missing
]]
function pawnMove.GetMoveSkill()
  local moveSkill = _G[Pawn:GetType()].MoveSkill
	if type(moveSkill) == 'string' then
		moveSkill = _G[moveSkill]
	end
  return moveSkill
end

--[[--
  Checks if the pawns overrides the given move function or has the given custom function

  @param name       Name of the function to check for
  @return true if the function exists and is overridden or if no move skill is set
]]
function pawnMove.HasFunction(name)
  local moveSkill = pawnMove.GetMoveSkill()
  return moveSkill ~= nil and moveSkill[name] ~= nil
end

--[[--
  Calls the given custom move function if present. If missing, calls default.
  You should generally call either HasTargetFunction() or HasEffectFunction() first to back out if not compatible

  @param name     Function to try calling
  @param default  If a function, then the function to use if the named function is missing
                  If not a function, value to return if the named function is missing
]]
function pawnMove.CallSkillFunction(moveSkill, name, default, ...)
  -- move skill overrides this? use their logic
  if moveSkill ~= nil and moveSkill[name] ~= nil then
    return moveSkill[name](moveSkill, ...)
  end

  -- if given a function, call it with the parameters
  if type(default) == "function" then
    return default(...)
  end

  -- if not a function, return default as a value
  return default
end

--[[--
  Calls the given custom move function if present. If missing, calls default.
  You should generally call either HasTargetFunction() or HasEffectFunction() first to back out if not compatible

  @param name     Function to try calling
  @param default  If a function, then the function to use if the named function is missing
                  If not a function, value to return if the named function is missing
]]
function pawnMove.CallFunction(name, default, ...)
  return pawnMove.CallSkillFunction(pawnMove.GetMoveSkill(), name, default, ...)
end


----------------------------
-- actual extension logic --
----------------------------

--[[--
  Gets the target area for the current pawn's move skill.
  Will try the extended version, the regular, then default to vanilla logic
  If you need to use the move parameter, you should call IsTargetAreaExt() first to verify its available

  @param point  Pawn Location
  @param move   Pawn move speed, if unset uses Pawn:GetMoveSpeed()
  @param moveSkill  known move skill instance, if nil fetches it from the pawn data
  @return  PointList of move target area
]]
function pawnMove.GetTargetArea(point, move, moveSkill)
  moveSkill = moveSkill or pawnMove.GetMoveSkill()
  if moveSkill ~= nil then
    -- if they extend the default move skill, use that logic
    -- provide them the option to say its not overridden to help with bad overrides
    if moveSkill.GetTargetAreaExt ~= nil and pawnMove.CallSkillFunction(moveSkill, "IsTargetAreaExt", true) then
      return moveSkill:GetTargetAreaExt(point, move)
    end
    -- fallback to the default target area, unfortunately move speed is ignored here
    if moveSkill.GetTargetArea ~= nil then
      -- TODO: consider a modloader event to increase move speed using Pawn:GetMoveSpeed(),can set a local var here which the event listener uses
      return moveSkill:GetTargetArea(point)
    end
  end
  -- fallback if they lack the function or lack the custom move skill entirely
  return pawnMove.GetDefaultTargetArea(point, move)
end

--[[--
  Gets the move skill effect for the relevant pawn move skill, appending it to the passed skill effect if passed
  Will *not* apply Adjacent_Heal or Web_Vek vanilla skills, if you need those call Move.DoPostMoveEffects(ret, p1, p2)

  @param p1         Pawn location
  @param p2         Target location
  @param ret        SkillEffect instance. If provided, appends skill effect to end
  @param moveSkill  known move skill instance, if nil fetches it from the pawn data
  @return SkillEffect instance
]]
function pawnMove.GetSkillEffect(p1, p2, ret, moveSkill)
  moveSkill = moveSkill or pawnMove.GetMoveSkill()
  -- if they have a custom skill effect, call their logic and append it to the passed skill effect
  if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
    local skillEffect = moveSkill:GetSkillEffect(p1, p2)
    if ret == nil then
      return skillEffect
    else
      -- if given an existing skill effect, append to that instead of replacing entirely
      appendDamageList(ret.effect, skillEffect.effect)
      appendDamageList(ret.q_effect, skillEffect.q_effect)
      return ret
    end
  end
  -- fallback if they lack the function or lack the custom move skill entirely
  return pawnMove.GetDefaultSkillEffect(p1, p2, ret)
end


----------------------------------
-- check if skills are modified --
----------------------------------

--[[--
  Checks if the pawn has a move skill that overriddes GetTargetArea

  @param moveSkill  known move skill instance, if nil fetches it from the pawn data
  @return  True if the pawn overrides GetTargetArea
]]
function pawnMove.OverridesTargetArea(moveSkill)
  moveSkill = moveSkill or pawnMove.GetMoveSkill()
  -- if they implement OverridesTargetArea, trust them to tell us if it changed
  -- if not implemented, best we can do is check if they have a non-default GetTargetArea function, will not work for string skills (waiting on a modApiExt change)
  return moveSkill ~= nil and pawnMove.CallSkillFunction(moveSkill, "OverridesTargetArea", pawnMove.GetTargetArea ~= nil)
end

--[[--
  Checks if the pawn has a move skill that overriddes GetSkillEffect

  @param moveSkill  known move skill instance, if nil fetches it from the pawn data
  @return  True if the pawn overrides GetSkillEffect
]]
function pawnMove.OverridesSkillEffect(moveSkill)
  moveSkill = moveSkill or pawnMove.GetMoveSkill()
  -- if they implement OverridesSkillEffect, trust them to tell us if it changed
  -- if not implemented, best we can do is check if they have a non-default GetTargetArea function, will not work for string skills (waiting on a modApiExt change)
  return moveSkill ~= nil and pawnMove.CallSkillFunction(moveSkill, "OverridesSkillEffect", pawnMove.GetSkillEffect ~= nil)
end

--[[--
  Checks if pawnMove.GetTargetArea can be called safely and with the extra parameters.

  @param moveSkill  known move skill instance, if nil fetches it from the pawn data
  @return true if the pawn has no move skill (default extended logic) or has a custom extended logic
]]
function pawnMove.IsTargetAreaExt(moveSkill)
  moveSkill = moveSkill or pawnMove.GetMoveSkill()
  -- no move skill? we can use extended by nature of fallback
  if moveSkill == nil then
    return true
  end
  -- if they implement a function telling us its extended, trust their function, its possible a bad override makes this false despite having the function
  if moveSkill.IsTargetAreaExt ~= nil then
    return moveSkill:IsTargetAreaExt()
  end
  -- if they lack a boolean function telling us it overrides, assume them having the function means it works
  -- alternatively, if they lack the function but do not override target area, that is fine too
  return moveSkill.GetTargetAreaExt ~= nil or not pawnMove.OverridesTargetArea(moveSkill)
end

--[[--
  Checks if pawnMove.GetSkillEffect can be called safely and with the extra parameters.

  @return true if the pawn has no move skill (default extended logic) or has a custom extended logic
  @deprecated  New implementation of pawnMove.GetSkillEffect does not require the skill to add the return parameter, so this always returns true
]]
function pawnMove.IsSkillEffectExt()
  return true
end

return pawnMove