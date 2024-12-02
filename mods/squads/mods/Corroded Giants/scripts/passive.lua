local updateHook = function(mission)
	if Board:IsBusy() or (not IsPassiveSkill("tosx_PassiveE_Smokeacid")) then
		return
	end
    local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
	for i, id in ipairs(foes) do
        if Board:IsSmoke(Board:GetPawnSpace(id)) and not Board:GetPawn(id):IsAcid() and not Board:GetPawn(id):IsShield() then
            Board:GetPawn(id):SetAcid(true)
        end
    end
end

local function onModsLoaded()
	modApi:addMissionUpdateHook(updateHook)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)