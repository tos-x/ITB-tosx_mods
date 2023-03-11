local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

Ronin_BladeMech = Pawn:new{
	Name = "Blade Mech",
	Class = "Prime",
	Health = 3,
	Image = "ronin_mech_blade",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"Ronin_Prime_Katana"},
	SoundLocation = "/mech/brute/tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
Ronin_StealthMech = Pawn:new{
	Name = "Stealth Mech",
	Class = "Ranged",
	Health = 1,
	Image = "ronin_mech_stealth",
	ImageOffset = imageOffset,
	MoveSpeed = 2,
	SkillList = {"Ronin_Ranged_Warp"},
	SoundLocation = "/mech/flying/jet_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	--IgnoreFire = true,
}
Ronin_HunterMech = Pawn:new{
	Name = "Hunter Mech",
	Class = "Brute",
	Health = 2,
	Image = "ronin_mech_hunter",
	ImageOffset = imageOffset,
	MoveSpeed = 4,
	SkillList = {"Ronin_Brute_Pursuit"},
	SoundLocation = "/mech/prime/rock_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}