-- mission Mission_tosx_Siege

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Siege"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")


Mission_tosx_Siege = Mission_Infinite:new{
	Name = "Siege",
	MapTags = { "tosx_siege" },
	Objectives = Objective("Break open both Crates",2,2),
	UseBonus = false,
	Environment = "tosx_env_siege",
}

tosx_env_siege = Environment:new{
	Name = "Under Siege",
	Text = "Vek will swarm this area in massive numbers just before the final turn.",
	StratText = "UNDER SIEGE",
	CombatIcon = "combat/tile_icon/tosx_icon_env_siege.png",
	CombatName = "SIEGE",
}

local function IsCorp()
	-- Returns string: Pinnacle, RST, Detritus, Archive
	return GetText(Game:GetCorp().bark_name)
end

function Mission_tosx_Siege:CountCrates()
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if Board:GetPawn(v):GetType() == "tosx_Crate1" or Board:GetPawn(v):GetType() == "tosx_Crate2" then
			if not Board:GetPawn(v):IsDead() then
				count = count + 1
			else
				-- We're going to manually replace crate corpses with units during this update
				local p = Board:GetPawnSpace(v)
				local fx = SkillEffect()
				local d = SpaceDamage(p)
				-- Let's put out fire so unit doesn't immediately die
				d.iFire = EFFECT_REMOVE
				d.sSound = "/enemy/shared/robot_power_on"
				d.sPawn = _G[Board:GetPawn(v):GetType()].Deploy
				fx:AddDamage(d)
				if Game:GetTeamTurn() == TEAM_ENEMY then
					fx:AddScript([[Board:GetPawn(]]..p:GetString()..[[):SetActive(false)]])
				end
				Board:RemovePawn(p)
				Board:AddEffect(fx)
			end
		end
	end	
	return count
end

function Mission_tosx_Siege:GetCompletedStatus()
	if self:CountCrates() > 0 then	
		return "Failure"
	else
		return "Success"
	end
end

function Mission_tosx_Siege:GetCompletedObjectives()
	local crate_count = self:CountCrates()
	if crate_count == 0 then
		return self.Objectives
	elseif crate_count == 1 then
		return Objective("Break open both Crates (One Remains)",1,2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_tosx_Siege:UpdateObjectives()
	local status = self:CountCrates() == 0 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Break open both Crates",status, REWARD_REP, 2)
end

function Mission_tosx_Siege:GetCompletedStatus()
	if self:CountCrates() == 0 then
		return "Success"
	elseif self:CountCrates() > 1 then
		return "Failure"
	else
		return "Partial"
	end
end

function Mission_tosx_Siege:StartMission()
	if IsCorp() == "Pinnacle" then
		_G["tosx_Siege01"].ImageOffset = 6
		_G["tosx_Siege02"].ImageOffset = 6
	elseif IsCorp() == "Detritus" then
		_G["tosx_Siege01"].ImageOffset = 7
		_G["tosx_Siege02"].ImageOffset = 7
	elseif IsCorp() == "RST" then
		_G["tosx_Siege01"].ImageOffset = 1
		_G["tosx_Siege02"].ImageOffset = 1
	elseif IsCorp() == "Archive" then
		_G["tosx_Siege01"].ImageOffset = 0
		_G["tosx_Siege02"].ImageOffset = 0
	else -- catchall for mod corps; Archive color
		_G["tosx_Siege01"].ImageOffset = 0
		_G["tosx_Siege02"].ImageOffset = 0
	end
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_Crate1")
	Board:AddPawn(pawn, "tosx_crate_zone1")
	Board:SetTerrain(pawn:GetSpace(), TERRAIN_ROAD)
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_Crate2")
	Board:AddPawn(pawn, "tosx_crate_zone2")
	Board:SetTerrain(pawn:GetSpace(), TERRAIN_ROAD)
end

function Mission_tosx_Siege:UpdateSpawning()
	if Game:GetTurnCount() == 2 then
		self.MaxEnemy = 12
		self.SpawnsPerTurn = {6,6}
		self.SpawnsPerTurn_Easy = {4,4}
		self.SpawnsPerTurn_Unfair = {6,6}
		self.Spawner = nil
		self:CreateSpawner()
		
		-- If there's a psion present, block another
		local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))		
		for i, pawn_id in ipairs(pawns) do
			if string.find(Board:GetPawn(pawn_id):GetType(), "Jelly") then
				self:GetSpawner():BlockPawns(Board:GetPawn(pawn_id):GetType())
				LOG("blocking "..Board:GetPawn(pawn_id):GetType())
			end
		end
	end
	self:SpawnPawns(self:GetSpawnCount())--spawn Vek
end

