--mission Mission_tosx_Evac
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

local objAfterMission = switch{
	[0] = function() return Objective("Evacuate the Exosuits", 2):Failed() end,
	[1] = function() return Objective("Evacuate the Exosuits (1 evacuated)", 1, 2) end,
	[2] = function() return Objective("Evacuate the Exosuits", 2) end,
	default = function() return nil end,
}

Mission_tosx_Evac = Mission_Infinite:new{
	Name = "Exosuit Evacuation",
	MapTags = {"satellite", "tosx_towers", "tosx_evac"},
	Objectives = objAfterMission:case(2),
	Criticals = nil,
	UseBonus = false,
	ExoCount = 2,
    ExoPawn = "tosx_Exosuit",
    Evacs = 0,
	Target = Point(-1,-1),
	Environment = "tosx_env_evac",
	SpawnStartMod = 1,
	SpawnMod = 1,
}

-- Add CEO dialog
local dialog = require(path .."missions/evac_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Evac", dialogTable)
end

function Mission_tosx_Evac:StartMission()
	self.Criticals = {}
	local options = extract_table(Board:GetZone("satellite"))
		
	if #options < self.ExoCount then LOG("ERROR NO VALID SPACE") return end
	
	local choice = random_removal(options)
	local exosuit = PAWN_FACTORY:CreatePawn(self.ExoPawn)
	self.Criticals[1] = exosuit:GetId()
	Board:AddPawn(exosuit, choice)
	
	local choice2 = choice
	while math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 and #options > 0 do
		choice2 = random_removal(options)
	end
	
	if math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 then 
		LOG("ERROR NO VALID SECOND SPACE") 
		return 
	end
		
	exosuit = PAWN_FACTORY:CreatePawn(self.ExoPawn)
	self.Criticals[2] = exosuit:GetId()
	Board:AddPawn(exosuit, choice2)
    
    local targets = {}
    for x = 3,4 do
        for y = 2,5 do
            local p = Point(x,y)
            if not Board:IsBuilding(p) and Board:GetTerrain(p) == TERRAIN_ROAD then
                targets[#targets+1] = p
            end
		end
    end
    if #targets < 1 then
        for x = 0,6 do
            for y = 2,5 do
                local p = Point(x,y)
                if not Board:IsBuilding(p) and Board:GetTerrain(p) == TERRAIN_ROAD then
                    targets[#targets+1] = p
                end
            end
            if x == 1 then x = 5 end --x=0,1,6,7
        end
    end
    if #targets < 1 then
        LOG("ERROR NO VALID EVAC TILE") 
		return 
    end
    self.Target = random_removal(targets)
    Board:SetCustomTile(self.Target,"tosx_evacsite.png")
end

function Mission_tosx_Evac:UpdateObjectives()
	local alive = countAlive(self.Criticals)
	if alive == 2 and self.Evacs == 0 and Game:GetTurnCount() == 4 then --2 alive, 1 turn left
		Game:AddObjective("Evacuate both Exosuits\n(0/2 evacuated)", OBJ_STANDARD, REWARD_REP, 2, 1)
	elseif alive == 2 and self.Evacs == 0 then
		Game:AddObjective("Evacuate both Exosuits\n(0/2 evacuated)", OBJ_STANDARD, REWARD_REP, 2)
	elseif alive == 1 and self.Evacs == 1 then
		Game:AddObjective("Evacuate both Exosuits\n(1/2 evacuated)", OBJ_STANDARD, REWARD_REP, 2)
	elseif alive == 0 and self.Evacs == 1 then
		Game:AddObjective("Evacuate both Exosuits\n(1/2 evacuated)", OBJ_COMPLETE, REWARD_REP, 2, 1)
	elseif alive == 0 and self.Evacs > 1 then
		Game:AddObjective("Evacuate both Exosuits\n(2/2 evacuated)", OBJ_COMPLETE, REWARD_REP, 2)
    else--if alive == 0 and self.Evacs == 0 then
		Game:AddObjective("Evacuate both Exosuits", OBJ_FAILED, REWARD_REP, 2)
        if alive == 1 and self.Evacs == 0 then
            Game:AddObjective("Evacuate the remaining Exosuit", OBJ_STANDARD, REWARD_REP, 1)
        end
	end
end

function Mission_tosx_Evac:GetCompletedObjectives()
	return objAfterMission:case(self.Evacs)
end

function Mission_tosx_Evac:GetCompletedStatus()
	if self.Evacs > 1 then
		return "Success"
	elseif self.Evacs == 0 then
		return "Failure"
	else
		return "Partial"
	end
end

tosx_Exosuit = Pawn:new{
	Name = "Vertex Exosuit",
	Health = 1,
	MoveSpeed = 4,
	Image = "tosx_exosuit",
	SkillList = { "tosx_ExoAtk" },
	SoundLocation = "/enemy/snowart_2/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = true,
}

tosx_ExoAtk = Prime_Punchmech:new{
	Name = "Exo Fist",
	Description = "Damage and push an adjacent tile.",
	Icon = "weapons/tosx_exofist.png",
	Class = "Unique",
	Upgrades = 0,
	Damage = 1,
	PathSize = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "tosx_Exosuit",
	}
}

modApi:appendAsset("img/units/mission/tosx_airlifter.png", mod.resourcePath.."img/units/mission/airlifter.png")

modApi:appendAsset("img/units/mission/tosx_exosuit.png", mod.resourcePath.."img/units/mission/exosuit.png")
modApi:appendAsset("img/units/mission/tosx_exosuit_ns.png", mod.resourcePath.."img/units/mission/exosuit_ns.png")
modApi:appendAsset("img/units/mission/tosx_exosuit_a.png", mod.resourcePath.."img/units/mission/exosuit_a.png")
modApi:appendAsset("img/units/mission/tosx_exosuit_d.png", mod.resourcePath.."img/units/mission/exosuit_d.png")

modApi:appendAsset("img/weapons/tosx_exofist.png", mod.resourcePath.."img/weapons/exofist.png")

local a = ANIMS
a.tosx_exosuit = a.BaseUnit:new{Image = "units/mission/tosx_exosuit.png", PosX = -9, PosY = 9}
a.tosx_exosuita = a.tosx_exosuit:new{Image = "units/mission/tosx_exosuit_a.png", PosX = -10, NumFrames = 3, Time = 0.4}
a.tosx_exosuitd = a.tosx_exosuit:new{Image = "units/mission/tosx_exosuit_d.png", PosX = -20, PosY = 3, NumFrames = 11, Time = 0.12, Loop = false }
a.tosx_exosuit_ns = a.tosx_exosuit:new{Image = "units/mission/tosx_exosuit_ns.png"}


tosx_env_evac = Env_Attack:new{
	Name = "Evac Point",--TipTitle; name whenever mousing over
	Decription = "Move an Exosuit here for it to be safely evacuated from the map.",--tile mouseover description
	Decription2 = "This unit will be evacuated at the end of the turn.",--tile mouseover description
	StratText = "EVACUATION",--name that appears on mission select screen
	TipText = "An airship will attempt to evacuate one Exosuit each turn.",--TipText; description that appears on mission select screen
	CombatName = "EVACUATION",--name that appears by turn order
	Text = "An airship will fly over the marked tile, evacuating any Exosuit there to safety.",--description that appears up by the turn order
	CombatIcon = "combat/tile_icon/tosx_icon_env_evac.png",
}

function tosx_env_evac:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
    if Board:IsPawnSpace(space) and Board:GetPawn(space):GetType() == "tosx_Exosuit" then
        Board:MarkSpaceDesc(space,"tosx_env_evac_tile2")
    else
        Board:MarkSpaceDesc(space,"tosx_env_evac_tile")
    end
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	end
end

function tosx_env_evac:GetAttackEffect(space)	
	local effect = SkillEffect()
    
	effect:AddSound("/props/airstrike")
	effect:AddAirstrike(space,"units/mission/tosx_airlifter.png")
	
	local damage = SpaceDamage(space)
	damage.sAnimation = "airpush_1"
	damage.sSound = "/impact/generic/grapple"
    damage.iFire = EFFECT_REMOVE
    effect:AddDamage(damage)
    effect:AddBounce(space,2)
    
    if Board:IsPawnSpace(space) and Board:GetPawn(space):GetType() == "tosx_Exosuit" then
        local d2 = SpaceDamage(space)
        d2.sScript = [[
            Board:RemovePawn(]]..space:GetString()..[[)
            local mission = GetCurrentMission()
            mission.Evacs = mission.Evacs + 1
            ]]
        effect:AddDamage(d2)
        damage.sSound = "/enemy/shared/robot_power_on"
    end
    
	return effect
end

function tosx_env_evac:SelectSpaces()
	local ret = {}
	
	local mission = GetCurrentMission()
	if not mission then return end
    
    if Board:IsValid(mission.Target) and mission.Evacs < 2 then
		ret[1] = mission.Target
	end

	return ret
end

modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_evac.png", mod.resourcePath .."img/combat/tile_icon/icon_env_evac.png")
Location["combat/tile_icon/tosx_icon_env_evac.png"] = Point(-27,2) -- Needed for it to appear on tiles

TILE_TOOLTIPS.tosx_env_evac_tile = {tosx_env_evac.Name, tosx_env_evac.Decription}
TILE_TOOLTIPS.tosx_env_evac_tile2 = {tosx_env_evac.Name, tosx_env_evac.Decription2}
Global_Texts["TipTitle_".."tosx_env_evac"] = tosx_env_evac.Name
Global_Texts["TipText_".."tosx_env_evac"] = tosx_env_evac.TipText