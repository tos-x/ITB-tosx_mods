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
		"While I do not understand how I now see the Grid before me, restored, I will not fail it a second time!",
		"I should not be alive when the Grid has failed, but I suppose that hasn't happened in this timeline. And I will not allow it to!",
	},
    FTL_Found = {
		--"I've never seen tech like that before.",
		"By the Grid, what is that? Certainly nothing from Vertex.",
	},
    FTL_Start = {
		--"I don't know who or what that is. But put it in a Mech and point it at the Vek.",
		"Though I can't understand its words, I believe it wishes to answer the call of the Grid, like the rest of us.",
	},
    Gamestart_PostVictory = {
		--"Another timeline. New weapons. Same threat.",
		"Another Grid, another change to serve! It will power our Mechs to victory, once again.",
		"The Grid prevailed once, it can do so again. I will see it saved in every timeline!",
		"New Mechs, same Grid. Once again it empowers us, to drive the Vek out of every timeline!",
	},
    Death_Revived = {
		--"Back in action.",
		"Thank the Grid! I thought that was the end of my service.",
		"Another chance! I will not fail this time.",
	},
    Death_Main = {
		--"#self_second, going down!",
		"My #self_mech is going critical!",
		"Defenses are failing! I can't-",
        "This is it for me! It has been an honor!",
	},
    Death_Response = {
		--"#main_second just bit it!",
		"#main_second knew the risks of being a Pilot. They'd want us to carry one.",
		"May you return to the Grid, Pilot #main_second.",
		"It was an honor serving with you, Pilot #main_second.",
	},
    Death_Response_AI = {
		--"Lost a #main_mech.",
		"Artificial or not, the Grid has lost a faithful servant.",
		"That #main_mech is offline! Thank the Grid there wasn't a Pilot inside.",
	},
    TimeTravel_Win = {
		--"The job's never done.",
		"The Grid is safe, in this timeline. My service to it will continue in another.",
		"It was a great honor to serve with you all, #squad.",
	},
    Gameover_Start = {
		--"We tried. We failed.",
		--"No coming back from this.",
		--"We'll have to learn from our failures and try harder; open a Breach.",
		"I... I can't believe it. The Grid... it's gone.",
		"No! It cannot be! We've lost the Grid!",
	},
    Gameover_Response = {
		--"Jumping to a new timeline. I'm sure they'll have a use for my experience.",
		"We can still serve the Grid in other timelines. Prepare a breach!",
		"So many Grids, lost to the Vek. I pray the next timeline will see it victorious!",
	},
    
    -- UI Barks
    Upgrade_PowerWeapon = {
		--"Give me the best you've got.",
		"What manner of weapon is this?",
		"I'll use any tool you can give me, to defend the Grid.",
	},
    Upgrade_NoWeapon = {
		--"Give me something.",
		"Can't defend the Grid without some form of weapon, can I?",
		"Is this a joke? My #self_mech needs a weapon!",
	},
    Upgrade_PowerGeneric = {
		--"Maximum power.",
		"This energy has a different... flavor, from that of Vertex. Does that make sense? I guess not.",
		"Power levels increasing.",
        "Nothing like the hum of an energy core powering up.",
	},
    
    -- Mid-Battle
    MissionStart = {
		--"Here we go.",
		"Let's do this!",
		"Prepare to defend the Grid with everything you've got, #squad.",
		"Awaiting orders, commander!",
        "Grid connection established. I can feel its power coursing through my #self_mech!",
	},
    Mission_ResetTurn = {
		--"That was weird.",
		"Anyone care to explain how those localized breaches actually work? Or will that just make this headache worse.",
		"Let's try that again!",
	},
    MissionEnd_Dead = {
		--"This sector has a clean bill of health.",
		"Every threat to the Grid has been neutralized!",
		"This sector is clear!",
	},
    MissionEnd_Retreat = {
		--"Look at them run.",
		"I hope those fleeing Vek remember us, next time we meet. Maybe they'll run away again!",
		"I guess we don't want to kill them all. What would we use for target practice tomorrow?",
	},

    PodIncoming = {
		--"Time Pod on my scope!",
		"By the Grid! What's that in the sky?",
		"Is that a Time Pod? Sure looks like it, on my sensors.",
	},
    PodResponse = {
		--"I see it!",
		"I wonder what kind of help the future sent us.",
		"Better double-time over there and secure that Pod.",
	},
    PodCollected_Self = {
		--"Mine now.",
		"I've secured this Time Pod.",
		"Time Pod retrieved. Sounds like there's some kind of energy core inside!",
	},
    PodDestroyed_Obs = {
		--"A war can't be won without weapons.",
		"We'll never know what was inside it, now.",
		"I hope there wasn't anyone in there!",
        "Letting that Pod be destroyed seems downright wasteful!",
	},
    Secret_DeviceSeen_Mountain = {
		--"Got a strange reading from that mountain.",
		"I'm getting a very unusual energy signature from those mountains. And I know my energy signatures!",
	},
    Secret_DeviceSeen_Ice = {
		--"Got a strange reading from under that ice.",
		"I'm getting a very unusual energy signature from that ice floe. And I know my energy signatures!",
	},
    Secret_DeviceUsed = {
		--"Okay, let's see what happens next.",
		"Was that... some kind of beacon? I think I activated it.",
	},

    Secret_Arriving = {
		--"Never seen a Pod like that!",
		"By the Grid! Is that a spaceship or a Time Pod!?",
	},
    Emerge_Detected = {
		--"More Vek are burrowing up.",
		"I can feel the ground shaking. More Vek must be tunneling toward us!",
		"Brace yourselves. We're about to have more company!",
	},
    Emerge_Success = {
		--"New Vek on the field.",
		"New threats on the board. Inform corporate, and keep defending the Grid!",
		"More Vek! Can't make it too easy on us, can they?",
	},
    Emerge_FailedMech = {
		--"I got this one locked down.",
		"That's one way to keep the Grid safe!",
		"A few scratches seems worth it, to keep these Vek buried!",
	},
    Emerge_FailedVek = {
		--"They're piled on top of each other.",
		"Not so threatening when they pile on top of each other.",
		"They can't get past each other! Wonderful.",
	},

    -- Mech State
    Mech_LowHealth = {
		--"Getting real low here.",
		"My #self_mech has plenty of power, but it's getting low on hull integrity.",
		"My #self_mech feels like it's starting to fall apart!",
		"I'm still good to go! It'll take more than that.",
	},
    Mech_Webbed = {
		--"Can't move!",
		"Can't seem to get any traction against this webbing!",
		"My options just got a lot narrower!",
        "This stuff is all over me!",
	},
    Mech_Shielded = {
		--"Shield active.",
		"Energy barrier is up!",
		"We protect the Grid, now the Grid protects us!",
        "These shields are much more reliable than the Grid's energy defenses!",
	},
    Mech_Repaired = {
		--"That's an improvement.",
		"Hull strength is looking better!",
		"Defensive options are increasing!",
	},
    Pilot_Level_Self = {
		--"That's how it's done.",
		"Don't bother with a medal or anything. I do it to protect the Grid!",
		"I guess I've stayed alive long enough to learn a few new tricks, huh?",
	},
    Pilot_Level_Obs = {
		--"Not bad.",
		"Your service to the Grid is admirable, #main_second!",
		"I guess you've stayed alive long enough to learn a few new tricks, huh?",
	},
    Mech_ShieldDown = {
		--"Shield is down.",
		"Energy barrier is down!",
		"That shield kept me alive!",
		"I'll miss the hum of that energy shield.",
	},

    -- Damage Done
    Vek_Drown = {
		--"Take a swim.",
		"All's fair when dealing with the Vek.",
		"Another threat to the Grid, neutralized!",
        "For the Grid!",
	},
    Vek_Fall = {
		--"Over the edge with you.",
		"All's fair when dealing with the Vek.",
        "Down you go, where you can't bother anyone.",
	},
    Vek_Smoke = {
		--"This should blind it.",
		"All's fair when dealing with the Vek.",
		"Let's see them attack the Grid if they can't actually see!",
		"The Vek don't seem to be able to fight in this smoke!",
	},
    Vek_Frozen = {
		--"Vek is on ice.",
		"All's fair when dealing with the Vek.",
		"That one shouldn't be thawing any time soon.",
		"The Vek aren't much of a threat, once they're frozen!",
	},
    VekKilled_Self = {
		--"One down.",
		"Another threat to the Grid, neutralized!",
		"My #self_mech claims another victim!",
        "For the Grid!",
	},
    VekKilled_Obs = {
		--"Leave the bodies for the scavengers.",
		"Another threat to the Grid, neutralized!",
		"Nicely done!",
		"I couldn't have done better, #main_second!",
	},
    VekKilled_Vek = {
		--"One down.",
		"Are these Vek actually a threat to the Grid?",
		"Let them kill each other! Saves us the trouble.",
	},

    DoubleVekKill_Self = {
		--"Two for me.",
		"Two more threats to the Grid, neutralized!",
		"Doesn't get much better than that!",
		"I've got this!",
	},
    DoubleVekKill_Obs = {
		--"You're earning your paycheck today.",
		"Two more threats to the Grid, neutralized!",
		"Your service is a credit to the Grid, #main_second!",
		"Outstanding performance, #main_second!",
	},
    DoubleVekKill_Vek = {
		--"They're taking each other out faster than we can engage them!",
		"No way these Vek are actually a threat to the Grid!",
		"Let them kill each other! They're certainly good at it!.",
	},

    MntDestroyed_Self = {
		--"Clearing the rubble.",
		"Let's break this down!",
		"Mountain has fractured.",
	},
    MntDestroyed_Obs = {
		--"Clear the rubble.",
		"Yes, break it down!",
		"Well done. The field is clear.",
	},
    MntDestroyed_Vek = {
		--"They're clearing the rubble.",
		"Better to see the Vek focusing on the landscape, than attacking the Grid...",
		"Looks like these Vek are into landscaping.",
	},

    PowerCritical = {
		--"If we lose the Grid, it's all over!",
		"Can you feel the adrenaline? This is the hour! The Grid has never needed us more!",
		"We cannot let the Grid take one more hit! We will not!",
	},
    Bldg_Destroyed_Self = {
		--"That's coming out of my paycheck.",
		"I am sorry. To those citizens, to the Grid. I didn't see another way.",
		"I never thought it would come to this.",
	},
    Bldg_Destroyed_Obs = {
		--"That's coming out of your paycheck.",
		"Hold fire!",
		"What are you doing?! We must protect the Grid, and these people!",
	},
    Bldg_Destroyed_Vek = {
		--"Protect the civilians!",
		"We must protect the Grid, and these people!",
		"Defend the Grid! Without it, we all die!",
		"We cannot leave the Grid open to attack!",
	},
    Bldg_Resisted = {
		--"Got lucky there!",
		"By Salazar! The Grid is aiding in its own defense!",
		"If the Grid could do that reliably, it wouldn't need us!",
	},
	
	-- Shared Mission Events
	Mission_Train_TrainStopped = {
		--"Train's been damaged. Protect the cargo!",
		"That train's been derailed, but we can still defend it from the Vek. Maybe someone inside survived!",
		"There may be survivors or salvage aboard that train; don't let it get hit again!",
	},
	Mission_Train_TrainDestroyed = {
		--"Lost the train.",
        "Doesn't look like that train survived!",
        "Nothing much left of that train now.",
	},
	Mission_Block_Reminder = {
		--"Keep those Vek underground, and our jobs will be easier.",
		"Check your scanners for Vek tunnels, and try to block the openings before they emerge!",
		"If we don't let the Vek onto the battlefield, defending the Grid should be a whole lot easier!",
	},
	
	-- Archive Mission Events
	Mission_Tanks_Activated = {
		--"Tanks online.",
		"Those tanks are finally powered up, and ready to serve the Grid!",
		"About time those tanks powered up. Welcome to the fight!",
	},
	Mission_Tanks_PartialActivated = {
		--"One tank made it.",
		"That tank is finally powered up, and ready to serve the Grid!",
		"Only one tank survived. I'm sure its Pilot would like to exact some revenge, now that their weapons are online.",
	},
	Mission_Satellite_Destroyed = {
		--"Doesn't look like we can salvage that satellite, commander.",
        "Doesn't look like that rocket survived!",
        "I'm assuming the loss of that rocket is going to make our job harder, in the long run.",
	},
	Mission_Satellite_Imminent = {
		--"That satellite is about to launch.",
		"That rocket is powered up and ready to launch. Should be a sight to see!",
		"Sensors show that rocket is almost fully powered. Clear the launch pad!",
	},
	Mission_Satellite_Launch = {
		--"Rocket is away!",
		"There it goes!",
		"I hope that satellite can play some part in repelling this invasion.",
	},
	Mission_Dam_Reminder = {
		--"We still need to take out that dam.",
		"I hate the thought of destroying a potential source of hydro power, but we need to blow that dam and wash away these Vek.",
		"We still need to bust that dam. It's not generating power for the Grid anyway.",
	},
	Mission_Dam_Destroyed = {
		--"Here comes the water!",
		"Sealing external vents on my #self_mech! It's getting wet out there.",
		"Now let's wash away these Vek.",
	},
	Mission_Mines_Vek = {
		--"The Vek don't seem to understand how mines work.",
		"Death underfoot! It reminds me of Vertex, and our exploding crystals.",
		"By the Grid, that was satisfying to watch.",
	},
	Mission_Airstrike_Incoming = {
		--"Airstrike inbound.",
		"Transmission just received from Archive aircraft. They're beginning a bombing run!",
		"Anyone else notice that Archive plane descending? Looked like the bomb bay doors were open!",
	},
	
	-- R.S.T. Mission Events
	Mission_Force_Reminder = {
		--"Gotta clear those mountains or the Vek will infest them.",
		"Those mountains can't be left standing. They're a prime location for the Vek to build their hives.",
		"We need to destroy those mountain ranges before the Vek infest them.",
	},
	Mission_Lightning_Strike_Vek = {
		--"R.S.T. is a weapon itself.",
		"By the Grid! If only Vertex had weather like this, they'd surely harness the energy of such storms, to great effect.",
		"That Vek is fried!",
	},
	Mission_Terraform_Destroyed = {
		--"Doesn't look like we can salvage that terraformer, commander.",
		"Going to be harder to defend the Grid without that Terraformer.",
        "Doesn't look like that Terraformer survived!",
	},
	Mission_Terraform_Attacks = {
		--"Watchtower could use one of those, to clean up the mess the Vek have made.",
		"That terraformer must use an enormous amount of energy. The power Grid certainly is a marvel!",
		"And I thought our Mechs drew a lot of energy from the Grid!",
	},
	Mission_Cataclysm_Falling = {
		--"No coming back from a trip to that underworld.",
		"Don't step in those holes without a flying Mech!",
		"The island is collapsing! Even if we defend the Grid, will R.S.T. survive?",
	},
	Mission_Solar_Destroyed = {
		--"Doesn't look like we can salvage that solar panel, commander.",
		"Going to be harder to defend the Grid without that solar farm.",
        "Doesn't look like that solar farm survived!",
        "The Grid took a bad hit there! That solar facility was vital!",
	},
	
	-- Pinnacle Mission Events
	BotKilled_Self = {
		--"One less hostile bot.",
		"Where do those bots draw their power from, anyway? Are they sapping it from the Grid? Zenith should thank us for taking them offline!",
		"Hostile robot neutralized.",
        "We can't let these robots threaten the Grid, no matter what Zenith says.",
	},
	BotKilled_Obs = {
		--"One less hostile bot.",
		"Hostile robot neutralized. Well done, #main_second.",
        "We can't let these robots threaten the Grid, no matter what Zenith says.",
	},
	Mission_Factory_Destroyed = {
		--"Doesn't look like we can salvage that factory, commander.",
		"Going to be harder to defend the Grid without that factory. Long term, I mean.",
        "Doesn't look like that factory survived!",
        "The Grid took a bad hit there! That factory was vital!",
	},
	Mission_Factory_Spawning = {
		--"Zenith really needs to get her priorities straight; these things are a menace.",
		"If that factory is still hooked to the Grid, isn't it just wasting our energy with these malfunctioning bots?",
		"If we can't disconnect that factory from the Grid, can't Zenith at least override its production sequence?",
	},
	Mission_Reactivation_Thawed = {
		--"That ice isn't holding them!",
		"I guess that ice was never going to hold, without some kind of thermal equilibrium.",
		"That Vek broke free! Good thing I'm ready for it now.",
	},
	Mission_Freeze_Mines_Vek = {
		--"That should stop it for a while.",
		"What does Pinnacle put in those freeze mines?",
		"Vek frozen! And we didn't have to lift a finger.",
	},
	Mission_SnowStorm_FrozenVek = {
		--"That should stop it for a while.",
		"Seems like Pinnacle's weather is protecting the Grid as well!",
		"It's going to be harder for the Vek to pose a threat when they're frozen solid!",
	},
	Mission_SnowStorm_FrozenMech = {
		--"I can't move!",
		"My #self_mech can't really handle this cold!",
		"I can't serve the Grid if my #self_mech is frozen solid!",
	},
	
	-- Detritus Mission Events
	Mission_Barrels_Destroyed = {
		--"I'll drink to that.",
		"Let that sink in.",
		"A.C.I.D. barrel ruptured. Just as Detritus requested.",
	},
	Mission_Disposal_Destroyed = {
		--"Doesn't look like we can salvage that disposal unit, commander.",
		"Going to be harder to defend the Grid without that disposal unit.",
        "Doesn't look like that disposal unit survived!",
	},
	Mission_Disposal_Disposal = {
		--"Nothing is going to be left standing after that.",
		"That disposal unit must use an enormous amount of energy. The power Grid certainly is a marvel!",
		"And I thought our Mechs drew a lot of energy from the Grid!",
        "If the Grid could power more units like that, we might win a lot faster.",
	},
	Mission_Power_Destroyed = {
		--"Doesn't look like we can salvage that power plant, commander.",
		"Going to be harder to defend the Grid without that power plant.",
        "Doesn't look like that power plant survived!",
        "The Grid took a bad hit there! That power plant was vital!",
        "If this region survives, maybe I can get Vertex to build them a new power station.",
	},
	Mission_Belt_Mech = {
		--"Here we go!",
		"These conveyors seem like a waste of Grid power, commander.",
		"Hey, that's not where I wanted to be!",
	},
	Mission_Teleporter_Mech = {
		--"Here we go!",
		"These teleporters seem like a waste of Grid power, commander.",
		"Hey, that's not where I wanted to be!",
	},
	
	-- Meridia Mission Events
	Mission_lmn_Convoy_Destroyed = {
		--"Doesn't look like we can salvage that vehicle, commander.",
		"Going to be harder to defend the Grid without the supplies in that truck.",
        "Doesn't look like that truck survived!",
	},
	Mission_lmn_FlashFlood_Flood = {
		--"Here comes high tide.",
		"Meridia should install some hydropower plants in this region, with all this moving water!",
		"Everyone, prepare to get your feet wet.",
	},
	Mission_lmn_Geyser_Launch_Mech = {
		--"That's a lot of pressure!",
		"There's a lot of pent-up energy in this island!",
		"Anyone looking to get a good pressure wash?",
	},
	Mission_lmn_Geyser_Launch_Vek = {
		--"That's a lot of pressure!",
		"There's a lot of pent-up energy in this island!",
		"That's right, give the Vek a nice pressure wash!",
	},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {
		--"That should give the Vek something to think about.",
		"There's a lot of pent-up energy in this island!",
		"This region would be perfect for a geothermal station...",
	},
	Mission_lmn_Wind_Push = {
		--"Storm on the horizon!",
		"There's a lot of pent-up energy in this island!",
		"This region would be perfect for a few wind turbines.",
        "Check your positions, this wind is going push everything about!",
	},
	
	Mission_lmn_Runway_Imminent = {
		--"Stay clear of that runway, #squad.",
		"That plane is powered up and ready to launch.",
		"Looks like that plane is almost at full power. Clear the runway!",
	},
	Mission_lmn_Runway_Crashed = {
		--"Doesn't look like we can salvage that aircraft, commander.",
        "Doesn't look like that plane survived!",
        "I'm assuming the loss of that plane is going to make our job harder, in the long run.",
	},
	Mission_lmn_Runway_Takeoff = {
		--"Aircraft away.",
		"There it goes!",
		"I hope that plane gets to wherever it's going.",
	},
	Mission_lmn_Greenhouse_Destroyed = {
		--"Doesn't look like we can salvage that greenhouse, commander.",
        "Doesn't look like that greenhouse survived!",
        "The Grid took a bad hit there! That greenhouse was vital!",
	},
	Mission_lmn_Geothermal_Plant_Destroyed = {
		--"Doesn't look like we can salvage that geothermal unit, commander.",
        "Doesn't look like that geothermal station survived!",
        "The Grid took a bad hit there! That geothermal facility was vital!",
        "If this region survives, maybe I can get Vertex to build them a new power station.",
	},
	Mission_lmn_Hotel_Destroyed = {
		--"Doesn't look like we can salvage that hotel, commander.",
        "Doesn't look like that hotel survived!",
        "That's certainly going to hurt tourism.",
	},
	Mission_lmn_Agroforest_Destroyed = {
		--"Doesn't look like we can salvage that agroforest, commander.",
        "Doesn't look like that agroforest survived!",
        "The Grid took a bad hit there! That agroforest was vital!",
	},
	
