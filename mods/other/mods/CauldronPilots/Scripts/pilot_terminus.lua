local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Terminus",
	Personality = "Terminus",
	Name = "Daiyu Tang",
	Sex = SEX_FEMALE,
	Skill = "TerminusSkill",
	Voice = "/voice/camila",
}

---
local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
	for i,id in pairs(mechs) do
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			local TerminusSkillId = id
			if not Board:GetPawn(TerminusSkillId):IsFrozen() and not Board:GetPawn(TerminusSkillId):IsDead() then
				local point1 = Board:GetPawnSpace(TerminusSkillId)
				if Board:GetPawnTeam(pawn:GetSpace()) ~= TEAM_PLAYER and p1:Manhattan(point1) == 1 and weaponId ~= "WebeggHatch1" then
				
					-- Need to add the entire attack via script; adding things to current skillEffect will treat them as part of the Vek attack,
					-- meaning Vek Hormones will trigger
					if not skillEffect.q_effect:empty() then
						skillEffect:AddQueuedScript("TerminusSwipe("..p1:GetString()..", "..point1:GetString()..","..TerminusSkillId..")")
					end
					
				end
			end
		end
	end
end

function TerminusSwipe(p1, point1, TerminusSkillId)
	-- local mission = GetCurrentMission()
	-- if not mission then return end
	-- if not mission.TerminusSkillId then return end
	
	local effect = SkillEffect()
	effect.iOwner = TerminusSkillId
	local direction = GetDirection(p1 - point1)
	local damage = SpaceDamage(p1,1)
	damage.sAnimation = "PilotTerminusSword_".. direction
	damage.sSound = "/weapons/sword"
	damage.bHide = true
	effect:AddMelee(point1, damage)
	effect:AddScript([[
		local cast = { main = ]]..Board:GetPawn(point1):GetId()..[[ }
		modapiext.dialog:triggerRuledDialog("Pilot_Skill_Terminus", cast)
		SuppressDialog(1200,"VekKilled_Vek")
		SuppressDialog(1200,"DoubleVekKill_Vek")
	]])
	effect:AddDelay(0.1)
	Board:AddEffect(effect)
end
---

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Vengeance", "Deal 1 damage to enemies that attack adjacent to Mech."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_tsword_D.png",mod.resourcePath.."img/effects/pilot_tsword_D.png")
	modApi:appendAsset("img/effects/pilot_tsword_L.png",mod.resourcePath.."img/effects/pilot_tsword_L.png")
	modApi:appendAsset("img/effects/pilot_tsword_R.png",mod.resourcePath.."img/effects/pilot_tsword_R.png")
	modApi:appendAsset("img/effects/pilot_tsword_U.png",mod.resourcePath.."img/effects/pilot_tsword_U.png")
	
	ANIMS.PilotTerminusSword_0 = ANIMS.explosword_0:new{
		Image = "effects/pilot_tsword_U.png",
	}
	ANIMS.PilotTerminusSword_1 = ANIMS.explosword_1:new{
		Image = "effects/pilot_tsword_R.png",
	}
	ANIMS.PilotTerminusSword_2 = ANIMS.explosword_2:new{
		Image = "effects/pilot_tsword_D.png",
	}
	ANIMS.PilotTerminusSword_3 = ANIMS.explosword_3:new{
		Image = "effects/pilot_tsword_L.png",
	}
end

function this:load()	
	modapiext:addSkillBuildHook(onSkillEffect)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Terminus", {
		Odds = 50,
		{ main = "Pilot_Skill_Terminus" },
	})
end

return this