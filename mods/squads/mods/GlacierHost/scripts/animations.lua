ANIMS.tosx_iceblast_0 = Animation:new{
	Image = "effects/tosx_iceblast_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -20
}

ANIMS.tosx_iceblast_1 = ANIMS.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_R.png",
	PosX = -20
}

ANIMS.tosx_iceblast_2 = ANIMS.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_D.png",
	PosX = -20
}

ANIMS.tosx_iceblast_3 = ANIMS.tosx_iceblast_0:new{
	Image = "effects/tosx_iceblast_L.png",
	PosX = -20
}

ANIMS.tosx_icerock1 = 	ANIMS.BaseUnit:new{ Image = "units/aliens/tosx_icerock_1.png", PosX = -18, PosY = -1 }
ANIMS.tosx_icerock1d = 	ANIMS.tosx_icerock1:new{ Image = "units/aliens/tosx_icerock_1_death.png", PosX = -34, PosY = -9, NumFrames = 13, Time = 0.09, Loop = false }
ANIMS.tosx_icerock1e = 	ANIMS.tosx_icerock1:new{ Image = "units/aliens/tosx_icerock_1_emerge.png", PosX = -23, PosY = 2, NumFrames = 6, Time = 0.07, Loop = false }

ANIMS.tosx_icerocker_0 = Animation:new{
	Image = "effects/tosx_icerocker_U.png",
	NumFrames = 11,
	Lengths = {0.06,0.06,0.06,0.06,1.0,0.06,0.06,0.06,0.06,0.06,0.06},
	PosX = -20,
	PosY = 8
}

ANIMS.tosx_icerocker_1 = ANIMS.tosx_icerocker_0:new{
	Image = "effects/tosx_icerocker_R.png",
	PosX = -23,
	PosY = -2
}

ANIMS.tosx_icerocker_2 = ANIMS.tosx_icerocker_0:new{
	Image = "effects/tosx_icerocker_D.png",
	PosX = -16,
	PosY = -3
}

ANIMS.tosx_icerocker_3 = ANIMS.tosx_icerocker_0:new{
	Image = "effects/tosx_icerocker_L.png",
	PosX = -16,
	PosY = 11
}