-- tosx missions
	-- Island missions
	Mission_tosx_Juggernaut_Destroyed = {
		--"Doesn't look like we can salvage that Juggernaut unit, commander.",
		"Going to be harder to defend the Grid without that Juggernaut.",
        "Doesn't look like that Juggernaut survived!",
	},
	Mission_tosx_Juggernaut_Ram = {
		--"Don't mess with that sphere.",
		"That Juggernaut must use an enormous amount of energy! No wonder it's so slow the rest of the time.",
        "Does that thing run on Grid energy? It's more deadly than our Mechs!",
	},
	Mission_tosx_Zapper_On = {
		--"I've got an electrical heartbeat here.",
		"Vertex engineers would have a heart attack if they saw combat units being used as power lines.",
		"That's certainly not a regulation power transmission line, but it will do!",
	},
	Mission_tosx_Zapper_Destroyed = {
		--"Doesn't look like we can salvage that storm tower, commander.",
		"Going to be harder to defend the Grid without that storm tower.",
        "Doesn't look like that tower survived!",
	},
	Mission_tosx_Warper_Destroyed = {
		--"Doesn't look like we can salvage that portal tender, commander.",
		"Going to be harder to defend the Grid without that portal tender.",
        "Doesn't look like that aircraft survived!",
	},
	Mission_tosx_Battleship_Destroyed = {
		--"Doesn't look like we can salvage that ship, commander.",
		"Going to be harder to defend the Grid without that battleship.",
        "Doesn't look like that battleship survived!",
	},
	
	-- Island missions 2
	Mission_tosx_Siege_Now = {
		--"Now the fun begins.",
		"By the Grid, there are a lot of them!",
		"This should be exciting!",
        "Defend the Grid, no matter how many of them swarm us!",
	},
	Mission_tosx_Plague_Spread = {
		--"Stand clear, #squad!",
		"Our cockpits aren't sealed against such biological agents! Stay back!",
		"We have to kill that thing before it contaminates this whole region!",
	},
	
	-- AE
	Mission_ACID_Storm_Start = {
		--"This place is soaking in A.C.I.D. Let's help them with that.",
		--"So even the rain here will melt your skin off. Great.",
		--"This is why no one vacations at Detritus.",
		"My hull integrity is holding, but I don't like the idea of taking a hit while covered in this A.C.I.D...",
		"This rain is not improving my mood. But it is softening up the Vek, at least.",
        "Better destroy that storm controller before the entire Grid dissolves.",
	},	
	Mission_ACID_Storm_Clear = {
		--"Weather is clearing.",
		"Updating the forecast for clear skies!",
		"That's enough A.C.I.D. for this region.",
	},	
	Mission_Wind_Mech = {
		--"Storm on the horizon!",
		"This region would be perfect for a few wind turbines.",
        "Check your positions, this wind is going push everything about!",
        "Don't get knocked about by those gusts!",
	},	
	Mission_Repair_Start = {
		--"So now we have to fix our own Mechs?",
		"Fighting in such a state sure ups the excitement, eh?",
		"So now we have to fix our own Mechs? Fine, sounds like an interesting challenge!",
	},	
	Mission_Hacking_NewFriend = {
		--"Another ally for the cause.",
		"Welcome to the team, robot!",
		"Can we reprogram any of Zenith's other robots? This one's pretty useful!",
	},	
	Mission_Shields_Down = {
		--"Shields are down!",
		"Detecting an energy pulse from that destroyed facility, which is disabling all nearby shields.",
		"Shields down, across the board. Back to playing defense!",
	},
	
	-- Final
	MissionFinal_Start = {
		--"This place has even less Grid support than Watchtower. What are we supposed to power our Mechs with?",
		"An island beyond the Grid? How can we hope to fight here?!",
	},
	MissionFinal_StartResponse = {
		--"I see the pylons inbound. Ready for Grid connection.",
		"Here come the pylons! My #self_mech is back on Grid power!",
	},
	MissionFinal_FallResponse = {
		--"What's happening?!",
		"Readings show a huge spike in seismic activity!",
	},
	MissionFinal_Bomb = {
		--"Even Akai's nukes wouldn't make a scratch on this place. It's huge!",
		"It would take more energy than Vertex can produce in a year to bring down this nest!",
	},
	MissionFinal_CaveStart = {
		--"Time to earn our last paycheck. Protect that bomb, #squad.",
		"One last call to serve the Grid. I will protect that bomb or die trying.",
	},
	MissionFinal_BombArmed = {
		--"We did it. Mission accomplished.",
		"By the Grid, we did it! The bomb is armed and ready!",
	},
	
	-- Watchtower missions
	Mission_tosx_Sonic_Destroyed = {
		--"Doesn't look like we can salvage that Disruptor, commander.",
		"Going to be harder to defend the Grid without that Disruptor.",
        "Doesn't look like that Disruptor survived!",
	},
	Mission_tosx_Tanker_Destroyed = {
		--"Doesn't look like we can salvage that tanker, commander.",
		"Losing that tanker is going to be hard on this region.",
        "Doesn't look like that tanker survived!",
	},
	Mission_tosx_Rig_Destroyed = {
		--"Doesn't look like we can salvage that War Rig, commander.",
		"Going to be harder to defend the Grid without that War Rig.",
        "Doesn't look like that War Rig survived!",
	},
	Mission_tosx_GuidedKill = {
		--"Looks like that targeting data was spot on.",
		"Watchtower sure has good aim!",
		"I'll take as many missiles as Watchtower can spare, as long as they keep aiming where I'm pointing!",
	},
	Mission_tosx_NuclearSpread = {
		--"This corporation never had the highest safety standards.",
		"Vertex reactors have much more robust safety features; Watchtower really should get in touch with Salazar...",
		"Salazar would be furious to see reactor waste so poorly contained. Vertex has robust protocols for this stuff, even with the Vek invasion.",
	},
	Mission_tosx_RaceReminder = {
		--"I've got a huge wager riding on the lead car. Let's make sure it reaches the far side of the sector, with no competition in sight!",
		"Watchtower must run on adrenaline, staging such a race right through a battlefield! We'll make sure they have a clear winner.",
		"Can we let the Vek determine the winner of that race? Or do we really have to step in and stop one car ourselves?",
	},
	Mission_tosx_MercsPaid = {
		--"Looks like those mercenaries are willing to do business!",
		"Makes me uncomfortable, seeing soldiers who only serve the Grid for profit. But serve it they shall.",
		"I see these mercenaries have rejected the Grid's calling until it was in their own direct self-interest. Shameful, but we can't turn down help.",
	},
	Mission_tosx_RigUpgraded = {
		--"That's Watchtower ingenuity right there.",
		"Watchtower engineers have a lot of guts, working in the middle of a combat zone!",
		"Wish we could upgrade our Mechs on the fly like that!",
	},

