local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath
local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local pilot = {
	Id = "Pilot_Baccarat",
	Personality = "Baccarat",
	Name = "Earl Deckard",
	Sex = SEX_MALE,
	Skill = "BaccaratSkill",
	Voice = "/voice/henry",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Cheap Trick", "Repair is replaced with a melee attack that kills wounded non-Massive enemies."))
	
	-- art, icons, animations
	
	CaulP_repairApi:SetRepairSkill{
		Weapon = "BaccaratSkill_Link",
		Icon = "img/weapons/repair_trick.png",		
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	---- Cheap Trick ----
	BaccaratSkill_Link = Skill:new{
		Name = "Cheap Trick",
		Description = "Damage an adjacent tile, killing wounded non-Massive enemies. Escape from Ice.",
		TipImage = {
			Unit = Point(2,3),
			Enemy_Damaged = Point(2,2),
			Target = Point(2,2),
		}
	}

	function BaccaratSkill_Link:GetTargetArea(p1)	
		local ret = PointList()
		local anysoldier = nil

		if Board:GetPawn(p1):IsFrozen() then
			ret:push_back(p1)
		end

		for dir = DIR_START, DIR_END do
			local target = p1 + DIR_VECTORS[dir]
			if Board:IsValid(target) then
				ret:push_back(target)
			end
		end
		return ret
	end

	function BaccaratSkill_Link:GetSkillEffect(p1, p2)
		local ret = SkillEffect()

		if p1 == p2 then
			local damage = SpaceDamage(p1,0)
			damage.iFrozen = EFFECT_REMOVE
			ret:AddDamage(damage)
		else
			local d = 1
			if Board:IsPawnSpace(p2) then
				local pawn = Board:GetPawn(p2)
				local currenthp = pawn:GetHealth()
				local maxhp = _G[pawn:GetType()].Health
				local ismassive = _G[pawn:GetType()].Massive
				
				if not IsTipImage() and not IsTestMechScenario() then
					-- First check for soldier psions (higher max hp)
					-- Soldier psions have no effect in test scenario, so skip that
					local anysoldier = false
					local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
					for i,id in pairs(foes) do
						local pawn2 = Board:GetPawn(id)
						if pawn2:GetType() == "Jelly_Health1" or pawn2:GetType() == "Jelly_Boss" then
							anysoldier = id
							--LOG("Soldier psion detected")
						end
					end			

					if anysoldier and pawn:GetId() ~= anysoldier then
						maxhp = maxhp + 1
					end
				end
				
				if not ismassive and (currenthp < maxhp) then
					d = DAMAGE_DEATH
				end
			end		
			
			local damage = SpaceDamage(p2, d)
			damage.sSound = "/impact/generic/explosion"
			damage.sAnimation = "SwipeClaw1"
			ret:AddDamage(damage)
			
			if d == DAMAGE_DEATH then
				ret:AddBounce(p2,4)
			end

			damage = SpaceDamage(p1, 0)
			damage.iFrozen = EFFECT_REMOVE
			ret:AddDamage(damage)

			--Trigger pilot dialogue
			if not IsTestMechScenario() and d == DAMAGE_DEATH then
				ret:AddScript([[
					local cast = { main = ]]..Pawn:GetId()..[[ }
					modapiext.dialog:triggerRuledDialog("Pilot_Skill_Baccarat", cast)
					SuppressDialog(1200,"VekKilled_Self")
					SuppressDialog(1200,"VekKilled_Obs")
				]])
			end
		end

		return ret
	end

end

function this:load()
	
	modapiext.dialog:addRuledDialog("Pilot_Skill_Baccarat", {
		Odds = 50,
		{ main = "Pilot_Skill_Baccarat" },
	})
end

return this