-- During the last spawn, override default spawn barks with custom
local oldTriggerVoice = TriggerVoiceEvent
function TriggerVoiceEvent(event, custom_odds)
	local mission = GetCurrentMission()
	if mission and
	mission.Environment == "tosx_env_siege" and
	Game:GetTurnCount() == 3 and
	event.id == "Emerge_Detected" then
		if not mission.tosx_swarm_text then
			event.id = "Mission_tosx_Siege_Now"
			custom_odds = 100
			mission.tosx_swarm_text = true
		else
			custom_odds = 0
		end
	end
	oldTriggerVoice(event, custom_odds)
end
-------------------------------------------------------------------- Crate 01
tosx_Crate1 = Pawn:new{
	Name = "Storage Crate 01",
	Health = 2,
	Neutral = true,
	MoveSpeed = 0,
	Image = "tosx_Crate1",
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_ROCK,
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Deploy = "tosx_Siege01",
	Tooltip = "tosx_Crate1_Death_Tooltip",
	Corpse = true,
}

tosx_Crate1_Death_Tooltip = SelfTarget:new{
	Name = "Deploy Contents",
	Description = "Release the contents of this Crate by destroying it.",
	Class = "Death",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Crate1"
	}
}

function tosx_Crate1_Death_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(2)
	return ret
end

tosx_Siege01 = Pawn:new{
	Name = "Missile Tank",
	Health = 1,
	MoveSpeed = 3,
	SkillList = { "tosx_Siege01Wep" },
	Image = "tosx_MissileTank",
	ImageOffset = 0,
	Massive = false,
	SoundLocation = "/support/civilian_artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true
}

tosx_Siege01Wep = LineArtillery:new{
	Name = "Arclight Missile", 
	Description = "Damage a tile and push surrounding tiles.",
	Range = RANGE_ARTILLERY,
	Icon = "weapons/brute_jetmech.png",
	UpShot = "effects/shotup_tribomb_missile.png",
	Damage = 1,
	Explosion = "ExploArt1",
	LaunchSound = "/support/civilian_artillery/fire",
	ImpactSound = "/impact/generic/explosion",
	Class = "Unique",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Siege01",
	}	
}

function tosx_Siege01Wep:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "ExploArt1"	
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, self.UpShot)
	
	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],0,dir)
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end

	return ret
end

-------------------------------------------------------------------- Crate 02
tosx_Crate2 = tosx_Crate1:new{
	Name = "Storage Crate 02",
	Image = "tosx_Crate2",
	Deploy = "tosx_Siege02",
	Tooltip = "tosx_Crate2_Death_Tooltip",
}

tosx_Crate2_Death_Tooltip = tosx_Crate1_Death_Tooltip:new{
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Crate2"
	}
}

tosx_Siege02 = Pawn:new{
	Name = "Flame Tank",
	Health = 1,
	MoveSpeed = 4,
	SkillList = { "tosx_Siege02Wep" },
	Image = "tosx_FireTank",
	ImageOffset = 0,
	Massive = false,
	SoundLocation = "/support/civilian_artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true
}

tosx_Siege02Wep = Skill:new{
	Name = "Dragon Cannon", 
	Description = "Projectile that damages target and lights it on fire.",
	Icon = "weapons/prime_flamethrower.png",
	Damage = 2,
	Fire = 1,
	Class = "Unique",
	Explosion = "ExploAir2",
	ProjectileArt = "effects/shot_mechtank",
	LaunchSound = "/weapons/flamethrower",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2, 2),
		CustomPawn = "tosx_Siege02",
	}
}

function tosx_Siege02Wep:GetTargetArea(p1)
	return Board:GetSimpleReachable(p1, 8, false)
end

function tosx_Siege02Wep:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local target = GetProjectileEnd(p1,p2,pathing)  	
	local damage = SpaceDamage(target, self.Damage)
	damage.iFire = self.Fire
	damage.sAnimation = self.Explosion
	
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end


