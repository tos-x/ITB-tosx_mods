-- mission Mission_tosx_Disease

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Disease"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")


Mission_tosx_Disease = Mission_Infinite:new{
	Name = "Diseased Vek",
	Objectives = Objective("Kill the Diseased Vek",1,1),
	Target = 0
}

function Mission_tosx_Disease:StartMission()
	local pawn = PAWN_FACTORY:CreatePawn("tosx_DiseasedBlobber")
	self.Target = pawn:GetId()
	Board:SpawnPawn(pawn)
end

function Mission_tosx_Disease:GetDestroyedCount()
	if not Board:IsPawnAlive(self.Target) then
		return 1
	end
	return 0
end

function Mission_tosx_Disease:UpdateObjectives()
	local status = not Board:IsPawnAlive(self.Target) and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Kill the Diseased Vek",status)
end

function Mission_tosx_Disease:GetCompletedObjectives()
	if Board:IsPawnAlive(self.Target) then
		return self.Objectives:Failed()
	end
	return self.Objectives
end
--------------------------------------------------------------------
tosx_DiseasedBlobber = Pawn:new{
	Name = "Diseased Vek",
	Portrait = "enemy/tosx_d_Blobber",
	Health = 5,
	MoveSpeed = 4,
	Image = "tosx_d_blobber",		
	SkillList = { "tosx_DiseaseAtk" },
	SoundLocation = "/enemy/blobber_1/",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_BLOB,
	GetPositionScore = function(self, point)
		local closest_pawn = Board:GetDistanceToPawn(point,TEAM_PLAYER)
		return math.max(0, (10-closest_pawn)/2)
	end
}

tosx_DiseaseAtk = Skill:new{
	Name = "Plague Cloud",
	Description = "Kills adjacent units. Buildings are unaffected.",
	Damage = DAMAGE_DEATH,
	Class = "Enemy",
	Icon = "weapons/enemy_blobber2.png",
	LaunchSound = "",
	SoundId = "blobber_1", 
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "tosx_DiseasedBlobber"
	}
}

function tosx_DiseaseAtk:GetTargetScore(p1,p2)
	local effect = SkillEffect()
	
	local targetScore = 1
	for i = DIR_START, DIR_END do
		local p = p2 + DIR_VECTORS[i]
		if Board:GetPawnTeam(p) == TEAM_PLAYER and
		not Board:GetPawn(p):IsDead() then
			targetScore = targetScore + 20
		end
	end
	return targetScore
end

function tosx_DiseaseAtk:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	return ret
end

function tosx_DiseaseAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	local chance = math.random()
	if chance > 0.3 then
		ret:AddVoice("Mission_tosx_Plague_Spread",-1)
	end
	
	for dir = DIR_START, DIR_END do
		local p = p1 + DIR_VECTORS[dir]
		local d = self.Damage
		if not Board:IsPawnSpace(p) then
			d = 0
		end
		local damage = SpaceDamage(p, d)
		damage.sAnimation = "tosx_plagueblast_"..dir
		damage.sSound = "/enemy/blobber_1/hurt" --!!!
		ret:AddQueuedDamage(damage)
		
		local damage2 = SpaceDamage(p)
		damage2.bHide = true
		damage2.sSound = "/props/smoke_cloud"
		ret:AddQueuedDamage(damage2)
	end	
	return ret
end
--------------------------------------------------------------------

