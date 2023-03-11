local wt2 = {	
	tosx_Prime_MagnetFist_Upgrade1 = "Slam", 
	tosx_Prime_MagnetFist_Upgrade2 = "+2 Damage",
	
	tosx_Brute_MagnetSling_Upgrade1 = "Buildings Immune",
	tosx_Brute_MagnetSling_Upgrade2 = "+1 Damage",
	
	tosx_Ranged_FluxArtillery_Upgrade1 = "+2 Mag Damage",
	tosx_Ranged_FluxArtillery_Upgrade2 = "+2 Mag Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local path = mod_loader.mods[modApi.currentMod].scriptPath
local previewer = require(path .."libs/weaponPreview")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local function IsGuarding2(point)
	-- Check if a point has a pawn and that pawn is guarding; false otherwise
	if Board:IsPawnSpace(point) then return Board:GetPawn(point):IsGuarding() end
	return false
end

local function IsMagnetic(point)
	if not Board:IsPawnSpace(point) then return false end
	if magscorps and Board:GetPawn(point):GetType() == "Scorpion1" then return true end

	if not IsTipImage() then
		if GAME then
			GAME.tosx_PosPolarities = GAME.tosx_PosPolarities or {}
			if GAME.tosx_PosPolarities[Board:GetPawn(point):GetId()] then return true end
		end
	end
	
	return false
end

local function ShowPolarities()
	local allpawns = extract_table(Board:GetPawns(TEAM_ANY))
	for i,id in pairs(allpawns) do
		local point = Board:GetPawnSpace(id)
		if IsMagnetic(point) then
			previewer:AddAnimation(point, "tosx_magnetic_icon")
		end
	end
end

-- Functions to display a hacky animated sImageMark (equivalent to weaponPreview) in a TipImage
local tippolarity = false

function tosx_resetTipPolarity()
	tippolarity = false
end

local function ShowPolaritiesTip(point)
	if tippolarity then return false end
	local effect = SkillEffect()
	local damage = SpaceDamage(point,0)
	damage.bHide = true
	damage.sAnimation = "tosx_magnetic_iconTip"
	effect:AddDelay(.6)
	effect:AddDamage(damage)
	Board:AddEffect(effect)
	tippolarity = true
end







tosx_Prime_MagnetFist = Skill:new{  
	Name = "Magnetite Fist",
	Description = "Magnetize and pull a target, then damage the tile adjacent to Mech.\n\nCan pull distant Magnetized units.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_mag1.png",
	Rarity = 2,
	LaunchSound = "/weapons/enhanced_tractor",
	Damage = 2,
	Summon = 1,
	Slam = 0,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Slam",  "+2 Damage"  },
	UpgradeCost = { 2,3 },
	TestDummy = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Friendly = Point(2,0),
	}
}
modApi:addWeaponDrop("tosx_Prime_MagnetFist")

function tosx_Prime_MagnetFist:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 1, 7 do
			local point = p1 + DIR_VECTORS[dir]*i
			if Board:IsValid(point) then
				if i < 3 or (self.Summon == 1 and IsMagnetic(point) and not IsGuarding2(point)) then
					ret:push_back(point)
				end
			end
		end
	end
	
	ShowPolarities()
	
	return ret
end

