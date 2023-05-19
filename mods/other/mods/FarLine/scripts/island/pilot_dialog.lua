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
		--"The Vek overran Watchtower; time to take back our island, and save the world.",
		"I've filled out all the necessary forms: Mech, ammunition, Grid power draw, and 15 different liability waivers. Let's get to the action.",
		"I can't imagine how much paperwork this time travel stuff will create. Or... do not all CEOs obsess over forms?",
		"Let's drive the Vek from each of these islands, one by one, and let the ocean consume their remains.",
	},
    FTL_Found = {
		--"I've never seen tech like that before.",
		"What on earth is that? Is it supposed to be here?",
	},
    FTL_Start = {
		--"I don't know who or what that is. But put it in a Mech and point it at the Vek.",
		"Whoever this new fellow is, we should get them checked in and see how they like piloting a Mech.",
	},
    Gamestart_PostVictory = {
		--"Another timeline. New weapons. Same threat.",
		"Another chance to save the world. Do I need to sign for this Mech?",
		"Do I need to fill out my Mech requisition forms all over again in this timeline?",
	},
    Death_Revived = {
		--"Back in action.",
		"... #self_full here. Reports of my death were greatly exaggerated.",
		"I'm not dead? I feel like that's going to result in a lot of paperwork.",
	},
    Death_Main = {
		--"#self_second, going down!",
		"I'm hit!",
		"It's been an honor fighting with you al-",
	},
    Death_Response = {
		--"#main_second just bit it!",
		"#main_full is down. Notify any next of kin, after the mission.",
		"#squad, we just lost a pilot!",
	},
    Death_Response_AI = {
		--"Lost a #main_mech.",
		"Those A.I. units may be replaceable, but we're still down one Mech in the short term!",
		"Don't fret too much; we'll requisition a new A.I. unit after this mission.",
	},
    TimeTravel_Win = {
		--"The job's never done.",
		"More islands to save, can't stop now.",
		"See you all in the next life, I hope.",
	},
    Gameover_Start = {
		--"We tried. We failed.",
		"No coming back from this.",
		"We'll have to learn from our failures and try harder; open a Breach.",
	},
    Gameover_Response = {
		--"Jumping to a new timeline. I'm sure they'll have a use for my experience.",
		"Maybe the next timeline will be the one to see success.",
		"I'll be filing an extensive report on the failures that may have resulted in the loss of this timeline. Hopefully someone reads it in the next.",
	},
    
    -- UI Barks
    Upgrade_PowerWeapon = {
		--"Give me the best you've got.",
		"Do I have to sign for this?",
		"Is this what I ordered? Let me double-check my requisition forms.",
	},
    Upgrade_NoWeapon = {
		--"Give me something.",
		"This can't be right.",
		"Hey, I know I ordered a weapon to go with this Mech.",
	},
    Upgrade_PowerGeneric = {
		--"Maximum power.",
		"Better hurry and power up all systems, or our timetable will slip.",
		"There we go.",
	},
    
    -- Mid-Battle
    MissionStart = {
		--"Here we go.",
		"All hands on deck, #squad.",
		"#squad, standing by to intercept the enemy.",
		"Let's hope it's smooth sailing.",
	},
    Mission_ResetTurn = {
		--"That was weird.",
		"Anyone else have a headache?",
		"I'm putting each one of those resets on my health assessment form, just in case I turn to temporal goo or something.",
	},
    MissionEnd_Dead = {
		--"This sector has a clean bill of health.",
		"Everything looks shipshape here.",
		"No surviving Vek; that'll simplify my battle report, not having to document stragglers.",
	},
    MissionEnd_Retreat = {
		--"Look at them run.",
		"Those stragglers will be a pain to document in my battle report. Still, don't want them to surprise anyone down the road.",
		"Couldn't stop them from escaping.",
	},

    PodIncoming = {
		--"Time Pod on my scope!",
		"Looks like a Time Pod just broke atmosphere.",
		"Got something coming in for a crash landing!",
	},
    PodResponse = {
		--"I see it!",
		"I'll try and retrieve that Pod with my #self_mech.",
		"Updating our mission parameters to prioritize Pod retrieval.",
	},
    PodCollected_Self = {
		--"Mine now.",
		"Pod retrieved. I'll file the necessary forms when we get back to the hangar.",
		"Got it. Updating mission parameters to reprioritize remaining objectives.",
	},
    PodDestroyed_Obs = {
		--"A war can't be won without weapons.",
		"Looks like we won't be getting to document the contents of that Pod.",
		"I've documented the loss of the Time Pod. I'll make a full report back at the hangar.",
	},
    Secret_DeviceSeen_Mountain = {
		--"Got a strange reading from that mountain.",
		"Anyone else seeing something in that mountain?",
	},
    Secret_DeviceSeen_Ice = {
		--"Got a strange reading from under that ice.",
		"Anyone else seeing something in that ice?",
	},
    Secret_DeviceUsed = {
		--"Okay, let's see what happens next.",
		"I think something's happening...",
	},

    Secret_Arriving = {
		--"Never seen a Pod like that!",
		"Got a Time Pod... no, wait, that's not a normal Pod, is it?",
	},
    Emerge_Detected = {
		--"More Vek are burrowing up.",
		"Underground Vek detected.",
		"Steady, #squad. Here they come.",
		"Seismic readings! More Vek are on their way.",
	},
    Emerge_Success = {
		--"New Vek on the field.",
		"Vek reinforcements!",
		"More threats to deal with.",
	},
    Emerge_FailedMech = {
		--"I got this one locked down.",
		"I've prevented this one from surfacing.",
		"You're not getting past me!",
	},
    Emerge_FailedVek = {
		--"They're piled on top of each other.",
		"They're preventing each other from surfacing!",
		"The Vek are piled all on top of one another.",
	},

    -- Mech State
    Mech_LowHealth = {
		--"Getting real low here.",
		"My #self_mech can't take much more of this!",
		"I'm still hanging in here!",
		"I'm going to be filing damage reports for days after this mission.",
	},
    Mech_Webbed = {
		--"Can't move!",
		"I'm stuck!",
		"This Vek has immobilized my #self_mech!",
	},
    Mech_Shielded = {
		--"Shield active.",
		"I feel much safer now.",
		"Shield is up.",
	},
    Mech_Repaired = {
		--"That's an improvement.",
		"That'll save me a few after-action damage report forms.",
		"Things are looking a little better.",
	},
    Pilot_Level_Self = {
		--"That's how it's done.",
		"Not bad, if I do say so.",
		"Is this promotion official now, or is there some form that needs to be processed first?",
		"I think I've earned this, given how many Vek I've taken out.",
	},
    Pilot_Level_Obs = {
		--"Not bad.",
		"Well done, #main_full.",
		"No one deserves a promotion more than you, #main_full.",
	},
    Mech_ShieldDown = {
		--"Shield is down.",
		"Shield is down.",
		"I'm feeling a bit adrift without that shield.",
	},

    -- Damage Done
    Vek_Drown = {
		--"Take a swim.",
		"The ocean can have you!",
		"Special delivery, via ocean freight!",
		"Give my regards to the deep.",
		"I hope the fish around here like eating dead Vek.",
	},
    Vek_Fall = {
		--"Over the edge with you.",
		"Give my regards to the center of the Earth.",
		"Special delivery, via air drop!",
	},
    Vek_Smoke = {
		--"This should blind it.",
		"Bad weather should slow these monsters down.",
		"Looks like they can't navigate through those clouds of smoke.",
	},
    Vek_Frozen = {
		--"Vek is on ice.",
		"Cool off.",
		"I think I've spotted an iceberg...",
	},
    VekKilled_Self = {
		--"One down.",
		"Chalk up another kill for me.",
		"Don't worry, I'm keeping score.",
		"I'm going to take credit for that kill in our post-mission report.",
	},
    VekKilled_Obs = {
		--"Leave the bodies for the scavengers.",
		"Chalk up another kill for #main_full.",
		"I'll give you the credit for that kill in my post-mission report.",
	},
    VekKilled_Vek = {
		--"One down.",
		"Chalk up one for Vek friendly fire.",
		"I'm not sure how I'm supposed to credit that kill in my post-mission report.",
	},

    DoubleVekKill_Self = {
		--"Two for me.",
		"Chalk up two more for me!",
		"I'm going to take credit for those kills in our post-mission report.",
	},
    DoubleVekKill_Obs = {
		--"You're earning your paycheck today.",
		"Chalk up two more for #main_full!",
		"I'll give you the credit for those kills in my post-mission report.",
	},
    DoubleVekKill_Vek = {
		--"They're taking each other out faster than we can engage them!",
		"Chalk up two for Vek friendly fire.",
		"I'm not sure how I'm supposed to credit those kills in my post-mission report.",
		"We're starting to look bad; the Vek are more efficient at killing each other than we are!",
	},

    MntDestroyed_Self = {
		--"Clearing the rubble.",
		"Mountain destroyed.",
		"Let's get this rubble out of the way.",
	},
    MntDestroyed_Obs = {
		--"Clear the rubble.",
		"Mountain destroyed. Nice work, #main_full.",
		"Let's get that rubble out of the way.",
	},
    MntDestroyed_Vek = {
		--"They're clearing the rubble.",
		"Mountain destroyed. The Vek must not care for rocks.",
		"I knew the Vek were good diggers, but to watch them topple mountains...",
	},

    PowerCritical = {
		--"If we lose the Grid, it's all over!",
		"Can't spare another hit to the Grid!",
		"Cutting it a little close here!",
	},
    Bldg_Destroyed_Self = {
		--"That's coming out of my paycheck.",
		"I take full responsibility; I'll notify next of kin after the mission.",
		"That's... that's going to be a lot of paperwork.",
	},
    Bldg_Destroyed_Obs = {
		--"That's coming out of your paycheck.",
		"I trust you did what you had to.",
		"I trust you'll take responsibility for notifying next of kin after the mission.",
	},
    Bldg_Destroyed_Vek = {
		--"Protect the civilians!",
		"The Vek are tearing through those buildings!",
		"Don't let the Vek attack those structures!",
	},
    Bldg_Resisted = {
		--"Got lucky there!",
		"That was statistically unlikely. Don't let the Vek get another hit in!",
		"I can't believe it!",
	},
	
	-- Shared Mission Events
	Mission_Train_TrainStopped = {
		--"Train's been damaged. Protect the cargo!",
		"No way that train's going to be on time now.",
		"If we can keep that train from taking further damage, we can arrange for the cargo to be recovered.",
	},
	Mission_Train_TrainDestroyed = {
		--"Lost the train.",
		"So much for the train, or its cargo.",
		"No way #corp is going to repair that train now.",
	},
	Mission_Block_Reminder = {
		--"Keep those Vek underground, and our jobs will be easier.",
		"Remember, keep the Vek in the dirt.",
		"Don't let them surface!",
	},
	
	-- Archive Mission Events
	Mission_Tanks_Activated = {
		--"Tanks online.",
		"Reinforcements have arrived.",
		"Let's put these tanks to work.",
	},
	Mission_Tanks_PartialActivated = {
		--"One tank made it.",
		"Reinforcements have arrived. Too bad about the other tank...",
		"One tank is better than none.",
	},
	Mission_Satellite_Destroyed = {
		--"Doesn't look like we can salvage that satellite, commander.",
		"No way that satellite is going to launch on schedule.",
		"There goes the rocket, and the payload.",
	},
	Mission_Satellite_Imminent = {
		--"That satellite is about to launch.",
		"Launch commencing! Right on time.",
		"Time to clear the launch pad.",
	},
	Mission_Satellite_Launch = {
		--"Rocket is away!",
		"Right on schedule!",
		"A textbook liftoff!",
	},
	Mission_Dam_Reminder = {
		--"We still need to take out that dam.",
		"We still need to break open that dam and release the waters.",
		"The grass is looking a little dry here; better unleash that dam soon!",
	},
	Mission_Dam_Destroyed = {
		--"Here comes the water!",
		"Brace for a little water!",
		"I love the sound of roaring water!",
	},
	Mission_Mines_Vek = {
		--"The Vek don't seem to understand how mines work.",
		"Was that mine placed there on purpose?",
		"These land mines are a sight more effective than Far Line's naval mines.",
	},
	Mission_Airstrike_Incoming = {
		--"Airstrike inbound.",
		"Archive bomber is on its way with a special package.",
		"Don't be in the drop zone when that bomber drops off its package.",
	},
	
	-- R.S.T. Mission Events
	Mission_Force_Reminder = {
		--"Gotta clear those mountains or the Vek will infest them.",
		"We still have mountains to destroy; if we don't, I'm sure #ceo_full will have some extra paperwork for us to fill out explaining why.",
		"Can't leave those mountains standing for the Vek to turn into hives.",
	},
	Mission_Lightning_Strike_Vek = {
		--"R.S.T. is a weapon itself.",
		"I'd rather deal with a hurricane at sea than live on R.S.T.",
		"R.S.T.'s weather is worse than Far Line in monsoon season.",
	},
	Mission_Terraform_Destroyed = {
		--"Doesn't look like we can salvage that terraformer, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that terraformer...",
		"That's going to impact our mission performance...",
	},
	Mission_Terraform_Attacks = {
		--"Watchtower could use one of those, to clean up the mess the Vek have made.",
		"With one of those, Far Line could make whole new islands! Or accidentally destroy the ones the have...",
		"Every machine R.S.T. makes seems to leave destruction in its wake.",
	},
	Mission_Cataclysm_Falling = {
		--"No coming back from a trip to that underworld.",
		"How deep IS that pit?",
		"Watch out, unstable terrain!",
	},
	Mission_Solar_Destroyed = {
		--"Doesn't look like we can salvage that solar panel, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that solar panel...",
		"That's going to impact our mission performance...",
	},
	
	-- Pinnacle Mission Events
	BotKilled_Self = {
		--"One less hostile bot.",
		"Does Zenith want us to document each of these robots that we destroy?",
		"Is there a form I need to fill out after blowing that up?",
	},
	BotKilled_Obs = {
		--"One less hostile bot.",
		"Does Zenith want us to document each of these robots that we destroy?",
		"One less distraction.",
	},
	Mission_Factory_Destroyed = {
		--"Doesn't look like we can salvage that factory, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that factory...",
		"That's going to impact our mission performance...",
	},
	Mission_Factory_Spawning = {
		--"Zenith really needs to get her priorities straight; these things are a menace.",
		"How are those factories still spitting out these hostile machines? Can't Pinnacle cut off their resources?",
		"Like clockwork. Could we get a factory that makes helpful bots?",
	},
	Mission_Reactivation_Thawed = {
		--"That ice isn't holding them!",
		"I guess even now, the planet is still warming.",
		"More company just showed up out of the ice.",
	},
	Mission_Freeze_Mines_Vek = {
		--"That should stop it for a while.",
		"That stopped it in its tracks.",
		"These ice mines are a sight more effective than Far Line's naval mines.",
	},
	Mission_SnowStorm_FrozenVek = {
		--"That should stop it for a while.",
		"That stopped the Vek in their tracks.",
		"This is why Far Line's ships hate making runs to Pinnacle, at least without an icebreaker leading the way.",
	},
	Mission_SnowStorm_FrozenMech = {
		--"I can't move!",
		"This ice has locked up all my #self_mech's actuators!",
		"This is why I hate visiting Pinnacle.",
	},
	
	-- Detritus Mission Events
	Mission_Barrels_Destroyed = {
		--"I'll drink to that.",
		"Can't believe Detritus is willingly polluting their land to such an extent; things must be dire.",
		"The lesser of two evils, I suppose.",
	},
	Mission_Disposal_Destroyed = {
		--"Doesn't look like we can salvage that disposal unit, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that disposal unit...",
		"That's going to impact our mission performance...",
	},
	Mission_Disposal_Disposal = {
		--"Nothing is going to be left standing after that.",
		"I'll stand back here.",
		"Don't get too close.",
	},
	Mission_Power_Destroyed = {
		--"Doesn't look like we can salvage that power plant, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that power plant...",
		"That's going to impact our mission performance...",
	},
	Mission_Belt_Mech = {
		--"Here we go!",
		"I go where the current takes me. Or the conveyor belt.",
		"Just like floating down a river.",
	},
	Mission_Teleporter_Mech = {
		--"Here we go!",
		"I go where the current takes me. Or the teleporter.",
		"Far Line would kill for a few teleporters to help with its shipments.",
	},
	
	-- Meridia Mission Events
	Mission_lmn_Convoy_Destroyed = {
		--"Doesn't look like we can salvage that vehicle, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that truck...",
		"That's going to impact our mission performance...",
	},
	Mission_lmn_FlashFlood_Flood = {
		--"Here comes high tide.",
		"Water's rising; just like high tide back on Far Line.",
		"Here comes the flood!",
	},
	Mission_lmn_Geyser_Launch_Mech = {
		--"That's a lot of pressure!",
		"Watch for those geysers, or push the Vek into them!",
		"Just like a waterspout on the ocean.",
	},
	Mission_lmn_Geyser_Launch_Vek = {
		--"That's a lot of pressure!",
		"That warms my heart to see.",
		"Just like a waterspout on the ocean.",
	},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {
		--"That should give the Vek something to think about.",
		"That warms my heart to see.",
		"Meridia's geologists must stay busy, tracking all this volcanic activity.",
	},
	Mission_lmn_Wind_Push = {
		--"Storm on the horizon!",
		"This wind is almost a hurricane!",
		"Rough weather ahead!",
	},
	
	Mission_lmn_Runway_Imminent = {
		--"Stay clear of that runway, #squad.",
		"Takeoff commencing! Right on time.",
		"Time to clear the runway.",
	},
	Mission_lmn_Runway_Crashed = {
		--"Doesn't look like we can salvage that aircraft, commander.",
		"No way that plane is going to arrive on schedule...",
		"There goes the plane, and the payload.",
	},
	Mission_lmn_Runway_Takeoff = {
		--"Aircraft away.",
		"Right on schedule!",
		"A textbook takeoff!",
	},
	Mission_lmn_Greenhouse_Destroyed = {
		--"Doesn't look like we can salvage that greenhouse, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that greenhouse...",
		"That's going to impact our mission performance...",
	},
	Mission_lmn_Geothermal_Plant_Destroyed = {
		--"Doesn't look like we can salvage that geothermal unit, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that geothermal plant...",
		"That's going to impact our mission performance...",
	},
	Mission_lmn_Hotel_Destroyed = {
		--"Doesn't look like we can salvage that hotel, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that hotel...",
		"That's going to impact our mission performance...",
	},
	Mission_lmn_Agroforest_Destroyed = {
		--"Doesn't look like we can salvage that agroforest, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that agroforest...",
		"That's going to impact our mission performance...",
	},
	
