
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Kill an enemy with a Guided Missile", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Kill an enemy with a Guided Missile", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Kill an enemy with a Guided Missile", 1):Failed() end,
	[1] = function() return Objective("Kill an enemy with a Guided Missile", 1) end,
	default = function() return nil end,
}

Mission_tosx_Guided = Mission_Infinite:new{
	Name = "Guided Missiles",
	MapTags = {"tosx_rocky" , "mountain"},
	BonusPool = copy_table(missionTemplates.bonusNoMercy),
	Objectives = objAfterMission:case(1),
	UseBonus = true,
	Environment = "tosx_env_guided",
	SpawnStartMod = 1,
	SpawnMod = 1,
	Kills = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/guided_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Guided", dialogTable)
end

function Mission_tosx_Guided:UpdateObjectives()
	objInMission:case(math.min(self.Kills,1))
end

function Mission_tosx_Guided:GetCompletedObjectives()
	return objAfterMission:case(math.min(self.Kills,1))
end

modApi:appendAsset("img/effects/tosx_shotup_guided_missile.png", mod.resourcePath .."img/effects/shotup_guided_missile.png")
modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_guided.png", mod.resourcePath .."img/combat/tile_icon/icon_env_guided.png")
Location["combat/tile_icon/tosx_icon_env_guided.png"] = Point(-27,2) -- Needed for it to appear on tiles

-------------------------------------------------------------------- 
tosx_env_guided = Env_Attack:new{
	Name = "Guided Missiles",
	Text = "Guided missiles will strike enemies in target zones, as long as a Mech is present.",
	Decription = "A guided missile will kill any enemy on this tile, if a Mech enters this target zone.",
	Decription1 = "A guided missile will kill any enemy on this tile.",
	Decription2 = "This Mech is activating this target zone. Enemies in it will be killed by missiles.",
	StratText = "GUIDED MISSILES",
	CombatIcon = "combat/tile_icon/tosx_icon_env_guided.png",
	CombatName = "MISSILES",
	ShotUp = "effects/tosx_shotup_guided_missile.png"
}
	
TILE_TOOLTIPS.tosx_env_guided_tile = {tosx_env_guided.Name, tosx_env_guided.Decription}
TILE_TOOLTIPS.tosx_env_guided_tile1 = {tosx_env_guided.Name, tosx_env_guided.Decription1}
TILE_TOOLTIPS.tosx_env_guided_tile2 = {tosx_env_guided.Name, tosx_env_guided.Decription2}
Global_Texts["TipTitle_".."tosx_env_guided"] = tosx_env_guided.Name
Global_Texts["TipText_".."tosx_env_guided"] = tosx_env_guided.Text

function tosx_env_guided:IsActiveQuadrant(space)
	local spaces = self:GetAttackArea(space)
	for i,v in ipairs(spaces) do
		if Board:IsPawnSpace(v) and Board:GetPawnTeam(v) == TEAM_PLAYER and Board:GetPawn(v):IsMech() then
			return true
		end
	end
	return false
end

function tosx_env_guided:GetAttackArea(space)
	local ret = { space }
	for dir = DIR_START, DIR_END do
		ret[#ret+1] = space + DIR_VECTORS[dir]
	end

	return ret
end

function tosx_env_guided:MarkSpace(space, active)
	local spaces = self:GetAttackArea(space)
	local targeted = self:IsActiveQuadrant(space)
	
	for i,v in ipairs(spaces) do
		Board:MarkSpaceImage(v,self.CombatIcon, GL_Color(230,162,21,0.75))
		Board:MarkSpaceDesc(v,"tosx_env_guided_tile")
		
		if targeted then
			Board:MarkSpaceImage(v,self.CombatIcon, GL_Color(255,42,0,0.75))
			Board:MarkSpaceDesc(v,"tosx_env_guided_tile1")	
			if Board:IsPawnSpace(v) then
				if Board:GetPawnTeam(v) == TEAM_PLAYER and Board:GetPawn(v):IsMech() then
					Board:MarkSpaceDesc(v,"tosx_env_guided_tile2")
				elseif Board:GetPawnTeam(v) == TEAM_ENEMY then
					Board:MarkSpaceDesc(v,"tosx_env_guided_tile1", EFFECT_DEADLY)			
				end
			end
		end
	end
end

function tosx_env_guided:GetAttackEffect(location)
	local effect = SkillEffect()
	if not self:IsActiveQuadrant(location) then return effect end
	
	local spaces = self:GetAttackArea(location)
	for i,v in ipairs(spaces) do
		if Board:IsPawnSpace(v) and Board:GetPawnTeam(v) == TEAM_ENEMY then
			effect:AddSound("/weapons/heavy_rocket")
			damage = SpaceDamage(v,DAMAGE_DEATH)
			
			damage.sAnimation = "ExploAir2"
			damage.sSound = "/impact/generic/explosion_large"
			effect:AddArtillery(damage, self.ShotUp, NO_DELAY)

			effect:AddDelay(1)
			
			effect:AddScript([[
				if not Board:IsPawnAlive(]]..Board:GetPawn(v):GetId()..[[) then
					GetCurrentMission().Kills = GetCurrentMission().Kills + 1
					
					local effect = SkillEffect()
					local chance = math.random()
					if chance > 0.3 then
						effect:AddVoice("Mission_tosx_GuidedKill", -1)
					end
					Board:AddEffect(effect)						
				end
				]])
		end
	end
			
	return effect
end

function tosx_env_guided:IsValidTarget(space)
	return Board:GetTerrain(space) ~= TERRAIN_BUILDING and not Board:GetTerrain(space) ~= TERRAIN_MOUNTAIN
end

function tosx_env_guided:SelectSpaces()

	local ret = {}
	
	local start = Point(3,2)
	
	local choices = {}
	for i = start.x, (start.x + 2) do
		for j = start.y, (start.y + 3) do
			local spaces = self:GetAttackArea(Point(i,j))
			local valid = true
			for i,v in ipairs(spaces) do
				valid = valid and self:IsValidTarget(v)
			end
			if valid then choices[#choices+1] = Point(i,j) end
		end
	end
	
	-- To be safe, add more y options if we haven't found anything
	if #choices == 0 then
		for i = start.x, (start.x + 2) do
			for j = 1, 6, 5 do --Only adds y = 1 and y = 6
				local spaces = self:GetAttackArea(Point(i,j))
				local valid = true
				for i,v in ipairs(spaces) do
					valid = valid and self:IsValidTarget(v)
				end
				if valid then choices[#choices+1] = Point(i,j) end
			end
		end
	end

	if #choices ~= 0 then 
		ret[1] = random_removal(choices)
	end

	return ret
end