-- Uses LApi for GetMaxHealth()

local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Quicksilver",
	Personality = "Quicksilver",
	Name = "Amelia Espada",
	Sex = SEX_FEMALE,
	Skill = "QuicksilverSkill",
	Voice = "/voice/camila",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Polyalloy Shell", "Mech repairs 1 damage at the start of each turn."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_quicksilver.png",mod.resourcePath.."img/effects/pilot_quicksilver.png")

	ANIMS.PilotQuicksilverMetal = Animation:new{
		Image = "effects/pilot_quicksilver.png",
		NumFrames = 10,
		Time = 0.05,
		PosX = -33,
		PosY = -14
	}

	QuicksilverSkill = {}
	
	----- Polyalloy Shell -----
	function QuicksilverSkill:HealingNow(point)
		local effect = SkillEffect()
		local damage = SpaceDamage(point, -1)

		damage.sAnimation = "PilotQuicksilverMetal"

		effect:AddDamage(damage)
		--Trigger pilot dialogue
		effect:AddScript([[
			local cast = { main = ]]..Board:GetPawn(point):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Pilot_Skill_Quicksilver", cast)
		]])
		SuppressDialog(1200,"Mech_Repaired")
		Board:AddEffect(effect)
	end

end

function this:load()	
	modApi:addNextTurnHook(function(mission)
		mission.QuicksilverEnv1 = nil
	end)
	
	modApi:addPreEnvironmentHook(function(mission)
	-- These happen after 1) fire 2) psions but before 3) environment hazards
		if not mission.QuicksilverEnv1 then
			mission.QuicksilverEnv1 = true
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				local pawn = Board:GetPawn(id)
				local currhp = pawn:GetHealth()
				
				local maxhp = pawn:GetMaxHealth()
				
				if pawn:IsAbility(pilot.Skill) and not pawn:IsDead() and currhp < maxhp then
					QuicksilverSkill:HealingNow(Board:GetPawnSpace(id))
				end
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Quicksilver", {
		Odds = 5,
		{ main = "Pilot_Skill_Quicksilver" },
	})
end

return this