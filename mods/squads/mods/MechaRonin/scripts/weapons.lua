local wt2 = {	
	Ronin_Prime_Katana_Upgrade1 = "Phasing",
	Ronin_Prime_Katana_Upgrade2 = "+1 Damage",
	
	Ronin_Ranged_Warp_Upgrade1 = "Ally Immune",
	Ronin_Ranged_Warp_Upgrade2 = "+2 Damage",
	
	Ronin_Brute_Pursuit_Upgrade1 = "+1 Mark Damage",
	Ronin_Brute_Pursuit_Upgrade2 = "+1 Mark Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local path = mod_loader.mods[modApi.currentMod].scriptPath
local worldConstants = require(path .."libs/worldConstants")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

-----------------------------
-- Blade Mech weapons
-----------------------------
Ronin_Prime_Katana = Skill:new{  
	Name = "Titan Katana",
	Description = "Charge through units, damaging them.",
	Class = "Prime",
	Icon = "weapons/ronin_katana.png",
	Rarity = 2,
	LaunchSound = "/weapons/shield_bash",
	BladeSound = "/weapons/sword",
	Damage = 2,
	Phasing = 0,
	Range = 7,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Phasing",  "+1 Damage"  },
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "Ronin_BladeMech",
	}
}
modApi:addWeaponDrop("Ronin_Prime_Katana")

function Ronin_Prime_Katana:GetTargetArea(p1)
	local ret = PointList()
	--ret = Board:GetReachable(p1, self.Range, PATH_FLYER)	
	for dir = DIR_START, DIR_END do
		local stillgood = true
		local max_i = 0
		for i = 1,self.Range do
			local point = p1 + DIR_VECTORS[dir]*i
			if stillgood and not Board:IsBlocked(point, Pawn:GetPathProf()) then
				--ret:push_back(point)
				max_i = i
			end
			if self.Phasing ~= 1 and (Board:IsBuilding(point) or Board:IsTerrain(point,TERRAIN_MOUNTAIN)) then -- UPDATE!
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

function Ronin_Prime_Katana:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local endcharge = p2
	local direction = GetDirection(p2 - p1)

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
	
	-- Charge really fast
	local superspeed = 4
	worldConstants.SetSpeed(ret, superspeed+1)
	ret:AddCharge(Board:GetPath(p1, endcharge, PATH_FLYER), NO_DELAY)
	worldConstants.ResetSpeed(ret)
	ret:AddDelay(0.06)
	
	-- Add the "blade" projectile
	if distance > 1 then
		worldConstants.SetSpeed(ret, superspeed)
		local dummydamage = SpaceDamage(endcharge, 0)
		dummydamage.bHide = true
		ret:AddProjectile(dummydamage, "effects/shot_katana",NO_DELAY)
		worldConstants.ResetSpeed(ret)
		
		-- Add another "blade" projectile if damage upgraded
		if self.Damage > 2 then
			ret:AddDelay(0.01)
			worldConstants.SetSpeed(ret, superspeed)
			ret:AddProjectile(dummydamage, "effects/shot_katana",NO_DELAY)
			worldConstants.ResetSpeed(ret)
		end
	end
	
	ret:AddSound(self.BladeSound)
	
	for i = 1,distance-1 do
		--ret:AddDelay(0.06)
		ret:AddDelay(0.02)
		local midpoint = p1 + DIR_VECTORS[direction]*i
		
		local dodamage = true
		if Board:IsBuilding(midpoint) then
			dodamage = false
		end
		
		if dodamage == true then
			local damage = SpaceDamage(midpoint,self.Damage)
			ret:AddDamage(damage)
		end
	end	
	
	local count = Board:GetEnemyCount()
	ret:AddScript(string.format([[
		local fx = SkillEffect();
		fx:AddScript("if %s - Board:GetEnemyCount() >= 3 then tosx_roninsquad_Chievo('tosx_ronin_katana') end")
		Board:AddEffect(fx);
	]], count))
	
	return ret
end

Ronin_Prime_Katana_A = Ronin_Prime_Katana:new{
	UpgradeDescription = "Phase through buildings and mountains when charging.",
	Phasing = 1,
	LaunchSound = "/weapons/enhanced_tractor",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "Ronin_BladeMech",
	},
}

