local wt2 = {	
	tosx_Prime_DowsingCharge_Upgrade1 = "Ignore Obstacle",
	tosx_Prime_DowsingCharge_Upgrade2 = "+2 Damage",
	
	tosx_Ranged_HydroCannon_Upgrade1 = "Overflow",
	tosx_Ranged_HydroCannon_Upgrade2 = "+1 Damage",
	
	tosx_Science_CargoBay_Upgrade1 = "+1 Range",
	tosx_Science_CargoBay_Upgrade2 = "Push",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local function IsVolcano(point)
	-- Let's not allow the 1x4 volcano to be turned to water
	if Board:GetCustomTile(Point(1,1)) == "supervolcano.png" then
		if point == Point(0,0) or
		point == Point(0,1) or
		point == Point(1,0) or
		point == Point(1,1) then
			return true
		end
	end
	return false
end

local oldInitializeBoardPawn = InitializeBoardPawn
function InitializeBoardPawn()
	oldInitializeBoardPawn()

	-- doesn't matter what pawn we create here, we just need a Pawn userdata instance
	local pawn = PAWN_FACTORY:CreatePawn("PunchMech")

	local oldSetPowered = pawn.SetPowered
	BoardPawn.SetPowered = function(self, flag)
		Tests.AssertEquals("userdata", type(self), "Argument #0")
		
		-- do stuff without setting powered
		if flag and GAME and GAME.tosx_HydroStorage then
			for i = 0, 2 do
				if GAME.tosx_HydroStorage[i] and
				GAME.tosx_HydroStorage[i].id and
				not IsTestMechScenario() then -- Bypass test scenario!
					if self:GetId() == GAME.tosx_HydroStorage[i].id and self:GetSpace() == Point(-1,-1) then
						-- The pawn that's getting powered on is in storage, so just make sure the powered flag is set instead of actually powering it
						GAME.tosx_HydroStorage[i].powered = true
						return
					end
				end
			end
		end
		return oldSetPowered(self, flag)
	end
end

-- Have to manually address the AE bot hacking mission
-- Don't unhack the bot until it's back on the board
local oldupdatemission = Mission_Hacking.UpdateMission
function Mission_Hacking:UpdateMission()
	if (Board:GetPawn(self.BotID) and Board:IsValid(Board:GetPawn(self.BotID):GetSpace())) then
		-- Safe to unhack
		oldupdatemission(self)
	else
		-- Not safe; delay unhack
        local BotID = self.BotID
        self.BotID = nil
        
        oldupdatemission(self)
        
        self.BotID = BotID
	end
end

tosx_Prime_DowsingCharge = Skill:new{  
	Name = "Dowsing Charge",
	Description = "Unleashes a geyser that pushes 3 tiles. Damages a target on Water, or creates Water if target is an empty tile.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_dowsingcharge.png",
	Rarity = 2,
	LaunchSound = "/props/tide_flood",
	Damage = 3,
	PowerCost = 1,
	Surge = 0,
	Flood = 0,
	Upgrades = 2,
	--UpgradeList = { "Ignore Obstacle", "+2 Damage"},
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Prime_DowsingCharge")

function tosx_Prime_DowsingCharge:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 1, 7 do
			local point = p1 + DIR_VECTORS[dir]*i
			if Board:IsValid(point) then
				ret:push_back(point)
				if self.Surge == 0 or Board:GetTerrain(point) ~= TERRAIN_WATER then
					break
				end
			else
				break
			end
		end
	end	
	return ret
end

function tosx_Prime_DowsingCharge:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2) - 1
	local actualdamage = 0
	local makewater = 0
	
	if Board:GetTerrain(p2) == TERRAIN_WATER then
		actualdamage = self.Damage
	else
		if self.MinDamage > 0 then
			actualdamage = self.MinDamage
		else
			actualdamage = 0
		end
		if not Board:IsSpawning(p2) then
			if not IsVolcano(p2) and ((self.Flood == 1 and not Board:IsBuilding(p2)) or not Board:IsBlocked(p2, PATH_PROJECTILE))then
				makewater = 1
				-- Add some invisible damage to clear mines
				if Board:IsDangerousItem(p2) then
					local damage = SpaceDamage(p2, 1)
					if not Board:IsSmoke(p2) then
						-- Invisible damage will trigger sand, leaving smoke over our new water
						damage.iSmoke = EFFECT_REMOVE
					end
					damage.bHide = true
					ret:AddDamage(damage)
				end
			end
		end
	end
	
	--Melee lunge
	ret:AddMelee(p1, SpaceDamage(p1 + DIR_VECTORS[direction], 0), NO_DELAY)
	ret:AddBounce(p1,2)
	
	--Damage intermediate water tiles
	if distance > 0 then
		for i = 1, distance do
			local point = p1 + DIR_VECTORS[direction]*i
			--local damage = SpaceDamage(point, self.Damage)
			local damage = SpaceDamage(point, 0)
			damage.sSound = self.LaunchSound
			damage.sAnimation = "Splash"
			ret:AddDamage(damage)
			ret:AddDelay(0.15)
		end
	end
	
	-- Pushing and damage first
	local damage = SpaceDamage(p2, actualdamage, direction)
	if makewater == 1 then
		damage.sImageMark = "combat/icons/tosx_create_water_icon_glow.png"
		if actualdamage > 0 then
			damage.sImageMark = "combat/icons/tosx_create_water_icon_glowU.png"
		end
	end
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], 0, (direction+1)%4)
	damage.sAnimation = "airpush_"..((direction+1)%4)
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p2 + DIR_VECTORS[(direction - 1)% 4],0, (direction-1)%4)
	damage.sAnimation = "airpush_"..((direction-1)%4)
	ret:AddDamage(damage)
	
	-- Water
	local waterdamage = SpaceDamage(p2, 0)	
	waterdamage.sAnimation = "Splash"
	if makewater == 1 then
		waterdamage.iTerrain = TERRAIN_WATER
		
		if not IsTipImage() then
			ret:AddScript([[
				local mission = GetCurrentMission()
				if mission then
					if not mission.tosx_hydro_tide then mission.tosx_hydro_tide = 0 end
					mission.tosx_hydro_tide = mission.tosx_hydro_tide + 1
				end
			]])
		end
		
	end
	waterdamage.bHide = true	
	ret:AddDamage(waterdamage)
	
	--[[	
	if distance > 2 then
		ret:AddScript("tosx_hydrosquad_Chievo('tosx_hydro_torpedo')")
	end
	--]]
	
	local count = Board:GetEnemyCount()
	ret:AddScript(string.format([[
		local fx = SkillEffect();
		fx:AddScript("if %s - Board:GetEnemyCount() >= 3 then tosx_hydrosquad_Chievo('tosx_hydro_torpedo') end")
		Board:AddEffect(fx);
	]], count))
	
	return ret
