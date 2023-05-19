
-- Table of responses to various events.
return {
	["Script ID"] = "CEO_FarLine", -- don't think this is needed, but included for completeness.
	Welcome_Message = {
		--"This is Far Line Charters. What's left of it, at any rate. You're here to change that: you will help us reclaim this island from the Vek.",
		"Welcome to Far Line Charters. Our archipelago was once an Old Earth mountain range; when the oceans rose it became the new home of our freight operations. Now the Vek are threatening those operations.",
		"You've arrived at Far Line Charters. Your Mechs look impressive, but they may find it difficult to operate in the waters of our archipelago. Still, those same waters help us to keep the Vek at bay.",
		"Far Line Charters is at your disposal, commander. I have authorized our cargo fleet and transport hubs to assist you in any way they can. Now if you'll excuse me, I have some damage reports to file; the Vek have not paused their onslaught.",
		"Far Line Charters specializes in transportation and freight. Our cargo fleet was Old Earth's largest; now that fleet supplies all of the corporate islands. We cannot allow the Vek to jeopardize it.",
	},
	Island_Perfect = {
		--"I see my faith in you was not misplaced. We stand a chance at bringing Watchtower back to full strength after all.",
		"Well done, commander. Top marks on all missions, and not a single after-action report out of place or misfiled!",
		"Your priorities are in lockstep with my own, commander. Well done.",
		"I have submitted a formal notice of recognition to document, and reward, your performance, commander.",
		"I reget that I doubted the capabilities of your Mechs, commander. They have performed admirably.",
	},
	Region_Names = [[
		Shale Harbor,
		West Harbor,
		Echo Point,
		Salt Reach,
		Brine Haul,
		Fell Channel,
		Algae Fields,
		Cargo Lanes,
		Underkeel,
		Lost Fathom,
		Weather Isle,
		Seamount 8,
		Skybird Isle,
		The Eye,
		Tagger's Lane,
		Inner Sounding,
		Polaris,
		Compass Shore,
		Kelp Forest,
		Broadside,
		Seawall,
		Last Voyage,
		Transport Hub,
		Spiny Docks,
		Coastal Garrison,
		Hydrothermal Research,
		Coldrock Isle,
		Shipwreck Isle,
		Dive Site,
		Chimera Port,
		Thalasso Port,
		Outer Reef,
		The Lighthouse,
		Dredge,
		Sheltered Cove,
		Kraken Isle
	]],
	
	-- Game States
	--Gamestart = {},
	--FTL_Found = {},
	--FTL_Start = {},
	--Gamestart_PostVictory = {},
	--Death_Revived = {},
	--Death_Main = {},
	Death_Response = {
		--"The loss of a skilled soldier is always difficult to bear.",
		"A heavy blow. I will notify the next of kin immediately.",
		"A tragic outcome, to be sure.",
	},
	Death_Response_AI = {
		--"Even these simple pilot units are costly to procure; do not waste them.",
		"The paperwork involved in requisitioning new A.I. units is significant. Please try to keep them operational.",
		"I believe we have a replacement for that A.I. unit in one of our warehouses. I will submit a requisition form.",
	},
	--TimeTravel_Win = {},
	Gameover_Start = {
		--"To watch my island fall a second time...",
		"To think we survived the rising waters only to be lost in this tide of Vek.",
		"Without the Grid, our archipelago is doomed.",
	},
	Gameover_Response = {
		--"I will fall with Watchtower, but you must take up this cause in another life, another time.",
		"You cannot let this be the end of your voyage; other timelines could still be saved.",
		"Go, before it is too late for a Breach. This timeline will fall; another may be saved.",
	},
	
	-- UI Barks
	--Upgrade_PowerWeapon = {},
	--Upgrade_NoWeapon = {},
	--Upgrade_PowerGeneric = {},
	
	-- Mid-Battle
	MissionStart = {
		--"Scattered though they are, the people of this island still maintain the Grid. Protect them.",
		"I have submitted all the necessary forms, commander: your operational authority is in full effect. Good luck.",
		"My analysts will document your performance and file any necessary paperwork after the mission.",
		"Far Line's operations in this sector are critical, commander. Please ensure there is no damage or disruption to our assets or personnel.",
		"Our combat projections for this mission are favorable, given current enemy forces. If you can route them within our estimated timetable, I would be most grateful, commander.",
	},
	Mission_ResetTurn = {
		--"Time is the greatest weapon we have. Use it wisely.",
		"I am unsure how best to document your mission timetable in the face of this Breach technology.",
		"Time has reset, yet our memories remain. I will have to fill out those action reports a second time.",
	},
	MissionEnd_Dead = {
		--"I see your lethality has not been overstated.",
		"Excellent. Operational efficiency will be greatly increased without any Vek in the way.",
		"Thank you for your efforts, commander. You have exterminated one hundred percent of the enemy forces in this sector.",
	},
	MissionEnd_Retreat = {
		--"Perhaps you do not appreciate the fact that any Vek who escape will continue to plague my island?",
		"Our sensors detect several Vek retreating through the earth. Please have your pilots fill out form 72B-9 when they return to the hangar, so that we can document this event.",
		"We cannot waste time chasing down fleeing Vek; there is still much to be done.",
	},
	
	PodIncoming = {
		--"Aid from the future. Procure that Time Pod.",
		"An unauthorized craft has entered this sector!",
		"A Time Pod is inbound!",
	},
	PodResponse = {
		--"If you cannot retrieve that Pod yourselves, my scavengers will acquire it after the battle.",
		"We will have to redo all of our estimated timetables to accommodate the retrieval of that Pod.",
		"Please return that Pod intact, so my analysts can properly document all of its contents.",
	},
	--PodCollected_Self = {},
	PodDestroyed_Obs = {
		--"This campaign against the Vek requires every available weapon, commander.",
		"I had already begun filing paperwork pertaining to that Pod's arrival... now I will have to append form 18R-1 for its destruction.",
		"All cargo is precious. Especially that which comes from the future, unbidden. But we must press on.",
	},
	--Secret_DeviceSeen_Mountain = {},
	--Secret_DeviceSeen_Ice = {},
	--Secret_DeviceUsed = {},
	--Secret_Arriving = {},
	--Emerge_Detected = {},
	--Emerge_Success = {},
	--Emerge_FailedMech = {},
	--Emerge_FailedVek = {},

	-- Mech State
	--Mech_LowHealth = {},
	--Mech_Webbed = {},
	--Mech_Shielded = {},
	--Mech_Repaired = {},
	--Pilot_Level_Self = {},
	--Pilot_Level_Obs = {},
	--Mech_ShieldDown = {},

	-- Damage Done
	Vek_Drown = {
		--"An efficient method of disposal.",
		"These creatures should have learned to swim before invading our island chain.",
		"How fortunate that the Vek are not adapted to the ocean, as we are.",
		"I will have my analysts record another drowned Vek via form 9A-4. I suspect we will need more copies of that form.",
		"Wonderful. The waters that give us life and livelihood also aid us in dealing with the Vek.",
		"Welcome to Far Line Charters.",
	},
	Vek_Fall = {
		--"An efficient method of disposal.",
		"Wonderful. I will fill out form 9A-5: Vek dispatched via chasm.",
		"Efficient use of the environment, commander. You are now ahead of our estimated timetable!",
	},
	Vek_Smoke = {	
		--"Utilize those smoke clouds to disrupt Vek attacks.",
		"The Vek cannot attack through all of that smoke.",
		"Those clouds of smoke will confuse the Vek, and keep our local assets safe.",
	},
	Vek_Frozen = {
		--"Ice will stop this enemy in its tracks.",
		"That ice appears thick enough to keep its occupant safely neutralized.",
		"Have your pilots focus on the other Vek, commander; that frozen one is no longer a threat.",
	},
	--VekKilled_Self = {},
	VekKilled_Obs = {
		--"Strike them down.",
		"Another recorded kill.",
		"Wonderful! One less Vek.",
		"I have updated our combat records to log that kill.",
	},
	VekKilled_Vek = {
		--"My enemies further their own destructions.",
		"Those Vek handily demonstrate the need for planning and preparation. Without such, they destroy themselves.",
		"I have updated our combat records to log that kill, although I'm unsure who to credit it to.",
	},
	
	--DoubleVekKill_Self = {},
	DoubleVekKill_Obs = {
		--"Kill them all.",
		"Two additional recorded kills!",
		"I have updated our combat records to log those kills.",
	},
	DoubleVekKill_Vek = {
		--"My enemies furthers their own destructions.",
		"I don't believe Far Line even has a form for that eventuality. I will have my analysts create one.",
		"Those Vek handily demonstrate the need for planning and preparation. Without such, they destroy themselves.",
	},
	
	--MntDestroyed_Self = {},
	--MntDestroyed_Obs = {},
	--MntDestroyed_Vek = {},
	
	PowerCritical = {
		--"You are the only hope for this island... but it is your only hope as well. Do not let the Grid fail.",
		"The Grid will soon fail, commander! You must protect it!",
		"All of our combat projections rest on the assumption that you can preserve the Grid. Without it we are all lost!",
	},
	--Bldg_Destroyed_Self = {},
	Bldg_Destroyed_Obs = {
		--"You are here to retake my island, not destroy it.",
		"I understand that sometimes sacrifices must be made.",
		"I would ask that you yourself notify the next of kin for all those civilians, commander.",
	},
	Bldg_Destroyed_Vek = {
		--"Protect the buildings, or the Grid will fail!",
		"I must ask that you protect my people, commander!",
		"Do not let the Vek attack our civilians!",
	},
	Bldg_Resisted = {
		--"We cannot rely on luck to save us all.",
		"A lucky happenstance. Luck is something I abhor, so please, do not rely on it.",
		"A stroke of luck... our combat projections did not account for this. We will have to revise them, immediately.",
	},
	
	-- Generic Missions
	Mission_Generic_Briefing = {
		--"The Vek must be driven out, sector by sector. Each site we reclaim offers the possibility of scavenging weapons and tech that was lost when Watchtower originally fell.",
		"This region is critical for our cargo operations, commander. Every moment that the Vek threaten it, our schedules slip and our people risk death.",
		"The Vek have been appearing all across our archipelago, stretching our ability to track them or provide aid to the populace. Your Mechs are badly needed.",
		"We have not been able to transit through this sector while it is under threat. Please clear the Vek so we can resume vital operations.",
		"Far Line's cargo fleet is not equipped to engage the Vek. Without your help, this region will fall.",
	},
	Mission_Generic_Success = {
		--"Before the Vek, Watchtower Security was without peer in matters of military conflict. With your success today, we restore some of that legacy.",
		"Wonderful, commander. Your pilots completed the mission well ahead of our projected timetable.",
		"My people will work to resume operations in this sector, now that the Vek there have been dealt with.",
		"It is always a pleasure to deal with capable professionals. Far Line Charters thanks you, commander; your efforts here were impeccable.",
		"Our fleet will once more be able to safely transit the waters around this sector, and stage supply runs from it to the other corporate islands.",
	},
	Mission_Generic_Failure = {
		--"I see my faith in you was ill-founded, commander. I cannot afford to lose ground here.",
		"This loss has thrown our whole operational schedule into disarray; it will take days to regain our footing.",
		"Each island in our archipelago is vital to our industry, commander. And without Far Line Charters, the other corporations will be cut off from ocean trade.",
		"I will have my analysts begin calculating the impact of this loss. I am sure the answer will be grim.",
		"Land is precious in this archipelago; Far Line cannot afford to lose any of it.",
	},
	
	-- Unsure if these should be filled in or not.
	--Mission_Survive_Briefing = {},
	--Mission_Survive_Success = {},
	--Mission_Survive_Failure = {},
	
	-- >=3 grid damage during a mission.
	Mission_ExtremeDamage = {
		--"War is not without loss. Still, at this rate there will not be much of Watchtower left to reclaim from the Vek.",
		"You must redouble your efforts to protect the Grid, commander, or we will all pay the price.",
		"None of us can afford another performance like that. Please ensure your pilots understand the vital importance of safeguarding the Grid.",
	},
	Mission_Mechs_Dead = {
		--"I am sorry about your pilots, commander. Skilled soldiers are in short supply.",
		"This is a day of dark skies and stormy seas. We will bury your pilots in the deep, with all honors due them.",
		"Your pilots died to protect Far Line, and for that, we are indebted to them. Their names will go down in our history, should we survive this war.",
	},
	
	-- Generic Objectives
	-- Lose less than x mech health
	Mission_MechHealth_Briefing = {
		--"The Vek control most of the resource-rich sectors of the island, so minimize material damage to your Mechs.",
		"Our supply ships have been delayed by bad weather; try not to damage your Mechs, as spare parts will be in short supply.",
		"This region is outside our normal shipping lanes, so supplies are stretched thin. Please try to minimize damage to your Mechs.",
	},
	Mission_MechHealth_Success = {
		--"An admirable performance. Your pilots are skilled indeed, to avoid enemy attacks so completely.",
		"Well done. I have noted your performance, and your respect for my supply network.",
		"Thank you, commander. Your actions have ensured we will not have to reroute our cargo freighters to obtain spare parts.",
	},
	Mission_MechHealth_Failure = {
		--"We will lose vital time and scarce resources repairing the damage done today. Instruct your pilots more clearly in the future, commander.",
		"I have issued an emergency authorization for the nearest supply ship to change course, so that we can repair your Mechs... but those parts were dearly needed elsewhere.",
		"Our mechanics will find some way to repair your Mechs, but they will likely have to strip critical Far Line equipment in order to do so...",
	},
	
	-- Lose less than x grid
	Mission_GridHealth_Briefing = {
		--"My people are building with scrap metal and prayers, #squad. Their structures cannot sustain much damage, so keep the Vek away from the Grid.",
		"Erosion in this sector has consumed most of our construction materials, so please keep the Vek away from the buildings; we won't be able to repair further damage.",
		"Worn underwater cables have left the Grid on this island barely functional; do not allow the Vek to damage it further.",
	},
	Mission_GridHealth_Success = {
		--"The Grid here survived, thanks to your actions.",
		"Excellent, the Grid remained intact. Far Line is grateful to you, commander.",
		"I appreciate your efforts; losing further Grid power in this sector would have been a mountain of paperwork.",
	},
	Mission_GridHealth_Failure = {
		--"The Grid in this sector is on the brink of failure, due to your lack of care.",
		"The Grid is almost beyond repair in this sector; we will have to evacuate the remaining populace.",
		"I do not know how we will rebuild the Grid in this region; even if it is possible, it will surely result in a mountain of paperwork.",
	},
	
	-- Kill x enemies
	Mission_KillAll_Briefing = {
		--"I require access to the resources in this sector, and I can't have the Vek harrying my teams. Inflict heavy casualties.",
		"The Vek can burrow deep enough to travel between islands; kill them all, so they don't have that chance.",
		"The Vek in this sector have already destroyed a number of ships and buildings; exterminate them before they do any more damage.",
	},
	Mission_KillAll_Success = {
		--"If the Vek have morale, hopefully your actions today will have substantially weakened it.",
		"A 100% effectiveness rating; your pilots are certainly skilled when it comes to exterminating the Vek.",
		"These are excellent results. Your pilots have my thanks.",
	},
	Mission_KillAll_Failure = {
		--"You failed to achieve the requested kill count. Vek stragglers continue to plague this region.",
		"Those Vek will surely resurface elsewhere in the near future. I can only assume our people, operations, and schedule will suffer for it.",
		"Too many Vek escaped. My analysts are already projecting high future losses due to their survival.",
	},

	-- Vek eggs
	Mission_Debris_Briefing = {
		--"We have enough Vek running around on my island without allowing their eggs to hatch and bolster their numbers. See to it, commander.",
		"Vek eggs have been sighted in this region; destroy them before they can hatch.",
	},
	Mission_Debris_Failure = {
		--"I have several reports in front of me detailing exactly how you failed to deal with those Vek eggs. Several additional reports are overdue, because some of my scouts were killed by the newly hatched Vek.",
		"It is much easier to deal with eggs than angry Vek, commander; you have cost us that chance.",
	},
	Mission_Debris_Success = {
		--"The Vek are much easier to deal with before they hatch, are they not?",
		"Excellent. I will have my analysts create a new form to document kills of pre-hatched Vek, as this represents a substantial combat efficiency gain.",
	},

	-- Vek mites
	Mission_SelfDamage_Briefing = {
		--"Vek Mites have been detected in this region. They cannot be allowed to spread; who knows what other hardware they might infest. Clear your Mechs before returning from the mission.",
		"It appears one of our freighters was carrying Vek Mites. They're currently contained to this island, but you'll need to eliminate them before your Mechs return from the mission.",
	},
	Mission_SelfDamage_Failure = {
		--"I see you broke quarantine and allowed the Vek Mites into our engineering facilities. We're already getting reports of malfunctions and destroyed equipment.",
		"There's no telling where those Vek Mites have spread now that they've made it off that island, commander. Far Line Charters has a reputation for efficiency, which will not survive if Mites begin destroying all our equipment.",
	},
	Mission_SelfDamage_Success = {
		--"Zero remaining Vek Mite signatures detected. Very effective, commander.",
		"Thank you, commander. Your efforts to preserve the quarantine and neutralize those Mites have been most successful.",
	},

	-- Pacifist
	Mission_Pacifist_Briefing = {
		--"My research team is trying to develop new munitions that will better penetrate Vek exoskeletons. For their efforts, we'll need live specimens, so limit your kills during this mission.",
		"The sea life in this sector has suffered greatly from decomposing Vek carcasses; please try to drive off the Vek without killing them, if possible.",
	},
	Mission_Pacifist_Failure = {
		--"My scavengers were unable to recover enough live specimens for the munitions project. This is unacceptable.",
		"Dead Vek leak all sorts of unhealthy compounds into our waters, commander; the local ecosystem is on the brink of collapse now.",
	},
	Mission_Pacifist_Success = {
		--"Excellent. We've trapped several of the Vek you left alive and will begin live fire tests with them shortly.",
		"Thank you, commander. We will deal with those Vek when they resurface, in less ecologically sensitive areas, as needed.",
	},
	
	-- Block x spawns
	Mission_Block_Briefing = {
		--"The salt flats in this region have been contaminated by radiation; prevent the Vek from disturbing the ground.",
		"Recent rainfall has accelerated erosion on this island; prevent the Vek from further destabilizing the ground with their tunnels.",
		"Active combat will accelerate the erosion of several sensitive sites on this island; keep the Vek in the ground to minimize that chance.",
	},
	Mission_Block_Success = {
		--"I see you were able to keep Vek reinforcements from tunneling into this region. Well done, commander.",
		"Good work. Not only have you prevented further erosion from Vek activity, your preventative efforts resulted in improved efficiency and a shorter mission timetable than anticipated.",
	},
	Mission_Block_Failure = {
		--"Numerous Vek reached the surface. I expect better in the future, commander.",
		"I have reports here, documenting the loss of several crucial facilities to destabilized terrain.",
	},
	
	Mission_BossGeneric_Briefing = {
		--"My researchers have never detected a specimen like this before. Eliminate it, and the island may be ours again.",
		"We have an as-yet undocumented type of Vek threatening Far Line Charters' main operation center. Please deal with this threat.",
		"Far Line Charters has recorded many types of Vek... but never anything like the one now approaching our headquarters. We lack any combat projections; please assume it is extremely dangerous.",
	},
	Mission_BossGeneric_Success = {
		--"Thanks to your efforts, Watchtower Security is under our control once more. I will ensure full-scale weapons production resumes immediately, to assist the other corporations in this struggle.",
		"Far Line Charters is free of the Vek. We will be able to step up our shipping operations and focus on supplying the other corporate islands.",
		"Our archipelago is safe once more. Our ships will set sail for the other corporate islands, to aid them as well.",
	},
	Mission_BossGeneric_Tower = {
		--"This tower housed valuable prototype weapons and schematics, but its loss must be weighed against the necessity of killing that monstrosity. I will make do.",
		"I... I do not have a form for this eventuality. The Far Line Charters HQ housed the majority of our records. I have no idea how we will regain any semblance of operational efficiency.",
		"Thank you for dispatching that abomination, commander, even if the cost was high.",
	},
	Mission_BossGeneric_Boss = {
		--"The island is secure once more, but that abnormal Vek remains at large. It will surely return to plague me.",
		"Far Line is finally free of the Vek, though the survival of that abomination gives me great unease.",
		"The survival of that monstrous Vek represents a huge variable in our ability to forecast future operations. Still, your efforts have been otherwise successful; thank you, commander.",
	},
	
	-- Final mission
	MissionFinal_StartResponse = {
		"Deploying remote power pylons. They should keep you connected to the Grid.",
	},
	MissionFinal_FallStart = {
		"Incoming seismic activity! Brace yourselves!",
	},
	MissionFinal_Pylons = {
		"Deploying additional power pylons. Please keep them operational. We don't have any more.",
	},
	MissionFinal_BombResponse = {
		"Deploying a Renfield Bomb. Defend it while it primes and it will destroy the hive.",
	},
	MissionFinal_BombDestroyed = {
		"Deploying another bomb, but it will need more time to prime. I don't know if we have any more in storage, so protect it.",
	},
	MissionFinal_BombArmed = {
		"The Renfield bomb is ready. Escape now, if you can, or you'll be buried with the Vek!",
	},
	
	-- Island missions
	Mission_tosx_Siege_Briefing = {
		--"A massive swarm of Vek is preparing to attack this remote region. You should find whatever spare hardware you can and activate it, if you wish to weather the onslaught.",
		"Somehow, a great swarm of Vek has amassed beneath this island. There are several cargo containers in the area with old military hardware; you'll need to unpack them if you want to stand a chance.",
	},
	Mission_tosx_Siege_Failure = {
		--"Your Mechs' power and ammunition consumption is unacceptably high; you were ordered to find reinforcements for just this reason.",
		"We'll be hard-pressed to resupply your Mechs after that mission; had you opened those crates and utilized their contents, your Mechs wouldn't have needed to push so hard.",
	},
	Mission_tosx_Siege_Partial = {
		--"Your Mechs' power and ammunition consumption is unacceptably high; additional reinforcements would have alleviated this issue.",
		"We'll be hard-pressed to resupply your Mechs after that mission; had you opened both crates, your Mechs wouldn't have needed to push so hard.",
	},
	Mission_tosx_Siege_Success = {
		--"Surviving that horde was clearly not an easy task. Get your pilots some well-deserved rest, commander.",
		"I cannot believe you, and the island's infrastructure, survived against such a vast enemy force. You may save us all yet, commander.",
	},
	Mission_tosx_Disease_Briefing = {
		--"My researchers believe this Vek has come into contact with one of our old biological weapons labs. It is now highly dangerous, and must be put down.",
		"A plague-ridden Vek has appeared in this region, crawling out of the wreck of a cargo ship that went missing days ago. It seems to be highly contagious. Put it down.",
	},
	Mission_tosx_Disease_Failure = {
		--"All my research into bioweapons was lost when the island fell; whatever disease this Vek carries, we have no cure. We must abandon this sector.",
		"We must evacuate this island immediately, before my people become infected. We cannot risk that disease spreading throughout the archipelago.",
	},
	Mission_tosx_Disease_Success = {
		--"I have tasked some of the more competent wasteland scavengers to carefully retrieve the corpse of that Vek, so we can study its affliction and prepare a cure... just in case.",
		"Even dead, the body of that Vek represents a dire threat to Far Line Charters; we will seal it in concrete and bury it in the ocean depths.",
	},
	
	-- FarLine barks
	Mission_tosx_Delivery_Destroyed = {
		"I had form 28F-3 prepared for just this eventuality, but I hoped I would not need it.",
		"The loss of that delivery, especially so close to its destination, is almost too much to bear.",
	},
	Mission_tosx_Sub_Destroyed = {
		"I had form 28F-1 prepared for just this eventuality, but I hoped I would not need it.",
		"The loss of any Far Line Charters vessel is a solemn occasion. Her crew will be given all honors.",
		"Down with all hands... let us have a moment of silence.",
	},
	Mission_tosx_Buoy_Destroyed = {
		"I had form 28F-6 prepared for just this eventuality, but I hoped I would not need it.",
		"Commander, we're no longer reading one of the navigation buoys.",
	},
	Mission_tosx_Rigship_Destroyed = {
		"I had form 28F-2 prepared for just this eventuality, but I hoped I would not need it.",
		"The loss of any Far Line Charters vessel is a solemn occasion. Her crew will be given all honors.",
		"Down with all hands... let us have a moment of silence.",
		"If you cannot protect our ships, your Mechs will need to learn how to fight while submerged.",
	},
	Mission_tosx_SpillwayOpen = {
		"With the spillway hatch open, that area will soon flood. Prepare your Mechs.",
		"The manual override worked; that spillway is fully open and should begin venting water shortly.",
	},
	Mission_tosx_OceanStart = {
		"Protect those vessels, and they will see to it that you have somewhere to fight, #squad.",
		"You'll need to construct additional deepwater platforms from which to stage your attacks, unless your Mechs can fly, #squad.",
	},
	Mission_tosx_RTrain_Destroyed = {
		"A necessary loss.",
		"Thank you, commander. We will begin working to reestablish our freight timetables now that we know the threat of a derailment has been neutralized.",
	},
	
}