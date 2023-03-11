local satname = "sat_detritus"
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tips = require(path .."libs/tutorialTips")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local satpath = mod_loader.mods[modApi.currentMod].resourcePath.."img/"..satname

modApi:appendAsset("img/weapons/tosx_"..satname.."_weapon.png",satpath.."/weapon.png")
modApi:appendAsset("img/effects/tosx_"..satname.."_effect.png",satpath.."/effect.png")

---------------------------------------

tosx_sat_detritus_w = Skill:new{  
	Name = "Annihilation Beam",
	Description = "Damages units in a line.\n\nSatellites disappear permanently after use.",
	Icon = "weapons/tosx_"..satname.."_weapon.png",
	Damage = 5,
	Class = "",
	Limited = 1,
	Damage = 5,
	LaunchSound = "/weapons/burst_beam",
	ImpactSound = "/impact/generic/explosion",
	Animation = "ExploArtCrab2",
	Range = 8,
	TwoClick = true,
	TipImage = {
		Unit = Point(5,5),
		Building = Point(1,2),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(0,2),
		Second_Click = Point(1,2),
	},
}
modApi:addWeaponDrop("tosx_sat_detritus_w")

function tosx_sat_detritus_w:GetTargetArea(point)
	local ret = PointList()
	local board_size = Board:GetSize()
	for i = 0, board_size.x  do
		for j = 0, board_size.y  do
			ret:push_back(Point(i,j))
		end
	end
	return ret
end

function tosx_sat_detritus_w:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddDamage(SpaceDamage(p2, 0))
	return ret
end

function tosx_sat_detritus_w:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		ret:push_back(p2 + DIR_VECTORS[i])
	end
	
	return ret
end

function tosx_sat_detritus_w:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local dir = GetDirection(p3 - p2)
	local curr = p2
	local change = VEC_DOWN

	if dir == DIR_UP or dir == DIR_DOWN then
		change = VEC_DOWN
		curr = Point(p2.x,0)
		ret:AddReverseAirstrike(curr, "effects/tosx_"..satname.."_effect.png")
	else
		change = VEC_RIGHT
		curr = Point(0,p2.y)
		ret:AddAirstrike(curr, "effects/tosx_"..satname.."_effect.png")
	end
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = self.Animation
	for i = 0, 7 do
		damage.loc = curr
		ret:AddSound("/support/terraformer/attack_first")
		ret:AddDamage(damage)
		ret:AddDelay(0.15)
		curr = curr + change
	end
	
	if not IsTipImage() and not IsTestMechScenario() then
	--remove weapon from pawn
		ret:AddScript("Game:RemoveItem('tosx_sat_detritus_w')")
		tips:Trigger("SatWeaponUse", p1)
	end

	return ret
end

---------------------------------------