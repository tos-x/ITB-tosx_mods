
local path = mod_loader.mods[modApi.currentMod].scriptPath
local previewer = require(path .."libs/weaponPreview")
local customAnim = require(path .."libs/customAnim")
local selected = require(path .."libs/selected")
local getWeapons = require(path .."libs/getWeapons")
local tips = require(path .."libs/tutorialTips")
local trait = require(path .."libs/trait")
	
local traitfunc_time = function(trait, pawn)
	return GAME and GAME.tosx_LooperSummons and GAME.tosx_LooperSummons[pawn:GetId()]
end
trait:add{
		func = traitfunc_time,
		icon = mod_loader.mods[modApi.currentMod].resourcePath.."img/combat/traits/tosx_past_trait.png",
		--icon_glow = mod_loader.mods[modApi.currentMod].resourcePath.."img/combat/traits/tosx_past_trait.png",
		icon_offset = Point(0,0),
		desc_title = "Past Unit",
		desc_text = "Damaging this unit will damage its present self (currently glowing orange). This unit will fade just before new enemies emerge.",
	}

local this = {}

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end
-------------------------------------------------
-- Settings flags
-------------------------------------------------
setting_InstantUnloopDeath = true
setting_InstantUnloopDamage = true
setting_NoRecursion = true
setting_NoDuplication = true
setting_ShowLoopParent = true
setting_PreventPastXp = true
setting_UpgradedPastHP = true
setting_PastFades = true
setting_NoDeathEffect = true
setting_CombineLoopDmg = true
setting_TrackAllies = false
setting_ShowOrange = false
setting_TrackBurrowers = true

tips:Add{
	id = "ShowThePast",
	title = "Temporal Lensing",
	text = "Blue glows show where enemy units were located last turn."
}
if setting_PastFades then
	tips:Add{
		id = "ShowAlteredPast",
		title = "Traces of Time Travel",
		text = "Orange glows show the past locations of units that cannot time travel (either units from the past, or units whose past selves have already traveled)."
	}
else
	tips:Add{
		id = "ShowAlteredPast",
		title = "Traces of Time Travel",
		text = "Orange glows show the past locations of time traveling units."
	}
end
tips:Add{
	id = "ExplainPastUnits",
	title = "Units from the Past",
	text = "Units from the past glow blue. Selecting them makes their present self glow orange.\n\nDamage to a past unit will appear on its present self. Past units fade just before new enemies emerge."
}
tips:Add{
	id = "ExplainAllyTimeTravel",
	title = "Time Traveling Allies",
	text = "Allies that travel to the present can act immediately. However, time travel disrupts Pilots, Weapon upgrades, Move upgrades and Passives on past Mechs."
}
--------------------------------------------
-- Note: Blob deaths are counted based on pawntypes containing "BlobBoss" string
Blob_tosxDE_Boss = BlobBoss:new{
	DeathSpawn = "",
}	
AddPawnName("Blob_tosxDE_Boss")
Blob_tosxDE_BossMed = BlobBossMed:new{
	DeathSpawn = "",
}	
AddPawnName("Blob_tosxDE_BossMed")
--------------------------------------------

function this:IsLoopPoint(point)
	--Returns 2 if a loop point that can't be summoned again
	--Returns 1 for any other loop point
	--Returns 0 for not a loop point
	if GAME then
		if GAME.tosx_LooperStorage then
			local pid = p2idx(point)
			if GAME.tosx_LooperStorage[pid] then
				if not GAME.tosx_LooperStorage[pid].looped then
					if GAME.tosx_LooperSummons then
						--No Recursion means summoned units can't have past selves summoned
						if GAME.tosx_LooperSummons[GAME.tosx_LooperStorage[pid].id]
						and setting_NoRecursion then
							return 2
						end
						
						--No Duplication means if a unit's past self has been summoned, it can't be summoned again (currently EVER, could change to "while alive")
						if setting_NoDuplication then
							for i,entry in pairs(GAME.tosx_LooperSummons) do
								if GAME.tosx_LooperStorage[pid].id == entry then
									return 2
								end
							end
						end
					end
					return 1
				else
					return 2
				end
			end
		end
	end
	return 0
end

local tiploop = false
function tosx_resetTipLoop()
	tiploop = false
end
function this:DisableTip(effect)
	tiploop = true
	Board:AddEffect(effect)
end
function this:ShowLoop0Tip(p1,i,effect)
	if tiploop then return false end
	local damage = SpaceDamage(p1,0)
	damage.bHide = true
	damage.sAnimation = "tosx_loop_icon"..i.."tip"
	effect:AddDamage(damage)
