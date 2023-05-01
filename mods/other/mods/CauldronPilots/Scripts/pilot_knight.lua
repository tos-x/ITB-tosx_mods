local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Knight",
	Personality = "Knight",
	Name = "George Mormoth",
	Sex = SEX_MALE,
	Skill = "KnightSkill",
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

local function vIsBlocked(point)
	index = p2idx (point)
	if virtual[index] then
		if virtual[index] == -1 then return false end
		if virtual[index] then return true end
	end
	return Board:IsBlocked(point, PATH_PROJECTILE)
end

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
	
	local retpawn = {}
	retpawn.space = 0
	retpawn.pushamount = 0
	
	damagetaken = 0
	currenthp  = 0
	pacid = false
	pice = false
	pshield = false
	pfutureice = false
	pfutureshield = false
	parmor = false	
	
	
	for _, spaceDamage in ipairs(extract_table(effect)) do		
		local point1 = spaceDamage.loc
		if vIsPawnSpace(point1) then
			local pawn = vGetPawn(point1)
			if not pawn:IsGuarding() then
				if spaceDamage.iPush then
					if spaceDamage.iPush <= 3 then
						local point2 = spaceDamage.loc + DIR_VECTORS[(spaceDamage.iPush)]
						if vIsBlocked(point2) and Board:IsValid(point2) then
							if vIsPawnSpace(point1) then
								if pawn:IsAbility(pilot.Skill) and not pawn:IsDead() then
									-- This is our pawn; figure out everything happening to it that affects health
									damagetaken = damagetaken + spaceDamage.iDamage
									currenthp = pawn:GetHealth() -- Last value only; shouldn't matter
									retpawn.space = point1 -- Last value only; shouldn't matter
									retpawn.pushamount = retpawn.pushamount + 1
									if pawn:IsAcid() and spaceDamage.iAcid ~= EFFECT_REMOVE then
										pacid = true
									end
									if pawn:IsShield() and spaceDamage.iShield ~= EFFECT_REMOVE then
										pshield = true
									end
									if pawn:IsFrozen() and spaceDamage.iFrozen ~= EFFECT_REMOVE then
										pice = true
									end
									if spaceDamage.iFrozen == EFFECT_CREATE then
										pfutureice = true
									end
									if spaceDamage.iShield == EFFECT_CREATE then
										pfutureshield = true
									end
									if pawn:IsArmor() then
										parmor = true
									end
								end
							end
							if vIsPawnSpace(point2) then
								pawn = vGetPawn(point2)
								if pawn:IsAbility(pilot.Skill) and not pawn:IsDead() then
									currenthp = pawn:GetHealth() -- Last value only; shouldn't matter
									retpawn.space = point2 -- Last value only; shouldn't matter
									retpawn.pushamount = retpawn.pushamount + 1
									if pawn:IsAcid() then -- Could be getting removed by some other spacedamage; oh well
										pacid = true
									end
									if pawn:IsShield() then
										pshield = true
									end
									if pawn:IsFrozen() then
										pice = true
									end
									if pawn:IsArmor() then
										parmor = true
									end
								end
							end
						elseif not vIsBlocked(point2) and Board:IsValid(point2) then
							local id = vGetPawn(point1):GetId()
							virtual[p2idx(point1)] = -1 --Space is now empty
							virtual[p2idx(point2)] = id -- Pawn "id" is now here
						end
					end
				end
				
			end
		end
	end
	
	-- A frozen, shielded unit spends its shield first
	if pshield and damagetaken > 0  then
		damagetaken = 0
		pshield = false
	elseif pice and damagetaken > 0  then
		damagetaken = 0
		pice = false
	end
		
	if pacid and damagetaken > 0 then
		damagetaken = damagetaken * 2
	elseif parmor then
		damagetaken = damagetaken - 1
	end
		
	--Okay, this is the final non-push damage our unit is taking
	--Its final HP should end up at...
	local finalhp = math.max(currenthp - damagetaken, 0)
	
	--Also if ice or shield remains, or is being created, that will reduce bump and hence the repair
	--A remaining shield and a shield being created still just means one shield at this point
	--Each ice/shield only gives one bump damage off
	--LOG("pfutureshield:" .. tostring(pfutureshield) .. " pshield:" .. tostring(pshield) .. " pfutureice:" .. tostring(pfutureice) .. " pice:" .. tostring(pice))
	if pfutureshield or pshield then
		retpawn.pushamount = retpawn.pushamount - 1
	end
	if pfutureice or pice then
		retpawn.pushamount = retpawn.pushamount - 1
	end
	--LOG("hp:" .. currenthp .. " dmg:" .. damagetaken .. " finalhp:" .. finalhp .. " repair:" .. retpawn.pushamount)
	
	--Don't repair more than this amount; if bumping kills unit, don't want to bring it back with more health
	retpawn.pushamount = math.min(retpawn.pushamount,finalhp)
	--Send out pawn space and how much to repair
	if retpawn.pushamount > 0  then
		retpawn.pushamount = -1 * retpawn.pushamount
		return retpawn
	else
		return nil
	end
end
			

local onSkillEffectFinal = function(skillEffect)
	if not skillEffect then return end
	local retpawn = IterateEffects(skillEffect.effect)	
	if retpawn then
		--previewer:AddAnimation(retpawn.space, "PilotKnightHeal")--No longer works outside skillEffect/targetArea :(
		skillEffect:AddScript([[
			local fx = SkillEffect();
			local damage = SpaceDamage(Point(]]..retpawn.space:GetString()..[[),]]..retpawn.pushamount..[[);
			fx:AddDamage(damage);
			tosx_knightskip = true
			Board:AddEffect(fx)
			tosx_knightskip = nil
			]])
	else
		retpawn = IterateEffects(skillEffect.q_effect)
		if retpawn then			
			skillEffect:AddQueuedScript([[
				local fx = SkillEffect();
				local damage = SpaceDamage(Point(]]..retpawn.space:GetString()..[[),]]..retpawn.pushamount..[[);
				fx:AddDamage(damage);
				tosx_knightskip = true
				Board:AddEffect(fx)
				tosx_knightskip = nil
				]])
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
local function onBoardAddEffect(skillEffect)
	if not skillEffect or tosx_knightskip then return end
	onSkillEffectFinal(skillEffect)
end
---

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Steadfast", "Mech instantly Repairs bump damage."))
	
	-- art, icons, animations
	ANIMS.PilotKnightHeal = Animation:new{
		Image = "combat/icons/icon_heal_glow.png",
		PosX = -28,
		PosY = 10,
		Time = 1,
		Loop = true,
		NumFrames = 1,
	}

	modApi.events.onBoardAddEffect:subscribe(onBoardAddEffect)
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