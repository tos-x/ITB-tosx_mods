local satname = "sat_rst"
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tips = require(path .."libs/tutorialTips")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local satpath = mod_loader.mods[modApi.currentMod].resourcePath.."img/"..satname

modApi:appendAsset("img/weapons/tosx_"..satname.."_weapon.png",satpath.."/weapon.png")

---------------------------------------

tosx_sat_rst_w = Skill:new{  
	Name = "Tectonic Destabilizer",
	Description = "Collapse 3 tiles into a Chasm.\n\nSatellites disappear permanently after use.",
	Icon = "weapons/tosx_"..satname.."_weapon.png",
	Class = "",
	Limited = 1,
	--Animation = "rock1d",
	Range = 3,
	TwoClick = true,
	TipImage = {
		Unit = Point(5,5),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Target = Point(2,2),
		Second_Click = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_sat_rst_w")

function tosx_sat_rst_w:GetTargetArea()
	local ret = PointList()
	for i = 0, 7 do
		for j = 0, 7 do
			if Board:IsValid(Point(i,j)) then
				ret:push_back(Point(i,j))
			end
		end
	end
	return ret
end

function tosx_sat_rst_w:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddDamage(SpaceDamage(p2, 0))
	return ret
end

function tosx_sat_rst_w:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		ret:push_back(p2 + DIR_VECTORS[i])
	end
	
	return ret
end

function tosx_sat_rst_w:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local dir = GetDirection(p3 - p2)
	local change = VEC_RIGHT
	local change2 = VEC_LEFT

	if dir == DIR_UP or dir == DIR_DOWN then
		change = VEC_DOWN
		change2 = VEC_UP
	end
	local curr = p2 + change * ((self.Range - 1)/2)
	
	if IsTipImage() then
		ret:AddBoardShake(1)
	else
		ret:AddBoardShake(3)
	end
	
	local damage = SpaceDamage(curr)
	damage.iTerrain = TERRAIN_HOLE
	for i = 0,self.Range-1 do		
		damage.loc = curr
		ret:AddSound("/support/terraformer/attack_first")
		ret:AddDamage(damage)
		ret:AddDelay(0.5)
		
		curr = curr + change2
	end
	
	if not IsTipImage() and not IsTestMechScenario() then
	--remove weapon from pawn
		ret:AddScript("Game:RemoveItem('tosx_sat_rst_w')")
		tips:Trigger("SatWeaponUse", p1)
	end
	return ret
end

---------------------------------------