local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Doc",
	Personality = "Doc",
	Name = "Mark Savage",
	Sex = SEX_MALE,
	Skill = "DocSkill",
	Voice = "/voice/isaac",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	--require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Medic", "Can repair adjacent Mechs."))
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Medic", "Fixes all damage when repairing. Can repair adjacent Mechs."))
	
	-- art, icons, animations
	
	CaulP_repairApi:SetRepairSkill{
		Weapon = "DocSkill_Link",
		Icon = "img/weapons/repair_medic.png",		
		IsActive = function(pawn)
			return pawn:IsAbility("DocSkill") and not pawn:IsFrozen()
		end
	}

	---- Medic ----
	DocSkill_Link = Skill:new{
		Name = "Repair",
		Description = "Repair self or adjacent Mech for all damage and remove Fire, Ice, and A.C.I.D.",
		Amount = -10,
		PathSize = 1,
		TipImage = {
			Unit = Point(2,3),
			Fire = Point(2,2),
			Friendly_Damaged = Point(2,2),
			Target = Point(2,2),
		}
	}

	function DocSkill_Link:GetTargetArea(p1)
		local ret = PointList()
		ret:push_back(p1)
		if not Board:GetPawn(p1):IsFrozen() then
			for dir = DIR_START, DIR_END do
				local loc = p1 + DIR_VECTORS[dir]

				if Board:IsValid(loc) and Board:IsPawnSpace(loc) then
					if Board:GetPawnTeam(loc) == TEAM_PLAYER and Board:GetPawn(loc):IsMech() then
						ret:push_back(loc)
					end
				end
			end
		end
		return ret
	end


	function DocSkill_Link:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		
		local damage = SpaceDamage(p2,self.Amount)
		damage.iFire = EFFECT_REMOVE
		damage.iFrozen = EFFECT_REMOVE
					
		local mechs = extract_table(Board:GetPawns(TEAM_MECH))
		for i,id in pairs(mechs) do
			local point = Board:GetPawnSpace(id)
			if point == p2 or IsPassiveSkill("Mass_Repair") then
				damage.loc = point			
				if Board:IsPawnSpace(point) then
					if Board:GetPawn(point):IsAcid() then
						damage.iAcid = EFFECT_REMOVE
					end
				end
				ret:AddDamage(damage)
			end
		end

		if p2 ~= p1 then
			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Doc", cast)
					SuppressDialog(1200,"Mech_Repaired")
				]])
			end
		end
		return ret
	end

end

function this:load()
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Doc", {
		Odds = 20,
		{ main = "Pilot_Skill_Doc" },
	})
end

return this