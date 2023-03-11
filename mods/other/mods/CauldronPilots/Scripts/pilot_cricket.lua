local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local pawnMove = require(path .."libs/pawnMoveSkill")
local moveskill = require(path .."libs/pilotSkill_move")

local pilot = {
	Id = "Pilot_Cricket",
	Personality = "Cricket",
	Name = "Kate Shreeve",
	Sex = SEX_FEMALE,
	Skill = "CricketSkill",
	Voice = "/voice/bethany",
}
	
function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Leap", "Mech leaps over tiles when moving in a line."))	
	
	-- art, icons, animations
	
	CricketSkill = {}
	
	moveskill.AddTargetArea(pilot.Personality, CricketSkill)
	moveskill.AddSkillEffect(pilot.Personality, CricketSkill)

-- local originalMove = {
	-- GetDescription = Move.GetDescription,
	-- GetTargetArea = Move.GetTargetArea,
	-- GetSkillEffect = Move.GetSkillEffect,
-- }
-- function Move:GetTargetArea(p1)
	-- local moveSkill = nil
	-- if Board:GetPawn(p1) then
		-- if Board:GetPawn(p1):GetPersonality() == pilot.Personality then
			-- moveSkill = CricketSkill
		-- end
	-- end

	-- if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
		-- return moveSkill:GetTargetArea(p1)
	-- end

	-- return originalMove.GetTargetArea(self, p1)
-- end

-- function Move:GetSkillEffect(p1, p2)
	-- local moveSkill = nil
	-- if Board:GetPawn(p1) then
		-- if Board:GetPawn(p1):GetPersonality() == pilot.Personality then
			-- moveSkill = CricketSkill
		-- end
	-- end
	
	-- if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
		-- return moveSkill:GetSkillEffect(p1, p2)
	-- end
	
	-- return originalMove.GetSkillEffect(self, p1, p2)
-- end

	----- Leap -----
	--- Default target area for the CricketSkillEffect
	local function cricketTargetArea(p1)
		-- start with vanilla move
		local ret = pawnMove.GetDefaultTargetArea(p1)
		local defaultSpaces = extract_table(ret)
		-- add any bonus spaces in each direction
		for dir = DIR_START, DIR_END do
			-- if provided, use their move speed logic
			for i = 1, Pawn:GetMoveSpeed() do
				local point = p1 + DIR_VECTORS[dir]*i
				-- if this point is invalid, all later points will also be invalid
				if not Board:IsValid(point) then break end
				-- point must be somewhere they can land and not already included
				if not Board:IsBlocked(point, Pawn:GetPathProf()) and not list_contains(defaultSpaces, point) then
					ret:push_back(point)
				end
			end
		end

		return ret
	end

	function CricketSkill:GetTargetArea(p1)
		-- it's hard to predict what a pawn may want for their bonus cricket movement
		-- if they replace GetTargetArea and do not have specific logic for us, do nothing
		if pawnMove.OverridesTargetArea() and not pawnMove.HasFunction("CricketTargetArea") then
			return pawnMove.GetTargetArea(p1)
		end

		-- call the pawn's override, or our default if no override
		return pawnMove.CallFunction("CricketTargetArea", cricketTargetArea, p1)
	end

	function CricketSkill:GetSkillEffect(p1, p2)
		-- if they did not move outside of regularly reachable area, do normal move
		local path = pawnMove.GetTargetArea(p1)
		if list_contains(extract_table(path), p2) then
			return pawnMove.GetSkillEffect(p1, p2)
		end

		-- leap move
		local ret = SkillEffect()
		ret:AddSound("/weapons/leap")
		local move = PointList()
		move:push_back(p1)
		move:push_back(p2)

		--Trigger pilot dialogue
		if not IsTestMechScenario() then
			ret:AddScript([[
				local cast = { main = ]]..Pawn:GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Pilot_Skill_Cricket", cast)
			]])
		end

		ret:AddLeap(move, 0.8)
		ret:AddSound("/impact/generic/mech")
		for dir = DIR_START, DIR_END do
			local damage = SpaceDamage(p2 + DIR_VECTORS[dir])
			damage.sAnimation = "airpush_"..dir
			ret:AddDamage(damage)
		end

		return ret
	end
end

function this:load()
	modapiext.dialog:addRuledDialog("Pilot_Skill_Cricket", {
		Odds = 5,
		{ main = "Pilot_Skill_Cricket" },
	})
end

return this