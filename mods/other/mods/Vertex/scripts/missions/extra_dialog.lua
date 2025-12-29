--[[
Barks when...
    Mission_tosx_Retracting         ...Tower queues to retract      
    Mission_tosx_MeltingDown        ...Reactor explodes/needs to die
    Mission_tosx_CrysGrowth         ...Crystal mines grow           

    Mission_tosx_Scoutship_Destroyed
    Mission_tosx_Beamtank_Destroyed
    Mission_tosx_Phoenix_Destroyed
    Mission_tosx_Exosuit_Destroyed
    Mission_tosx_Retracter_Destroyed
    Mission_tosx_Halcyte_Destroyed
--]]

return {
	-- Archive generic
	Archive = {
        Mission_tosx_Scoutship_Destroyed = {
			"That airship wasn't very durable.",
			"That airship is scrap.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"That tank wasn't very durable.",
			"That laser tank is scrap.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"That Phoenix Project wasn't very durable.",
			"That resurrection tower is scrap.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"That exosuit wasn't very durable.",
			"That exosuit is scrap.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"That antenna wasn't very durable.",
			"That transmission tower is scrap.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal destroyed, commander.",
			"That crystal won't be a problem any more.",
		},
        Mission_tosx_Retracting = {
			"The tower's getting ready to retract.",
            "Antenna retraction mechanism engaged.",
		},
        Mission_tosx_MeltingDown = {
			"It's getting stronger!",
		},
        Mission_tosx_CrysGrowth = {
			"Watch out for those exploding crystals.",
		},
        
        
	},
	
	-- RST generic
	Rust = {
        Mission_tosx_Scoutship_Destroyed = {
			"That scout ship just blew up.",
			"Salazar's airship is down.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"That beam tank just blew up.",
			"Salazar's tank is down.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"That facility just blew up.",
			"Salazar's Phoenix Project is down.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"That exosuit just blew up.",
			"Salazar's exosuit is down.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"That transmission tower just blew up.",
			"Nothing left of that antenna to retract.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal destruction confirmed, commander.",
		},
        Mission_tosx_Retracting = {
			"Tower's getting ready to retract; keep defending it.",
		},
        Mission_tosx_MeltingDown = {
			"We need to kill that reactor before it wipes out this whole sector!",
		},
        Mission_tosx_CrysGrowth = {
			"More crystals. Watch your step.",
		},
	},
	
	-- Pinnacle generic
	Pinnacle = {
        Mission_tosx_Scoutship_Destroyed = {
			"[ Scout vessel has been destroyed ]",
			"[ Scout vessel is no longer intact ]",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"[ Allied tank has been destroyed ]",
			"[ Allied tank is no longer intact ]",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"[ Experimental facility has been destroyed ]",
			"[ Experimental facility is no longer intact ]",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"[ Allied exosuit has been destroyed ]",
			"[ Allied exosuit is no longer intact ]",
		},
        Mission_tosx_Retracter_Destroyed = {
			"[ Antenna has been destroyed ]",
			"[ Antenna is no longer intact ]",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"[ Volatile crystal has been neutralized ]",
			"[ Dangerous crystal has been removed ]",
		},
        Mission_tosx_Retracting = {
			"[ Antenna preparing to retract ]",
			"[ Preparing to defend antenna until retraction completed ]",
		},
        Mission_tosx_MeltingDown = {
			"[ Reactor yield increasing ]",
			"[ Reactor threat level rising ]",
		},
        Mission_tosx_CrysGrowth = {
			"[ Dangerous crystals have propagated ]",
		},
	},
	
	-- Detritus generic
	Detritus = {
        Mission_tosx_Scoutship_Destroyed = {
			"That airship wasn't very durable.",
			"We'll have to continue without the airship.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"That tank wasn't very durable.",
			"We'll have to continue without the laser tank.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"That facility wasn't very durable.",
			"We'll have to continue without the Phoenix Project. Don't get disabled now!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"That exosuit wasn't very durable.",
			"I don't think the pilot survived.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"That antenna wasn't very durable.",
			"We couldn't retract the antenna in time...",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal has been cleared out.",
			"Crystal disposed of.",
		},
        Mission_tosx_Retracting = {
			"That antenna should be safe once it finishes retracting.",
		},
        Mission_tosx_MeltingDown = {
			"Watch out!",
			"That reactor is destroying everything nearby!",
		},
        Mission_tosx_CrysGrowth = {
			"Don't get too close to those crystals!",
		},
	},
	
	-- AI generic
	Artificial = {
        Mission_tosx_Scoutship_Destroyed = {
			"Update: Scout unit destroyed",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Update: Laser unit destroyed",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Update: Revival unit destroyed",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Update: Support unit destroyed",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Update: Antenna destroyed",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Update: Crystal threat neutralized",
		},
        Mission_tosx_Retracting = {
			"Update: Antenna retraction in progress",
		},
        Mission_tosx_MeltingDown = {
			"Warning: Criticality event in progress",
		},
        Mission_tosx_CrysGrowth = {
			"Warning: Volatile crystal growth detected",
		},
	},

	-- Archimedes
	Aquatic = {
        Mission_tosx_Scoutship_Destroyed = {
			"I believe the Corporate Accords protect us from any liabilities resulting from the airship's loss.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"A waste of a perfectly functional combat vehicle.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"I regret to inform you all that the experimental facility has accrued numerous structural deficiencies.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"A waste of a perfectly functional combat vehicle.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"I regret to inform you all that the transmission facility has accrued numerous structural deficiencies.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"I have disposed of this threat to human safety.",
            "This crystal hazard has been sanitized.",
		},
        Mission_tosx_Retracting = {
			"This inefficient retraction system has been summarily engaged.",
		},
        Mission_tosx_MeltingDown = {
			"That reactor was clearly not constructed to Pinnacle specifications.",
		},
        Mission_tosx_CrysGrowth = {
			"These crystals risk impeding the structural integrity of our Mechs.",
		},
	},
	
	-- Abe Isamu
	Assassin = {
        Mission_tosx_Scoutship_Destroyed = {
			"The scout ship is destroyed.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"The tank is destroyed.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"The facility is destroyed.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"The exosuit is destroyed.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"The tower is destroyed.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal neutralized.",
		},
        Mission_tosx_Retracting = {
			"Get this thing out of my combat zone.",
		},
        Mission_tosx_MeltingDown = {
			"Now things are getting interesting.",
		},
        Mission_tosx_CrysGrowth = {
			"Those crystals will make excellent weapons.",
		},
	},
    
	-- Bethany Jones
	Genius = {
        Mission_tosx_Scoutship_Destroyed = {
			"No! We've lost the airship!",
			"Airship's disabled!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"No! We've lost the beam tank!",
			"Tank's disabled!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"No! We've lost the Phoenix Project!",
			"Resurrection facility's disabled!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"No! We've lost an exosuit!",
			"Exosuit's disabled!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"No! We've lost the antenna!",
			"Transmission tower's disabled!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal fragmentation complete.",
			"Crystal destroyed. I've gathered some fragments for analysis.",
		},
        Mission_tosx_Retracting = {
			"Transmission antenna is primed to retract.",
		},
        Mission_tosx_MeltingDown = {
			"That reaction isn't slowing down!",
		},
        Mission_tosx_CrysGrowth = {
			"This whole area is seeded with those volatile crystals.",
		},
	},
	
	-- Henry Kwan
	Hotshot = {
        Mission_tosx_Scoutship_Destroyed = {
			"Nothing we could do, that airship practically destroyed itself!",
			"Uh, did we really need that airship?",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Uh, did we need that tank?",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Did we really need that facility? The #squad has me!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Uh, did we need that exosuit?",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Hey, who was supposed to be watching that thing?",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Take that, crystal!",
			"Guess I won't be able to admire my reflection in that crystal any more.",
		},
        Mission_tosx_Retracting = {
			"Get this tower out of here, we've got work to do!",
			"I've retracted the antenna, can I go back to killing Vek now?",
		},
        Mission_tosx_MeltingDown = {
			"Someone left the reactor on the wrong setting!",
		},
        Mission_tosx_CrysGrowth = {
			"Hey, I bet the Vek would love these crystals!",
		},
	},
	
	-- Chen Rong
	Leader = {
        Mission_tosx_Scoutship_Destroyed = {
			"Airship's been destroyed!",
			"We lost the scout airship.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Laser tank's been destroyed!",
			"We lost the beam tank.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"The Phoenix Project's been destroyed!",
			"We lost the Phoenix Project.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Vertex exosuit's been destroyed!",
			"We lost the exosuit.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Tower's been destroyed!",
			"We lost one of the antennas.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal's neutralized.",
			"Crystal has been shattered.",
		},
        Mission_tosx_Retracting = {
			"Antenna's on its way to safety. Just have to buy it a little more time.",
		},
        Mission_tosx_MeltingDown = {
			"No way to fix that reactor at this point; destroy it quickly!",
		},
        Mission_tosx_CrysGrowth = {
			"Watch your step, those crystals are unstable.",
		},
	},
	
	-- Isaac Jones
	Medic = {
        Mission_tosx_Scoutship_Destroyed = {
			"S-S-Scout ship's been destroyed!",
			"We've l-lost the airship!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"T-T-Tank's been destroyed!",
			"We've l-lost the beam tank!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"The Phoenix P-P-Project's been destroyed!",
			"We've l-lost the facility!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Exosuit's b-b-been destroyed!",
			"We've l-lost one of the exosuits!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"T-T-Tower's been destroyed!",
			"We've l-lost the transmission antenna!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystals d-d-destroyed.",
			"One less crystal to w-w-worry about.",
		},
        Mission_tosx_Retracting = {
			"T-T-Tower is retracting now. M-M-Might take a few minutes.",
		},
        Mission_tosx_MeltingDown = {
			"The reactor is o-o-overloading!",
		},
        Mission_tosx_CrysGrowth = {
			"D-D-Don't step on those crystals.",
		},
	},

	-- Silica
	Miner = {
        Mission_tosx_Scoutship_Destroyed = {
			"Unauthorized destruction of Vertex property detected.",
			"Vertex scout ship destroyed.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Unauthorized destruction of Vertex property detected.",
			"Vertex laser vehicle destroyed.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Unauthorized destruction of Vertex property detected.",
			"Vertex research facility destroyed.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Unauthorized destruction of Vertex property detected.",
			"Vertex mechanized exoframe destroyed.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Unauthorized destruction of Vertex property detected.",
			"Vertex transmission facility destroyed.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal has fragmented.",
			"Authorized destruction of crystalline mass is complete.",
		},
        Mission_tosx_Retracting = {
			"Subterranean relocation of transmission facility underway.",
		},
        Mission_tosx_MeltingDown = {
			"Unauthorized incendiary rezoning of Vertex region.",
		},
        Mission_tosx_CrysGrowth = {
			"High-energy crystal growth detected.",
		},
	},
	
	-- Ralph Karlsson
	Original = {
        Mission_tosx_Scoutship_Destroyed = {
			"Airship's wrecked!",
			"Dammit!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Tank's lost!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"#squad, we lost the Vertex facility!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Exosuit's wrecked!",
			"Dammit!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"#squad, we lost the antenna!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"That crystal has been taken care of.",
			"This region will be safer without that crystal.",
		},
        Mission_tosx_Retracting = {
			"Power antenna retracting.",
		},
        Mission_tosx_MeltingDown = {
			"Stay clear of that reactor until we can decommission it!",
		},
        Mission_tosx_CrysGrowth = {
			"Watch out for exploding crystals!",
		},
	},
	
	-- Prospero
	Recycler = {
        Mission_tosx_Scoutship_Destroyed = {
			"Scout unit has been recycled.",
			"Scout unit recycled.",
			"Scouting functions inhibited.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Laser unit has been recycled.",
			"Laser unit recycled.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Vertex facility has been recycled.",
			"Experimental unit recycled.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Miniature combat unit has been recycled.",
			"Miniature combat unit recycled.",
			"Evacuation function now incomplete.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Transmission unit has been recycled.",
			"Energy transmitter recycled.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Hazardous crystal recycled.",
			"Chance of crystal spontaneously reforming: 0%.",
		},
        Mission_tosx_Retracting = {
			"Energy transmitter safety function engaged.",
		},
        Mission_tosx_MeltingDown = {
			"Energy reactor unit experiencing uncontained failure event.",
		},
        Mission_tosx_CrysGrowth = {
			"Spontaneous crystal formation detected.",
		},
	},
	
	-- Harold Schmidt
	Repairman = {
        Mission_tosx_Scoutship_Destroyed = {
			"That scouting vessel has unfortunately been lost.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"I was hoping to study that tank, and improve its efficiency for future operations.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"I was hoping to study that facility, and help Vertex improve its efficiency for future operations.",
			"The loss of that facility represents a substantial scientific setback.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"That combat exoskeleton has unfortunately been lost.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"That transmitter has been destroyed.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal destroyed. Hopefully some fragments survived for study.",
		},
        Mission_tosx_Retracting = {
			"Ah, I see how this works. Transmitter safety override engaged.",
		},
        Mission_tosx_MeltingDown = {
			"That reactor is well beyond its design specifications!",
		},
        Mission_tosx_CrysGrowth = {
			"Volatile crystal structures are forming across the region. Fascinating!",
		},
	},
	
	-- Camila Vera
	Soldier = {
        Mission_tosx_Scoutship_Destroyed = {
			"Airship's been destroyed.",
			"Airship's been lost, commander.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Tank has been destroyed.",
			"Tank's been lost.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"The Phoenix Project's been destroyed.",
			"The Phoenix Project's been lost, commander.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Exosuit's been destroyed.",
			"Exosuit's been lost, commander.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"One of the antennas has been destroyed.",
			"Antenna's been lost.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Good work destroying that crystal, #squad.",
		},
        Mission_tosx_Retracting = {
			"Engaging safety overrides. This antenna should retract soon. Protect it until then.",
		},
        Mission_tosx_MeltingDown = {
			"Take out that malfunctioning reactor before it destabilizes the whole region!",
		},
        Mission_tosx_CrysGrowth = {
			"Danger underfoot.",
		},
	},
	
	-- Gana
	Warrior = {
        Mission_tosx_Scoutship_Destroyed = {
			"Aircraft's components have failed to defend it.",
			"Aircraft's hull integrity is questionable.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Vehicle's components have failed to defend it.",
			"Vehicle's hull integrity is questionable.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Recover the remaining parts to interrogate them. This failure must be explained.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Exosuit's components have failed to defend it.",
			"Exosuit's hull integrity is questionable.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Transmitter unit has been decommissioned.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Crystal destroyed.",
			"Crystal decommissioned.",
		},
        Mission_tosx_Retracting = {
			"Transmitter unit has been ordered to retreat.",
		},
        Mission_tosx_MeltingDown = {
			"Reactor unit is failing to obey shutdown commands. Decommission by force.",
		},
        Mission_tosx_CrysGrowth = {
			"A volatile crystal formation will soon emerge.",
		},
	},
	
	-- Lily Reed
	Youth = {
        Mission_tosx_Scoutship_Destroyed = {
			"I think we just lost that airship.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"I think we just lost that laser tank.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"I think we just lost that research facility.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"I think we just lost that exosuit.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Whoops. We needed that antenna, right?",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Take that, crystal!",
			"Break it into shiny pieces!",
		},
        Mission_tosx_Retracting = {
			"Get underground, tower!",
		},
        Mission_tosx_MeltingDown = {
			"Uh, should that explosion be getting bigger?",
		},
        Mission_tosx_CrysGrowth = {
			"Watch your step, everyone!",
		},
	},
	
	-- Kazaaakpleth
	Mantis = {
        Mission_tosx_Scoutship_Destroyed = {
			"Tch'k; Jjk.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Tch'k; Jjk.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Tch'k; Jjk.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Tch'k; Jjk.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Tch'k; Jjk.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Tch'k; tch Jjk.",
		},
        Mission_tosx_Retracting = {
			"Kc'cht!",
		},
        Mission_tosx_MeltingDown = {
			"KC'CHT?!",
		},
        Mission_tosx_CrysGrowth = {
			"Kc'cht!",
		},
	},
	
	-- Adriane
	Rock = {
        Mission_tosx_Scoutship_Destroyed = {
			":: NNN-HR! HrrrRNN! ::",
		},
        Mission_tosx_Beamtank_Destroyed = {
			":: NNN-HR! HrrrRNN! ::",
		},
        Mission_tosx_Phoenix_Destroyed = {
			":: NNN-HR! HrrrRNN! ::",
		},
        Mission_tosx_Exosuit_Destroyed = {
			":: NNN-HR! HrrrRNN! ::",
		},
        Mission_tosx_Retracter_Destroyed = {
			":: NNN-HR! HrrrRNN! ::",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Rhnn-kk-n!",
		},
        Mission_tosx_Retracting = {
			":: Rhnnn-kk-k-n. ::",
		},
        Mission_tosx_MeltingDown = {
			"Rhnnn-kk-k-HNH!!",
		},
        Mission_tosx_CrysGrowth = {
			"Rhnn-kk-n!",
		},
	},
	
	-- Mafan
	Zoltan = {
        Mission_tosx_Scoutship_Destroyed = {
			"\\ *::*:.*: //",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"\\ *::*:.*: //",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"\\ *::*:.*: //",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"\\ *::*:.*: //",
		},
        Mission_tosx_Retracter_Destroyed = {
			"\\ *::*:.*: //",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"/ *::..: \ ",
		},
        Mission_tosx_Retracting = {
			"/ *:-:-: \ ",
		},
        Mission_tosx_MeltingDown = {
			"\ *:*::. /",
		},
        Mission_tosx_CrysGrowth = {
			"/ *::..: \ ",
		},
	},

	-- Kai
	Arrogant = {
        Mission_tosx_Scoutship_Destroyed = {
			"Well that's a bust.",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Not ideal. Not ideal.",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Not ideal. Not ideal.",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Not ideal. Not ideal.",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Well that's a bust.",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"These crystals make such a mess when they shatter.",
		},
        Mission_tosx_Retracting = {
			"Did we really need to retract these things ourselves?",
		},
        Mission_tosx_MeltingDown = {
			"That can't be good.",
		},
        Mission_tosx_CrysGrowth = {
			"Couldn't we have deployed somewhere without exploding crystals?",
		},
	},

	-- Rosie
	Caretaker = {
        Mission_tosx_Scoutship_Destroyed = {
			"That airship may be done for, but we're not!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"That tank may be done for, but we're not!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"Don't give up, we can keep going without that facility!",
			"The Phoenix Project may be dead, but I can still keep this squad on its feet!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"That exosuit may be done for, but we're not!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Don't give up, we can keep going without that antenna!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"What a shame to break such pretty gemstones.",
		},
        Mission_tosx_Retracting = {
			"A few quick modifications, and... there! Antenna is ready to retract!",
		},
        Mission_tosx_MeltingDown = {
			"Pretty sure that reactor can't be repaired at this point.",
			"We need to blow up that reactor before it blows us up!",
		},
        Mission_tosx_CrysGrowth = {
			"Tread lightly, lots of deadly gems in this soil.",
		},
	},

	-- Morgan
	Chemical = {
        Mission_tosx_Scoutship_Destroyed = {
			"Airship has been destroyed!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"Beam tank has been destroyed!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"The Phoenix Project has been destroyed!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"Exosuit has been destroyed!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"Tower has been destroyed!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"That crystal shouldn't cause any more problems.",
		},
        Mission_tosx_Retracting = {
			"Tower is ready to retract.",
		},
        Mission_tosx_MeltingDown = {
			"Better deal with that meltdown, quickly.",
		},
        Mission_tosx_CrysGrowth = {
			"New crystals emerging. Careful.",
		},
	},

	-- Adam
	Delusional = {
        Mission_tosx_Scoutship_Destroyed = {
			"We don't need that scout ship anyway!",
		},
        Mission_tosx_Beamtank_Destroyed = {
			"We don't need that tank anyway!",
		},
        Mission_tosx_Phoenix_Destroyed = {
			"We don't need that facility anyway!",
		},
        Mission_tosx_Exosuit_Destroyed = {
			"We don't need that exosuit anyway!",
		},
        Mission_tosx_Retracter_Destroyed = {
			"We don't need that transmitter anyway!",
		},
        Mission_tosx_Halcyte_Destroyed = {
			"Hardly a worthy adversary.",
		},
        Mission_tosx_Retracting = {
			"Such menial tasks; I must return to the glory of combat!",
		},
        Mission_tosx_MeltingDown = {
			"These people are running out of Time.",
		},
        Mission_tosx_CrysGrowth = {
			"Time seems to have accelerated the changes within this landscape.",
		},
	}
	
}