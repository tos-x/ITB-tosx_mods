
local path = mod_loader.mods[modApi.currentMod].scriptPath
local customAnim = require(path .."libs/customAnim")


local this = {}

--[[
local pilot = {
	Id = "Pilot_Aloy",
	Personality = "Aloy",
	Name = "Aloy",
	Voice = "/voice/bethany",
	Sex = SEX_FEMALE,
	Skill = "AloySkill",
}
--]]

local function IsAbilityActive()
	if not Board then return false end
	local pawn = Board:GetSelectedPawn()
	return 
		pawn								and
		not pawn:IsDead()					and
		pawn:IsAbility("AloySkill")			and
		pawn:GetArmedWeaponId() > 0
end
-----------------------
--[[ Virtual functions that will treat virtual[point] as the overriding truth.
This way we know where pawns will be if they get pushed after moving/charging/teleporting
 virtual = -1 means that the skill has declared this point is being vacated
 virtual = id means that the skill has declared this point will have pawn [id] on it
 virtual = nil means treat point normally
--]]
local virtual = {}

local function vIsPawnSpace(point)
	index = p2idx (point) -- Can't use raw points for table indexes; they don't work properly
	if virtual[index] then
		if virtual[index] == -1 then return false end
		if virtual[index] then return true end
	end
	return Board:IsPawnSpace(point)
end

local function vGetPawn(point)
	index = p2idx (point)
	if virtual[index] then
		if virtual[index] ~= -1 then return Board:GetPawn(virtual[index]) end
	end
	return Board:GetPawn(point)
end

local function IterateEffects(effect)
	-- Create a record of pawns that won't be where they are now
	virtual = {}	
	for _, spaceDamage in ipairs(extract_table(effect)) do
		if spaceDamage:IsMovement() then
			local point = spaceDamage:MoveStart()
			local point2 = spaceDamage:MoveEnd()
			if vIsPawnSpace(point) then
				local id = Board:GetPawn(point):GetId()
				virtual[p2idx(point)] = -1 --Space is now empty
				virtual[p2idx(point2)] = id -- Pawn "id" is now here
			end
		end
	end

	for _, spaceDamage in ipairs(extract_table(effect)) do
		--if Board:IsPawnSpace(spaceDamage.loc) then
		if vIsPawnSpace(spaceDamage.loc) then
			--local pawn = Board:GetPawn(spaceDamage.loc)
			local pawn = vGetPawn(spaceDamage.loc)
			
			-- do the hunter mark ID check here			
			if pawn:GetTeam() == TEAM_ENEMY then
				if GAME.AloyFocus ~= nil then
					if pawn:GetId() == GAME.AloyFocus[pawn:GetId()] then
						if spaceDamage.iDamage > 0 then
							spaceDamage.iDamage = spaceDamage.iDamage + 1
						end
					end
				end
			end			
		end
	end
	return nil
end

local onSkillEffectFinal = function(pawn, skillEffect)
	if pawn and pawn:IsAbility("AloySkill") then
		IterateEffects(skillEffect.effect)	
	end
end
local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	if not skillEffect or not pawn then return end
	onSkillEffectFinal(pawn, skillEffect)
end
local onSkillEffect2 = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	if not skillEffect or not pawn then return end
	onSkillEffectFinal(pawn, skillEffect)
end

