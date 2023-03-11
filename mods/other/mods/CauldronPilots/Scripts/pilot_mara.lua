local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local pawnMove = require(path .."libs/pawnMoveSkill")
local moveskill = require(path .."libs/pilotSkill_move")
local trait = require(path .."libs/trait")

local pilot = {
	Id = "Pilot_Mara",
	Personality = "Mara",
	Name = "Marika Prochazka",
	Sex = SEX_FEMALE,
	Skill = "MaraSkill",
	Voice = "/voice/lily",
}

local function clearMissionData(mission)
	mission.MaraSkillUsed = nil
	mission.MaraSkillUsedBeforeMove = nil
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Improbable Escape", "Once per mission, Mech survives death with 1 health."))
	
	-- art, icons, animations
	ANIMS.PilotMaraPoof = Animation:new{
		Image = "effects/explo_artillery0.png",
		NumFrames = 10,
		Time = 0.075,
		PosX = -20,
		PosY = 8,
	}

	MaraSkill = {}
	
	moveskill.AddSkillEffect(pilot.Personality, MaraSkill)

	-- Improbable Escape
	function MaraSkill:GetSkillEffect(p1, p2)
		local mission = GetCurrentMission()
		if not mission then return end

		mission.MaraSkillUsedBeforeMove = mission.MaraSkillUsed
		return pawnMove.GetSkillEffect(p1, p2)
	end

	function MaraSkill:UndoMove(mission, pawn, oldPosition)
		mission.MaraSkillUsed = mission.MaraSkillUsedBeforeMove
	end

	function MaraSkill:Escape(id)
		local effect = SkillEffect()
		effect:AddDelay(0.2)
		effect:AddScript([[
			SuppressDialog(1200,"Mech_Repaired")
			SuppressDialog(1200,"Mech_LowHealth")
			SuppressDialog(2400,"Death_Revived")
		]])
		effect:AddScript("MaraSkill:Escape2("..id..")")
		Board:AddEffect(effect)
		-- Call a second skill so that it can grab the pawn position AFTER the delay
		-- Pawn may move due to push or something as it dies
		-- Still want to suppress dialogs up front
		-- Not sure why normal dialogs go through if dying on a hole???
	end

	function MaraSkill:Escape2(id)
		local mission = GetCurrentMission()
		if not mission then return end
		local effect = SkillEffect()
		local p1 = Board:GetPawnSpace(id)

		if Board:GetTerrain(p1) == TERRAIN_HOLE and not Board:GetPawn(id):IsFlying() then
			--LOG("No escape!")
		else
			local damage = SpaceDamage(p1,-1)
			damage.sAnimation = "PilotMaraPoof"
			damage.sSound = "/ui/map/flyin_rewards"

			effect:AddDamage(damage)
			effect:AddScript("Board:AddAlert(Point("..p1:GetString().."),'IMPROBABLE ESCAPE')")
			effect:AddDelay(0.5)
			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				--LOG("mara pawn id "..pawn:GetId())
				effect:AddScript([[
					local cast = { main = ]]..id..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Mara", cast)
				]])
			end

			Board:AddEffect(effect)
			mission.MaraSkillUsed = true
			trait:update(p1)
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
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		MaraSkill:UndoMove(mission, pawn, oldPosition)
	end)

	modApi:addTestMechEnteredHook(function(mission)
		clearMissionData(mission)
	end)
	
	modapiext:addPawnKilledHook(function(mission, pawn)
		if pawn:IsAbility(pilot.Skill) and not mission.MaraSkillUsed then
			--LOG("Mara died on " .. point:GetString())
			MaraSkill:Escape(pawn:GetId())
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Mara", {
		Odds = 20,
		{ main = "Pilot_Skill_Mara" },
	})
end

return this