function this:init(mod)	
	modApi:appendAsset("img/units/aliens/tosx_d_blobber.png", mod.resourcePath .."img/units/aliens/d_blobber.png")
	modApi:appendAsset("img/units/aliens/tosx_d_blobbera.png", mod.resourcePath .."img/units/aliens/d_blobbera.png")
	modApi:appendAsset("img/units/aliens/tosx_d_blobber_emerge.png", mod.resourcePath .."img/units/aliens/d_blobber_emerge.png")
	modApi:appendAsset("img/units/aliens/tosx_d_blobber_death.png", mod.resourcePath .."img/units/aliens/d_blobber_death.png")
	modApi:appendAsset("img/portraits/enemy/tosx_d_Blobber.png", mod.resourcePath .."img/portraits/enemy/d_Blobber.png")
	
	modApi:appendAsset("img/effects/tosx_plagueblast_U.png",mod.resourcePath.."img/effects/plagueblast_U.png")
	modApi:appendAsset("img/effects/tosx_plagueblast_R.png",mod.resourcePath.."img/effects/plagueblast_R.png")
	modApi:appendAsset("img/effects/tosx_plagueblast_L.png",mod.resourcePath.."img/effects/plagueblast_L.png")
	modApi:appendAsset("img/effects/tosx_plagueblast_D.png",mod.resourcePath.."img/effects/plagueblast_D.png")
		
	local a = ANIMS

	a.tosx_d_blobber = a.BaseUnit:new{Image = "units/aliens/tosx_d_blobber.png", PosX = -16, PosY = 1 }
	a.tosx_d_blobbera = a.tosx_d_blobber:new{Image = "units/aliens/tosx_d_blobbera.png", PosX = -16, PosY = 1, NumFrames = 4 }
	a.tosx_d_blobberd = a.tosx_d_blobber:new{Image = "units/aliens/tosx_d_blobber_death.png", PosX = -17, PosY = 2, NumFrames = 8, Time = 0.14, Loop = false }
	a.tosx_d_blobbere = a.tosx_d_blobber:new{
					Image = "units/aliens/tosx_d_blobber_emerge.png",
					PosX = -17,
					PosY = 2, 
					NumFrames = 10, 
					Loop = false, 
					Time = 0.15, 
					Sound = "/enemy/shared/crawl_out" }

	a.tosx_plagueblast_0 = Animation:new{
		Image = "effects/tosx_plagueblast_U.png",
		NumFrames = 9,
		Time = 0.06,
		PosX = -20
	}
	a.tosx_plagueblast_1 = a.tosx_plagueblast_0:new{
		Image = "effects/tosx_plagueblast_R.png",
		PosX = -20
	}
	a.tosx_plagueblast_2 = a.tosx_plagueblast_0:new{
		Image = "effects/tosx_plagueblast_D.png",
		PosX = -20
	}
	a.tosx_plagueblast_3 = a.tosx_plagueblast_0:new{
		Image = "effects/tosx_plagueblast_L.png",
		PosX = -20
	}
end

function this:load(mod, options, version)
	-- Allowable corps:
	local corps = {
		"archive",
	    "rst",
	    "pinnacle",
	    "detritus",
		"Watchtower",
		"FarLine",
	}
	
	-- Add to all 4 default corp slots
	--corpIslandMissions.Add_Missions_High("Mission_tosx_Disease")
	
	-- Random number 0-3 (Corp_Grass, Corp_Desert, Corp_Snow, Corp_Factory)
	modApi:addPostStartGameHook(function()
		if GAME and not GAME.tosx_risle2 then
			GAME.tosx_risle2 = math.random(4) - 1
			--LOG("random island2: "..GAME.tosx_risle2)
		end
	end)
	
	-- Randomly remove the mission from 3 of the slots each run
	modApi:addPreIslandSelectionHook(function(corporation, island)
		if GAME.tosx_risle2 and GAME.tosx_risle2 ~= island then
			corpIslandMissions.Rem_Missions_High("Mission_tosx_Disease", corporation)
		elseif easyEdit and easyEdit.world then
			-- Now also remove it from all but allowed corps
			local disallow = true
			for i = 1, #corps do
				if easyEdit.world[island + 1].corporation == corps[i] then
					-- This slot is set to something compatible
					disallow = false
					break
				end
			end
			if disallow then
				-- This slot doesn't contain anything compatible
				corpIslandMissions.Rem_Missions_High("Mission_tosx_Disease", corporation)
			end
		end
		
	end)
end

return this