function tosx_Prime_MagnetFist:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local backwards = GetDirection(p1 - p2)
	local distance = p1:Manhattan(p2) --distance >2 means a summon
	local magthis = false
	local p_far = p1 + DIR_VECTORS[direction]*2
	local p_close = p1 + DIR_VECTORS[direction]*1
	
	if distance < 3 then		
		local moveable = false
		if not IsGuarding2(p_far) then moveable = true end

		if not Board:IsBlocked(p_close, PATH_PROJECTILE) and moveable then
			-- Unit is going to charge
			local damage = SpaceDamage(p_far, 0)
			damage.sAnimation = "tosx_magpush_"..backwards
			damage.bHide = true
			damage.sSound = "/impact/generic/tractor_beam"
			ret:AddDamage(damage)
			ret:AddCharge(Board:GetPath(p_far, p_close, PATH_FLYER), NO_DELAY)
			if Board:IsPawnSpace(p_far) and not IsMagnetic(p_far) then magthis = Board:GetPawn(p_far):GetId() end
		else
			-- Unit can't charge, going to pull distant tile instead
			local damage = SpaceDamage(p_far, 0, backwards)
			damage.sAnimation = "tosx_magpush_"..backwards
			damage.sSound = "/impact/generic/tractor_beam"
			ret:AddDamage(damage)
			if Board:IsPawnSpace(p_close) and not IsMagnetic(p_close) then magthis = Board:GetPawn(p_close):GetId() end
		end		
	else
		-- We're yanking a distant unit		
		local damage0 = SpaceDamage(p1, 0)
		damage0.sAnimation = "tosx_magflare"
		damage0.sSound = "/impact/generic/tractor_beam"
		damage0.bHide = true
		ret:AddDamage(damage0)
	
		-- Find spot as close to p1 as possible; default to p2
		local dest = p2
		for i = 1, distance do
			local midpoint = p1 + DIR_VECTORS[direction]*i
			if not Board:IsBlocked(midpoint, PATH_PROJECTILE) then
				dest = midpoint
				break
			end
		end
		
		local damage = SpaceDamage(p2, 0)
		if dest == p2 then damage.iPush = backwards end -- If our magnetic target can't go anywhere, still pull
		damage.sAnimation = "tosx_magpush_"..backwards
		ret:AddDamage(damage)
		ret:AddCharge(Board:GetPath(p2, dest, PATH_FLYER), NO_DELAY)
		
		local traveldistance = dest:Manhattan(p2)
		local obstacles = 0
		if traveldistance > 1 then
			for i = 1, traveldistance - 1 do				
				local midpoint = p2 + DIR_VECTORS[backwards]*i
				
				-- Add animations
				local damage2a = SpaceDamage(midpoint + DIR_VECTORS[backwards], 0)
				damage2a.bHide = true
				damage2a.sAnimation = "tosx_magpush_"..backwards
				ret:AddDamage(damage2a)
				
				-- Damage intermediate points
				if self.Slam == 1 then
					local damage2 = SpaceDamage(midpoint, self.Damage)
					damage2.sAnimation = "tosx_magpush_"..backwards
					ret:AddDelay(0.06)
					ret:AddDamage(damage2)
				end
				
				if Board:IsBlocked(midpoint, PATH_PROJECTILE) then
					obstacles = obstacles + 1
				end
			end
		end
		
		-- There may still be something else on the punch tile that's not magnetic yet
		if Board:IsPawnSpace(p_close) and not IsMagnetic(p_close) then magthis = Board:GetPawn(p_close):GetId() end

		if obstacles > 3 then
			ret:AddScript("tosx_magnetsquad_Chievo('tosx_magnet_yank')")
		end
	end
	
	-- Add the punch
	ret:AddDelay(0.3)
	local damage2 = SpaceDamage(p_close, self.Damage)
	damage2.sAnimation = "explopunch1_"..direction
	if magthis then damage2.sImageMark = "combat/icons/tosx_polarity2d_icon_glow.png" end
	damage2.sSound = "/weapons/titan_fist"
	ret:AddMelee(p1, damage2, NO_DELAY)		
	
	-- Add to mag list and add animation if we're Magnetizing
	if magthis then
		if not IsTipImage() then
			local turn = IsTestMechScenario() and 1 or Game:GetTurnCount()
			ret:AddScript("GAME.tosx_PosPolarities["..magthis.."] = "..turn) -- Add to magnetic list
		end
		
		-- Add magnetic animation
		local damage3 = SpaceDamage(p_close,0)
		damage3.sAnimation = "tosx_magflare"
		damage3.bHide = true
		ret:AddDelay(0.2)
		ret:AddDamage(damage3)
	end
	
	return ret
end

tosx_Prime_MagnetFist_A = tosx_Prime_MagnetFist:new{
	UpgradeDescription = "Distant Magnetized units damage anything they pass through.",
	Slam = 1,
}

tosx_Prime_MagnetFist_B = tosx_Prime_MagnetFist:new{
	UpgradeDescription = "Increases damage by 2.",
	Damage = 4,
}