end

function this:ShowLoop0(p1)
	-- Call during GetTargetArea to show past unit locations
	-- Blue normally, orange for past units that have been summoned
	if GAME then
		if GAME.tosx_LooperStorage then
			for i,entry in pairs(GAME.tosx_LooperStorage) do
				local point = Point(i%8, math.floor(i/8))
				if this:IsLoopPoint(point) > 0 then
					if this:IsLoopPoint(point) == 2 then
						if setting_ShowOrange then
							-- Orange preview, can't summon
							previewer:AddAnimation(point, "tosx_loop_icon0")
							if not (IsTipImage() or IsTestMechScenario()) then
								tips:Trigger("ShowAlteredPast", p1)
							end
						end
					else
						previewer:AddAnimation(point, "tosx_loop_icon1")
						if not (IsTipImage() or IsTestMechScenario()) then
							tips:Trigger("ShowThePast", p1)
						end
					end
				end
			end
		end
	end
end

function AnimateLoopUnit(id)
	-- Called automatically during past unit summoning
	-- Adds an animation to the id'd pawn
	if false then return end
	local mission = GetCurrentMission()
	local desc = "loopanimtest"
	customAnim:Add(mission, id, "tosx_loop_icon1a", desc)
	if not (IsTipImage() or IsTestMechScenario()) then
		tips:Trigger("ExplainPastUnits", Board:GetPawnSpace(id))
	end
end

function this:SummonLoopUnit(skillEffect,point)
	-- Adds some scripts to the skillEffect to summon a point's past unit, with its past health
	if GAME then
		if GAME.tosx_LooperStorage then
			local pid = p2idx(point)
			if GAME.tosx_LooperStorage[pid] then
				if not GAME.tosx_LooperStorage[pid].looped then
					local spid = GAME.tosx_LooperStorage[pid]

------------------------------		
					--This code calculates additional damage needed to bring new pawn's health to what it was last turn
					local hpdiff = 0
					local looptype = spid.ptype
					local loophp = spid.hp
					local maxhp = _G[looptype].Health
					
					-- First check for soldier psions (higher max hp)
					local anysoldier = false
					local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
					for i,id in pairs(foes) do
						local pawn2 = Board:GetPawn(id)
						if (pawn2:GetType() == "Jelly_Health1" or pawn2:GetType() == "Jelly_Boss") and not IsTestMechScenario() then
							anysoldier = id
						end
					end			

					if spid.team == TEAM_ENEMY and anysoldier and looptype ~= "Jelly_Health1" and looptype ~= "Jelly_Boss" then
						maxhp = maxhp + 1
					end
				
					if loophp > maxhp then
						if setting_UpgradedPastHP then maxhp = loophp else end
						loophp = maxhp
					end
					hpdiff = maxhp - loophp
------------------------------

					--Need to add pawn, and add pawn to track array, via script
					--Manually set team, just in case
					--Set looped flag so it can't be summoned again this turn
					GAME.tosx_LooperSummons = GAME.tosx_LooperSummons or {}
					
					--Currently, player pawns will spawn with unupgraded versions of whatever weapons they have
					skillEffect:AddScript([[
						local looptype = "]]..looptype..[["
					
						if setting_NoDeathEffect then
							if looptype == "BlobBoss" then looptype = "Blob_tosxDE_Boss" end
							if looptype == "BlobBossMed" then looptype = "Blob_tosxDE_BossMed" end
						end
					
						local oldSkillList = _G[looptype].SkillList
						if (GAME.tosx_LooperStorage[]]..pid..[[].weapons[1] or GAME.tosx_LooperStorage[]]..pid..[[].weapons[2]) then
							_G[looptype].SkillList = { GAME.tosx_LooperStorage[]]..pid..[[].weapons[1] , GAME.tosx_LooperStorage[]]..pid..[[].weapons[2] }
						end
						
						local oldMinor = _G[looptype].Minor
						if setting_PreventPastXp then _G[looptype].Minor = true end
						
						local oldMaxHp = _G[looptype].Health
						if setting_UpgradedPastHP and _G[looptype].Health < ]]..maxhp..[[ then
							_G[looptype].Health = ]]..maxhp..[[
						end
						
						Board:AddPawn(looptype,]] .. point:GetString() .. [[)
						
						_G[looptype].SkillList = oldSkillList
						if setting_PreventPastXp then _G[looptype].Minor = oldMinor end
						if setting_UpgradedPastHP then _G[looptype].Health = oldMaxHp end
						
						setting_InstantUnloopDamage = false
						local pawn0 = Board:GetPawn(]]..point:GetString()..[[)
						pawn0:SetHealth(]]..loophp..[[)
						setting_InstantUnloopDamage = true
						
						pawn0:SetTeam(]]..spid.team..[[)
						GAME.tosx_LooperSummons[pawn0:GetId()] = ]]..spid.id..[[
						GAME.tosx_LooperStorage[]]..pid..[[].looped = true
						AnimateLoopUnit(pawn0:GetId())
						]])
					if not setting_ShowOrange then
						skillEffect:AddScript("GAME.tosx_LooperStorage["..pid.."] = nil")
					end
						
					
					if not (IsTipImage() or IsTestMechScenario()) then
						if spid.team == TEAM_PLAYER then
							tips:Trigger("ExplainAllyTimeTravel", point)
						end
					end
				
				end
			end
		end
	end
