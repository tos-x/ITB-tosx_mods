local wt2 = {	
	tosx_Prime_TimeLance_Upgrade1 = "-1 Self Damage",
	tosx_Prime_TimeLance_Upgrade2 = "+2 Damage",
	
	tosx_Science_TimeClock_Upgrade1 = "+1 Range",
	tosx_Science_TimeClock_Upgrade2 = "+1 Range",
	
	tosx_Ranged_Stasis_Upgrade1 = "Buildings Immune",
	tosx_Ranged_Stasis_Upgrade2 = "+1 Damage",
	
	tosx_Science_TimeTear_Upgrade1 = "Free Action",
	tosx_Science_TimeTear_Upgrade2 = "Rewind Allies",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

local path = mod_loader.mods[modApi.currentMod].scriptPath
local timeLooping = require(path .."libs/timeLooping")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end


tosx_Prime_TimeLance = Skill:new{  
	Name = "Rift Lance",
	Description = "Damage and push an adjacent tile. Mech can teleport up to 2 tiles first by damaging itself.",
	Class = "Prime",
	Icon = "weapons/tosx_weapon_time1.png",
	Rarity = 2,
	Damage = 1,
	SwapRange = 2,
	SwapDamage = 1,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "-1 Self Damage" , "+2 Damage"},
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Prime_TimeLance")

function tosx_Prime_TimeLance:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for k = 1, self.SwapRange + 1 do
			local point = p1 + DIR_VECTORS[dir]*k
			local point2 = p1 + DIR_VECTORS[dir]*(k-1)
			
			if k == 1
			or (Board:IsPawnSpace(point2) and not Board:GetPawn(point2):IsGuarding())
			or not Board:IsBlocked(point2, PATH_FLYER) then
				ret:push_back(point)
			end
			if not Board:IsValid(point) then
				break
			end
		end
	end
	
	return ret
end

function tosx_Prime_TimeLance:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)
	local p3 = p2 - DIR_VECTORS[direction]

	if distance > 1 then -- 1 dmg per tile (unupgraded)
		ret:AddDelay(0.1)
		local sdmg = self.SwapDamage + distance - 2
		local damage = SpaceDamage(p1,sdmg)
		damage.sSound = "/weapons/enhanced_tractor"
		ret:AddDamage(damage)
		
		ret:AddTeleport(p1,p3, 0)
		if Board:IsPawnSpace(p3) then
			ret:AddTeleport(p3,p1,0)
		end
		ret:AddDelay(0.5)
	end

	-- Damage
	local damage = SpaceDamage(p2,self.Damage,direction)
	damage.sAnimation = "timespear1_"..direction
	damage.sSound = "/weapons/sword"
	ret:AddDamage(damage)
	
	return ret
end

tosx_Prime_TimeLance_A = tosx_Prime_TimeLance:new{
	UpgradeDescription = "Reduces the damage the Mech takes when using this weapon by 1.",
	SwapDamage = 0,
}

tosx_Prime_TimeLance_B = tosx_Prime_TimeLance:new{
	UpgradeDescription = "Increases damage by 2.",
	Damage = 3,
}

tosx_Prime_TimeLance_AB = tosx_Prime_TimeLance:new{
	SwapDamage = 0,
	Damage = 3,
}

tosx_Science_TimeClock = Skill:new{  
	Name = "Chronostasis",
	Description = "Push a tile and cancel enemy attacks.",
	Class = "Science",
	Icon = "weapons/tosx_weapon_time3.png",
	Rarity = 3,
	PowerCost = 0,
	PathSize = 1,
	Upgrades = 2,
	Friendly = false,
	Push = true,
	--UpgradeList = { "+1 Range",  "+1 Damage"  },
	UpgradeCost = { 1,2 },
	TipImage = {
		Unit = Point(2,3),
		Enemy1 = Point(2,2),
		Queued1 = Point(3,2),
		Building = Point(3,2),
		Target = Point(2,2),
	}
}
modApi:addWeaponDrop("tosx_Science_TimeClock")

function tosx_Science_TimeClock:GetTargetArea(p1)			
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for k = 1, self.PathSize do
			local point = p1 + DIR_VECTORS[dir]*k
			ret:push_back(point)
			if not Board:IsValid(point) then
				break
			end
		end
	end	
	
	return ret
end

