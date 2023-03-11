local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Impact",
	Personality = "Impact",
	Name = "Jai Chandra",
	Sex = SEX_MALE,
	Skill = "ImpactSkill",
	Voice = "/voice/henry",
}

local function clearMissionData(mission)
	mission.ImpactSkillPawns = {0,0,0,0}
	mission.ImpactSkillSpeeds = {0,0,0,0}
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Grav Anchor", "During the enemy turn, adjacent enemies cannot move away from Mech."))
	
	ImpactSkill = {}

	----- Grav Anchor -----
	function ImpactSkill:Stopping(p1)
		local mission = GetCurrentMission()
		if not mission then return end
		
		local effect = SkillEffect()
		local anybodythere = false

		-- init or grab data
		mission.ImpactSkillPawns = mission.ImpactSkillPawns or {0,0,0,0}
		mission.ImpactSkillSpeeds = mission.ImpactSkillSpeeds or {0,0,0,0}

		for i = 1,4 do -- Data table indices are 1-4
			local point = p1 + DIR_VECTORS[i-1] -- DIR_VECTORS indices are 0-3
			if (Board:IsValid(point) and Board:GetPawnTeam(point) == TEAM_ENEMY) and not (Board:GetPawn(point):IsFrozen() or _G[Board:GetPawn(point):GetType()].MoveSpeed == 0) then
				anybodythere = true
				mission.ImpactSkillPawns[i] = Board:GetPawn(point):GetId()
				mission.ImpactSkillSpeeds[i] = _G[Board:GetPawn(point):GetType()].MoveSpeed
				Board:GetPawn(mission.ImpactSkillPawns[i]):SetMoveSpeed(0)

				effect:AddSound("/weapons/swap")
				effect:AddBounce(point,4)
				effect:AddScript("Board:AddAlert(Point("..p1:GetString().."),'GRAV ANCHOR')")

				effect:AddScript(string.format([[
					local p = %s
					if Board:IsPawnSpace(p) then
						Board:Ping(p, GL_Color(%s, %s, %s))
					end]],
					point:GetString(), 102, 45, 145
				))
				--Trigger pilot dialogue
				if not IsTestMechScenario() then
					effect:AddScript([[
						local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
						modapiext.dialog:triggerRuledDialog("Pilot_Skill_Impact", cast)
					]])
				end

			end
		end
		if anybodythere == true then
			Board:AddEffect(effect)
		end
	end

	function ImpactSkill:Starting()
		local mission = GetCurrentMission()
		if not mission then return end
		-- init or grab data
		mission.ImpactSkillPawns = mission.ImpactSkillPawns or {0,0,0,0}
		mission.ImpactSkillSpeeds = mission.ImpactSkillSpeeds or {0,0,0,0}

		if mission.ImpactSkillPawns == nil then mission.ImpactSkillPawns = {0,0,0,0} end
		if mission.ImpactSkillSpeeds == nil then mission.ImpactSkillSpeeds = {0,0,0,0} end

		for i = 1,4 do
			if mission.ImpactSkillPawns[i] > 0 and mission.ImpactSkillSpeeds[i] > 0 then
				local pawn = Board:GetPawn(mission.ImpactSkillPawns[i])
				if pawn and not pawn:IsDead() then
					Board:GetPawn(mission.ImpactSkillPawns[i]):SetMoveSpeed(mission.ImpactSkillSpeeds[i])
				end
				mission.ImpactSkillPawns[i] = 0
				mission.ImpactSkillSpeeds[i] = 0
			end
		end
	end

end

function this:load()	
	modApi:addMissionStartHook(function(mission)
		clearMissionData(mission)
	end)

	modApi:addMissionNextPhaseCreatedHook(function(_, mission)
		clearMissionData(mission)
	end)

	modApi:addTestMechEnteredHook(function(mission)
		clearMissionData(mission)
	end)
	
	modApi:addNextTurnHook(function(mission)
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility(pilot.Skill) then			
				if Game:GetTeamTurn() == TEAM_PLAYER then			
					--Impact's grav ability resets
					if not Board:GetPawn(id):IsDead() then
						ImpactSkill:Starting()
						break
					end
				end

				if Game:GetTeamTurn() == TEAM_ENEMY then
					--Impact's grav ability traps foes
					if not Board:GetPawn(id):IsDead() then
						ImpactSkill:Stopping(Board:GetPawnSpace(id))
						break
					end
				end
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Impact", {
		Odds = 5,
		{ main = "Pilot_Skill_Impact" },
	})
end

return this