-- tosx missions
	-- Island missions
	Mission_tosx_Juggernaut_Destroyed = {
		--"Doesn't look like we can salvage that Juggernaut unit, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that Juggernaut...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_Juggernaut_Ram = {
		--"Don't mess with that sphere.",
		"I'm almost glad this is the last of the Juggernaut units.",
		"Does Pinnacle regulate these Juggernaut units? I hope so, with all the destruction they cause.",
	},
	Mission_tosx_Zapper_On = {
		--"I've got an electrical heartbeat here.",
		"Lights are on.",
		"Bring on the lightning.",
	},
	Mission_tosx_Zapper_Destroyed = {
		--"Doesn't look like we can salvage that storm tower, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that Storm Tower...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_Warper_Destroyed = {
		--"Doesn't look like we can salvage that portal tender, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that aircraft...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_Battleship_Destroyed = {
		--"Doesn't look like we can salvage that ship, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that battleship...",
		"That's going to impact our mission performance...",
	},
	
	-- Island missions 2
	Mission_tosx_Siege_Now = {
		--"Now the fun begins.",
		"We're drowning in Vek signatures!",
		"It's like an ocean of Vek.",
	},
	Mission_tosx_Plague_Spread = {
		--"Stand clear, #squad!",
		"Don't get too close!",
		"I'm going to file a health and safety complaint form as soon as we get back to the hangar.",
	},
	
	-- AE
	Mission_ACID_Storm_Start = {
		--"This place is soaking in A.C.I.D. Let's help them with that.",
		"So even the rain here will melt your skin off. Great.",
		"This is why no one vacations at Detritus.",
	},	
	Mission_ACID_Storm_Clear = {
		--"Weather is clearing.",
		"Well, that's a bit of an improvement.",
		"Sky's clearing up.",
	},	
	Mission_Wind_Mech = {
		--"Storm on the horizon!",
		"This wind is almost a hurricane!",
		"Rough weather ahead!",
	},	
	Mission_Repair_Start = {
		--"So now we have to fix our own Mechs?",
		"I can't believe no one requisitioned proper parts to keep our Mechs in fighting shape.",
		"I'm not sure I'm qualified to work these repair platforms. Am I?",
	},	
	Mission_Hacking_NewFriend = {
		--"Another ally for the cause.",
		"At last, a friendly robot!",
		"That's better; now it's on our side.",
	},	
	Mission_Shields_Down = {
		--"Shields are down!",
		"Every shield is coming down, all at once!",
		"Get ready, we don't have those shields anymore!",
	},
	
	-- Final
	MissionFinal_Start = {
		--"This place has even less Grid support than Watchtower. What are we supposed to power our Mechs with?",
		"This place is even more remote than Far Line's outlying islands. And with even less connection to the Grid.",
	},
	MissionFinal_StartResponse = {
		--"I see the pylons inbound. Ready for Grid connection.",
		"I see the pylons. Let's link up to the Grid.",
	},
	MissionFinal_FallResponse = {
		--"What's happening?!",
		"Some kind of earthquake?",
	},
	MissionFinal_Bomb = {
		--"Even Akai's nukes wouldn't make a scratch on this place. It's huge!",
		"No way we're equipped to take on something like this.",
	},
	MissionFinal_CaveStart = {
		--"Time to earn our last paycheck. Protect that bomb, #squad.",
		"Forget the forms and timetables; just protect the bomb and try to survive.",
	},
	MissionFinal_BombArmed = {
		--"We did it. Mission accomplished.",
		"I think we made it.",
	},
	
	-- Watchtower missions
	Mission_tosx_Sonic_Destroyed = {
		--"Doesn't look like we can salvage that Disruptor, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that Disruptor...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_Tanker_Destroyed = {
		--"Doesn't look like we can salvage that tanker, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that tanker...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_Rig_Destroyed = {
		--"Doesn't look like we can salvage that War Rig, commander.",
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that War Rig...",
		"That's going to impact our mission performance...",
	},
	Mission_tosx_GuidedKill = {
		--"Looks like that targeting data was spot on.",
		"That's unnerving, standing in the middle of all those missiles.",
		"Watchtower had better not hit one of our Mechs.",
	},
	Mission_tosx_NuclearSpread = {
		--"This corporation never had the highest safety standards.",
		"Another radiation spike!",
		"Radiation levels are still on the rise! Is anyone documenting this?",
	},
	Mission_tosx_RaceReminder = {
		--"I've got a huge wager riding on the lead car. Let's make sure it reaches the far side of the sector, with no competition in sight!",
		"Fixing the outcome of a backwater race feels like misuse of resources. But it's in our formal mission objectives, so I can't argue.",
	},
	Mission_tosx_MercsPaid = {
		--"Looks like those mercenaries are willing to do business!",
		"Goods have been delivered, and the mercenaries are now gearing up help us in return.",
	},
	Mission_tosx_RigUpgraded = {
		--"That's Watchtower ingenuity right there.",
		"That Rig has upgraded itself. I trust its mechanics are qualified for this?",
		"I see Watchtower takes their gear wherever they can find it.",
	},

