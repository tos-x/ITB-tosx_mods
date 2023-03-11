-- mission Mission_tosx_Juggernaut

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Juggernaut"}
local corpMissions = require(path .."corpMissions")

-- returns number of pawns alive
-- in a list of pawn id's.
local function countAlive(list)
	assert(type(list) == 'table', "table ".. tostring(list) .." not a table")
	local ret = 0
	for _, id in ipairs(list) do
		if type(id) == 'number' then
			ret = ret + (Board:IsPawnAlive(id) and 1 or 0)
		else
			error("variable of type ".. type(id) .." is not a number")
		end
	end
	
	return ret
end

Mission_tosx_Juggernaut = Mission_Infinite:new{
	Name = "Juggernaut Escort",
	MapTags = { "tosx_juggernaut" },
	Objectives = { Objective("Defend the Juggernaut",1), Objective("Destroy the Frozen Hulks", 1),  }, 
	Criticals = nil,
	Criticals2 = nil,
	HulkCount = 3,
	UseBonus = false,
	BonusPool = {}
}

-- Not sure if this is needed; supposed to prevent bonus objectives
--function Mission_tosx_Juggernaut:AddAsset()
--end

function Mission_tosx_Juggernaut:StartMission()
	self.Criticals = {}
	self.Criticals2 = {}
	
	local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_juggernaut")
	table.insert(self.Criticals, pawn:GetId())
	Board:SetTerrain(pawn:GetSpace(), TERRAIN_ROAD)
	Board:AddPawn(pawn, "tosx_juggernaut_zone")
	pawn:SetTeam(TEAM_PLAYER)
	
	for i = 1, self.HulkCount do
		local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_IceHulk")
		table.insert(self.Criticals2, pawn:GetId())
		Board:AddPawn(pawn, "tosx_icehulk_zone"..i)
	end	
	
end

function Mission_tosx_Juggernaut:UpdateObjectives()
	if countAlive(self.Criticals) == 0 then
		Game:AddObjective("Defend the Juggernaut", OBJ_FAILED, REWARD_REP, 1)
	else
		Game:AddObjective("Defend the Juggernaut", OBJ_STANDARD, REWARD_REP, 1)	
	end
	if countAlive(self.Criticals2) > 0 then
		Game:AddObjective("Destroy the Frozen Hulks\n("..countAlive(self.Criticals2).." Remain)", OBJ_STANDARD, REWARD_REP, 1)
	else
		Game:AddObjective("Destroy the Frozen Hulks", OBJ_COMPLETE, REWARD_REP, 1)
	end
end

function Mission_tosx_Juggernaut:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	
	if countAlive(self.Criticals) == 0 then
		ret[1] = ret[1]:Failed()
	end
	
	if countAlive(self.Criticals2) > 0 then
		ret[2] = Objective("Destroy the Frozen Hulks",1):Failed()
	end
	
	return ret
end

tosx_mission_IceHulk = Pawn:new{
	Name = "Frozen Hulk",
	Health = 4,
	Image = "tosx_IceHulk",
	MoveSpeed = 0,
	Neutral = true,
	DefaultTeam = TEAM_NEUTRAL,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/enemy/snowart_1/",
	IsPortrait = false,
	Mission = true,
	Minor = true,
	Armor = true,
}

tosx_mission_juggernaut = Pawn:new{
	Name = "Juggernaut-Mech",
	Health = 1,
	Image = "tosx_JuggernautBot",
	MoveSpeed = 0,
	SkillList = { "tosx_juggernaut_ram" },  
	SoundLocation = "/enemy/snowart_2/",
	Portrait = "enemy/tosx_juggernautbot",
	DefaultFaction = FACTION_BOTS,
	ImpactMaterial = IMPACT_METAL,
	IgnoreSmoke = true,
	Mission = true,
	Massive = true,
	Pushable = true,
	Corpse = true
}

tosx_juggernaut_ram = Skill:new{  
	Name = "Juggernaut Engines",
	Description = "Charge through units, destroying them.",
	Class = "Unique",
	Icon = "weapons/tosx_juggernautbot_ram.png",
	LaunchSound = "/weapons/shield_bash",
	Damage = DAMAGE_DEATH,
	Phasing = 0,
	Range = 7,
	TipImage = {
		Unit = Point(1,2),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(4,2),
		CustomEnemy = "Snowtank2",
		CustomPawn = "tosx_mission_juggernaut",
	}
}

function tosx_juggernaut_ram:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local stillgood = true
		local max_i = 0
		for i = 1,self.Range do
			local point = p1 + DIR_VECTORS[dir]*i
			if stillgood and not Board:IsBlocked(point, Pawn:GetPathProf()) then
				max_i = i
			end
			if self.Phasing ~= 1 and (Board:IsBuilding(point) or Board:IsTerrain(point,TERRAIN_MOUNTAIN)) then
				stillgood = false --needed?
				break
			end
		end
		if max_i > 0 then
			for i = 1,max_i do
				point = p1 + DIR_VECTORS[dir]*i
				ret:push_back(point)
			end
		end
	end
	return ret
end

