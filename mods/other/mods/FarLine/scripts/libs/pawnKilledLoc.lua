
-- Requires:
-- 	modApiExt v1.2
--  attackEvents.lua (Lemonymous libs)

local VERSION = "0.0.1"
local EVENTS = {
	"onFinalSpace",
}

local mod = modApi:getCurrentMod()
local path = mod.scriptPath
require(mod.scriptPath.."libs/attackEvents")

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

local function vIsBlocked(point)
	index = p2idx (point)
	if virtual[index] then
		if virtual[index] == -1 then return false end
		if virtual[index] then return true end
	end
	return Board:IsBlocked(point, PATH_PROJECTILE)
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
		local point1 = spaceDamage.loc
		if vIsPawnSpace(point1) then
			local pawn = vGetPawn(point1)
			if not pawn:IsGuarding() then
				if spaceDamage.iPush then
					if spaceDamage.iPush <= 3 then
						local point2 = spaceDamage.loc + DIR_VECTORS[(spaceDamage.iPush)]
						if not vIsBlocked(point2) and Board:IsValid(point2) then
							local id = pawn:GetId()
							virtual[p2idx(point1)] = -1 --Space is now empty
							virtual[p2idx(point2)] = id -- Pawn "id" is now here
						end
					end
				end
			end
		end
	end
	
	local pawnids = {}
	for x = 0,7 do
		for y = 0,7 do
			local p = Point(x,y)
			if vIsPawnSpace(p) then
				pawnids[vGetPawn(p):GetId()] = p2idx(p)
			end
		end
	end
	return pawnids
end		

local onSkillEffectFinal = function(skillEffect)
	if not skillEffect then return end
	local queued = not skillEffect.q_effect:empty()
	
	local pawnids = IterateEffects(skillEffect.effect)	
	if not queued and next(pawnids,nil) then
		for id, p in pairs(pawnids) do
			skillEffect:AddScript([[
				if PawnKilledLoc and PawnKilledLoc.Wait then
					local id = ]]..id..[[
					local p = ]]..p..[[
					if PawnKilledLoc.Wait[id] then 
						PawnKilledLoc.Wait[id]= p
					end
				end
				]])
		end
	else
		local pawnids = IterateEffects(skillEffect.q_effect)
		if next(pawnids,nil) then
			for id, p in pairs(pawnids) do
				skillEffect:AddQueuedScript([[
					if PawnKilledLoc and PawnKilledLoc.Wait then
						local id = ]]..id..[[
						local p = ]]..p..[[
						if PawnKilledLoc.Wait[id] then 
							PawnKilledLoc.Wait[id]= p
						end
					end
					]])
			end
		end
	end
end
local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	if not skillEffect then return end
	onSkillEffectFinal(skillEffect)
end
local onSkillEffect2 = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	if not skillEffect then return end
	onSkillEffectFinal(skillEffect)
end

local function effectStart()
	--LOG(" effectStart()")
	PawnKilledLoc.Wait = {}
	local pawns = extract_table(Board:GetPawns(TEAM_ANY))
	for i,id in pairs(pawns) do
		if Board:IsPawnAlive(id) then
			PawnKilledLoc.Wait[Board:GetPawn(id):GetId()] = p2idx(Board:GetPawnSpace(id))
		end
	end
end

local function effectEnd()
	--LOG(" effectEnd()")
	local mission = GetCurrentMission()
	if not PawnKilledLoc.Wait or not mission then return end
	for id, p in pairs(PawnKilledLoc.Wait) do
		if not Board:IsPawnAlive(id) then
			local point = idx2p(p)
			--LOG("dispatch ",id," p: ",point:GetString())
			if id and Board:IsValid(point) then
				PawnKilledLoc.onFinalSpace:dispatch(mission, id, point)
			end
		end
	end
	PawnKilledLoc.Wait = nil
end

local effectFlag = false
local function onBoardAddEffect(skillEffect)
	if not skillEffect then return end
	--LOG("board start")
	effectStart()
	onSkillEffectFinal(skillEffect)
	effectFlag = true
end

local function onAttackStart(mission, pawn, weaponId, p1, p2)
	--LOG("attack start")
	effectStart()
end
local function onAttackResolved(mission, pawn, weaponId, p1, p2)
	--LOG("attack done")
	effectEnd()
end

local function onMissionUpdate(mission)
	if Board:GetBusyState() == 0 and effectFlag then
		effectFlag = nil
		--LOG("board done")
		effectEnd()
	end
end

local function onModsLoaded()
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
	modApi:addMissionUpdateHook(onMissionUpdate)
end

local function initEvents()
	for _, eventId in ipairs(EVENTS) do
		if PawnKilledLoc[eventId] == nil then
			PawnKilledLoc[eventId] = Event()
		end
	end
end

local function finalizeInit(self)
	self.getCurrentAttackInfo = getCurrentAttackInfo

	modApi.events.onModsLoaded:subscribe(onModsLoaded)
	modApi.events.onBoardAddEffect:subscribe(onBoardAddEffect)
	AttackEvents.onAttackStart:subscribe(onAttackStart)
	AttackEvents.onAttackResolved:subscribe(onAttackResolved)
end

local function onModsInitialized()
	local isHighestVersion = true
		and PawnKilledLoc.initialized ~= true
		and PawnKilledLoc.version == VERSION

	if isHighestVersion then
		PawnKilledLoc:finalizeInit()
		PawnKilledLoc.initialized = true
	end
end


local isNewerVersion = false
	or PawnKilledLoc == nil
	or VERSION > PawnKilledLoc.version

if isNewerVersion then
	PawnKilledLoc = PawnKilledLoc or {}
	PawnKilledLoc.version = VERSION
	PawnKilledLoc.finalizeInit = finalizeInit

	modApi.events.onModsInitialized:subscribe(onModsInitialized)

	initEvents()
end

return PawnKilledLoc