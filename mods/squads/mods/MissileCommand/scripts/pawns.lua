local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Missile1Mech = Pawn:new{
	Name = "Ballistic Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_missile1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Ballistic"},
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Missile2Mech = Pawn:new{
	Name = "Standoff Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 3,
	Image = "tosx_mech_missile2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_Standoff"},
	SoundLocation = "/support/vip_truck/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Missile3Mech = Pawn:new{
	Name = "Barrage Mech",
	Class = "Ranged",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_missile3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_PointDef"},
	SoundLocation = "/mech/distance/artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}