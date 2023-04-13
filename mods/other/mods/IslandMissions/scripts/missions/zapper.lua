-- mission Mission_tosx_Zapper

local path = mod_loader.mods[modApi.currentMod].scriptPath
local this = {id = "Mission_tosx_Zapper"}
--local corpMissions = require(path .."corpMissions")
local corpIslandMissions = require(path .."corpIslandMissions")
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

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Defend the Storm Towers\n(0/2 undamaged)", OBJ_FAILED, REWARD_REP, 2)
	end,
	[1] = function()
		Game:AddObjective("Defend the Storm Towers\n(1/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	[2] = function()
		Game:AddObjective("Defend the Storm Towers\n(2/2 undamaged)", OBJ_STANDARD, REWARD_REP, 2)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Defend the Storm Towers", 2):Failed() end,
	[1] = function() return Objective("Defend the Storm Towers (1 destroyed)", 1, 2) end,
	[2] = function() return Objective("Defend the Storm Towers", 2) end,
	default = function() return nil end,
}

Mission_tosx_Zapper = Mission_Infinite:new{
--At this point, self is the table defining the whole mission type
	Name = "Storm Towers",
	Objectives = objAfterMission:case(2),
	MapTags = {"tosx_zapper"},
	Criticals = nil,
	Powered = { true, true},
	TurnLimit = 4,
	BonusPool = {},
	UseBonus = false,
}

function Mission_tosx_Zapper:StartMission()
	--At this point, self is the table for the ACTUAL instance of mission; the GetCurrentMission() one that resets on Turn Reset; so I don't need a GetCurrentMission() check here, and it fails anyway
	self.tosx_zapperActive = { false, false}

	self.Criticals = {}
	for i = 1,2 do	
		local pawn = PAWN_FACTORY:CreatePawn("tosx_mission_zapper")
		table.insert(self.Criticals, pawn:GetId())
		Board:AddPawn(pawn, "tosx_zapper"..i.."_zone")
		pawn:SetPowered(false)
		
		local wire = Board:GetZone("tosx_zapwire"..i.."_zone"):index(1)
		Board:BlockSpawn(wire, BLOCKED_PERM)
		if Board:GetCustomTile(wire) == "tosx_mission_cableVbreak.png" then --vertical arc
			Board:AddAnimation(wire, "tosx_zaparcVs", ANIM_NO_DELAY)
		else --horizontal arc
			Board:AddAnimation(wire, "tosx_zaparcHs", ANIM_NO_DELAY)
		end
	end	
end

function Mission_tosx_Zapper:NextTurn()
	local mission = GetCurrentMission()
	if not mission then return end
	
	if Game:GetTeamTurn() == TEAM_ENEMY then
		for i = 1,2 do
			mission.tosx_zapperActive[i] = false
		end		
	end
	if Game:GetTeamTurn() == TEAM_PLAYER then
		for i = 1,2 do
			mission.tosx_zapperActive[i] = true
		end		
	end
end
	
