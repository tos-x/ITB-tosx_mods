-- 0 = orange, 1 = blue

ANIMS.tosx_loop_icon0 = Animation:new{
	Image = "effects/tosx_loop0.png",
	NumFrames = 8,
	Time = 0.08,
	PosX = -33,
	PosY = -14,
	Loop = true
}
ANIMS.tosx_loop_icon1 = ANIMS.tosx_loop_icon0:new{
	Image = "effects/tosx_loop1.png",
}
ANIMS.tosx_loop_icon2 = ANIMS.tosx_loop_icon0:new{
	Image = "effects/tosx_loop2.png",
}
	ANIMS.tosx_loop_icon0tip = ANIMS.tosx_loop_icon0:new{
		Loop = false,
		Frames = {0,1,2,3,4,5,6,7,0,1,2},
	}
	ANIMS.tosx_loop_icon1tip = ANIMS.tosx_loop_icon1:new{
		Loop = false,
		Frames = {0,1,2,3,4,5,6,7,0,1,2},
	}

ANIMS.tosx_loop_icon0a = ANIMS.tosx_loop_icon0:new{
	Image = "effects/tosx_loop0a.png",
	PosX = -17,
	PosY = 0,
}
ANIMS.tosx_loop_icon1a = ANIMS.tosx_loop_icon0:new{
	Image = "effects/tosx_loop1a.png",
	PosX = -17,
	PosY = 0,
}
ANIMS.tosx_loop_icon2a = ANIMS.tosx_loop_icon0:new{
	Image = "effects/tosx_loop2a.png",
	PosX = -17,
	PosY = 0,
}
	ANIMS.tosx_loop_icon1atip = ANIMS.tosx_loop_icon1a:new{
		Loop = false,
		Frames = {0,1,2,3,4,5,6,7,0,1,2},
	}

ANIMS.tosx_loop_icon_once0 = ANIMS.tosx_loop_icon0:new{
	Loop = false
}
ANIMS.tosx_loop_icon_once1 = ANIMS.tosx_loop_icon1:new{
	Loop = false
}
ANIMS.tosx_loop_icon_once2 = ANIMS.tosx_loop_icon2:new{
	Loop = false
}



ANIMS.tosx_summon_traveler = Animation:new{
	Image = "effects/tosx_summonrift.png",
	NumFrames = 19,
	Loop = false,
	PosX = -32,
	PosY = -145,
	Time = 0.02,
}



ANIMS.timespear1_0 = Animation:new{
	Image = "effects/time_spear1_U.png",
	NumFrames = 6,
	Time = 0.06,
	PosX = -18,
	PosY = -33
}
ANIMS.timespear2_0 = ANIMS.timespear1_0:new{ 	Image = "effects/time_spear2_U.png", }

ANIMS.timespear1_1 = ANIMS.timespear1_0:new{
	Image = "effects/time_spear1_R.png",
	PosX = -20,
	PosY = 0
}
ANIMS.timespear2_1 = ANIMS.timespear1_1:new{ 	Image = "effects/time_spear2_R.png", }

ANIMS.timespear1_2 = ANIMS.timespear1_0:new{
	Image = "effects/time_spear1_D.png",
	PosX = -70,
	PosY = 4
}
ANIMS.timespear2_2 = ANIMS.timespear1_2:new{ 	Image = "effects/time_spear2_D.png", }

ANIMS.timespear1_3 = ANIMS.timespear1_0:new{
	Image = "effects/time_spear1_L.png",
	PosX = -68,
	PosY = -32
}
ANIMS.timespear2_3 = ANIMS.timespear1_3:new{ 	Image = "effects/time_spear2_L.png", }





ANIMS.tosx_clockFF = Animation:new{
	Image = "effects/tosx_spinclock.png",
	PosX = -25,
	PosY = -5,
	Time = 0.04,
	NumFrames = 8,
	Frames = {0,0,0,1,1,2,3,4,5,6,7},
}
ANIMS.tosx_clockXX = ANIMS.tosx_clockFF:new{
	--Frames = {7,6,5,4,3,2,1,0},
	Frames = {7,6,5,4,3,2,1,1,0,0,0},
}