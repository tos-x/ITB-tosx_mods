
local VERSION = "0.0.2"

local function SkillBuild(mission, pawn, weaponId, p1, p2, skillEffect)
	if not skillEffect or not pawn then return end
	if not skillEffect.q_effect:empty() and pawn:IsBoosted() and not pawn:IsMutation(LEADER_BOOSTED) then
		skillEffect:AddScript([[
			local e = SkillEffect()
			e:AddScript("Board:GetPawn(]]..pawn:GetId()..[[):SetBoosted(true)")
			e:AddScript("Board:DamageSpace(Point(0,0),0)")
			Board:AddEffect(e)
			]])
			--Need to force the attack numeral to update; hence Board:DamageSpace
	end
end

local function QueuedSkillStart(mission, pawn, weaponId, p1, p2)
	if not pawn then return end
	if not pawn:IsMutation(LEADER_BOOSTED) then
		pawn:SetBoosted(false)
	end
end

local function onModsLoaded()
	modapiext:addSkillBuildHook(SkillBuild)
	modapiext:addQueuedSkillStartHook(QueuedSkillStart)
end


local function finalizeInit(self)
	modApi.events.onModsLoaded:subscribe(onModsLoaded)
end

local function onModsInitialized()
	local isHighestVersion = true
		and QueuedBoost.initialized ~= true
		and QueuedBoost.version == VERSION

	if isHighestVersion then
		QueuedBoost:finalizeInit()
		QueuedBoost.initialized = true
	end
end


local isNewerVersion = false
	or QueuedBoost == nil
	or VERSION > QueuedBoost.version

if isNewerVersion then
	QueuedBoost = QueuedBoost or {}
	QueuedBoost.version = VERSION
	QueuedBoost.finalizeInit = finalizeInit

	modApi.events.onModsInitialized:subscribe(onModsInitialized)
end

return QueuedBoost