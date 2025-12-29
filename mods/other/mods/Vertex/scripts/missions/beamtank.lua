-- mission Mission_tosx_BeamTank
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")

local objAfterMission1 = switch{
	[0] = function() return Objective("Protect the Beam Tank", 1):Failed() end,
	[1] = function() return Objective("Protect the Beam Tank", 1) end,
	default = function() return nil end,
}

local objAfterMission2 = switch{
	[0] = function() return Objective("Destroy 2 mountains with the Crystal Laser", 1):Failed() end,
	[1] = function() return Objective("Destroy 2 mountains with the Crystal Laser", 1) end,
	default = function() return nil end,
}

Mission_tosx_BeamTank = Mission_Infinite:new{
	Name = "Beam Tank",
	MapTags = {"tosx_beam"},
	Objectives = {objAfterMission1:case(1),objAfterMission2:case(1)},
	UseBonus = false,
	BeamId = -1,
	BeamPawn = "tosx_BeamTank",
	Mountains = 0,
    MountainsGoal = 2,
	SpawnStartMod = 1,
	SpawnMod = 1,
}

-- Add CEO dialog
local dialog = require(path .."missions/beamtank_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_BeamTank", dialogTable)
end

function Mission_tosx_BeamTank:StartMission()
	local options = extract_table(Board:GetZone("tank"))
	local choice = random_removal(options)
    
	local beam = PAWN_FACTORY:CreatePawn(self.BeamPawn)
	self.BeamId = beam:GetId()
	Board:AddPawn(beam, choice)
end

function Mission_tosx_BeamTank:UpdateObjectives()
	local status = Board:IsPawnAlive(self.BeamId) and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Protect the Beam Tank",status)
    
    if not Board:IsPawnAlive(self.BeamId) and self.Mountains < self.MountainsGoal then
        Game:AddObjective("Destroy 2 mountains with the Crystal Laser", OBJ_FAILED)
    else
        local mountainStatus = (self.Mountains >= self.MountainsGoal) and OBJ_COMPLETE or OBJ_STANDARD
        Game:AddObjective("Destroy 2 mountains with the Crystal Laser \n(Current: "..tostring(self.Mountains)..")", mountainStatus)
    end
end

function Mission_tosx_BeamTank:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission1:case(Board:IsPawnAlive(self.BeamId) and 1 or 0)
	ret[2] = objAfterMission2:case(self.Mountains >= self.MountainsGoal and 1 or 0)
	return ret
end

function Mission_tosx_BeamTank:GetCompletedStatus()
	if Board:IsPawnAlive(self.BeamId) and self.Mountains >= self.MountainsGoal then
		return "Success"
	elseif Board:IsPawnAlive(self.BeamId) then
		return "DefendOnly"
	elseif self.Mountains >= self.MountainsGoal then
		return "MtnOnly"
	else
		return "Failure"
	end
end

tosx_BeamTank = Pawn:new{
	Name = "Beam Tank",
	Image = "tosx_beamtank",
	Health = 2,
	MoveSpeed = 4,
	SkillList = { "tosx_BeamTankAtk" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/support/civilian_tank/",
	Corporate = true,
}

tosx_BeamTankAtk = Skill:new{
	Name = "Crystal Laser",
	Description = "Fire a piercing beam that deals lethal damage after passing through a Mountain.",
	Class = "Unique",
	Icon = "weapons/tosx_mtn_beam.png",
	LaserArt = "effects/tosx_cryslaser",
	LaserArt2 = "effects/tosx_crys1laser",
	LaunchSound = "/weapons/burst_beam",
    Damage = 1,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Mountain = Point(2,2),
		Enemy2 = Point(2,3),
		Target = Point(2,3),
		CustomPawn = "tosx_BeamTank"
	}
}

function tosx_BeamTankAtk:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		while not Board:IsBuilding(curr) and Board:IsValid(curr) do
			ret:push_back(curr)
			curr = curr + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end
	
	return ret
end

function tosx_BeamTankAtk:GetSkillEffect(p1, p2)
    
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
    local mtns = 0
    
    local p3 = p1 + DIR_VECTORS[dir]
    local p3b = p3
    while Board:IsValid(p3b) do
        p3 = p3b
        if Board:IsBuilding(p3b) then
            break
        end
        p3b = p3 + DIR_VECTORS[dir]
    end
    
	local distance = p1:Manhattan(p3)
	local amount = self.Damage
    local beam2 = p1
    
	for k = 1, distance do
		local curr = p1 + DIR_VECTORS[dir]*k
		if Board:GetTerrain(curr) == TERRAIN_MOUNTAIN then
            mtns = mtns + 1
			amount = DAMAGE_DEATH
            if beam2 == p1 then
                beam2 = curr
            end
		end
		local damage = SpaceDamage(curr, amount)
		if (k == distance and beam2 == p1) or beam2 == curr then
			--end the first beam
            ret:AddProjectile(damage,self.LaserArt)
        elseif k == distance then
            ret:AddSound("/weapons/bend_beam")
            ret:AddSound("/impact/generic/explosion")
            ret:AddProjectile(beam2,damage,self.LaserArt2,NO_DELAY)
		else
			ret:AddDamage(damage)
		end
	end
    
    if not Board:IsTipImage() and mtns > 0 then
        ret:AddScript([[
            local mission = GetCurrentMission() 
            if not mission then return end 
            mission.Mountains = mission.Mountains + ]]..mtns)
    end
	
	return ret
