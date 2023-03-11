local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_SurgeMech = Pawn:new{
	Name = "Surge Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_surge",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_DowsingCharge"},
	SoundLocation = "/enemy/snowtank_2/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_HydroMech = Pawn:new{
	Name = "Hydro Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_hydro",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_HydroCannon"},
	SoundLocation = "/mech/prime/rock_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_CargoMech = Pawn:new{
	Name = "Cargo Mech",
	Class = "Science",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_cargo",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Science_CargoBay"},
	SoundLocation = "/support/support_drone/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}