
return {
	--Game States
	Gamestart = {"I'm used to hunting machines; these Vek should be interesting.","I'm not going to stop until I learn what caused this invasion... but we have to survive it first."},
	FTL_Found = {"Aren't you a strange one."},
	FTL_Start = {},
	Gamestart_PostVictory = {"One more go.","Let's hope this timeline goes as well as the last.","Each of these timelines is another chance to find the cause of this invasion."},
	Death_Revived = {"Well, it's good to be back.","It's going to take more than that to kill me."},
	Death_Main = {"I... underestimated y-","Clever girl."},
	Death_Response = {"No!","We lost #main_first"},
	Death_Response_AI = {"Lost one of our machines.","Guess it's up to us now."},
	TimeTravel_Win = {"We did it.","This world will survive."},
	Gameover_Start = {"This world is doomed.","I don't see a way out of this one."},
	Gameover_Response = {"Leave this world to the beasts and the machines.","There are still other timelines we can save."},
	
	-- UI Barks
	Upgrade_PowerWeapon = {"Okay.","Looks good.","Very nice.","Not quite my style, but I'll learn how to use it."},
	Upgrade_NoWeapon = {"At least give me a pointy stick.","What have you got for me?","I can't hunt without a weapon.","Hey. Even outcasts get weapons."},
	Upgrade_PowerGeneric = {"This should do it.","These machines can... evolve.","Let's see how this works..."},
	
	-- Mid-Battle
	MissionStart = {"Good hunting.","We can't let them break through here."},
	Mission_ResetTurn = {"That was weird.","Didn't we do this already?"},
	MissionEnd_Dead = {"We've cleared out all the Vek.","This area is clear."},
	MissionEnd_Retreat = {"A few of the Vek escaped.","Those Vek won't trouble us anymore."},

	MissionFinal_Start = {"A volcano? Huh.","Watch out for lava."},
	MissionFinal_StartResponse = {"Linking to the Grid through the pylons.","Grid link established. Those pylons seem to be working."},
	MissionFinal_FallStart = {},
	MissionFinal_FallResponse = {"Here we go.","Maybe we'll find some answers down there."},
	MissionFinal_Pylons = {},
	MissionFinal_Bomb = {"This place is... massive.","So many of them."},
	MissionFinal_BombResponse = {},
	MissionFinal_CaveStart = {"Protect that bomb.","We'll buy as much time as we can."},
	MissionFinal_BombDestroyed = {},
	MissionFinal_BombArmed = {"Time to go.","We made it."},

	PodIncoming = {"Detecting an inbound Time Pod.","Atmospheric analysis shows something coming..."},
	PodResponse = {"I see it.","Might be something useful in there."},
	PodCollected_Self = {"I salvaged what I could.","You're coming with me."},
	PodDestroyed_Obs = {"The Pod didn't survive.","Guess we'll have to try harder to save the next one."},
	Secret_DeviceSeen_Mountain = {"I'm detecting something in that rubble."},
	Secret_DeviceSeen_Ice = {"I'm detecting something in the water."},
	Secret_DeviceUsed = {"Not sure what that did..."},
	Secret_Arriving = {"Detecting a new machine... some variant of a Time Pod?"},
	Emerge_Detected = {"Here they come.","Vek, coming up from beneath the soil!","I'm detecting more Vek underground."},
	Emerge_Success = {"More Vek. Great.","... so many of them."},
	Emerge_FailedMech = {"Not so fast.","Oof.","They can't get past me."},
	Emerge_FailedVek = {"They're piling up.","Their reinforcements are stuck underground!"},

	-- Mech State
	Mech_LowHealth = {"My Mech is falling apart!","This machine won't last much longer!"},
	Mech_Webbed = {"Well, this is perfect.","This Vek has me tied down."},
	Mech_Shielded = {"Good, a shield.","Good. That should help."},
	Mech_Repaired = {"Just need to make a few quick repairs.","Let me fix a few things..."},
	Pilot_Level_Self = {"I'm getting more skilled at this.","Have I proven myself yet?"},
	Pilot_Level_Obs = {"You're getting more skilled at this.","Impressive."},
	Mech_ShieldDown = {"Well, there goes my shield.","Guess I can't rely on that shield any further."},

	-- Damage Done
	Vek_Drown = {"They don't swim very well.","That works."},
	Vek_Fall = {"They don't fly very well.","That works.","Back where you came from."},
	Vek_Smoke = {"That should keep you from attacking.","This one's disabled. Should buy some time."},
	Vek_Frozen = {"Vek is frozen.","That'll slow it down."},
	VekKilled_Self = {"Got one.","You're mine.","Sorry, big guy."},
	VekKilled_Obs = {"A clean kill.","You've been practicing."},
	VekKilled_Vek = {"They're killing each other.","Did that one get turned to our side somehow?"},

	DoubleVekKill_Self = {"Two down.","You're mine."},
	DoubleVekKill_Obs = {"Nice work.","You've been practicing.","Nice work over there."},
	DoubleVekKill_Vek = {"That one's going on a rampage.","Their behavior doesn't make a lot of sense."},

	MntDestroyed_Self = {"Mountain destroyed.","Saves me from having to climb it."},
	MntDestroyed_Obs = {"Mountain destroyed.","For a moment, I thought that was an earthquake."},
	MntDestroyed_Vek = {"The Vek are destroying the mountains... but why?","Are they looking for something in those rocks?"},

	PowerCritical = {"Almost out of power here.","We can't let them overrun the Grid."},
	Bldg_Destroyed_Self = {"Sorry about that.","Sometimes... the individual is less important than the tribe."},
	Bldg_Destroyed_Obs = {"Be careful over there.","There are people in there!"},
	Bldg_Destroyed_Vek = {"Can't let them get away with that.","We have to stop them from rampaging through the cities.","We have to put these things down."},
	Bldg_Resisted = {"That was lucky.","Someone is looking out for us."},


	-- Shared Missions
	Mission_Train_TrainStopped = {"The train took damage; we can still save it.","We can still salvage those supplies if we keep the Vek away."},
	Mission_Train_TrainDestroyed = {"The train was destroyed.","We're too late to save the train."},
	Mission_Block_Reminder = {"We need to stop more Vek from emerging.","Block their tunnels!"},

	-- Archive
	Mission_Airstrike_Incoming = {"Airstrike incoming.","One of their flying machines is on its way; don't get caught in its fire."},
	Mission_Tanks_Activated = {"Those little machines are online.","Those Old Earth machines are ready for battle."},
	Mission_Tanks_PartialActivated = {"That little machine is online.","That Old Earth machine is ready for battle."},
	Mission_Dam_Reminder = {"We still need to blow that dam.","We need to destroy that dam before we're overrun."},
	Mission_Dam_Destroyed = {"That did it.","Don't get swept away by the water."},
	Mission_Satellite_Destroyed = {"We lost one of the rockets.","That's not good."},
	Mission_Satellite_Imminent = {"Looks like it's ready for launch.","Detecting a heat spike; seems that machine is powering up for launch."},
	Mission_Satellite_Launch = {"That was impressive.","There goes the satellite."},
	Mission_Mines_Vek = {"We're going to need more traps.","That got it."},

	-- RST
	Mission_Terraform_Destroyed = {"The terraformer was destroyed.","We're too late to save the terraformer."},
	Mission_Terraform_Attacks = {"Okay, stay out of its way. Got it.","In my timeline, these machines wiped out the Vek... and us."},
	Mission_Cataclysm_Falling = {"Watch your footing.","... that works."},
	Mission_Lightning_Strike_Vek = {"Glad that wasn't me.","All-mother must be angry."},
	Mission_Solar_Destroyed = {"One of the solar panels was destroyed.","We're too late to save those solar panels."},
	Mission_Force_Reminder = {"Still need to destroy those mountains.","We have to level those mountains."},

	-- Pinnacle
	Mission_Freeze_Mines_Vek = {"We're going to need more ice traps.","That got it.","Almost as effective as the exploding traps."},
	Mission_Factory_Destroyed = {"That factory was destroyed.","We're too late to save the factory.","Won't be any more machines coming out of there..."},
	Mission_Factory_Spawning = {"More feral machines.","My timeline was overrun by these guys."},
	Mission_Reactivation_Thawed = {"Looks like the ice didn't hold.","They're thawing out fast..."},
	Mission_SnowStorm_FrozenVek = {"Nice weather we're having.","They're not adapted to the cold."},
	Mission_SnowStorm_FrozenMech = {"Just perfect.","Guess I better start chipping away at this ice."},
	BotKilled_Self = {"Sorry, little one.","Can't leave these possessed machines running around."},
	BotKilled_Obs = {"A clean kill.","Can't leave these possessed machines running around."},

	-- Detritus
	Mission_Disposal_Destroyed = {"The launcher was destroyed.","We're too late to save the A.C.I.D. launcher."},
	Mission_Disposal_Activated = {"Okay, stay out of its way. Got it.","That thing could defend a city practically on its own."},
	Mission_Barrels_Destroyed = {"What a mess.","We've ruptured the cannisters."},
	Mission_Power_Destroyed = {"The power plant was destroyed.","We're too late to save the power station."},
	Mission_Teleporter_Mech = {"That's a strange sensation.","These machines... are just used to move trash?"},
	Mission_Belt_Mech = {"Moving along.","Guess I'm going for a ride."},
	
	-- Meridia
	Mission_lmn_Convoy_Destroyed = {"One of the trucks was just destroyed.","We're too late to save that truck."},
	Mission_lmn_FlashFlood_Flood = {"Flash flood!","Good thing these creatures can't swim."},
	Mission_lmn_Geyser_Launch_Mech = {"Whoa!","Didn't realize that geyser was active."},
	Mission_lmn_Geyser_Launch_Vek = {"That geyser just blasted a Vek.","So long."},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {"I should probably stay out of those vents.","Maybe we can lure more of them into the vents."},
	Mission_lmn_Wind_Push = {"Can't hold my position!","The storm is picking up again."},
	Mission_lmn_Runway_Imminent = {"That flying machine is about to launch.","We need to clear a path for that flying machine."},
	Mission_lmn_Runway_Crashed = {"One of the flying machines was just destroyed.","We're too late to save that flying machine."},
	Mission_lmn_Runway_Takeoff = {"That flying machine is on its way.","They made it."},
	Mission_lmn_Greenhouse_Destroyed = {"The greenhouse was destroyed.","We're too late to save the greenhouse."},
	Mission_lmn_Geothermal_Plant_Destroyed = {"The geothermal plant was destroyed.","We're too late to save the geothermal plant."},
	Mission_lmn_Hotel_Destroyed = {"The hotel was destroyed.","We're too late to save the hotel."},
	Mission_lmn_Agroforest_Destroyed = {"The agroforest was destroyed.","We're too late to save the agroforest."},

	-- Special
	Pilot_Skill_Aloy = {"Analyzing.","Scanning for weaknesses.","Analyzing enemy for weak points.","Scanning for vulnerabilities."},
	
	-- Island missions
	Mission_tosx_Juggernaut_Destroyed = {
		"That giant machine didn't last very long.",
		"Rest easy, big guy.",
	},
	Mission_tosx_Juggernaut_Ram = {
		"Okay, stay out of the way of THAT.",
		"What a mess.",
	},
	Mission_tosx_Zapper_On = {
		"That should do it.",
		"Looks like that did something.",
	},
	Mission_tosx_Zapper_Destroyed = {
		"The tower is gone.",
		"So much for that storm tower.",
	},
	Mission_tosx_Warper_Destroyed = {
		"Our little friend didn't make it.",
		"That flyer just went down.",
	},
	Mission_tosx_Battleship_Destroyed = {
		"That ship cracked like an egg.",
		"That watercraft is lost.",
	},
	
	-- Island missions 2
	Mission_tosx_Siege_Now = {
		"Get ready, here they come.",
		"They're swarming us.",
	},
	Mission_tosx_Plague_Spread = {
		"I shouldn't get too close to that thing.",
		"Probably safer to stay away from that plaguebearer.",
	},
	
	-- AE
	Mission_ACID_Storm_Start = {
		"We need to halt this storm.",
		"This rain is eating through metal.",
	},	
	Mission_ACID_Storm_Clear = {
		"Storm's clearing up.",
		"That's better.",
	},	
	Mission_Wind_Mech = {
		"These winds are causing havoc.",
		"I've never seen winds so fierce.",
	},	
	Mission_Repair_Start = {
		"Better find some way to repair our Mechs.",
		"These machines need an overhaul.",
	},	
	Mission_Hacking_NewFriend = {
		"That machine's no longer being overridden.",
		"That machine shouldn't be hostile any more.",
	},	
	Mission_Shields_Down = {
		"All those energy shields just... disappeared.",
		"Taking out that device has deactivated all the shields.",
	},
	
	-- Watchtower
	Mission_tosx_Sonic_Destroyed = {
		"The tower is gone.",
		"So much for that scrambler tower.",
	},
	Mission_tosx_Tanker_Destroyed = {
		"Our tanker friend didn't make it.",
		"That machine just went down.",
	},
	Mission_tosx_Rig_Destroyed = {
		"Our little friend didn't make it.",
		"That machine just went down.",
	},
	Mission_tosx_GuidedKill = {
		"Impressive aim.",
	},
	Mission_tosx_NuclearSpread = {
		"That looks dangerous. Better stay clear.",
	},
	Mission_tosx_RaceReminder = {
		"So these people race for sport? I like the sound of that. But I guess today I have to ruin their fun.",
	},
	Mission_tosx_MercsPaid = {
		"Those traders got what they wanted; in return they're going to help us fight.",
	},
	Mission_tosx_RigUpgraded = {
		"I see. They're scavenging components from those dead machines, to improve their own.",
	},
	
	--Far Line
	Mission_tosx_Delivery_Destroyed = {
		"Those supplies didn't make it.",
		"What a waste.",
	},
	Mission_tosx_Sub_Destroyed = {
		"Our underwater friend didn't make it.",
		"That machine just went down.",
	},
	Mission_tosx_Buoy_Destroyed = {
		"That navigation marker just sank.",
		"That marker just went down.",
	},
	Mission_tosx_Rigship_Destroyed = {
		"Our swimming friend didn't make it.",
		"That machine just went down.",
	},
	Mission_tosx_SpillwayOpen = {
		"Looks like water's about to start flowing.",
	},
	Mission_tosx_OceanStart = {
		"Well, this is a new way to fight. I hope my machine can handle it.",
	},
    
    --Vertex
    Mission_tosx_Scoutship_Destroyed = {
		"Our flying friend didn't make it.",
		"That machine just went down.",
    },
    Mission_tosx_Beamtank_Destroyed = {
		"Our crystal-breaker didn't make it.",
		"That machine just went down.",
    },
    Mission_tosx_Phoenix_Destroyed = {
		"That mechanical altar didn't make it.",
		"That structure just went down.",
    },
    Mission_tosx_Exosuit_Destroyed = {
		"Our little friend didn't make it.",
		"That machine just went down.",
    },
    Mission_tosx_Retracter_Destroyed = {
		"That energy tower didn't make it.",
		"That structure just went down.",
    },
    Mission_tosx_Halcyte_Destroyed = {
        "Crystal destroyed."
        "Not as challenging as hunting monsters or machines."
    },
    Mission_tosx_Retracting = {
        "That should do it. The tower is headed underground.",
    },
    Mission_tosx_MeltingDown = {
        "Better take out the structure, quickly.",
        "Those explosions are getting stronger.",
    },
    Mission_tosx_CrysGrowth = {
        "We'll have to maneuver carefully around these crystals.",
    },
}