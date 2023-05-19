--v2
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")
local worldConstants = require(path .."libs/worldConstants")

Mission_tosx_Waves = Mission_Infinite:new{
	Name = "Waves",
	MapTags = {"tosx_waves"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = true,
	Environment = "tosx_env_waves",
	Zones = nil,
}

function Mission_tosx_Waves:StartMission()
	self.Zones = {}
	for i = 1, 4 do
		local zone = extract_table(Board:GetZone("wave"..i-1))
		if zone and #zone > 0 then
			self.Zones[#self.Zones + 1] = i-1
		end
	end
end

-- Add CEO dialog
local dialog = require(path .."missions/waves_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Waves", dialogTable)
end

for i = 0, 3 do
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_wave"..i..".png", mod.resourcePath .."img/combat/tile_icon/icon_env_wave"..i..".png")
	Location["combat/tile_icon/tosx_icon_env_wave"..i..".png"] = Point(-27,2) -- Needed for it to appear on tiles
end
modApi:appendAsset("img/effects/tosx_shot_wave_U.png", mod.resourcePath.. "img/effects/shot_wave_U.png")
modApi:appendAsset("img/effects/tosx_shot_wave_R.png", mod.resourcePath.. "img/effects/shot_wave_R.png")

modApi:appendAsset("img/effects/tosx_splashw0.png",mod.resourcePath.."img/effects/splashw0.png")
modApi:appendAsset("img/effects/tosx_splashw1.png",mod.resourcePath.."img/effects/splashw1.png")
modApi:appendAsset("img/effects/tosx_splashw2.png",mod.resourcePath.."img/effects/splashw2.png")
modApi:appendAsset("img/effects/tosx_splashw3.png",mod.resourcePath.."img/effects/splashw3.png")

local a = ANIMS
a.tosx_splashw0 = Animation:new{
	Image = "effects/tosx_splashw0.png",
	PosX = -22,
	PosY = -11,
	Time = 0.09,
	NumFrames = 7
}
a.tosx_splashw1 = a.tosx_splashw0:new{
	Image = "effects/tosx_splashw1.png",
	PosX = -22,
	PosY = 6,
}
a.tosx_splashw2 = a.tosx_splashw0:new{
	Image = "effects/tosx_splashw2.png",
	PosX = -38,
	PosY = 6,
}
a.tosx_splashw3 = a.tosx_splashw0:new{
	Image = "effects/tosx_splashw3.png",
	PosX = -38,
	PosY = -11,
}

tosx_env_waves = Env_Attack:new{
	Name = "Tsunami",
	Text = "Waves will surge across the map each turn, pushing the first tile they hit.",
	LastDir = nil,
	Tiles = nil,
	Decription = "A wave will surge across the map from this tile, pushing the first thing it hits.",
	StratText = "TSUNAMI",
	CombatIcon = "combat/tile_icon/tosx_icon_env_wave3.png",
	CombatName = "TSUNAMI",
}

TILE_TOOLTIPS.tosx_env_waves_tile = {tosx_env_waves.Name, tosx_env_waves.Decription}
Global_Texts["TipTitle_".."tosx_env_waves"] = tosx_env_waves.Name
Global_Texts["TipText_".."tosx_env_waves"] = tosx_env_waves.Text


function tosx_env_waves:MarkSpace(space, active)
	for i = 1, #self.Tiles do
		local p = self.Tiles[i]
		if Board:GetTerrain(p) == TERRAIN_WATER then
			local icon = "combat/tile_icon/tosx_icon_env_wave"..self.LastDir..".png"
			Board:MarkSpaceImage(p,icon, GL_Color(255,226,88,0.75))
			Board:MarkSpaceDesc(p,"tosx_env_waves_tile")
		end
	end
end

function tosx_env_waves:GetAttackEffect(location)
	local effect = SkillEffect()
	
	local waters = {}
	for i = 1, #self.Tiles do
		local p = self.Tiles[i]
		if Board:GetTerrain(p) == TERRAIN_WATER then
			waters[#waters + 1] = p
		end
	end
	if #waters == 0 then return effect end
		
	local dir = self.LastDir
	
	effect:AddBoardShake(3)
	effect:AddSound("/props/tide_flood") 
	
	local farthest = 0
	local dists = {}
	for i = 1, #waters do
		local p = waters[i]
		if Board:GetTerrain(p) ~= TERRAIN_WATER then break end
	
		
		local p2 = p + DIR_VECTORS[dir]
		local target = GetProjectileEnd(p,p2)
		if Board:IsBlocked(p, PATH_PROJECTILE) then
			target = p
		end
			
		local d = SpaceDamage(target,0,dir) 
		d.sAnimation = "tosx_splashw"..dir
		d.sSound = "/props/water_splash" 
		
		if p == target then
			effect:AddDamage(d)
			dists[#dists + 1] = 0
		else
			farthest = math.max(farthest, p:Manhattan(target))
			dists[#dists + 1] = p:Manhattan(target)
			
			worldConstants:setSpeed(effect, 0.2)
			effect:AddProjectile(p,d,"effects/tosx_shot_wave",NO_DELAY) 
			worldConstants:resetSpeed(effect)
		end
	end
	
	for d = 0, farthest do
		for i = 1, #waters do
			if dists[i] >= d then
				local p = waters[i] + DIR_VECTORS[dir] * d
				effect:AddBounce(p,6)
			end
		end
		effect:AddDelay(0.28)
	end
	
	return effect
end

function tosx_env_waves:IsCorner(point)
	if (point.x == 0 or point.x == 7) and
	   (point.y == 0 or point.y == 7) then
		return true
	end
	return false
end

function tosx_env_waves:SelectSpaces()
	self.Tiles = {}
	local mission = GetCurrentMission()
	local choices = {}
	for i = 1, #mission.Zones do
		-- exclude last turn's zone, unless there's only 1 available
		if self.LastDir ~= mission.Zones[i] or #mission.Zones < 2 then
			choices[#choices + 1] = mission.Zones[i]
		end
	end
	local choice = random_removal(choices)
	
	-- grab 4 random tiles from this zone
	local zones = extract_table(Board:GetZone("wave"..choice))
	local count = 4
	while #zones > 0 and count > 0 do
		local p = random_removal(zones)
		-- exclude corners unless we need more tiles to make our count
		if not self:IsCorner(p) or #zones <= count then
			self.Tiles[#self.Tiles+1] = p
			count = count - 1
		end
	end
	
	self.LastDir = choice
	return {self.Tiles[1]} -- just grab a point; we're going to apply them all at once
end