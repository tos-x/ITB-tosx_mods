local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Malichae",
	Personality = "Malichae",
	Name = "Alec Shaheen",
	Sex = SEX_MALE,
	Skill = "MalichaeSkill",
	Voice = "/voice/ralph",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Decoy", "Repairing leaves a hologram decoy instead of healing Mech."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_malichae.png",mod.resourcePath.."img/effects/pilot_malichae.png")
	modApi:appendAsset("img/effects/pilot_malichae2.png",mod.resourcePath.."img/effects/pilot_malichae2.png")
	
	ANIMS.PilotMalichaeSummon = Animation:new{
		Image = "effects/pilot_malichae.png",
		NumFrames = 8,
		Time = 0.08,
		PosX = -33,
		PosY = 0
	}

	ANIMS.PilotMalichaeUnsummon = Animation:new{
		Image = "effects/pilot_malichae2.png",
		NumFrames = 4,
		Time = 0.08,
		PosX = -21,
		PosY = 3
	}
	
	modApi:appendAsset("img/units/enemy/holodecoy.png", mod.resourcePath .."img/units/player/holodecoy.png")
	modApi:appendAsset("img/units/enemy/holodecoy_death.png", mod.resourcePath .."img/units/player/holodecoy_death.png")
	modApi:appendAsset("img/units/enemy/holodecoya.png", mod.resourcePath .."img/units/player/holodecoya.png")
	
	local a = ANIMS
	a.CaulP_HoloDecoy = a.BaseUnit:new{Image = "units/enemy/holodecoy.png", PosX = -21, PosY = 0 }
	a.CaulP_HoloDecoya = a.CaulP_HoloDecoy:new{Image = "units/enemy/holodecoya.png", NumFrames = 4 }
	a.CaulP_HoloDecoyd = a.CaulP_HoloDecoy:new{Image = "units/enemy/holodecoy_death.png", NumFrames = 4, Time = 0.14, Loop = false }
	
	HoloDecoy = 
	{
		Name = "Hard Light Decoy",
		Health = 1,
		Neutral = true,
		MoveSpeed = 0,
		IsPortrait = false,
		Image = "CaulP_HoloDecoy",
		DefaultTeam = TEAM_PLAYER,
		Pushable = false,
		Flying = true,
		IgnoreFire = true,
		ImpactMaterial = IMPACT_SHIELD
	}
	AddPawn("HoloDecoy")	
	
	CaulP_repairApi:SetRepairSkill{
		Weapon = "MalichaeSkill_Link",
		Icon = "img/weapons/repair_summon.png",		
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	-- Decoy
	MalichaeSkill_Link = Skill:new{
		Name = "Decoy",
		Description = "Move to an adjacent tile, removing Fire, Ice, and A.C.I.D. from Mech, and leaving a Decoy for 1 turn.",
		TipImage = {
			Unit = Point(2,3),
			Fire = Point(2,3),
			Enemy = Point(2,1),
			Target = Point(3,3),
		}
	}

	function MalichaeSkill_Link:GetTargetArea(p1)
		local ret = PointList()
		for dir = DIR_START, DIR_END do
			local point = p1 + DIR_VECTORS[dir]
			if Board:IsValid(point) and not Board:IsBlocked(point, Pawn:GetPathProf()) then
				ret:push_back(point)
			end
		end
		return ret
	end

	function MalichaeSkill_Link:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		ret:AddCharge(Board:GetSimplePath(p1, p2), NO_DELAY)
		
		local damage = SpaceDamage(p2,0)
		damage.iFire = EFFECT_REMOVE
		damage.iFrozen = EFFECT_REMOVE
		if Pawn:IsAcid() then
			damage.iAcid = EFFECT_REMOVE
		end
		damage.sSound = "/ui/map/repair_mech"
		ret:AddDamage(damage)
		
		ret:AddScript([[
			local self = Point(]].. p2:GetString() .. [[)
			Board:Ping(self, GL_Color(0, 255, 0));
		]])
		
		ret:AddDelay(0.1)
		local damage2 = SpaceDamage(p1,0)
		damage2.sPawn = "HoloDecoy"
		damage2.sAnimation = "PilotMalichaeSummon"
		damage2.sSound = "/props/shield_activated"
		ret:AddDamage(damage2)
		--Trigger pilot dialogue
		if not IsTestMechScenario() then
			ret:AddScript([[
				local cast = { main = ]]..Pawn:GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Pilot_Skill_Malichae", cast)
			]])
		end
		
		return ret
	end

end

function this:load()
	modApi:addNextTurnHook(function(mission)			
		if Game:GetTeamTurn() == TEAM_PLAYER then
			--Malichae's holograms fade
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				local pawn = Board:GetPawn(id)
				if pawn:GetType() == "HoloDecoy" then
					Board:GetPawn(id):Kill(true)
					local ret = SkillEffect()
					local damage = SpaceDamage(pawn:GetSpace(),0)
					damage.sAnimation = "PilotMalichaeUnsummon"
					ret:AddDamage(damage)
					Board:AddEffect(ret)
				end
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Malichae", {
		Odds = 10,
		{ main = "Pilot_Skill_Malichae" },
	})
end

return this