function Mission_tosx_Zapper:UpdateMission() --!!! will this update every move?
	local mission = GetCurrentMission()
	if not mission then return end
	
	for i = 1,2 do	
		Board:MarkSpaceDesc(Board:GetZone("tosx_zapwire"..i.."_zone"):index(1), "tosx_mission_arc")
	end
		
	--Stepping on/off animation, powering up/down
	if Board:GetBusyState() == 0 then
		for i = 1,2 do	
			local pawn = Board:GetPawn(self.Criticals[i])
			
			if pawn and not pawn:IsDead() and pawn:GetSpace() == Board:GetZone("tosx_zapper"..i.."_zone"):index(1) then
				point =  Board:GetZone("tosx_zapwire"..i.."_zone"):index(1)
				if Board:IsPawnSpace(point) and not self.Powered[i] then
					pawn:SetPowered(true)
					self.Powered[i] = true
					-- Depowered pawns don't get set to active each team turn
					-- So I have to manually activate them, but I need to know if they've fired yet this turn
					-- (since I don't want to reactivate them if they get power again after firing)
					-- So the cannon weapons set flags that are cleared between turns
					if mission.tosx_zapperActive[i] then
						pawn:SetActive(true)
					else
						pawn:SetActive(false)
					end
					
					local effect = SkillEffect()
					local damage = SpaceDamage(point,0)
					if Board:GetCustomTile(point) == "tosx_mission_cableVbreak.png" then --vertical arc
						damage.sAnimation = "tosx_zaparcV"
					else --horizontal arc
						damage.sAnimation = "tosx_zaparcH"
					end
					effect:AddDamage(damage)
					
					local chance = math.random()
					if chance > 0.2 then
						effect:AddVoice("Mission_tosx_Zapper_On", -1)--!!! ruled dialog low%?
					end
					
					Board:AddEffect(effect)
				elseif self.Powered[i] and not Board:IsPawnSpace(point) then
					pawn:SetPowered(false)
					self.Powered[i] = false
				end
				
			else
				self.Powered[i] = false
			end
		end
	end
	--make specific, variable-sized wire regions to check for unbroken road terrain?
end

function Mission_tosx_Zapper:UpdateObjectives()	
	objInMission:case(countAlive(self.Criticals))
end

function Mission_tosx_Zapper:GetCompletedObjectives()
	return objAfterMission:case(countAlive(self.Criticals))
end
function Mission_tosx_Zapper:GetCompletedStatus()
	if countAlive(self.Criticals) > 1 then
		return "Success"
	elseif countAlive(self.Criticals) == 0 then
		return "Failure"
	else
		return "Partial"
	end
end

tosx_mission_zapper = Pawn:new{
	Name = "Storm Tower",
	Health = 1,
	Image = "tosx_zapper_cannon",
	MoveSpeed = 0,
	SkillList = { "tosx_mission_zapperAtk" },
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	SoundLocation = "/support/civilian_truck/",
	Pushable = false,
	Corporate = true,
}

tosx_mission_zapperAtk = Skill:new{
	Name = "Discharge",
	Description = "Generate lightning to damage a target.",
	Damage = 2,
	Range = 15,
	Class = "Unique",
	Icon = "weapons/tosx_zapper_bolt.png",
	LaunchSound = "/support/civilian_truck/move",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Target = Point(1,1),
		CustomPawn = "tosx_mission_zapper"
	}
}
function Mission_tosx_Zapper:Deactivate(i)
	local mission = GetCurrentMission()
	if not mission then return end
	
	mission.tosx_zapperActive[i] = false
end

function tosx_mission_zapperAtk:GetTargetArea(p1)
	return general_DiamondTarget(p1, self.Range)
end

function tosx_mission_zapperAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local zap_id = 0
	
	if not IsTipImage() then
		--do some lightning flashing through the wires
		local p3 = p1
		for i = 1,2 do
			if p1 == Board:GetZone("tosx_zapper"..i.."_zone"):index(1) then
				p3 = Board:GetZone("tosx_zapwire"..i.."_zone"):index(1)
				zap_id = i
			end
		end
		
		if p3 ~= p1 then
			local damage = SpaceDamage(p3, 0)
			--lightning arc at p3
			if Board:GetCustomTile(p3) == "tosx_mission_cableVbreak.png" then --vertical arc
				damage.sAnimation = "tosx_zaparcV"
			else --horizontal arc
				damage.sAnimation = "tosx_zaparcH"
			end
			ret:AddDamage(damage)
		end
		ret:AddScript("Mission_tosx_Zapper:Deactivate("..zap_id..")")
	end
	
	local damage = SpaceDamage(p1, 0)
	damage.sAnimation = "tosx_zap_bolt"
	damage.sSound = "/weapons/electric_whip"
	ret:AddDamage(damage)
	ret:AddDelay(0.25)	
	
	local damage = SpaceDamage(p2, self.Damage)
	damage.sAnimation = "LightningBolt"..random_int(2)
	ret:AddSound("/props/lightning_strike")
	ret:AddDelay(1)
	ret:AddDamage(damage)
	
	return ret
end

