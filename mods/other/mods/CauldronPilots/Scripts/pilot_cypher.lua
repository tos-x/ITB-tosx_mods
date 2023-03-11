local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local pawnMove = require(path .."libs/pawnMoveSkill")
local moveskill = require(path .."libs/pilotSkill_move")

local pilot = {
	Id = "Pilot_Cypher",
	Personality = "Cypher",
	Name = "Karl Schraeder",
	Sex = SEX_MALE,
	Skill = "CypherSkill",
	Voice = "/voice/silica",
	Blacklist = {"Thick"},
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Adaptive Nanites", "Mech neutralizes Fire, Smoke, Frozen and A.C.I.D. effects on its tile."))
	
	-- art, icons, animations

	CypherSkill = {}
	
	moveskill.AddSkillEffect(pilot.Personality, CypherSkill)

	-- Adaptive Nanites
	function CypherSkill:GetSkillEffect(p1, p2)
		local mission = GetCurrentMission()
		if not mission then return end
		mission.CypherSkillTerrain = nil

		-- call the pawn's move skill
		mission.CypherSkillMoving = true
		local ret = pawnMove.GetSkillEffect(p1, p2)

		-- set skill variables, these do not need to be done before move since the location check is done in script
		--[[The reason for setting this via script is that
			otherwise, highlighting a move but not actually performing it
			will set the variables. The move can be right-click canceled
			without ever doing Undo Move (skipping its variable reset)--]]
		--LOG("Remove lava")
		if Board:IsTerrain(p2,TERRAIN_LAVA) then
			--mission.CypherSkillTerrain = 1
			ret:AddScript([[
				local mission = GetCurrentMission()
				if mission then
					mission.CypherSkillTerrain = 1
				end
			]])
		end
		-- clear variable after move finishes
		ret:AddScript([[
			local mission = GetCurrentMission()
			if mission then
				mission.CypherSkillMoving = nil
			end
		]])
		return ret
	end

	function CypherSkill:UndoMove(mission, pawn, oldPosition)
		if mission.CypherSkillTerrain then
			if mission.CypherSkillTerrain == 1 then
				Board:SetLava(oldPosition, true)
				--LOG("Remake lava")
			end
			CypherSkillTerrain = nil
		end
	end
	
	-- Manually override SetAcid so it doesn't affect him
	local oldInitializeBoardPawn = InitializeBoardPawn
	function InitializeBoardPawn()
		oldInitializeBoardPawn()

		-- doesn't matter what pawn we create here, we just need a Pawn userdata instance
		local pawn = PAWN_FACTORY:CreatePawn("PunchMech")

		local oldSetAcid = pawn.SetAcid
		BoardPawn.SetAcid = function(self, flag)
			Tests.AssertEquals("userdata", type(self), "Argument #0")
			if not flag or not self:IsAbility(pilot.Skill) then
				return oldSetAcid(self, flag)
			end			
		end
	end
end

function this:load()

	modApi:addMissionUpdateHook(function(mission, pawn, oldPosition)
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility(pilot.Skill) and not Board:GetPawn(id):IsDead() then
				local p = Board:GetPawnSpace(id)
				if Board:IsSmoke(p) then
					Board:SetSmoke(p, false, true)
				end
				if Board:GetPawn(id):IsFire() then
					local ret = SkillEffect()
					local damage = SpaceDamage(p)
					damage.iFire = EFFECT_REMOVE
					ret:AddDamage(damage)
					Board:AddEffect(ret)
				end
				if Board:GetPawn(id):IsFrozen() then
					Board:GetPawn(id):SetFrozen(false)
				end
			end
		end
	end)

	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		CypherSkill:UndoMove(mission, pawn, oldPosition)
	end)
	
	modapiext:addPawnIsAcidHook(function(mission, pawn, isAcid)
		local point = pawn:GetSpace()
		if pawn:IsAbility(pilot.Skill) and not pawn:IsDead() then
			if not mission.CypherSkillMoving or IsTestMechScenario() then
				if isAcid then
					if Board:GetTerrain(point) == TERRAIN_WATER then					
						Board:GetPawn(pawn:GetId()):SetSpace(Point(-1,-1))
						Board:GetPawn(pawn:GetId()):SetAcid(false)
						
						Board:SetAcid(point, false)
						Board:GetPawn(pawn:GetId()):SetSpace(point)					
						--LOG("Cypher acid water cleared C")
					else
						pawn:SetAcid(false)
						--LOG("Cypher no more acid D")
					end
				end
			end
		end
	end)
end

return this