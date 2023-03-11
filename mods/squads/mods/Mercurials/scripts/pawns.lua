local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Mercury1Mech = Pawn:new{
	Name = "Alloy Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_mercury1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Tendrils"},
	SoundLocation = "/mech/science/fourway_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Mercury2Mech = Pawn:new{
	Name = "Needle Mech",
	Class = "Ranged",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_mercury2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Needle"},
	SoundLocation = "/mech/science/exchange_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}
tosx_Mercury3Mech = Pawn:new{
	Name = "Split Mech",
	Class = "Science",
	Health = 3,
	MoveSpeed = 3,
	Image = "tosx_mech_mercury3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Science_Splitter"},
	SoundLocation = "/mech/science/superman_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Flying = true,
	Massive = true,
}



modApi:appendAsset("img/units/mission/tosx_husk.png", mod.resourcePath .."img/units/player/tosx_husk.png")
modApi:appendAsset("img/units/mission/tosx_husk_a.png", mod.resourcePath .."img/units/player/tosx_husk_a.png")
modApi:appendAsset("img/units/mission/tosx_husk_d.png", mod.resourcePath .."img/units/player/tosx_husk_d.png")
modApi:appendAsset("img/units/mission/tosx_husk_ns.png", mod.resourcePath .."img/units/player/tosx_husk_ns.png")

local a = ANIMS
a.tosx_husk = a.BaseUnit:new{Image = "units/mission/tosx_husk.png", PosX = -30, PosY = -16}
a.tosx_huska = a.tosx_husk:new{Image = "units/mission/tosx_husk_a.png", PosX = -20, PosY = -5, NumFrames = 2, Time = 0.65}
a.tosx_huskd = a.tosx_huska:new{Image = "units/mission/tosx_husk_d.png", NumFrames = 9, Time = 0.12, Loop = false }
a.tosx_huske = a.tosx_huskd:new{Frames = {8,7,6,5,4,3,2,1,0}, Time = 0.05}
a.tosx_husk_ns = a.tosx_husk:new{Image = "units/mission/tosx_husk_ns.png", PosX = -17, PosY = -3}
	
tosx_Husk1 = Pawn:new{
	Name = "Husk",
	Health = 1,
	MoveSpeed = 3,
	Image = "tosx_husk",--!!!
	SkillList = { "tosx_Deploy_Splitter" },
	SoundLocation = "/mech/brute/pierce_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
}

tosx_Husk2 = tosx_Husk1:new{
	Health = 2,
}