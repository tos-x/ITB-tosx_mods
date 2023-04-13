
--------------------------------------
-- Suppress Dialog - code library
--------------------------------------
-- provides functions for suppressing
-- dialog events
--------------------------------------
--------------------------------------

-----------------------------------------------------------------------
-- loading:
--[[-------------------------------------------------------------------
	
	-- you can request it anytime in init or load with:
	local suppressDialog = require(self.scriptPath .."suppressDialog")
	
]]---------------------------------------------------------------------

------------------
-- function list:
------------------

--------------------------------------------------
-- suppressDialog:AddEvent(eventId)
--[[----------------------------------------------
	suppresses a dialog event until unsuppressed.
	
	example:
	
	suppressDialog:AddEvent("PilotDeath")
	
--]]----------------------------------------------

------------------------------------------
-- suppressDialog:RemEvent(eventId)
--[[--------------------------------------
	unsuppresses a dialog event.
	
	example:
	
	suppressDialog:RemEvent("PilotDeath")
	
--]]--------------------------------------

--------------------------------------------------
-- suppressDialog:AddPawnEvent(pawnId, eventId)
--[[----------------------------------------------
	suppresses a dialog event initiated by pawnId
	until unsuppressed.
	
	example:
	
	suppressDialog:AddPawnEvent(0, "PilotDeath")
	
--]]----------------------------------------------

----------------------------------------------------
-- suppressDialog:RemPawnEvent(pawnId, eventId)
--[[------------------------------------------------
	unsuppresses a dialog event initiated by pawnId
	
	example:
	
	suppressDialog:RemPawnEvent(0, "PilotDeath")
	
--]]------------------------------------------------

local this = {
	events = {},
	pawns = {}
}

function this:AddEvent(eventId)
	--LOG("Supress "..eventId)
	self.events[eventId] = true
end

function this:RemEvent(eventId)
	--LOG("Remove "..eventId)
	self.events[eventId] = nil
end

function this:AddPawnEvent(pawnId, eventId)
	self.pawns[pawnId] = self.pawns[pawnId] or {}
	self.pawns[pawnId][eventId] = true
end

function this:RemPawnEvent(pawnId, eventId)
	self.pawns[pawnId] = self.pawns[pawnId] or {}
	self.pawns[pawnId][eventId] = nil
end

local oldTriggerVoiceEvent = TriggerVoiceEvent
function TriggerVoiceEvent(event, ...)
	
	if this.events[event.id] then
		
		return -- suppress dialog
	end
	
	if
		event.pawn1 >= 0					and
		this.pawns[event.pawn1]				and
		this.pawns[event.pawn1][event.id]
	then
		return -- suppress dialog
	end
	
	oldTriggerVoiceEvent(event, ...)
end

return this