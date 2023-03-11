local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Titan",
	Personality = "Titan",
	Name = "Roland White",
	Sex = SEX_MALE,
	Skill = "TitanSkill",
	Voice = "/voice/abe",
}

---
-----------------------
--[[ Virtual functions that will treat virtual[point] as the overriding truth.
This way we know where pawns will be if they get pushed after moving/charging/teleporting
 virtual = -1 means that the skill has declared this point is being vacated
 virtual = id means that the skill has declared this point will have pawn [id] on it
 virtual = nil means treat point normally
--]]
local virtual = {}

local function vIsPawnSpace(point)
	index = p2idx (point) -- Can't use raw points for table indexes; they don't work properly
	if virtual[index] then
		if virtual[index] == -1 then return false end
		if virtual[index] then return true end
	end
	return Board:IsPawnSpace(point)
end
--[[
local function vIsBlocked(point)
	index = p2idx (point)
	if virtual[index] then
		if virtual[index] == -1 then return false end
		if virtual[index] then return true end
	end
	return Board:IsBlocked(point, PATH_PROJECTILE)
end
--]]
local function vGetPawn(point)
	index = p2idx (point)
	if virtual[index] then
		if virtual[index] ~= -1 then return Board:GetPawn(virtual[index]) end
	end
	return Board:GetPawn(point)
end
-----------------------

local function IterateEffects(effect)
	-- Create a record of pawns that won't be where they are now
	virtual = {}	
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if spaceDamage:IsMovement() then
			local point = spaceDamage:MoveStart()
			local point2 = spaceDamage:MoveEnd()
			if vIsPawnSpace(point) then
				local id = Board:GetPawn(point):GetId()
				virtual[p2idx(point)] = -1 --Space is now empty
				virtual[p2idx(point2)] = id -- Pawn "id" is now here
			end
		end
	end
	
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if	vIsPawnSpace(spaceDamage.loc) then
			local pawn = vGetPawn(spaceDamage.loc)
			
			if pawn:IsAbility(pilot.Skill) and not pawn:IsShield() and not pawn:IsFrozen() and not pawn:IsDead() then
			
				local minDmg = 1
				
				if _G[pawn:GetType()].Armor and		-- if our mech has natural armor
					not pawn:IsAcid() then			-- that is not broken by acid.					
					minDmg = 2						-- set threshold to 2, so it ends at 1 after armor
				end
				
				-- check what the damage is before returning a value
				local d = spaceDamage.iDamage
				if d >= minDmg and d ~= DAMAGE_DEATH and d ~= DAMAGE_ZERO then
					return pawn:GetId() -- Id of the pawn with skill, that's being damaged.
				end
			end
		end
	end
	return nil
end

-- local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	-- if not skillEffect then return end
	-- local ret = IterateEffects(skillEffect.effect)	
	-- if ret then
		-- skillEffect:AddScript("tosx_TitanGo("..ret..")")
	-- else
		-- ret = IterateEffects(skillEffect.q_effect)
		-- if ret then
			-- skillEffect:AddQueuedScript("tosx_TitanGo("..ret..")")
		-- end
	-- end
-- end

local onSkillEffectFinal = function(skillEffect)
	if not skillEffect then return end
	local ret = IterateEffects(skillEffect.effect)	
	if ret then
		skillEffect:AddScript("tosx_TitanGo("..ret..")")
	else
		ret = IterateEffects(skillEffect.q_effect)
		if ret then
			skillEffect:AddQueuedScript("tosx_TitanGo("..ret..")")
		end
	end
end
local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	if not skillEffect then return end
	onSkillEffectFinal(skillEffect)
end
local onSkillEffect2 = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	if not skillEffect then return end
	onSkillEffectFinal(skillEffect)
end

function tosx_TitanGo(id)
	local effect = SkillEffect()
	-- Have to add the shield through 2 layers of scripts to ensure the board has finished doing stuff
	effect:AddScript([[
		local fx = SkillEffect()
		local point = Board:GetPawnSpace(]]..id..[[)
		local damage = SpaceDamage(point,0)
		damage.iShield = EFFECT_CREATE
		fx:AddDamage(damage)
		Board:AddEffect(fx)
		]])
	Board:AddEffect(effect)
end
---

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Titan Armor", "Gain a shield after surviving an attack."))
	
	-- art, icons, animations
end

function this:load()	
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Titan", {
		Odds = 10,
		{ main = "Pilot_Skill_Titan" },
	})
end

return this