function tosx_Science_TimeClock:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)
	
	local psh = (self.Push and direction) or DIR_NONE
	local damage2 = SpaceDamage(p2, 0, psh)
	
	if self.Friendly and Board:IsPawnSpace(p2) and Board:GetPawn(p2):GetTeam() == TEAM_PLAYER then
		damage2.sAnimation = "tosx_clockFF"
		damage2.sImageMark = "combat/icons/tosx_future_icon_glow.png"
		damage2.sSound = "enemy/shared/robot_power_on"
		ret:AddScript("Board:GetPawn(Point("..p2:GetString()..")):SetActive(true)")
	else
		damage2.sAnimation = "tosx_clockXX"
		--damage2.sSound = "props/freezing"
		damage2.sSound = "enemy/shared/robot_power_on"
		damage2.sImageMark = "combat/icons/tosx_stasis_icon_off_glowB.png"
		ret:AddScript("Board:GetPawn(Point("..p2:GetString()..")):ClearQueued()")	
		
		-- Break webs too, just in case the push fails
		if Board:IsPawnSpace(p2) then
			damage2.sImageMark = "combat/icons/tosx_stasis_icon_glowB.png"
			local pawn2 = Board:GetPawn(p2)
			if not (_G[pawn2:GetType()].ExtraSpaces[1] or pawn2:IsGuarding()) then
				ret:AddScript([[Board:GetPawn(]]..pawn2:GetId()..[[):SetSpace(Point(-1,-1))]])
				ret:AddDelay(0.01)
				ret:AddScript([[Board:GetPawn(]]..pawn2:GetId()..[[):SetSpace(]]..p2:GetString()..[[)]])
			end
		end
	end
	ret:AddDamage(damage2)
	
	return ret
end

tosx_Science_TimeClock_A = tosx_Science_TimeClock:new{
	UpgradeDescription = "Extends range by 1 tile.",
	PathSize = 2,
	TipImage = {
		Unit = Point(2,3),
		Mountain = Point(2,2),
		Enemy1 = Point(2,1),
		Queued1 = Point(3,1),
		Building = Point(3,1),
		Target = Point(2,1),
	}
}

tosx_Science_TimeClock_B = tosx_Science_TimeClock:new{
	UpgradeDescription = "Extends range by 1 tile.",
	PathSize = 2,
	TipImage = {
		Unit = Point(2,3),
		Mountain = Point(2,2),
		Enemy1 = Point(2,1),
		Queued1 = Point(3,1),
		Building = Point(3,1),
		Target = Point(2,1),
	}
}

tosx_Science_TimeClock_AB = tosx_Science_TimeClock:new{
	PathSize = 3,
	TipImage = {
		Unit = Point(2,3),
		Mountain = Point(2,2),
		Enemy1 = Point(2,1),
		Queued1 = Point(3,1),
		Building = Point(3,1),
		Target = Point(2,1),
	}
}




