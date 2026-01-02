local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

tosx_Warp1Mech = Pawn:new{
	Name = "Distortion Mech",
	Class = "Prime",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_warp1",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Prime_Distorter"},
	SoundLocation = "/mech/science/hydrant_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	LargeShield = true,
}
tosx_Warp2Mech = Pawn:new{
	Name = "Portal Mech",
	Class = "Ranged",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_warp2",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Ranged_Portals"},
	SoundLocation = "/mech/distance/scorpio_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Flying = true,
	Massive = true,
}
tosx_Warp3Mech = Pawn:new{
	Name = "Nomad Mech",
	Class = "Science",
	Health = 2,
	MoveSpeed = 4,
	Image = "tosx_mech_warp3",
	ImageOffset = imageOffset,
	SkillList = {"tosx_Science_Nomad"},
	SoundLocation = "/mech/science/fourway_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Teleporter = true,--Add sound below
}

local tosx_NomadMove = function(mission, pawn, weaponId, p1, p2)
    if pawn and pawn:GetType() == "tosx_Warp3Mech" and weaponId == "Move" then
        Game:TriggerSound("/enemy/moth_1/attack_launch")
    end
end

modapiext.events.onSkillStart:subscribe(tosx_NomadMove)