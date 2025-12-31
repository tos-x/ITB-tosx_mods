-- local VERSION = "0.0.2"

-- This code populates missions with cracked mountain tiles, based on tileset chance
-- It also makes destroyed mountains explode for 1 damage to non-buildings

-- Issue list
-- 		Terrain animation
-- 		-	Displaying the anim above other terrain icons and high-ranked tiles (spawn block hand icon)
--		Lib logic (see boilerplate)

local mod = modApi:getCurrentMod()
local path = mod_loader.mods[modApi.currentMod].scriptPath

local customAnim = require(path .."libs/customAnim")
local weaponArmed = require(path .."libs/weaponArmed")
require(path.."libs/boardEvents")
	
local terraintile = {
	StatusIcon = "tosx_crystalmtn",
	DamageAnim = "tosx_crystalmtn_icona",
	TileTooltip = {"Crystal Mountain Tile", "Blocks movement and projectiles. Damage twice to destroy, dealing 1 damage to adjacent non-Building tiles."},
	TileTooltipD = {"Damaged Crystal Mountain Tile", "Blocks movement and projectiles. One hit will destroy it, dealing 1 damage to adjacent non-Building tiles."},
	TileTooltipR = "Crystal Mountain Rubble", "No special effect.",
	MaxTiles = 10,
	}

-- TERRAIN constant; choose something unique! (somehow)
TERRAIN_CRYSTALMTN = 522
	
-- Set up array strings
local terrainTip 		= terraintile.StatusIcon.."_tip"
local terrainAnimStart 	= terraintile.StatusIcon.."_animStart"
local terrainDmgTiles 	= terraintile.StatusIcon.."_dmgTiles"
local terrainDmgTilesQ 	= terraintile.StatusIcon.."_dmgTilesQ"
local terrainDmgAnims 	= terraintile.StatusIcon.."_dmgAnims"

local function IsCrystalMtn(point)
    --[[
    3 = Crystal Mountain
    2 = Damaged Crystal Mountain
    1 = Crystal Mountain Rubble
    0 = Other
    ]]
	if modApi:getCurrentTileset() == "Vertex" then
        if Board:GetTerrain(point) == TERRAIN_MOUNTAIN then
            if Board:GetHealth(point) == 1 then
                return 2
            end
            return 3
        end
        if Board:GetTerrain(point) == TERRAIN_RUBBLE then
            return 1
        end
    end
    return 0
end

