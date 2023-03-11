-- mission Mission_tosx_Earthquake

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Earthquake"}
local corpMissions = require(path .."corpMissions")

Mission_tosx_Earthquake = Mission_Infinite:new{
	Name = "Earthquake",
	MapTags = {"tosx_quake"},
	Environment = "tosx_env_quake",
	UseBonus = true
}

------------------------------------------------------------------------
tosx_env_quake = Env_Attack:new{
	Name = "Seismic Upheaval",
	Decription = "A Mountain will emerge from this tile. If a unit is present, it will die and prevent formation of the Mountain.",
	Text = "Mountains will emerge from 2 tiles every turn. Units in the way will be killed.",
	StratText = "SEISMIC UPHEAVAL",
	CombatIcon = "combat/tile_icon/tosx_icon_env_quake.png",
	CombatName = "UPHEAVAL",
	Damage = DAMAGE_DEATH,
}

function tosx_env_quake:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceDesc(space,"tosx_env_quake_tile", EFFECT_DEADLY)
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	end
end

function tosx_env_quake:GetAttackEffect(location)	
	local effect = SkillEffect()
	effect:AddBoardShake(0.6)
	effect:AddBounce(location, 2)
	
	local damage = SpaceDamage(location)
	damage.sSound = "/impact/dynamic/rock"
	damage.iFire = EFFECT_REMOVE
	damage.iSmoke = EFFECT_REMOVE
	
	if Board:IsValid(location) and not Board:IsBlocked(location,PATH_PROJECTILE) then
		damage.sAnimation = "tosx_sandmountain_emerge"
		
		effect:AddDamage(damage)
		effect:AddDelay(0.56)
		local damage2 = SpaceDamage(location)
		damage2.iTerrain = TERRAIN_MOUNTAIN
		effect:AddDamage(damage2)
	else
		damage.iDamage = self.Damage
		damage.sAnimation = "Mountain_Collapse"
		effect:AddDamage(damage)
	end
	
	effect:AddDelay(0.2)
	return effect
end

function tosx_env_quake:SelectSpaces()
	local ret = {}	
	local quarters = self:GetQuarters()
	local exclude1 = math.random(2)
	local exclude2 = math.random(2)+2
	
	for i,v in ipairs(quarters) do
		if i ~= exclude1 and i ~= exclude2 then
			local choice = random_removal(v)
			while (Board:IsTerrain(choice, TERRAIN_MOUNTAIN) or Board:IsSpawning(choice)) and #v > 1 do
				choice = random_removal(v)
			end
			
			ret[#ret+1] = choice
			Board:BlockSpawn(choice,BLOCKED_TEMP)
		end
	end
	
	return ret
end
------------------------------------------------------------------------

function this:init(mod)
	TILE_TOOLTIPS.tosx_env_quake_tile = {tosx_env_quake.Name, tosx_env_quake.Decription}
	Global_Texts["TipTitle_".."tosx_env_quake"] = tosx_env_quake.Name
	Global_Texts["TipText_".."tosx_env_quake"] = tosx_env_quake.Text
	
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_quake.png", mod.resourcePath .."img/combat/icon_env_quake.png")
	Location["combat/tile_icon/tosx_icon_env_quake.png"] = Point(-27,2) -- Needed for it to appear on tiles
	
	modApi:appendAsset("img/effects/tosx_mountain_0_rising.png", mod.resourcePath .."img/effects/mountain_0_rising.png")
	
	local a = ANIMS	
	
	a.tosx_sandmountain_emerge = Animation:new{
		Image = "effects/tosx_mountain_0_rising.png",
		NumFrames = 8,
		Time = 0.07,
		PosX = -28,
		PosY = -21,
		Layer = LAYER_FLOOR,
		Loop = false
	}

	for i = 0, 5 do
		modApi:addMap(mod.resourcePath .."maps/tosx_quake".. i ..".map")
	end
end

function this:load(mod, options, version)
	corpMissions.Add_Missions_High("Mission_tosx_Earthquake", "Corp_Desert")
end

return this