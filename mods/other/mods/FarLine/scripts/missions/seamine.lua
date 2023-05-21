
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Seamine = Mission_Infinite:new{
	Name = "Sea Mines",
	MapTags = {"tosx_smallisland", "tosx_bigisland", "tosx_continent"},
	BonusPool = copy_table(missionTemplates.bonusNoMercyOrDebris),
	UseBonus = true,
	MineCount = 4,
}

-- Add CEO dialog
local dialog = require(path .."missions/seamine_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Seamine", dialogTable)
end

function Mission_tosx_Seamine:StartMission()
	local choices = {}
	local choicesB = {}
			
	local watertiles = self:GetTerrainList(TERRAIN_WATER)
	for i = 1, #watertiles do
		local p = watertiles[i]
		-- Find an open water tile, with no adjacent buildings, and 1 adjacent non-mountain/water (ground?) tile
		if not Board:IsBlocked(p, PATH_PROJECTILE) then
			local blocked = 0
			for dir = DIR_START, DIR_END do
				local p2 = p + DIR_VECTORS[dir]
				if Board:IsBuilding(p2) then
					blocked = 4
				elseif Board:GetTerrain(p2) == TERRAIN_WATER or
					   Board:GetTerrain(p2) == TERRAIN_MOUNTAIN or
					   not Board:IsValid(p2) then
					blocked = blocked + 1
				end
			end
			if blocked < 4 then
				if (x == 0 or x == 7) and (y == 0 or y == 7) then
					-- No corners
				elseif x == 0 or x == 7 or y == 0 or y == 7 then
					-- Edge tiles are backups
					choicesB[#choicesB+1] = p
				else
					choices[#choices+1] = p
				end
			end
		end
	end

	if #choices + #choicesB < self.MineCount then
		self.MineCount = #choices + #choicesB
	end
	--LOG("Mine tiles available: ",#choices + #choicesB,", placing ",self.MineCount," mines")
	
	for i = 1, self.MineCount do
		local choice
		if #choices ~= 0 then
			choice = random_removal(choices)
		else
			choice = random_removal(choicesB)
		end
		local mine = PAWN_FACTORY:CreatePawn("tosx_seamine1")
		Board:AddPawn(mine, choice)	
	end
end

tosx_seamine1 = Pawn:new{
	Name = "Sea Mine",
	Health = 1,
	Neutral = true,
	Massive = true,
	IgnoreSmoke = true,
	IgnoreFlip = true,
	SpaceColor = false,
	MoveSpeed = 0,
	Image = "tosx_seamine1",
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,	
	Minor = true,
	Mission = true,
	Tooltip = "tosx_seamine1_Death_Tooltip",
	IsDeathEffect = true,
}

function tosx_seamine1:GetDeathEffect(point)
	local ret = SkillEffect()
	local dam = SpaceDamage(point,DAMAGE_DEATH)
	dam.sAnimation = "ExploAir2"
	dam.sSound = "/impact/generic/explosion_large"
	ret:AddDamage(dam)
	
	for dir = DIR_START, DIR_END do
		local p2 = point + DIR_VECTORS[dir]
		local dam2 = SpaceDamage(p2,DAMAGE_DEATH)
		dam2.sAnimation = "explopush2_"..dir
		-- Death effects don't seem to be caught by skill builds, so for now hack this manually :(
		if Board:GetCustomTile(p2) == "tosx_whirlpool_0.png" then
			dam2.sScript = "tosx_WhirlpoolOff("..p2:GetString()..")"
		end
		ret:AddDamage(dam2)
	end
	
	return ret
end

tosx_seamine1_Death_Tooltip = SelfTarget:new{
	Name = "Explosive Charge",
	Description = "Kill anything adjacent upon death.",
	Class = "Death",
	TipImage = {
		Water = Point(2,2),
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "tosx_seamine1"
	}
}

function tosx_seamine1_Death_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(1)
	return ret
end

---------------------

modApi:appendAsset("img/units/mission/tosx_seamine1.png", mod.resourcePath .."img/units/mission/seamine1.png")
modApi:appendAsset("img/units/mission/tosx_seamine1_ns.png", mod.resourcePath .."img/units/mission/seamine1_ns.png")
modApi:appendAsset("img/units/mission/tosx_seamine1_w.png", mod.resourcePath .."img/units/mission/seamine1_w.png")

local a = ANIMS
a.tosx_seamine1 = a.BaseUnit:new{Image = "units/mission/tosx_seamine1.png", PosX = -8, PosY = 13}
a.tosx_seamine1w = a.tosx_seamine1:new{Image = "units/mission/tosx_seamine1_w.png", PosX = -9, PosY = 21}
a.tosx_seamine1a = a.tosx_seamine1:new{}
a.tosx_seamine1_ns = a.tosx_seamine1:new{Image = "units/mission/tosx_seamine1_ns.png"}