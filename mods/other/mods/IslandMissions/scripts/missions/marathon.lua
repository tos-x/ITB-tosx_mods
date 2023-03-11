-- mission Mission_tosx_Marathon

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Marathon"}
local corpMissions = require(path .."corpMissions")
local switch = require(path .."switch")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

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

---!!!
local function IsImovable(point)
	-- True if obstacle (mountain, building) or guarding pawn; false otherwise
	if Board:IsPawnSpace(point) then return Board:GetPawn(point):IsGuarding() end
	return Board:IsBlocked(point,PATH_PROJECTILE)
end
---!!!

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Portal Tender", OBJ_FAILED, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Defend the Portal Tender", OBJ_STANDARD, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Portal Tender", 1):Failed() end,
	[1] = function() return Objective("Defend the Portal Tender", 1) end,
	default = function() return nil end,
}

Mission_tosx_Marathon = Mission_Critical:new{
	Name = "Anomaly Storm",
	BonusPool = { BONUS_KILL_FIVE, BONUS_GRID, BONUS_MECHS, BONUS_BLOCK },
	MapTags = { "tosx_marathon" },
	Objectives = objAfterMission:case(1),
	Criticals = nil,
	Environment = "tosx_env_warps",
	Criticals = nil,
	UseBonus = true,
	TurnLimit = 4,
	SpawnStartMod = 1,
	--SpawnMod = 1,
	--MaxEnemy = 8,
}

--Need to prevent "defend structure" objectives getting added, otherwise can end up with 3 rep mission somehow
function Mission_tosx_Marathon:AddAsset()
end

function Mission_tosx_Marathon:StartMission()
	self.Criticals = {}
	local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_warper")
	table.insert(self.Criticals, pawn:GetId())
	Board:AddPawn(pawn, "tosx_marathon_zone")
	pawn:SetTeam(TEAM_PLAYER)
end

function Mission_tosx_Marathon:UpdateObjectives()	
	objInMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Marathon:GetCompletedObjectives()
	return objAfterMission:case(countAlive(self.Criticals))
end

tosx_env_warps = Environment:new{
	Name = "Teleporter Anomaly",
	Text = "Units on the marked tiles will swap places, or die and destroy the other tile if blocked.",
	StratText = "TELEPORTER ANOMALY",
	CombatIcon = "combat/tile_icon/tosx_icon_env_warp.png",
	CombatName = "ANOMALY",
	Locations = nil,
	Planned = true,
	effectFinished = false,
}

function tosx_env_warps:Start()
	self.Locations = {}
end

