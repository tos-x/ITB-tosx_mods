ANIMS.GravBlast1 = Animation:new{
	Image = "effects/explo_gravpulse1.png",
	NumFrames = 8,
	Time = 0.05,
	PosX = -33,
	PosY = -14
}

ANIMS.AmmoDrop1 = Animation:new{
	Image = "effects/misc_ammo1.png",
	NumFrames = 7,
	Time = 0.04,
	PosX = -33,
	PosY = -7
}

ANIMS.tosx_firesymbol = Animation:new{
	Image = "combat/icons/icon_fire_glow.png",
	PosX = -28,
	PosY = 10,
	Time = 1,
	Loop = true,
	NumFrames = 1,
}

ANIMS.tosx_firesymbol2 = ANIMS.tosx_firesymbol:new{
	Image = "combat/icons/icon_fire_immune_glow.png"
}

ANIMS.tosx_explo_shield = Animation:new{
	Image = "effects/explo_pulse_shield.png",
	NumFrames = 8,
	Time = 0.075,
	PosX = -40,
	PosY = -20
}


ANIMS.tosx_explo_quakeA_0 = Animation:new{
	Image = "effects/explo_quake_R.png",--URDL
	NumFrames = 13,
	Time = 0.05,
	PosX = -27,
	PosY = 5,
}
ANIMS.tosx_explo_quakeB_0 = ANIMS.tosx_explo_quakeA_0:new{
	PosX = -6,
	PosY = -4,
}
--[[
ANIMS.tosx_explo_quakeA_2 = ANIMS.tosx_explo_quakeA_0:new{
	Image = "effects/explo_quake_L.png",
	PosX = -39,
	PosY = -5,
}
ANIMS.tosx_explo_quakeB_2 = ANIMS.tosx_explo_quakeA_2:new{
	PosX = -18,
	PosY = -14,
}--]]