function tosx_juggernaut_ram:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local endcharge = p2
	local direction = GetDirection(p2 - p1)
	local crushing = false

	-- air graphics to emphasize speed.
	local damage0 = SpaceDamage(p1, 0)
	damage0.sAnimation = "airpush_".. ((direction+2)%4)
	ret:AddDamage(damage0)
	ret:AddDelay(0.5)
	
	-- Jump target to next open tile
	if Board:IsBlocked(p2, Pawn:GetPathProf()) then
		for i = 1,6 do
			local point2 = p2 + DIR_VECTORS[direction]*i
			if not Board:IsBlocked(point2, Pawn:GetPathProf()) then
				endcharge = point2
				break
			end
		end
	end
    local distance = p1:Manhattan(endcharge)
		
	ret:AddCharge(Board:GetPath(p1, endcharge, PATH_FLYER), NO_DELAY)
	
	for i = 1,distance-1 do	
		ret:AddDelay(0.1)
		local midpoint = p1 + DIR_VECTORS[direction]*i
		
		if Board:IsPawnSpace(midpoint) and not crushing then
			if Board:GetPawn(midpoint):GetType() == "tosx_mission_IceHulk" or Board:GetPawnTeam(midpoint) == TEAM_ENEMY then
				local chance = math.random()
				if chance > 0.3 then
					ret:AddVoice("Mission_tosx_Juggernaut_Ram",-1)
				end
				
				crushing = true
			end
		end
		
		local dodamage = true		
		if Board:IsBuilding(midpoint) then
			dodamage = false
		end
		
		if dodamage == true then
			local damage = SpaceDamage(midpoint,self.Damage)
			ret:AddDamage(damage)
		end
	end
	return ret
end



function this:init(mod)
	modApi:appendAsset("img/units/enemy/tosx_juggernautbot.png", mod.resourcePath .."img/units/mission/juggernautbot.png")
	modApi:appendAsset("img/units/enemy/tosx_juggernautbot_ns.png", mod.resourcePath .."img/units/mission/juggernautbot_ns.png")
	modApi:appendAsset("img/units/enemy/tosx_juggernautbot_a.png", mod.resourcePath .."img/units/mission/juggernautbot_a.png")
	modApi:appendAsset("img/units/enemy/tosx_juggernautbot_w.png", mod.resourcePath .."img/units/mission/juggernautbot_w.png")
	modApi:appendAsset("img/units/enemy/tosx_juggernautbot_broken.png", mod.resourcePath .."img/units/mission/juggernautbot_broken.png")
	modApi:appendAsset("img/units/enemy/juggernautbot_w_broken.png", mod.resourcePath .."img/units/mission/juggernautbot_w_broken.png")
	modApi:appendAsset("img/weapons/tosx_juggernautbot_ram.png", mod.resourcePath.. "img/weapons/tosx_juggernautbot_ram.png")
	modApi:appendAsset("img/portraits/enemy/tosx_juggernautbot.png", mod.resourcePath.. "img/portraits/mission/tosx_juggernautbot.png")

	local a = ANIMS
	a.tosx_JuggernautBot = a.BaseUnit:new{Image = "units/enemy/tosx_juggernautbot.png", PosX = -24, PosY = -9}
	a.tosx_JuggernautBota = a.tosx_JuggernautBot:new{Image = "units/enemy/tosx_juggernautbot_a.png", NumFrames = 4 }
	a.tosx_JuggernautBotw = a.tosx_JuggernautBot:new{Image = "units/enemy/tosx_juggernautbot_w.png", PosX = -17, PosY = 9}
	a.tosx_JuggernautBot_broken = a.tosx_JuggernautBot:new{Image = "units/enemy/tosx_juggernautbot_broken.png", PosX = -23, PosY = -8}
	a.tosx_JuggernautBotw_broken = a.tosx_JuggernautBot:new{Image = "units/enemy/juggernautbot_w_broken.png", PosX = -17, PosY = 9}
	a.tosx_JuggernautBot_ns = a.tosx_JuggernautBot:new{Image = "units/enemy/tosx_juggernautbot_ns.png"}

	modApi:appendAsset("img/units/enemy/tosx_icehulk.png", mod.resourcePath .."img/units/mission/tosx_icehulk.png")
	modApi:appendAsset("img/units/enemy/tosx_icehulk_d.png", mod.resourcePath .."img/units/mission/tosx_icehulk_d.png")

	local a = ANIMS
	a.tosx_IceHulk = a.BaseUnit:new{Image = "units/enemy/tosx_icehulk.png", PosX = -20, PosY = -12}
	a.tosx_IceHulkd = a.tosx_IceHulk:new{Image = "units/enemy/tosx_icehulk_d.png", PosX = -22, PosY = -10, NumFrames = 11, Time = 0.14, Loop = false }
		
	for i = 0, 5 do
		modApi:addMap(mod.resourcePath .."maps/tosx_juggernaut".. i ..".map")
	end
end

function this:load(mod, options, version)
	corpMissions.Add_Missions_High("Mission_tosx_Juggernaut", "Corp_Snow")
end

return this