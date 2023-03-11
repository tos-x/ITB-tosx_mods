local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_LancerMech = Pawn:new{
	Name = "Lancer Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_time1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_TimeLance"},
	SoundLocation = "/enemy/snowtank_1/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_TimestopperMech = Pawn:new{
	Name = "Oblivion Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_time2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Stasis"},
	SoundLocation = "/enemy/snowart_1/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_TravelerMech = Pawn:new{
	Name = "Traveler Mech",
	Class = "Science",
	Health = 2,
	MoveSpeed = 3,
	Image = "tosx_mech_time3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Science_TimeClock" , "tosx_Science_TimeTear"},
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}