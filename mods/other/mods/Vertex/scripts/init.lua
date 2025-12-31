local mod = {
	id = "tosx_vertex",
	name = "Vertex Conglomerate",
	version = "0.0.2",
	modApiVersion = "2.9.2",
	icon = "img/icon.png",
	requirements = {"tosx_island_missons"},
	description = "Adds a new island, Vertex Conglomerate.",
	dependencies = {
        modApiExt = "1.21",
        memedit = "1.0.4",
        easyEdit = "2.0.6",
    }
}

function mod:init()
	require(self.scriptPath.."terrainCrystalMtn")
		
	require(self.scriptPath.."island/island")
	require(self.scriptPath.."island/tileset")
	require(self.scriptPath.."island/ceo")
	require(self.scriptPath.."island/corporation")
	require(self.scriptPath.."island/pilot")	
	require(self.scriptPath.."island/enemyList")
	require(self.scriptPath.."island/bossList")
	require(self.scriptPath.."island/structures")
	require(self.scriptPath.."island/structureList")
	
	require(self.scriptPath.."island/waterfall")
	
	require(self.scriptPath.."island/island_composite")
	
	require(self.scriptPath.."missions/init")
	require(self.scriptPath.."island/missionList")
	
end

function mod:load(options, version)
end

return mod