local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_CarrierMech = Pawn:new{
	Name = "Carrier Mech",
	Class = "Prime",
	Health = 3,
	Image = "tosx_mech_carrier",
	ImageOffset = imageOffset,
	MoveSpeed = 2,
	SkillList = {"tosx_DeploySkill_Fighter"},
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}
tosx_GuardMech = Pawn:new{
	Name = "Guard Mech",
	Class = "Ranged",
	Health = 3,
	Image = "tosx_mech_guard",
	ImageOffset = imageOffset,
	MoveSpeed = 3,
	SkillList = {"tosx_Ranged_Shield"},
	SoundLocation = "/mech/brute/tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_QuakeMech = Pawn:new{
	Name = "Quake Mech",
	Class = "Science",
	Health = 2,
	Image = "tosx_mech_quake",
	ImageOffset = imageOffset,
	MoveSpeed = 4,
	SkillList = {"tosx_Science_Seismic"},
	SoundLocation = "/mech/distance/dstrike_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}