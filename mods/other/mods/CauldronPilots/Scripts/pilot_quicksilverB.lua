-- Uses LApi for GetMaxHealth()

local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local trait = require(path .."libs/trait")

local pilot = {
	Id = "Pilot_Quicksilver",
	Personality = "QuicksilverB",
	Name = "Amelia Espada",
	Sex = SEX_FEMALE,
	Skill = "QuicksilverSkillB",
	Voice = "/voice/camila",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Combat Override", "Mech gains Boosted when damaged."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_quicksilver.png",mod.resourcePath.."img/effects/pilot_quicksilver.png")

	ANIMS.PilotQuicksilverMetal = Animation:new{
		Image = "effects/pilot_quicksilver.png",
		NumFrames = 10,
		Time = 0.05,
		PosX = -33,
		PosY = -14,
		Loop = false,
	}

	QuicksilverSkillB = {}
	
	----- Polyalloy Shell -----
	function QuicksilverSkillB:Hardening(pawn)	
		local cast = { main = pawn:GetId() }
		modapiext.dialog:triggerRuledDialog("Pilot_Skill_Quicksilver", cast)
		pawn:SetBoosted(true)
		trait:update(pawn:GetSpace())
		Board:AddAnimation(pawn:GetSpace(), "PilotQuicksilverMetal", NO_DELAY)
	end

end

function this:load()	
	modapiext:addPawnDamagedHook(function(mission, pawn, damageTaken)	
		if pawn:IsAbility(pilot.Skill) and not pawn:IsDead() and not pawn:IsBoosted() then
			QuicksilverSkillB:Hardening(pawn)
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Quicksilver", {
		Odds = 5,
		{ main = "Pilot_Skill_Quicksilver" },
	})
end

return this