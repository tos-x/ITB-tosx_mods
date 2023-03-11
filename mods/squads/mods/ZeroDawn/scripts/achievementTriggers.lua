
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tosx_squadname = "Zero Dawn"
local tosx_achvname = "gaia_"
local modid = "tosx_ZeroDawn" -- Also the squad id

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local this = {}


function this:load()	
	modApi:addMissionStartHook(function(mission)
		if GAME and GAME.additionalSquadData.squad ~= modid then return end
        mission.gaia_still = Point(-3,-3)		
	end)
	
	--NEED TO BYPASS ON DEPLOYMENT
	modApi:addNextTurnHook(function(mission)
	if mission.gaia_still then
		--LOG(mission.gaia_still:GetString())
		if mission.gaia_still == Point(-3,-3) then
			mission.gaia_still = nil
		else
			mission.gaia_still = Point(-5,-5)
		end
	end
	end)
	
	-- gaia_still
	modapiext:addPawnPositionChangedHook(function(mission, pawn, oldPosition)
		if GAME and GAME.additionalSquadData.squad ~= modid then return end
        if pawn:GetType() ~= "ZeroDawn_TallMech" then return end
        if IsTipImage() then return end
		
		--LOG("pawn:GetSpace()="..pawn:GetSpace():GetString().." oldPosition="..oldPosition:GetString())
		if pawn:GetSpace() ~= oldPosition then
			if not mission.gaia_still then
				-- mission.gaia_still is blank; this is our first move
				mission.gaia_still = oldPosition
				--LOG("Left starting tile, which was "..mission.gaia_still:GetString())
			elseif mission.gaia_still == Point(-4,-4) then
				-- Just finished an UndoMoveHook that sent us back to our origin
				mission.gaia_still = nil
				--LOG("Just got back")
			end
		end
    end)	
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		if GAME and GAME.additionalSquadData.squad ~= modid then return end
        if pawn:GetType() ~= "ZeroDawn_TallMech" then return end
		if mission.gaia_still then
			if mission.gaia_still == Point(-5,-5) then return end
			-- We have moved
			if pawn:GetSpace() == mission.gaia_still then
				--LOG("Back to starting tile")
				mission.gaia_still = Point(-4,-4)
			end
		end	
	end)
	
	modApi:addMissionEndHook(function(mission)
		if GAME and GAME.additionalSquadData.squad ~= modid then return end
		if Board:GetPawn(2):IsDead() then return end
        if not mission.gaia_still then
			gaiasquad_Chievo("gaia_still")
		end
	end)
end

return this