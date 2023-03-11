local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Low",
	Personality = "Low",
	Name = "Sen",
	Sex = SEX_FEMALE,
	Skill = "LowSkill",
	Voice = "/voice/lily",
}

---
local function IsLowPawnSelected()
	local pawn = this.selected:Get()
	return 
		pawn								and
		not pawn:IsDead()					and
		pawn:IsAbility("LowSkill")
end

LowSkill = {}

function LowSkill:Mark(p1)
	local mission = GetCurrentMission()
	if not mission then return end
	local season = Game:GetTurnCount()
	
	dir = season%4
	local point = p1 + DIR_VECTORS[dir]
	-- check turn, apply terrain
	if season == 1 then
		Board:MarkSpaceImage(point,"combat/tile_icon/pilot_low_spring.png", GL_Color(255, 180, 0 ,0.75))
		Board:MarkSpaceDesc(point, "low_spring")
	elseif season == 2 then
		Board:MarkSpaceImage(point,"combat/tile_icon/pilot_low_summer.png", GL_Color(255, 180, 0 ,0.75))
		Board:MarkSpaceDesc(point, "low_summer")
	elseif season == 3 then
		Board:MarkSpaceImage(point,"combat/tile_icon/pilot_low_fall.png", GL_Color(255, 180, 0 ,0.75))
		Board:MarkSpaceDesc(point, "low_fall")
	elseif season == 4 then
		Board:MarkSpaceImage(point,"combat/tile_icon/pilot_low_winter.png", GL_Color(255, 180, 0 ,0.75))
		Board:MarkSpaceDesc(point, "low_winter")
	end
end

function LowSkill:Weather(p1,id)
	local mission = GetCurrentMission()
	if not mission then return end
	local effect = SkillEffect()
	local season = Game:GetTurnCount()

	effect:AddScript("Board:AddAlert(Point("..p1:GetString().."),'ATMOSPHERICS')")
	--Trigger pilot dialogue
	effect:AddScript([[
		local cast = { main = ]]..id..[[ }
		modapiext.dialog:triggerRuledDialog("Pilot_Skill_Low_]]..season..[[", cast)
		SuppressDialog(1800,"Vek_Frozen")
		SuppressDialog(1800,"Vek_Smoke")
	]])
	
	dir = season%4
	local point = p1 + DIR_VECTORS[dir]
	if Board:IsValid(point) then
		local damage = SpaceDamage(point,0)
		local dummy = SpaceDamage(point,0)
		-- check turn, apply effect
		if season == 1 then
			effect:AddSound("/props/tide_flood")
			dummy.sAnimation = "PilotLowRain1"
			effect:AddDamage(dummy)
			
			for i = 1,20 do
				dummy.sAnimation = "PilotLowRain"..math.random(1,21)
				effect:AddDamage(dummy)
				effect:AddDelay(math.random(3,5)*0.01)
				if i == 13 then
					damage.iAcid = EFFECT_CREATE
					effect:AddDamage(damage)
				end				
			end
		elseif season == 2 then
			effect:AddSound("/props/lava_splash")
			dummy.sAnimation = "PilotLowSunlight"
			effect:AddDamage(dummy)
			effect:AddDelay(1.3)
			damage.iFire = EFFECT_CREATE
			effect:AddDamage(damage)
		elseif season == 3 then
			effect:AddSound("/weapons/wind")
			dummy.sAnimation = "PilotLowDust"
			effect:AddDamage(dummy)
			effect:AddDelay(0.7)
			damage.iSmoke = EFFECT_CREATE
			effect:AddDamage(damage)
		elseif season == 4 then
			effect:AddSound("/props/snow_storm")
			mission.LowSkillWeather = 4
			modApi:scheduleHook(1200, function()
				mission.LowSkillWeather = nil
			end)
			effect:AddDelay(1)
			damage.iFrozen = EFFECT_CREATE
			effect:AddDamage(damage)
		end
	end

	Board:AddEffect(effect)