Ronin_Prime_Katana_B = Ronin_Prime_Katana:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

Ronin_Prime_Katana_AB = Ronin_Prime_Katana:new{
	Phasing = 1,
	Damage = 3,
	LaunchSound = "/weapons/enhanced_tractor",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "Ronin_BladeMech",
	},
}



-----------------------------
-- Stealth Mech weapons
-----------------------------
Ronin_Ranged_Warp = Skill:new{  
	Name = "Warp Blades",
	Description = "Damage adjacent non-building tiles and warp away, pushing adjacent tiles on arrival.",
	Class = "Ranged",
	Icon = "weapons/ronin_warp.png",
	Rarity = 2,
	LaunchSound = "/weapons/science_repulse",
	Range = 4,
	Safe = 0,
	Damage = 1,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Ally Immune",  "+2 Damage"  },
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0)
	}
}
modApi:addWeaponDrop("Ronin_Ranged_Warp")

function Ronin_Ranged_Warp:GetTargetArea(p1)
	local ret = PointList()
	if self.Range == 15 then
		--ret = Board:GetReachable(p1, self.Range, PATH_FLYER)
		for dir = DIR_START, DIR_END do
			for i = 1, 7 do
				local curr = Point(p1 + DIR_VECTORS[dir] * i + DIR_VECTORS[(dir+1)%4] * i)
				if not Board:IsValid(curr) then
					break
				end
				if not Board:IsBlocked(curr, Pawn:GetPathProf()) then
					ret:push_back(curr)
				end
			end
		end
	end
	--else
		for dir = DIR_START, DIR_END do
			for i = 1, 7 do
				local curr = Point(p1 + DIR_VECTORS[dir] * i)
				if not Board:IsValid(curr) then
					break
				end
				if not Board:IsBlocked(curr, Pawn:GetPathProf()) then
					ret:push_back(curr)
				end
			end
		end
	--end
	return ret
end

function Ronin_Ranged_Warp:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local p3 = Point(-1,-1)
	if p1:Manhattan(p2) == 2 then
		p3 = p1 + DIR_VECTORS[direction]
	end
	
	ret:AddTeleport(p1,p2,0.5)
	
	-- Add the warp blade animations (no damage)
	for dir = DIR_START, DIR_END do
		point = p1 + DIR_VECTORS[dir]
		if Board:IsValid(point) then		
			local dummy2 = SpaceDamage(point,0)
			dummy2.bHide = true
			worldConstants.SetSpeed(ret, .4)
			ret:AddProjectile(dummy2, "effects/shot_warp",NO_DELAY)
			worldConstants.ResetSpeed(ret)
		end
	end
	
	-- Add the actual push effects
	for dir = DIR_START, DIR_END do
		point = p2 + DIR_VECTORS[dir]
		if point ~= p1 then
			local damage = SpaceDamage(point,0,dir)
			
			if point == p3 then
				damage.iPush = DIR_NONE
				damage.bHide = true
			end
			damage.sAnimation = "airpush_"..dir				
			ret:AddDamage(damage)			
		end
	end
	ret:AddDelay(0.2)
	
	-- Add the actual damage
	for dir = DIR_START, DIR_END do
		point = p1 + DIR_VECTORS[dir]
		if Board:IsValid(point) then
			if not Board:IsBuilding(point) and point ~= p2 then
				local damage = SpaceDamage(point,0)
				if (self.Safe == 0) or (Board:GetPawnTeam(point) ~= TEAM_PLAYER) then
					damage.iDamage = self.Damage
				end
				if point == p3 then
					damage.iPush = (dir+2)%4
				end
				ret:AddDamage(damage)
			end
		end
	end
	return ret
end

Ronin_Ranged_Warp_A = Ronin_Ranged_Warp:new{
	UpgradeDescription = "No longer damages allies.",
	Safe = 1,
}

Ronin_Ranged_Warp_B = Ronin_Ranged_Warp:new{
	UpgradeDescription = "Increases damage by 2.",
	Damage = 3,
}

Ronin_Ranged_Warp_AB = Ronin_Ranged_Warp:new{
	Safe = 1,
	Damage = 3,
}

