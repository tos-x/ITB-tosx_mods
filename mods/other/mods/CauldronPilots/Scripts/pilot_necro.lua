local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local trait = require(path .."libs/trait")

local pilot = {
	Id = "Pilot_Necro",
	Personality = "Necro",
	Name = "Simon Coil",
	Sex = SEX_MALE,
	Skill = "NecroSkill",
	Voice = "/voice/harold",
}

local function clearMissionData(mission)
	mission.NecroSkillUsed = false
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Necrotize", "Once per mission, when an adjacent Vek dies, creates a friendly Spiderling."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_necro1.png",mod.resourcePath.."img/effects/pilot_necro1.png")

	ANIMS.PilotNecroGrave = Animation:new{
		Image = "effects/pilot_necro1.png",
		NumFrames = 8,
		Time = 0.08,
		PosX = -22,
		PosY = 1
	}

	modApi:appendAsset("img/units/enemy/spiderlingZ.png", mod.resourcePath .."img/units/player/spiderlingZ.png")
	modApi:appendAsset("img/units/enemy/spiderlingZ_ns.png", mod.resourcePath .."img/units/player/spiderlingZ_ns.png")
	modApi:appendAsset("img/units/enemy/spiderlingZ_death.png", mod.resourcePath .."img/units/player/spiderlingZ_death.png")
	modApi:appendAsset("img/units/enemy/spiderlingZa.png", mod.resourcePath .."img/units/player/spiderlingZa.png")
	modApi:appendAsset("img/portraits/enemy/spiderlingZ_portrait.png", mod.resourcePath.. "img/portraits/summons/spiderlingZ_portrait.png")
	modApi:appendAsset("img/weapons/spiderlingZ_wep_portrait.png",mod.resourcePath.."img/weapons/spiderlingZ_wep_portrait.png")

	local a = ANIMS
	a.CaulP_SpiderlingZ = a.BaseUnit:new{Image = "units/enemy/spiderlingZ.png", PosX = -14, PosY = 10 }
	a.CaulP_SpiderlingZa = a.CaulP_SpiderlingZ:new{Image = "units/enemy/spiderlingZa.png", NumFrames = 6 }
	a.CaulP_SpiderlingZ_ns = a.CaulP_SpiderlingZ:new{Image = "units/enemy/spiderlingZ_ns.png"}	
	a.CaulP_SpiderlingZd = a.CaulP_SpiderlingZ:new{Image = "units/enemy/spiderlingZ_death.png", PosX = -20, PosY = 11, NumFrames = 8, Time = 0.14, Loop = false }
	
	SpiderlingZ =
	{
		Name = "Reanimated Spiderling",
		Health = 1,
		MoveSpeed = 3,
		SpawnLimit = false,
		Image = "CaulP_SpiderlingZ",
		SkillList = { "SpiderlingAtkZ" },
		SoundLocation = "/enemy/spiderling_1/",
		DefaultTeam = TEAM_PLAYER,
		ImpactMaterial = IMPACT_FLESH,
		Portrait = "enemy/spiderlingZ_portrait"
	}
	AddPawn("SpiderlingZ")

	SpiderlingAtkZ = Skill:new{
		Name = "Tiny Mandibles",
		Description = "Sacrifice self to damage and push the target.", 
		Icon = "weapons/spiderlingZ_wep_portrait.png",
		PathSize = 1,
		Damage = 1,
		SelfDamage = DAMAGE_DEATH,
		TipImage = {
			Unit = Point(2,2),
			Enemy = Point(2,1),
			Target = Point(2,1),
			CustomPawn = "SpiderlingZ"
		}
	}

	function SpiderlingAtkZ:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		local dir = GetDirection(p2 - p1)

		local damage = SpaceDamage(p2, self.Damage, dir)
		damage.sAnimation = "explopunch1_"..dir
		ret:AddMelee(p1, damage)
		
		ret:AddDamage(SpaceDamage(p1,self.SelfDamage))
		
		return ret
	end

	NecroSkill = {}

	-- Necrotize
	function NecroSkill:Reanimate(id,grave,nid)
		local ret = SkillEffect()
		ret:AddDelay(0.15)
		ret:AddScript("NecroSkill:Reanimate2("..id..","..grave:GetString()..","..nid..")")
		Board:AddEffect(ret)
	end

	function NecroSkill:Reanimate2(id,grave0,nid)
		local mission = GetCurrentMission()
		if not mission then return end
		local ret = SkillEffect()
		local grave = Board:GetPawnSpace(id)

		-- If we can't find pawn's location, default to where it originally died
		-- Original location won't account for pushing etc.

		if grave == Point(-1,-1) then
			grave = grave0
		end

		if Board:GetTerrain(grave) == TERRAIN_WATER or Board:GetTerrain(grave) == TERRAIN_HOLE or Board:IsBlocked(grave,PATH_PROJECTILE) then
			mission.NecroSkillUsed = false
			-- Dying pawn has ended up in a hole/water/obstacle, don't waste the spiderling
		else
			mission.NecroSkillUsed = true
			ret:AddScript([[local pawnzombie = PAWN_FACTORY:CreatePawn("SpiderlingZ")
				Board:AddPawn(pawnzombie,]] .. grave:GetString() .. [[)
				pawnzombie:SetTeam(TEAM_PLAYER)
				if Game:GetTeamTurn() == TEAM_ENEMY then pawnzombie:SetActive(false) end
				]])
			ret:AddScript("Board:AddAlert(Point(" .. grave:GetString() .. "),'NECROTIZE')")
			
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				trait:update(Board:GetPawnSpace(id))
			end

			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..nid..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Necro", cast)
				]])
			end

			local damage = SpaceDamage(grave)
			damage.sAnimation = "PilotNecroGrave"
			ret:AddDamage(damage)
			Board:AddEffect(ret)
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

	modApi:addTestMechEnteredHook(function(mission)
		clearMissionData(mission)
	end)
	
	modapiext:addPawnKilledHook(function(mission, pawn)		
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility(pilot.Skill) and mission.NecroSkillUsed == false and not Board:GetPawn(id):IsDead() then
				if (pawn:GetTeam() == TEAM_ENEMY) and (pawn:GetTeam() ~= TEAM_BOTS) and not (_G[pawn:GetType()].Minor) then
					local point = pawn:GetSpace()
					if point:Manhattan(Board:GetPawnSpace(id)) == 1 then
						if Board:GetTerrain(point) ~= TERRAIN_WATER and Board:GetTerrain(point) ~= TERRAIN_HOLE then
							mission.NecroSkillUsed = true
							NecroSkill:Reanimate(pawn:GetId(),point,id)
							break
						end
					end
				end
			end
		end		
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Necro", {
		Odds = 50,
		{ main = "Pilot_Skill_Necro" },
	})
end

return this