end

function this:DamagePastTile(skillEffect,point,past_dmg_amt)
	-- Adds some damage to the skill effect that effects any units that were on that tile last turn
	-- 1. If a unit was on that tile, return wherever they are now so that point can be damaged
	-- 2. If a past self was summoned from that tile, return wherever they are now so that point can be damaged
	-- (2. is instead of 1. instead, since that damage will transfer to the present version)
	-- 3. Their tracked HP is damaged too
	
	-- Inputs:
	--	past_dmg 			= integer damage to apply to the point in the past
	
	if this:IsLoopPoint(point) > 0 then
		-- A unit was here last turn; find them
		local pid = p2idx(point)
		
		-- Update their stored HP
		local newhp = GAME.tosx_LooperStorage[pid].hp - past_dmg_amt
		skillEffect:AddScript("GAME.tosx_LooperStorage["..pid.."].hp = "..newhp)
		
		local pid1 = GAME.tosx_LooperStorage[pid].id
		if this:IsLoopPoint(point) == 2 then
			-- A unit from here has been summoned
			for i,entry in pairs(GAME.tosx_LooperSummons) do
				if GAME.tosx_LooperStorage[pid].id == entry then
					pid1 = i
				end
			end
		end
		-- If it dies in past, stop tracking! It didn't survive to be tracked this turn
		if newhp <= 0 then
			skillEffect:AddScript("GAME.tosx_LooperStorage["..pid.."] = nil")
		end
		
		local pawn1 = Board:GetPawn(pid1)
		if pawn1 then
			-- The pawn is alive,  return its location
			return Board:GetPawnSpace(pid1)
		end
	end
	return nil
end

-------------------------------------------------
-- HOOKS
-------------------------------------------------

local function TrackAllyHP(mission)
	--LOG("track ally hp")
	if not mission.tosxTime_FirstEnvironmentTurn then
		mission.tosxTime_FirstEnvironmentTurn = true
		if GAME then
			GAME.tosx_LooperAllyHP = {}
			pawns = extract_table(Board:GetPawns(TEAM_MECH))
			for i,id in pairs(pawns) do
				local pawn = Board:GetPawn(id)
				if not pawn:IsDead() and pawn:GetHealth() >0 then
					GAME.tosx_LooperAllyHP[pawn:GetId()] = pawn:GetHealth()
				end
			end
		end
	end
end

local function ResetLoopVars()
	GAME.tosx_LooperStorage = nil
	GAME.tosx_LooperSummons = nil
	GAME.tosx_LoopDmg = nil
	GAME.tosx_LooperAllyHP = nil
	GAME.tosx_LoopBurrower = nil
end

local function TrackLoop(pid)
	if GAME then
		GAME.tosx_LooperStorage = GAME.tosx_LooperStorage or {}
		GAME.tosx_LoopBurrower = GAME.tosx_LoopBurrower or {}
		
		local mypawn = Board:GetPawn(pid)
--		--Only moveable, single-tile, alive pawns are tracked
--		if not mypawn:IsDead() and not _G[mypawn:GetType()].Burrows and not _G[mypawn:GetType()].ExtraSpaces[1] then

		--Only single-tile, alive pawns are tracked
		if not mypawn:IsDead() and not _G[mypawn:GetType()].ExtraSpaces[1] then
			if setting_TrackBurrowers or not _G[mypawn:GetType()].Burrows then
				--Need to store id, HP, type; index by location
				
				local pawnspace = mypawn:GetSpace()
				if pawnspace == Point(-1,-1) then
					if GAME.tosx_LoopBurrower[pid] then
						pawnspace = GAME.tosx_LoopBurrower[pid]
						GAME.tosx_LoopBurrower[pid] = nil
					end
				end
				
				local point = p2idx(pawnspace)
				--Need to make sure there's nothing already tracked at that point
				if not GAME.tosx_LooperStorage[point] then
					GAME.tosx_LooperStorage[point] = {}
					GAME.tosx_LooperStorage[point].id = pid
					GAME.tosx_LooperStorage[point].ptype = mypawn:GetType()
					GAME.tosx_LooperStorage[point].hp = mypawn:GetHealth()
					GAME.tosx_LooperStorage[point].team = mypawn:GetTeam()
					GAME.tosx_LooperStorage[point].looped = false
					GAME.tosx_LooperStorage[point].weapons = getWeapons:GetPoweredBase(mypawn) --only detects base weapons
				end
			end
		end
	end