end

tosx_Prime_DowsingCharge_A = tosx_Prime_DowsingCharge:new{
	UpgradeDescription = "Always creates Water on target unless it is a Grid Building or spawning Vek.",
	Flood = 1,
}

tosx_Prime_DowsingCharge_B = tosx_Prime_DowsingCharge:new{
	UpgradeDescription = "Increases damage to Water and non-Water tiles by 2.",
	Damage = 5,
	MinDamage = 2,
}

tosx_Prime_DowsingCharge_AB = tosx_Prime_DowsingCharge:new{
	Damage = 5,
	MinDamage = 2,
	Flood = 1,
}

tosx_Ranged_HydroCannon = Skill:new{  
	Name = "Hydro Cannon",
	Description = "Fires a shot that damages and pulls. Drains Water behind the shooter for extra damage.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_hydrocannon.png",
	Rarity = 2,
	LaunchSound = "/support/disposal/attack",
	ImpactSound = "/support/disposal/attack_impact",
	MinDamage = 1,
	Damage = 3,
	PowerCost = 0,
	ArtillerySize = 8,
	OnlyEmpty = false,
	Puddle = 0,
	Elemental = 1,
	Upgrades = 2,
	--UpgradeList = { "Overflow",  "+1 Damage"  },
	UpgradeCost = { 2,2 },
	TipImage = {
		Water = Point(2,4),
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,0),
	}
}
modApi:addWeaponDrop("tosx_Ranged_HydroCannon")

