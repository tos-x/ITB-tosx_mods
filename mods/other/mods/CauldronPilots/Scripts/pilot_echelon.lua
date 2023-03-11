local this = {}

local path = mod_loader.mods[modApi.currentMod].scriptPath

local pilot = {
	Id = "Pilot_Echelon",
	Personality = "Echelon",
	Name = "Esther Martin",
	Sex = SEX_FEMALE,
	Skill = "EchelonSkill",
	Voice = "/voice/camila",
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Mentor", "Squad Pilots gain +2 bonus XP at the end of each mission."))
	
	-- art, icons, animations
	PawnXP2 = 
		{
			Name = "2XP",
			Health = 2,
			MoveSpeed = 1,
			Image = "scarab",
			DefaultTeam = TEAM_ENEMY,
		}
		
	AddPawn("PawnXP1") 

	PawnXP1 = 
		{
			Name = "1XP",
			Health = 1,
			MoveSpeed = 1,
			Image = "scarab",
			DefaultTeam = TEAM_ENEMY,
		}
		
	AddPawn("PawnXP2") 

	EchelonSkill = {}

	-- Mentor
	function EchelonSkill:Teaching()
		local anysoldier = nil

		-- First check for soldier/abomination psions, just in case one doesn't retreat?
		local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
		for i,id in pairs(foes) do
			local pawn = Board:GetPawn(id)
			if pawn:GetType():sub(1,5) == "Jelly_Health1" or pawn:GetType():sub(1,5) == "Jelly_Boss" then
				anysoldier = true
				--LOG("Soldier psion detected")
			end
		end

		-- Give each non-AI mech a kill
		local mechs = extract_table(Board:GetPawns(TEAM_MECH))
		for i, id in ipairs(mechs) do
			local pawn = Board:GetPawn(id)
			if pawn:GetPersonality() ~= "Artificial" and not pawn:IsDead() then
				if anysoldier then
					local pawnxp = PAWN_FACTORY:CreatePawn("PawnXP1")
					Board:AddPawn(pawnxp,Board:GetPawnSpace(pawn:GetId()))
					pawnxp:Kill(true)
				else
					local pawnxp = PAWN_FACTORY:CreatePawn("PawnXP2")
					Board:AddPawn(pawnxp,Board:GetPawnSpace(pawn:GetId()))
					pawnxp:Kill(true)
				end
			end
		end
	end

end

function this:load()
	modApi:addMissionEndHook(function(mission)
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility(pilot.Skill) then
				if not Board:GetPawn(id):IsDead() then
					EchelonSkill:Teaching()
				end
			end
		end
	end)
end

return this