--FarLine barks
	Mission_tosx_Delivery_Destroyed = {
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that shipment...",
		"That's going to impact our mission performance...",
		"Jansson is going be livid, losing that shipment so close to its destination.",
	},
	Mission_tosx_Sub_Destroyed = {
		"We're going to have some paperwork to fill out after this mission, explaining how we lost a Far Line submarine...",
		"That's going to impact our mission performance...",
		"The archipelago is going to suffer without that sub defending its coastlines...",
	},
	Mission_tosx_Buoy_Destroyed = {
		"We're going to have some paperwork to fill out after this mission, explaining how we lost that buoy...",
		"That's going to impact our mission performance...",
		"The Far Line fleet isn't going to be happy to lose one of its navigation buoys, especially in these waters.",
	},
	Mission_tosx_Rigship_Destroyed = {
		"We're going to have some paperwork to fill out after this mission, explaining how we lost a Far Line vessel...",
		"That's going to impact our mission performance...",
		"We're not going to have anywhere to fight if we can't protect those construction ships.",
	},
	Mission_tosx_SpillwayOpen = {
		"Manual valve operation successful. Get ready for outlet flow.",
		"Spillway hatch is open, and readings indicate water is being piped to this outlet now.",
		"Venting floodwaters to this location. Get ready.",
	},
	Mission_tosx_OceanStart = {
		"No land in sight... better keep a weather eye on those ships, and use the platforms they create to launch our attacks.",
		"I'm used to seeing the open ocean from a boat; it's a bit different in a Mech.",
		"I hope those ships can build some new deepwater platforms quickly, or we'll have nowhere to stand and fight.",
	},
	Mission_tosx_RTrain_Destroyed = {
		"That takes care of the train.",
		"Jansson won't be thrilled to have one of her cargo trains destroyed, but I suppose it's better than having it derail in a city.",
	},
}