function tosx_Ranged_HydroCannon:GetTargetArea(p1)			
	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local point = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(point) then
				break
			end
			
			if not self.OnlyEmpty or not Board:IsBlocked(point,PATH_GROUND) then
				ret:push_back(point)
			end

		end
	end	
	return ret
end

function tosx_Ranged_HydroCannon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local p3 = p1 - DIR_VECTORS[direction]
	local bounceamount = 1
	local element = ""
	
	-- Increase bounce and projectile size by 1 step if damage upgraded
	if self.MinDamage > 1 then
		bounceamount = bounceamount + 1
	end
	
	-- With upgrade, create water behind
	if not IsVolcano(p3) and self.Puddle == 1 and not (Board:IsBlocked(p3, PATH_PROJECTILE) or Board:GetTerrain(p3) == TERRAIN_WATER or Board:IsSpawning(p3)) then
		
		-- Add some invisible damage to clear mines
		if Board:IsDangerousItem(p3) then
			local damage = SpaceDamage(p3, 1)
			if not Board:IsSmoke(p3) then
				-- Invisible damage will trigger sand, leaving smoke over our new water
				damage.iSmoke = EFFECT_REMOVE
			end
			damage.bHide = true
			ret:AddDamage(damage)
		end
		
		local waterdamage = SpaceDamage(p3,0)
		waterdamage.iTerrain = TERRAIN_WATER
		waterdamage.sAnimation = "Splash"
		waterdamage.sImageMark = "combat/icons/tosx_create_water_icon_glow.png"
		ret:AddDamage(waterdamage)
		
		if not IsTipImage() then
			ret:AddScript([[
				local mission = GetCurrentMission()
				if mission then
					if not mission.tosx_hydro_tide then mission.tosx_hydro_tide = 0 end
					mission.tosx_hydro_tide = mission.tosx_hydro_tide + 1
				end
			]])
		end
	end
	
	local damage = SpaceDamage(p2,self.MinDamage, GetDirection(p1 - p2))
	damage.sAnimation = "Splash"
	
	-- Drain water for bonuses
	if Board:GetTerrain(p3) == TERRAIN_WATER then
		damage.iDamage = self.Damage
		
		if self.Elemental == 1 and Board:IsTerrain(p3,TERRAIN_LAVA) then
			damage.iFire = EFFECT_CREATE
			element = "_lava"			
			
			ret:AddScript("tosx_triggerThirsty('fire')")
			
		elseif self.Elemental == 1 and Board:IsAcid(p3) then
			damage.iAcid = EFFECT_CREATE
			element = "_acid"
			
			ret:AddScript("tosx_triggerThirsty('acid')")
			
		end
		damage.sAnimation = "Splash"..element
		
		bounceamount = bounceamount+1
		
		local waterdamage = SpaceDamage(p3,0)
		if Board:IsPawnSpace(p3) then
			if Board:GetPawn(p3):GetType() == "Dam_Pawn" then
				-- This is a dam; pretend to drain it, but don't really; infinite water!
			else
				waterdamage.iTerrain = TERRAIN_ROAD
			end
		else
			waterdamage.iTerrain = TERRAIN_ROAD
		end
		
		waterdamage.sAnimation = "tosx_drain_anim"..element
		waterdamage.sImageMark = "combat/icons/tosx_create_water_icon_glowX.png"
		ret:AddDamage(waterdamage)
		ret:AddBounce(p3, 3)
	end
	
	ret:AddBounce(p1, bounceamount)
	ret:AddArtillery(damage, "effects/tosx_shotup_splasher"..tostring(bounceamount)..element..".png")
	ret:AddBounce(p2, 3)
	
	return ret
