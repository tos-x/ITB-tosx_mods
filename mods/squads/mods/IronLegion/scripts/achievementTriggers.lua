
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tosx_squadname = "Iron Legion"
local tosx_achvname = "tosx_legion_"

local this = {}

local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end


function this:load()

	modApi:addMissionStartHook(function(mission)
		mission.tosx_legion_sparecount = 0
	end)
	
	modapiext:addPawnPositionChangedHook(function(mission, pawn, oldPosition)
        if pawn:GetType() ~= "tosx_Deploy_Fighter" then return end
        if IsTipImage() then return end
		
		--LOG("pawn:GetSpace()="..pawn:GetSpace():GetString().." oldPosition="..oldPosition:GetString())
		if pawn:GetSpace() ~= oldPosition then
			if not mission.tosx_legion_fightermove then
				-- mission.tosx_legion_fightermove is blank; this is our first move
				mission.tosx_legion_fightermove = oldPosition
				--LOG("Left starting tile, which was "..mission.tosx_legion_fightermove:GetString())
			elseif mission.tosx_legion_fightermove == Point(-4,-4) then
				-- Just finished an UndoMoveHook that sent us back to our origin
				mission.tosx_legion_fightermove = nil
				--LOG("Just got back")
			end
		end
    end)	
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
        if pawn:GetType() ~= "tosx_Deploy_Fighter" then return end
		if mission.tosx_legion_fightermove then
			if mission.tosx_legion_fightermove == Point(-5,-5) then return end
			-- We have moved
			if pawn:GetSpace() == mission.tosx_legion_fightermove then
				--LOG("Back to starting tile")
				mission.tosx_legion_fightermove = Point(-4,-4)
			end
		end
	end)
	
	modapiext:addPawnKilledHook(function(mission, pawn)
        if IsTipImage() then return end
        if pawn:GetType() == "tosx_Deploy_Fighter" then
			if not mission.tosx_legion_sparecount then mission.tosx_legion_sparecount = 0 end
			mission.tosx_legion_sparecount = mission.tosx_legion_sparecount + 1
		end
	end)
	
	modApi:addMissionEndHook(function(mission)		
        if not mission.tosx_legion_fightermove then
			tosx_legionsquad_Chievo("tosx_legion_placement")
		end
		
		if mission.tosx_legion_sparecount == 0 then
			tosx_legionsquad_Chievo("tosx_legion_spares")
		end
		mission.tosx_legion_fightermove = nil
		mission.tosx_legion_sparecount = nil
	end)
end

return this