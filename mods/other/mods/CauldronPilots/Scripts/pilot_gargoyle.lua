local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Gargoyle",
	Personality = "Gargoyle",
	Name = "Gargoyle",
	Sex = SEX_MALE,
	Skill = "GargoyleSkill",
	Voice = "/voice/prospero",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Leech Field", "Instead of repairing, fire a projectile that siphons health from enemies."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/explo_leech1_U.png",mod.resourcePath.."img/effects/explo_leech1_U.png")
	modApi:appendAsset("img/effects/explo_leech1_D.png",mod.resourcePath.."img/effects/explo_leech1_D.png")
	modApi:appendAsset("img/effects/explo_leech1_L.png",mod.resourcePath.."img/effects/explo_leech1_L.png")
	modApi:appendAsset("img/effects/explo_leech1_R.png",mod.resourcePath.."img/effects/explo_leech1_R.png")
	
	ANIMS.exploleech1_0 = Animation:new{
		Image = "effects/explo_leech1_U.png",
		NumFrames = 8,
		Time = 0.06,
		--PosX = -5,
		-- = 2
		PosX = -34,
		PosY = -13
	}

	ANIMS.exploleech1_1 = ANIMS.exploleech1_0:new{
		Image = "effects/explo_leech1_R.png",
		PosX = -33,
		PosY = -13
	}

	ANIMS.exploleech1_2 = ANIMS.exploleech1_0:new{
		Image = "effects/explo_leech1_D.png",
		PosX = -34,
		PosY = -13
	}

	ANIMS.exploleech1_3 = ANIMS.exploleech1_0:new{
		Image = "effects/explo_leech1_L.png",
		--PosX = -22,
		--PosY = 2
		PosX = -33,
		PosY = -13
	}
	
	CaulP_repairApi:SetRepairSkill{
		Weapon = "GargoyleSkill_Link",
		Icon = "img/weapons/repair_leech.png",		
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	---- Leech Field ----
	GargoyleSkill_Link = Skill:new{
		Name = "Leech Field",
		Description = "Fire a projectile that siphons health. Removes Fire, Ice, and A.C.I.D. if Mech heals.",
		Amount = -1,
		Damage = 1,
		TipImage = {
			Unit = Point(2,3),
			Fire = Point(2,3),
			Enemy_Damaged = Point(2,1),
			Target = Point(2,1),
		}
	}

	function GargoyleSkill_Link:GetTargetArea(p1)
		local ret = PointList()

		if Board:GetPawn(p1):IsFrozen() then
			ret:push_back(p1)
		end
		for dir = DIR_START, DIR_END do
			local this_path = {}

			local target = p1 + DIR_VECTORS[dir]

			while not Board:IsBlocked(target, PATH_PROJECTILE) do
				this_path[#this_path+1] = target
				target = target + DIR_VECTORS[dir]
			end

			if Board:IsValid(target) and Board:IsPawnSpace(target) then
				this_path[#this_path+1] = target
				for i,v in ipairs(this_path) do
					ret:push_back(v)
				end
			end
		end

		return ret
	end


	function GargoyleSkill_Link:GetSkillEffect(p1, p2)
		local ret = SkillEffect()

		if p1 == p2 then
			local damage = SpaceDamage(p1,0)
			damage.iFrozen = EFFECT_REMOVE
			ret:AddDamage(damage)
		else
			local backwards = GetDirection(p1 - p2)
			local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)
			local damage = SpaceDamage(target, self.Damage)
			damage.sAnimation = "exploleech1_" .. backwards --update!
			--ret:AddProjectile(damage, "effects/shot_phaseshot", FULL_DELAY) --update!
			ret:AddDamage(damage)

			-- Make healing dependent on damage dealt, accounting for intact armor or acid
			local pawn = Board:GetPawn(target)

			if pawn:IsArmor() and not pawn:IsAcid() then
				--LOG("No healing")
			elseif pawn:IsAcid() then
				--LOG("2X healing")
				-- Remember, healing is negative! Hence we use max
				local healing = math.max(self.Amount*2,-1 * pawn:GetHealth())
				damage = SpaceDamage(p1,healing)
				damage.iFire = EFFECT_REMOVE
				if Board:GetPawn(p1):IsAcid() then
					damage.iAcid = EFFECT_REMOVE
				end
				damage.iFrozen = EFFECT_REMOVE
				ret:AddDamage(damage)
			else
				--LOG("Normal healing")
				damage = SpaceDamage(p1,self.Amount)
				damage.iFire = EFFECT_REMOVE
				if Board:GetPawn(p1):IsAcid() then
					damage.iAcid = EFFECT_REMOVE
				end
				damage.iFrozen = EFFECT_REMOVE
				ret:AddDamage(damage)
			end

			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Gargoyle", cast)
					SuppressDialog(1200,"Mech_Repaired")
				]])
			end
		end

		return ret
	end

end

function this:load()
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Gargoyle", {
		Odds = 5,
		{ main = "Pilot_Skill_Gargoyle" },
	})
end

return this