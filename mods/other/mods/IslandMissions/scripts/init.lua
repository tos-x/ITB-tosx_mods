
local mod = {
	id = "tosx_island_missons",
	name = "Island Missions",
	description = "Adds 8 new island-specific missions and 2 new generic missions.",
	version = "0.23",
	modApiVersion = "2.9.2",
	icon = "img/icons/mod_icon.png",
    dependencies = {
        modApiExt = "1.21",
        easyEdit = "2.0.6",
	},
}

function mod:init()
	local scriptPath = self.scriptPath
	local resourcePath = self.resourcePath
		
	self.missions = require(scriptPath .."missions/init")
	self.missions:init(self)
	
	-- Add icons for easyEdit
	modApi:appendAssets("img/strategy/mission/", "img/missions/", "")
	modApi:appendAssets("img/strategy/mission/small/", "img/missions/small/", "")
	require(scriptPath .."missionList")
	
end

function mod:load(options, version)
	local scriptPath = self.scriptPath
	self.missions:load(self, options, version)
end

return mod