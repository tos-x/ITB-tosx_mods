
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Shieldstorm = Mission_Infinite:new{
	Name = "Shield Storm",
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = true,
	Environment = "tosx_env_shieldstorm",
}

-- Add CEO dialog
local dialog = require(path .."missions/shieldstorm_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Shieldstorm", dialogTable)
end

tosx_env_shieldstorm = Env_Attack:new{
	Name = "Shield Storm",--TipTitle; name whenever mousing over
	Decription = "Fluctuating energies cause anything present to gain a Shield.",--tile mouseover description
	StratText = "SHIELD STORM",--name that appears on mission select screen
	TipText = "Large areas of the map will periodically be Shielded.",--TipText; description that appears on mission select screen
	CombatName = "SHIELD STORM",--name that appears by turn order
	Text = "Marked tiles will be Shielded at the start of the enemy turn.",--description that appears up by the turn order
	CombatIcon = "combat/tile_icon/tosx_icon_env_shieldstorm.png",
	LastLoc = nil,
	Options = nil,
	Instant = true, -- Marks all spaces at same time
}

function tosx_env_shieldstorm:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	Board:MarkSpaceDesc(space,"tosx_env_shieldstorm_tile")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	end
end

function tosx_env_shieldstorm:ApplyEffect()
	local effect = SkillEffect()
    
	effect:AddSound("/weapons/enhanced_tractor")
    effect:AddSound("/ui/battle/resisted")
    
	local damage0 = SpaceDamage(self.LastLoc)
    damage0.sAnimation = "tosx_explo_shield"
    effect:AddDamage(damage0)
    effect:AddDelay(0.3)
    
	local damage = SpaceDamage(Point(0,0))
	damage.iShield = EFFECT_CREATE
	for i,v in ipairs(self.Locations) do
		damage.loc = v
		effect:AddDamage(damage)
	end
	effect.iOwner = ENV_EFFECT
	Board:AddEffect(effect)
	self.CurrentAttack = self.Locations
	self.Locations = {}
	
	return false
end

function tosx_env_shieldstorm:SelectSpaces()

	if self.Options == nil or #self.Options == 0 then
		self.Options = { Point(3,2), Point(3,5), Point(2,3), Point(5,3)}
	end
	
	self.LastLoc = random_removal(self.Options)
		
	local ret = {self.LastLoc}
	for i = DIR_START, DIR_END do
		local locs = {self.LastLoc + DIR_VECTORS[i],self.LastLoc + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]}
		for j, point in ipairs(locs) do
			ret[#ret+1] = point
		end
	end
		
	return ret
end

TILE_TOOLTIPS.tosx_env_shieldstorm_tile = {tosx_env_shieldstorm.Name, tosx_env_shieldstorm.Decription}
Global_Texts["TipTitle_".."tosx_env_shieldstorm"] = tosx_env_shieldstorm.Name
Global_Texts["TipText_".."tosx_env_shieldstorm"] = tosx_env_shieldstorm.TipText

modApi:appendAsset("img/effects/tosx_explo_pulse_shield.png", mod.resourcePath .."img/effects/explo_pulse_shield.png")

modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_shieldstorm.png", mod.resourcePath .."img/combat/tile_icon/icon_env_shieldstorm.png")
Location["combat/tile_icon/tosx_icon_env_shieldstorm.png"] = Point(-27,2) -- Needed for it to appear on tiles

local a = ANIMS
a.tosx_explo_shield = Animation:new{
	Image = "effects/tosx_explo_pulse_shield.png",
	NumFrames = 8,
	Time = 0.075,
	PosX = -40,
	PosY = -20
}