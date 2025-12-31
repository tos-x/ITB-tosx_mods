-- mission Mission_tosx_Lighthouse
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")

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

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Lighthouse", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the Lighthouse", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Lighthouse", 1):Failed() end,
	[1] = function() return Objective("Defend the Lighthouse", 1) end,
	default = function() return nil end,
}

Mission_tosx_Lighthouse = Mission_Infinite:new{
	Name = "Lighthouse",
	MapTags = {"tosx_lighthouse"},
	Objectives = {objAfterMission:case(1),Objective("Clear Smoke from Water tiles", 1)},
	Criticals = nil,
	SpawnStartMod = 1,
	UseBonus = false,
    StartingSmoke = nil,
}

-- Add CEO dialog
local dialog = require(path .."missions/lighthouse_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Lighthouse", dialogTable)
end

function Mission_tosx_Lighthouse:StartMission()
	self.Criticals = {}
	local options = extract_table(Board:GetZone("lighthouse"))
	
	local choice = random_removal(options)
	if not choice then
		LOG("NO LIGHTHOUSE ZONE")
		return
	end
	local lighthouse = PAWN_FACTORY:CreatePawn("tosx_lighthouse1")
	self.Criticals[1] = lighthouse:GetId()
	Board:SetTerrain(choice, TERRAIN_ROAD)
	Board:AddPawn(lighthouse, choice)
    
	self.StartingSmoke = {}
    self:waterSmoke()
end

function Mission_tosx_Lighthouse:waterSmoke()
	local count = 0
	for i = 0,7 do
		for j = 0,7 do
			local p = Point(i,j)
			if Board:IsSmoke(p) and Board:GetTerrain(p) == TERRAIN_WATER then
				count = count + 1
                if not self.Counted then
                    -- This would block deployment; harmless since water tiles shouldn't spawn
                    --Board:BlockSpawn(p, BLOCKED_PERM)
                    
                    -- First time, record starting smoke tiles
                    self.StartingSmoke[p2idx(p)] = true
                end
			end
            if Game:GetTurnCount() < 1 and self.StartingSmoke[p2idx(p)] and self.Counted then
                -- During deployment, replace smoke lost to mech placement effects, just in case
                if not (Board:IsPawnSpace(p) and Board:GetPawn(p):IsMech()) then
                    Board:SetSmoke(p, true, true)
                end
            end
		end
	end
    
    self.Counted = true
	return count
end

function Mission_tosx_Lighthouse:UpdateObjectives()
	objInMission:case(countAlive(self.Criticals))
	
	local status = self:waterSmoke() > 0 and OBJ_STANDARD or OBJ_COMPLETE
	Game:AddObjective("Clear Smoke from Water tiles ("..tostring(self:waterSmoke()).." remain)", status, REWARD_REP, 1)
end

function Mission_tosx_Lighthouse:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	ret[1] = objAfterMission:case(countAlive(self.Criticals))
	
	ret[2] = Objective("Clear Smoke from Water tiles", 1, 1)
	if self:waterSmoke() > 0 then
		ret[2] = Objective("Clear Smoke from Water tiles ("..tostring(self:waterSmoke()).." remain)", 0, 1)
	end
	return ret
end

function Mission_tosx_Lighthouse:GetCompletedStatus()
	if countAlive(self.Criticals) > 0 and self:waterSmoke() == 0 then
		return "Success"
	elseif countAlive(self.Criticals) == 0 and self:waterSmoke() == 0 then
		return "SmokeOnly"
	elseif countAlive(self.Criticals) > 0 and self:waterSmoke() > 0 then
		return "LightOnly"
	else
		return "Failure"
	end
end


tosx_lighthouse1 = Pawn:new{
	Name = "Lighthouse",
	Health = 2,
	--SpaceColor = false,
	MoveSpeed = 0,
	Image = "tosx_lighthouse",
	DefaultTeam = TEAM_PLAYER,
	--IsPortrait = false,
	Mission = true,
	SkillList = { "tosx_Lighthouse_Attack" }, 	
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/support/terraformer",
	Pushable = false,
	NonGrid = true,
	Corporate = true,
	IgnoreSmoke = true,
	--PilotDesc = "Far Line \nLighthouse Keeper", -- Doesn't do anything
}

tosx_Lighthouse_Attack = Grenade_Base:new{
	Name = "Fresnel Lens",
	Description = "Cancel attacks and remove Smoke on target tiles.",
	Icon = "weapons/tosx_bright_lens.png",
	Class = "Unique",
	LaunchSound = "/impact/generic/tractor_beam",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,1),
		Target = Point(2,1),
		Enemy1 = Point(1,1),
		Queued1 = Point(2,1),
		Smoke = Point(3,1),
		CustomPawn = "tosx_lighthouse1"
	}
}