function tosx_env_warps:Plan()
	local ret = {}
	local teleports = {}
	local quarters = Environment:GetQuarters()
	
	for i,options in pairs(quarters) do
		local curr = Point(-1,-1)
		while #options > 0 and (not Board:IsValid(curr) or Board:IsBuilding(curr)) do
			curr = random_removal(options)
		end
		teleports[#teleports+1] = curr
	end	
	for i = 1, 2 do
		self.Locations[i] = random_removal(teleports)
		--LOG("p: "..self.Locations[i]:GetString())
		--LOG(tostring(GetCurrentMission().LiveEnvironment.Locations[i]:GetString()))
	end
	self.MarkInProgress = true
	self.MarkLocations = {}

	return false -- done planning for this turn.
end

function tosx_env_warps:IsEffect()
	return #self.Locations ~= 0
end

function tosx_env_warps:MarkBoard()
	if self:IsEffect() then
		if self.MarkInProgress and not Board:IsBusy() then
			local fx = SkillEffect()
			
			for i, loc in ipairs(self.Locations) do
				if not list_contains(self.MarkLocations, loc) then
					fx:AddScript(string.format("table.insert(GetCurrentMission().LiveEnvironment.MarkLocations, %s)", loc:GetString()))
					fx:AddSound("/props/square_lightup")
					if i == #self.Locations then
						fx:AddScript("GetCurrentMission().LiveEnvironment.MarkInProgress = nil")
					else
					end
					fx:AddDelay(.10)
				end
			end
			
			Board:AddEffect(fx)
		end
	end
	for i = 1,2 do
		if self.MarkLocations and self.MarkLocations[i] then
			local point = self.MarkLocations[i]
			Board:MarkSpaceImage(point, self.CombatIcon, GL_Color(255,226,88,0.75))
			Board:AddAnimation(point, "tosx_mission_warp_sqlight"..i, ANIM_NO_DELAY)
			
			---!!!
			if not IsImovable(point) then
				-- Regular teleport will happen
				Board:MarkSpaceDesc(point, "tosx_env_warps_tip"..i)
			else
				-- This spot is blocked by an obstacle or guarding pawn; show extra icon and revised description
				Board:MarkSpaceDesc(point, "tosx_env_warps_tip"..i.."b")
				Board:AddAnimation(point, "tosx_icon_tele_"..i.."_animX", ANIM_NO_DELAY)
			end
			---!!!
		end
	end
end

function tosx_env_warps:ApplyEffect()
	local effect = SkillEffect()
	effect.iOwner = ENV_EFFECT
	
	loc1 = self.MarkLocations[1]
	loc2 = self.MarkLocations[2]
		
	local on1 = 0
	local on2 = 0
	local dest1 = loc2
	local dest2 = loc1
	
	if Board:IsPawnSpace(loc1) then
		on1 = on1+1
		if Board:GetPawn(loc1):IsGuarding() then
			dest1 = loc1
		else
			on1 = on1-1
			on2 = on2+1
		end
	end
	if Board:IsPawnSpace(loc2) then
		on2 = on2+1
		if Board:GetPawn(loc2):IsGuarding() then
			dest2 = loc2
		else
			on2 = on2-1
			on1 = on1+1
		end
	end
	if on1 == 0 and on2 == 0 then
		-- No units; make one
		local pawnvis = PAWN_FACTORY:CreatePawn("tosx_mission_emptypawn")
		Board:AddPawn(pawnvis,loc1)
	elseif not Board:IsPawnSpace(loc1) and Board:IsBlocked(loc1, PATH_PROJECTILE) then
		--Mountain or something; only count if there was a real pawn
		on1 = on1+1
	elseif not Board:IsPawnSpace(loc2) and Board:IsBlocked(loc2, PATH_PROJECTILE) then
		--Mountain or something; only count if there was a real pawn
		on2 = on2+1
	end
	effect:AddSound("/weapons/swap")
	
	-- At this point it's possible loc = empty and only target = occupied, so first teleport may be wasted (is okay)
	local delay = Board:IsPawnSpace(dest1) and 0 or FULL_DELAY
	effect:AddTeleport(loc1,dest1, delay)
		
	if delay ~= FULL_DELAY then
		effect:AddTeleport(loc2,dest2, FULL_DELAY)
	end
	
	-- Cleanup time
	if on1 == 0 and on2 == 0 then
		--emptypawn is headed to loc2
		effect:AddScript([[
			local pawn = Board:GetPawn(Point(]]..loc2:GetString()..[[))
			Board:RemovePawn(pawn)
		]])
	elseif on1 == 2 or on2 == 2 then
		glitch = loc1
		if on2 == 2 then glitch = loc2 end
		local damage = SpaceDamage(glitch, DAMAGE_DEATH)
		damage.sAnimation = "ExploRepulse3"
		damage.sSound = "/weapons/science_repulse"
		effect:AddDamage(damage)
	end
	effect:AddScript("GetCurrentMission().LiveEnvironment.Locations = {}")
	effect:AddScript("GetCurrentMission().LiveEnvironment.MarkLocations = {}")
	effect:AddDelay(0.50)
	Board:AddEffect(effect)
	
	return false -- effects done for this turn.
end

function Mission_tosx_Marathon:UpdateMission()
end

tosx_mission_emptypawn = Pawn:new{
	Name = "EmptyWarp",
	Health = 1,
	Neutral = true,
	MoveSpeed = 0,
	IsPortrait = false,
	Image = "tosx_mission_emptypawn",
	DefaultTeam = TEAM_NONE,
	Flying = true,
	Mission = true,
	ImpactMaterial = IMPACT_SHIELD
	}

tosx_mission_warper = Pawn:new{
	Name = "Portal Tender",
	Health = 1,
	Image = "tosx_warper",
	MoveSpeed = 4,
	SkillList = { "tosx_mission_warperAtk1" ,  "tosx_mission_warperAtk2"},  
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corporate = true,
	Mission = true,
	Flying = true,
}

tosx_mission_warperAtk1 = Skill:new{  
	Name = "Red Attenuator",
	--Description = "Relocate the red Anomaly.",
	Description = "Relocate the red Anomaly. Targeting the red Anomaly will trigger a teleport.",
	Class = "Unique",
	Icon = "weapons/tosx_warpergun1.png",
	LaunchSound = "/impact/generic/tractor_beam",
	ImpactSound = "/weapons/enhanced_tractor",
	ArtillerySize = 8,
	Color = 1,
	Pull = false,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(2,0),
		Enemy2 = Point(0,5),
		CustomPawn = "tosx_mission_warper",
	}
}

