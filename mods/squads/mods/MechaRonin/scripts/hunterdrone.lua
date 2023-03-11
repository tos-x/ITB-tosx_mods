local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

local this = {}

Ronin_DroneZ = Pawn:new{
	Name = "Pursuit Drone Launching",
	Health = 0,
	Neutral = true,
	MoveSpeed = 0,
	IsPortrait = false,
	Image = "PursuitDroneZ",
	ImageOffset = imageOffset,
	DefaultTeam = TEAM_PLAYER,
	Corpse = false,
	Flying = true,
	Pushable = false,
}

Ronin_Drone0 = Ronin_DroneZ:new{
	Name = "Pursuit Drone U",
	Image = "PursuitDroneU",
}
Ronin_Drone1 = Ronin_DroneZ:new{
	Name = "Pursuit Drone R",
	Image = "PursuitDroneR",
}
Ronin_Drone2 = Ronin_DroneZ:new{
	Name = "Pursuit Drone D",
	Image = "PursuitDroneD",
}
Ronin_Drone3 = Ronin_DroneZ:new{
	Name = "Pursuit Drone L",
	Image = "PursuitDroneL",
}

--Another set for p2 animations
Ronin_Drone_B0 = Ronin_DroneZ:new{
	Name = "Pursuit DroneB U",
	Image = "PursuitDrone2U",
}
Ronin_Drone_B1 = Ronin_DroneZ:new{
	Name = "Pursuit DroneB R",
	Image = "PursuitDrone2R",
}
Ronin_Drone_B2 = Ronin_DroneZ:new{
	Name = "Pursuit DroneB D",
	Image = "PursuitDrone2D",
}
Ronin_Drone_B3 = Ronin_DroneZ:new{
	Name = "Pursuit DroneB L",
	Image = "PursuitDrone2L",
}

function this:init(mod)
	local this = self
	
	modApi:appendAsset("img/units/player/hunter_drone_Z_death.png", mod.resourcePath .."img/units/player/hunter_drone_Z_death.png")
	modApi:appendAsset("img/units/player/hunter_drone_U_death.png", mod.resourcePath .."img/units/player/hunter_drone_U_death.png")
	modApi:appendAsset("img/units/player/hunter_drone_R_death.png", mod.resourcePath .."img/units/player/hunter_drone_R_death.png")
	modApi:appendAsset("img/units/player/hunter_drone_D_death.png", mod.resourcePath .."img/units/player/hunter_drone_D_death.png")
	modApi:appendAsset("img/units/player/hunter_drone_L_death.png", mod.resourcePath .."img/units/player/hunter_drone_L_death.png")
		
	setfenv(1, ANIMS)
	
	PursuitDroneZ =			MechUnit:new{}
	PursuitDroneZd =		PursuitDroneZ:new{ Image = "units/player/hunter_drone_Z_death.png", PosX = -30, PosY = -15, Loop = false, NumFrames = 7, Time = .06 }
	PursuitDroneU =			MechUnit:new{}
	PursuitDroneUd =		PursuitDroneU:new{ Image = "units/player/hunter_drone_U_death.png", PosX = -58, PosY = -33, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDroneR =			PursuitDroneU:new{}
	PursuitDroneRd =		PursuitDroneR:new{ Image = "units/player/hunter_drone_R_death.png", PosX = -58, PosY = -33, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDroneD =			PursuitDroneU:new{}
	PursuitDroneDd =		PursuitDroneD:new{ Image = "units/player/hunter_drone_D_death.png", PosX = -58, PosY = -33, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDroneL =			PursuitDroneU:new{}
	PursuitDroneLd =		PursuitDroneL:new{ Image = "units/player/hunter_drone_L_death.png", PosX = -58, PosY = -33, Loop = false, NumFrames = 12, Time = .025 }
	
	PursuitDrone2U =		MechUnit:new{}
	PursuitDrone2Ud =		PursuitDrone2U:new{ Image = "units/player/hunter_drone_U_death.png", PosX = -58+28, PosY = -33-21, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDrone2R =		PursuitDrone2U:new{}
	PursuitDrone2Rd =		PursuitDrone2R:new{ Image = "units/player/hunter_drone_R_death.png", PosX = -58+28, PosY = -33+21, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDrone2D =		PursuitDrone2U:new{}
	PursuitDrone2Dd =		PursuitDrone2D:new{ Image = "units/player/hunter_drone_D_death.png", PosX = -58-28, PosY = -33+21, Loop = false, NumFrames = 12, Time = .025 }
	PursuitDrone2L =		PursuitDrone2U:new{}
	PursuitDrone2Ld =		PursuitDrone2L:new{ Image = "units/player/hunter_drone_L_death.png", PosX = -58-28, PosY = -33-21, Loop = false, NumFrames = 12, Time = .025 }
end

function this:load()
	
end

return this