--FarLine barks
	Mission_tosx_Delivery_Destroyed = {
		"Going to be harder to defend the Grid without those supplies.",
        "Doesn't look like those crates survived!",
	},
	Mission_tosx_Sub_Destroyed = {
		"Going to be harder to defend the Grid without that submersible.",
        "Doesn't look like that submersible survived!",
	},
	Mission_tosx_Buoy_Destroyed = {
		"Losing that buoy is going to be hard on this region.",
        "Doesn't look like that buoy survived!",
	},
	Mission_tosx_Rigship_Destroyed = {
		"Going to be harder to defend the Grid without that ship!",
        "Doesn't look like that ship survived!",
	},
	Mission_tosx_SpillwayOpen = {
		--"Manual valve operation successful. Get ready for outlet flow.",
		"I've released the spillway valve. Should have outflow soon.",
		"That should get the water flowing.",
	},
	Mission_tosx_OceanStart = {
		--"No land in sight... better keep a weather eye on those ships, and use the platforms they create to launch our attacks.",
		--"I'm used to seeing the open ocean from a boat; it's a bit different in a Mech.",
		--"I hope those ships can build some new deepwater platforms quickly, or we'll have nowhere to stand and fight.",
		"By the Grid! How do we defend it if there's nowhere to make our stand?",
		"Thank the Grid those ships have construction equipment. I hope they can build something for us to stand on, quickly!",
	},
	Mission_tosx_RTrain_Destroyed = {
		--"That takes care of the train.",
		"Cargo train derailed. Shouldn't pose a threat to the Grid now.",
		"This is your last stop.",
	},
    
