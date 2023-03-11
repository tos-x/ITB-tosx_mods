local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Stranger",
	Personality = "Stranger",
	Name = "Stranger",
	Sex = SEX_MALE,
	Skill = "StrangerSkill",
	Voice = "/voice/archimedes",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Wastelander", "Vek spawning adjacent to Mech take 1 damage on arrival."))
	
	-- art, icons, animations

	StrangerSkill = {}

	-- Wastelander
	function StrangerSkill:Rune(p1,p2)
		local effect = SkillEffect()

		damage = SpaceDamage(p2,1)
		damage.sAnimation = "ExploArtCrab2"
		damage.sSound = "/impact/generic/explosion"
		effect:AddScript("Board:AddAlert(Point("..p1:GetString().."),'WASTELANDER')")
		effect:AddDamage(damage)
		--Trigger pilot dialogue
		if not IsTestMechScenario() then
			effect:AddScript([[
				local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Pilot_Skill_Stranger", cast)
			]])
		end
		Board:AddEffect(effect)
	end

end

function this:load()	
	modapiext:addPawnTrackedHook(function(mission, pawn)
		local p0 = pawn:GetSpace()
		for dir = DIR_START, DIR_END do
			local point = p0 + DIR_VECTORS[dir]
			if Board:IsValid(point) and Board:IsPawnSpace(point) then
				local pawn2 = Board:GetPawn(point)
				if not pawn2:IsDead() and pawn2:IsAbility(pilot.Skill) then						
					local reg = GetCurrentRegion(RegionData)
					if reg ~= nil then
						for i, a in ipairs(reg.player.map_data.spawn_ids) do 
							if a == pawn:GetId() then			
								StrangerSkill:Rune(point,p0)
							end
						end
					end
				end
			end
		end
	end)
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Stranger", {
		Odds = 10,
		{ main = "Pilot_Skill_Stranger" },
	})
end

return this