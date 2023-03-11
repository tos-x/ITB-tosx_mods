local this = {}

function this:init(mod)
	local this = self
	modApi:appendAsset("img/units/player/tosx_carrier_drone.png", mod.resourcePath .."img/units/player/tosx_carrier_drone.png")
	modApi:appendAsset("img/units/player/tosx_carrier_dronea.png", mod.resourcePath .."img/units/player/tosx_carrier_dronea.png")
	modApi:appendAsset("img/units/player/tosx_carrier_droned.png", mod.resourcePath .."img/units/player/tosx_carrier_droned.png")
	modApi:appendAsset("img/units/player/tosx_carrier_dronens.png", mod.resourcePath .."img/units/player/tosx_carrier_dronens.png")
		Location["combat/icons/tosx_carrier_dronens.png"] = Point(-15,0)
	
	setfenv(1, ANIMS)	
	tosx_Fighter_img =			MechUnit:new{ Image = "units/player/tosx_carrier_drone.png", PosX = -15, PosY = 0 }
	tosx_Fighter_imga =			tosx_Fighter_img:new{ Image = "units/player/tosx_carrier_dronea.png", NumFrames = 4 }
	tosx_Fighter_img_ns =		MechIcon:new{ Image = "units/player/tosx_carrier_dronens.png" }
	tosx_Fighter_imgd =			tosx_Fighter_img:new{ Image = "units/player/tosx_carrier_droned.png", Loop = false, PosX = -17, Time = 0.075, NumFrames = 11 }
	
	
	
	
end

return this