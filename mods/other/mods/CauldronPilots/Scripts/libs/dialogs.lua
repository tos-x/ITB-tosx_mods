
-- Notes: To use modApiExt's dialog functions, you need a version MORE RECENT than 1.12.260
-- Prior versions had bugs
-- modApiExt version 1.12.260 can be used, but you will need to adjust global.lua (copy this mod's file)

local function SelectedPersonalityRule(personality)
    return function(pawnId, cast)
        return Pawn and Pawn:GetId() == pawnId and Game:GetPawn(pawnId):GetPersonality() == personality
    end
end

local load = function()
	
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		if not GAME.convopause then
			-- We set a global "no conversations" flag so that multiple mods calling
			-- "Pilot_Story_Conversation" on move-undo can all check for this flag;
			-- only the first call will go through, and will then suppress others for
			-- 1 second
			GAME.convopause = true
			modApi:scheduleHook(1200, function()
				GAME.convopause = nil
			end)
			modapiext.dialog:triggerRuledDialog("Pilot_Story_Conversation")
			
		end
	end)
	
--[[
	modApi:addVoiceEventHook(function(eventInfo, customOdds, suppress)
		LOG("eid: "..eventInfo.id)
		if eventInfo.id == "Pilot_Story_Conversation" and not suppress then
			GAME.convopause = true
		end
	end)
	
--]]
	-- Just to be safe, we clear the flag at mission start as well:
	modApi:addMissionStartHook(function(mission)
		GAME.convopause = nil
	end)
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Assassin_Soldier1" },
			{ main = "Convo_Assassin_Soldier2" },
			{ other = "Convo_Assassin_Soldier3" },
			{ main = "Convo_Assassin_Soldier4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Assassin"),
			other = PersonalityRule("Soldier")
		}
	})-- Abe, Camila
		
	Personality.Soldier.Convo_Assassin_Soldier1 = { "So, does anyone still call you 'Honest #main_first' to your face?" }
	Personality.Assassin.Convo_Assassin_Soldier2 = { "Those who remember that name are no longer around to use it." }
	Personality.Soldier.Convo_Assassin_Soldier3 = { "Except me." }
	Personality.Assassin.Convo_Assassin_Soldier4 = { "Perhaps that should serve as a warning, #other_second." }

------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Knight_Drift1" },
			{ main = "Convo_Knight_Drift2" },
			{ other = "Convo_Knight_Drift3" },
			{ main = "Convo_Knight_Drift4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Knight"),
			other = PersonalityRule("Drift")
		}
	})
	Personality.Drift.Convo_Knight_Drift1 = { "Are you really from Old Earth, Sir #main_first? I mean, knights and castles and stuff?" }
	Personality.Knight.Convo_Knight_Drift2 = { "Those things did exist in my time, yes." }
	Personality.Drift.Convo_Knight_Drift3 = { "Were there dragons?" }
	Personality.Knight.Convo_Knight_Drift4 = { "None that I saw. Why, are there not enough monsters for you here?" }

------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Cricket_Echelon1" },
			{ other = "Convo_Cricket_Echelon2" },
			{ main = "Convo_Cricket_Echelon3" },
			{ other = "Convo_Cricket_Echelon4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cricket"),
			other = PersonalityRule("Echelon")
		}
	})
	Personality.Cricket.Convo_Cricket_Echelon1 = { "Miss #other_second, you know I can hear you grumbling over there, right?" }
	Personality.Echelon.Convo_Cricket_Echelon2 = { "Well if you'd keep your super hearing aids to yourself I'd have one less thing to grumble about." }
	Personality.Cricket.Convo_Cricket_Echelon3 = { "See if I warn you next time I hear something tunneling up under your Mech." }
	Personality.Echelon.Convo_Cricket_Echelon4 = { "That's the spirit, kid." }

------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Tango_Terminus1" },
			{ main = "Convo_Tango_Terminus2" },
			{ other = "Convo_Tango_Terminus3" },
			{ main = "Convo_Tango_Terminus4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Tango"),
			other = PersonalityRule("Terminus")
		}
	})
	Personality.Terminus.Convo_Tango_Terminus1 = { "I never could get a bead on you mercenary types." }
	Personality.Tango.Convo_Tango_Terminus2 = { "Why? Because I trust money more than people?" }
	Personality.Terminus.Convo_Tango_Terminus3 = { "Yeah. How's that working out, now that we're all fighting to save the world pro bono?" }
	Personality.Tango.Convo_Tango_Terminus4 = { "It's just a different kind of paycheck, Officer #other_second." }

------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gray_Vanish1" },
			{ main = "Convo_Gray_Vanish2" },
			{ other = "Convo_Gray_Vanish3" },
			{ main = "Convo_Gray_Vanish4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gray"),
			other = PersonalityRule("Vanish")
		}
	})
	Personality.Vanish.Convo_Gray_Vanish1 = { "You holding it together over there, #main_second?" }
	Personality.Gray.Convo_Gray_Vanish2 = { "As best I can, given the circumstances." }
	Personality.Vanish.Convo_Gray_Vanish3 = { "Well, the squad has your back. Although we'd still appreciate some warning if you feel the need to go nuclear." }
	Personality.Gray.Convo_Gray_Vanish4 = { "Trust me, #other_second, I'm in no hurry to explode and kill us all." }