----------------------------------------
tosx_Science_TimeTear = Skill:new{  
	Name = "Temporal Tear",
	Description = "Open a rift that time-travels past enemies to the present for the rest of the turn.\n\nDamaging past units damages their present selves.",
	Class = "Science",
	Icon = "weapons/tosx_weapon_time4.png",
	Rarity = 3,
	LaunchSound = "ui/battle/power_down",
	PowerCost = 0,
	Limited = 2,
	Upgrades = 2,
	Friendly = false,
	Heal = false,
	Reactivate = false,
	--UpgradeList = { "Free Action",  "Rewind Allies"  },
	UpgradeCost = { 2 , 2 },
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Enemy2 = Point(3,3),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Science_TimeTear")

function tosx_Science_TimeTear:GetTargetArea(p1)			
	local ret = PointList()
	for i = 0,7 do
		for j = 0,7 do
			local target = Point(i,j)
			if Board:IsValid(target) then
				ret:push_back(Point(i,j))
			end
		end
	end
	
	timeLooping:ShowLoop0(p1)
	-- Extra work for displaying in TipImage, since weaponPreview doesn't work there
	if IsTipImage() then
		local effect = SkillEffect()
		effect:AddDelay(0.6)
		timeLooping:ShowLoop0Tip(Point(2,1),1,effect)
		timeLooping:ShowLoop0Tip(Point(3,3),1,effect)
		timeLooping:DisableTip(effect)
	end
	
	return ret
end

function tosx_Science_TimeTear:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local bounceamount = 3
	ret:AddScript("tosx_resetTipLoop()") -- Clears the TipImage animation flag
	local dmgoverlap = false
	
	ret:AddBounce(p1, bounceamount)	
		
	--Add p1 animation no matter what
	local damage3 = SpaceDamage(p1,0)
	damage3.sAnimation = "tosx_summon_traveler"
	damage3.bHide = true
	ret:AddDamage(damage3)
	
	ret:AddDelay(0.6)
	ret:AddBoardShake(0.5)
	ret:AddSound("/weapons/science_repulse")
	
	-- Show fake summons on each empty loop tile within box
	if GAME and not IsTipImage() then
		if GAME.tosx_LooperStorage then
			for i,entry in pairs(GAME.tosx_LooperStorage) do
				local point = Point(i%8, math.floor(i/8))
								
				if timeLooping:IsLoopPoint(point) > 0 then
					if Board:IsBlocked(point, PATH_PROJECTILE) or
					timeLooping:IsLoopPoint(point) == 2 or
					(not self.Friendly and entry.team == TEAM_PLAYER) then
						-- Orange preview
						-- Blocked preview (orange or blue)
						-- Friendly preview without upgrade (blocked, orange, blue, whatev)
						local curr = 0
						if point == p2 and timeLooping:IsLoopPoint(point) ~= 2 then -- exclude orange
							curr = timeLooping:DamagePastTile(ret, point, 0) -- Don't actually deal past damage
							if curr and curr ~= 0 then
								local damage = SpaceDamage(curr, 0)
								damage.sImageMark = "combat/icons/tosx_future_icon_glowX.png"
								--ret:AddDamage(damage)
								if point ~= curr then
									ret:AddArtillery(point,damage,"",NO_DELAY)
								else
									ret:AddDamage(damage)
								end
							end
						end
					else
						local damage0 = SpaceDamage(point,0)
						damage0.sPawn = entry.ptype
						--damage0.sAnimation = "" --prevent delays
						damage0.sAnimation = "tosx_loop_icon_once0"
						damage0.fDelay = 0
						
						if point == p2 then							
							--Also try to mark the linked pawn in the present, if they exist
							local curr = 0
							curr = timeLooping:DamagePastTile(ret, p2, 0) -- Don't actually deal past damage
							if curr and curr ~= 0 then
								local damage = SpaceDamage(curr, 0)
								damage.sImageMark = "combat/icons/tosx_future_icon_glow.png"
								--ret:AddDamage(damage)
								if point ~= curr then
									ret:AddArtillery(point,damage,"",NO_DELAY)
								else
									ret:AddDamage(damage)
								end
							end
						end
						
						ret:AddDamage(damage0)
						
						--Remove the sPawn, we added our own via script
						ret:AddScript([[
							local pawn = Board:GetPawn(Point(]]..point:GetString()..[[))
							Board:RemovePawn(pawn)
						]])
						timeLooping:SummonLoopUnit(ret,point)
					end
				end
			end
		end
	end
	local tippoint = Point(1,1)
	if IsTipImage() then
		local damage0 = SpaceDamage(p2,0)
		damage0.sPawn = Board:GetPawn(tippoint):GetType()
		--damage0.sAnimation = "" --prevent delays
		damage0.sAnimation = "tosx_loop_icon_once0"
		damage0.fDelay = 0
		ret:AddDamage(damage0)
		
		--Also try to mark the linked pawn in the present, if they exist
		local damage = SpaceDamage(tippoint, 0)
		damage.sImageMark = "combat/icons/tosx_future_icon_glow.png"
		ret:AddDamage(damage)
		ret:AddScript([[
			local pawn = Board:GetPawn(Point(]]..p2:GetString()..[[))
			Board:RemovePawn(pawn)
		]])
		--Manually add pawn, make it glow
		ret:AddScript([[
			Board:AddPawn("]]..Board:GetPawn(tippoint):GetType()..[[",]]..p2:GetString()..[[)
			]])
		local damagei = SpaceDamage(p2,0)
		damagei.bHide = true
		damagei.sAnimation = "tosx_loop_icon1atip"
		ret:AddDamage(damagei)
	end
	
	if self.Heal and not IsTipImage() then
		if GAME and GAME.tosx_LooperAllyHP then
			GAME.tosx_LooperAllyHP = GAME.tosx_LooperAllyHP or {}
			for id,hp in pairs(GAME.tosx_LooperAllyHP) do
				local pawn = Board:GetPawn(id)
				if pawn and (pawn:GetHealth() < hp or pawn:IsDead()) then
					local heal = SpaceDamage(pawn:GetSpace(), pawn:GetHealth() - hp)
					if pawn:IsDead() then
						heal.iDamage = -hp
						ret:AddScript("tosx_timesquad_Chievo('tosx_time_groundhog')")
					end
					ret:AddDamage(heal)
				end
			end
		end
	end
	if self.Reactivate then
		ret:AddDelay(0.2)
		ret:AddScript([[
			local self = Point(]].. p1:GetString() .. [[)
			Board:GetPawn(self):SetActive(true)
			Game:TriggerSound("/ui/map/flyin_rewards");
			Board:Ping(self, GL_Color(255, 255, 255));
		]])
	end
	
	return ret
end

tosx_Science_TimeTear_A = tosx_Science_TimeTear:new{
	UpgradeDescription = "Mech can attack again after opening a Tear.",
	Reactivate = true,
}

tosx_Science_TimeTear_B = tosx_Science_TimeTear:new{
	UpgradeDescription = "Restores Mechs to the health they had at the end of the last player turn.",
	Heal = true,
}

tosx_Science_TimeTear_AB = tosx_Science_TimeTear:new{
	Reactivate = true,
	Heal = true,
}
----------------------------------------






tosx_Ranged_Stasis = Skill:new{  
	Name = "Oblivion Strike",
	Description = "Artillery attack that damages 3 tiles, pushing the outer tiles.",
	Class = "Ranged",
	Icon = "weapons/tosx_weapon_time2.png",
	Rarity = 2,
	ArtillerySize = 8,
	Safe = false,
	LaunchSound = "/weapons/wide_shot",
	ImpactSound = "/weapons/boulder_throw",
	Damage = 1,
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "Building Immune",  "+1 Damage"  },
	UpgradeCost = { 2,3 },
	TipImage = {
		Unit = Point(2,3),
		CustomEnemy = "Hornet2",
		Enemy = Point(2,1),
		Enemy2 = Point(1,1),
		Building = Point(3,1),
		Target = Point(2,1),
	}
}
modApi:addWeaponDrop("tosx_Ranged_Stasis")