end

tosx_Ranged_HydroCannon_A = tosx_Ranged_HydroCannon:new{
	UpgradeDescription = "Creates Water behind the shooter if the tile is empty and not spawning Vek.",
	Puddle = 1,
}

tosx_Ranged_HydroCannon_B = tosx_Ranged_HydroCannon:new{
	UpgradeDescription = "Increases damage by 1.",
	MinDamage = 2,
	Damage = 4,
}

tosx_Ranged_HydroCannon_AB = tosx_Ranged_HydroCannon:new{
	Puddle = 1,
	MinDamage = 2,
	Damage = 4,
}


tosx_Science_CargoBay = Skill:new{  
	Name = "Cargo Bay",
	Description = "Leap onto a nearby enemy, storing them inside you. Enemies already in storage are deposited at launch.",
	Class = "Science",
	Icon = "weapons/tosx_weapon_cargo.png",
	Rarity = 2,
	Range = 1,
	LaunchSound = "/weapons/leap",
	PowerCost = 0,
	Upgrades = 2,
	Push = 0,
	Extinguish = false,
	--UpgradeList = { "+1 Range",  "Push"  },
	UpgradeCost = { 1,2 },
	TipImage = {
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,2),
		Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Science_CargoBay")
-- Future update: use Cutils to SetFreeze (will need to account for shields?), which bypasses animation/sound
-- Would remove need to manually deal with fire, protect against tyrant+passive, and remove need to unpower?
-- Note: AE softlocks if pawns at -1,-1 die during fire/tyrant turn step

function tosx_Science_CargoBay:GetTargetArea(p1)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.Range do
			local point = DIR_VECTORS[i]*k + p1
			if Board:IsValid(point) and (Board:IsPawnSpace(point) or not Board:IsBlocked(point, PATH_PROJECTILE)) then
				if not Board:IsPawnSpace(point) then
					ret:push_back(point)
				elseif Board:GetPawnTeam(point) ~= TEAM_PLAYER and not Board:GetPawn(point):IsGuarding() then
					ret:push_back(point)
				end
			end
		end
	end
	return ret
end

function tosx_Science_CargoBay:GetSkillEffect(p1, p2)
	local myid = Pawn:GetId()
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)
	local shelf = Point(-1,-1)
	local gift = false
	local oldgift = false
	
	if Board:IsPawnSpace(p2) then
		gift = Board:GetPawn(p2)
	end
	
	ret:AddBounce(p1,1)
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)
	ret:AddLeap(move, NO_DELAY)
		
	if not IsTipImage() then
	
		if GAME then
			GAME.tosx_HydroStorage = GAME.tosx_HydroStorage or {}
			GAME.tosx_HydroStorage[myid] = GAME.tosx_HydroStorage[myid] or {}
		else return end
	
		if GAME.tosx_HydroStorage[myid].id then
			--Make sure nothing died in storage
			local pawn = Board:GetPawn(GAME.tosx_HydroStorage[myid].id)
			if pawn then
				--There's a value in storage, but no living pawn
				if pawn:IsDead() and not (_G[Board:GetPawn(GAME.tosx_HydroStorage[myid].id):GetType()].Corpse or Board:GetPawn(GAME.tosx_HydroStorage[myid].id):IsMech()) then
					-- Pawn is dead! This type doesn't leave a corpse AND is not a mech; clear the value to be safe. Storage will be empty
					ret:AddScript(string.format("GAME.tosx_HydroStorage[%s] = {}", myid))
				else
					oldgift = tostring(GAME.tosx_HydroStorage[myid].id)
				end
			end
		end
			
		if oldgift then	
			-- Create and then script-remove a matching pawn so the previewer will show what's in storage
			local damage = SpaceDamage(p1, 0)
			damage.sPawn = Board:GetPawn(GAME.tosx_HydroStorage[myid].id):GetType()
			ret:AddDamage(damage)
			ret:AddScript([[
				local pawn = Board:GetPawn(Point(]]..p1:GetString()..[[))
				Board:RemovePawn(pawn)
			]])	
			ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(%s))", oldgift, p1:GetString()))
			if GAME.tosx_HydroStorage[myid].powered then
				-- Old gift had power when swallowed; repower it
				ret:AddScript(string.format("Board:GetPawn(%s):SetPowered(true)", oldgift))
				if GAME.tosx_HydroStorage[myid].ally == 2 then
					ret:AddScript(string.format("Board:GetPawn(%s):SetActive(true)", oldgift))
				end
			end
			ret:AddScript(string.format("GAME.tosx_HydroStorage[%s] = {}", myid))
		end
		
		ret:AddDelay(distance*0.01 + 0.78) --Was 0.78
		ret:AddBurst(p2,"Emitter_Burst_$tile",DIR_NONE)
				
		if gift then
			local tilefire = false
			local dF = SpaceDamage(p2)
			dF.bHide = true
			if gift:IsFire() and self.Extinguish then
				if Board:IsFire(p2) then
					tilefire = true
				end
				dF.iFire = EFFECT_REMOVE
				ret:AddDamage(dF)
			end
			ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(%s))", gift:GetId(), shelf:GetString()))
			if tilefire and self.Extinguish then
				dF.iFire = EFFECT_CREATE
				ret:AddDamage(dF)
			end
			ret:AddScript(string.format("Board:GetPawn(%s):ClearQueued()", gift:GetId()))
			ret:AddScript(string.format("Board:GetPawn(%s):SetPowered(false)", gift:GetId()))
			
			ret:AddScript(string.format("GAME.tosx_HydroStorage[%s].powered = true", myid))
			ret:AddScript(string.format("GAME.tosx_HydroStorage[%s].id = Board:GetPawn(%s):GetId()", myid, gift:GetId()))
			
			local damage = SpaceDamage(p2, 0)
			damage.sImageMark = "combat/icons/tosx_cargo_icon_glow.png"
			ret:AddDamage(damage)
		end
		
		ret:AddBounce(p2,3)
		ret:AddSound("/impact/generic/mech")
		
	else -- Is Tip image; simple stuff, known target:
	
		ret:AddDelay(distance*0.01 + 0.78) --Was 0.78
		ret:AddBurst(p2,"Emitter_Burst_$tile",DIR_NONE)
		
		ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(%s))", gift:GetId(), shelf:GetString()))
		
		local damage = SpaceDamage(p2, 0)
		damage.sImageMark = "combat/icons/tosx_cargo_icon_glow.png"
		ret:AddDamage(damage)
		
		ret:AddBounce(p2,3)
		ret:AddSound("/impact/generic/mech")	
		
	end
	
	if self.Push == 1 then
		for i = 1,3,2 do
			local dirP = (direction + i)% 4
			local damageP = SpaceDamage(p2 + DIR_VECTORS[dirP], 0, dirP)
			damageP.sAnimation = "airpush_"..dirP
			ret:AddDamage(damageP)
		end
	end
	
	return ret
end

tosx_Science_CargoBay_A = tosx_Science_CargoBay:new{
	UpgradeDescription = "Extends range of the leap by 1 tile.",
	Range = 2,
	TipImage = {
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

tosx_Science_CargoBay_B = tosx_Science_CargoBay:new{
	UpgradeDescription = "Push tiles on either side after leaping.",
	Push = 1,
	TipImage = {
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,2),
		Enemy2 = Point(1,2),
		Target = Point(2,2),
	}
}

tosx_Science_CargoBay_AB = tosx_Science_CargoBay:new{
	Range = 2,
	Push = 1,
	TipImage = {
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,1),
		Enemy2 = Point(1,1),
		Target = Point(2,1),
	}
}



local function ResetStorageVars()
	GAME.tosx_HydroStorage = nil
end

return {
	ResetStorageVars = ResetStorageVars,
}