------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Gyrosaur_Starlight1" },
			{ other = "Convo_Gyrosaur_Starlight2" },
			{ main = "Convo_Gyrosaur_Starlight3" },
			{ other = "Convo_Gyrosaur_Starlight4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gyrosaur"),
			other = PersonalityRule("Starlight")
		}
	})
	Personality.Gyrosaur.Convo_Gyrosaur_Starlight1 = { "I managed not to trip over anything!" }
	Personality.Starlight.Convo_Gyrosaur_Starlight2 = { "#main_full, we do not have time for this." }
	Personality.Gyrosaur.Convo_Gyrosaur_Starlight3 = { "But I just replaced all of #main_mech's ventral control actuators and I wasn't sure if they were working at full capacity. They are!" }
	Personality.Starlight.Convo_Gyrosaur_Starlight4 = { "Oh... I see." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Cypher_Impact1" },
			{ main = "Convo_Cypher_Impact2" },
			{ other = "Convo_Cypher_Impact3" },
			{ main = "Convo_Cypher_Impact4" },
			{ other = "Convo_Cypher_Impact5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cypher"),
			other = PersonalityRule("Impact")
		}
	})
	Personality.Impact.Convo_Cypher_Impact1 = { "What's it like, having all that nanotech as part of yourself?" }
	Personality.Cypher.Convo_Cypher_Impact2 = { "You get used to it." }
	Personality.Impact.Convo_Cypher_Impact3 = { "That's almost a scary thought." }
	Personality.Cypher.Convo_Cypher_Impact4 = { "Well, what's it like carrying a stabilized black hole around in your Mech?" }
	Personality.Impact.Convo_Cypher_Impact5 = { "... You get used to it." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Malichae_Mara1" },
			{ main = "Convo_Malichae_Mara2" },
			{ other = "Convo_Malichae_Mara3" },
			{ main = "Convo_Malichae_Mara4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Malichae"),
			other = PersonalityRule("Mara")
		}
	})
	Personality.Mara.Convo_Malichae_Mara1 = { "#main_first, that hologram tech is amazing, by the way. I would have killed to have it in my old job." }
	Personality.Malichae.Convo_Malichae_Mara2 = { "You know I saw one of your shows, once. Before the Vek on Archive got so bad." }
	Personality.Mara.Convo_Malichae_Mara3 = { "Those were the days." }
	Personality.Malichae.Convo_Malichae_Mara4 = { "That disappearing act in the finale could still come in handy, if we get overrun here." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Stranger_Baccarat1" },
			{ main = "Convo_Stranger_Baccarat2" },
			{ other = "Convo_Stranger_Baccarat3" },
			{ main = "Convo_Stranger_Baccarat4" },
			{ other = "Convo_Stranger_Baccarat5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Stranger"),
			other = PersonalityRule("Baccarat")
		}
	})
	Personality.Baccarat.Convo_Stranger_Baccarat1 = { "I been meanin' to ask how come you look so tree-like, #main_full?" }
	Personality.Stranger.Convo_Stranger_Baccarat2 = { "I am afraid the past is not my strong suit. I have no recollection of... whatever came before this." }
	Personality.Baccarat.Convo_Stranger_Baccarat3 = { "By the time this war's over, I wager most will want to forget things we've seen." }
	Personality.Stranger.Convo_Stranger_Baccarat4 = { "Do you already number among these hypothetical people?" }
	Personality.Baccarat.Convo_Stranger_Baccarat5 = { "That would be telling." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gargoyle_Necro1" },
			{ main = "Convo_Gargoyle_Necro2" },
			{ other = "Convo_Gargoyle_Necro3" },
			{ main = "Convo_Gargoyle_Necro4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gargoyle"),
			other = PersonalityRule("Necro")
		}
	})
	Personality.Necro.Convo_Gargoyle_Necro1 = { "Many pilots do not care for my... experiments. Does that explain your silence today, #main_full?" }
	Personality.Gargoyle.Convo_Gargoyle_Necro2 = { "... My biosuit can siphon energy from these creatures to empower me. What you do is not so different." }
	Personality.Necro.Convo_Gargoyle_Necro3 = { "Except for the zombie spiders." }
	Personality.Gargoyle.Convo_Gargoyle_Necro4 = { "Except for those." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Low_Titan1" },
			{ main = "Convo_Low_Titan2" },
			{ other = "Convo_Low_Titan3" },
			{ main = "Convo_Low_Titan4" },
			{ other = "Convo_Low_Titan5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Low"),
			other = PersonalityRule("Titan")
		}
	})
	Personality.Titan.Convo_Low_Titan1 = { "I suppose you never have to worry about unseasonable weather, eh?" }
	Personality.Low.Convo_Low_Titan2 = { "Quite the other way around. Why, what do you worry about?" }
	Personality.Titan.Convo_Low_Titan3 = { "These days? Mostly the end of the world, I guess." }
	Personality.Low.Convo_Low_Titan4 = { "Well, today the sun is still shining." }
	Personality.Titan.Convo_Low_Titan5 = { "I suppose it is." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Titan_Cricket1" },
			{ main = "Convo_Titan_Cricket2" },
			{ other = "Convo_Titan_Cricket3" },
			{ main = "Convo_Titan_Cricket4" },
			{ other = "Convo_Titan_Cricket5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Titan"),
			other = PersonalityRule("Cricket")
		}
	})
	Personality.Cricket.Convo_Titan_Cricket1 = { "So when do the rest of us get our own sets of that Titan Armor?" }
	Personality.Titan.Convo_Titan_Cricket2 = { "You teach me how you get that Mech jumping over buildings, and I'll try explaining how to work my armor." }
	Personality.Cricket.Convo_Titan_Cricket3 = { "What's to teach? You just... jump!" }
	Personality.Titan.Convo_Titan_Cricket4 = { "And I'm sure the hangar crews love checking for impact fractures afterwards." }
	Personality.Cricket.Convo_Titan_Cricket5 = { "Well... not so much." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Mara_Echelon1" },
			{ main = "Convo_Mara_Echelon2" },
			{ other = "Convo_Mara_Echelon3" },
			{ main = "Convo_Mara_Echelon4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Mara"),
			other = PersonalityRule("Echelon")
		}
	})
	Personality.Echelon.Convo_Mara_Echelon1 = { "I never thought I'd see a wizard piloting a Mech." }
	Personality.Mara.Convo_Mara_Echelon2 = { "That's not... I was a stage magician." }
	Personality.Echelon.Convo_Mara_Echelon3 = { "Well, I appreciate you not turning anyone into rabbits." }
	Personality.Mara.Convo_Mara_Echelon4 = { "Do you have this much fun with all the pilots, of just the ones you trained?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gyrosaur_Quicksilver1" },
			{ main = "Convo_Gyrosaur_Quicksilver2" },
			{ other = "Convo_Gyrosaur_Quicksilver3" },
			{ main = "Convo_Gyrosaur_Quicksilver4" },
			{ other = "Convo_Gyrosaur_Quicksilver5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gyrosaur"),
			other = PersonalityRule("Quicksilver")
		}
	})
	Personality.Quicksilver.Convo_Gyrosaur_Quicksilver1 = { "Hey turtle, you like destroying everything, right?" }
	Personality.Gyrosaur.Convo_Gyrosaur_Quicksilver2 = { "Not on purpose!" }
	Personality.Quicksilver.Convo_Gyrosaur_Quicksilver3 = { "No, I meant that as a compliment. I'm similarly inclined." }
	Personality.Gyrosaur.Convo_Gyrosaur_Quicksilver4 = { "Oh. Great!" }
	Personality.Quicksilver.Convo_Gyrosaur_Quicksilver5 = { "We're going to wipe the floor with these Vek." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Low_Gray1" },
			{ main = "Convo_Low_Gray2" },
			{ other = "Convo_Low_Gray3" },
			{ main = "Convo_Low_Gray4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Low"),
			other = PersonalityRule("Gray")
		}
	})
	Personality.Gray.Convo_Low_Gray1 = { "You are certainly a strange sight, my lady." }
	Personality.Low.Convo_Low_Gray2 = { "Everything about this world is strange. Even you, #other_second." }
	Personality.Gray.Convo_Low_Gray3 = { "I used to be normal, once. Did you?" }
	Personality.Low.Convo_Low_Gray4 = { "Not in the way you mean." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Tango_Vanish1" },
			{ other = "Convo_Tango_Vanish2" },
			{ main = "Convo_Tango_Vanish3" },
			{ other = "Convo_Tango_Vanish4" },
			{ main = "Convo_Tango_Vanish5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Tango"),
			other = PersonalityRule("Vanish")
		}
	})
	Personality.Tango.Convo_Tango_Vanish1 = { "I wish my old Chameleon Armor could be scaled up to a Mech; I miss invisibly sniping the bad guys." }
	Personality.Vanish.Convo_Tango_Vanish2 = { "#main_first, you're in a giant robot. And you want to be inconspicuous?" }
	Personality.Tango.Convo_Tango_Vanish3 = { "Says the woman who still lugs her breach teleporter everywhere." }
	Personality.Vanish.Convo_Tango_Vanish4 = { "... That's completely different." }
	Personality.Tango.Convo_Tango_Vanish5 = { "I'm just saying, if you get your old gear, I should get mine." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Drift_Terminus1" },
			{ main = "Convo_Drift_Terminus2" },
			{ other = "Convo_Drift_Terminus3" },
			{ main = "Convo_Drift_Terminus4" },
			{ other = "Convo_Drift_Terminus5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Drift"),
			other = PersonalityRule("Terminus")
		}
	})
	Personality.Terminus.Convo_Drift_Terminus1 = { "#main_second, can you stop flashing and flickering? I'm getting a headache." }
	Personality.Drift.Convo_Drift_Terminus2 = { "Sorry; ever since training I can't stay properly in the timestream." }
	Personality.Terminus.Convo_Drift_Terminus3 = { "I heard about your accident. At least there were some upsides." }
	Personality.Drift.Convo_Drift_Terminus4 = { "I... heard about yours, too. Does... your other eye still work?" }
	Personality.Terminus.Convo_Drift_Terminus5 = { "Why? Do I need two eyes to kill Vek?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Stranger_Gargoyle1" },
			{ main = "Convo_Stranger_Gargoyle2" },
			{ other = "Convo_Stranger_Gargoyle3" },
			{ main = "Convo_Stranger_Gargoyle4" },
			{ other = "Convo_Stranger_Gargoyle5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Stranger"),
			other = PersonalityRule("Gargoyle")
		}
	})
	Personality.Gargoyle.Convo_Stranger_Gargoyle1 = { "So how bad did things get, in your original timeline?" }
	Personality.Stranger.Convo_Stranger_Gargoyle2 = { "You mean, after the Vek won? I should think the answer was obvious." }
	Personality.Gargoyle.Convo_Stranger_Gargoyle3 = { "I wouldn't know; I escaped from mine right after the end. Not everyone did." }
	Personality.Stranger.Convo_Stranger_Gargoyle4 = { "Perhaps I was one of them, and it was the same timeline..." }
	Personality.Gargoyle.Convo_Stranger_Gargoyle5 = { "Well, at least you survived." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Starlight_Cypher1" },
			{ main = "Convo_Starlight_Cypher2" },
			{ other = "Convo_Starlight_Cypher3" },
			{ main = "Convo_Starlight_Cypher4" },
			{ other = "Convo_Starlight_Cypher5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Starlight"),
			other = PersonalityRule("Cypher")
		}
	})
	Personality.Cypher.Convo_Starlight_Cypher1 = { "Before you joined as a pilot, Doctor #main_second, you did satellite recon, right?" }
	Personality.Starlight.Convo_Starlight_Cypher2 = { "Yes. Everything was beautiful and impersonal, viewed from space." }
	Personality.Cypher.Convo_Starlight_Cypher3 = { "Even when aiming an orbital laser?" }
	Personality.Starlight.Convo_Starlight_Cypher4 = { "That does tend to feel a little more personal." }
	Personality.Cypher.Convo_Starlight_Cypher5 = { "It's certainly a beautiful sight." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Baccarat_Doc1" },
			{ main = "Convo_Baccarat_Doc2" },
			{ main = "Convo_Baccarat_Doc3" },
			{ other = "Convo_Baccarat_Doc4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Baccarat"),
			other = PersonalityRule("Doc")
		}
	})
	Personality.Doc.Convo_Baccarat_Doc1 = { "#main_second. I heard you don't like fighting fair." }
	Personality.Baccarat.Convo_Baccarat_Doc2 = { "You know how 'tis, Doc: stabbing 'em in the back is just more efficient." }
	Personality.Baccarat.Convo_Baccarat_Doc3 = { "Why, you planning to report me?" }
	Personality.Doc.Convo_Baccarat_Doc4 = { "No... I was hoping to learn how to do it." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Necro_Knight1" },
			{ main = "Convo_Necro_Knight2" },
			{ other = "Convo_Necro_Knight3" },
			{ main = "Convo_Necro_Knight4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Necro"),
			other = PersonalityRule("Knight")
		}
	})
	Personality.Knight.Convo_Necro_Knight1 = { "Everyone keeps telling me that magic does not exist... but your necromancy would seem to belie that, Sir #main_first." }
	Personality.Necro.Convo_Necro_Knight2 = { "Necromancy... I suppose the term is apt. But truly, it is science." }
	Personality.Knight.Convo_Necro_Knight3 = { "Most science is not so... gruesome." }
	Personality.Necro.Convo_Necro_Knight4 = { "I know! Isn't it wonderful?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Quicksilver_Doc1" },
			{ main = "Convo_Quicksilver_Doc2" },
			{ other = "Convo_Quicksilver_Doc3" },
			{ main = "Convo_Quicksilver_Doc4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Quicksilver"),
			other = PersonalityRule("Doc")
		}
	})
	Personality.Doc.Convo_Quicksilver_Doc1 = { "You slowing down there, #main_first? I thought that magic metal was supposed to keep you tip-top." }
	Personality.Quicksilver.Convo_Quicksilver_Doc2 = { "Just giving you a chance to catch up, #other_second." }
	Personality.Doc.Convo_Quicksilver_Doc3 = { "Well, let me know the minute they figure out how to mass-produce that experimental polyalloy." }
	Personality.Quicksilver.Convo_Quicksilver_Doc4 = { "I thought that's what we had you for, Doc." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Impact_Malichae1" },
			{ main = "Convo_Impact_Malichae2" },
			{ other = "Convo_Impact_Malichae3" },
			{ main = "Convo_Impact_Malichae4" },
			{ other = "Convo_Impact_Malichae5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Impact"),
			other = PersonalityRule("Malichae")
		}
	})
	Personality.Malichae.Convo_Impact_Malichae1 = { "Just to make sure I have this straight, your tech ensures that any Vek surrounding you are going to KEEP surround you?" }
	Personality.Impact.Convo_Impact_Malichae2 = { "It's better than having them go after the Grid or civilians, isn't it?" }
	Personality.Malichae.Convo_Impact_Malichae3 = { "Sure, but... not by much." }
	Personality.Impact.Convo_Impact_Malichae4 = { "Hasn't gotten me killed yet." }
	Personality.Malichae.Convo_Impact_Malichae5 = { "... In this timeline." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Low_Baccarat1" },
			{ main = "Convo_Low_Baccarat2" },
			{ other = "Convo_Low_Baccarat3" },
			{ main = "Convo_Low_Baccarat4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Low"),
			other = PersonalityRule("Baccarat")
		}
	})
	Personality.Baccarat.Convo_Low_Baccarat1 = { "Hey lady, you ever played cards before? In whatever magic wood you came from?" }
	Personality.Low.Convo_Low_Baccarat2 = { "No. Will you teach me this game?" }
	Personality.Baccarat.Convo_Low_Baccarat3 = { "Sure thing; we can round up the hangar crews tonight and play for Reactor Cores." }
	Personality.Low.Convo_Low_Baccarat4 = { "I would like more of those!" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Stranger_Malichae1" },
			{ main = "Convo_Stranger_Malichae2" },
			{ other = "Convo_Stranger_Malichae3" },
			{ main = "Convo_Stranger_Malichae4" },
			{ other = "Convo_Stranger_Malichae5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Stranger"),
			other = PersonalityRule("Malichae")
		}
	})
	Personality.Malichae.Convo_Stranger_Malichae1 = { "So how big is the hole in your memory, #main_full? Do you even remember which island you were from?" }
	Personality.Stranger.Convo_Stranger_Malichae2 = { "Only vaguely. I... remember plants. Lots of them." }
	Personality.Malichae.Convo_Stranger_Malichae3 = { "Sounds like Archive?" }
	Personality.Stranger.Convo_Stranger_Malichae4 = { "Some of these plants ate people. And Mechs." }
	Personality.Malichae.Convo_Stranger_Malichae5 = { "Soooo probably not Archive, then." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_AZ_Mara1" },
			{ main = "Convo_AZ_Mara2" },
			{ other = "Convo_AZ_Mara3" },
			{ main = "Convo_AZ_Mara4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("AZ"),
			other = PersonalityRule("Mara")
		}
	})
	Personality.Mara.Convo_AZ_Mara1 = { "You giving me the cold shoulder, #main_second?" }
	Personality.AZ.Convo_AZ_Mara2 = { "Har har. I didn't realize you were a comedian." }
	Personality.Mara.Convo_AZ_Mara3 = { "Sorry. Sensitive subject?" }
	Personality.AZ.Convo_AZ_Mara4 = { "Well, if you ever find yourself trapped in a cryo-suit for the rest of your life, you can let me know." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Cricket_Impact1" },
			{ other = "Convo_Cricket_Impact2" },
			{ main = "Convo_Cricket_Impact3" },
			{ other = "Convo_Cricket_Impact4" },
			{ main = "Convo_Cricket_Impact5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cricket"),
			other = PersonalityRule("Impact")
		}
	})
	Personality.Cricket.Convo_Cricket_Impact1 = { "#other_first, you ever wonder if there's a timeline where none of this happened? No Vek?" }
	Personality.Impact.Convo_Cricket_Impact2 = { "A timeline with versions of us doing normal things right now?" }
	Personality.Cricket.Convo_Cricket_Impact3 = { "Yeah. I don't even know what that means anymore." }
	Personality.Impact.Convo_Cricket_Impact4 = { "Every timeline I've heard the travelers talk about... the invasion always happened. And things were always dire." }
	Personality.Cricket.Convo_Cricket_Impact5 = { "Then I guess this is normal." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Gargoyle_Mara1" },
			{ other = "Convo_Gargoyle_Mara2" },
			{ main = "Convo_Gargoyle_Mara3" },
			{ other = "Convo_Gargoyle_Mara4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gargoyle"),
			other = PersonalityRule("Mara")
		}
	})
	Personality.Gargoyle.Convo_Gargoyle_Mara1 = { "#other_second, you have an eye for misdirection; how would you take the initiative from these Vek?" }
	Personality.Mara.Convo_Gargoyle_Mara2 = { "I figured I'd defer to you; don't you have years of experience fighting them?" }
	Personality.Gargoyle.Convo_Gargoyle_Mara3 = { "Yes, but we lost. Don't undervalue your perspective." }
	Personality.Mara.Convo_Gargoyle_Mara4 = { "Hmm. Do they like magic tricks?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ main = "Convo_Cricket_AZ1" },
			{ other = "Convo_Cricket_AZ2" },
			{ main = "Convo_Cricket_AZ3" },
			{ other = "Convo_Cricket_AZ4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cricket"),
			other = PersonalityRule("AZ")
		}
	})
	Personality.Cricket.Convo_Cricket_AZ1 = { "I wish the folks in those buildings would chatter less. I can't keep from hearing it all." }
	Personality.AZ.Convo_Cricket_AZ2 = { "You don't get to throw stones, #main_second; you're the chattiest one here." }
	Personality.Cricket.Convo_Cricket_AZ3 = { "I am not! Am I?" }
	Personality.AZ.Convo_Cricket_AZ4 = { "You're like some noisy little cricket, always chirping away." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gray_Terminus1" },
			{ main = "Convo_Gray_Terminus2" },
			{ other = "Convo_Gray_Terminus3" },
			{ main = "Convo_Gray_Terminus4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gray"),
			other = PersonalityRule("Terminus")
		}
	})
	Personality.Terminus.Convo_Gray_Terminus1 = { "I still can't believe Detritus just pardoned you and stuck you in a Mech, #main_second." }
	Personality.Gray.Convo_Gray_Terminus2 = { "You'd prefer I was penitent AND useless?" }
	Personality.Terminus.Convo_Gray_Terminus3 = { "I don't want to see anyone else get killed because of you and your delusions." }
	Personality.Gray.Convo_Gray_Terminus4 = { "I'll do my best." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Tango_Titan1" },
			{ main = "Convo_Tango_Titan2" },
			{ other = "Convo_Tango_Titan3" },
			{ main = "Convo_Tango_Titan4" },
			{ other = "Convo_Tango_Titan5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Tango"),
			other = PersonalityRule("Titan")
		}
	})
	Personality.Titan.Convo_Tango_Titan1 = { "I gotta ask, #main_second: you really carrying some old rifle around in the cockpit of your Mech?" }
	Personality.Tango.Convo_Tango_Titan2 = { "Yes." }
	Personality.Titan.Convo_Tango_Titan3 = { "And you're taking potshots at Vek from your escape hatch?" }
	Personality.Tango.Convo_Tango_Titan4 = { "Yes." }
	Personality.Titan.Convo_Tango_Titan5 = { "Damn." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Vanish_Starlight1" },
			{ main = "Convo_Vanish_Starlight2" },
			{ other = "Convo_Vanish_Starlight3" },
			{ main = "Convo_Vanish_Starlight4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Vanish"),
			other = PersonalityRule("Starlight")
		}
	})
	Personality.Starlight.Convo_Vanish_Starlight1 = { "How far can you travel with that teleporter, #main_first?" }
	Personality.Vanish.Convo_Vanish_Starlight2 = { "If I have solid readings on the landing site? A few miles, easy." }
	Personality.Starlight.Convo_Vanish_Starlight3 = { "Perhaps we should be developing that technology so that if the Vek win, we can escape. All of us, not just a few time travelers." }
	Personality.Vanish.Convo_Vanish_Starlight4 = { "Let's hope it doesn't come to that." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Doc_Echelon1" },
			{ main = "Convo_Doc_Echelon2" },
			{ other = "Convo_Doc_Echelon3" },
			{ main = "Convo_Doc_Echelon4" },
			{ other = "Convo_Doc_Echelon5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Doc"),
			other = PersonalityRule("Echelon")
		}
	})
	Personality.Echelon.Convo_Doc_Echelon1 = { "Havoc." }
	Personality.Doc.Convo_Doc_Echelon2 = { "Martin." }
	Personality.Echelon.Convo_Doc_Echelon3 = { "I'm supposed to be training rookie pilots. What are they giving me old hats like you for?" }
	Personality.Doc.Convo_Doc_Echelon4 = { "I may have requested a transfer to the #squad after I heard my old instructor was piloting again." }
	Personality.Echelon.Convo_Doc_Echelon5 = { "Well, I'm glad to see you." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Drift_Gyrosaur1" },
			{ main = "Convo_Drift_Gyrosaur2" },
			{ other = "Convo_Drift_Gyrosaur3" },
			{ main = "Convo_Drift_Gyrosaur4" },
			{ other = "Convo_Drift_Gyrosaur5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Drift"),
			other = PersonalityRule("Gyrosaur")
		}
	})
	Personality.Gyrosaur.Convo_Drift_Gyrosaur1 = { "Miss #main_first, can you really see into the future?" }
	Personality.Drift.Convo_Drift_Gyrosaur2 = { "A little bit, I guess." }
	Personality.Gyrosaur.Convo_Drift_Gyrosaur3 = { "That sounds confusing. Wait, what am I about to do?" }
	Personality.Drift.Convo_Drift_Gyrosaur4 = { "Haha, it changes when I tell you, #other_first." }
	Personality.Gyrosaur.Convo_Drift_Gyrosaur5 = { "Shoot." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Knight_Quicksilver1" },
			{ main = "Convo_Knight_Quicksilver2" },
			{ other = "Convo_Knight_Quicksilver3" },
			{ main = "Convo_Knight_Quicksilver4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Knight"),
			other = PersonalityRule("Quicksilver")
		}
	})
	Personality.Quicksilver.Convo_Knight_Quicksilver1 = { "You're pretty handy with that #main_mech, for someone claiming to hail from the medieval era." }
	Personality.Knight.Convo_Knight_Quicksilver2 = { "The fact that our technology was less advanced did not make it any less complex to operate. Are you familiar with horses?" }
	Personality.Quicksilver.Convo_Knight_Quicksilver3 = { "Those were Old Earth beasts of burden, right?" }
	Personality.Knight.Convo_Knight_Quicksilver4 = { "Yes. Imagine piloting something with a mind of its own." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Cypher_Necro1" },
			{ main = "Convo_Cypher_Necro2" },
			{ other = "Convo_Cypher_Necro3" },
			{ main = "Convo_Cypher_Necro4" },
			{ other = "Convo_Cypher_Necro5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cypher"),
			other = PersonalityRule("Necro")
		}
	})
	Personality.Necro.Convo_Cypher_Necro1 = { "I've heard the stories about you, #main_second. You practically brought yourself back from the dead." }
	Personality.Cypher.Convo_Cypher_Necro2 = { "These nanites are meant to repair and rebuild, #other_second. Please don't get any ideas." }
	Personality.Necro.Convo_Cypher_Necro3 = { "That would seem to be an extremely narrow application of their full potential." }
	Personality.Cypher.Convo_Cypher_Necro4 = { "Have you never watched any of Archive's preserved horror vids?" }
	Personality.Necro.Convo_Cypher_Necro5 = { "No, why?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Knight_Low1" },
			{ main = "Convo_Knight_Low2" },
			{ other = "Convo_Knight_Low3" },
			{ main = "Convo_Knight_Low4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Knight"),
			other = PersonalityRule("Low")
		}
	})
	Personality.Low.Convo_Knight_Low1 = { "Sir #main_first of #main_second... someone of that name once visited me, in the old forest." }
	Personality.Knight.Convo_Knight_Low2 = { "And I once met a lady of the wood, who looked as you do." }
	Personality.Low.Convo_Knight_Low3 = { "I did not think to see you again." }
	Personality.Knight.Convo_Knight_Low4 = { "It seems our roads to this place were equally long." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Doc_Gray1" },
			{ main = "Convo_Doc_Gray2" },
			{ other = "Convo_Doc_Gray3" },
			{ main = "Convo_Doc_Gray4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Doc"),
			other = PersonalityRule("Gray")
		}
	})
	Personality.Gray.Convo_Doc_Gray1 = { "You are an actual doctor, right #main_second? That's not just a call sign?" }
	Personality.Doc.Convo_Doc_Gray2 = { "Yeah, but the Vek don't leave a lot of injured behind. So I learned to patch up Mechs." }
	Personality.Gray.Convo_Doc_Gray3 = { "What did you tell those who knew their time was short?" }
	Personality.Doc.Convo_Doc_Gray4 = { "Don't waste it." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Cricket_Quicksilver1" },
			{ main = "Convo_Cricket_Quicksilver2" },
			{ other = "Convo_Cricket_Quicksilver3" },
			{ main = "Convo_Cricket_Quicksilver4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cricket"),
			other = PersonalityRule("Quicksilver")
		}
	})
	Personality.Quicksilver.Convo_Cricket_Quicksilver1 = { "What's with the headgear, #main_second?" }
	Personality.Cricket.Convo_Cricket_Quicksilver2 = { "I lost my hearing when I was younger. Vek attack." }
	Personality.Quicksilver.Convo_Cricket_Quicksilver3 = { "So now it's time for revenge?" }
	Personality.Cricket.Convo_Cricket_Quicksilver4 = { "Well, I also lost most of my family. So yeah, it's about that time." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Drift_Mara1" },
			{ main = "Convo_Drift_Mara2" },
			{ other = "Convo_Drift_Mara3" },
			{ main = "Convo_Drift_Mara4" },
			{ other = "Convo_Drift_Mara5" },
			{ main = "Convo_Drift_Mara6" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Drift"),
			other = PersonalityRule("Mara")
		}
	})
	Personality.Mara.Convo_Drift_Mara1 = { "You seem pretty young for a Pilot, #main_second." }
	Personality.Drift.Convo_Drift_Mara2 = { "I got temporally desynchronized for a year; so technically I'm older than I look." }
	Personality.Mara.Convo_Drift_Mara3 = { "You mean, like, stuck outside of time?" }
	Personality.Drift.Convo_Drift_Mara4 = { "Basically." }
	Personality.Mara.Convo_Drift_Mara5 = { "Sounds terrifying." }
	Personality.Drift.Convo_Drift_Mara6 = { "It was mostly boring." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Titan_Necro1" },
			{ main = "Convo_Titan_Necro2" },
			{ other = "Convo_Titan_Necro3" },
			{ main = "Convo_Titan_Necro4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Titan"),
			other = PersonalityRule("Necro")
		}
	})
	Personality.Necro.Convo_Titan_Necro1 = { "I hear that you worked for a rather interesting organization in your original timeline, #main_second." }
	Personality.Titan.Convo_Titan_Necro2 = { "That was classified, #other_second." }
	Personality.Necro.Convo_Titan_Necro3 = { "Does it still apply, if the organization doesn't even exist in this reality?" }
	Personality.Titan.Convo_Titan_Necro4 = { "Probably not, but old habits die hard." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Stranger_Tango1" },
			{ main = "Convo_Stranger_Tango2" },
			{ other = "Convo_Stranger_Tango3" },
			{ main = "Convo_Stranger_Tango4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Stranger"),
			other = PersonalityRule("Tango")
		}
	})
	Personality.Tango.Convo_Stranger_Tango1 = { "I like your preemptive approach to the Vek, #main_full." }
	Personality.Stranger.Convo_Stranger_Tango2 = { "In the wastelands, it was the only way to survive." }
	Personality.Tango.Convo_Stranger_Tango3 = { "It certainly won't hurt our chances here, either." }
	Personality.Stranger.Convo_Stranger_Tango4 = { "I hope so." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gargoyle_Terminus1" },
			{ main = "Convo_Gargoyle_Terminus2" },
			{ other = "Convo_Gargoyle_Terminus3" },
			{ main = "Convo_Gargoyle_Terminus4" },
			{ other = "Convo_Gargoyle_Terminus5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gargoyle"),
			other = PersonalityRule("Terminus")
		}
	})
	Personality.Terminus.Convo_Gargoyle_Terminus1 = { "Any reason you keep that suit on all the time, #main_full?" }
	Personality.Gargoyle.Convo_Gargoyle_Terminus2 = { "Why do you keep your eye covered, #other_second?" }
	Personality.Terminus.Convo_Gargoyle_Terminus3 = { "Because there's not much left." }
	Personality.Gargoyle.Convo_Gargoyle_Terminus4 = { "There's your answer." }
	Personality.Terminus.Convo_Gargoyle_Terminus5 = { "I can't tell if you're being literal or metaphorical." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Cypher_Vanish1" },
			{ main = "Convo_Cypher_Vanish2" },
			{ other = "Convo_Cypher_Vanish3" },
			{ main = "Convo_Cypher_Vanish4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Cypher"),
			other = PersonalityRule("Vanish")
		}
	})
	Personality.Vanish.Convo_Cypher_Vanish1 = { "How come those nanites of yours eat fire and ice, but not, say, wood?" }
	Personality.Cypher.Convo_Cypher_Vanish2 = { "They react to extreme environmental conditions and attempt to neutralize them." }
	Personality.Vanish.Convo_Cypher_Vanish3 = { "Can you program them to see the Vek as an extreme condition?" }
	Personality.Cypher.Convo_Cypher_Vanish4 = { "Possibly. But what happens if they decide humanity is also one?" }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Impact_Starlight1" },
			{ main = "Convo_Impact_Starlight2" },
			{ other = "Convo_Impact_Starlight3" },
			{ main = "Convo_Impact_Starlight4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Impact"),
			other = PersonalityRule("Starlight")
		}
	})
	Personality.Starlight.Convo_Impact_Starlight1 = { "Pilot #main_second. I believe I knew your father." }
	Personality.Impact.Convo_Impact_Starlight2 = { "He was a physicist. He mentioned your satellite projects occasionally." }
	Personality.Starlight.Convo_Impact_Starlight3 = { "He was working on a gravitic drive that would have replaced Archive's rockets." }
	Personality.Impact.Convo_Impact_Starlight4 = { "It never worked as such, but it did form the basis of my Grav Anchor." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Malichae_Baccarat1" },
			{ main = "Convo_Malichae_Baccarat2" },
			{ other = "Convo_Malichae_Baccarat3" },
			{ main = "Convo_Malichae_Baccarat4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Malichae"),
			other = PersonalityRule("Baccarat")
		}
	})
	Personality.Baccarat.Convo_Malichae_Baccarat1 = { "So what's a map-maker doing as a Mech pilot, #main_second?" }
	Personality.Malichae.Convo_Malichae_Baccarat2 = { "Combat is all about reading the terrain." }
	Personality.Baccarat.Convo_Malichae_Baccarat3 = { "Disagree with you there; it's about reading your opponent." }
	Personality.Malichae.Convo_Malichae_Baccarat4 = { "You're no stranger to R.S.T., #other_second; the terrain IS the opponent." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gyrosaur_Echelon1" },
			{ main = "Convo_Gyrosaur_Echelon2" },
			{ other = "Convo_Gyrosaur_Echelon3" },
			{ main = "Convo_Gyrosaur_Echelon4" },
			{ other = "Convo_Gyrosaur_Echelon5" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gyrosaur"),
			other = PersonalityRule("Echelon")
		}
	})
	Personality.Echelon.Convo_Gyrosaur_Echelon1 = { "For such an odd-looking duck, you're a pretty fast learner, #main_first." }
	Personality.Gyrosaur.Convo_Gyrosaur_Echelon2 = { "What's a duck?" }
	Personality.Echelon.Convo_Gyrosaur_Echelon3 = { "... A fast learner when it comes to Mechs, at least." }
	Personality.Gyrosaur.Convo_Gyrosaur_Echelon4 = { "Of the 87 classes of Mechs that Archive has schematics for, I don't think any of them were 'ducks'." }
	Personality.Echelon.Convo_Gyrosaur_Echelon5 = { "Just testing you. Let it go now." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Gray_AZ1" },
			{ main = "Convo_Gray_AZ2" },
			{ other = "Convo_Gray_AZ3" },
			{ main = "Convo_Gray_AZ4" },
			{ other = "Convo_Gray_AZ5" },
			{ main = "Convo_Gray_AZ6" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Gray"),
			other = PersonalityRule("AZ")
		}
	})
	Personality.AZ.Convo_Gray_AZ1 = { "Let me guess, #main_second; that suit isn't optional for you?" }
	Personality.Gray.Convo_Gray_AZ2 = { "Correct." }
	Personality.AZ.Convo_Gray_AZ3 = { "Take it off and you die?" }
	Personality.Gray.Convo_Gray_AZ4 = { "So I'm told." }
	Personality.AZ.Convo_Gray_AZ5 = { "We're not so different, then." }
	Personality.Gray.Convo_Gray_AZ6 = { "Except your life is ice, and mine is fire." }
