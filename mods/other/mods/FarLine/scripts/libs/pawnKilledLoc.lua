
-- Requires:
-- 	modApiExt v1.2

local VERSION = "0.0.4"
local EVENTS = {
	"onFinalSpace",
}

--Adapted from fossilizer Passive by Lemonymous, edited by Alcom Isst
local trackedPawns = {}
local trackedTeams = {}

--The game should not save while the board is busy, so using a local table should be fine.
--However, we should probably reset it when the data don't make sense anymore.

----------------------------------------------------------------
--Reset functions
----------------------------------------------------------------
--Reset tracked pawns
local function tosx_ResetTrackedPawns()
    trackedPawns = {}
    trackedTeams = {}
end

--Reset everything
local function tosx_ResetAll()
    tosx_ResetTrackedPawns()
end

----------------------------------------------------------------
--Tracking functions
----------------------------------------------------------------
--Track a pawn
local function tosx_TrackPawn(pawn)
    trackedPawns[pawn:GetId()] = pawn:GetSpace()    --Track this space
    trackedTeams[pawn:GetId()] = pawn:GetTeam()    --Track this pawn's team
end

----------------------------------------------------------------
--Action functions
----------------------------------------------------------------
--Event dispatch with final locaiton
local function tosx_AddDrown(mission)
    local pawnId, loc = next(trackedPawns)          --Get the first tracked pawn

    if pawnId then                                  --If the tracked pawn exists
        local team = trackedTeams[pawnId]
		PawnKilledLoc.onFinalSpace:dispatch(mission, pawnId, loc, team)
        trackedPawns[pawnId] = nil                  --We're done with this pawn, untrack it
        trackedTeams[pawnId] = nil                  --We're done with this pawn, untrack it
    end
end

--Track dying pawns to their new locations
local function tosx_TrackDying()
    for pawnId, loc in pairs(trackedPawns) do       --For every tracked pawn
        local pawn = Board:GetPawn(pawnId)          --Track the pawn's position
        
        if pawn then                                --if pawn still exists
            trackedPawns[pawnId] = pawn:GetSpace()  --update its tracked location.
        end
    end
end


local function onModsLoaded()
    modApi:addPreLoadGameHook(tosx_ResetAll)
    
    --On update, update the tracked pawn locations or both spawn a rock and clear tracked summons
    modApi:addMissionUpdateHook(function(mission)
        if Board:GetBusyState() == 0 then   --Wait for the board to unbusy
            tosx_AddDrown(mission)                  --Spawn a rock
        else                                --If the board is not busy 
            tosx_TrackDying()                  --Update the tracked positions for spawned
        end
    end)
    
    --When a pawn dies
    modapiext:addPawnKilledHook(function(mission, pawn)
        --Add it to the list of tracked pawns
        tosx_TrackPawn(pawn)
    end)
end

local function initEvents()
	for _, eventId in ipairs(EVENTS) do
		if PawnKilledLoc[eventId] == nil then
			PawnKilledLoc[eventId] = Event()
		end
	end
end

local function finalizeInit(self)
	modApi.events.onModsLoaded:subscribe(onModsLoaded)
    sdlext.addGameExitedHook(tosx_ResetAll)
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