function this:init(mod)
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cable.png", mod.resourcePath .."img/tileset/tosx_mission_cable.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cable1.png", mod.resourcePath .."img/tileset/tosx_mission_cable1.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cable2.png", mod.resourcePath .."img/tileset/tosx_mission_cable2.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cableH.png", mod.resourcePath .."img/tileset/tosx_mission_cableH.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cableV.png", mod.resourcePath .."img/tileset/tosx_mission_cableV.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cableHbreak.png", mod.resourcePath .."img/tileset/tosx_mission_cableHbreak.png")
	modApi:appendAsset("img/combat/tiles_grass/tosx_mission_cableVbreak.png", mod.resourcePath .."img/tileset/tosx_mission_cableVbreak.png")
	modApi:appendAsset("img/units/mission/tosx_zapper_cannon.png", mod.resourcePath .."img/units/mission/tosx_zapper_cannon.png")
	modApi:appendAsset("img/units/mission/tosx_zapper_cannon_a.png", mod.resourcePath .."img/units/mission/tosx_zapper_cannon_a.png")
	modApi:appendAsset("img/units/mission/tosx_zapper_cannon_d.png", mod.resourcePath .."img/units/mission/tosx_zapper_cannon_d.png")
	modApi:appendAsset("img/units/mission/tosx_zapper_cannon_ns.png", mod.resourcePath .."img/units/mission/tosx_zapper_cannon_ns.png")
	modApi:appendAsset("img/units/mission/tosx_zapper_cannon_off.png", mod.resourcePath .."img/units/mission/tosx_zapper_cannon_off.png")
	modApi:appendAsset("img/effects/tosx_zaparc_V.png", mod.resourcePath .."img/effects/tosx_zaparc_V.png")
	modApi:appendAsset("img/effects/tosx_zaparc_H.png", mod.resourcePath .."img/effects/tosx_zaparc_H.png")
	modApi:appendAsset("img/effects/tosx_zaparc_Vs.png", mod.resourcePath .."img/effects/tosx_zaparc_Vs.png")
	modApi:appendAsset("img/effects/tosx_zaparc_Hs.png", mod.resourcePath .."img/effects/tosx_zaparc_Hs.png")
	modApi:appendAsset("img/effects/tosx_zap_bolt.png", mod.resourcePath .."img/effects/tosx_zap_bolt.png")
	modApi:appendAsset("img/weapons/tosx_zapper_bolt.png", mod.resourcePath.. "img/weapons/tosx_zapper_bolt.png")
	
	local a = ANIMS
	a.tosx_zapper_cannon = a.generator1:new{Image = "units/mission/tosx_zapper_cannon.png"}
	a.tosx_zapper_cannonoff = a.tosx_zapper_cannon:new{Image = "units/mission/tosx_zapper_cannon_off.png"}
	a.tosx_zapper_cannona = a.generator1a:new{Image = "units/mission/tosx_zapper_cannon_a.png"}
	a.tosx_zapper_cannond = a.generator1d:new{Image = "units/mission/tosx_zapper_cannon_d.png"}
	a.tosx_zapper_cannon_ns = a.tosx_zapper_cannon:new{Image = "units/mission/tosx_zapper_cannon_ns.png"}
	
	a.tosx_zaparcV = a.BaseUnit:new{Image = "effects/tosx_zaparc_V.png", PosX = -37, PosY = -19, NumFrames = 4, Time = 0.1, Loop = false}
	a.tosx_zaparcH = a.tosx_zaparcV:new{Image = "effects/tosx_zaparc_H.png"}
	
	a.tosx_zaparcVs = a.BaseUnit:new{Image = "effects/tosx_zaparc_Vs.png", PosX = -37, PosY = -19, NumFrames = 4, Frames = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3}, Time = .1, Loop = true}
	a.tosx_zaparcHs = a.tosx_zaparcVs:new{Image = "effects/tosx_zaparc_Hs.png"}
	
	a.tosx_zap_bolt = a.BaseUnit:new{Image = "effects/tosx_zap_bolt.png", PosX = -14, PosY = -90, NumFrames = 1, Time = 0.25, Loop = false}
	
	for i = 0, 5 do
		modApi:addMap(mod.resourcePath .."maps/tosx_zapper".. i ..".map")
	end
	
	TILE_TOOLTIPS.tosx_mission_arc = {"Broken Conduit", "Power cannot flow through this tile unless a unit is occupying it."}
end

function this:load(mod, options, version)
	-- corpMissions.Add_Missions_Low("Mission_tosx_Zapper", "Corp_Desert")
	corpIslandMissions.Add_Missions_Low("Mission_tosx_Zapper", "rst")
end

return this