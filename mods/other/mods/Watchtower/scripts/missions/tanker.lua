
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")

Mission_tosx_Tanker = Mission_Infinite:new{
	Name = "Fill the Tanker",
	MapTags = {"tosx_puddles"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	Objectives = Objective("Siphon 4 Water tiles", 2),
	BlockedUnits = {"Leaper", "Dung", "Spider", "Digger"}, --Try to minimize chokepoints
	UseBonus = false,
	TankerId = -1,
	Siphon = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/tanker_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Tanker", dialogTable)
end

function Mission_tosx_Tanker:StartMission()
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end
	
	local tanker = PAWN_FACTORY:CreatePawn("tosx_Tanker1")
	self.TankerId = tanker:GetId()
	Board:AddPawn(tanker)
end

function Mission_tosx_Tanker:IsTankerAlive()
	return Board:GetPawn(self.TankerId) ~= nil and Board:IsPawnAlive(self.TankerId)
end

function Mission_tosx_Tanker:UpdateObjectives()
	local status = self.Siphon >= 4 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Siphon 4 Water tiles\n("..tostring(self.Siphon).." / 4)", status, REWARD_REP, 2)
end

function Mission_tosx_Tanker:GetCompletedObjectives()
	local status = 0
	if self.Siphon >= 2 then status = 1 end
	if self.Siphon >= 4 then status = 2 end
	return Objective("Siphon 4 Water tiles ("..tostring(self.Siphon).." / 4)", status, 2)
end

function Mission_tosx_Tanker:GetCompletedStatus()
	if self.Siphon > 3 and self:IsTankerAlive() then
		return "Success"
	elseif self.Siphon > 3 and not self:IsTankerAlive() then
		return "Dead"
	else
		return "Failure"
	end
end
-- example of briefing entry: Mission_tosx_Upgrader_Dead_CEO_Watchtower_1
-- "Dead" is the status


modApi:appendAsset("img/effects/tosx_drain_a.png",mod.resourcePath.."img/effects/tosx_drain_a.png")
modApi:appendAsset("img/effects/tosx_drain_a_acid.png",mod.resourcePath.."img/effects/tosx_drain_a_acid.png")
modApi:copyAsset("img/combat/icons/icon_water_immune_glow.png", "img/combat/icons/tosx_create_water_icon_glowX.png")
Location["combat/icons/tosx_create_water_icon_glowX.png"] = Point(-13,10)

modApi:appendAsset("img/units/mission/tosx_tanker.png", mod.resourcePath.."img/units/mission/tanker.png")
modApi:appendAsset("img/units/mission/tosx_tanker_ns.png", mod.resourcePath.."img/units/mission/tanker_ns.png")
modApi:appendAsset("img/units/mission/tosx_tankera.png", mod.resourcePath.."img/units/mission/tankera.png")
modApi:appendAsset("img/units/mission/tosx_tankerd.png", mod.resourcePath.."img/units/mission/tankerd.png")

modApi:appendAsset("img/weapons/tosx_tanker_siphon.png", mod.resourcePath.."img/weapons/tanker_siphon.png")

local a = ANIMS
a.tosx_tanker = a.BaseUnit:new{Image = "units/mission/tosx_tanker.png", PosX = -21, PosY = 0}
a.tosx_tankera = a.tosx_tanker:new{Image = "units/mission/tosx_tankera.png", NumFrames = 2, Time = 0.5}
a.tosx_tankerd = a.tosx_tanker:new{Image = "units/mission/tosx_tankerd.png", PosX = -19, PosY = 1, NumFrames = 11, Time = 0.12, Loop = false }
a.tosx_tanker_ns = a.tosx_tanker:new{Image = "units/mission/tosx_tanker_ns.png"}

a.tosx_drain_anim = Animation:new{
	Image = "effects/tosx_drain_a.png",
	PosX = -29,
	PosY = 1,
	Time = 0.05,
	NumFrames = 13
}

a.tosx_drain_anim_acid = a.tosx_drain_anim:new{
	Image = "effects/tosx_drain_a_acid.png",
}

tosx_Tanker1 = {
	Name = "Water Tanker",
	Health = 2,
	MoveSpeed = 5,
	Neutral = false,
	IgnoreFire = true,
	IgnoreSmoke = true,
	Image = "tosx_tanker",
	SkillList = { "tosx_Tanker_Siphon" },
	SoundLocation = "/support/civilian_tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true
}
AddPawn("tosx_Tanker1")

tosx_Tanker_Siphon = Skill:new{
	Name = "Water Siphon",
	Description = "Siphon an adjacent Water tile.",
	Icon = "weapons/tosx_tanker_siphon.png",
	Damage = 0,
	PathSize = 7,
	LaunchSound = "/props/tide_flood",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "tosx_Tanker1",
	}
}

function tosx_Tanker_Siphon:GetTargetArea(p1)
	-- Needed for TipImage to show water
	if Board:IsTipImage() and Board:GetTerrain(Point(2,1)) ~= TERRAIN_WATER then
		Board:SetTerrain(Point(2,1), TERRAIN_WATER)
	end
	
	local ret = PointList()

	local pathing = Pawn:GetPathProf()
	
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		if Board:GetTerrain(curr) == TERRAIN_WATER and not Board:IsTerrain(curr,TERRAIN_LAVA) then
			ret:push_back(curr)
		end
	end
	return ret
end

function tosx_Tanker_Siphon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()	
	
	local element = ""
	if Board:IsAcid(p2) then
		element = "_acid"
	end
	
	local waterdamage = SpaceDamage(p2)
	waterdamage.iTerrain = TERRAIN_ROAD
	waterdamage.sAnimation = "tosx_drain_anim"..element
	waterdamage.sImageMark = "combat/icons/tosx_create_water_icon_glowX.png"
	ret:AddDamage(waterdamage)
	ret:AddBounce(p2, 3)
	
	if not Board:IsTipImage() then
		ret:AddScript([[
			local mission = GetCurrentMission()
			if mission then
				mission.Siphon = mission.Siphon + 1
			end
			]])
	end
	ret:AddScript("Board:SetCustomTile("..p2:GetString()..",'tosx_mud_0.png')")

	return ret
end