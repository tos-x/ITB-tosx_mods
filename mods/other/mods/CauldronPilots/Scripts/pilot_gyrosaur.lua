local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Gyrosaur",
	Personality = "Gyrosaur",
	Name = "Athena",
	Sex = SEX_FEMALE,
	Skill = "GyrosaurSkill",
	Voice = "/voice/lily",
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

	local ret = {}
	i = 0
	--[[
		go through all effects and queued effects in the skilleffect,
		and check each damage location for your pilot.
		only checking p2 is not going to account for all damage.
	--]]
	for _, spaceDamage in ipairs(extract_table(effect)) do		
		local point1 = spaceDamage.loc
		if vIsPawnSpace(point1) then
			local pawn = vGetPawn(point1) -- The pawn that's moving
			if not pawn:IsGuarding() then
				if spaceDamage.iPush then
					if spaceDamage.iPush <= 3 then
						local point2 = spaceDamage.loc + DIR_VECTORS[(spaceDamage.iPush)]
						
						if vIsPawnSpace(point2) then
							local pawn2 = vGetPawn(point2)
							if pawn2:IsAbility(pilot.Skill) and Board:GetPawnTeam(pawn:GetSpace()) ~= TEAM_PLAYER then
								i = i+1
								ret[i] = point1
								-- Space of the pawn BUMPING INTO the pawn with the skill.
							elseif pawn:IsAbility(pilot.Skill) and Board:GetPawnTeam(pawn2:GetSpace()) ~= TEAM_PLAYER then
								i = i+1
								ret[i] = point2
								-- Space of the pawn being BUMPED INTO BY the pawn with the skill.
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
	if i > 0 then return ret end
	return nil
end

local onSkillEffectFinal = function(skillEffect)
	if not skillEffect then return end
	local ret = IterateEffects(skillEffect.effect)	
	if ret then
		for i = 1, #ret do
			skillEffect:AddScript([[
				local fx = SkillEffect();
				local damage = SpaceDamage(Point(]]..ret[i]:GetString()..[[),1);
				fx:AddDamage(damage);
				tosx_gyroskip = true
				Board:AddEffect(fx)
				tosx_gyroskip = nil
				]])
			end
	else
		ret = IterateEffects(skillEffect.q_effect)
		if ret then
			for i = 1, #ret do
				skillEffect:AddQueuedScript([[
					local fx = SkillEffect();
					local damage = SpaceDamage(Point(]]..ret[i]:GetString()..[[),1);
					fx:AddDamage(damage);
					tosx_gyroskip = true
					Board:AddEffect(fx)
					tosx_gyroskip = nil
					]])
			end
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
	if not skillEffect or tosx_gyroskip then return end
	onSkillEffectFinal(skillEffect)
end
---

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Ricochet", "Deals additional damage to enemies that bump Mech."))
	
	-- art, icons, animations
	
	modApi.events.onBoardAddEffect:subscribe(onBoardAddEffect)
end

function this:load()	
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
end

return this