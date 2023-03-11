local originalMove = {
	GetDescription = Move.GetDescription,
	GetTargetArea = Move.GetTargetArea,
	GetSkillEffect = Move.GetSkillEffect,
}

function Move:GetTargetArea(p1)
	local moveSkill = nil
	local namestring = "tosx_Deploy_Fighter"
	--if Board:GetPawn(p1):GetType():sub(1,namestring:len()) == namestring then
		--moveSkill = tosx_Deploy_FighterMove
	--end

	if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
		return moveSkill:GetTargetArea(p1)
	end

	return originalMove.GetTargetArea(self, p1)
end

function Move:GetSkillEffect(p1, p2)
	local moveSkill = nil
	--[[
	if Board:GetPawn(p1):GetPersonality() == "Drift" then
		moveSkill = DriftSkill
	elseif Board:GetPawn(p1):GetPersonality() == "Vanish" then
		moveSkill = VanishSkill
	elseif Board:GetPawn(p1):GetPersonality() == "Cricket" then
		moveSkill = CricketSkill
	elseif Board:GetPawn(p1):GetPersonality() == "Mara" then
		moveSkill = MaraSkill
	elseif Board:GetPawn(p1):GetPersonality() == "Cypher" then
		moveSkill = CypherSkill
	end
	--]]
	if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
		return moveSkill:GetSkillEffect(p1, p2)
	end
	
	return originalMove.GetSkillEffect(self, p1, p2)
end