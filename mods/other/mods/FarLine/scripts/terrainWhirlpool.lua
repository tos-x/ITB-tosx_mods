local VERSION = "0.0.1"

-- This code populates missions with Whirlpool terrain tiles, based on tileset chance
-- These tiles turn any damage on them into lethal damage, then go away

-- Issue list
-- 		Terrain animation
-- 		-	Displaying the anim above other terrain icons and high-ranked tiles (spawn block hand icon)
-- 		Explosion damage (non-skill, non-bump)
-- 		-	How to detect and deal with?
--		Lib logic (see boilerplate)
--		Check sScript length for safety; if too long, do separate AddScript, rather than appending a string?


local mod = modApi:getCurrentMod()
local path = mod_loader.mods[modApi.currentMod].scriptPath

local customAnim = require(path .."libs/customAnim")
local weaponArmed = require(path .."libs/weaponArmed")
	
local terraintile = {
	StatusIcon = "tosx_whirlpool",
	DamageAnim = "tosx_whirlpool_icona",
	TileAnim = "tosx_whirlpooltile",
	DamageFunction = "tosx_WhirlpoolOff",
	TileTooltip = {"Whirlpool Tile", "The next damage on this tile will be lethal.\n\nUnits cannot attack in Water. Most non-flying enemies die in Water."},
	StatusTooltip = {"In Whirlpool", "Tile will kill anything on it when damaged, posing great risk to this unit."},
	MaxTiles = 10,
	}

-- TERRAIN constant; choose something unique! (somehow)
TERRAIN_WHIRLPOOL = 520
	
-- Set up array strings
local terrainTip 		= terraintile.StatusIcon.."_tip"
local terrainAnimStart 	= terraintile.StatusIcon.."_animStart"
local terrainDmgTiles 	= terraintile.StatusIcon.."_dmgTiles"
local terrainDmgTilesQ 	= terraintile.StatusIcon.."_dmgTilesQ"
local terrainDmgAnims 	= terraintile.StatusIcon.."_dmgAnims"
local terrainTileImg	= terraintile.StatusIcon.."_0.png"		-- This terrain is "tosx_whirlpool_0.png"

