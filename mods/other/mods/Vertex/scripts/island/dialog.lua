--[[
    Vertex treats the Grid as its savior.
        Energy generation, production, and distribution is treated as a holy calling.
        They believe in impenetrable defenses.
        Its facilities are sacred sites.
        Mechs are just instruments of the Grid.
        Pilots are knights, blessed to draw on its power.
    Their CEO is unfazed by failure, seeing it as a test of the Grid.
        The spreading crystals are a failure that the island still hopes to harness, no regrets.
        Success risks being boring.
        Sometimes forgets that she and her citizens are at risk of harm.
    Their pilots are enthusiastic and reckless.    
--]]

-- Table of responses to various events.
return {
	["Script ID"] = "CEO_Vertex", -- don't think this is needed, but included for completeness.
	Welcome_Message = {
		--"This is Far Line Charters. What's left of it, at any rate. You're here to change that: you will help us reclaim this island from the Vek.",
		"Welcome to Vertex. I'm sure our time together will present many fascinating challenges, but the energies of the Grid are strong here. Together we will make them even stronger.",
        "The Vertex Conglomerate serves the Grid. We work tirelessly to strengthen and expand it, drawing energy from the island's crystals. With your help, the Vek will break themselves against our defenses!",
        "Your Mechs are only as impressive as the Grid that powers them. Fortunately for you, we have dedicated our entire island to fueling the Grid. Let the Vek test themselves against us!",
        "The Grid welcomes you! In this hour of need, you have answered its call, and we will do whatever we can to aid its newest servants.",
        "The crystals you see around you contain a staggering amount of energy; if we can but survive long enough, we may yet find a way to yoke that energy to the Grid and turn it against these invaders!",
	},
	Island_Perfect = {
		--"I see my faith in you was not misplaced. We stand a chance at bringing Watchtower back to full strength after all.",
		"You honor us with your impeccable service to the Grid, commander. Vertex will shine brighter than ever, thanks to your efforts.",
	},
	Region_Names = [[
        Trinity,
        Omicron Station,
        Transfer Hub,
        Galvanic Reach,
        Volt Corridor,
        Neutron Waste,
        First Criticality,
        Testing Shrine,
        Crystal Fields,
        Omicron Lattice,
        Helix,
        Shard Vault,
        Gem Processing,
        Facet,
        Power Terminus,
        Shattered Road,
        Crimson Edifice,
        Sea of Glass,
        Glimmering Cave,
        Crystal Forge,
        Old Parapet,
        Castle Dynamo,
        Moebius Substation,
        Reactor 4,
        Pillar of Light,
        Polishing District,
        The Fade,
        Salazar's Gate,
        Halcyte Cluster,
        Brittle Spires,
        Unrefined Lode,
        Mirror Range,
        Dark Reflection,
        Solemn Treasury,
        Vertex Main,
        Pulse,
        Energy Ward
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
		"We all understand what is at stake in this war, but every loss is still difficult.",
        "One of your Mechs has lost connection to the Grid. I fear the worst.",
        "Pilot #main_second has made the ultimate sacrifice to protect the Grid.",
	},
	Death_Response_AI = {
		--"Even these simple pilot units are costly to procure; do not waste them.",
		"That automaton has sacrificed itself to protect the Grid. Such nobility from a machine.",
        "One of your Mechs has lost connection to the Grid. Even without a pilot inside, this is serious setback.",
        "Our engineers can salvage and repair that Mech after the battle, as long as the Grid survives.",
	},
	--TimeTravel_Win = {},
	Gameover_Start = {
		--"To watch my island fall a second time...",
		"It cannot be... the Grid has fallen.",
        "So much energy, fed into the Grid to maintain it... and still it has failed us! There is nothing left to hold back the Vek!",
	},
	Gameover_Response = {
		--"I will fall with Watchtower, but you must take up this cause in another life, another time.",
		"We have failed. Without the Grid, nowhere in this timeline is safe. Flee, if you can.",
        "The Vek are already breaching our remaining strongholds across the island. This timeline is doomed.",
	},
	
	-- UI Barks
	--Upgrade_PowerWeapon = {},
	--Upgrade_NoWeapon = {},
	--Upgrade_PowerGeneric = {},
	
	-- Mid-Battle
	MissionStart = {
		--"Scattered though they are, the people of this island still maintain the Grid. Protect them.",
		"Another chance presents itself, to prevail over the Vek and drive them from Vertex for good!",
		"Use the volatile crystals of this terrain to your advantage, whenever possible. Our buildings have been shielded against their energies, but the Vek will suffer from them.",
		"Watch out for fractured crystals in the landscape; they will release their pent-up energies when shattered.",
		"The Vek must die, on this ground. The Grid, and Vertex, must survive. Our people await your success!",
	},
	Mission_ResetTurn = {
		--"Time is the greatest weapon we have. Use it wisely.",
		"Detecting a very strange energy reading. Was that a miniaturized breach?",
		"What just happened? The Grid fluctuated strangely for a moment, and my memories became twisted.",
	},
	MissionEnd_Dead = {
		--"I see your lethality has not been overstated.",
		"Such violence, your Mechs are capable of! I thank the Grid you are on our side.",
		"If you continue to produce Vek corpses in such quantities, Vertex will have to investigate the possibility of using them for biofuel. Let them contribute to the survival of the Grid!",
	},
	MissionEnd_Retreat = {
		--"Perhaps you do not appreciate the fact that any Vek who escape will continue to plague my island?",
		"I wonder if the Vek that survived will learn anything from this encounter. The idea of facing them again is fascinating, is it not?",
		"Let the Vek flee this battlefield. Vertex's energy production must continue to accelerate, until the Grid is too strong to fear any attack from them!",
	},
	
	PodIncoming = {
		--"Aid from the future. Procure that Time Pod.",
		"A Time Pod has just entered the atmosphere near your Mechs, commander.",
		"Our sensor web has just registered an unauthorized aerial craft; it appears to be a Time Pod, commander.",
	},
	PodResponse = {
		--"If you cannot retrieve that Pod yourselves, my scavengers will acquire it after the battle.",
		"Make every attempt to recover that craft, commander!",
		"Defend or retrieve that Time Pod! Its contents could prove invaluable to Vertex.",
	},
	--PodCollected_Self = {},
	PodDestroyed_Obs = {
		--"This campaign against the Vek requires every available weapon, commander.",
		"What a waste.",
		"Perhaps it was prudent not to introduce untested technology into our fight against the Vek. Still, I regret to see it destroyed!",
	},
	Secret_DeviceSeen_Mountain = {
		"The energy signature within that crystal mountain is most unusual...",
	},
	Secret_DeviceSeen_Ice = {
		"The energy signature beneath that ice is most unusual...",
	},
	--Secret_DeviceUsed = {},
    Secret_Arriving = {
		"A very... strange craft has just entered the atmosphere. No markings we can identify.",
	},
	Emerge_Detected = {
		"The veins of subsurface crystal throughout our island are not enough to deter these burrowing Vek. More approach.",
        "More Vek are about to breach the surface. Show them the strength of the Grid!",
	},
	Emerge_Success = {
		"Right on time!",
        "Lead these Vek to the slaughter!",
	},
	--Emerge_FailedMech = {},
	Emerge_FailedVek = {
		"Apparently these Vek are not fond of competition from their own!",
        "These Vek do not seem eager for their own reinforcements!",
	},

	-- Mech State
	--Mech_LowHealth = {},
	--Mech_Webbed = {},
	--Mech_Shielded = {},
	--Mech_Repaired = {},
	--Pilot_Level_Self = {},
	Pilot_Level_Obs = {
		"Let the Grid recognize your superior performance here today, Pilot #main_second!",
	},
	--Mech_ShieldDown = {},

	-- Damage Done
	Vek_Drown = {
		--"An efficient method of disposal.",
		"Quite a practical way to dispose of threats to the Grid!",
		"I was eager to see your weapons at work, and they do not disappoint!",
        "These creatures chose a poor planet to invade, if they dislike water!",
	},
	Vek_Fall = {
		--"An efficient method of disposal.",
		"Quite a practical way to dispose of threats to the Grid!",
		"Given time and depth, that Vek corpse may turn into an energy-dense resource, to the benefit of Vertex!",
	},
	Vek_Smoke = {	
		--"Utilize those smoke clouds to disrupt Vek attacks.",
		"Those fine particulates appear to disrupt the Vek's attack patterns.",
	},
	Vek_Frozen = {
		--"Ice will stop this enemy in its tracks.",
		"Subzero temperatures appear to severely disrupt the Vek's attack patterns.",
		"Encased in ice! Almost as if the crystals of our island have claimed that Vek for their own.",
	},
	--VekKilled_Self = {},
	VekKilled_Obs = {
		--"Strike them down.",
		"I was eager to see your weapons at work, and they do not disappoint!",
		"Yes! Every threat to the Grid must be struck down!",
		"Let these invaders feel the fury of the Grid!",
	},
	VekKilled_Vek = {
		--"My enemies further their own destructions.",
		"I was eager to see your weapons at work, but that will do as well!",
		"They destroy themselves! Perhaps eager to avoid your wrath?",
	},
	
	--DoubleVekKill_Self = {},
	DoubleVekKill_Obs = {
		--"Kill them all.",
		"I was eager to see your weapons at work, and they certainly do not disappoint!",
		"By the Grid, what a splendid show of force! Two kills at once!",
		"Let these invaders feel the unrelenting fury of the Grid!",
		"Pilot #main_second, you are indeed a worthy servant of the Grid!",
	},
	DoubleVekKill_Vek = {
		--"My enemies furthers their own destructions.",
		"I was eager to see your weapons at work, but that will do as well! And two at once!",
		"They destroy themselves, one after another! Perhaps eager to avoid your wrath?",
	},
	
	--MntDestroyed_Self = {},
	--MntDestroyed_Obs = {},
	--MntDestroyed_Vek = {},
	
	PowerCritical = {
		--"You are the only hope for this island... but it is your only hope as well. Do not let the Grid fail.",
		"Vertex is nothing without the Grid... and neither are your Mechs. You cannot allow it to take further damage!",
		"My engineers will be eager to analyze the Grid's performance under these dire conditions, but first they must survive! We cannot take another hit!",
	},
	--Bldg_Destroyed_Self = {},
	Bldg_Destroyed_Obs = {
		--"You are here to retake my island, not destroy it.",
		"I pray your actions serve some strategic purpose. Otherwise, those deaths are in vain.",
		"What foolhardy test are you performing, damaging the Grid like this? I hope it was worth the deaths of those citizens.",
	},
	Bldg_Destroyed_Vek = {
		--"Protect the buildings, or the Grid will fail!",
		"Those civilians gave their lives maintaining the Grid; do not waste their sacrifice!",
		"These creatures desecrate the Grid and lay waste to our people. You cannot let that stand!",
        "You must protect the Grid at all costs!",
	},
	Bldg_Resisted = {
		--"We cannot rely on luck to save us all.",
		"Thank the Grid!",
		"Witness the true power of the Grid! In our moment of need, it stands strong.",
		"The Grid held! It has bought you time.",
	},
	
	-- Generic Missions
	Mission_Generic_Briefing = {
		--"The Vek must be driven out, sector by sector. Each site we reclaim offers the possibility of scavenging weapons and tech that was lost when Watchtower originally fell.",
		"This Vek onslaught presents a valuable opportunity for us to assess their weaknesses. However, the sanctity of the Grid should remain your priority.",
		"The Grid Buildings in this sector should provide ample power for your Mechs to drive off the Vek. Several substations were rerouted to ensure any power fluctuations are minimal.",
		"Our engineers continue to search for ways to make the Grid Defense system more reliable, but until they succeed, you must minimize Vek attacks on our infrastructure.",
		"Another chance for you to demonstrate the might of the Grid! Let it power your Mechs to victory over these hordes.",
	},
	Mission_Generic_Success = {
		--"Before the Vek, Watchtower Security was without peer in matters of military conflict. With your success today, we restore some of that legacy.",
		"Excellent, the majority of our infrastructure in this region has survived. But I'm sure further excitement awaits elsewhere on the island; the Vek do not rest!",
		"My compliments on the swiftness of your action today, #squad. The Grid endures!",
		"You've pushed the Vek from this region! Vertex will be stronger for your efforts..",
		"Vertex has already begun routing additional power lines through this region, now that it is secure. These lines should enable you to push into new sectors.",
	},
	Mission_Generic_Failure = {
		--"I see my faith in you was ill-founded, commander. I cannot afford to lose ground here.",
		"As long as Vertex survives, each failure is but another opportunity to identify and eliminate our weaknesses.",
		"A costly lesson, but we will learn what we can from this setback. As long as the Grid survives, there is hope.",
		"We cannot afford to see every mission turn out like this, #squad. The Grid can only endure so much.",
		"Pressure like this will eventually cause Vertex to fracture, violently. Just like those crystals.",
	},
	
	-- Unsure if these should be filled in or not.
	--Mission_Survive_Briefing = {},
	--Mission_Survive_Success = {},
	--Mission_Survive_Failure = {},
	
	-- >=3 grid damage during a mission.
	Mission_ExtremeDamage = {
		--"War is not without loss. Still, at this rate there will not be much of Watchtower left to reclaim from the Vek.",
		"New crystals will soon overtake all of this rubble. Hopefully one day Vertex can harvest their energy, and put it towards helping those who survived.",
		"This region has taken heavy damage, but as long as Vertex itself still stands, the survivors will endeavor to adapt and rebuild.",
        "The Grid requires more of your squad, commander. It cannot continue to power the island, or your Mechs, if this attrition continues.",
	},
	Mission_Mechs_Dead = {
		--"I am sorry about your pilots, commander. Skilled soldiers are in short supply.",
		"Your pilots served the Grid well. May they find peace, and may the rest of us continue to strive in memory of them.",
	},
	
	-- Generic Objectives
	-- Lose less than x mech health
	Mission_MechHealth_Briefing = {
		--"The Vek control most of the resource-rich sectors of the island, so minimize material damage to your Mechs.",
		"Our conglomerate's resources in this sector are entirely devoted towards maintaining and strengthening the Power Grid, so we can spare little for Mech repair. Minimize damage any way you can.",
		"A vein of crystal recently exploded in this sector, damaging nearby repair facilities. I'm sure your squad can accomplish their objectives without taking undue damage.",
	},
	Mission_MechHealth_Success = {
		--"An admirable performance. Your pilots are skilled indeed, to avoid enemy attacks so completely.",
		"Your efforts have allowed us to allocate more resources towards the Grid, which will in turn benefit your Mechs!",
		"Given your excellent performance, perhaps we should allocate even fewer resources to post-mission repairs! I'm sure Vertex could use those resources elsewhere.",
	},
	Mission_MechHealth_Failure = {
		--"We will lose vital time and scarce resources repairing the damage done today. Instruct your pilots more clearly in the future, commander.",
		"We will have to abandon other priority projects to free up resources for Mech repair now. I suppose that will keep the future interesting.",
		"While I admire your independence, commander, I cannot condone your carelessness with Vertex resources. Those orders you disobeyed were for everyone's benefit.",
	},
	
	-- Lose less than x grid
	Mission_GridHealth_Briefing = {
		--"My people are building with scrap metal and prayers, #squad. Their structures cannot sustain much damage, so keep the Vek away from the Grid.",
		"We are working to install new transmission lines throughout this sector. Damage to the Grid could cause dangerous fluctuations and far-ranging damage, so do not allow the Vek to destroy our structures!",
		"The power levels in this region must remain stable to allow for delicate work on the Grid; too much damage to our structures could undo everything!",
	},
	Mission_GridHealth_Success = {
		--"The Grid here survived, thanks to your actions.",
		"Minimal Grid fluctuations reported. I have faith that our engineers would have finished their work under any circumstances, but today we didn't have to find out!",
		"You served the Grid well today, #squad!",
	},
	Mission_GridHealth_Failure = {
		--"The Grid in this sector is on the brink of failure, due to your lack of care.",
		"The damage to the Grid has shorted out several vital substations. We'll be working overtime to try and contain the effects.",
		"Vertex cannot maintain the Grid if it is constantly in flux from these attacks. I know you and your squad are capable of more dedicated effort, commander.",
	},
	
	-- Kill x enemies
	Mission_KillAll_Briefing = {
		--"I require access to the resources in this sector, and I can't have the Vek harrying my teams. Inflict heavy casualties.",
		"Leave no surviving Vek. Any that escape will inevitably return.",
		"We cannot afford to let any Vek escape this region. Destroy as many as you can!",
	},
	Mission_KillAll_Success = {
		--"If the Vek have morale, hopefully your actions today will have substantially weakened it.",
		"Your service to the Grid is appreciated. No threats remain!",
		"Eradicating the Vek here has prevented them from fleeing into the surrounding cities. Well done!",
	},
	Mission_KillAll_Failure = {
		--"You failed to achieve the requested kill count. Vek stragglers continue to plague this region.",
		"Too many Vek survived. Our citizens will be dealing with stragglers once your Mechs have moved on.",
		"You failed to take out the attackers; many will return to fight another day. I hope you're not trying to extend the thrill of battle?",
	},

	-- Vek eggs
	Mission_Debris_Briefing = {
		--"We have enough Vek running around on my island without allowing their eggs to hatch and bolster their numbers. See to it, commander.",
		"We've gained some new insight into the Vek lifecycle through the appearance of several massive eggs here. We would prefer to study them once they are deceased, for safety.",
	},
	Mission_Debris_Failure = {
		--"I have several reports in front of me detailing exactly how you failed to deal with those Vek eggs. Several additional reports are overdue, because some of my scouts were killed by the newly hatched Vek.",
		"The Vek horde continues to grow, with the hatching of those eggs. I appreciate the faith you have in our defenses, but you failed in your charge, commander.",
	},
	Mission_Debris_Success = {
		--"The Vek are much easier to deal with before they hatch, are they not?",
		"Excellent, our scientists can now safely dissect those eggs. Perhaps we will uncover new weaknesses once we better understand them.",
	},

	-- Vek mites
	Mission_SelfDamage_Briefing = {
		--"Vek Mites have been detected in this region. They cannot be allowed to spread; who knows what other hardware they might infest. Clear your Mechs before returning from the mission.",
		"This region has become infested with Vek Mites. We can't afford to have them hitching a ride back with your Mechs, so you'll have to sterilize on site.",
	},
	Mission_SelfDamage_Failure = {
		--"I see you broke quarantine and allowed the Vek Mites into our engineering facilities. We're already getting reports of malfunctions and destroyed equipment.",
		"Those Vek Mites managed to spread into several core transmission lines upon your return. Rooting them out of the Grid will be a costly endeavor.",
	},
	Mission_SelfDamage_Success = {
		--"Zero remaining Vek Mite signatures detected. Very effective, commander.",
		"The Grid remains clear of Vek Mites, thanks to your sterilization efforts during the battle. Well done, commander.",
	},

	-- Pacifist
	Mission_Pacifist_Briefing = {
		--"My research team is trying to develop new munitions that will better penetrate Vek exoskeletons. For their efforts, we'll need live specimens, so limit your kills during this mission.",
		"We have plans for a major construction effort in this region; disposing of Vek corpses will slow that work considerably. Please drive them off without creating a pile of bodies.",
	},
	Mission_Pacifist_Failure = {
		--"My scavengers were unable to recover enough live specimens for the munitions project. This is unacceptable.",
		"We've all let our emotions get the better of us when it comes to the Vek, so I understand your prejudice in dealing with them, commander. Still, site cleanup will delay our work considerably.",
	},
	Mission_Pacifist_Success = {
		--"Excellent. We've trapped several of the Vek you left alive and will begin live fire tests with them shortly.",
		"I know we would all like to see the Vek eliminated, rather than driven off, but you've ensured our construction crews can start their work without needing to do additional site cleanup.",
	},
	
	-- Block x spawns
	Mission_Block_Briefing = {
		--"The salt flats in this region have been contaminated by radiation; prevent the Vek from disturbing the ground.",
		"We've seeded the terrain here with several promising crystal strains. To preserve them, the surface needs to remain relatively unbroken. Keep the Vek from breaking through.",
		"We're cultivating a delicate strain of crystal in this region, with promising applications. Don't let the Vek disturb the surface and ruin our work.",
	},
	Mission_Block_Success = {
		--"I see you were able to keep Vek reinforcements from tunneling into this region. Well done, commander.",
		"The crystal harvest should be a success, thanks to your efforts to block the Vek tunnels.",
	},
	Mission_Block_Failure = {
		--"Numerous Vek reached the surface. I expect better in the future, commander.",
		"Our sensors show several major fractures in the underground crystal lattice, due to those Vek emergence points. We may lose the entire harvest.",
	},
	
	Mission_BossGeneric_Briefing = {
		--"My researchers have never detected a specimen like this before. Eliminate it, and the island may be ours again.",
		"It seems the Vek have one last trick up their sleeves: sending some kind of unknown abomination to threaten our primary Grid link, at Vertex tower.",
		"Our tower is under threat! We've never detected this species of Vek before, so we cannot yet asses the scope of the danger.",
	},
	Mission_BossGeneric_Success = {
		--"Thanks to your efforts, Watchtower Security is under our control once more. I will ensure full-scale weapons production resumes immediately, to assist the other corporations in this struggle.",
		"The Grid has carried your Mechs to this victory, and you have carried all of Vertex with you!",
		"I will miss the excitement you brought to Vertex, commander. But you must move on: your service to the Grid extends beyond this one island!",
	},
	Mission_BossGeneric_Tower = {
		--"This tower housed valuable prototype weapons and schematics, but its loss must be weighed against the necessity of killing that monstrosity. I will make do.",
		"That tower was our primary distribution hub for the Grid. The island is going to be experiencing severe blackouts until we can reroute things, but at least we'll do so in peace.",
		"If losing our tower is the price of maintaining the Grid and securing our island, so be it. Vertex still stands!",
	},
	Mission_BossGeneric_Boss = {
		--"The island is secure once more, but that abnormal Vek remains at large. It will surely return to plague me.",
		"I look forward to our next meeting with that creature; we will spend every waking moment preparing for its return. But you must move on: your service to the Grid extends beyond this one island!",
		"I trust you gave that creature some scars to remember you by. Shame we cannot mount its head in the tower atrium, as a trophy to the Grid.",
	},
	
	-- Final mission
	MissionFinal_StartResponse = {
		"Deploying remote power pylons. They will extend the Grid and keep you within its reach.",
	},
	MissionFinal_FallStart = {
		"Seismic activity detected, commander.",
	},
	MissionFinal_Pylons = {
		"Deploying additional subsurface pylons. These are the last of our reserves, so use care!",
	},
	MissionFinal_BombResponse = {
		"High-yield energy-based explosive deployed. It should level that hive, but it will take time to arm; defend it!",
	},
	MissionFinal_BombDestroyed = {
		"Deploying additional explosive, but it will take more time to arm. Defend this one more vigorously than the last!",
	},
	MissionFinal_BombArmed = {
		"The bomb is armed, and your service to the Grid is ended. Escape while you can, and leave the Vek to burn!",
	},
	
	-- Island missions
	Mission_tosx_Siege_Briefing = {
		--"A massive swarm of Vek is preparing to attack this remote region. You should find whatever spare hardware you can and activate it, if you wish to weather the onslaught.",
		"A Vek swarm of unprecedented size is nearing this region. It should make for a thorough test of your capabilities, along with some new hardware we've been developing!",
	},
	Mission_tosx_Siege_Failure = {
		--"Your Mechs' power and ammunition consumption is unacceptably high; you were ordered to find reinforcements for just this reason.",
		"Vertex assets draw less power from the Grid, which is why you were ordered to utilize them. While your attempt to deal with the swarm on your own was impressive, we must always focus on the Grid!",
	},
	Mission_tosx_Siege_Partial = {
		--"Your Mechs' power and ammunition consumption is unacceptably high; additional reinforcements would have alleviated this issue.",
		"Vertex assets draw less power from the Grid, which is why you were ordered to utilize everything we had available. While your attempt to deal with the swarm short-handed was impressive, we must always focus on the Grid!",
	},
	Mission_tosx_Siege_Success = {
		--"Surviving that horde was clearly not an easy task. Get your pilots some well-deserved rest, commander.",
		"The Grid endures, even in the face of such overwhelming numbers! A performance to celebrate, for sure!",
	},
	Mission_tosx_Disease_Briefing = {
		--"My researchers believe this Vek has come into contact with one of our old biological weapons labs. It is now highly dangerous, and must be put down.",
		"Sensors have detected severe biological contamination spreading from an unidentified Vek in this region. Eliminate this threat!",
	},
	Mission_tosx_Disease_Failure = {
		--"All my research into bioweapons was lost when the island fell; whatever disease this Vek carries, we have no cure. We must abandon this sector.",
		"Our citizens cannot inhabit this sector if they cannot leave their buildings to maintain the Grid; we will have to abandon it to the Vek and hope their own disease fells them.",
	},
	Mission_tosx_Disease_Success = {
		--"I have tasked some of the more competent wasteland scavengers to carefully retrieve the corpse of that Vek, so we can study its affliction and prepare a cure... just in case.",
		"The diseased corpse of that Vek presents a unique research opportunity, which our scientists will make the most of. We will work as fast as possible to have a cure ready should more such creatures surface!",
	},
	
-- Vertex barks
    Mission_tosx_Scoutship_Destroyed = {
		"While testing the integrity of Vertex assets is an admirable goal, we need them intact to complete their missions!",
        "That scout ship provided valuable intel on approaching Vek threats. I see you prefer a challenge, going in blind.",
        "That airship provided vital intelligence for tracking Vek movements. Without it, your mission will be more dangerous!",
    },
    Mission_tosx_Beamtank_Destroyed = {
		"While testing the integrity of Vertex assets is an admirable goal, we need them intact to complete their missions!",
		"The crystal laser on that tank was an important asset, and its crew highly trained. Without them, you will certainly have a greater challenge on your hands.",
    },
    Mission_tosx_Phoenix_Destroyed = {
		"While testing the integrity of Vertex assets is an admirable goal, we need them intact to complete their missions!",
		"I see you do not fear death, if you do not see the value in defending the Phoenix Project.",
        "That facility was our best chance at directly channeling excess Grid energy into your Mechs to increase their effectiveness.",
    },
    Mission_tosx_Exosuit_Destroyed = {
		"While testing the integrity of Vertex assets is an admirable goal, we need them intact to complete their missions!",
		"Those exosuits are our best attempt at recreating the might of your Mechs. If they are not evacuated, we cannot continue our efforts!",
        "The pilot of that exosuit knew the risks. I will inform our evac team of this sad news.",
    },
    Mission_tosx_Retracter_Destroyed = {
		"While testing the integrity of Vertex assets is an admirable goal, we need them intact to complete their missions!",
		"Those antennas help distribute energy throughout the Grid, commander. We already know they are fragile, so you do not have to test them so!",
    },
    Mission_tosx_Halcyte_Destroyed = {
		"These unique crystal strains are too dangerous to remain intact, fascinating as they would be to study.",
        "Vertex has consistently failed to harness those unique crystals as a power source. In the future we may try again, but for now this is the safest course!",
        "Such a shame, that we cannot harness the power within those unique crystals. But until we have a research breakthrough, they must be destroyed!",
    },
    Mission_tosx_Retracting = {
		"Excellent work! That antenna will soon be safely underground, preserving an important Vertex asset!",
		"If only we had the energy reserves and material resources to retrofit all our Grid buildings with such retraction mechanisms.",
		"That transmission tower will soon be underground, now that you've activated its defensive sequence.",
    },
    Mission_tosx_MeltingDown = {
		"My engineers would love to study the exponential increase in energy output that reactor is exhibiting, but we cannot risk damage to other Grid assets nearby. Destroy it, and we will learn what we can from the rubble!",
		"As you can see, Vertex assets are capable of unparalleled energy generation. Unfortunately, when they cannot be controlled, they must be destroyed to prevent harm to the Grid.",
		"I would love to see if our nearby structures could withstand that reactor's increasing output, but I fear I already know the answer. So destroy it, quickly!",
    },
    Mission_tosx_CrysGrowth = {
		"Vertex is never still. The crystals we seeded in our search for new energy sources continue to spread and grow!",
		"Those crystals hold nearly unlimited energy, but it is too dangerous to harvest them. Or even to approach them!",
		"Watch out, commander. New crystals are forming in this region. Their composition makes them incredible volatile.",
    },
	
}