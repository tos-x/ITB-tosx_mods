
local mod = modApi:getCurrentMod()
local path = mod.scriptPath
local missionTemplates = require(path .."missions/missionTemplates")
local suppressDialog = require(path .."libs/suppressDialog")

function SuppressDialog(duration,event)
	suppressDialog:AddEvent(event)
	if duration and duration >= 0 then
		modApi:scheduleHook(duration, function()
			UnsuppressDialog(event)
		end)
	end
end
function UnsuppressDialog(event)
	suppressDialog:RemEvent(event)
end

Mission_tosx_Nuclear = Mission_Infinite:new{
	Name = "Nuclear Waste",
	MapTags = {"tosx_rocky" , "mountain", "generic"},
	BonusPool = copy_table(missionTemplates.bonusAll),
	UseBonus = true,
	Environment = "tosx_env_nuclear",
	Sites = {},
	Active = {},
}

-- Add CEO dialog
local dialog = require(path .."missions/nuclear_dialog")
for personalityId, dialogTable in pairs(dialog) do
	Personality[personalityId]:AddMissionDialogTable("Mission_tosx_Nuclear", dialogTable)
end

function Mission_tosx_Nuclear:StartMission()
	self.Sites = {}
	self.Active = {}

	local quarters = Environment:GetQuarters()
	
	for i,options in pairs(quarters) do
		local curr = Point(-1,-1)
		while #options > 0 and (not Board:IsValid(curr) or Board:IsBlocked(curr,PATH_GROUND)) do
			curr = random_removal(options)
		end
		self.Sites[#self.Sites+1] = curr
		Board:SetCustomTile(curr,"tosx_nuclear_0.png")
		
		if curr.x > 3 then -- Add another for the last 2 quarters (vek side, x = 4-7)
			curr = Point(-1,-1)
			while #options > 0 and (not Board:IsValid(curr) or Board:IsBlocked(curr,PATH_GROUND)) do
				curr = random_removal(options)
			end
			self.Sites[#self.Sites+1] = curr
			Board:SetCustomTile(curr,"tosx_nuclear_0.png")
		end
	end
end

modApi:appendAsset("img/combat/tile_icon/tosx_icon_env_nuclear.png", mod.resourcePath .."img/combat/tile_icon/icon_env_nuclear.png")
Location["combat/tile_icon/tosx_icon_env_nuclear.png"] = Point(-27,2) -- Needed for it to appear on tiles
modApi:appendAsset("img/effects/tosx_rad_a.png",mod.resourcePath.."img/effects/tosx_rad_a.png")

ANIMS.tosx_RadBlast = Animation:new{
	Image = "effects/tosx_rad_a.png",
	NumFrames = 8,
	Time = 0.08,
	PosX = -33,
	PosY = -14
}

-------------------------------------------------------------------- 
tosx_env_nuclear = Env_Attack:new{
	Name = "Radioactive Waste",
	Text = "Lethal radiation will gradually contaminate the map.",
	Ordered = true,
	Decription = "Radiation will kill any unit on this tile.",
	Decription2 = "Radiation will reduce this unit to 1 health.",
	StratText = "RADIATION",
	CombatIcon = "combat/tile_icon/tosx_icon_env_nuclear.png",
	CombatName = "RADIATION",
}
	
TILE_TOOLTIPS.tosx_env_nuclear_tile = {tosx_env_nuclear.Name, tosx_env_nuclear.Decription}
TILE_TOOLTIPS.tosx_env_nuclear_tile2 = {tosx_env_nuclear.Name, tosx_env_nuclear.Decription2}
Global_Texts["TipTitle_".."tosx_env_nuclear"] = tosx_env_nuclear.Name
Global_Texts["TipText_".."tosx_env_nuclear"] = tosx_env_nuclear.Text
	

function tosx_env_nuclear:MarkSpace(space, active)
	--Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(230,162,21,0.75))
	Board:MarkSpaceDesc(space,"tosx_env_nuclear_tile", EFFECT_DEADLY)
	if Board:IsPawnSpace(space) and Board:GetPawn(space):IsAbility("GraySkill") then
		Board:MarkSpaceDesc(space,"tosx_env_nuclear_tile2")
	end
	-- if active then
		-- Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	-- end
end

function tosx_env_nuclear:GetAttackEffect(location)
	local effect = SkillEffect()
	
	local damage = SpaceDamage(location, DAMAGE_DEATH)
	damage.sAnimation = "tosx_RadBlast"
	damage.sSound = "/impact/generic/explosion_large"
	
	effect:AddDamage(damage)
	
	-- Special interaction with Gray
	if Board:IsPawnSpace(location) and Board:GetPawn(location):IsAbility("GraySkill") then	
		effect:AddScript([[
			SuppressDialog(1200,"Death_Revived")
			SuppressDialog(1200,"PilotDeath")
			SuppressDialog(1200,"Mech_Repaired")
			SuppressDialog(1200,"Mech_LowHealth")
			SuppressDialog(1200,"Pilot_Skill_Gray")
		]])
		-- PilotDeath event has the calls to Death_Main and Death_Response
	
		effect:AddScript("Board:GetPawn("..location:GetString().."):SetHealth(1)")
		effect:AddScript([[
			local cast = { main = ]]..Board:GetPawn(location):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Mission_tosx_NuclearGray", cast)
		]])
	end
	
	return effect
end

function tosx_env_nuclear:SelectSpaces()
	local ret = {}
	local mission = GetCurrentMission()
	if #mission.Active < #mission.Sites then
		local i = #mission.Active + 1
		mission.Active[i] = mission.Sites[i]
	end

	local effect = SkillEffect()
	local chance = math.random()
	if chance > 0.2 and Game:GetTurnCount() > 0 then
		effect:AddVoice("Mission_tosx_NuclearSpread", -1)
	end
	Board:AddEffect(effect)	

	return mission.Active
end

	

local function onModsLoaded()
	modapiext.dialog:addRuledDialog("Mission_tosx_NuclearGray", {
		Odds = 100,
		{ main = "Mission_tosx_NuclearGray" },
	})
end
	
modApi.events.onModsLoaded:subscribe(onModsLoaded)