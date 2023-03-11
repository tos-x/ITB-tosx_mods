ANIMS.Gaia_NavPulse1 = Animation:new{
	Image = "effects/gaia_nav_explo1.png",
	NumFrames = 14,
	Time = .02,
	PosX = -71,
	PosY = -50,
	Frames = {1,2,3,4,9,10,10,10,10,10,11,11,12,12,13,13},
}
ANIMS.Gaia_NavPulse2 = ANIMS.Gaia_NavPulse1:new{
	Image = "effects/gaia_nav_explo2.png",
}
ANIMS.Gaia_NavPulse3 = ANIMS.Gaia_NavPulse1:new{
	Image = "effects/gaia_nav_explo3.png",
}

ANIMS.Gaia_NavRing1 = Animation:new{
	Image = "effects/gaia_nav_ring1.png",
	NumFrames = 5,
	Time = .06,
	PosX = -37,
	PosY = -7
}
ANIMS.Gaia_NavRing2 = ANIMS.Gaia_NavRing1:new{
	Image = "effects/gaia_nav_ring2.png",
}
ANIMS.Gaia_NavRing3 = ANIMS.Gaia_NavRing1:new{
	Image = "effects/gaia_nav_ring3.png",
}

ANIMS.Gaia_Confuse = Animation:new{
	Image = "combat/icons/stun_strip5.png",
	PosX = -8, PosY = -3,
	NumFrames = 5,
	Time = 0.1,
	Frames = {0,1,2,3,4,0,1},
}

Emitter_Gaia_ForceLoader = Emitter:new{
	image = "combat/tiles_grass/dust.png",
	x = 0,
	y = 25,
	max_alpha = .5,
	angle = -90,
	angle_variance = 0,
	variance_x = 40,
	variance_y = 20,
	lifespan = 0.4,
	burst_count = 2,
	birth_rate = 0.01,
	timer = 0.3,
	max_particles = 10,
	speed = 1,
	gravity = false,
	layer = LAYER_FRONT
}

ANIMS.Gaia_ForceRocks = Animation:new{
	Image = "effects/gaia_forceloader_float.png",
	NumFrames = 10,
	Time = .05,
	PosX = -28,
	PosY = -4,
}

ANIMS.gaia_zeta_iceblast_0 = Animation:new{
	Image = "effects/gaia_zeta_iceblast_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -20
}

ANIMS.gaia_zeta_iceblast_1 = ANIMS.gaia_zeta_iceblast_0:new{
	Image = "effects/gaia_zeta_iceblast_R.png",
	PosX = -20
}

ANIMS.gaia_zeta_iceblast_2 = ANIMS.gaia_zeta_iceblast_0:new{
	Image = "effects/gaia_zeta_iceblast_D.png",
	PosX = -20
}

ANIMS.gaia_zeta_iceblast_3 = ANIMS.gaia_zeta_iceblast_0:new{
	Image = "effects/gaia_zeta_iceblast_L.png",
	PosX = -20
}

ANIMS.gaia_focus = Animation:new{
	Image = "combat/icons/aloy_focus_a.png",
	--PosX = -28,
	--PosY = 10,
	PosX = -27,
	PosY = 2,
	Time = 0.15,
	Loop = true,
	NumFrames = 9,
	layer = LAYER_BACK,
}