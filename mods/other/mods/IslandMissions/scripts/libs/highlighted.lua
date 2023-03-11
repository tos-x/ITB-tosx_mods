
---------------------------------------------------------------------
-- Highlighted v1.1* - code library
--[[-----------------------------------------------------------------
	*modified for hotseat
]]
local this = {}

sdlext.addGameExitedHook(function()
	this.highlighted = nil
end)

function this:Get()
	return self.highlighted
end

function this:load()
	modapiext:addTileHighlightedHook(function(_, tile)
		self.highlighted = tile
	end)
	
	modapiext:addTileUnhighlightedHook(function()
		self.highlighted = nil
	end)
end

return this