tosx_Prime_MagnetFist_AB = tosx_Prime_MagnetFist:new{
	Slam = 1,
	Damage = 4,
}


tosx_Brute_MagnetSling = Skill:new{  
	Name = "Magnetic Sling",
	Description = "Magnetize a unit, then fling all Magnetized units to damage and push.",
	Class = "Brute",
	Icon = "weapons/tosx_weapon_mag2.png",
	Rarity = 2,
	Damage = 1,
	Impact = 1,
	Friendly = 0,
	StableDamage = 0,
	LaunchSound = "/weapons/area_shield",
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Buildings Immune",  "+1 Damage"  },
	UpgradeCost = { 1,3 },
	TestDummy = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,0),
		Building = Point(0,1),
		Target = Point(2,2),
		Second_Origin = Point(2,3),
		Second_Target = Point(1,3),
	}
}
modApi:addWeaponDrop("tosx_Brute_MagnetSling")

function tosx_Brute_MagnetSling:GetTargetArea(p1)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[dir]
		if Board:IsValid(point) then
			ret:push_back(point)
		end
	end
	
	ShowPolarities()
	-- Extra work for displaying in TipImage, since weaponPreview doesn't work there
	if IsTipImage() and not Board:IsPawnSpace(Point(2,2)) then
		ShowPolaritiesTip(Point(2,1))
	end
	
	return ret
end

function tosx_Brute_MagnetSling:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local vacatedpoints = PointList()
	local blockedpoints = PointList()	
	local delay_array = {}
	local landing_array = {}
	local pushedpoints = PointList()	
	local targetcount = 0
	local downhole = true
	local magthis = false
	ret:AddScript("tosx_resetTipPolarity()") -- Clears the TipImage animation flag
	
	if Board:IsPawnSpace(p2) and not IsMagnetic(p2) then
		magthis = Board:GetPawn(p2):GetId()
		if not IsTipImage() then
			local turn = IsTestMechScenario() and 1 or Game:GetTurnCount()
			ret:AddScript("GAME.tosx_PosPolarities["..magthis.."] = "..turn) -- Add to magnetic list
		end		
	end
	
	-- Add magnetic animation
	local damage = SpaceDamage(p2,0)
	damage.sAnimation = "tosx_magflare"
	if magthis then damage.sImageMark = "combat/icons/tosx_polarity2_icon_glow.png" end
	ret:AddDamage(damage)
	ret:AddDelay(0.2)
	
	-- Artificial TipImage shenanigans to give it a magnetized pawn on second use
	if IsTipImage() and not Board:IsPawnSpace(Point(2,2)) then
		magthis = Board:GetPawn(Point(2,1)):GetId()
	end
	
	for i = 0, 7 do
		for j = 0, 7  do
			local point = Point(i,j) -- DIR_LEFT
			if dir == DIR_RIGHT then
				point = Point(7 - i, j)
			elseif dir == DIR_UP then
				point = Point(j,i)
			elseif dir == DIR_DOWN then
				point = Point(j,7-i)
			end
			
			if Board:IsPawnSpace(point) and point ~= p1 then -- don't move self
				local pawn = Board:GetPawn(point)
				if IsMagnetic(point) or pawn:GetId() == magthis then
				
					local damage = SpaceDamage(point, 0)
					damage.sAnimation = "tosx_magpush_"..dir
					damage.bHide = true
					ret:AddDamage(damage)
					
					local chargepoint = point
					for k = 1, 7 do						
						
						local point2 = point + DIR_VECTORS[dir]*k
						
						if (not Board:IsBlocked(point2, PATH_PROJECTILE) or 
						list_contains(extract_table(vacatedpoints), point2)) and
						not list_contains(extract_table(blockedpoints), point2) then
							chargepoint = point2
						else
							break
						end
						
					end
					
					if self.StableDamage == 1 and pawn:IsGuarding() then
						-- Magnetic immovables can still damage/push
						chargepoint = point
					end
					
					if self.StableDamage == 1 or not pawn:IsGuarding() then

						if chargepoint ~= point then
							vacatedpoints:push_back(point)
							
							if downhole then
								-- Units that can die in holes or water do not block such spaces
								local block = true
								
								if Board:GetTerrain(chargepoint) == TERRAIN_HOLE then block = false end
								if Board:GetTerrain(chargepoint) == TERRAIN_WATER and not _G[pawn:GetType()].Massive then block = false end
								if pawn:IsFlying() then block = true end
								
								if block then
									blockedpoints:push_back(chargepoint)
								end
								
							else
								blockedpoints:push_back(chargepoint)
							end
							
							ret:AddCharge(Board:GetPath(point, chargepoint, PATH_FLYER), NO_DELAY)
						end
						
