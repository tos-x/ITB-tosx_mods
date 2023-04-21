local mod = {
	id = "CauldronPilots",
	name = "Cauldron Pilots",
	version = "1.35",
	modApiVersion = "2.8.0",
	icon = "img/icons/mod_icon.png",
	description = "New pilots with unique abilities.",
	dependencies = {
        modApiExt = "1.2",
        memedit = "0.1.0",
    }
}

local function getModOptions(mod)
    return mod_loader:getModConfig()[mod.id].options
end

local function getOption(options, name, defaultVal)
	if options and options[name] then
		return options[name].enabled
	end
	if defaultVal then return defaultVal end
	return true
end

local pilotnames = {
	["Pilot_Cricket"] = "Kate Shreeve",
	["Pilot_Vanish"] = "Janet Walker",
	["Pilot_Drift"] = "Alain Mormont",
	["Pilot_Mara"] = "Marika Prochazka",
	["Pilot_Cypher"] = "Karl Schraeder",
	["Pilot_Titan"] = "Roland White",
	["Pilot_Quicksilver"] = "Amelia Espada",
	["Pilot_Gyrosaur"] = "Athena",
	["Pilot_Terminus"] = "Daiyu Tang",
	["Pilot_Knight"] = "George Mormoth",
	["Pilot_Low"] = "Sen",
	["Pilot_Gray"] = "Ezekiel Gray",
	["Pilot_Stranger"] = "Stranger",
	["Pilot_Echelon"] = "Esther Martin",
	["Pilot_Starlight"] = "Andromeda McLear",
	["Pilot_Necro"] = "Simon Coil",
	["Pilot_Impact"] = "Jai Chandra",
	["Pilot_Tango"] = "Julia Takahashi",
	["Pilot_Baccarat"] = "Earl Deckard",
	["Pilot_Doc"] = "Mark Savage",
	["Pilot_Gargoyle"] = "Gargoyle",
	["Pilot_AZ"] = "Ryan Frost",
	["Pilot_Malichae"] = "Alec Shaheen",
	}

function mod:metadata()	
	modApi:addGenerationOption(
		"enable_pilot_traits", "Use Trait Icons",
		"Adds trait icons for some pilot abilities. May conflict with other mods that use custom trait icons.",
		{enabled = true}
	)
	
	for id, name in pairs(pilotnames) do
		modApi:addGenerationOption(
			"enable_" .. string.lower(id), "Pilot: "..name,
			"Enable this pilot.",
			{enabled = true}
		)
    end
end

function mod:init()
	require(mod.scriptPath .."libs/pilotSkill_move")
	require(self.scriptPath.."personalities/personalities")
	local suppressDialog = require(self.scriptPath.."libs/suppressDialog")
	function SuppressDialog(duration,event)
		suppressDialog:AddEvent(event)

		if duration and duration >= 0 then
			modApi:scheduleHook(duration, function()
				UnsuppressDialog(event)
			end)
		end
	end
	function UnsuppressDialog(event)
		suppressDialog:RemEvent(event)
	end
	
	CaulP_repairApi = require(self.scriptPath.. "ReplaceRepair/api")
	CaulP_repairApi:init(self)
	
	dialogs = require(self.scriptPath .."libs/dialogs")
	
	local options = getModOptions(mod)	
	for id, name in pairs(pilotnames) do
		if getOption(options, "enable_"..string.lower(id)) then
			modApi:appendAsset("img/portraits/pilots/"..id..".png",self.resourcePath.."img/portraits/pilots/"..id..".png")
			modApi:appendAsset("img/portraits/pilots/"..id.."_2.png",self.resourcePath.."img/portraits/pilots/"..id.."_2.png")
			modApi:appendAsset("img/portraits/pilots/"..id.."_blink.png",self.resourcePath.."img/portraits/pilots/"..id.."_blink.png")
			
			self[id] = require(self.scriptPath .. string.lower(id))
			self[id]:init(self)
		end
	end	
	
	if getOption(options, "enable_pilot_traits") then
		require(self.scriptPath.."addTraits")	
	end
end

function mod:load(options, version)
	CaulP_repairApi:load(self, options, version)
	dialogs.load()

	local options = getModOptions(mod)	
	for id, name in pairs(pilotnames) do
		if getOption(options, "enable_"..string.lower(id)) then
			self[id]:load()
		end
	end
	
	if getOption(options, "enable_pilot_traits") then
		require(self.scriptPath.."addTraits")
	end
end

return mod
