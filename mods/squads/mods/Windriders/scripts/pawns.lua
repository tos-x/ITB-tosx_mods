local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_AeroMech = Pawn:new{
	Name = "Aero Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_wind1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_AeroThrusters"},
	SoundLocation = "/mech/flying/jet_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}
tosx_WindMech = Pawn:new{
	Name = "Wind Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_wind2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_Microburst"},
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Flying = true,
	Massive = true,
}
tosx_HurricaneMech = Pawn:new{
	Name = "Hurricane Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_wind3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Cyclone"},
	SoundLocation = "/support/support_drone/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}