-- Everything here is JUST used to preview post-charge bumps
						local target2 = chargepoint + DIR_VECTORS[dir]
									--LOG("???? Will push clear "..target2:GetString())
						local target3 = target2 + DIR_VECTORS[dir]
						if Board:IsValid(target3) then -- Tile is an edge; no bump damage
									--LOG("???? Is this empty: "..target3:GetString())
							if ((not Board:IsBlocked(target3, PATH_PROJECTILE) or list_contains(extract_table(vacatedpoints), target3))
							and not list_contains(extract_table(blockedpoints), target3)) or -- Tile is/will be empty
							list_contains(extract_table(pushedpoints), target3) then -- Tile isn't/won't be empty, but will be pushed empty
								if not Board:IsBlocked(target2, PATH_PROJECTILE) or (Board:IsPawnSpace(target2) and not IsGuarding2(target2)) then
									-- This can move and has somewhere to go
									-- Add it to a list to let future checks know
									--LOG("             Push will clear "..target2:GetString())
									pushedpoints:push_back(target2)
								end
							end
						end
-- Everything here is JUST used to preview post-charge bumps

						targetcount = targetcount + 1
						delay_array[targetcount] = point:Manhattan(chargepoint) * 0.06
						landing_array[targetcount] = chargepoint
					end

				end
			end
		end
	end
	
	-- Try to get the damage and pushes to correspond with each flung unit reaching its destination
	if targetcount > 0 then
		local sumdelay = 0
		local currdelay = -1
		local i = 0
		while i < 8*0.06 do
			for j = 1, targetcount do
				if math.abs(delay_array[j] - i) < 0.001 then -- Rounding errors; can't compare exact
					currdelay = i
				end
			end
			if currdelay == i then
				ret:AddDelay(currdelay - sumdelay)
				sumdelay = currdelay
				for j = 1, targetcount do
					if math.abs(delay_array[j] - i) < 0.001 then
						local target = landing_array[j]+ DIR_VECTORS[dir]
						local damage3 = SpaceDamage(target, self.Damage)
						if self.Impact == 1 then
							damage3.iPush = dir
							damage3.sAnimation = "airpush_"..dir
						end
						if self.Friendly == 1 and Board:IsBuilding(target) then
							damage3.iDamage = 0
						end						
												
-- Everything here is JUST used to preview post-charge bumps
						if not Board:IsBlocked(target, PATH_PROJECTILE) then
						-- Something isn't here yet and will be pushed; force preview
							local target2 = target + DIR_VECTORS[dir]
							if Board:IsValid(target2) then
								previewer:AddAnimation(target, "tosx_fakepush_square")
								
								if not list_contains(extract_table(pushedpoints), target2) and Board:IsValid(target2) then
								-- target will crash
									-- iPush = 230 will FORCE bump damage in preview! Only to 1 tile though
									--LOG("Fake bump to: "..target:GetString().." and #2 to: "..target2:GetString())
									
									local mission = GetCurrentMission()
									if mission then
										mission.podMarkedTiles = mission.podMarkedTiles or {}
										local pushnum = 220
										if list_contains(mission.podMarkedTiles, loc) then pushnum = 230 end
										
										local t = SpaceDamage(target, self.Damage, pushnum)
										previewer:AddDamage(t)
										previewer:AddAnimation(target, "tosx_fakepushC_"..dir)
										
										--LOG("Fake bump #2 to "..target2:GetString())
										local t2 = SpaceDamage(target2, 0, pushnum)
										previewer:AddDamage(t2)
									end
									
								else
									previewer:AddAnimation(target, "tosx_fakepush_"..dir)
								end
							end
						end