tosx_mission_warperAtk2 = tosx_mission_warperAtk1:new{  
	Name = "Blue Attenuator",
	--Description = "Relocate the blue Anomaly.",
	Description = "Relocate the blue Anomaly. Targeting the blue Anomaly will trigger a teleport.",
	Icon = "weapons/tosx_warpergun2.png",
	Color = 2,
}

function tosx_mission_warperAtk1:GetTargetArea(point)
	local mission = GetCurrentMission()
	if not mission then return end
	
	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			-- Don't allow anomaly 1 to be targeted at anomaly 2, and vice versa
			if curr ~= mission.LiveEnvironment.Locations[3-self.Color] then
				ret:push_back(curr)
			end
		end
	end
	
	if IsTipImage() then
		local p3 = Point(0,2)
		if Board:IsPawnSpace(Point(0,5)) then
			Board:GetPawn(Point(0,5)):SetSpace(Point(1,5))
			local fakedamage = SpaceDamage(p3,0)
			fakedamage.sAnimation = "tosx_mission_warp_sqt"..self.Color.."tip"
			local e = SkillEffect()
			e:AddDamage(fakedamage)
			Board:AddEffect(e)
		end
	end
	
	return ret
end

function Mission_tosx_Marathon:Relocate(point, color)
	local mission = GetCurrentMission()
	if not mission then return end
	--LOG("Point: "..point:GetString()..", Color:"..color)
	mission.LiveEnvironment.Locations[color] = point
	mission.LiveEnvironment.MarkLocations[color] = point
end