function tosx_Lighthouse_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local lens0 = SpaceDamage(p1)
	lens0.sAnimation = "tosx_lens_a"
	ret:AddDamage(lens0)
	ret:AddSound("/mech/flying/jet_mech/move")
	
	ret:AddDelay(0.15)
	
	lens0.loc = p2
	lens0.bHide = true
	lens0.sAnimation = "tosx_lens2_a"
	ret:AddDamage(lens0)
	
	local lens = SpaceDamage(p2,0,5) --5 gives a directionless push square
	lens.iSmoke = EFFECT_REMOVE
	ret:AddDamage(lens)
	
	local ps = {}
	ps[1] = p2
	for i = DIR_START, DIR_END do
		ps[#ps+1] = p2 + DIR_VECTORS[i]
	end
	for i = 1, #ps do
		local p = ps[i]
		--local p = p2 + DIR_VECTORS[i]
		
	-- for i = -1, 1 do
		-- for j = -1, 1 do
			-- local p = p2 + Point(i,j)
			if Board:IsValid(p) then
				lens.loc = p		
				lens.sImageMark = "combat/icons/tosx_stasisSmoke_off_glowB.png"
				lens.sAnimation = ""
				
				-- Break webs too
				if Board:IsPawnSpace(p) then
					ret:AddScript("Board:GetPawn(Point("..p:GetString()..")):ClearQueued()")	
					lens.sImageMark = "combat/icons/tosx_stasisSmoke_glowB.png"
					local pawn2 = Board:GetPawn(p)
					if not (_G[pawn2:GetType()].ExtraSpaces[1] or pawn2:IsGuarding()) then
						ret:AddScript([[Board:GetPawn(]]..pawn2:GetId()..[[):SetSpace(Point(-1,-1))]])
						ret:AddDelay(0.01)
						ret:AddScript([[Board:GetPawn(]]..pawn2:GetId()..[[):SetSpace(]]..p:GetString()..[[)]])
					end
				end
				if Board:IsSmoke(p) then
					lens.sAnimation = "tosx_SmokeDisappear"
				end
				
				ret:AddDamage(lens)
			end
		end
	-- end
	
	return ret
end

---------------------

modApi:appendAsset("img/units/mission/tosx_lighthouse.png", mod.resourcePath .."img/units/mission/lighthouse.png")
modApi:appendAsset("img/units/mission/tosx_lighthouse_ns.png", mod.resourcePath .."img/units/mission/lighthouse_ns.png")
modApi:appendAsset("img/units/mission/tosx_lighthousea.png", mod.resourcePath .."img/units/mission/lighthousea.png")
modApi:appendAsset("img/units/mission/tosx_lighthouse_d.png", mod.resourcePath .."img/units/mission/lighthouse_d.png")
modApi:appendAsset("img/units/mission/tosx_sub1_dg.png", mod.resourcePath .."img/units/mission/sub1_dg.png")

modApi:appendAsset("img/weapons/tosx_bright_lens.png", mod.resourcePath.. "img/weapons/tosx_bright_lens.png")
modApi:appendAsset("img/effects/tosx_lens_a.png", mod.resourcePath.. "img/effects/tosx_lens_a.png")
modApi:appendAsset("img/effects/tosx_lens2_a.png", mod.resourcePath.. "img/effects/tosx_lens2_a.png")

local a = ANIMS
a.tosx_lighthouse = a.BaseUnit:new{Image = "units/mission/tosx_lighthouse.png", PosX = -30, PosY = -14}
a.tosx_lighthousea = a.tosx_lighthouse:new{Image = "units/mission/tosx_lighthousea.png", NumFrames = 4, Time = 0.5 }
a.tosx_lighthouse_ns = a.tosx_lighthouse:new{Image = "units/mission/tosx_lighthouse_ns.png", PosX = -12, PosY = -9}
a.tosx_lighthoused = a.tosx_lighthouse:new{Image = "units/mission/tosx_lighthouse_d.png", PosX = -19, PosY = -9, NumFrames = 11, Time = 0.12, Loop = false }


modApi:appendAsset("img/combat/icons/tosx_stasisSmoke_glowB.png",mod.resourcePath.."img/combat/icons/tosx_stasisSmoke_glow.png")
	Location["combat/icons/tosx_stasisSmoke_glowB.png"] = Point(-15,9)
modApi:appendAsset("img/combat/icons/tosx_stasisSmoke_off_glowB.png",mod.resourcePath.."img/combat/icons/tosx_stasisSmoke_off_glow.png")
	Location["combat/icons/tosx_stasisSmoke_off_glowB.png"] = Point(-15,9)

a.tosx_lens_a = Animation:new{
	Image = "effects/tosx_lens_a.png",
	NumFrames = 11,
	Time = 0.05,
	PosX = -47,
	PosY = -20,
	Loop = false
}

a.tosx_lens2_a = Animation:new{
	Image = "effects/tosx_lens2_a.png",
	NumFrames = 9,
	Time = 0.05,
	PosX = -93,
	PosY = -60,
	Loop = false
}

a.tosx_SmokeDisappear = a.SmokeAppear:new{
	Frames = {5,4,3,2,1,0}
}