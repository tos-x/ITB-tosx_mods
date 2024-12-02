local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Steam1Mech = Pawn:new{
    Name = "Winch Mech",
    Class = "Prime",
    Health = 3,
    MoveSpeed = 3,
    Image = "tosx_mech_steam1",
    ImageOffset = imageOffset,
    SkillList = {"tosx_Prime_SteamClaw"},
	SoundLocation = "/mech/prime/smoke_mech/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
    Massive = true,
}
tosx_Steam2Mech = Pawn:new{
    Name = "Steam Mech",
    Class = "Ranged",
    Health = 3,
    MoveSpeed = 3,
    Image = "tosx_mech_steam2",
    ImageOffset = imageOffset,
    SkillList = {"tosx_Ranged_Smoker"},
	SoundLocation = "/mech/distance/trimissile_mech/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
    Massive = true,
}
tosx_Steam3Mech = Pawn:new{
    Name = "Weather Mech",
    Class = "Science",
    Health = 3,
    MoveSpeed = 3,
    Image = "tosx_mech_steam3",
    ImageOffset = imageOffset,
    SkillList = {"tosx_Science_Smokeline" , "tosx_Passive_Smokeboost"},
	SoundLocation = "/mech/brute/needle_mech/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
    Massive = true,
    Flying = true,
}