function tosx_mission_warperAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local p4 = p2 + DIR_VECTORS[direction]
	
	local damage = SpaceDamage(p2,0)
	damage.sAnimation = "tosx_explo_new_warp"..self.Color
	damage.sImageMark = "combat/icons/tosx_icon_tele_"..self.Color.."_glow.png"	
	local damage2 = SpaceDamage(p2,0)
	damage2.sImageMark = "combat/icons/tosx_icon_tele_"..self.Color.."_glowX.png"
	local damage3 = SpaceDamage(p4,0,GetDirection(p1 - p2))
	damage3.sAnimation = "airpush_"..GetDirection(p1 - p2)
	
	if not IsTipImage() then
		local mission = GetCurrentMission()
		if not mission then return end
		local p3 = mission.LiveEnvironment.Locations[self.Color]
		
		if p3 == p2 then
			damage.sImageMark = ""
		end
		
		ret:AddBounce(p1, 1)
		ret:AddArtillery(damage, "effects/tosx_shot_warper"..self.Color..".png")
		--LOG("C "..p3:GetString())
		--LOG("d.loc "..damage2.loc:GetString())
		if p3 ~= p2 then
			damage2.loc = p3
			ret:AddScript("Mission_tosx_Marathon:Relocate("..p2:GetString()..","..self.Color..")")
			ret:AddDamage(damage2)
		else
			local loc1 = mission.LiveEnvironment.Locations[1]
			local loc2 = mission.LiveEnvironment.Locations[2]
			
			-- Have to duplicate the code or I don't get a weapon preview :(
			local on1 = 0
			local on2 = 0
			local dest1 = loc2
			local dest2 = loc1
			
			if Board:IsPawnSpace(loc1) then
				on1 = on1+1
				if Board:GetPawn(loc1):IsGuarding() then
					dest1 = loc1
				else
					on1 = on1-1
					on2 = on2+1
				end
			end
			if Board:IsPawnSpace(loc2) then
				on2 = on2+1
				if Board:GetPawn(loc2):IsGuarding() then
					dest2 = loc2
				else
					on2 = on2-1
					on1 = on1+1
				end
			end
			if on1 == 0 and on2 == 0 then
				-- No units; make one
				ret:AddScript([[
					local pawnvis = PAWN_FACTORY:CreatePawn("tosx_mission_emptypawn")
					Board:AddPawn(pawnvis,]]..loc1:GetString()..[[)
				]])
				-- local pawnvis = PAWN_FACTORY:CreatePawn("tosx_mission_emptypawn")
				-- Board:AddPawn(pawnvis,loc1)
			elseif not Board:IsPawnSpace(loc1) and Board:IsBlocked(loc1, PATH_PROJECTILE) then
				--Mountain or something; only count if there was a real pawn
				on1 = on1+1
			elseif not Board:IsPawnSpace(loc2) and Board:IsBlocked(loc2, PATH_PROJECTILE) then
				--Mountain or something; only count if there was a real pawn
				on2 = on2+1
			end
			ret:AddSound("/weapons/swap")
			
			-- At this point it's possible loc = empty and only target = occupied, so first teleport may be wasted (is okay)
			local delay = Board:IsPawnSpace(dest1) and 0 or FULL_DELAY
			ret:AddTeleport(loc1,dest1, delay)
				
			if delay ~= FULL_DELAY then
				ret:AddTeleport(loc2,dest2, FULL_DELAY)
			end
			
			-- Cleanup time
			if on1 == 0 and on2 == 0 then
				--emptypawn is headed to loc2
				ret:AddScript([[
					local pawn = Board:GetPawn(Point(]]..loc2:GetString()..[[))
					Board:RemovePawn(pawn)
				]])
			elseif on1 == 2 or on2 == 2 then
				glitch = loc1
				if on2 == 2 then glitch = loc2 end
				local damage = SpaceDamage(glitch, DAMAGE_DEATH)
				damage.sAnimation = "ExploRepulse3"
				damage.sSound = "/weapons/science_repulse"
				ret:AddDamage(damage)
			end
			
		end
		if Board:IsValid(p4) and self.Pull then ret:AddDamage(damage3) end
	else --TipImage
		local p3 = Point(0,2)
		local fakedamage = SpaceDamage(p3,0)
		fakedamage.sAnimation = "tosx_mission_warp_sqt"..self.Color.."tip"
		
		ret:AddBounce(p1, 1)
		--damage.bHide = true
		ret:AddArtillery(damage, "effects/tosx_shot_warper"..self.Color..".png")
		damage2.loc = p3
		--damage2.bHide = true
		ret:AddDamage(damage2)
		fakedamage.loc = p2
		fakedamage.bHide = true
		ret:AddDamage(fakedamage)
		--damage3.bHide = true
		if self.Pull then ret:AddDamage(damage3) end
	end
	
	return ret
end






