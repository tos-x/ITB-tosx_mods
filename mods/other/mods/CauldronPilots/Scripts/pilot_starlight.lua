local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Starlight",
	Personality = "Starlight",
	Name = "Andromeda McLear",
	Sex = SEX_FEMALE,
	Skill = "StarlightSkill",
	Voice = "/voice/camila",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Orbital Strike", "Wounds up to 3 Vek at start of missions."))
	
	-- art, icons, animations
	modApi:appendAsset("img/effects/explo_raining_orbital1.png",mod.resourcePath.."img/effects/explo_raining_orbital1.png")

	ANIMS.PilotStarlightRain = Animation:new{
		Image = "effects/explo_raining_orbital1.png",
		NumFrames = 10,
		Time = 0.075,
		PosX = -20,
		PosY = -38
	}

	StarlightSkill = {}
	
	-- Orbital Strike
	function StarlightSkill:Marking(p1)
		local ret = SkillEffect()
		local damage = SpaceDamage(p1,0)
		local anymarking = 0

		local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
		-- First check each pawn to find the psions
		for i,id in pairs(foes) do
			local pawn = Board:GetPawn(id)
			if anymarking < 3 then
				if pawn:GetType():sub(1,5) == "Jelly" and
				pawn:GetHealth() > 1 and
				not pawn:IsFrozen() then
					if anymarking == 0 then -- Add before first target only
						ret:AddScript("Board:AddAlert(Point("..p1.x..","..p1.y.."),'ORBITAL STRIKE')")
					end
					--LOG("Psion detected on ".. pawn:GetSpace():GetString())
					if pawn:IsArmor() and not pawn:IsAcid() then
						damage = SpaceDamage(Board:GetPawnSpace(id),2)
					else
						damage = SpaceDamage(Board:GetPawnSpace(id),1)
					end
					damage.sAnimation = "PilotStarlightRain"
					damage.iFire = EFFECT_REMOVE -- Hopefully stop forest fires? In case
					ret:AddDamage(damage)
					damage.sSound = "/impact/generic/explosion"
					ret:AddDelay(0.3)
					anymarking = anymarking + 1
				end
			end
		end

		-- Now, grab vek ids (not: bots, volatile, 1hp, frozen) until 3 are marked
		for i,id in pairs(foes) do
			local pawn = Board:GetPawn(id)
			if anymarking < 3 then
				if pawn:GetType():sub(1,5) ~= "Jelly" and
				pawn:GetTeam() ~= TEAM_BOTS and
				pawn:GetType():sub(1,7) ~= "Glowing" and -- Volatile Vek
				pawn:GetHealth() > 1 and
				not pawn:IsFrozen() then
					if anymarking == 0 then -- Add before first target only
						ret:AddScript("Board:AddAlert(Point("..p1.x..","..p1.y.."),'ORBITAL STRIKE')")
					end
					if pawn:IsArmor() and not pawn:IsAcid() then
						damage = SpaceDamage(Board:GetPawnSpace(id),2)
					else
						damage = SpaceDamage(Board:GetPawnSpace(id),1)
					end
					damage.sAnimation = "PilotStarlightRain"
					damage.iFire = EFFECT_REMOVE -- Hopefully stop forest fires? In case
					ret:AddDamage(damage)
					damage.sSound = "/impact/generic/explosion"
					ret:AddDelay(0.3)
					anymarking = anymarking + 1
				end
			end
		end
		if anymarking > 0 then
			Board:AddEffect(ret)
		end
	end

end

function this:load()	
	modApi:addNextTurnHook(function(mission)
		if Game:GetTurnCount() == 0 then		
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				if Board:GetPawn(id):IsAbility(pilot.Skill) then
					if not Board:GetPawn(id):IsDead() then
						StarlightSkill:Marking(Board:GetPawnSpace(id))
					end
				end
			end
		end
	end)
end

return this