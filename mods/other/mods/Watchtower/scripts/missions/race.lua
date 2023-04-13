
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Ensure only 1 Racer\ncrosses the map", OBJ_FAILED, REWARD_REP, 2)
	end,
	[1] = function()
		Game:AddObjective("Ensure only 1 Racer\ncrosses the map", OBJ_STANDARD, REWARD_REP, 2)
	end,
	[2] = function()
		Game:AddObjective("Ensure only 1 Racer\ncrosses the map", OBJ_COMPLETE, REWARD_REP, 2)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Ensure only 1 Racer crosses the map", 2):Failed() end,
	[1] = function() return Objective("Ensure only 1 Racer crosses the map", 2) end,
	default = function() return nil end,
}

Mission_tosx_Rallyrace = Mission_Infinite:new{
	Name = "Fix the Race",
	MapTags = {"tosx_rallyrace"},
	Objectives = objAfterMission:case(1),
	UseBonus = false,
	Racers = nil,
}

-- Add CEO dialog
local dialog = require(path .."missions/race_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Rallyrace", dialogTable)
end

function Mission_tosx_Rallyrace:StartMission()
	local start = Point(-1,-1)
	for y = 0,6 do
		local check = Point(0,y)
		if Board:GetCustomTile(check) == "tosx_road_0.png" then
			start = check
			break
		end
	end		
	if start == Point(-1,-1) then LOG("ERROR NO VALID SPACE") return end
	
	local start2 = start + Point(0,1)	
	self.Racers = {-1,-1}
	
	local racer = PAWN_FACTORY:CreatePawn("tosx_Racer0")
	self.Racers[1] = racer:GetId()
	Board:AddPawn(racer,start)
	
	local racer2 = PAWN_FACTORY:CreatePawn("tosx_Racer1")
	self.Racers[2] = racer2:GetId()
	Board:AddPawn(racer2,start2)
end

function Mission_tosx_Rallyrace:AnyRacersAlive()
	for i = 1,2 do
		if Board:GetPawn(self.Racers[i]) ~= nil and Board:IsPawnAlive(self.Racers[i]) then
			return true
		end
	end
	return false
end

function Mission_tosx_Rallyrace:FinishLine()
	local count = 0
	for y = 0, 7 do
		local p = Point(7,y)
		if Board:IsPawnSpace(p) and Board:IsPawnAlive(Board:GetPawn(p):GetId()) then
			if Board:GetPawn(p):GetType() == "tosx_Racer0" or Board:GetPawn(p):GetType() == "tosx_Racer1" then
				count = count + 1
			end
		end
	end
	return count
end

function Mission_tosx_Rallyrace:NextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER and
	   Game:GetTurnCount() == 3 and
	   self:FinishLine() ~= 1 and
	   self:AnyRacersAlive() then
		PrepareVoiceEvent("Mission_tosx_RaceReminder")
	end
end

function Mission_tosx_Rallyrace:UpdateObjectives()
	if not self:AnyRacersAlive() then
		objInMission:case(0)
	elseif self:FinishLine() == 1 then
		objInMission:case(2)
	else
		objInMission:case(1)
	end	
end

function Mission_tosx_Rallyrace:GetCompletedObjectives()
	if self:FinishLine() == 1 then
		return objAfterMission:case(1)
	else
		 return objAfterMission:case(0)
	end
end

function Mission_tosx_Rallyrace:GetCompletedStatus()
	if self:FinishLine() == 1 then
		return "Success"
	elseif self:FinishLine() == 2 then
		return "Tie"
	else
		return "Failure"
	end
end
-- example of briefing entry: Mission_tosx_Upgrader_Dead_CEO_Watchtower_1
-- "Dead" is the status


