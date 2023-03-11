--local trait = LApi.library:fetch("trait")
local mod = modApi:getCurrentMod()
local trait = require(mod.scriptPath .."libs/trait")

local path = mod_loader.mods[modApi.currentMod].resourcePath.."img/combat/traits/"
local path2 = mod_loader.mods[modApi.currentMod].resourcePath.."img/combat/icons/empty.png"

trait:add{
		pilotSkill = "KnightSkill",
		icon = path.."pilot_trait_knight.png",
		icon_offset = Point(0,0),
		desc_title = "Steadfast",
		desc_text = "Mech instantly Repairs bump damage.",
	}

trait:add{
		pilotSkill = "TitanSkill",
		icon = path.."pilot_trait_titan.png",
		icon_offset = Point(0,0),
		desc_title = "Titan Armor",
		desc_text = "Gain a shield after surviving an attack.",
	}

trait:add{
		pilotSkill = "GyrosaurSkill",
		icon = path.."pilot_trait_gyrosaur.png",
		icon_offset = Point(0,0),
		desc_title = "Ricochet",
		desc_text = "Deals additional damage to enemies that bump Mech.",
	}

trait:add{
		pilotSkill = "ImpactSkill",
		icon = path.."pilot_trait_impact.png",
		icon_offset = Point(0,0),
		desc_title = "Grav Anchor",
		desc_text = "During the enemy turn, adjacent enemies cannot move away from Mech.",
	}

trait:add{
		pilotSkill = "StrangerSkill",
		icon = path.."pilot_trait_stranger.png",
		icon_offset = Point(0,0),
		desc_title = "Wastelander",
		desc_text = "Vek spawning adjacent to Mech take 1 damage on arrival.",
	}

trait:add{
		pilotSkill = "CypherSkill",
		icon = path.."pilot_trait_cypher.png",
		icon_offset = Point(0,0),
		desc_title = "Adaptive Nanites",
		desc_text = "Mech neutralizes Fire, Smoke, Frozen and A.C.I.D. effects on its tile.",
	}

trait:add{
		pilotSkill = "TerminusSkill",
		icon = path.."pilot_trait_terminus.png",
		icon_offset = Point(0,0),
		desc_title = "Vengeance",
		desc_text = "Deal 1 damage to enemies that attack adjacent to Mech.",
	}

trait:add{
		pilotSkill = "QuicksilverSkill",
		icon = path.."pilot_trait_quicksilver.png",
		icon_offset = Point(0,0),
		desc_title = "Polyalloy Shell",
		desc_text = "Repair 1 HP at the start of each turn.",
	}
	
trait:add{
		--func = function(trait, pawn) return pawn:IsAbility("QuicksilverSkillB") and (not pawn:IsBoosted()) end,
		pilotSkill = "QuicksilverSkillB",
		icon = path.."pilot_trait_quicksilverB.png",
		icon_offset = Point(0,0),
		desc_title = "Combat Override",
		desc_text = "Mech gains Boosted when damaged.",
	}

trait:add{
		func = function(trait, pawn) return (pawn:GetHealth() == 1) and pawn:IsAbility("GraySkill") end,
		icon = path.."pilot_trait_gray.png",
		icon_offset = Point(0,0),
		desc_title = "Unstable Reactor",
		desc_text = "Damages adjacent non-building tiles at the end of your turn.",
	}
	
local traitfunc_necro = function(trait, pawn)
	local mission = GetCurrentMission()
	if not mission then return false end
	return pawn:IsAbility("NecroSkill") and (not mission.NecroSkillUsed)
end
	
trait:add{
		func = traitfunc_necro,
		icon = path.."pilot_trait_necro.png",
		icon_offset = Point(0,0),
		desc_title = "Necrotize",
		desc_text = "When an adjacent Vek dies, creates a friendly Spiderling.",
	}
	
local traitfunc_mara = function(trait, pawn)
	local mission = GetCurrentMission()
	if not mission then return false end
	return pawn:IsAbility("MaraSkill") and (not mission.MaraSkillUsed)
end

trait:add{
		func = traitfunc_mara,
		icon = path.."pilot_trait_mara.png",
		icon_offset = Point(0,0),
		desc_title = "Improbable Escape",
		desc_text = "Mech survives death with 1 health.",
	}
	
local traitfunc_drift = function(trait, pawn)
	local mission = GetCurrentMission()
	if not mission then return false end
	return pawn:IsAbility("DriftSkill") and (mission.DriftReduction == 1)
end

trait:add{
		func = traitfunc_drift,
		icon = path.."pilot_trait_drift.png",
		icon_offset = Point(0,0),
		desc_title = "Time Lag",
		desc_text = "Movement reduced by 1 due to Pilot using Drift Step on previous turn.",
	}
	
local traitfunc_drift2 = function(trait, pawn)
	local mission = GetCurrentMission()
	if not mission then return false end
	return pawn:IsAbility("DriftSkill") and (mission.DriftReduction == 2)
end

trait:add{
		func = traitfunc_drift2,
		icon = path.."pilot_trait_drift.png",
		icon_offset = Point(0,0),
		desc_title = "Time Lag",
		desc_text = "Movement reduced by 2 due to Pilot using Drift Step on previous turn.",
	}