end
---

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Atmospherics", "Applies a different elemental effect to an adjacent tile after each of your turns."))
	
	-- art, icons, animations
	modApi:appendAsset("img/combat/tile_icon/pilot_low_spring.png",mod.resourcePath.."img/combat/tile_icon/pilot_low_spring.png")
		Location["combat/tile_icon/pilot_low_spring.png"] = Point(-27,2)
	modApi:appendAsset("img/combat/tile_icon/pilot_low_summer.png",mod.resourcePath.."img/combat/tile_icon/pilot_low_summer.png")
		Location["combat/tile_icon/pilot_low_summer.png"] = Point(-27,2)
	modApi:appendAsset("img/combat/tile_icon/pilot_low_fall.png",mod.resourcePath.."img/combat/tile_icon/pilot_low_fall.png")
		Location["combat/tile_icon/pilot_low_fall.png"] = Point(-27,2)
	modApi:appendAsset("img/combat/tile_icon/pilot_low_winter.png",mod.resourcePath.."img/combat/tile_icon/pilot_low_winter.png")
		Location["combat/tile_icon/pilot_low_winter.png"] = Point(-27,2)
	modApi:appendAsset("img/effects/smoke/pilot_low_snow.png",mod.resourcePath.."img/effects/smoke/pilot_low_snow.png")
	modApi:appendAsset("img/effects/pilot_low_sunlight.png",mod.resourcePath.."img/effects/pilot_low_sunlight.png")
	modApi:appendAsset("img/effects/pilot_low_dust.png",mod.resourcePath.."img/effects/pilot_low_dust.png")
	modApi:appendAsset("img/effects/pilot_low_rain.png",mod.resourcePath.."img/effects/pilot_low_rain.png")
	
	TILE_TOOLTIPS["low_spring"] = {"Acid Rain", "The rain inflicts anything present with A.C.I.D."}
	TILE_TOOLTIPS["low_summer"] = {"Heat Wave", "Intense heat sets anything present on Fire."}
	TILE_TOOLTIPS["low_fall"] = {"Dust Storm", "The storm generates smoke on this tile."}
	TILE_TOOLTIPS["low_winter"] = {"Icy Winds", "The storm causes anything present to become Frozen."}
	
	ANIMS.PilotLowSunlight = Animation:new{
		Image = "effects/pilot_low_sunlight.png",
		NumFrames = 11,
		Time = 0.15,
		PosX = -56,
		PosY = -26,
	}

	ANIMS.PilotLowDust = Animation:new{
		Image = "effects/pilot_low_dust.png",
		NumFrames = 11,
		Time = 0.06,
		PosX = -35,
		PosY = -19,
	}

	ANIMS.PilotLowRain1 = Animation:new{
		Image = "effects/pilot_low_rain.png",
		NumFrames = 10,
		Time = 0.03,
		PosX = 0,
		PosY = -25,
	}

	for k = 2, 21 do
		local yvar = -25+0.5*(k-1)
		local xvar = math.random(-20,20)
		ANIMS["PilotLowRain".. k] = ANIMS.PilotLowRain1:new{
			PosX = xvar,
			PosY = yvar,
		}
	end
	
	self.selected = require(mod.scriptPath .."libs/selected")
	self.selected:init()
	
	Emitter_Pilot_Low4 = Emitter:new{
		image = "effects/smoke/pilot_low_snow.png",
		fade_in = false,
		fade_out = false,
		max_alpha = 1,
		x = 0,
		y = -20,
		variance = 0,
		variance_x = 40,
		variance_y = 10,
		angle = 90,
		lifespan = 3.0,
		burst_count = 1,
		speed = 1.0,
		rot_speed = 0,
		gravity = false,
		birth_rate = 0.01,
		layer = LAYER_FRONT,
		angle_variance = 0,
	}
end

function this:load()
	self.selected:load()
	
	modApi:addPreEnvironmentHook(function(mission)
		if not mission.LowEnv1 then
			mission.LowEnv1 = true
			local LowSkillId
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				if Board:GetPawn(id):IsAbility(pilot.Skill) then
					LowSkillId = id
					if not Board:GetPawn(LowSkillId):IsDead()
					and Game:GetTurnCount() >= 1
					and Game:GetTurnCount() <= 4 then
						LowSkill:Weather(Board:GetPawnSpace(LowSkillId),id)
					end
				end
			end
		end
	end)
	
	modApi:addNextTurnHook(function(mission)
		mission.LowEnv1 = nil
	end)
	
	modApi:addMissionUpdateHook(function(mission)	
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility(pilot.Skill) then
				local point = Board:GetPawnSpace(id)
				if IsLowPawnSelected() and not GAME.InTestScenario then
					LowSkill:Mark(point)
				end
				if mission.LowSkillWeather then
					dir = Game:GetTurnCount()%4
					local point2 = point + DIR_VECTORS[dir]
					Board:AddBurst(point2, "Emitter_Pilot_Low4", DIR_NONE)
				end
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Low_1", {
		Odds = 10,
		{ main = "Pilot_Skill_Low_1" },
	})
end

return this