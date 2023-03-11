
local mod = {
	id = "tosx_island_missons",
	name = "Island Missions",
	description = "Adds 8 new island-specific missions and 2 new generic missions.",
	version = "0.19",
	modApiVersion = "2.8.0",
	icon = "img/icons/mod_icon.png",
    dependencies = { modApiExt = "1.2" },
}

function mod:init()
	local scriptPath = self.scriptPath
	local resourcePath = self.resourcePath
		
	self.missions = require(scriptPath .."missions/init")
	self.missions:init(self)
	
end

function mod:load(options, version)
	local scriptPath = self.scriptPath
	self.missions:load(self, options, version)
	require(scriptPath .."libs/menu"):load()
	require(scriptPath .."libs/selected"):load()
	require(scriptPath .."libs/highlighted"):load()
end

return mod