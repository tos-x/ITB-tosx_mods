local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local customAnim = require(path .."libs/customAnim")
local trait = require(path .."libs/trait")

local pilot = {
	Id = "Pilot_Gray",
	Personality = "Gray",
	Name = "Ezekiel Gray",
	Sex = SEX_MALE,
	Skill = "GraySkill",
	Voice = "/voice/chen",
	Blacklist = {"Regen"},
}

function this:GetPilot()
	return pilot
end

local function AnimateFallout(id, flag)
	local mission = GetCurrentMission()
	if flag then
		customAnim:add(id, "PilotGrayFlameL")
		mission.tosx_GrayCritical = true
	else
		customAnim:rem(id, "PilotGrayFlameL")
		mission.tosx_GrayCritical = nil
	end
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Unstable Reactor", "Damages adjacent non-building tiles at the end of your turn if Mech has 1 health."))
	
	-- art, icons, animations
	--modApi:appendAsset("img/effects/explo_radgray.png",mod.resourcePath.."img/effects/explo_radgray.png")
	modApi:appendAsset("img/effects/pilot_gray.png",mod.resourcePath.."img/effects/pilot_gray.png")
	modApi:appendAsset("img/effects/pilot_gray2.png",mod.resourcePath.."img/effects/pilot_gray2.png")

	ANIMS.PilotGrayBlast = Animation:new{
		Image = "effects/pilot_gray.png",
		NumFrames = 8,
		Time = 0.08,
		PosX = -33,
		PosY = -14
	}

	ANIMS.PilotGrayFlame = Animation:new{
		Image = "effects/pilot_gray2.png",
		NumFrames = 8,
		Time = 0.06,
		PosX = -33,
		PosY = -14
	}
	ANIMS.PilotGrayFlameL = ANIMS.PilotGrayFlame:new{
		Time = 0.1,
		Loop = true
	}

	GraySkill = {}
	
	-- Unstable Reactor
	function GraySkill:Fallout(p1)
		local effect = SkillEffect()

		local damage = SpaceDamage(p1,0)
		damage.sAnimation = "PilotGrayBlast"
		damage.sSound = "/impact/generic/explosion_large"
		effect:AddDamage(damage)
		effect:AddScript("Board:AddAlert(Point("..p1:GetString().."),'UNSTABLE REACTOR')")

		for dir = DIR_START, DIR_END do
			point = p1 + DIR_VECTORS[dir]
			if Board:IsValid(point) and not Board:IsBuilding(point) then
				damage = SpaceDamage(point,1)
				damage.sAnimation = "PilotGrayFlame"
				effect:AddDamage(damage)
				effect:AddDelay(0.04)
			end
		end

		--Trigger pilot dialogue
		if not IsTestMechScenario() then
			effect:AddScript([[
				local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Pilot_Skill_Gray", cast)
			]])
		end

		Board:AddEffect(effect)
	end
end

function this:load()
	modApi:addPreEnvironmentHook(function(mission)
		if not mission.GrayEnv1 then
			mission.GrayEnv1 = true
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				if Board:GetPawn(id):IsAbility(pilot.Skill) and Board:GetPawn(id):GetHealth() == 1 and Game:GetTurnCount() > 0 then
					GraySkill:Fallout(Board:GetPawnSpace(id))
				end
			end
		end
	end)
	
	modApi:addNextTurnHook(function(mission)
		mission.GrayEnv1 = nil
	end)
	
	-- Animation on pawn while at 1hp; apply and remove as needed
	modapiext:addPawnDamagedHook(function(mission, pawn, damageTaken)
		-- Update pawn trait for cases where it's not moving
		if pawn:IsAbility(pilot.Skill) then trait:update(pawn:GetSpace()) end
		
		if pawn:GetHealth() == 1 and pawn:IsAbility(pilot.Skill) and not mission.tosx_GrayCritical then
			AnimateFallout(pawn:GetId(), true)
		end
	end)
	modapiext:addPawnHealedHook(function(mission, pawn, healingTaken)
		if pawn:IsAbility(pilot.Skill) then
			-- Update pawn trait for cases where it's not moving
			trait:update(pawn:GetSpace())
			
			--Could be adding animation if being revived
			if pawn:GetHealth() == 1 and not mission.tosx_GrayCritical then
				AnimateFallout(pawn:GetId(), true)
			elseif mission.tosx_GrayCritical then
				AnimateFallout(pawn:GetId(), false)
			end
		end
	end)
	modapiext:addPawnKilledHook(function(mission, pawn)
		if pawn:IsAbility(pilot.Skill) and mission.tosx_GrayCritical then
			AnimateFallout(pawn:GetId(), false)
		end
	end)
	modApi:addMissionStartHook(function(mission)
		for id = 0, 2 do
			local pawn = Board:GetPawn(id)
			if pawn:GetHealth() == 1 and pawn:IsAbility(pilot.Skill) then
				AnimateFallout(pawn:GetId(), true)
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Gray", {
		Odds = 10,
		{ main = "Pilot_Skill_Gray" },
	})	
end

return this