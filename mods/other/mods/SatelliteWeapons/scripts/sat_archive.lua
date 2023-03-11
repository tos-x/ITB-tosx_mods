local satname = "sat_archive"
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
	PosX = -20,
	PosY = -38,
	NumFrames = 10,
	Time = 0.075
	}

---------------------------------------

tosx_sat_archive_w = Skill:new{  
	Name = "Orbital Salvo",
	Description = "Deal heavy damage in a large X pattern.\n\nSatellites disappear permanently after use.",
	Icon = "weapons/tosx_"..satname.."_weapon.png",
	Damage = 5,
	Class = "",
	Limited = 1,
	Animation = "tosx_"..satname.."_effect",
	LaunchSound = "/weapons/burst_beam",
	ImpactSound = "/impact/generic/explosion",
	Range = 3,
	TipImage = {
		Unit = Point(5,5),
		Building = Point(1,2),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(3,3),
		Target = Point(3,2),
	},
}
modApi:addWeaponDrop("tosx_sat_archive_w")

function tosx_sat_archive_w:GetTargetArea()
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


function tosx_sat_archive_w:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local damage = SpaceDamage(p2, self.Damage)
	damage.sAnimation = self.Animation
	ret:AddDamage(damage)
	
	for i = 1,self.Range do
		for dir = DIR_START, DIR_END do
			local point = p2 + DIR_VECTORS[dir]*i
			damage.loc = point
			ret:AddDelay(0.05)
			ret:AddDamage(damage)
		end
	end
	
	if not IsTipImage() and not IsTestMechScenario() then
	--remove weapon from pawn
		ret:AddScript("Game:RemoveItem('tosx_sat_archive_w')")
		tips:Trigger("SatWeaponUse", p1)
	end
	if self.Reactivate then
		ret:AddDelay(0.2)
		ret:AddScript([[
			local self = Point(]].. p1:GetString() .. [[)
			Board:GetPawn(self):SetActive(true)
			Game:TriggerSound("/ui/map/flyin_rewards");
			Board:Ping(self, GL_Color(255, 255, 255));
		]])
	end
	return ret
end

---------------------------------------