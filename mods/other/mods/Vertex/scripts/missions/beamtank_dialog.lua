
return {
	CEO_Vertex = {
		Briefing = {
			"We've been developing a promising laser weapon, using refined crystals. You'll need to further calibrate it in the field.",
			"This laser weapon could help turn the tide against the Vek, if we can finish calibrating it. Our scientists will be recording data remotely; you just need to fire it at suitable crystal deposits.",
		},
		Failure = {
			"I suppose such a weapon would have made things too easy, wouldn't it? As always, our faith must rest with the Grid.",
			"A pity, that neither the weapon nor the firing data made it back to us. They would have been most useful.",
		},
		DefendOnly = {
			--"Didn't break 2 mtns all, did save unit.",
			"The laser weapon remains uncalibrated. I suppose it still proved moderately effective, but its potential may never be realized.",
			"Your understandable enthusiasm for engaging the Vek has led you to neglect your orders, commander. Our weapon testing remains incomplete.",
		},
		MtnOnly = {
			--"Didn't save unit, did break 2 mtns.",
            "We managed to record the calibration data from your firing test, even if the unit itself was lost. We will make the most of it!",
			"Even though the tank did not survive, you gathered valuable calibration data. We may still be able to use it for future laser defenses.",
		},
		Success = {
			"You gathered valuable calibration data. We'll set to work incorporating it into the tank, to improve its effectiveness.",
			"Now that we can properly tune it, this crystal laser should help us capably defend ourselves, once you and your Mechs move on from Vertex.",
		},
	},
}