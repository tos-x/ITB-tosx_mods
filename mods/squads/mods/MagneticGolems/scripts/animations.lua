
ANIMS.tosx_magnetic_icon = Animation:new{
	Image = "combat/icons/tosx_polarity1_icon_glow.png",
	PosX = -28,
	PosY = 10,
	Time = 0.15,
	Loop = true,
	NumFrames = 4,
}
ANIMS.tosx_magnetic_iconTip = ANIMS.tosx_magnetic_icon:new{
	Loop = false,
	Frames = {0,1,2,3,0,1,},
}
ANIMS.tosx_fakepush_square = Animation:new{
	Image = "combat/tosx_push_square.png",
	PosX = -28,
	PosY = 1,
	Time = 1,
	Loop = true,
	NumFrames = 1,
	Layer = LAYER_FLOOR,
}



ANIMS.tosx_fakepush_0 = Animation:new{
	Image = "combat/arrow_up.png",
	PosX = -10,
	PosY = -10,
	Time = 1,
	Loop = true,
	NumFrames = 1,
	Layer = LAYER_SKY,
}
ANIMS.tosx_fakepush_1 = ANIMS.tosx_fakepush_0:new{
	Image = "combat/arrow_right.png",
	PosX = -10,
	PosY = 15,
}
ANIMS.tosx_fakepush_2 = ANIMS.tosx_fakepush_0:new{
	Image = "combat/arrow_down.png",
	PosX = -45,
	PosY = 15,
}
ANIMS.tosx_fakepush_3 = ANIMS.tosx_fakepush_0:new{
	Image = "combat/arrow_left.png",
	PosX = -45,
	PosY = -10,
}

ANIMS.tosx_fakepushC_0 = ANIMS.tosx_fakepush_0:new{
	Image = "combat/arrow_hit_up.png",
}
ANIMS.tosx_fakepushC_1 = ANIMS.tosx_fakepush_1:new{
	Image = "combat/arrow_hit_right.png",
}
ANIMS.tosx_fakepushC_2 = ANIMS.tosx_fakepush_2:new{
	Image = "combat/arrow_hit_down.png",
}
ANIMS.tosx_fakepushC_3 = ANIMS.tosx_fakepush_3:new{
	Image = "combat/arrow_hit_left.png",
}



ANIMS.tosx_magflare = Animation:new{
	Image = "effects/tosx_magflare1.png",
	PosX = -42,
	PosY = -8,
	Time = 0.03,
	NumFrames = 9,
}

ANIMS.tosx_magpush_0 = Animation:new{
	Image = "effects/tosx_magpush_U.png",
	PosX = -42,
	PosY = -8,
	Time = 0.03,
	NumFrames = 8,
}
ANIMS.tosx_magpush_1 = ANIMS.tosx_magpush_0:new{
	Image = "effects/tosx_magpush_R.png",
}
ANIMS.tosx_magpush_2 = ANIMS.tosx_magpush_0:new{
	Image = "effects/tosx_magpush_D.png",
}
ANIMS.tosx_magpush_3 = ANIMS.tosx_magpush_0:new{
	Image = "effects/tosx_magpush_L.png",
}