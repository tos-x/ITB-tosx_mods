
local this = {
	corp = "Archive",
	amphibious = {},
	move = {},
}

local function IsAmphibious(pawn)
	if not pawn then return false end
	local v = _G[pawn:GetType()]
	return	v.tosx_trait_swimming	and
			v.Flying					and
			not pawn:IsAbility("Flying")
end

local original_GetStatusTooltip = GetStatusTooltip
function GetStatusTooltip(id)
	if	id == "flying"		and
		IsAmphibious(Pawn)	then
		
		return {"Swimming", "Swimming units can only move on Water."}
	end
	return original_GetStatusTooltip(id)
end

function this:init(mod)
	self.SwimmingIcon = require(mod.scriptPath .."SwimmingIcon")
	self.SwimmingIcon:init(mod)
end

return this