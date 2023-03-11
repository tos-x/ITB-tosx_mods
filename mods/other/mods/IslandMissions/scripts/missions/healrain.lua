-- mission Mission_tosx_Healrain

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Healrain"}
local corpMissions = require(path .."corpMissions")

Mission_tosx_Healrain = Mission_Infinite:new{
	Name = "Healing Rain",
	Environment = "tosx_env_healrain",
}

tosx_env_healrain = Env_Attack:new{
	Name = "Cleansing Rain",
	Decription = "Rain will wash off Fire and A.C.I.D. and heal 1 damage to any unit on this tile.",
	Text = "Rain will periodically fall, healing units.",
	StratText = "CLEANSING RAIN",
	CombatIcon = "combat/tile_icon/tosx_icon_env_healrain.png",
	CombatName = "RAIN",
	LastLoc = nil,
	Options = nil,
	Instant = true, -- Marks all spaces at same time
}

function Mission_tosx_Healrain:StartMission()
	Board:StopWeather()
end

function tosx_env_healrain:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	Board:MarkSpaceDesc(space,"tosx_env_healrain_tile")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	end
end

function tosx_env_healrain:ApplyEffect()
	
	local effect = SkillEffect()
	local damage = SpaceDamage(Point(0,0), -1)
	damage.sAnimation = ""
	damage.iFire = EFFECT_REMOVE
	
	local loc = self.LastLoc + Point(-1,-1)
	local weather = RAIN_NORMAL
	local script = "Board:SetWeather(5,"..weather..","..loc:GetString()..",Point(3,3),2)"
	effect:AddScript(script)
	--effect:AddSound("/props/snow_storm")
	effect:AddDelay(1)
	for i,v in ipairs(self.Locations) do
		damage.loc = v
		if Board:IsPawnSpace(v) then
			--damage.iAcid = EFFECT_REMOVE --won't work on pawn in acid water
			effect:AddScript([[
				Board:SetAcid(]]..v:GetString()..[[, false)
				Board:GetPawn(]]..v:GetString()..[[):SetAcid(false)
			]])
		else
			effect:AddScript("Board:SetAcid("..v:GetString()..", false)")
		end
		effect:AddDamage(damage)
	end
	effect.iOwner = ENV_EFFECT
	Board:AddEffect(effect)
	self.CurrentAttack = self.Locations
	self.Locations = {}
	
	return false
end

function tosx_env_healrain:SelectSpaces()
	LOG("a --")

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

function this:init(mod)
	TILE_TOOLTIPS.tosx_env_healrain_tile = {tosx_env_healrain.Name, tosx_env_healrain.Decription}
	Global_Texts["TipTitle_".."tosx_env_healrain"] = tosx_env_healrain.Name
	Global_Texts["TipText_".."tosx_env_healrain"] = tosx_env_healrain.Text
	
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_healrain.png", mod.resourcePath .."img/combat/icon_env_healrain.png")
	Location["combat/tile_icon/tosx_icon_env_healrain.png"] = Point(-27,2) -- Needed for it to appear on tiles
end

function this:load(mod, options, version)
	corpMissions.Add_Missions_High("Mission_tosx_Healrain", "Corp_Factory")
end

return this