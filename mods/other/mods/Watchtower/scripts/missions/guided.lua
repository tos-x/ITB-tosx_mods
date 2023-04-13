
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local switch = require(path .."libs/switch")
local missionTemplates = require(path .."missions/missionTemplates")

local objInMission = switch{
	[0] = function()
		Game:AddObjective("Kill an enemy with a Guided Missile", OBJ_STANDARD, REWARD_REP, 1)
	end,
	[1] = function()
		Game:AddObjective("Kill an enemy with a Guided Missile", OBJ_COMPLETE, REWARD_REP, 1)
	end,
	default = function() end
}

local objAfterMission = switch{
	[0] = function() return Objective("Kill an enemy with a Guided Missile", 1):Failed() end,
	[1] = function() return Objective("Kill an enemy with a Guided Missile", 1) end,
	default = function() return nil end,
}

Mission_tosx_Guided = Mission_Infinite:new{
	Name = "Guided Missiles",
	MapTags = {"tosx_rocky" , "mountain"},
	BonusPool = copy_table(missionTemplates.bonusNoMercy),
	Objectives = objAfterMission:case(1),
	UseBonus = true,
	Environment = "tosx_env_guided",
	Kills = 0,
}

-- Add CEO dialog
local dialog = require(path .."missions/guided_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Guided", dialogTable)
end

function Mission_tosx_Guided:UpdateObjectives()
	objInMission:case(self.Kills)
end

function Mission_tosx_Guided:GetCompletedObjectives()
	return objAfterMission:case(self.Kills)
end

modApi:appendAsset("img/effects/tosx_shotup_guided_missile.png", mod.resourcePath .."img/effects/shotup_guided_missile.png")
modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_guided.png", mod.resourcePath .."img/combat/tile_icon/icon_env_guided.png")
Location["combat/tile_icon/tosx_icon_env_guided.png"] = Point(-27,2) -- Needed for it to appear on tiles

-------------------------------------------------------------------- 
tosx_env_guided = Environment:new{
	Name = "Guided Missiles",
	Text = "Guided missiles will strike any tiles that Mechs target with their weapons.\n\nMechs and Grid Buildings will not be fired on.",
	Decription = "If there are no Mechs on this tile, a missile will strike it, dealing 1 damage.",
	StratText = "GUIDED MISSILES",
	CombatIcon = "combat/tile_icon/tosx_icon_env_guided.png",
	CombatName = "MISSILES",
	Damage = 1,
	Locations = {},
	MarkLocations = {},
	ShotUp = "effects/tosx_shotup_guided_missile.png"
}
	
TILE_TOOLTIPS.tosx_env_guided_tile = {tosx_env_guided.Name, tosx_env_guided.Decription}
Global_Texts["TipTitle_".."tosx_env_guided"] = tosx_env_guided.Name
Global_Texts["TipText_".."tosx_env_guided"] = tosx_env_guided.Text
	
function tosx_env_guided:Plan()
	return false
end

function tosx_env_guided:IsEffect()
	return true
end

function tosx_env_guided:MarkBoard()
	for _, loc in ipairs(self.MarkLocations) do
		--Board:MarkSpaceImage(loc, self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
		Board:MarkSpaceImage(loc, self.CombatIcon, GL_Color(230,162,21,0.75))
		Board:MarkSpaceDesc(loc, "tosx_env_guided_tile")
	end
end

function tosx_env_guided:ApplyEffect()
	if not self.MarkLocations then return false end
	
	local effect = SkillEffect()
	effect.iOwner = ENV_EFFECT
	
	self.MarkLocations = reverse_table(self.MarkLocations)

	while #self.MarkLocations > 0 do
		local loc = pop_back(self.MarkLocations)
		
		if Board:IsPawnSpace(loc) and Board:GetPawn(loc):GetTeam() == TEAM_PLAYER then
			-- do nothing
		else
			effect:AddSound("/weapons/heavy_rocket")
			damage = SpaceDamage(loc,self.Damage)
			if Board:IsPawnSpace(loc) and Board:GetCustomTile(loc) == "tosx_rocks_0.png"then
				-- Skillbuild hooks don't catch Board:AddEffect
				-- Manually hack in our rock terrain effect until a better way is found
				damage.iDamage = DAMAGE_ZERO
				damage.sScript = "tosx_RocksCrumble("..loc:GetString()..")"
			end				
			damage.sAnimation = "ExploAir2"
			damage.sSound = "/impact/generic/explosion_large"
			effect:AddArtillery(damage, self.ShotUp, NO_DELAY)

			effect:AddDelay(1)
			if Board:IsPawnSpace(loc) and Board:GetPawn(loc):GetTeam() == TEAM_ENEMY then
				effect:AddScript([[
					if not Board:IsPawnAlive(]]..Board:GetPawn(loc):GetId()..[[) then
						GetCurrentMission().Kills = GetCurrentMission().Kills + 1
						
						local effect = SkillEffect()
						local chance = math.random()
						if chance > 0.3 then
							effect:AddVoice("Mission_tosx_GuidedKill", -1)
						end
						Board:AddEffect(effect)						
					end
					]])
			end
			
		end
	end	
	
    Board:AddEffect(effect)	
    self.MarkLocations = {}
	
    return false
end
-------------------------------------------------------------------- 

local onSkillFinal = function(skillEffect, pawn, point)
	if pawn:GetTeam() == TEAM_PLAYER and
	   pawn:GetArmedWeaponId() > 0 and
	   pawn:GetArmedWeaponId() < 50 and --0 = move, 50 = repair
	   not Board:IsBuilding(point) then
		skillEffect:AddDelay(.10)
		skillEffect:AddSound("/props/square_lightup")
		skillEffect:AddScript(string.format("table.insert(GetCurrentMission().LiveEnvironment.MarkLocations, %s)", point:GetString()))
	end
end

local onSkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
	if not mission or mission.ID ~= "Mission_tosx_Guided" then return end
	if not skillEffect or not pawn then return end
	onSkillFinal(skillEffect, pawn, p2)
end

local onSkillEffect2 = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	if not mission or mission.ID ~= "Mission_tosx_Guided" then return end
	if not skillEffect or not pawn then return end
	onSkillFinal(skillEffect, pawn, p3)
end

local function onModsLoaded()
	modapiext:addSkillBuildHook(onSkillEffect)
	modapiext:addFinalEffectBuildHook(onSkillEffect2)
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)