------------------------------------
--[[
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Aloy_Knight1" },
			{ main = "Convo_Aloy_Knight2" },
			{ other = "Convo_Aloy_Knight3" },
			{ main = "Convo_Aloy_Knight4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Aloy"),
			other = PersonalityRule("Knight")
		}
	})
	Personality.Knight.Convo_Aloy_Knight1 = { "I notice there are things about this world that are as strange to you as they are to me, Lady #main_full." }
	Personality.Aloy.Convo_Aloy_Knight2 = { "As far as I can tell, I think this is... my world's past. Somehow I'm back in time." }
	Personality.Knight.Convo_Aloy_Knight3 = { "For me, this seems to be the future." }
	Personality.Aloy.Convo_Aloy_Knight4 = { "Guess those Time Pods go both ways." }
------------------------------------
	modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_Aloy_AZ1" },
			{ main = "Convo_Aloy_AZ2" },
			{ other = "Convo_Aloy_AZ3" },
			{ main = "Convo_Aloy_AZ4" }
		),
		CastRules = {
			main = SelectedPersonalityRule("Aloy"),
			other = PersonalityRule("AZ")
		}
	})
	Personality.AZ.Convo_Aloy_AZ1 = { "You really think you can learn these things' weaknesses by watching them up close, #main_first?" }
	Personality.Aloy.Convo_Aloy_AZ2 = { "I was raised as a hunter. Studying your prey is essential." }
	Personality.AZ.Convo_Aloy_AZ3 = { "You're not aiming to eat what's left, I hope?" }
	Personality.Aloy.Convo_Aloy_AZ4 = { "Wasn't planning on it." }
	--]]
------------------------------------
end

return{
	load = load,
}