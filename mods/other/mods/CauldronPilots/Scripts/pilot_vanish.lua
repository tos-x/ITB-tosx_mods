local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local pawnMove = require(path .."libs/pawnMoveSkill")
local moveskill = require(path .."libs/pilotSkill_move")

local pilot = {
	Id = "Pilot_Vanish",
	Personality = "Vanish",
	Name = "Janet Walker",
	Sex = SEX_FEMALE,
	Skill = "VanishSkill",
	Voice = "/voice/camila",
}

local function clearMissionData(mission)
	mission.VanishSkillUsed = nil
	mission.VanishSkillUsedBeforeMove = nil
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Blink", "Once per mission, may teleport to any unit when moving."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_vanish.png",mod.resourcePath.."img/effects/pilot_vanish.png")
	modApi:appendAsset("img/effects/pilot_vanish2.png",mod.resourcePath.."img/effects/pilot_vanish2.png")
	modApi:copyAsset("img/combat/icons/icon_tele_A_glow.png", "img/combat/icons/pilot_vanish_icon_tele_A_glow.png")
		Location["combat/icons/pilot_vanish_icon_tele_A_glow.png"] = Point(-13,17)
	
	ANIMS.PilotVanishExit = Animation:new{
		Image = "effects/pilot_vanish.png",
		NumFrames = 8,
		Time = 0.05,
		PosX = -33,
		PosY = -15
	}

	ANIMS.PilotVanishEnter = Animation:new{
		Image = "effects/pilot_vanish2.png",
		NumFrames = 8,
		Time = 0.05,
		PosX = -33,
		PosY = -15
	}

	VanishSkill = {}
	
	moveskill.AddTargetArea(pilot.Personality, VanishSkill)
	moveskill.AddSkillEffect(pilot.Personality, VanishSkill)

	----- Blink -----
	function VanishSkill:GetTargetArea(p1)
		local mission = GetCurrentMission()
		if not mission then return end

		-- start with the pawn's move skill
		local ret = pawnMove.GetTargetArea(p1)
		local allpawns = extract_table(Board:GetPawns(TEAM_ANY))
		if not mission.VanishSkillUsedBeforeMove then
			for i,id in pairs(allpawns) do
				pawnpoint = Board:GetPawnSpace(id)
				if pawnpoint ~= p1 then
					for dir = DIR_START, DIR_END do
						pawnpoint2 = pawnpoint + DIR_VECTORS[dir]
						if Board:IsValid(pawnpoint2) and not Board:IsBlocked(pawnpoint2, Pawn:GetPathProf()) then
							if not list_contains(extract_table(ret), pawnpoint2) then
								ret:push_back(pawnpoint2)
							end
						end
					end
				end
			end
		end

		return ret
	end

	function VanishSkill:GetSkillEffect(p1, p2)
		local mission = GetCurrentMission()
		if not mission then return end

		-- if within the normal target area, use normal move
		local path = pawnMove.GetTargetArea(p1)
		if list_contains(extract_table(path), p2) then
			return pawnMove.GetSkillEffect(p1, p2)
		end

		-- perform custom move
		local ret = SkillEffect()
		damage = SpaceDamage(p1,0)
		damage.sAnimation = "PilotVanishExit"
		ret:AddDamage(damage)

		damage = SpaceDamage(p2,0)
		damage.sAnimation = "PilotVanishEnter"
		damage.sSound = "/weapons/swap"
		damage.sImageMark = "combat/icons/pilot_vanish_icon_tele_A_glow.png"
		ret:AddDamage(damage)

		ret:AddDelay(0.3)
		ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1,-1))", Pawn:GetId()))
		ret:AddTeleport(p1,p2,0) -- Needed for move previewing
		ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(%s))", Pawn:GetId(), p2:GetString()))

		--Trigger pilot dialogue and mark used if not in test scenario
		if not IsTestMechScenario() then

			--[[The reason for setting this via script is that
				otherwise, highlighting a move but not actually performing it
				will set the variables. The move can be right-click canceled
				without ever doing Undo Move (skipping its variable reset)--]]
			ret:AddScript([[
				local mission = GetCurrentMission()
				if mission then
					mission.VanishSkillUsed = true
				end
			]])

			ret:AddScript([[
				local cast = { main = ]]..Pawn:GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Pilot_Skill_Vanish", cast)
			]])
		end

		return ret
	end

	function VanishSkill:UndoMove(mission, pawn, oldPosition)
		local mission = GetCurrentMission()
		if not mission then return end
		if not pawn:IsAbility(pilot.Skill) then return end
		mission.VanishSkillUsed = mission.VanishSkillUsedBeforeMove
	end

end

function this:load()
	modApi:addNextTurnHook(function(mission)
		if Game:GetTeamTurn() == TEAM_PLAYER then
			mission.VanishSkillUsedBeforeMove = mission.VanishSkillUsed
		end
	end)
	
	modApi:addMissionStartHook(function(mission)
		clearMissionData(mission)
	end)

	modApi:addMissionNextPhaseCreatedHook(function(_, mission)
		clearMissionData(mission)
	end)
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		VanishSkill:UndoMove(mission, pawn, oldPosition)
	end)

	modApi:addTestMechEnteredHook(function(mission)
		clearMissionData(mission)
	end)
			
	modapiext.dialog:addRuledDialog("Pilot_Skill_Vanish", {
		Odds = 5,
		{ main = "Pilot_Skill_Vanish" },
	})
end

return this