-----------------------------
-- Hunter Mech weapons
-----------------------------
Ronin_Brute_Pursuit = Skill:new{  
	Name = "Pursuit Drone",
	Description = "Damage and push adjacent unit, marking it. All marked enemies are also damaged and pushed.",
	Class = "Brute",
	Icon = "weapons/ronin_pursuit.png",
	Rarity = 3,
	DiveSound = "/impact/generic/mech",
	Damage = 1,
	MarkDamage = 0,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "+1 Mark Damage",  "+1 Mark Damage"  },
	UpgradeCost = { 1,2 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,3),
		Target = Point(2,2),
		Second_Origin = Point(2,3),
		Second_Target = Point(3,3),
	}
}
modApi:addWeaponDrop("Ronin_Brute_Pursuit")

function Ronin_Brute_Pursuit:GetTargetArea(p1)
	local ret = PointList()	
	for dir = DIR_START, DIR_END do
		point = p1 + DIR_VECTORS[dir]
		if Board:IsValid(point) then
			ret:push_back(point)
		end
	end
	return ret
end

function Ronin_Brute_Pursuit:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local waitcooldown = 0.1
	local waitpush = 0.1
	local newmark = false
	local damageamount = 0
	local count = 0
	
	-- Mark the new target
	if GAME and not IsTipImage() then
		local colorid = Pawn:GetId() + 1
		_G["Ronin_DroneZ"].ImageOffset = Pawn:GetImageOffset()
		_G["Ronin_Drone" .. direction].ImageOffset = Pawn:GetImageOffset()
		_G["Ronin_Drone_B" .. direction].ImageOffset = Pawn:GetImageOffset()
	
	
		if Board:IsPawnSpace(p2) then
			local pawn = Board:GetPawn(p2)
			if pawn:GetTeam() == TEAM_ENEMY then
				if GAME.roninMark == nil then
					GAME.roninMark = {}
				end
				if pawn:GetId() ~= GAME.roninMark[pawn:GetId()] then				
					ret:AddScript([[
						local point = Point(]].. p2:GetString() ..[[)
						GAME.roninMark[Board:GetPawn(point):GetId()] = Board:GetPawn(point):GetId()
					]])
					newmark = true
					count = count + 1
				end
			end
		end
	end
	
	-- If a new target is being marked, do animation
	if newmark or IsTipImage() then
		local dummy2 = SpaceDamage(p2,0)
		dummy2.sAnimation = "HunterNewMark"
		ret:AddDamage(dummy2)
		ret:AddSound("/ui/battle/select_unit")
		ret:AddDelay(0.5)
	end
	
	-- Animate drone takeoff
	ret:AddScript([[
		local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_DroneZ")
		Board:AddPawn(dronelaunchanim,]]..p1:GetString()..[[)
	]])
	
	ret:AddSound("/weapons/wind")
	ret:AddDelay(0.8)
	
	-- Set up damage variables
	local dummy3 = SpaceDamage(p2, self.Damage, direction)
	dummy3.sAnimation = "explopush1_" .. direction
	
	if not IsTipImage() then
		-- Check every tile on the board
		for i = 0, 7 do
			for j = 0, 7  do
				local point = Point(i,j) -- DIR_LEFT
				if direction == DIR_RIGHT then
					point = Point(7 - i, j)
				elseif direction == DIR_UP then
					point = Point(j,i)
				elseif direction == DIR_DOWN then
					point = Point(j,7-i)
				end
				
				dummy3.sImageMark = ""
				if Board:IsPawnSpace(point) then
					local pawn = Board:GetPawn(point)					
					local pid = pawn:GetId()
					
					dummy3.iDamage = 0					
					if point == p2 then
						dummy3.iDamage = self.Damage
					end
					if pawn:GetTeam() == TEAM_ENEMY then
						if GAME.roninMark ~= nil then
							if pawn:GetId() == GAME.roninMark[pawn:GetId()] then
								dummy3.iDamage = dummy3.iDamage + self.Damage + self.MarkDamage
								dummy3.sImageMark = "combat/icons/hunter_mark_circle1.png"
								count = count + 1
							end
						end
					end
					
					if dummy3.iDamage > 0 then
						if point == p2 then
							ret:AddScript([[
								local pawn = Board:GetPawn(]]..pid..[[)
								local point = pawn:GetSpace()
								pawn:SetSpace(Point(-1,-1))
								
								local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_Drone_B]]..direction..[[")
								Board:AddPawn(dronelaunchanim,]]..p1:GetString()..[[)
								
								pawn:SetSpace(point)
							]])
						else
							ret:AddScript([[
								local pawn = Board:GetPawn(]]..pid..[[)
								local point = pawn:GetSpace()
								pawn:SetSpace(Point(-1,-1))
								
								local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_Drone]]..direction..[[")
								Board:AddPawn(dronelaunchanim,]]..point:GetString()..[[)
								
								pawn:SetSpace(point)
							]])
						end
						
						dummy3.loc = point
						if dummy3.iDamage > 1 then
							dummy3.sAnimation = "explopush2_" .. direction
						else
							dummy3.sAnimation = "explopush1_" .. direction
						end
						ret:AddDelay(waitpush)
						ret:AddDamage(dummy3)
						ret:AddSound(self.DiveSound)
						
						ret:AddDelay(waitcooldown)
					end
				elseif point == p2 then
					dummy3.iDamage = self.Damage
					ret:AddScript([[								
						local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_Drone_B]]..direction..[[")
						Board:AddPawn(dronelaunchanim,]]..p1:GetString()..[[)
					]])
						
					dummy3.loc = point
					if dummy3.iDamage > 1 then
						dummy3.sAnimation = "explopush2_" .. direction
					else
						dummy3.sAnimation = "explopush1_" .. direction
					end
					ret:AddDelay(waitpush)
					ret:AddDamage(dummy3)
					ret:AddSound(self.DiveSound)
						
					ret:AddDelay(waitcooldown)
				end
			end
		end
		
		if count > 2 then
			ret:AddScript("tosx_roninsquad_Chievo('tosx_ronin_pursuit')")
		end
	
	else--
		-- Ugly, but let's just manually set up what the tip image will do
		-- This is the first target
		ret:AddScript([[
			local pawn = Board:GetPawn(]]..p1:GetString()..[[)
			pawn:SetSpace(Point(-1,-1))
			
			local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_Drone]]..direction..[[")
			Board:AddPawn(dronelaunchanim,]]..p1:GetString()..[[)
			
			pawn:SetSpace(]]..p1:GetString()..[[)
		]])
		
		ret:AddDelay(waitpush)
		ret:AddDamage(dummy3)
		
		if p2 ~= Point(2,2) then
			-- This is the second target, after first has been 'marked'
			
			ret:AddDelay(waitcooldown)
			dummy3.iDamage = self.Damage + self.MarkDamage
			dummy3.sImageMark = "combat/icons/hunter_mark_circle1.png"
			ret:AddScript([[
				local pawn = Board:GetPawn(Point(2,1))
				pawn:SetSpace(Point(-1,-1))
			
				local dronelaunchanim = PAWN_FACTORY:CreatePawn("Ronin_Drone]]..direction..[[")
				Board:AddPawn(dronelaunchanim,Point(2,1))
				
				pawn:SetSpace(Point(2,1))
			]])
			
			dummy3.loc = Point(2,1)
			if dummy3.iDamage > 1 then
				dummy3.sAnimation = "explopush2_" .. direction
			else
				dummy3.sAnimation = "explopush1_" .. direction
			end
			ret:AddDelay(waitpush)
			ret:AddDamage(dummy3)			
		end
	end
	return ret
end

Ronin_Brute_Pursuit_A = Ronin_Brute_Pursuit:new{
	UpgradeDescription = "Increases damage to marked targets by 1.",
	MarkDamage = 1,
}

Ronin_Brute_Pursuit_B = Ronin_Brute_Pursuit:new{
	UpgradeDescription = "Increases damage to marked targets by 1.",
	MarkDamage = 1,
}

Ronin_Brute_Pursuit_AB = Ronin_Brute_Pursuit:new{
	MarkDamage = 2,
}

local function ResetMarkVars()
	--LOG("Reset mark")
	GAME.roninMark = {}
end

return {
	ResetMarkVars = ResetMarkVars,
}