local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

ZeroDawn_ThunderMech = Pawn:new{
	Name = "Thunder Mech",
	Class = "Prime",
	Health = 3,
	Image = "gaia_mech_thunder",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"ZeroDawn_Prime_ZetaCannon"},
	SoundLocation = "/mech/science/napalm_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
ZeroDawn_EarthMech = Pawn:new{
	Name = "Earth Mech",
	Class = "Brute",
	Health = 3,
	Image = "gaia_mech_earth",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"ZeroDawn_Brute_ForceLoader"},
	SoundLocation = "/mech/prime/smoke_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
ZeroDawn_TallMech = Pawn:new{
	Name = "Tall Mech",
	Class = "Science",
	Health = 4,
	Image = "gaia_mech_tall",
	ImageOffset = imageOffset,
	MoveSpeed = 1,
	SkillList = {"ZeroDawn_Science_NavRelay"},
	SoundLocation = "mech/distance/trimissile_mech",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Armor = true,
	LargeShield = true,
}