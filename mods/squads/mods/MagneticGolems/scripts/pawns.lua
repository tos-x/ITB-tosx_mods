local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_MagnetMech = Pawn:new{
	Name = "Magnet Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_mag1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_MagnetFist"},
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_CatapultMech = Pawn:new{
	Name = "Catapult Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 3,
	Image = "tosx_mech_mag2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_MagnetSling"},
	SoundLocation = "/mech/brute/charge_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_FluxMech = Pawn:new{
	Name = "Flux Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_mag3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_FluxArtillery"},
	SoundLocation = "/mech/science/pulse_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}