function this:init(mod)	
	self.id = mod.id .."_aloy_"
	
	--CreatePilot(pilot)
	
	local originalGetSkillInfo = GetSkillInfo
	function GetSkillInfo(skill)
		if skill == "AloySkill" then
			return PilotSkill("Analyze", "At the end of your turn, analyze enemies within 2 tiles. Mech deals extra damage to analyzed enemies.")
		end		
		return originalGetSkillInfo(skill)
	end
	
	local pilot_dialog = require(mod.scriptPath .."personality")
	local personality = CreatePilotPersonality("Aloy")
	personality:AddDialogTable(pilot_dialog)
	Personality["Aloy"] = personality
	
	modApi:appendAsset("img/portraits/pilots/Pilot_Aloy.png", mod.resourcePath .."img/portraits/pilots/Pilot_Aloy.png")
	modApi:appendAsset("img/portraits/pilots/Pilot_Aloy_2.png", mod.resourcePath .."img/portraits/pilots/Pilot_Aloy_2.png")
	modApi:appendAsset("img/portraits/pilots/Pilot_Aloy_blink.png", mod.resourcePath .."img/portraits/pilots/Pilot_Aloy_blink.png")
	
	modApi:appendAsset("img/effects/smoke/analysis_smoke.png", mod.resourcePath .."img/effects/smoke/analysis_smoke.png")
	modApi:appendAsset("img/combat/icons/aloy_focus_a.png",mod.resourcePath.."img/combat/icons/aloy_focus_a.png")

	Emitter_Pilot_Aloy = Emitter:new{
		image = "effects/smoke/analysis_smoke.png",
		fade_in = true,
		fade_out = true,
		max_alpha = 0.5,
		x = 0,
		y = 15,
		variance = 0,
		variance_x = 20,
		variance_y = 20,
		angle = -90,
		lifespan = 0.8,
		burst_count = 1,
		speed = 0.80,
		rot_speed = 0,
		gravity = false,
		birth_rate = 0.0001,
		layer = LAYER_FRONT,
		
		angle_variance = 0,
	}
	
	local animstart = false
	local stagedanims
	sdlext.addFrameDrawnHook(function(screen)
		local mission = GetCurrentMission()
		
		if IsAbilityActive() and not animstart then
			if not mission or not Board then return end
			
			stagedanims = {}
			local foepawns = extract_table(Board:GetPawns(TEAM_ENEMY))
			for i,id in pairs(foepawns) do
				pawn = Board:GetPawn(id)			
			
				-- do the hunter mark ID check here			
				if pawn:GetTeam() == TEAM_ENEMY then
					if GAME.AloyFocus ~= nil then
						if id == GAME.AloyFocus[id] then
							Board:AddBurst(Board:GetPawnSpace(id), "Emitter_Pilot_Aloy", DIR_NONE)
							stagedanims[#stagedanims + 1] = Board:GetPawnSpace(id)
							customAnim:add(Board:GetPawnSpace(id), "gaia_focus", desc)
						end
					end
				end
			end
			animstart = true
		elseif animstart and not IsAbilityActive() then
			if not mission or not Board then return end
			
			for i = 1, #stagedanims do
				local id = stagedanims[i]
				customAnim:rem(id, "gaia_focus")
			end
			animstart = false
			stagedanims = {}
		end
	end)
end

local function ResetAnalyzeVars()
	GAME.AloyFocus = {}
end

tosx_analyzeNew = function(mission)
	--LOG("tosx_analyzeNew")
	-- init or grab data
	GAME.AloyFocus = GAME.AloyFocus or {}
	local anybodythere = false
	
	-- These happen after 1) fire 2) psions but before 3) environment hazards
	if not mission.ZDFirstEnvironmentTurn and Game:GetTurnCount() > 0 then
		mission.ZDFirstEnvironmentTurn = true
		
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,AloySkillId in pairs(mechs) do
			if Board:GetPawn(AloySkillId):IsAbility("AloySkill") and not Board:GetPawn(AloySkillId):IsDead() then			
			
				local point1 = Board:GetPawnSpace(AloySkillId)
				local foes = extract_table(Board:GetPawns(TEAM_ENEMY))
				for i,id in pairs(foes) do		
					local point2 = Board:GetPawnSpace(id)
					local pawn = Board:GetPawn(id)
					
					if point1:Manhattan(point2) <= 2 then					
						if pawn:GetId() ~= GAME.AloyFocus[pawn:GetId()] then				
							GAME.AloyFocus[pawn:GetId()] = pawn:GetId()
							anybodythere = true
							
							local effect = SkillEffect()
							effect:AddScript(string.format([[
								local p = %s
								if Board:IsPawnSpace(p) then
									Board:Ping(p, GL_Color(%s, %s, %s))
								end]],
								point2:GetString(), 0, 190, 240
							))
							Board:AddEffect(effect)
						end
					end
				end
			
				if anybodythere == true then
					local effect = SkillEffect()
					effect:AddSound("/weapons/swap") --update!
					effect:AddScript("Board:AddAlert(Point("..point1:GetString().."),'ANALYZE')")
					--Trigger pilot dialogue
						effect:AddScript([[
							local cast = { main = ]]..AloySkillId..[[ }
							modapiext.dialog:triggerRuledDialog("Pilot_Skill_Aloy", cast)
						]])
					Board:AddEffect(effect)
				end
			
			end
		end
	end
end

function this:load()
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
	modApi:addPreEnvironmentHook(tosx_analyzeNew)
	modApi:addMissionStartHook(ResetAnalyzeVars)
	modApi:addMissionNextPhaseCreatedHook(ResetAnalyzeVars)
	
	modApi:addNextTurnHook(function(mission)
		mission.ZDFirstEnvironmentTurn = nil
	end)
end

return this