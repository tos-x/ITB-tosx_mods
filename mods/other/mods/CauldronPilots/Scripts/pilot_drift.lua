local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local pawnMove = require(path .."libs/pawnMoveSkill")
local moveskill = require(path .."libs/pilotSkill_move")
local previewer = require(path .."libs/weaponPreview")
local trait = require(path .."libs/trait")

local pilot = {
	Id = "Pilot_Drift",
	Personality = "Drift",
	Name = "Alain Mormont",
	Sex = SEX_FEMALE,
	Skill = "DriftSkill",
	Voice = "/voice/lily",
}

local function clearMissionData(mission)
	mission.DriftReduction = 0
	mission.DriftUpcomingReduction = 0	
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Drift Step", "Mech can move up to 2 extra tiles, but next turn's movement is reduced by that amount."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_drift.png",mod.resourcePath.."img/effects/pilot_drift.png")
	modApi:appendAsset("img/combat/icons/pilot_drift_1_glowa.png",mod.resourcePath.."img/combat/icons/pilot_drift_1_glowa.png")
	modApi:appendAsset("img/combat/icons/pilot_drift_2_glowa.png",mod.resourcePath.."img/combat/icons/pilot_drift_2_glowa.png")
		
	modApi:appendAsset("img/combat/icons/pilot_drift_1_glow.png",mod.resourcePath.."img/combat/icons/pilot_drift_1_glow.png")
		Location["combat/icons/pilot_drift_1_glow.png"] = Point(-28,10)
	modApi:appendAsset("img/combat/icons/pilot_drift_2_glow.png",mod.resourcePath.."img/combat/icons/pilot_drift_2_glow.png")
		Location["combat/icons/pilot_drift_2_glow.png"] = Point(-28,10)
		
	ANIMS.PilotDriftPulse = Animation:new{
		Image = "effects/pilot_drift.png",
		NumFrames = 8,
		Time = 0.02,
		PosX = -33,
		PosY = -14
	}

	ANIMS.PilotDriftTile1 = Animation:new{
		Image = "combat/icons/pilot_drift_1_glowa.png",
		PosX = -28,
		PosY = 10,
		Time = 0.15,
		Loop = true,
		NumFrames = 6
	}

	ANIMS.PilotDriftTile2 = ANIMS.PilotDriftTile1:new{
		Image = "combat/icons/pilot_drift_2_glowa.png"
	}

	ANIMS.PilotDriftTile1static = Animation:new{
		Image = "combat/icons/pilot_drift_1.png",
		PosX = -28,
		PosY = 10,
		Time = 1,
		Loop = true,
		NumFrames = 1
	}

	ANIMS.PilotDriftTile2static = ANIMS.PilotDriftTile1static:new{
		Image = "combat/icons/pilot_drift_2.png"
	}

	DriftSkill = {}
	
	moveskill.AddTargetArea(pilot.Personality, DriftSkill)
	moveskill.AddSkillEffect(pilot.Personality, DriftSkill)

	----- Drift Step -----
	function DriftSkill:GetTargetArea(p1)
		-- weapon preview does not work properly if within a skill, you call another skill's GetTargetArea or GetSkillEffect
		-- additionally, this skill needs the ret parameter on GetSkillEffect and the move parameter on GetTarget area to reduce hacks
		if not pawnMove.IsTargetAreaExt() or not pawnMove.IsSkillEffectExt() then
			return pawnMove.GetTargetArea(p1)
		end

		local mission = GetCurrentMission()
		if not mission then return end
		mission.DriftReduction = mission.DriftReduction or 0

	  -- get the pawn's current move speed and increase or decrease
		local moveSpeed = Pawn:GetMoveSpeed()
		if mission.DriftReduction == 0 then
		moveSpeed = moveSpeed + 2
		else
			moveSpeed = moveSpeed - mission.DriftReduction
		end
	  -- call the pawns's move skill, or vanilla
		return pawnMove.GetTargetArea(p1, moveSpeed)
	end

	function DriftSkill:GetSkillEffect(p1, p2)
		-- see comment in GetTargetArea
		if not pawnMove.IsTargetAreaExt() or not pawnMove.IsSkillEffectExt() then
			return pawnMove.GetSkillEffect(p1, p2)
		end

		local mission = GetCurrentMission()
		if not mission then return end
		mission.DriftReduction = mission.DriftReduction or 0

		local ret = SkillEffect()
		local move = Pawn:GetMoveSpeed()
		local path = pawnMove.GetTargetArea(p1, move)
		if not list_contains(extract_table(path), p2) then
			damage = SpaceDamage(p1,0)
			damage.sAnimation = "PilotDriftPulse"
			ret:AddDamage(damage)
			ret:AddSound("/weapons/swap")

			--This adds the glowing box
			ret:AddScript(string.format([[
				local p = %s
				if Board:IsPawnSpace(p) then
					Board:Ping(p, GL_Color(%s, %s, %s))
				end]],
				p1:GetString(), 247, 148, 29
			))
			ret:AddDelay(0.05)

			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Drift", cast)
				]])
			end

			--[[The reason for setting this via script is that
				otherwise, highlighting a move but not actually performing it
				will set the variables. The move can be right-click canceled
				without ever doing Undo Move (skipping its variable reset)--]]

			path = pawnMove.GetTargetArea(p1, move + 1)
			if not list_contains(extract_table(path), p2) then
				ret:AddScript([[
					local mission = GetCurrentMission()
					if mission then
						mission.DriftUpcomingReduction = 2
					end
				]])
				previewer:AddAnimation(p2, "PilotDriftTile2")
			else
				ret:AddScript([[
					local mission = GetCurrentMission()
					if mission then
					  mission.DriftUpcomingReduction = 1
					end
				]])
				previewer:AddAnimation(p2, "PilotDriftTile1")
			end

		end
		--LOG("Drift " .. mission.DriftUpcomingReduction)
		pawnMove.GetSkillEffect(p1, p2, ret)
		return ret
	end

	function DriftSkill:UndoMove(mission, pawn, oldPosition)
		local mission = GetCurrentMission()
		if not mission then return end
		if not pawn:IsAbility(pilot.Skill) then return end
		mission.DriftUpcomingReduction = 0
	end

end

function this:load()
	modApi:addNextTurnHook(function(mission)
		mission.DriftUpcomingReduction = mission.DriftUpcomingReduction or 0
		if Game:GetTeamTurn() == TEAM_PLAYER then
			--Drift's reduction
			mission.DriftReduction = mission.DriftUpcomingReduction
			mission.DriftUpcomingReduction = 0
			
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				trait:update(Board:GetPawnSpace(id))
			end
		end
	end)
	
	modApi:addMissionStartHook(function(mission)
		clearMissionData(mission)
	end)

	modApi:addMissionNextPhaseCreatedHook(function(_, mission)
		clearMissionData(mission)
	end)
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		DriftSkill:UndoMove(mission, pawn, oldPosition)
	end)

	modApi:addTestMechEnteredHook(function(mission)
		clearMissionData(mission)
	end)
			
	modapiext.dialog:addRuledDialog("Pilot_Skill_Drift", {
		Odds = 5,
		{ main = "Pilot_Skill_Drift" },
	})
end

return this