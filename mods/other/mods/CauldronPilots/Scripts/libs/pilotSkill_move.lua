local this = {}
this.PilotArea = {}
this.PilotSkill = {}

local originalMove = {
    GetDescription = Move.GetDescription,
    GetTargetArea = Move.GetTargetArea,
    GetSkillEffect = Move.GetSkillEffect,
}

function Move:GetTargetArea(p1)
    local moveSkill = nil
	
    if Pawn:IsMech() then
        local personalityId = Pawn:GetPersonality()
        for i, pilot in ipairs(this.PilotArea) do
            if personalityId == pilot.personalityId then
                moveSkill = pilot.moveSkill
            end
        end
    end

    if moveSkill ~= nil and moveSkill.GetTargetArea ~= nil then
        return moveSkill:GetTargetArea(p1)
    end
	
    return originalMove.GetTargetArea(self, p1)
end

function Move:GetSkillEffect(p1, p2)
    local moveSkill = nil
	
    if Pawn:IsMech() then
        local personalityId = Pawn:GetPersonality()
        for i, pilot in ipairs(this.PilotSkill) do
            if personalityId == pilot.personalityId then
                moveSkill = pilot.moveSkill
            end
        end
    end

    if moveSkill ~= nil and moveSkill.GetSkillEffect ~= nil then
        return moveSkill:GetSkillEffect(p1, p2)
    end

    return originalMove.GetSkillEffect(self, p1, p2)
end

function this.AddTargetArea(personalityId, moveSkill)
	assert(type(personalityId) == 'string')
    this.PilotArea[#this.PilotArea+1] = {
        personalityId = personalityId,
        moveSkill = moveSkill
    }
end

function this.AddSkillEffect(personalityId, moveSkill)
	assert(type(personalityId) == 'string')
    this.PilotSkill[#this.PilotSkill+1] = {
        personalityId = personalityId,
        moveSkill = moveSkill
    }
end

return this