local function PreMission(mission)
	if not Board or not mission or mission.ID == "Mission_Final" then return end
	local curr_tileset = easyEdit.tileset:get(modApi:getCurrentTileset())
	local terrain_chance = curr_tileset:getEnvironmentChance(TERRAIN_WHIRLPOOL, GetDifficulty())
	
	if terrain_chance then
		local choices = {}
		for i = 0,7 do
			for j = 0,7 do
				local current = Point(i,j)
				if Board:GetTerrain(current) == TERRAIN_WATER and
				not Board:IsAcid(current) and
				not Board:IsTerrain(current,TERRAIN_LAVA) and
				not Board:IsBlocked(current,PATH_PROJECTILE) and
				Board:GetCustomTile(current) == "" then
					if math.random(0,100) < terrain_chance then
						choices[#choices+1] = current
					end
				end
			end
		end
		
		local qty = terraintile.MaxTiles or Board:GetSize()
		while (#choices ~= 0 and qty > 0) do
			local current = random_removal(choices)		
			-- Set the custom terrain image
			Board:SetCustomTile(current,terrainTileImg)
			local whirlpool = PAWN_FACTORY:CreatePawn("tosx_whirlpooldummy")
			Board:AddPawn(whirlpool, current)
			qty = qty - 1
		end
	end
end

local function MissionEnd(mission)
	-- Switch from customAnim to regular anim as we end
	for i = 0,7 do
		for j = 0,7 do
			local p = Point(i,j)
			if Board:GetCustomTile(p) == terrainTileImg then
				Board:AddAnimation(p,terraintile.TileAnim,NO_DELAY)
			end
		end
	end	
end

local function MissionUpdate(mission)
	-- First update, replace units with anims
	if not mission.tosx_whirlpools then
		mission.tosx_whirlpools = true
		local pawns = extract_table(Board:GetPawns(TEAM_ANY))
		for i,id in pairs(pawns) do
			if Board:GetPawn(id):GetType() == "tosx_whirlpooldummy" then
				local p = Board:GetPawnSpace(id)
				Board:RemovePawn(Board:GetPawn(id))
				customAnim:add(p, terraintile.TileAnim)
			end
		end
	end

	-- Set the space description and terrain icon each update	
	for i = 0,7 do
		for j = 0,7 do
			local p = Point(i,j)
			if customAnim:get(p, terraintile.TileAnim) then
				if Board:GetTerrain(p) ~= TERRAIN_WATER or
				   Board:IsAcid(p) or
				   Board:GetCustomTile(p) ~= terrainTileImg or
				   Board:IsTerrain(p,TERRAIN_LAVA) then
					-- Our custom terrain should be cleared
					if Board:GetCustomTile(p) == terrainTileImg then
						-- Only using this for mission end; but a mod could
						-- have changed custom tile on us
						Board:SetCustomTile(p,"")
					end
					Board:SetTerrainIcon(p,"")
					customAnim:rem(p, terraintile.TileAnim)
				else
					-- Don't use Board:MarkSpaceDesc, since environment effects need it
					Board:SetTerrainIcon(p,terraintile.StatusIcon)
				end
			end
		end
	end	
end


local function DamageCustomTile(point,dmg)
	if Board:GetCustomTile(point) == terrainTileImg and
	   dmg > 0 then
		if not Board:IsPawnSpace(point) then return true end
		-- It is a pawn
		if dmg == DAMAGE_DEATH then return true end
		if Board:GetPawn(point):IsFrozen() then return false end
		if Board:GetPawn(point):IsShield() then return false end
		return true
	end
	return false
end

local function IterateEffects(effect, queued)
	-- Check each skill spaceDamage tile for Whirlpools
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
			
			-- Set dmg to death
			spaceDamage.iDamage = DAMAGE_DEATH
			
			-- Add our script to the spaceDamage object (even lethal dmg will clear tile)
			local sscript = terraintile.DamageFunction .. "("..spaceDamage.loc:GetString()..")"
			if not spaceDamage.sScript then
				-- modloader adds metadata via sScript to some projectiles/grapples/etc; overwrite
				spaceDamage.sScript = sscript
			else
				spaceDamage.sScript = spaceDamage.sScript .. " " .. sscript
			end
		end
	end
	if #mission[terrainDmgTiles] > 0 then return true end
	return nil
end

local function IterateQueuedEffects(effect, pawnid)
	-- Check enemy skill spaceDamage tile for Whirlpools
	local mission = GetCurrentMission()
	if not mission then return nil end
	
	mission[terrainDmgTilesQ] = mission[terrainDmgTilesQ] or {}
	mission[terrainDmgTilesQ][pawnid] = {}
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if DamageCustomTile(spaceDamage.loc, spaceDamage.iDamage) then
			-- Set dmg to death
			spaceDamage.iDamage = DAMAGE_DEATH
			
			-- Add this tile to our animation list
			-- For some reason, trying to store Points (during FrameDrawn
			-- hooks?) messes them up; store as IDs instead
			mission[terrainDmgTilesQ][pawnid][#mission[terrainDmgTilesQ][pawnid] + 1] = p2idx(spaceDamage.loc)
			
			-- Add our script to the spaceDamage object (even lethal dmg will clear tile)
			local sscript = terraintile.DamageFunction .. "("..spaceDamage.loc:GetString()..")"
			if not spaceDamage.sScript then
				-- modloader adds metadata via sScript to some projectiles/grapples/etc; overwrite
				spaceDamage.sScript = sscript
			else
				spaceDamage.sScript = spaceDamage.sScript .. " " .. sscript
			end
		end
	end
end

local onSkillFinal = function(skillEffect, pawn)
	local queued = not skillEffect.q_effect:empty()
	local regularEffect = IterateEffects(skillEffect.effect, queued)
	if not regularEffect then
		-- Add queued script to clear Whirlpools that are being damaged by enemies
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

local function onBoardAddEffect(skillEffect)
	local queued = true -- Don't bother clearing anim flag
	IterateEffects(skillEffect.effect, queued)
end

local function onBoardDamageSpace(spaceDamage)
	if DamageCustomTile(spaceDamage.loc) and
	   spaceDamage.iDamage > 0 then
		spaceDamage.iDamage = DAMAGE_DEATH
		-- Add our script to the spaceDamage object (even lethal dmg will clear tile)
		local sscript = terraintile.DamageFunction .. "("..spaceDamage.loc:GetString()..")"
		if not spaceDamage.sScript then
			spaceDamage.sScript = sscript
		else
			spaceDamage.sScript = spaceDamage.sScript .. " " .. sscript
		end
	end
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

local onTileHighlighted = function(mission, point)	
	-- Override ground tile tooltip when highlighting Whirlpools
	-- Board:MarkSpaceDesc is used by environment effects and could conflict
		if Board:IsValid(point) and Board:GetTerrain(point) == TERRAIN_WATER and Board:GetCustomTile(point) == terrainTileImg then	   
		modApi.modLoaderDictionary["Tile_water_Title"] = terraintile.TileTooltip[1]
		modApi.modLoaderDictionary["Tile_water_Text"] = terraintile.TileTooltip[2]		
	else
		modApi.modLoaderDictionary["Tile_water_Title"] = nil
		modApi.modLoaderDictionary["Tile_water_Text"] = nil		
	end
end

local FrameDrawn = function(screen)
	-- Draw the Whirlpool animation each frame while aiming, remove when no longer aiming
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

local function overrideGetStatusTooltip()
	-- Set tooltip for our terrain status
	local oldGetStatusTooltip = GetStatusTooltip
	function GetStatusTooltip(id)
		if id == terraintile.StatusIcon then
			return {
				terraintile.StatusTooltip[1],
				terraintile.StatusTooltip[2]
			}
		end

		return oldGetStatusTooltip(id)
	end
end

tosx_WhirlpoolOff = function(point) -- Function name must match the terraintile.DamageFunction string
	-- After a skill/queued skill is used on Whirlpools, remove them!
	Board:AddAnimation(point,"tosx_dissipate_anim",ANIM_NO_DELAY)
	Board:AddAnimation(point,"Splash",ANIM_NO_DELAY)
	Board:SetCustomTile(point,"")
	Board:SetTerrainIcon(point,"")
end

local function onModsInitialized()
	local ticon = terraintile.StatusIcon
	modApi:appendAsset("img/combat/tiles_grass/tosx_whirlpool_0.png", mod.resourcePath.."img/terrain/tosx_whirlpool_0.png")	
	modApi:appendAsset("img/units/mission/tosx_whirlpool_a.png", mod.resourcePath.."img/terrain/tosx_whirlpool_a.png")	
	modApi:appendAsset("img/combat/icons/icon_"..ticon..".png", mod.resourcePath.."img/terrain/"..ticon..".png")
	modApi:appendAsset("img/combat/icons/icon_"..ticon.."_glow.png", mod.resourcePath.."img/terrain/"..ticon.."_glow.png")
	modApi:appendAsset("img/combat/icons/icon_"..ticon.."_anim.png", mod.resourcePath.."img/terrain/"..ticon.."_anim.png")
	modApi:appendAsset("img/effects/tosx_dissipate_anim.png", mod.resourcePath.."img/terrain/dissipate_anim.png")
	
	modApi:appendAsset("img/combat/icons/tosx_icon_kill_glow_KO.png", mod.resourcePath.."img/combat/icons/icon_kill_glow_KO.png")
		Location["combat/icons/tosx_icon_kill_glow_KO.png"] = Point(-16,9)

	-- Set our terrain tooltip
	TILE_TOOLTIPS[terrainTip] = terraintile.TileTooltip
	
	local a = ANIMS	
	a.tosx_whirlpooltile = Animation:new{
		Image = "units/mission/tosx_whirlpool_a.png",
		PosX = -15, PosY = 18,
		Time = 0.4,
		Loop = true,
		Layer = LAYER_FLOOR,
		NumFrames = 4
	}
	a.tosx_whirlpool1 = a.BaseUnit:new{Image = "units/mission/tosx_whirlpool_a.png", PosX = -15, PosY = 18}
	a.tosx_whirlpool1w = a.tosx_whirlpool1:new{Image = "units/mission/tosx_whirlpool_a.png", Time = 0.4, NumFrames = 4}
	a.tosx_whirlpool1a = a.tosx_whirlpool1:new{}--Image = "units/mission/tosx_whirlpool_a.png", NumFrames = 1, Time = 0.15}
	a.tosx_whirlpool1_ns = a.tosx_whirlpool1:new{}
	
	a.tosx_whirlpool_icona = Animation:new{
		Image = "combat/icons/icon_tosx_whirlpool_anim.png",
		PosX = -13, PosY = 22,
		Time = 0.15,
		Loop = true,
		Layer = LAYER_SKY,
		NumFrames = 6
	}
	a.tosx_dissipate_anim = Animation:new{
		Image = "effects/tosx_dissipate_anim.png",
		PosX = -15, PosY = 19,
		Time = 0.07,
		Loop = false,
		Layer = LAYER_FLOOR,
		NumFrames = 4
	}
	
	overrideGetStatusTooltip()
	
	tosx_whirlpooldummy = Pawn:new{
		Name = "Whirlpool",
		Health = 1,
		Neutral = true,
		Massive = true,
		SpaceColor = false,
		MoveSpeed = 0,
		Image = "tosx_whirlpool1",
		DefaultTeam = TEAM_PLAYER,
		IsPortrait = false,
	}

end

-- Override Board:IsDeadly to trigger death effects on whirlpools
-- Shouldn't interfere with other mods that also override this?
local function onBoardClassInitialized(BoardClass, board)	
	local IsDeadlyVanilla = board.IsDeadly
	BoardClass.IsDeadly = function(self, spaceDamage, pawn)
		Assert.Equals("userdata", type(self), "Argument #0")
		Assert.Equals("userdata", type(spaceDamage), "Argument #1")
		Assert.Equals("userdata", type(pawn), "Argument #2")
		
		if spaceDamage and spaceDamage.loc and Board:IsValid(spaceDamage.loc) and
		   Board:GetCustomTile(spaceDamage.loc) == terrainTileImg and
		   spaceDamage.iDamage and spaceDamage.iDamage > 0 then 
			local spaceDamageCopy = SpaceDamage(spaceDamage.loc, DAMAGE_DEATH, spaceDamage.iPush)
			-- No vanilla orange DAMAGE_DEATH icon for KO effects; add one to the original damage
			-- and hope it's not overwriting anything important
			if Board:IsPawnSpace(spaceDamage.loc) then
				spaceDamage.sImageMark = "combat/icons/tosx_icon_kill_glow_KO.png"
				return IsDeadlyVanilla(self, spaceDamageCopy, pawn)
			end
		end
		return IsDeadlyVanilla(self, spaceDamage, pawn)
	end
end
	
local function onModsLoaded()
	modApi:addPreMissionAvailableHook(PreMission)
	modApi:addMissionEndHook(MissionEnd)
	modApi:addMissionUpdateHook(MissionUpdate)
	sdlext.addFrameDrawnHook(FrameDrawn)
	
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
	modapiext:addTileHighlightedHook(onTileHighlighted)
end
	
modApi.events.onModsInitialized:subscribe(onModsInitialized)
modApi.events.onModsLoaded:subscribe(onModsLoaded)
modApi.events.onBoardClassInitialized:subscribe(onBoardClassInitialized)
modApi.events.onBoardAddEffect:subscribe(onBoardAddEffect)
modApi.events.onBoardDamageSpace:subscribe(onBoardDamageSpace)