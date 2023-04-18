
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local boardEvents = require(path .."libs/boardEvents")
require(path .."libs/queuedBoost")
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_BoostMine = Mission_MineBase:new{
	Name = "Boost Mines",
	MineType = "tosx_Boost_Mine",
	BonusPool = copy_table(missionTemplates.bonusAll),
	MapTags = {"tosx_rocky" , "mountain"},
}

-- Add CEO dialog
local dialog = require(path .."missions/boostmine_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_BoostMine", dialogTable)
end

-- Rocks get created before mines; clear them on mine tiles at start
local oldStartMission = Mission_tosx_BoostMine.StartMission
function Mission_tosx_BoostMine:StartMission()
	oldStartMission(self)
	for i = 1, 6 do
		for j = 1, 6 do
			if Board:IsItem(Point(i,j)) then
				Board:SetCustomTile(Point(i,j),"")
			end
		end
	end
end

modApi:appendAsset("img/combat/tosx_boost_mine.png", mod.resourcePath.."img/combat/boost_mine.png")
Location["combat/tosx_boost_mine.png"] = Point(-14,-4)
modApi:appendAsset("img/combat/icons/icon_tosx_boostmine_glow.png", mod.resourcePath.."img/combat/icons/icon_boostmine_glow.png")
Location["combat/icons/icon_tosx_boostmine_glow.png"] = Point(-13,13)

local mine_damage = SpaceDamage(0)
--mine_damage.iFrozen = EFFECT_REMOVE	--Need something or the sImageMark doesn't appear; leave as hidden feature
mine_damage.iCrack = EFFECT_REMOVE	--Need something or the sImageMark doesn't appear; cracks destroy items so it should never happen

tosx_Boost_Mine = {
	Image = "combat/tosx_boost_mine.png",
	Damage = mine_damage,
	Tooltip = "tosx_boost_mine",
	Icon = "combat/icons/icon_tosx_boostmine_glow.png",
	UsedImage = ""
	}

boardEvents.onItemRemoved:subscribe(function(loc, removed_item)
    if removed_item == "tosx_Boost_Mine"  then
        local pawn = Board:GetPawn(loc)
        if pawn then
			local mine_damage = SpaceDamage(loc)
			mine_damage.sScript = "Board:GetPawn("..loc:GetString().."):SetBoosted(true)"
			Board:DamageSpace(mine_damage)
        end
    end
end)

TILE_TOOLTIPS[tosx_Boost_Mine.Tooltip] = {"Boost Mine", "Any unit that steps on this space will trigger the mine and gain Boosted."}