local a = ANIMS
for i = 0, 1 do
	modApi:appendAsset("img/units/mission/tosx_racer"..i..".png", mod.resourcePath.."img/units/mission/racer"..i..".png")
	modApi:appendAsset("img/units/mission/tosx_racer"..i.."_ns.png", mod.resourcePath.."img/units/mission/racer"..i.."_ns.png")
	modApi:appendAsset("img/units/mission/tosx_racer"..i.."a.png", mod.resourcePath.."img/units/mission/racer"..i.."a.png")
	modApi:appendAsset("img/units/mission/tosx_racer"..i.."d.png", mod.resourcePath.."img/units/mission/racer"..i.."d.png")

	a["tosx_racer"..i] = a.BaseUnit:new{Image = "units/mission/tosx_racer"..i..".png", PosX = -17, PosY = 6}
	a["tosx_racer"..i.."a"] = a["tosx_racer"..i]:new{Image = "units/mission/tosx_racer"..i.."a.png", NumFrames = 6, Time = 0.5}
	a["tosx_racer"..i.."d"] = a["tosx_racer"..i]:new{Image = "units/mission/tosx_racer"..i.."d.png", PosX = -19, PosY = 1, NumFrames = 11, Time = 0.12, Loop = false }
	a["tosx_racer"..i.."_ns"] = a["tosx_racer"..i]:new{Image = "units/mission/tosx_racer"..i.."_ns.png"}
end

tosx_Racer0 = {
	Name = "Racing Rig",
	Health = 2,
	--Armor = true,
	MoveSpeed = 0,
	Image = "tosx_racer0",
	SoundLocation = "/support/vip_truck/",
	ImpactMaterial = IMPACT_METAL,
	Neutral = true,
	--IsPortrait = false,
	Minor = true,
	Mission = true,	
	SkillList = { "tosx_Racer_Move" },	
	DefaultTeam = TEAM_PLAYER,	
	IgnoreSmoke = true,
	IgnoreFlip = true,
	IgnoreFire = true,
	Corporate = true,
}
AddPawn("tosx_Racer0")

tosx_Racer1 = tosx_Racer0:new{
	--Name = "Racing Rig",
	Image = "tosx_racer1",
}

tosx_Racer_Move = Skill:new{
	Name = "Start your Engines!",
	Description = "Move forward 2 spaces, destroying anything in its path.",
	--Icon = "weapons/tosx_rig_engine.png",
	Class = "Enemy",
	AttackAnimation = "ExploArt2",
	LaunchSound = "/support/vip_truck/move",
	TipImage = {
		Unit = Point(1,2),
		Enemy = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Racer0"
	}
}

function tosx_Racer_Move:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point + VEC_RIGHT)
	return ret
end

function tosx_Racer_Move:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local q_move = PointList()	
	q_move:push_back(p1)
	
	-- local danim = SpaceDamage(p1)
	-- danim.sAnimation = "airpush_"..GetDirection(VEC_LEFT)
	-- ret:AddQueuedDamage(danim)
			
	local range = 2	
	local current = p2
	local damage = Point(-1,-1)
	for k = 1, range do
		if not Board:IsPawnSpace(current) and (Board:GetTerrain(current) == TERRAIN_WATER or Board:GetTerrain(current) == TERRAIN_HOLE) then ---run into water/hole and die!
			q_move:push_back(current)
			break
		elseif Board:IsBlocked(current, PATH_GROUND) and Board:IsValid(current) then
			ret:AddQueuedCharge(q_move, FULL_DELAY)
			local damage = SpaceDamage(current, DAMAGE_DEATH)
			ret:AddQueuedDamage(damage)
			damage.sImageMark = "combat/arrow_hit.png"
			damage.iDamage = 1
			damage.loc = current + VEC_LEFT
			ret:AddQueuedDamage(damage)
			return ret
		elseif Board:IsValid(current) then
			q_move:push_back(current)
		end
		
		current = current + VEC_RIGHT
	end
	
	ret:AddQueuedCharge(q_move, FULL_DELAY)
		
	return ret
end

function tosx_Racer_Move:GetTargetScore(p1, p2)
	return 100
end