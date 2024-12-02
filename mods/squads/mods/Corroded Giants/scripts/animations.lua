
modApi:copyAsset(
	"img/combat/icons/icon_smoke_glow.png", 
	"img/combat/icons/vwt_icon_smoke_glow.png"
)
modApi:copyAsset(
	"img/combat/icons/icon_smoke_immune_glow.png", 
	"img/combat/icons/vwt_icon_smoke_immune_glow.png"
)
Location["combat/icons/vwt_icon_smoke_glow.png"] = Point(-10,8)
Location["combat/icons/vwt_icon_smoke_immune_glow.png"] = Point(-10,8)


modApi:createAnimations{
	vwt_smoke_move_0 = {
		Image = "effects/vwt_smoke_move_D.png",
		PosX = -51,
		PosY = -21,
		Time = 0.016,
		NumFrames = 14,
	},
}

modApi:createAnimations{
	vwt_smoke_move_1 = {
		Base = "vwt_smoke_move_0",
		Image = "effects/vwt_smoke_move_L.png",
	},
	vwt_smoke_move_2 = {
		Base = "vwt_smoke_move_0",
		Image = "effects/vwt_smoke_move_U.png",
	},
	vwt_smoke_move_3 = {
		Base = "vwt_smoke_move_0",
		Image = "effects/vwt_smoke_move_R.png",
	},
}
