
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Battlefield = Mission_Infinite:new{
	Name = "Old Battlefield",
	BonusPool = copy_table(missionTemplates.bonusNoMercy),
	UseBonus = true,
	SpawnMod = 2,
	SpawnStartMod = 1,
}

-- Add CEO dialog
local dialog = require(path .."missions/battlefield_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Battlefield", dialogTable)
end

-- PawnTrackedHook doesn't seem to catch starting spawns
-- Neither does StartMission()
function Mission_tosx_Battlefield:UpdateMission()
	if Game:GetTurnCount() == 0 and Game:GetTeamTurn() == TEAM_ENEMY then
		local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
		for i,id in pairs(foes) do
			local pawn = Board:GetPawn(id)
			local hp = math.max(1,pawn:GetMaxHealth() - 2)
			if pawn:GetHealth() > hp then
				--LOG("UPDATE Setting pawn ",pawn:GetId()," (type: ",pawn:GetType(),") to hp: ",hp)
				pawn:SetHealth(hp)
			end
		end
	end
end

-- Have to do this via a hook, because adjusting the spawn functions won't save the
-- pawn:SetHealth() change to spawns if game is quit and restarted
local function onTracked(mission, pawn)
	if not mission or not pawn or mission.ID ~= "Mission_tosx_Battlefield" then return end
	local reg = GetCurrentRegion(RegionData)
	if reg ~= nil then
		for i, a in ipairs(reg.player.map_data.spawn_ids) do 
			if a == pawn:GetId() then
				local hp = math.max(1,pawn:GetHealth() - 2)
				--LOG("Setting pawn ",pawn:GetId()," (type: ",pawn:GetType(),") to hp: ",hp)
				pawn:SetHealth(hp)
			end
		end
	end
	
end

local function onModsLoaded()
	modapiext:addPawnTrackedHook(onTracked)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)