end

local function UnsummonPast()
	if not setting_PastFades then return end
	if GAME then
		if GAME.tosx_LooperSummons then
			GAME.tosx_LooperSummons = GAME.tosx_LooperSummons or {}
			
			local effect = SkillEffect()
			effect:AddDamage(SpaceDamage(Point(0,0)))-- ensure not empty
			
			for k, v in pairs(GAME.tosx_LooperSummons) do
				local pawn0 = Board:GetPawn(k)
				if pawn0 then
					--LOG("Removing past pawn "..k)
					local d = SpaceDamage(pawn0:GetSpace(),0)
					d.sAnimation = "tosx_loop_icon_once1"
					d.sSound = "/impact/shield"
					effect:AddDamage(d)
					Board:RemovePawn(pawn0)
				end
			end
			
			Board:AddEffect(effect)
		end
		GAME.tosx_LooperSummons = {}
	end
end

local function NewTurnLoopUnits(mission)
	mission.tosxTime_FirstEnvironmentTurn = nil
	if Game:GetTeamTurn() == TEAM_ENEMY then
		UnsummonPast()
		--LOG("- Record pawns at enemy turn start")
		GAME.tosx_LooperStorage = nil
		local pawns2 = {}
		if setting_TrackAllies then
			pawns2 = extract_table(Board:GetPawns(TEAM_ANY))
		else
			pawns2 = extract_table(Board:GetPawns(TEAM_ENEMY))
		end
		for i,pid in pairs(pawns2) do
			TrackLoop(pid)
		end
	end
end

local function NewPawnLoopUnits(mission, pawn)
	--LOG("-- Record a new pawn")
	if (not setting_TrackAllies and pawn:GetTeam() ~= TEAM_ENEMY) then return false end
	TrackLoop(pawn:GetId())
end

local function InstantUnloopDeath(mission, pawn)
	if not setting_InstantUnloopDeath then return end
	local pid = pawn:GetId()
	if GAME then
		if GAME.tosx_LooperSummons then
			if GAME.tosx_LooperSummons[pid] then
				--Our pawn is a past unit
				--See if there's still a present unit to transfer death to
				local pawn0 = Board:GetPawn(GAME.tosx_LooperSummons[pid])
				if pawn0 and not pawn0:IsDead() then
					--LOG(pawn0:GetId().." dealt loop death!")
					local effect = SkillEffect()
					local pid0 = pawn0:GetId()					
					
					effect:AddScript([[
						pid0 = ]]..pid0..[[
						point0 = Board:GetPawnSpace(pid0)
						Board:DamageSpace(point0,DAMAGE_DEATH)
						tosx_timesquad_Chievo('tosx_time_grandpa')
						Board:AddAnimation(point0,"tosx_loop_icon_once0",ANIM_NO_DELAY)
						]])
						
					Board:AddEffect(effect)
					
					GAME.tosx_LoopDmg = GAME.tosx_LoopDmg or {}
					GAME.tosx_LoopDmg[pid0] = -100
				end
			end
		end
	end	
end

local function TrackBurrowers(mission, pawn, damageTaken)
	if not setting_TrackBurrowers then return end
	if not pawn:IsDead() and _G[pawn:GetType()].Burrows then
		GAME.tosx_LoopBurrower[pawn:GetId()] = pawn:GetSpace()
	end
end

