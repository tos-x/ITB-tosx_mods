ANIMS.tosx_windspin = Animation:new{
	Image = "effects/tosx_dustspin.png",
	NumFrames = 11,
	Time = 0.06,
	PosX = -35,
	PosY = -19,
}

tosx_Emitter_Windburst_0 = Emitter_Wind_0:new{   --up
	variance_x = 40,
	variance_y = 28,
	max_particles = 50,
	timer = 0.7,
	burst_count = 10,
	-- x= 0,
	-- y = 20,
}
tosx_Emitter_Windburst_1 = tosx_Emitter_Windburst_0:new{ x = -60, y = 0, angle = 40, }  --right
tosx_Emitter_Windburst_2 = tosx_Emitter_Windburst_0:new{ x = 60, y = 0, angle = 160, }  --down
tosx_Emitter_Windburst_3 = tosx_Emitter_Windburst_0:new{ x = 60, y = 40, angle = 220, }  --left