-- Everything here is JUST used to preview post-charge bumps
						
						ret:AddMelee(landing_array[j], damage3, NO_DELAY)
					end
				end
			end
			i = i + 0.06
		end
	end
		
	if targetcount > 3 then
		ret:AddScript("tosx_magnetsquad_Chievo('tosx_magnet_whiplash')")
	end

	return ret
end

tosx_Brute_MagnetSling_A = tosx_Brute_MagnetSling:new{
	UpgradeDescription = "This attack will no longer damage Grid Buildings.",
	Friendly = 1,
}

tosx_Brute_MagnetSling_B = tosx_Brute_MagnetSling:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Brute_MagnetSling_AB = tosx_Brute_MagnetSling:new{
	Damage = 2,
	Friendly = 1,
}


tosx_Ranged_FluxArtillery = Skill:new{  
	Name = "Flux Artillery",
	Description = "Magnetize a target and push adjacent tiles. Damages enemies that are already Magnetized.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_mag3.png",
	Rarity = 2,
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/tractor_beam",
	Damage = 2,
	ArtillerySize = 8,
	PowerCost = 0,
	PathSize = 8,
	Upgrades = 2,
	--UpgradeList = { "+2 Mag Damage",  "+2 Mag Damage"  },
	UpgradeCost = { 1,2 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(1,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Ranged_FluxArtillery")

function tosx_Ranged_FluxArtillery:GetTargetArea(p1)
	local ret = PointList()	
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local point = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(point) then
				break
			end
			ret:push_back(point)
		end
	end
	
	ShowPolarities()
	-- Extra work for displaying in TipImage, since weaponPreview doesn't work there
	if IsTipImage() and not Board:IsPawnSpace(Point(1,1)) then
		ShowPolaritiesTip(Point(2,1))
	end

	return ret
end

function tosx_Ranged_FluxArtillery:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)	
	local magthis = nil
	ret:AddScript("tosx_resetTipPolarity()") -- Clears the TipImage animation flag
	
	local damage = SpaceDamage(p2,0)
	if Board:IsPawnSpace(p2) then
		if IsMagnetic(p2) or (IsTipImage() and not Board:IsPawnSpace(Point(1,1))) then
			damage.iDamage = self.Damage
		else
			magthis = Board:GetPawn(p2):GetId()
			damage.sImageMark = "combat/icons/tosx_polarity2_icon_glow.png"
		end
	end

	ret:AddBounce(p1, 1)	
	ret:AddArtillery(damage, "effects/tosx_shotup_flux1.png", FULL_DELAY)--!!!
	
	ret:AddBounce(p2, 2)
	
	for dir = DIR_START, DIR_END do
		local point = p2 + DIR_VECTORS[dir]
		if Board:IsValid(point) then
			local damage2 = SpaceDamage(point,0,dir)
			damage2.sAnimation = "airpush_"..dir
			ret:AddDamage(damage2)
		end
	end
	
	-- Have to add this animation separate from the artillery shot, otherwise "FULL_DELAY" waits until the anim ends
	local damage3 = SpaceDamage(p2,0)
	damage3.sAnimation = "tosx_magflare"
	damage3.bHide = true
	ret:AddDamage(damage3)
	
	if magthis and not IsTipImage() then
		local turn = IsTestMechScenario() and 1 or Game:GetTurnCount()
		ret:AddScript("GAME.tosx_PosPolarities["..magthis.."] = "..turn) -- Add to magnetic list
	end
	
	return ret
	
end

tosx_Ranged_FluxArtillery_A = tosx_Ranged_FluxArtillery:new{
	UpgradeDescription = "Increases damage to Magnetized units by 2.",
	Damage = 4,
}

tosx_Ranged_FluxArtillery_B = tosx_Ranged_FluxArtillery:new{
	UpgradeDescription = "Increases damage to Magnetized units by 2.",
	Damage = 4,
}

tosx_Ranged_FluxArtillery_AB = tosx_Ranged_FluxArtillery:new{
	Damage = 6,
}


local function ResetMagVars()
	GAME.tosx_PosPolarities = nil
end

return {
	ResetMagVars = ResetMagVars,
}