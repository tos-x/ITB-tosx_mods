local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_BlizzardMech = Pawn:new{
	Name = "Blizzard Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_glacier1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Cryoburst"},
	SoundLocation = "/mech/prime/bottlecap_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_WallMech = Pawn:new{
	Name = "Wall Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_glacier2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_WallIce"},
	SoundLocation = "/mech/prime/rock_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_ScatterMech = Pawn:new{
	Name = "Scatter Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 3,
	Image = "tosx_mech_glacier3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Dispersal"},
	SoundLocation = "/mech/science/fourway_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}

tosx_IceWall = 
	{
		Name = "Ice Block",
		Health = 1,
		Neutral = true,
		TempUnit = true,
		MoveSpeed = 0,
		IsPortrait = false,
		Image = "tosx_icerock1",
		SoundLocation = "/support/rock/",
		DefaultTeam = TEAM_NONE,
		ImpactMaterial = IMPACT_ROCK
	}
AddPawn("tosx_IceWall") 