function this:init(mod)
	Global_Texts["TipTitle_".."tosx_env_siege"] = tosx_env_siege.Name
	Global_Texts["TipText_".."tosx_env_siege"] = tosx_env_siege.Text
	
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_siege.png", mod.resourcePath .."img/combat/icon_env_siege.png")
	
	modApi:appendAsset("img/units/enemy/tosx_crate1.png", mod.resourcePath .."img/units/mission/tosx_crate1.png")
	modApi:appendAsset("img/units/enemy/tosx_crate1_a.png", mod.resourcePath .."img/units/mission/tosx_crate1_a.png")
	modApi:appendAsset("img/units/enemy/tosx_crate2.png", mod.resourcePath .."img/units/mission/tosx_crate2.png")
	modApi:appendAsset("img/units/enemy/tosx_crate2_a.png", mod.resourcePath .."img/units/mission/tosx_crate2_a.png")
	modApi:appendAsset("img/units/enemy/tosx_crate_d.png", mod.resourcePath .."img/units/mission/tosx_crate_d.png")
	
	-- Need to append to units/player for color palettes to work
	modApi:appendAsset("img/units/player/tosx_missiletank.png", mod.resourcePath .."img/units/mission/tosx_missiletank.png")
	modApi:appendAsset("img/units/player/tosx_missiletanka.png", mod.resourcePath .."img/units/mission/tosx_missiletanka.png")
	modApi:appendAsset("img/units/player/tosx_missiletank_death.png", mod.resourcePath .."img/units/mission/tosx_missiletank_death.png")
	modApi:appendAsset("img/units/player/tosx_missiletank_ns.png", mod.resourcePath .."img/units/mission/tosx_missiletank_ns.png")
	modApi:appendAsset("img/units/enemy/tosx_missiletank_off.png", mod.resourcePath .."img/units/mission/tosx_missiletank_off.png")

	modApi:appendAsset("img/units/player/tosx_firetank.png", mod.resourcePath .."img/units/mission/tosx_firetank.png")
	modApi:appendAsset("img/units/player/tosx_firetanka.png", mod.resourcePath .."img/units/mission/tosx_firetanka.png")
	modApi:appendAsset("img/units/player/tosx_firetank_death.png", mod.resourcePath .."img/units/mission/tosx_firetank_death.png")
	modApi:appendAsset("img/units/player/tosx_firetank_ns.png", mod.resourcePath .."img/units/mission/tosx_firetank_ns.png")
	modApi:appendAsset("img/units/enemy/tosx_firetank_off.png", mod.resourcePath .."img/units/mission/tosx_firetank_off.png")
	
	local a = ANIMS

	a.tosx_Crate1 = a.BaseUnit:new{Image = "units/enemy/tosx_crate1.png", PosX = -24, PosY = -4}
	a.tosx_Crate1a = a.tosx_Crate1:new{Image = "units/enemy/tosx_crate1_a.png", NumFrames = 6 }
	a.tosx_Crate1d = a.tosx_Crate1:new{Image = "units/enemy/tosx_crate_d.png", Time = 0.06, NumFrames = 5, Loop = false }
	a.tosx_Crate1_broken = 	a.tosx_Crate1:new{ Image = "units/enemy/tosx_missiletank_off.png", PosX = -22, PosY = 3 } -- For deploying

	a.tosx_Crate2 = a.tosx_Crate1:new{Image = "units/enemy/tosx_crate2.png" }
	a.tosx_Crate2a = a.tosx_Crate1a:new{Image = "units/enemy/tosx_crate2_a.png" }
	a.tosx_Crate2d = a.tosx_Crate1d:new{ }
	a.tosx_Crate2_broken = 	a.tosx_Crate2:new{ Image = "units/enemy/tosx_firetank_off.png", PosX = -15, PosY = 4 } -- For deploying
	
	-- Need to use MechUnit for color palettes to work
	a.tosx_MissileTank = 	a.MechUnit:new{ Image = "units/player/tosx_missiletank.png", PosX = -22, PosY = 3 }
	a.tosx_MissileTanka = 	a.tosx_MissileTank:new{ Image = "units/player/tosx_missiletanka.png", NumFrames = 2 }
	a.tosx_MissileTankd  = a.tosx_MissileTank:new{ Image = "units/player/tosx_missiletank_death.png", PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false }
	a.tosx_MissileTank_ns  = a.MechIcon:new{ Image = "units/player/tosx_missiletank_ns.png"}
	
	a.tosx_FireTank = 	a.MechUnit:new{ Image = "units/player/tosx_firetank.png", PosX = -15, PosY = 4 }
	a.tosx_FireTanka = 	a.tosx_FireTank:new{ Image = "units/player/tosx_firetanka.png", NumFrames = 2 }
	a.tosx_FireTankd  = a.tosx_FireTank:new{ Image = "units/player/tosx_firetank_death.png", PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false }
	a.tosx_FireTank_ns  = a.MechIcon:new{ Image = "units/player/tosx_firetank_ns.png"}	
	
	for i = 0, 3 do
		modApi:addMap(mod.resourcePath .."maps/tosx_siege".. i ..".map")
	end
end

function this:load(mod, options, version)
	modapiext:addPawnKilledHook(function(mission, pawn)
		-- Manually play sound when a crate dies
		if string.find(pawn:GetType(),"tosx_Crate") then
			Game:TriggerSound("/weapons/bombling_throw")
		end
	end)

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
	--corpIslandMissions.Add_Missions_High("Mission_tosx_Siege")
	
	-- Random number 0-3 (Corp_Grass, Corp_Desert, Corp_Snow, Corp_Factory)
	modApi:addPostStartGameHook(function()
		if GAME and not GAME.tosx_risle then
			GAME.tosx_risle = math.random(4) - 1
			--LOG("random island: "..GAME.tosx_risle)
		end
	end)
	
	-- Randomly remove the mission from 3 of the slots each run
	modApi:addPreIslandSelectionHook(function(corporation, island)
		if GAME.tosx_risle and GAME.tosx_risle ~= island then
			corpIslandMissions.Rem_Missions_High("Mission_tosx_Siege", corporation)
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
				corpIslandMissions.Rem_Missions_High("Mission_tosx_Siege", corporation)
			end
		end
		
	end)
end

return this