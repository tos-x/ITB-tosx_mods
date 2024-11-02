local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Stalker1Mech = Pawn:new{
	Name = "Arc Mech",
	Class = "Prime",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_stalkers1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Boomerang"},
	SoundLocation = "/mech/distance/scorpio_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Stalker2Mech = Pawn:new{
	Name = "Pincer Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_stalkers2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_Pincer"},
	SoundLocation = "/mech/distance/bombling_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Armor = true,
}
tosx_Stalker3Mech = Pawn:new{
	Name = "Trap Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 3,
	Image = "tosx_mech_stalkers3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Trap"},
	SoundLocation = "/mech/brute/needle_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Flying = true,
	Massive = true,
}