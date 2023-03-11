local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_AZ",
	Personality = "AZ",
	Name = "Ryan Frost",
	Sex = SEX_MALE,
	Skill = "AZSkill",
	Voice = "/voice/archimedes",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Coolant Blast", "Repairing instead Freezes Mech and sets an adjacent tile on Fire. Reversed if Frozen."))
	
	-- art, icons, animations
	
	CaulP_repairApi:SetRepairSkill{
		Weapon = "AZSkill_Link",
		Icon = "img/weapons/repair_isothermal.png",		
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	---- Coolant Blast ----
	AZSkill_Link = Skill:new{
		Name = "Coolant Blast",
		Description = "Freeze Mech and set an adjacent tile on Fire. If Mech is Frozen, effects are reversed.",
		TipImage = {
			Unit = Point(2,3),
			Fire = Point(2,3),
			Enemy = Point(2,2),
			Target = Point(2,2),
		}
	}

	function AZSkill_Link:GetTargetArea(p1)
		local ret = PointList()
		for dir = DIR_START, DIR_END do
			local loc = p1 + DIR_VECTORS[dir]
			if Board:IsValid(loc) then
				ret:push_back(loc)
			end
		end
		return ret
	end


	function AZSkill_Link:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		local damage = SpaceDamage(p1,0)

		if Board:GetPawn(p1):IsFrozen() then
			--Trigger pilot dialogue
				if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_AZ2", cast)
				]])
			end

			damage.iFire = EFFECT_CREATE
			ret:AddDamage(damage)

			damage = SpaceDamage(p2,0)
			damage.iFrozen = EFFECT_CREATE
			ret:AddDamage(damage)
		else
			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_AZ", cast)
				]])
			end

			damage.iFrozen = EFFECT_CREATE
			ret:AddDamage(damage)

			damage = SpaceDamage(p2,0)
			damage.iFire = EFFECT_CREATE
			ret:AddDamage(damage)
		end
		return ret
	end

end

function this:load()	
	modapiext.dialog:addRuledDialog("Pilot_Skill_AZ", {
		Odds = 5,
		{ main = "Pilot_Skill_AZ" },
	})
end

return this