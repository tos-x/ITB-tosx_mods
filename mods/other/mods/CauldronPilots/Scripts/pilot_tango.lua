local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local pilot = {
	Id = "Pilot_Tango",
	Personality = "Tango",
	Name = "Julia Takahashi",
	Sex = SEX_FEMALE,
	Skill = "TangoSkill",
	Voice = "/voice/bethany",
}

local function clearMissionData(mission)
	mission.TangoSkillUsed = nil
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Sniper", "Once per mission, deal 1 damage to any tile without ending Mech's turn."))
	
	-- art, icons, animations
	
	CaulP_repairApi:SetRepairSkill{		
		Weapon = "TangoSkill_Link",
		Icon = "img/weapons/repair_sniper.png",		
		IsActive = function(pawn)
			if not GAME then return false end
			local mission = GAME.GetMission and GetCurrentMission()
			if not mission then return false end
			return pawn:IsAbility(pilot.Skill) and not pawn:IsFrozen() and not mission.TangoSkillUsed
		end
	}

	---- Sniper ----
	TangoSkill_Link = Skill:new{
		Name = "Sniper",
		Description = "Once per mission, deal 1 damage to any tile without ending Mech's turn. Otherwise, Repair.",
		TipImage = {
			Unit = Point(2,3),
			Enemy = Point(2,0),
			Target = Point(2,0),
			Second_Origin = Point(2,3),
			Second_Target = Point(2,3),
		}
	}

	function TangoSkill_Link:GetTargetArea(p1)
		local mission = GetCurrentMission()
		if not mission then return end
		local ret = PointList()
		if not Board:GetPawn(p1):IsFrozen() and not mission.TangoSkillUsed then
			for i = 0,7 do
				for j = 0,7 do
					local loc = Point(i,j)
					if Board:IsValid(loc) then
						ret:push_back(loc)
					end
				end
			end
		else
			ret:push_back(p1)
		end
		return ret
	end

	function TangoSkill_Link:GetSkillEffect(p1, p2)
		local mission = GetCurrentMission()
		if not mission then return end

		local ret = SkillEffect()
		local damage = SpaceDamage(p1,0)

		if p1 == p2 then
			local damage = SpaceDamage(p1,-1)
			if Board:GetPawn(p2):IsAcid() then
				damage.iAcid = EFFECT_REMOVE
			end
			damage.iFire = EFFECT_REMOVE
			damage.iFrozen = EFFECT_REMOVE
			ret:AddDamage(damage)
		else
			--Trigger pilot dialogue
			if not IsTestMechScenario() then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Tango", cast)
				]])
			end
			ret:AddDelay(.3)

			local damage = SpaceDamage(p2,1)
			damage.sAnimation = "ExploArt1"
			damage.sSound = "/impact/generic/explosion"
			ret:AddDamage(damage)
			ret:AddDelay(0.3)
			ret:AddScript([[
				local self = Point(]].. p1:GetString() .. [[)
				Board:GetPawn(self):SetActive(true)
				Game:TriggerSound("/ui/map/flyin_rewards");
				Board:Ping(self, GL_Color(255, 255, 255));
			]])
			-- Only set the flag on the actual skill, not the tipimage
			if not IsTipImage() then
				ret:AddScript([[
					local mission = GetCurrentMission()
					mission.TangoSkillUsed = true
				]])--update!
			end
		end
		return ret
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
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Tango", {
		Odds = 50,
		{ main = "Pilot_Skill_Tango" },
	})
end

return this