local function PreMission(mission)
	if not Board or not mission or mission.ID == "Mission_Final" then return end
	local curr_tileset = easyEdit.tileset:get(modApi:getCurrentTileset())
	local terrain_chance = curr_tileset:getEnvironmentChance(TERRAIN_CRYSTALMTN, GetDifficulty())
	
	if terrain_chance then
		local choices = {}
		for i = 0,7 do
			for j = 0,7 do
				local current = Point(i,j)
				if Board:GetTerrain(current) == TERRAIN_MOUNTAIN then
					if math.random(0,100) < terrain_chance then
						choices[#choices+1] = current
					end
				end
			end
		end
		
		local qty = terraintile.MaxTiles or Board:GetSize()
		while (#choices ~= 0 and qty > 0) do
			local current = random_removal(choices)
			Board:DamageSpace(current,1)
			qty = qty - 1
		end
	end
end


local function DamageCustomTile(point,dmg)
	if IsCrystalMtn(point) > 1 and dmg > 0 then
		if dmg == DAMAGE_DEATH then return true end
        if Board:GetHealth(point) == 1 then
            if Board:IsFrozen(point) then return false end
            if Board:IsShield(point) then return false end --memedit to detect shielded mountain
            return true
        end
	end
	return false
end

local function IterateEffects(effect, queued)
	-- Check each skill spaceDamage tile for crystal mountains
	local mission = GetCurrentMission()
	if not mission then return nil end
	mission[terrainDmgTiles] = {}

	-- Clear animation flag each time skill is built and needs to animate
	if not queued then mission[terrainAnimStart] = nil end
	
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if DamageCustomTile(spaceDamage.loc, spaceDamage.iDamage) then		   
			-- Add this tile to our animation list
			-- For some reason, trying to store Points (during FrameDrawn
			-- hooks?) messes them up; store as IDs instead
			mission[terrainDmgTiles][#mission[terrainDmgTiles] + 1] = p2idx(spaceDamage.loc)
		end
	end
	if #mission[terrainDmgTiles] > 0 then return true end
	return nil
end

local function IterateQueuedEffects(effect, pawnid)
	-- Check enemy skill spaceDamage tile for crystal mountains
	local mission = GetCurrentMission()
	if not mission then return nil end
	
	mission[terrainDmgTilesQ] = mission[terrainDmgTilesQ] or {}
	mission[terrainDmgTilesQ][pawnid] = {}
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if DamageCustomTile(spaceDamage.loc, spaceDamage.iDamage) then			
			-- Add this tile to our animation list
			-- For some reason, trying to store Points (during FrameDrawn
			-- hooks?) messes them up; store as IDs instead
			mission[terrainDmgTilesQ][pawnid][#mission[terrainDmgTilesQ][pawnid] + 1] = p2idx(spaceDamage.loc)
		end
	end
end

local onSkillFinal = function(skillEffect, pawn)
	local queued = not skillEffect.q_effect:empty()
	local regularEffect = IterateEffects(skillEffect.effect, queued)
	if not regularEffect then
		IterateQueuedEffects(skillEffect.q_effect, pawn:GetId())
	end
end

local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	if not skillEffect or not pawn then return end
	onSkillFinal(skillEffect, pawn)
end

local onSkillEffect2 = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	if not skillEffect or not pawn then return end
	onSkillFinal(skillEffect, pawn)
end

local function ShowTerrainAnim()
	-- When a player pawn is aiming a weapon, returns true
	local pawn = Board:GetSelectedPawn()
	if pawn and
	   not pawn:IsDead() and
	   pawn:GetArmedWeaponId() > 0 and
	   pawn:GetArmedWeaponId() < 50 then  --0 = move, 50 = repair
		local weapon = weaponArmed:getArmedWeapon()
		if weapon and list_contains(extract_table(weapon:GetTargetArea(pawn:GetSpace())), Board:GetHighlighted()) then
			return true
		end		
	end
	
	-- Otherwise false
	return false
end

local function ShowTerrainAnimQ()
	-- When a player mouses over an attacking enemy, returns true
	local mission = GetCurrentMission()
	if not mission then return false end
	
	local point = Board:GetHighlighted()
	if Board:IsPawnSpace(point) then
		local id = Board:GetPawn(point):GetId()
		if mission[terrainDmgTilesQ] and mission[terrainDmgTilesQ][id] and #mission[terrainDmgTilesQ][id] > 0 then
			local pawn = Board:GetSelectedPawn()
			if pawn and not pawn:IsDead() and pawn:GetArmedWeaponId() > 0 then	
				-- Ignore mousing over enemies while aiming player weapons (except moveSkill)
				return false
			end
			   
			return true
		end
	end
	
	-- Otherwise false
	return false
end

local crystalTitle = ""
local crystalText = ""
local crystalDTitle = ""
local crystalDText = ""
local crystalRTitle = ""

local onTileHighlighted = function(mission, point)	
	-- Override mountain tile tooltip when highlighting Crystals
	-- Board:MarkSpaceDesc is used by environment effects and could conflict
	if Board:IsValid(point) and IsCrystalMtn(point) == 3 then
		crystalTitle = modApi.modLoaderDictionary["Tile_mountain_Title"]
		crystalText = modApi.modLoaderDictionary["Tile_mountain_Text"]
		
		modApi.modLoaderDictionary["Tile_mountain_Title"] = terraintile.TileTooltip[1]
		modApi.modLoaderDictionary["Tile_mountain_Text"] = terraintile.TileTooltip[2]	
	end
	if Board:IsValid(point) and IsCrystalMtn(point) == 2 then
		crystalDTitle = modApi.modLoaderDictionary["Tile_damaged_mountain_Title"]
		crystalDText = modApi.modLoaderDictionary["Tile_damaged_mountain_Text"]
		
		modApi.modLoaderDictionary["Tile_damaged_mountain_Title"] = terraintile.TileTooltipD[1]
		modApi.modLoaderDictionary["Tile_damaged_mountain_Text"] = terraintile.TileTooltipD[2]	
	end
	if Board:IsValid(point) and IsCrystalMtn(point) == 1 then
		crystalRTitle = modApi.modLoaderDictionary["Tile_mnt_rubble_Title"]
		
		modApi.modLoaderDictionary["Tile_mnt_rubble_Title"] = terraintile.TileTooltipR
	end
end

local onTileUnhighlighted = function(mission, point)
	if Board:IsValid(point) and IsCrystalMtn(point) == 3 then	   
		modApi.modLoaderDictionary["Tile_mountain_Title"] = crystalTitle
		modApi.modLoaderDictionary["Tile_mountain_Text"] = crystalText
	end
	if Board:IsValid(point) and IsCrystalMtn(point) == 2 then	   
		modApi.modLoaderDictionary["Tile_damaged_mountain_Title"] = crystalDTitle
		modApi.modLoaderDictionary["Tile_damaged_mountain_Text"] = crystalDText
	end
	if Board:IsValid(point) and IsCrystalMtn(point) == 1 then	   
		modApi.modLoaderDictionary["Tile_mnt_rubble_Title"] = crystalRTitle
	end
end

local FrameDrawn = function(screen)
	-- Draw the crystal animation each frame while aiming, remove when no longer aiming
	local mission = GetCurrentMission()
	if not mission or not Board then return end

	if ShowTerrainAnim() and not mission[terrainAnimStart] then		
		-- First, clear old anims that exist
		if mission[terrainDmgAnims] and #mission[terrainDmgAnims] > 0 then
			for i = 1, #mission[terrainDmgAnims] do
				local point = idx2p(mission[terrainDmgAnims][i])
				customAnim:rem(point, terraintile.DamageAnim)
				--LOG("Remove enemy anim at ",point:GetString())
			end
		end
		mission[terrainDmgAnims] = nil
		
		-- Add new anims
		if mission[terrainDmgTiles] and #mission[terrainDmgTiles] > 0 then
			mission[terrainDmgAnims] = {}
			for i = 1, #mission[terrainDmgTiles] do
				local point = idx2p(mission[terrainDmgTiles][i])
				
				-- For some reason, trying to store Points (during FrameDrawn
				-- hooks?) messes them up; store as IDs instead
				mission[terrainDmgAnims][i] = p2idx(point)
				customAnim:add( point, terraintile.DamageAnim)
				--LOG("Add player anim at ",point:GetString())
			end
		end
		mission[terrainAnimStart] = true
	elseif ShowTerrainAnimQ() and not mission[terrainDmgAnims] then
		-- Add new enemy anims
		local id = Board:GetPawn(Board:GetHighlighted()):GetId()
		
		if mission[terrainDmgTilesQ] and mission[terrainDmgTilesQ][id] and #mission[terrainDmgTilesQ][id] > 0 then
			mission[terrainDmgAnims] = {}
			for i = 1, #mission[terrainDmgTilesQ][id] do
				local point = idx2p(mission[terrainDmgTilesQ][id][i])
				mission[terrainDmgAnims][i] = p2idx(point)
				customAnim:add( point, terraintile.DamageAnim)
				--LOG("Add enemy anim at ",point:GetString())
			end
		end
	elseif mission[terrainDmgAnims] and not ShowTerrainAnim() and not ShowTerrainAnimQ() then
		-- Clear all anims
		for i = 1, #mission[terrainDmgAnims] do
			local point = idx2p(mission[terrainDmgAnims][i])
			customAnim:rem(point, terraintile.DamageAnim)
			--LOG("Blanket clear anim at ",point:GetString())
		end
		mission[terrainDmgAnims] = nil
		mission[terrainAnimStart] = nil
	end
end

local trackedMtns = {}

local function onMountainRemoved(point)
	if modApi:getCurrentTileset() ~= "Vertex" then return end
	trackedMtns[p2idx(point)] = point
end

local function ResetCrystals()
    trackedMtns = {}
end

local function CrystalExplode()
	if modApi:getCurrentTileset() ~= "Vertex" then return end
    
    local Id, loc = next(trackedMtns)          --Get the first tracked dead mtn
    if Id then                                  --If the entry exists
        local effect = SkillEffect()
        effect:AddSound("/impact/generic/explosion")
        
        local damage0 = SpaceDamage(loc, 1)
        --damage0.sAnimation = "tosx_explocrysmain2"
        effect:AddDamage(damage0)
        
        for i = DIR_START,DIR_END do
            local p = loc + DIR_VECTORS[i]
            if Board:IsValid(p) and not Board:IsBuilding(p) then
                local damage = SpaceDamage(p, 1)
                damage.sAnimation = "tosx_explocrys_"..i
                effect:AddDamage(damage)
                --effect:AddBounce(p, 2)
            end
        end
        Board:AddEffect(effect)
        
        trackedMtns[Id] = nil                  --We're done with this mtn, untrack it
    end
end

local function onModsInitialized()
	local ticon = terraintile.StatusIcon
	modApi:appendAsset("img/combat/icons/icon_"..ticon.."_anim.png", mod.resourcePath.."img/terrain/"..ticon.."_anim.png")
	modApi:appendAsset("img/effects/tosx_explo_crys_D.png", mod.resourcePath.."img/effects/explo_crys_D.png")
	modApi:appendAsset("img/effects/tosx_explo_crys_L.png", mod.resourcePath.."img/effects/explo_crys_L.png")
	modApi:appendAsset("img/effects/tosx_explo_crys_R.png", mod.resourcePath.."img/effects/explo_crys_R.png")
	modApi:appendAsset("img/effects/tosx_explo_crys_U.png", mod.resourcePath.."img/effects/explo_crys_U.png")
	modApi:appendAsset("img/effects/tosx_explo_crysmain.png", mod.resourcePath.."img/effects/explo_crysmain.png")
	modApi:appendAsset("img/effects/tosx_explo_crysmain1.png", mod.resourcePath.."img/effects/explo_crysmain1.png")
	modApi:appendAsset("img/effects/tosx_explo_crysmain2.png", mod.resourcePath.."img/effects/explo_crysmain2.png")

	-- Set our terrain tooltip
	TILE_TOOLTIPS[terrainTip] = terraintile.TileTooltip
	
	local a = ANIMS	
	a.tosx_crystalmtn_icona = Animation:new{
		Image = "combat/icons/icon_"..ticon.."_anim.png",
		PosX = -13, PosY = 22,
		Time = 0.15,
		Loop = true,
		Layer = LAYER_SKY,
		NumFrames = 6
	}
    a.tosx_explocrys_0 = a.exploout1_0:new{
		Image = "effects/tosx_explo_crys_U.png",
    }
    a.tosx_explocrys_1 = a.exploout1_1:new{
		Image = "effects/tosx_explo_crys_R.png",
    }
    a.tosx_explocrys_2 = a.exploout1_2:new{
		Image = "effects/tosx_explo_crys_D.png",
    }
    a.tosx_explocrys_3 = a.exploout1_3:new{
		Image = "effects/tosx_explo_crys_L.png",
    }
    a.tosx_explocrysmain = a.ExploArt1:new{
		Image = "effects/tosx_explo_crysmain.png",
    }
    a.tosx_explocrysmain1 = a.explo_fire1:new{
		Image = "effects/tosx_explo_crysmain1.png",
    }
    a.tosx_explocrysmain2 = a.ExploArt1:new{
		Image = "effects/tosx_explo_crysmain2.png",
		PosX = -32, PosY = -11,
		Time = 0.075,
		Loop = false,
		NumFrames = 8
    }
	
	sdlext.addFrameDrawnHook(FrameDrawn)
end

	
local function onModsLoaded()
	modApi:addPreMissionAvailableHook(PreMission)
    modApi:addPreLoadGameHook(ResetCrystals)
    sdlext.addGameExitedHook(ResetCrystals)
	modApi:addMissionEndHook(ResetCrystals)
	modApi:addMissionStartHook(ResetCrystals)
	modApi:addMissionNextPhaseCreatedHook(ResetCrystals)
	modApi:addTestMechEnteredHook(ResetCrystals)
	modApi:addTestMechExitedHook(ResetCrystals)
    
    modApi:addMissionUpdateHook(function(mission)
        if Board:GetBusyState() == 0 then   --Wait for the board to unbusy
            CrystalExplode()                --Explode
        end
    end)
	
    
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
	modapiext:addTileHighlightedHook(onTileHighlighted)
	modapiext:addTileUnhighlightedHook(onTileUnhighlighted)
end

BoardEvents.onMountainRemoved:subscribe(onMountainRemoved)
modApi.events.onModsInitialized:subscribe(onModsInitialized)
modApi.events.onModsLoaded:subscribe(onModsLoaded)