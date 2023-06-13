
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")
local trait = require(path .."libs/trait")

trait:add{
		pawnType = "tosx_IceHornet",
		icon = mod_loader.mods[modApi.currentMod].resourcePath.."img/combat/icons/tosx_icemove_icon.png",
		icon_offset = Point(0,0),
		desc_title = "Frigid Carapace",
		desc_text = "This unit Freezes all adjacent Water tiles when it moves.",
	}
	
Mission_tosx_IceVek = Mission_Infinite:new{
	Name = "Cryo Vek",
	MapTags = {"tosx_smallisland"},
	Objectives = Objective("Kill the Cryo Vek",1,1),
	Target = 0,
	BonusPool = copy_table(missionTemplates.bonusNoDebris),
	UseBonus = true,
	SpawnStartMod = -1,
}

-- Add CEO dialog
local dialog = require(path .."missions/icevek_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_IceVek", dialogTable)
end

function Mission_tosx_IceVek:StartMission()
	Board:SetWeather(1, RAIN_SNOW, Point(0,0), Point(8,8), -1)
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_IceHornet")
	self.Target = pawn:GetId()
	Board:SpawnPawn(pawn)
end

function Mission_tosx_IceVek:MoveFreeze(pawn)
	local loc = pawn:GetSpace()
	local e = SkillEffect()
	e:AddSound("/props/freezing")
	
	local d = SpaceDamage(loc)
	d.iFrozen = EFFECT_CREATE
	local pawnid = pawn:GetId()
	e:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", pawnid))
	e:AddDamage(d)
	e:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawnid, loc:GetString()))
	
	for i = DIR_START, DIR_END do
		local loc2 = loc + DIR_VECTORS[i]
		if Board:IsValid(loc2) then
			d.loc = loc2
			if Board:IsPawnSpace(loc2) then
				pawnid = Board:GetPawn(loc2):GetId()
				e:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", pawnid))
				e:AddDamage(d)
				e:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawnid, loc2:GetString()))
			elseif not Board:IsBuilding(loc2) then
				e:AddDamage(d)
			end
		end
	end
	Board:AddEffect(e)
end

local icemove = 0
function Mission_tosx_IceVek:UpdateMission()
	if not Board:IsPawnAlive(self.Target) then
		Board:SetWeather(0,RAIN_SNOW,Point(0,0),Point(8,8),-1)
	else
		Board:SetWeather(2, RAIN_SNOW, Point(0,0), Point(8,8), -1)	
	end
	if icemove == 1 and Board:GetBusyState() == 0 and Board:IsPawnAlive(self.Target) then
		icemove = 2
		local pawn = Board:GetPawn(self.Target)
		self:MoveFreeze(pawn)
		icemove = 0
	end
end

function Mission_tosx_IceVek:UpdateObjectives()
	local status = not Board:IsPawnAlive(self.Target) and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Kill the Cryo Vek",status)
end

function Mission_tosx_IceVek:GetCompletedObjectives()
	if Board:IsPawnAlive(self.Target) then
		return self.Objectives:Failed()
	end
	return self.Objectives
end

function Mission_tosx_IceVek:GetCompletedStatus()
	if not Board:IsPawnAlive(self.Target) then
		return "Success"
	else
		return "Failure"
	end
end
--------------------------------------------------------------------
local function IceHornetScore(self, point)
	local score = 5
	if Board:GetTerrain(point) == TERRAIN_WATER then
		score = score + 1
	end
	for i = DIR_START, DIR_END do
		if Board:GetTerrain(point + DIR_VECTORS[i]) == TERRAIN_WATER then
			score = score + 1
		end
	end
	return score
end

tosx_IceHornet = Pawn:new{
	Name = "Cryo Vek",
	Portrait = "enemy/tosx_i_Hornet",
	Health = 4,
	MoveSpeed = 5,
	Image = "tosx_i_hornet",
	SkillList = { "tosx_IceHornetAtk" },  
	Flying = true,
	LargeShield = true,
	SoundLocation = "/enemy/hornet_2/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_FLESH,
	GetPositionScore = IceHornetScore,
}

tosx_IceHornetAtk = HornetAtk2:new{
	Name = "Freezing Stinger",
	Description = "Stab 2 tiles in front of the unit, damaging and then Freezing them.",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "tosx_IceHornet"
	}
}

function tosx_IceHornetAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)	
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.iFrozen = EFFECT_CREATE
	damage.sAnimation = "explohornet_"..direction
	
	ret:AddQueuedMelee(p1,damage, 0.25)
	
	if self.TargetBehind then
		damage.loc = p2+DIR_VECTORS[direction]
		ret:AddQueuedDamage(damage)
	end
	
	return ret
end	

--------------------------------------------------------------------

modApi:appendAsset("img/units/aliens/tosx_i_hornet.png", mod.resourcePath .."img/units/aliens/i_hornet.png")
modApi:appendAsset("img/units/aliens/tosx_i_horneta.png", mod.resourcePath .."img/units/aliens/i_horneta.png")
modApi:appendAsset("img/units/aliens/tosx_i_hornet_emerge.png", mod.resourcePath .."img/units/aliens/i_hornet_emerge.png")
modApi:appendAsset("img/units/aliens/tosx_i_hornet_death.png", mod.resourcePath .."img/units/aliens/i_hornet_death.png")
modApi:appendAsset("img/portraits/enemy/tosx_i_Hornet.png", mod.resourcePath .."img/portraits/enemy/i_Hornet.png")
	
local a = ANIMS

a.tosx_i_hornet = a.BaseUnit:new{Image = "units/aliens/tosx_i_hornet.png", PosX = -11, PosY = -13 }
a.tosx_i_horneta = a.tosx_i_hornet:new{Image = "units/aliens/tosx_i_horneta.png", PosX = -11, PosY = -13, NumFrames = 4 }
a.tosx_i_hornetd = a.tosx_i_hornet:new{Image = "units/aliens/tosx_i_hornet_death.png", PosX = -10, PosY = -13, NumFrames = 8, Time = 0.14, Loop = false }
a.tosx_i_hornete = a.tosx_i_hornet:new{
				Image = "units/aliens/tosx_i_hornet_emerge.png",
				PosX = -22,
				PosY = -12,
				NumFrames = 10, 
				Loop = false, 
				Time = 0.15, 
				Sound = "/enemy/shared/crawl_out" }

local function pawnMoved(mission, pawn, loc_old)
	if not mission or not mission.Target or mission.ID ~= "Mission_tosx_IceVek" then return end
	if not pawn or pawn:GetId() ~= mission.Target or not Board:IsPawnAlive(mission.Target) then return end
	if icemove == 0 then 
		icemove = 1
	end
end
	
local function onModsLoaded()
	modapiext:addPawnPositionChangedHook(pawnMoved)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)