local satname = "sat_pinnacle"
local path = mod_loader.mods[modApi.currentMod].scriptPath
local tips = require(path .."libs/tutorialTips")

local function IsTipImage()
	return Board:GetSize() == Point(6, 6)
end

local satpath = mod_loader.mods[modApi.currentMod].resourcePath.."img/"..satname

modApi:appendAsset("img/weapons/tosx_"..satname.."_weapon.png",satpath.."/weapon.png")
modApi:appendAsset("img/effects/tosx_"..satname.."_effect.png",satpath.."/effect.png")	

local a = ANIMS
a["tosx_"..satname.."_effect"] = a.BaseUnit:new{Image = "effects/tosx_"..satname.."_effect.png", 
	Loop = false,
	NumFrames = 8,
	Time = 0.05,	
	PosX = -33,
	PosY = -14
	}

---------------------------------------

tosx_sat_pinnacle_w = Skill:new{  
	Name = "Guardian Pulse",
	Description = "Shield all Grid Buildings and friendly units.\n\nSatellites disappear permanently after use.",
	Icon = "weapons/tosx_"..satname.."_weapon.png",
	Class = "",
	Limited = 1,
	Animation = "tosx_"..satname.."_effect",
	LaunchSound = "/weapons/area_shield",
	ImpactSound = "/weapons/science_repulse",
	Range = 3,
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Building2 = Point(1,2),
		Building3 = Point(3,3),
		Target = Point(2,1),
	},
}
modApi:addWeaponDrop("tosx_sat_pinnacle_w")

function tosx_sat_pinnacle_w:GetTargetArea()
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


function tosx_sat_pinnacle_w:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local damage = SpaceDamage(p2)
	damage.iShield = 1
	damage.sAnimation = self.Animation
	
	for i = 0, 7 do
		local jmin = 0
		if IsTipImage() then jmin = 1 end
		for j = jmin, 7 do
			if Board:IsValid(Point(i,j)) then
				damage.loc = Point(i,j)
				if Board:IsPawnSpace(Point(i,j)) and Board:GetPawn(Point(i,j)):GetTeam() == TEAM_PLAYER then
					ret:AddDamage(damage)
					ret:AddDelay(0.02)
				elseif Board:IsBuilding(Point(i,j)) then
					ret:AddDamage(damage)
					ret:AddDelay(0.02)
				end
			end
		end
	end
	
	if not IsTipImage() and not IsTestMechScenario() then
	--remove weapon from pawn
		ret:AddScript("Game:RemoveItem('tosx_sat_pinnacle_w')")
		tips:Trigger("SatWeaponUse", p1)
	end
	return ret
end

---------------------------------------