function tosx_Ranged_Stasis:GetTargetArea(p1)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local point = Point(p1 + DIR_VECTORS[dir] * i)
			ret:push_back(point)
			if not Board:IsValid(point) then
				break
			end
		end
	end
	
	return ret
end

function tosx_Ranged_Stasis:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local dir2a = (dir+1)%4
	local dir2b = (dir-1)%4
	local p2a = p2 + DIR_VECTORS[dir2a]
	local p2b = p2 + DIR_VECTORS[dir2b]
	
	local damage = SpaceDamage(p2, self.Damage)
	if self.Safe and Board:IsBuilding(p2) then damage.iDamage = 0 end
	damage.sAnimation = "tosx_loop_icon_once2"
	ret:AddBounce(p1, 1)
	ret:AddDamage(damage)
	--ret:AddArtillery(damage,"effects/shotdown_rock.png")
	ret:AddBounce(p2, 1)
	ret:AddBoardShake(0.15)
	ret:AddDelay(0.1)
	
	local damagepush = SpaceDamage(p2a, self.Damage, dir2a)
	if self.Safe and Board:IsBuilding(p2a) then damagepush.iDamage = 0 end
	damagepush.sAnimation = "tosx_loop_icon_once2"
	ret:AddDamage(damagepush)
	damagepush = SpaceDamage(p2b, self.Damage, dir2b)
	if self.Safe and Board:IsBuilding(p2b) then damagepush.iDamage = 0 end
	damagepush.sAnimation = "tosx_loop_icon_once2"
	ret:AddDamage(damagepush)
	
	local damageanim = SpaceDamage(p2a)
	damageanim.bHide = true
	damageanim.sAnimation = "airpush_"..(dir2a)
	ret:AddDamage(damageanim)
	damageanim.loc = p2b
	damageanim.sAnimation = "airpush_"..(dir2b)
	ret:AddDamage(damageanim)
	
	-- achievement checking
	local count = 0
	if Board:IsPawnSpace(p2) then count = count + 1 end
	if Board:IsPawnSpace(p2a) then count = count + 1 end
	if Board:IsPawnSpace(p2b) then count = count + 1 end
	if count >= 2 and GAME and GAME.tosx_LooperSummons then		
		GAME.tosx_LooperSummons = GAME.tosx_LooperSummons or {}
		for pastid, presentid in pairs(GAME.tosx_LooperSummons) do
			local pp1 = Board:GetPawnSpace(pastid)
			local pp2 = Board:GetPawnSpace(presentid)
			if pp1 and pp2 then
				if (pp1 == p2 or pp1 == p2a or pp1 == p2b) and
				(pp2 == p2 or pp2 == p2a or pp2 == p2b) then
					ret:AddScript("tosx_timesquad_Chievo('tosx_time_oblivion')")
				end
			end
		end
	end
	
	return ret
end

tosx_Ranged_Stasis_A = tosx_Ranged_Stasis:new{
	UpgradeDescription = "This attack will no longer damage Grid Buildings.",
	Safe = true,
}

tosx_Ranged_Stasis_B = tosx_Ranged_Stasis:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

tosx_Ranged_Stasis_AB = tosx_Ranged_Stasis:new{
	Safe = true,
	Damage = 2,
}