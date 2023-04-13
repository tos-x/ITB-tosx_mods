--[[
#squad
#corp

#ceo_full
#ceo_first
#ceo_second

#self_mech
#self_full
#self_first
#self_second

#main_mech
#main_full
#main_first
#main_second
]]


return {
    -- Game States
    Gamestart = {
		"The Vek overran Watchtower; time to take back our island, and save the world.",
		"I'm not going to let the Vek conquer any more islands. Let's take the fight to them.",
		"Surviving the end of the world puts things in perspective...",
	},
    FTL_Found = {
		"I've never seen tech like that before.",
	},
    FTL_Start = {
		"I don't know who or what that is. But put it in a Mech and point it at the Vek.",
	},
    Gamestart_PostVictory = {
		"Another timeline. New weapons. Same threat.",
		"#self_second, reporting. Here to share that the future isn't without hope.",
	},
    Death_Revived = {
		"Back in action.",
		"No more breaks.",
	},
    Death_Main = {
		"#self_second, going down!",
		"My #self_mech is falling apart!",
	},
    Death_Response = {
		"#main_second just bit it!",
		"We'll have to continue on without #main_second!",
	},
    Death_Response_AI = {
		"Lost a #main_mech.",
		"All pilots still accounted for.",
	},
    TimeTravel_Win = {
		"The job's never done.",
		"See you in the next timeline. Hopefully with better hazard pay.",
	},
    Gameover_Start = {
		"We tried. We failed.",
		"Our best. It wasn't enough.",
	},
    Gameover_Response = {
		"Jumping to a new timeline. I'm sure they'll have a use for my experience.",
		"One more try. Next time, we'll get it right.",
	},
    
    -- UI Barks
    Upgrade_PowerWeapon = {
		"Give me the best you've got.",
		"Has this been reloaded recently?",
	},
    Upgrade_NoWeapon = {
		"Give me something.",
		"No weapons for me, no dead Vek for you.",
	},
    Upgrade_PowerGeneric = {
		"Maximum power.",
		"Engineering did a nice job on this.",
	},
    
    -- Mid-Battle
    MissionStart = {
		"Here we go.",
		"This is what they're paying us for.",
		"Let's drive the Vek into the sea.",
	},
    Mission_ResetTurn = {
		"That was weird.",
		"Time; the ultimate weapon.",
	},
    MissionEnd_Dead = {
		"This sector has a clean bill of health.",
		"Hope there's a bonus for leaving no survivors.",
	},
    MissionEnd_Retreat = {
		"Look at them run.",
		"Odds are, we'll be fighting the survivors tomorrow...",
	},

    PodIncoming = {
		"Time Pod on my scope!",
		"Weapons from the future! Maybe this will help our chances.",
	},
    PodResponse = {
		"I see it!",
		"Get to that Pod!",
	},
    PodCollected_Self = {
		"Mine now.",
		"Contents of the Pod are secure.",
	},
    PodDestroyed_Obs = {
		"A war can't be won without weapons.",
		"We needed that. It's dust now...",
	},
    Secret_DeviceSeen_Mountain = {
		"Got a strange reading from that mountain.",
	},
    Secret_DeviceSeen_Ice = {
		"Got a strange reading from under that ice.",
	},
    Secret_DeviceUsed = {
		"Okay, let's see what happens next.",
	},

    Secret_Arriving = {
		"Never seen a Pod like that!",
	},
    Emerge_Detected = {
		"More Vek are burrowing up.",
		"Here comes another wave from underground.",
		"More Vek inbound.",
	},
    Emerge_Success = {
		"New Vek on the field.",
		"They never stop coming!",
	},
    Emerge_FailedMech = {
		"I got this one locked down.",
		"My #self_mech blocked the Vek.",
	},
    Emerge_FailedVek = {
		"They're piled on top of each other.",
		"They can't all get to the surface.",
	},

    -- Mech State
    Mech_LowHealth = {
		"Getting real low here.",
		"I'm on a knife's edge here.",
		"I've got cracks in my viewscreen...",
	},
    Mech_Webbed = {
		"Can't move!",
		"This webbing is compromising my mobility!",
		"Get me out of this!",
	},
    Mech_Shielded = {
		"Shield active.",
		"Let them come at me now...",
	},
    Mech_Repaired = {
		"That's an improvement.",
		"Green across the board.",
	},
    Pilot_Level_Self = {
		"That's how it's done.",
		"Watch and learn.",
		"This is why you hired me.",
	},
    Pilot_Level_Obs = {
		"Not bad.",
		"Hey, share the glory.",
	},
    Mech_ShieldDown = {
		"Shield is down.",
		"I hate that sound.",
	},

    -- Damage Done
    Vek_Drown = {
		"Take a swim.",
		"Try breathing underwater.",
	},
    Vek_Fall = {
		"Over the edge with you.",
		"Down the hole!",
	},
    Vek_Smoke = {
		"This should blind it.",
		"That smokescreen should keep it from attacking.",
	},
    Vek_Frozen = {
		"Vek is on ice.",
		"Vek is out of action. Leave it for the scavengers.",
	},
    VekKilled_Self = {
		"One down.",
		"This one's mine.",
		"Leave the bodies for the scavengers.",
	},
    VekKilled_Obs = {
		"Leave the bodies for the scavengers.",
		"One down.",
		"You got one.",
	},
    VekKilled_Vek = {
		"One down.",
		"They don't seem to get along.",
	},

    DoubleVekKill_Self = {
		"Two for me.",
		"I've earned my paycheck today.",
		"Two down.",
	},
    DoubleVekKill_Obs = {
		"You're earning your paycheck today.",
		"Two down.",
	},
    DoubleVekKill_Vek = {
		"They're taking each other out faster than we can engage them!",
		"Two down.",
	},

    MntDestroyed_Self = {
		"Clearing the rubble.",
		"Let's get these rocks out of the way.",
	},
    MntDestroyed_Obs = {
		"Clear the rubble.",
		"Get those rocks out of the way.",
	},
    MntDestroyed_Vek = {
		"They're clearing the rubble.",
		"The Vek must not like rocks.",
	},

    PowerCritical = {
		"If we lose the Grid, it's all over!",
		"Save the Grid! The rest of us are expendable.",
	},
    Bldg_Destroyed_Self = {
		"That's coming out of my paycheck.",
		"Sacrifices must be made.",
	},
    Bldg_Destroyed_Obs = {
		"That's coming out of your paycheck.",
		"Sacrifices must be made.",
		"Watch out for the civilians!",
	},
    Bldg_Destroyed_Vek = {
		"Protect the civilians!",
		"Keep them away from the buildings!",
	},
    Bldg_Resisted = {
		"Got lucky there!",
		"No way!",
	},
	
	-- Shared Mission Events
	Mission_Train_TrainStopped = {
		"Train's been damaged. Protect the cargo!",
		"Don't let that train take another hit, or we'll lose the cargo too!",
	},
	Mission_Train_TrainDestroyed = {
		"Lost the train.",
		"That train is a complete loss.",
	},
	Mission_Block_Reminder = {
		"Keep those Vek underground, and our jobs will be easier.",
		"Don't let the Vek surface!",
	},
	
	-- Archive Mission Events
	Mission_Tanks_Activated = {
		"Tanks online.",
		"Everything is better with tanks.",
	},
	Mission_Tanks_PartialActivated = {
		"One tank made it.",
		"One tank is better than no tanks.",
	},
	Mission_Satellite_Destroyed = {
		"Doesn't look like we can salvage that satellite, commander.",
		"Lost a satellite.",
	},
	Mission_Satellite_Imminent = {
		"That satellite is about to launch.",
		"Get clear before that rocket blasts off!",
	},
	Mission_Satellite_Launch = {
		"Rocket is away!",
		"Payload's on its way to space.",
		"Take me with you...",
	},
	Mission_Dam_Reminder = {
		"We still need to take out that dam.",
		"Can't flood this region without destroying that dam...",
	},
	Mission_Dam_Destroyed = {
		"Here comes the water!",
		"Dam destroyed!",
	},
	Mission_Mines_Vek = {
		"The Vek don't seem to understand how mines work.",
		"One for the minefield.",
	},
	Mission_Airstrike_Incoming = {
		"Airstrike inbound.",
		"That Archive bomber is about to light this place up.",
	},
	
	-- R.S.T. Mission Events
	Mission_Force_Reminder = {
		"Gotta clear those mountains or the Vek will infest them.",
		"Remember, we still need to clear those mountains.",
	},
	Mission_Lightning_Strike_Vek = {
		"R.S.T. is a weapon itself.",
		"Someone give that lightning a job.",
	},
	Mission_Terraform_Destroyed = {
		"Doesn't look like we can salvage that terraformer, commander.",
		"Shame to lose such a potent weapon.",
	},
	Mission_Terraform_Attacks = {
		"Watchtower could use one of those, to clean up the mess the Vek have made.",
		"Nothing is going to be left standing after that.",
	},
	Mission_Cataclysm_Falling = {
		"No coming back from a trip to that underworld.",
		"This forsaken island is falling apart!",
	},
	Mission_Solar_Destroyed = {
		"Doesn't look like we can salvage that solar panel, commander.",
		"No more sunlight for #ceo_second.",
	},
	
	-- Pinnacle Mission Events
	BotKilled_Self = {
		"One less hostile bot.",
		"Bots, Vek; I don't care, they all die the same.",
	},
	BotKilled_Obs = {
		"One less hostile bot.",
		"Excellent. One less thing to worry about.",
	},
	Mission_Factory_Destroyed = {
		"Doesn't look like we can salvage that factory, commander.",
		"Well, at least that factory won't be spitting out more problems for us.",
	},
	Mission_Factory_Spawning = {
		"Zenith really needs to get her priorities straight; these things are a menace.",
		"More hostiles! These factories can't really be worth it, can they?",
	},
	Mission_Reactivation_Thawed = {
		"That ice isn't holding them!",
		"Vek is on the move again!",
	},
	Mission_Freeze_Mines_Vek = {
		"That should stop it for a while.",
		"Watchtower could use some of these mines.",
	},
	Mission_SnowStorm_FrozenVek = {
		"That should stop it for a while.",
		"This weather is unforgiving.",
	},
	Mission_SnowStorm_FrozenMech = {
		"I can't move!",
		"I'm snowed in!",
		"It's... so... cold.",
	},
	
	-- Detritus Mission Events
	Mission_Barrels_Destroyed = {
		"I'll drink to that.",
		"Let the Vek soak in that.",
	},
	Mission_Disposal_Destroyed = {
		"Doesn't look like we can salvage that disposal unit, commander.",
		"Shame to lose such a potent weapon.",
	},
	Mission_Disposal_Disposal = {
		"Nothing is going to be left standing after that.",
		"Those mountains will simply dissolve away, in the face of that.",
	},
	Mission_Power_Destroyed = {
		"Doesn't look like we can salvage that power plant, commander.",
		"Grid power decreasing!",
	},
	Mission_Belt_Mech = {
		"Here we go!",
		"Uncommanded relocation underway!",
	},
	Mission_Teleporter_Mech = {
		"Here we go!",
		"Are these teleporters safe?",
	},
	
	-- Meridia Mission Events
	Mission_lmn_Convoy_Destroyed = {
		"Doesn't look like we can salvage that vehicle, commander.",
		"Lost a truck, and the supplies it was carrying.",
	},
	Mission_lmn_FlashFlood_Flood = {
		"Here comes high tide.",
		"Floodwaters are rising!",
	},
	Mission_lmn_Geyser_Launch_Mech = {
		"That's a lot of pressure!",
		"Uncommanded relocation underway!",
	},
	Mission_lmn_Geyser_Launch_Vek = {
		"That's a lot of pressure!",
		"That should give the Vek something to think about.",
	},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {
		"That should give the Vek something to think about.",
		"This island is turning up the heat.",
	},
	Mission_lmn_Wind_Push = {
		"Storm on the horizon!",
		"Brace for winds!",
	},
	
	Mission_lmn_Runway_Imminent = {
		"Stay clear of that runway, #squad.",
		"We don't get paid unless that plane takes off safely.",
	},
	Mission_lmn_Runway_Crashed = {
		"Doesn't look like we can salvage that aircraft, commander.",
		"Aircraft down!",
	},
	Mission_lmn_Runway_Takeoff = {
		"Aircraft away.",
		"I hope that plane gets where it's going.",
	},
	Mission_lmn_Greenhouse_Destroyed = {
		"Doesn't look like we can salvage that greenhouse, commander.",
		"That greenhouse didn't survive.",
	},
	Mission_lmn_Geothermal_Plant_Destroyed = {
		"Doesn't look like we can salvage that geothermal unit, commander.",
		"That geothermal unit didn't survive.",
	},
	Mission_lmn_Hotel_Destroyed = {
		"Doesn't look like we can salvage that hotel, commander.",
		"That hotel didn't survive.",
	},
	Mission_lmn_Agroforest_Destroyed = {
		"Doesn't look like we can salvage that agroforest, commander.",
		"That agroforest didn't survive.",
	},
	
-- tosx missions
	-- Island missions
	Mission_tosx_Juggernaut_Destroyed = {
		"Doesn't look like we can salvage that Juggernaut unit, commander.",
		"Shame to lose such an effective weapon.",
	},
	Mission_tosx_Juggernaut_Ram = {
		"Don't mess with that sphere.",
		"Stand clear, #squad.",
	},
	Mission_tosx_Zapper_On = {
		"I've got an electrical heartbeat here.",
		"Power is flowing; tower is armed.",
	},
	Mission_tosx_Zapper_Destroyed = {
		"Doesn't look like we can salvage that storm tower, commander.",
		"That tower didn't survive.",
		"Shame to lose such an effective weapon.",
	},
	Mission_tosx_Warper_Destroyed = {
		"Doesn't look like we can salvage that portal tender, commander.",
		"Aircraft is down!",
	},
	Mission_tosx_Battleship_Destroyed = {
		"Doesn't look like we can salvage that ship, commander.",
		"Survivors are in the water. Focus on the Vek, and let the rescue teams handle it.",
	},
	
	-- Island missions 2
	Mission_tosx_Siege_Now = {
		"Now the fun begins.",
		"They're everywhere!",
	},
	Mission_tosx_Plague_Spread = {
		"Stand clear, #squad!",
		"That thing is a walking deathtrap!",
	},
	
	-- AE
	Mission_ACID_Storm_Start = {
		"This place is soaking in A.C.I.D. Let's help them with that.",
		"#corp lost control of this storm; let's fix things.",
	},	
	Mission_ACID_Storm_Clear = {
		"Weather is clearing.",
		"Storm controller is offline.",
	},	
	Mission_Wind_Mech = {
		"Storm on the horizon!",
		"Brace for winds!",
	},	
	Mission_Repair_Start = {
		"So now we have to fix our own Mechs?",
		"I can't believe we have to take care of repairs ourselves.",
	},	
	Mission_Hacking_NewFriend = {
		"Another ally for the cause.",
		"Can we get a few more hacked robots to help us?",
	},	
	Mission_Shields_Down = {
		"Shields are down!",
		"Energy field dissipating. Watch yourselves!",
	},
	
	-- Final
	MissionFinal_Start = {
		"This place has even less Grid support than Watchtower. What are we supposed to power our Mechs with?",
	},
	MissionFinal_StartResponse = {
		"I see the pylons inbound. Ready for Grid connection.",
	},
	MissionFinal_FallResponse = {
		"What's happening?!",
	},
	MissionFinal_Bomb = {
		"Even Akai's nukes wouldn't make a scratch on this place. It's huge!",
	},
	MissionFinal_CaveStart = {
		"Time to earn our last paycheck. Protect that bomb, #squad.",
	},
	MissionFinal_BombArmed = {
		"We did it. Mission accomplished.",
	},
	
	-- Watchtower missions
	Mission_tosx_Sonic_Destroyed = {
		"Doesn't look like we can salvage that Disruptor, commander.",
		"Lost the Disruptor.",
		"Shame to lose such a potent weapon.",
	},
	Mission_tosx_Tanker_Destroyed = {
		"Doesn't look like we can salvage that tanker, commander.",
		"This island doesn't have enough water to be wasting it like that.",
		"This island breeds hardy people, but they still need water. Can't believe we lost the tanker.",
	},
	Mission_tosx_TankerFull_Destroyed = {
		"Watchtower is crawling with capable scavengers; I'm sure Akai will find someone to retrieve the water from that wreckage.",
		"Knowing Akai, he's already got a salvage team en route to recover the water from that wreck.",
	},
	Mission_tosx_Rig_Destroyed = {
		"Doesn't look like we can salvage that War Rig, commander.",
		"Lost the War Rig.",
		"Shame to lose such a weapon with such potential.",
	},
	Mission_tosx_GuidedKill = {
		"Looks like that targeting data was spot on.",
		"Feed it a missile!",
	},
	Mission_tosx_NuclearSpread = {
		"This corporation never had the highest safety standards.",
		"I wonder if Akai left that nuclear waste here intentionally, as a present for the Vek.",
	},
	Mission_tosx_RaceReminder = {
		"I've got a huge wager riding on the lead car. Let's make sure it reaches the far side of the sector, with no competition in sight!",
		"If we can give Watchtower's citizens a thrilling conclusion to this race, our reputation here is sure to soar. Let's get one of those Rigs to the finish line!",
	},
	Mission_tosx_MercsPaid = {
		"Looks like those mercenaries are willing to do business!",
		"Seems the minerals we gathered are worth something to these mercs; they're willing to fight with us in exchange for them.",
	},
	Mission_tosx_RigUpgraded = {
		"That's Watchtower ingenuity right there.",
		"Watchtower is always trying to build better weapons. And they're succeeding!",
	},
	
}

	