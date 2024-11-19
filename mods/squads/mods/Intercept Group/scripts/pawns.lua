local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Burn1Mech = Pawn:new{
	Name = "Beam Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_burn1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_ThermalLance"},
	SoundLocation = "/mech/prime/inferno_mech/",
	SoundLocation = "/mech/brute/doubletank_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Burn2Mech = Pawn:new{
	Name = "Cycle Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_burn2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Brute_Shockwave"},
	SoundLocation = "/mech/brute/bulk_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Burn3Mech = Pawn:new{
	Name = "Bunker Mech",
	Class = "Ranged",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_burn3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Concussion"},
	SoundLocation = "/mech/science/exchange_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}