function this:init(mod)
	modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_warp.png", mod.resourcePath .."img/combat/icon_env_warp.png")
		Location["combat/tile_icon/tosx_icon_env_warp.png"] = Point(-27,2)
	modApi:appendAsset("img/units/enemy/tosx_empty_unit.png", mod.resourcePath .."img/units/mission/empty_unit.png")
	modApi:copyAsset("img/combat/icons/icon_tele_A_glow.png", "img/combat/icons/tosx_icon_tele_1_glow.png")
		Location["combat/icons/tosx_icon_tele_1_glow.png"] = Point(-13,10)
	modApi:copyAsset("img/combat/icons/icon_tele_B_glow.png", "img/combat/icons/tosx_icon_tele_2_glow.png")
		Location["combat/icons/tosx_icon_tele_2_glow.png"] = Point(-13,10)
	for i = 1,2 do
		modApi:appendAsset("img/effects/tosx_shot_warper"..i..".png", mod.resourcePath .."img/effects/shot_warper"..i..".png")
		modApi:appendAsset("img/effects/tosx_explo_new_warp"..i..".png", mod.resourcePath .."img/effects/explo_new_warp"..i..".png")		
		modApi:appendAsset("img/combat/icons/tosx_icon_tele_"..i.."_glowX.png", mod.resourcePath .."img/combat/icons/icon_tele_"..i.."_glowX.png")
			Location["combat/icons/tosx_icon_tele_"..i.."_glowX.png"] = Point(-13,10)
		modApi:appendAsset("img/effects/tosx_warp_sqlight"..i..".png", mod.resourcePath .."img/effects/warp_sqlight"..i..".png")
		modApi:appendAsset("img/weapons/tosx_warpergun"..i..".png", mod.resourcePath.. "img/weapons/tosx_warpergun"..i..".png")

	end
	modApi:appendAsset("img/units/mission/tosx_warper.png", mod.resourcePath .."img/units/mission/warper.png")
	modApi:appendAsset("img/units/mission/tosx_warper_a.png", mod.resourcePath .."img/units/mission/warper_a.png")
	modApi:appendAsset("img/units/mission/tosx_warper_d.png", mod.resourcePath .."img/units/mission/warper_d.png")
	modApi:appendAsset("img/units/mission/tosx_warper_ns.png", mod.resourcePath .."img/units/mission/warper_ns.png")

	TILE_TOOLTIPS.tosx_env_warps_tip1 = {"Teleporter Anomaly", "Any unit here will swap places with the blue Anomaly, or die and destroy that tile if blocked."}
	TILE_TOOLTIPS.tosx_env_warps_tip2 = {"Teleporter Anomaly", "Any unit here will swap places with the red Anomaly, or die and destroy that tile if blocked."}
	
	---!!!
	TILE_TOOLTIPS.tosx_env_warps_tip1b = {"Teleporter Anomaly", "This tile cannot be teleported; if a unit teleports here from the blue Anomaly, this tile will be destroyed."}
	TILE_TOOLTIPS.tosx_env_warps_tip2b = {"Teleporter Anomaly", "This tile cannot be teleported; if a unit teleports here from the red Anomaly, this tile will be destroyed."}
	---!!!
	
	Global_Texts["TipTitle_".."tosx_env_warps"] = tosx_env_warps.Name
	Global_Texts["TipText_".."tosx_env_warps"] = tosx_env_warps.Text
	
	local a = ANIMS
	a.tosx_mission_emptypawn = a.BaseUnit:new{Image = "units/enemy/tosx_empty_unit.png"}
	a.tosx_mission_emptypawna = a.tosx_mission_emptypawn:new{NumFrames = 1, Loop = false}
	a.tosx_mission_emptypawnd = a.tosx_mission_emptypawna:new{}
	a.tosx_explo_new_warp1 = a.BaseUnit:new{Image = "effects/tosx_explo_new_warp1.png", PosX = -33, PosY = -14, NumFrames = 8, Time = 0.05, Loop = false}
	a.tosx_explo_new_warp2 = a.tosx_explo_new_warp1:new{Image = "effects/tosx_explo_new_warp2.png"}

	a.tosx_mission_warp_sqlight1 = a.BaseUnit:new{Image = "effects/tosx_warp_sqlight1.png", PosX = -37, PosY = -41, NumFrames = 1, Time = 0, Loop = false}
	a.tosx_mission_warp_sqlight2 = a.tosx_mission_warp_sqlight1:new{Image = "effects/tosx_warp_sqlight2.png"}
	a.tosx_mission_warp_sqt1tip = a.tosx_mission_warp_sqlight1:new{Time = 2.3}
	a.tosx_mission_warp_sqt2tip = a.tosx_mission_warp_sqlight2:new{Time = 2.3}
	
	a.tosx_warper = a.BaseUnit:new{Image = "units/mission/tosx_warper.png", PosX = -17, PosY = -5}
	a.tosx_warpera = a.tosx_warper:new{Image = "units/mission/tosx_warper_a.png", NumFrames = 2, Time = 0.5}
	a.tosx_warperd = a.tosx_warpera:new{Image = "units/mission/tosx_warper_d.png", PosX = -18, PosY = -10, NumFrames = 11, Time = 0.12, Loop = false }
	a.tosx_warper_ns = a.tosx_warper:new{Image = "units/mission/tosx_warper_ns.png"}
	
	---!!!
	a.tosx_icon_tele_1_animX = a.BaseUnit:new{Image = "combat/icons/tosx_icon_tele_1_glowX.png", PosX = -28, PosY = 10, NumFrames = 1, Time = 0, Loop = false}
	a.tosx_icon_tele_2_animX = a.tosx_icon_tele_1_animX:new{Image = "combat/icons/tosx_icon_tele_2_glowX.png"}
	---!!!
	
	for i = 0, 5 do
		modApi:addMap(mod.resourcePath .."maps/tosx_marathon".. i ..".map")
	end
end

function this:load(mod, options, version)
	corpMissions.Add_Missions_High("Mission_tosx_Marathon", "Corp_Factory")
end

return this