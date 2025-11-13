local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Gunner1Mech = Pawn:new{
	Name = "Axe Mech",
	Class = "Prime",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_gunner1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Axes"},
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Gunner2Mech = Pawn:new{
	Name = "Gunner Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_gunner2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_Machinegun"},
	SoundLocation = "/mech/science/napalm_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Gunner3Mech = Pawn:new{
	Name = "Line Mech",
	Class = "Science",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_gunner3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Science_LineShift"},
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}