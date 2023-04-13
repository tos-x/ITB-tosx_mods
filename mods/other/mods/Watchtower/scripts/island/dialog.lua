
-- Table of responses to various events.
return {
	["Script ID"] = "CEO_Watchtower", -- don't think this is needed, but included for completeness.
	Welcome_Message = {
		"This is Watchtower Security. What's left of it, at any rate. You're here to change that: you will help us reclaim this island from the Vek.",
		"Watchtower is in the business of war, yet even we were unable to stand against the Vek. Our attempt resulted in the loss of our island. Do you think you can do better?",
		"Watchtower Security led the initial effort to repel the Vek; our forces were decimated and our island reduced to a barren waste. Reclaiming it will be no easy task.",
		"Welcome to my island. Most of my corporate soldiers have become mercenary scavengers, adrift in the wastes; you are here to help me unite them and drive out the Vek for good.",
	},
	Island_Perfect = {
		"I see my faith in you was not misplaced. We stand a chance at bringing Watchtower back to full strength after all.",
		"An exceptional performance. I expect as much from my soldiers, but it is rare to find in outsiders.",
		"If you continue to perform with such skill, we will soon retake Watchtower and be able to restart full-scale weapons production.",
	},
	Region_Names = [[
		Mount Sho,
		Salt Flats,
		Tau Spire,
		Eastern Ascent,
		Amber Pass,
		Catchwater,
		Lot's Road,
		Tengu Ridge,
		Cloudwatch,
		The Four Pillars,
		Henge,
		Scoured Corridor,
		Dry Basin,
		Seishin Peak,
		Rubble Quarter,
		Alter Canyon,
		Basalt Quarry,
		Tower Arch,
		Haunted Stair,
		Salt March,
		Scavenger's Playground,
		Old Racetrack,
		Arms Depot,
		Mud Pit,
		Baker Spire,
		Warning Road,
		Outpost 5,
		Firing Range,
		Radioactive Lake,
		Munitions Storage,
		Camp Walker,
		Target Field,
		Two Coins,
		Claymore,
		Neutron Stockpile,
		Desolation Rock,
		No Recourse,
		Contaminated Sector
	]],
	
	-- Game States
	--Gamestart = {},
	--FTL_Found = {},
	--FTL_Start = {},
	--Gamestart_PostVictory = {},
	--Death_Revived = {},
	--Death_Main = {},
	Death_Response = {
		"The loss of a skilled soldier is always difficult to bear.",
		"Mourn briefly. We will have to seek a replacement as quickly as possible.",
	},
	Death_Response_AI = {
		"Even these simple pilot units are costly to procure; do not waste them.",
		"That AI unit may be immortal, but its #main_mech is now unable to assist your efforts.",
	},
	--TimeTravel_Win = {},
	Gameover_Start = {
		"To watch my island fall a second time...",
		"You have failed. It is a bitter, if familiar, sentiment.",
	},
	Gameover_Response = {
		"I will fall with Watchtower, but you must take up this cause in another life, another time.",
		"No one can save us now. Your penance will be to save as many other timelines as you can.",
	},
	
	-- UI Barks
	--Upgrade_PowerWeapon = {},
	--Upgrade_NoWeapon = {},
	--Upgrade_PowerGeneric = {},
	
	-- Mid-Battle
	MissionStart = {
		"Scattered though they are, the people of this island still maintain the Grid. Protect them.",
		"Give the enemy no quarter.",
		"You have your orders. Execute them with precision.",
		"Let us see what you are capable of, #squad.",
	},
	Mission_ResetTurn = {
		"Time is the greatest weapon we have. Use it wisely.",
		"This will be your last chance to adjust your stratagems; do not waste it.",
	},
	MissionEnd_Dead = {
		"I see your lethality has not been overstated.",
		"The scavengers will take many trophies from this battlefield.",
		"Excellent. My island is one step closer to being free of the Vek.",
	},
	MissionEnd_Retreat = {
		"Perhaps you do not appreciate the fact that any Vek who escape will continue to plague my island?",
		"A victory, but tempered by the escape of enemy forces who will no doubt return.",
	},
	
	PodIncoming = {
		"Aid from the future. Procure that Time Pod.",
		"Our weapons are the most advanced of any corporation, but they still pale in comparison to those from your future. Secure that Pod.",
	},
	PodResponse = {
		"If you cannot retrieve that Pod yourselves, my scavengers will acquire it after the battle.",
		"My technicians will surely be able to improve your Mechs with the contents of that Pod.",
	},
	--PodCollected_Self = {},
	PodDestroyed_Obs = {
		"This campaign against the Vek requires every available weapon, commander.",
		"Nothing to salvage, even for the scavengers. Have more care, commander.",
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
		"An efficient method of disposal.",
		"My science team still cannot explain how creatures with such a weakness have successfully infested our islands...",
		"Augmented perception, enhanced locomotive ability, improved threat assessment... still can't swim.",
		"Watching them sink below fills me with a shameful joy.",
		"Water has ever nurtured humanity. Now it protects us, as well.",
	},
	Vek_Fall = {
		"An efficient method of disposal.",
		"Take care not to follow it into the abyss.",
	},
	Vek_Smoke = {	
		"Utilize those smoke clouds to disrupt Vek attacks.",
		"The Vek are rendered practically harmless when they cannot see.",
	},
	Vek_Frozen = {
		"Ice will stop this enemy in its tracks.",
		"The Vek are rendered practically harmless when frozen.",
		"Encased in ice. We could run some tests after the battle.",
	},
	--VekKilled_Self = {},
	VekKilled_Obs = {
		"Strike them down.",
		"Very good, #squad.",
		"Very good, #main_second.",
	},
	VekKilled_Vek = {
		"My enemies further their own destructions.",
		"The enemy of my enemy...",
	},
	
	--DoubleVekKill_Self = {},
	DoubleVekKill_Obs = {
		"Kill them all.",
		"Very efficient, #squad.",
		"Very efficient, #main_second.",
		"I commend your performance, #main_second.",
	},
	DoubleVekKill_Vek = {
		"My enemies furthers their own destructions.",
		"The enemy of my enemy...",
		"How kind of them to aid us so.",
	},
	
	--MntDestroyed_Self = {},
	--MntDestroyed_Obs = {},
	--MntDestroyed_Vek = {},
	
	PowerCritical = {
		"You are the only hope for this island... but it is your only hope as well. Do not let the Grid fail.",
		"You cannot allow the Grid to fail, or we are all doomed.",
	},
	--Bldg_Destroyed_Self = {},
	Bldg_Destroyed_Obs = {
		"You are here to retake my island, not destroy it.",
		"Your provocations must cease. Without the Grid, we all die.",
		"#squad, what are you doing?!",
	},
	Bldg_Destroyed_Vek = {
		"Protect the buildings, or the Grid will fail!",
		"Those structures may look ramshackle, but their safety is still paramount!",
	},
	Bldg_Resisted = {
		"We cannot rely on luck to save us all.",
		"This attack failed; the next may not. Do not give the Vek any opportunity to attack these buildings.",
	},
	
	-- Generic Missions
	Mission_Generic_Briefing = {
		"The Vek must be driven out, sector by sector. Each site we reclaim offers the possibility of scavenging weapons and tech that was lost when Watchtower originally fell.",
		"Former Watchtower soldiers remained in this sector when the island fell, defending it to the best of their ability. Relieve them before their supplies are exhausted.",
		"My island's inhospitable terrain has made it difficult to root out the Vek; that's where you come in, #squad. Clear this sector, with prejudice.",
		"This region may look barren, but it contains valuable mineral resources that will allow Watchtower to restart our heavy weapons manufacturing. Do not let the Vek take it.",
	},
	Mission_Generic_Success = {
		"Before the Vek, Watchtower Security was without peer in matters of military conflict. With your success today, we restore some of that legacy.",
		"I see my faith in you was well-founded, #squad. Your combat skills will be right at home at Watchtower.",
		"Your combat efficiency is laudable, #squad. Your tactics may carry us to a lasting victory.",
		"You have done what my soldiers and mercenaries could not: drive the Vek from this sector, permanently. Well done, commander.",
	},
	Mission_Generic_Failure = {
		"I see my faith in you was ill-founded, commander. I cannot afford to lose ground here.",
		"Your martial reputation seems to have been severely overstated, commander.",
		"I have seen hired mercenaries with more discipline. When I provide you with objectives, I expect them to be achieved.",
		"I cannot accept this outcome, commander. Begin preparing for your next mission, with greater care.",
	},
	
	-- Unsure if these should be filled in or not.
	--Mission_Survive_Briefing = {},
	--Mission_Survive_Success = {},
	--Mission_Survive_Failure = {},
	
	-- >=3 grid damage during a mission.
	Mission_ExtremeDamage = {
		"War is not without loss. Still, at this rate there will not be much of Watchtower left to reclaim from the Vek.",
		"Many gave their lives here today. It is your job to ensure they did not do so in vain.",
	},
	Mission_Mechs_Dead = {
		"I am sorry about your pilots, commander. Skilled soldiers are in short supply.",
		"This is a heavy loss. I have plenty of mercenaries, but few qualified replacement pilots.",
	},
	
	-- Generic Objectives
	-- Lose less than x mech health
	Mission_MechHealth_Briefing = {
		"The Vek control most of the resource-rich sectors of the island, so minimize material damage to your Mechs.",
		"We have been reduced to scavenging the wastes for scrap metal, so take care with your Mechs; we can ill afford to make substantial repairs.",
	},
	Mission_MechHealth_Success = {
		"An admirable performance. Your pilots are skilled indeed, to avoid enemy attacks so completely.",
		"Excellent. Your Mechs appear ready for their next mission.",
	},
	Mission_MechHealth_Failure = {
		"We will lose vital time and scarce resources repairing the damage done today. Instruct your pilots more clearly in the future, commander.",
		"#squad, focus on dispensing damage, not receiving it.",
	},
	
	-- Lose less than x grid
	Mission_GridHealth_Briefing = {
		"My people are building with scrap metal and prayers, #squad. Their structures cannot sustain much damage, so keep the Vek away from the Grid.",
		"The buildings in this sector are only tenuously connected to the Grid, so any damage could risk leaving your Mechs without power.",
	},
	Mission_GridHealth_Success = {
		"The Grid here survived, thanks to your actions.",
		"Well done, commander. I will have my engineers continue working to improve the Grid in this sector.",
	},
	Mission_GridHealth_Failure = {
		"The Grid in this sector is on the brink of failure, due to your lack of care.",
		"We cannot continue to power your Mechs if you cannot protect the Grid where it is vulnerable.",
	},
	
	-- Kill x enemies
	Mission_KillAll_Briefing = {
		"I require access to the resources in this sector, and I can't have the Vek harrying my teams. Inflict heavy casualties.",
		"My research team wants you to test some new ammunition; prepare for a lot of target practice.",

	},
	Mission_KillAll_Success = {
		"If the Vek have morale, hopefully your actions today will have substantially weakened it.",
		"You've exceeded my expectations, commander. Hopefully Vek corpses have some use; the scavengers will have a good haul.",
	},
	Mission_KillAll_Failure = {
		"You failed to achieve the requested kill count. Vek stragglers continue to plague this region.",
		"Perhaps I should clarify what I mean when I use the words 'extreme prejudice'.",
	},

	-- Vek eggs
	Mission_Debris_Briefing = {
		"We have enough Vek running around on my island without allowing their eggs to hatch and bolster their numbers. See to it, commander.",
	},
	Mission_Debris_Failure = {
		"I have several reports in front of me detailing exactly how you failed to deal with those Vek eggs. Several additional reports are overdue, because some of my scouts were killed by the newly hatched Vek.",
	},
	Mission_Debris_Success = {
		"The Vek are much easier to deal with before they hatch, are they not?",
	},

	-- Vek mites
	Mission_SelfDamage_Briefing = {
		"Vek Mites have been detected in this region. They cannot be allowed to spread; who knows what other hardware they might infest. Clear your Mechs before returning from the mission.",
	},
	Mission_SelfDamage_Failure = {
		"I see you broke quarantine and allowed the Vek Mites into our engineering facilities. We're already getting reports of malfunctions and destroyed equipment.",
	},
	Mission_SelfDamage_Success = {
		"Zero remaining Vek Mite signatures detected. Very effective, commander.",
	},

	-- Pacifist
	Mission_Pacifist_Briefing = {
		"My research team is trying to develop new munitions that will better penetrate Vek exoskeletons. For their efforts, we'll need live specimens, so limit your kills during this mission.",
	},
	Mission_Pacifist_Failure = {
		"My scavengers were unable to recover enough live specimens for the munitions project. This is unacceptable.",
	},
	Mission_Pacifist_Success = {
		"Excellent. We've trapped several of the Vek you left alive and will begin live fire tests with them shortly.",
	},
	
	-- Block x spawns
	Mission_Block_Briefing = {
		"The salt flats in this region have been contaminated by radiation; prevent the Vek from disturbing the ground.",
		"Reserves of ammunition are running low in this sector; better to keep the Vek underground than engage in prolonged combat.",
	},
	Mission_Block_Success = {
		"I see you were able to keep Vek reinforcements from tunneling into this region. Well done, commander.",
	},
	Mission_Block_Failure = {
		"Numerous Vek reached the surface. I expect better in the future, commander.",
	},
	
	Mission_BossGeneric_Briefing = {
		"My researchers have never detected a specimen like this before. Eliminate it, and the island may be ours again.",
		"An unidentified Vek is approaching my tower. Take it out before it arrives.",
	},
	Mission_BossGeneric_Success = {
		"Thanks to your efforts, Watchtower Security is under our control once more. I will ensure full-scale weapons production resumes immediately, to assist the other corporations in this struggle.",
		"Fine work, commander. I can finally reunite the remnants of Watchtower, and work to bring new weapons to bear against the Vek on other islands.",
	},
	Mission_BossGeneric_Tower = {
		"This tower housed valuable prototype weapons and schematics, but its loss must be weighed against the necessity of killing that monstrosity. I will make do.",
	},
	Mission_BossGeneric_Boss = {
		"The island is secure once more, but that abnormal Vek remains at large. It will surely return to plague me.",
		"I have already put a contract out to all the mercenaries of the wastes: to hunt that creature down and finish it off.",
	},
	
	Mission_tosx_Siege_Briefing = {
		"A massive swarm of Vek is preparing to attack this remote region. You should find whatever spare hardware you can and activate it, if you wish to weather the onslaught.",
	},
	Mission_tosx_Siege_Failure = {
		"Your Mechs' power and ammunition consumption is unacceptably high; you were ordered to find reinforcements for just this reason.",
	},
	Mission_tosx_Siege_Partial = {
		"Your Mechs' power and ammunition consumption is unacceptably high; additional reinforcements would have alleviated this issue.",
	},
	Mission_tosx_Siege_Success = {
		"Surviving that horde was clearly not an easy task. Get your pilots some well-deserved rest, commander.",
	},
	Mission_tosx_Disease_Briefing = {
		"My researchers believe this Vek has come into contact with one of our old biological weapons labs. It is now highly dangerous, and must be put down.",
	},
	Mission_tosx_Disease_Failure = {
		"All my research into bioweapons was lost when the island fell; whatever disease this Vek carries, we have no cure. We must abandon this sector.",
	},
	Mission_tosx_Disease_Success = {
		"I have tasked some of the more competent wasteland scavengers to carefully retrieve the corpse of that Vek, so we can study its affliction and prepare a cure... just in case.",
	},
	
-- Watchtower barks
	Mission_tosx_Sonic_Destroyed = {
		"That Disruptor was vital to the defense of this region.",
		"Commander, you were ordered to protect that Disruptor.",
	},
	Mission_tosx_Tanker_Destroyed = {
		"That water was vital to the people of this region.",
		"Without that Tanker, I will not be able to supply the people of this sector.",
	},
	Mission_tosx_TankerFull_Destroyed = {
		"The water tanks in that vehicle are reinforced; they should survive its destruction.",
		"The water storage tanks were built to survive the vehicle's destruction. We can retrieve them once the area is secure.",
	},
	Mission_tosx_Rig_Destroyed = {
		"Commander, you were ordered to protect that War Rig.",
		"That War Rig was vital to our weapons program.",
		"I required that War Rig intact; now the scavengers will pick it clean before my techs can salvage it.",
	},
	Mission_tosx_GuidedKill = {
		"My gunners are locked onto that Vek.",
		"Watchtower's reach is long.",
	},
	Mission_tosx_NuclearSpread = {
		"Radiation levels are climbing at a new set of coordinates.",
		"Another nuclear waste dump has begun leaking dangerous radiation, commander.",
	},
	Mission_tosx_RaceReminder = {
		"We must have a clear winner, commander. Ensure one, and only one, of those Rigs reaches the far side of the sector.",
		"The eyes of Watchtower are on that race. Make sure one Rig reaches the end of the track. One alone.",
	},
	Mission_tosx_MercsPaid = {
		"In exchange for that haul of minerals, these mercenaries have agreed to aid you against the Vek.",
		"I have secured the services of that mercenary rig, using the minerals you collected.",
	},
	Mission_tosx_RigUpgraded = {
		"Excellent. That War Rig grows more formidable.",
		"Watchtower has learned much since the Vek defeated us. Nothing goes to waste. Failed weapons must be repurposed and improved.",
	},
	
}