local function InstantUnloopDamage(mission, pawn, damageTaken)
	if not setting_InstantUnloopDamage then return end
	local pid = pawn:GetId()
	if GAME then
		if GAME.tosx_LooperSummons then
			if GAME.tosx_LooperSummons[pid] then
				--Our pawn is a past unit
				--See if there's still a present unit to transfer damage to
				local pawn0 = Board:GetPawn(GAME.tosx_LooperSummons[pid])
				if pawn0 then
					if not pawn0:IsDead() and damageTaken ~= DAMAGE_DEATH then
						local effect = SkillEffect()
						if not setting_CombineLoopDmg then
							local hp = pawn0:GetHealth()
							hp = math.max(hp - damageTaken,0)
							pawn0:SetHealth(hp)
							local point0 = pawn0:GetSpace()
							local d = SpaceDamage(point0)
							d.sAnimation = "tosx_loop_icon_once0" --update!
							d.sSound = "/impact/generic/explosion"
							effect:AddDamage(d)
							Board:AddEffect(effect)
						else
							local pid0 = pawn0:GetId()
							--LOG(pid.." took "..damageTaken.. ", need to damage "..pid0)
							GAME.tosx_LoopDmg = GAME.tosx_LoopDmg or {}
							if GAME.tosx_LoopDmg[pid0] == -100 then
								GAME.tosx_LoopDmg[pid0] = nil
							else
								GAME.tosx_LoopDmg[pid0] = GAME.tosx_LoopDmg[pid0] or 0
								GAME.tosx_LoopDmg[pid0] = GAME.tosx_LoopDmg[pid0] + damageTaken
								
								effect:AddScript([[
									local pid0 = ]]..pid0..[[
									local point0 = Board:GetPawnSpace(pid0)
									if GAME.tosx_LoopDmg[pid0] then
										if GAME.tosx_LoopDmg[pid0] ~= -100 then
											local pawn0 = Board:GetPawn(pid0)
											local hp = pawn0:GetHealth() - GAME.tosx_LoopDmg[pid0]
											local d = 0
											
											if hp <= 0 then
												hp = 1
												d = DAMAGE_DEATH
											end
											
											pawn0:SetHealth(hp)											
											Board:DamageSpace(point0,d)
											
											Board:AddAnimation(point0,"tosx_loop_icon_once0",ANIM_NO_DELAY)
										end
									end
									GAME.tosx_LoopDmg[pid0] = nil
									]])
								Board:AddEffect(effect)
							end
						end
						--[[
						Note all this code is to lump damage, bump damage, and death damage together so things only get hit once
						That way armor/ice tiles interact cleaner
						]]
					end
				end
			end
		end
	end	
end

local selected_id = -1
local parent_id = -1
local function ShowLoopParent(screen)
	if not setting_ShowLoopParent then return end
	
	local mission = GetCurrentMission()
	if not mission or not Board then return end
	local sid = selected:Get()
	if sid then
		if sid:GetId() then
			sid = sid:GetId()
			if sid ~= selected_id then
				--LOG("Selected someone new")
				selected_id = sid
				if parent_id > -1 then
					customAnim:Rem(mission, parent_id, "tosx_loop_icon0a")
					parent_id = -1
				end
			end
		end
	elseif selected_id > -1 then
		--LOG("Deselecting")
		selected_id = -1
		if parent_id > -1 then
			customAnim:Rem(mission, parent_id, "tosx_loop_icon0a")
			parent_id = -1
		end
	end
	
	if selected_id > -1 then
		if GAME then
			if GAME.tosx_LooperSummons then
				if GAME.tosx_LooperSummons[selected_id] then
					if parent_id == -1 then
						local pawn1 = Board:GetPawn(GAME.tosx_LooperSummons[sid])
						if pawn1 then
							parent_id = GAME.tosx_LooperSummons[sid]
							customAnim:Add(mission, parent_id, "tosx_loop_icon0a", desc)
						end
					end
				end
			end
		end
	end
end


-------------------------------------------------

function this:init(mod)	
	self.id = mod.id .."_tosx_"
	
	self.selected = require(mod.scriptPath .."libs/selected")
	self.selected:init()
	
	sdlext.addFrameDrawnHook(ShowLoopParent)
end


function this:load()
	self.selected:load()

	modapiext:addPawnTrackedHook(NewPawnLoopUnits)
	modapiext:addPawnKilledHook(InstantUnloopDeath)
	modapiext:addPawnDamagedHook(TrackBurrowers)
	modapiext:addPawnDamagedHook(InstantUnloopDamage)
	modApi:addNextTurnHook(NewTurnLoopUnits)
	modApi:addMissionEndHook(ResetLoopVars)
	modApi:addMissionStartHook(ResetLoopVars)
	modApi:addMissionNextPhaseCreatedHook(ResetLoopVars)
	modApi:addTestMechEnteredHook(ResetLoopVars)
	modApi:addTestMechExitedHook(ResetLoopVars)
	
	modApi:addPreEnvironmentHook(TrackAllyHP)
end
	

return this