-- Vertex barks
    Mission_tosx_Scoutship_Destroyed = {
		"Going to be harder to defend the Grid without that airship to scout for us.",
        "Doesn't look like that airship survived! Salazar won't be pleased.",
    },
    Mission_tosx_Beamtank_Destroyed = {
		"Going to be harder to defend the Grid without that laser tank.",
        "Doesn't look like that x survived! Salazar won't be pleased.",
    },
    Mission_tosx_Phoenix_Destroyed = {
		"Going to be harder to defend the Grid without that facility to revive us.",
        "Time to live dangerously. No more second chances!",
        "Doesn't look like the Phoenix Project survived! Salazar won't be pleased.",
    },
    Mission_tosx_Exosuit_Destroyed = {
		"Going to be harder to defend the Grid without that exosuit.",
        "Doesn't look like that exosuit survived! Salazar won't be pleased.",
        "I'll let Salazar know, that exosuit isn't going to make it to the evac point.",
    },
    Mission_tosx_Retracter_Destroyed = {
        "Doesn't look like that transmission tower survived! Salazar won't be pleased.",
        "I told Salazar we need these antennas to be capable of automatic retraction...",
    },
    Mission_tosx_Halcyte_Destroyed = {
		"Crystal fractured!",
        "I've lost count of how many crystals I've shattered, working for Vertex.",
        "Those crystals are too dangerous to remain intact.",
    },
    Mission_tosx_Retracting = {
        --"Activating safety override.",
		"I'll inform Salazar directly, one of her antennas is about to retract. It should soon be safe underground.",
		"By the Grid, Vertex really needs to update these safety overrides to not require manual activation!",
    },
    Mission_tosx_MeltingDown = {
        --"Even Watchtower's nuclear reactors aren't in that sorry of a state.",
		"By the Grid, I've never seen a Vertex reactor in such a state! We can't leave it like that!",
		"If we don't hurry and demolish that reactor, the Vek may not be the biggest threat to the Grid!",
    },
    Mission_tosx_CrysGrowth = {
        --"Stay sharp, more of those volatile crystals are emerging.",
		"I never tire of these crystals' beauty. Or getting the Vek to explode by running into them.",
		"Try to maneuver the Vek over those crystal formations. That should give them a nice surprise!",
    },
}