end

modApi:appendAsset("img/units/mission/tosx_beamtank.png", mod.resourcePath .."img/units/mission/beamtank.png")
modApi:appendAsset("img/units/mission/tosx_beamtank_ns.png", mod.resourcePath .."img/units/mission/beamtank_ns.png")
modApi:appendAsset("img/units/mission/tosx_beamtank_a.png", mod.resourcePath .."img/units/mission/beamtank_a.png")
modApi:appendAsset("img/units/mission/tosx_beamtank_d.png", mod.resourcePath .."img/units/mission/beamtank_d.png")

modApi:appendAsset("img/weapons/tosx_mtn_beam.png", mod.resourcePath .."img/weapons/mtn_beam.png")

modApi:appendAsset("img/effects/tosx_cryslaser_start.png",mod.resourcePath.."img/effects/cryslaser_start.png")
modApi:appendAsset("img/effects/tosx_cryslaser_U.png",mod.resourcePath.."img/effects/cryslaser_U.png")
modApi:appendAsset("img/effects/tosx_cryslaser_U1.png",mod.resourcePath.."img/effects/cryslaser_U1.png")
modApi:appendAsset("img/effects/tosx_cryslaser_U2.png",mod.resourcePath.."img/effects/cryslaser_U2.png")
modApi:appendAsset("img/effects/tosx_cryslaser_R.png",mod.resourcePath.."img/effects/cryslaser_R.png")
modApi:appendAsset("img/effects/tosx_cryslaser_R1.png",mod.resourcePath.."img/effects/cryslaser_R1.png")
modApi:appendAsset("img/effects/tosx_cryslaser_R2.png",mod.resourcePath.."img/effects/cryslaser_R2.png")
modApi:appendAsset("img/effects/tosx_cryslaser_hit.png",mod.resourcePath.."img/effects/cryslaser_hit.png")

modApi:appendAsset("img/effects/tosx_crys1laser_start.png",mod.resourcePath.."img/effects/crys1laser_start.png")
modApi:appendAsset("img/effects/tosx_crys1laser_U.png",mod.resourcePath.."img/effects/crys1laser_U.png")
modApi:appendAsset("img/effects/tosx_crys1laser_U1.png",mod.resourcePath.."img/effects/crys1laser_U1.png")
modApi:appendAsset("img/effects/tosx_crys1laser_U2.png",mod.resourcePath.."img/effects/crys1laser_U2.png")
modApi:appendAsset("img/effects/tosx_crys1laser_R.png",mod.resourcePath.."img/effects/crys1laser_R.png")
modApi:appendAsset("img/effects/tosx_crys1laser_R1.png",mod.resourcePath.."img/effects/crys1laser_R1.png")
modApi:appendAsset("img/effects/tosx_crys1laser_R2.png",mod.resourcePath.."img/effects/crys1laser_R2.png")
modApi:appendAsset("img/effects/tosx_crys1laser_hit.png",mod.resourcePath.."img/effects/crys1laser_hit.png")

local laser_loc = Point(-12,3)
Location["effects/tosx_cryslaser_start.png"] = laser_loc
Location["effects/tosx_cryslaser_U.png"] = laser_loc
Location["effects/tosx_cryslaser_U1.png"] = laser_loc
Location["effects/tosx_cryslaser_U2.png"] = laser_loc
Location["effects/tosx_cryslaser_R.png"] = laser_loc
Location["effects/tosx_cryslaser_R1.png"] = laser_loc
Location["effects/tosx_cryslaser_R2.png"] = laser_loc
Location["effects/tosx_cryslaser_hit.png"] = laser_loc

Location["effects/tosx_crys1laser_start.png"] = laser_loc
Location["effects/tosx_crys1laser_U.png"] = laser_loc
Location["effects/tosx_crys1laser_U1.png"] = laser_loc
Location["effects/tosx_crys1laser_U2.png"] = laser_loc
Location["effects/tosx_crys1laser_R.png"] = laser_loc
Location["effects/tosx_crys1laser_R1.png"] = laser_loc
Location["effects/tosx_crys1laser_R2.png"] = laser_loc
Location["effects/tosx_crys1laser_hit.png"] = laser_loc
    
local a = ANIMS
a.tosx_beamtank = a.BaseUnit:new{Image = "units/mission/tosx_beamtank.png", PosX = -18, PosY = 8}
a.tosx_beamtanka = a.tosx_beamtank:new{Image = "units/mission/tosx_beamtank_a.png", PosY = 7, NumFrames = 2, Time = 0.5}
a.tosx_beamtankd = a.tosx_beamtank:new{Image = "units/mission/tosx_beamtank_d.png", PosX = -18, PosY = 2, NumFrames = 11, Time = 0.12, Loop = false }
a.tosx_beamtank_ns = a.tosx_beamtank:new{Image = "units/mission/tosx_beamtank_ns.png"}