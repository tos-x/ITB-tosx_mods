local descriptiontext = "Adds powerful satellite weapons to the shop, which disappear after 1 use."

local mod = {
	id = "tosx_satweapons",
	name = "Satellite Weapons",
	version = "0.07",
	modApiVersion = "2.7.2",
	icon = "img/icons/mod_icon.png",
	description = descriptiontext,
}

local satweps = {
		"sat_archive",
		"sat_rst",
		"sat_pinnacle",
		"sat_detritus",
	}

function mod:init()
	local tips = require(self.scriptPath .."libs/tutorialTips")	
	tips:Add{
		id = "SatWeaponUse",
		title = "Satellite Weapons",
		text = "Satellites disappear permanently after use."
	}
	for _, satname in ipairs(satweps) do
		require(self.scriptPath .. satname)
	end
end

function mod:load(options, version)
end

return mod