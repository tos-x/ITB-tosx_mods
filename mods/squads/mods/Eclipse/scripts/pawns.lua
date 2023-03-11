local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

ECL_ReaperMech = Pawn:new{
	Name = "Reaper Mech",
	Class = "Prime",
	Health = 2,
	Image = "ecl_mech_reaper",
	ImageOffset = imageOffset,
	MoveSpeed = 4,
	SkillList = {"Ecl_Prime_Longrifle", "Ecl_Support_Autoloader"},
	SoundLocation = "/mech/brute/tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
ECL_ArchangelMech = Pawn:new{
	Name = "Archangel Mech",
	Class = "Ranged",
	Health = 3,
	Image = "ecl_mech_archangel",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"Ecl_Ranged_Orion"},
	Flying = true,
	SoundLocation = "/mech/flying/jet_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
ECL_ForceMech = Pawn:new{
	Name = "Force Mech",
	Class = "Science",
	Health = 3,
	Image = "ecl_mech_force",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"Ecl_Science_Gravpulse"},
	SoundLocation = "/mech/prime/rock_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}