-- mission Mission_tosx_NewCrystals
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_NewCrystals = Mission_Infinite:new{
	Name = "Spreading Crystals",
	BonusPool = copy_table(missionTemplates.bonusNoMercy),
	UseBonus = true,
	Environment = "tosx_env_newcrystals",
	BlockedUnits = {"Jelly_Explode", "Dung"},
}

-- Add CEO dialog
local dialog = require(path .."missions/newcrystals_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_NewCrystals", dialogTable)
end

function Mission_tosx_NewCrystals:StartMission()
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end
end

modApi:appendAsset("img/combat/tosx_crysmine.png", mod.resourcePath.."img/combat/crysmine.png")
Location["combat/tosx_crysmine.png"] = Point(-16,1)
modApi:appendAsset("img/combat/icons/icon_tosx_crysmine_glow.png", mod.resourcePath.."img/combat/icons/icon_crysmine_glow.png")
Location["combat/icons/icon_tosx_crysmine_glow.png"] = Point(-13,18)

local mine_damage = SpaceDamage(DAMAGE_DEATH)
mine_damage.sSound = "/props/exploding_mine"
mine_damage.sAnimation = "tosx_explocrysmain"--crystal energy explosion

tosx_CrysMine = {
	Image = "combat/tosx_crysmine.png",
	Damage = mine_damage,
	Tooltip = "tosx_crysmine",
	Icon = "combat/icons/icon_tosx_crysmine_glow.png",
	UsedImage = ""
	}
    
TILE_TOOLTIPS[tosx_CrysMine.Tooltip] = {"Volatile Crystal", "Any unit that steps on this space will detonate the crystal and be killed."}

tosx_env_newcrystals = Env_Attack:new{    
	Name = "Spreading Crystals",--TipTitle; name whenever mousing over
	Decription = "Volatile crystals will emerge on this tile. Anything that steps on them will be destroyed.",--tile mouseover description
	StratText = "SPREADING CRYSTALS",--name that appears on mission select screen
	TipText = "Volatile crystals will emerge across the map. Anything that steps on them will be destroyed.",--TipText; description that appears on mission select screen
	CombatName = "NEW CRYSTALS",--name that appears by turn order
	Text = "Volatile crystals will emerge from two spaces every turn.",--description that appears up by the turn order
	CombatIcon = "combat/tile_icon/tosx_icon_env_crysmines.png",
}

function tosx_env_newcrystals:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	Board:MarkSpaceDesc(space,"tosx_env_newcrystals_tile")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	end
end

function tosx_env_newcrystals:GetAttackEffect(location)	
	local effect = SkillEffect()
	
	local damage = SpaceDamage(location)
	damage.sAnimation = "tosx_crysmine_e"
    damage.sSound = "/enemy/digger_1/attack_queued"
	effect:AddDamage(damage)
    effect:AddSound("/props/freezing")
	
    effect:AddDelay(0.63)
	
	local damage1 = SpaceDamage(location)
    damage1.sItem = "tosx_CrysMine"
	effect:AddDamage(damage1)
	
	effect:AddDelay(0.75)	
	
	return effect
end

local function goodspot(point)
    return Board:IsValid(point) and
           (not Board:IsItem(point)) and
           (not Board:IsBuilding(point)) and
           Board:GetTerrain(point) == TERRAIN_ROAD or
           Board:GetTerrain(point) == TERRAIN_FOREST or
           Board:GetTerrain(point) == TERRAIN_SAND
end

function tosx_env_newcrystals:SelectSpaces()
	local ret = {}
    
    local mines = {}
	local quarters = Environment:GetQuarters()
	
	for i,options in pairs(quarters) do
		local curr = Point(-1,-1)
		while #options > 0 and not goodspot(curr) do
            -- Pick again
			curr = random_removal(options)
		end
        if goodspot(curr) then
            mines[#mines+1] = curr
        end
	end
	for i = 1, 2 do
        if #mines > 0 then
            ret[#ret+1] = random_removal(mines)
        else
            break
        end
	end
    
	local effect = SkillEffect()
	local chance = math.random()
	if chance > 0.2 and Game:GetTurnCount() > 0 and #ret > 0 then
		effect:AddVoice("Mission_tosx_CrysGrowth", -1)
	end
	Board:AddEffect(effect)	
    
	return ret
end

modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_crysmines.png", mod.resourcePath .."img/combat/tile_icon/icon_env_crysmines.png")
Location["combat/tile_icon/tosx_icon_env_crysmines.png"] = Point(-27,2) -- Needed for it to appear on tiles

TILE_TOOLTIPS.tosx_env_newcrystals_tile = {tosx_env_newcrystals.Name, tosx_env_newcrystals.Decription}
Global_Texts["TipTitle_".."tosx_env_newcrystals"] = tosx_env_newcrystals.Name
Global_Texts["TipText_".."tosx_env_newcrystals"] = tosx_env_newcrystals.TipText

modApi:appendAsset("img/effects/tosx_crysmine_e.png", mod.resourcePath.. "img/effects/crysmine_e.png")

local a = ANIMS
a.tosx_crysmine_e = Animation:new{
	Image = "effects/tosx_crysmine_e.png",
	NumFrames = 9,
	Time = 0.07,
	PosX = -16,
	PosY = 1,
	Layer = LAYER_FLOOR,
	Loop = false
}