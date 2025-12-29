
return {
	CEO_Vertex = {
		Briefing = {
			"A strange crystal in this sector has been making it difficult for our forces to damage the Vek. Verify the crystal's not making the Vek immortal, then blow it up so they no longer benefit from it.",
			"This strange crystal seems to be healing nearby combatants. We need to understand whether the Vek can still be killed under these conditions, before destroying the crystal for good.",
		},
		Failure = {
			--"Didn't do either.",
			"We may have to abandon this sector, given how difficult it's become to kill the Vek under that crystal's influence.",
			"If the crystal makes it that difficult to kill the Vek, thank the Grid there's only been one specimen sighted so far.",
		},
		CrystalOnly = {
			--"Didn't kill a vek while crystal was alive, but killed crystal.",
			"I see the crystal was successfully destroyed, though I would have preferred additional data on Vek mortality while under its influence.",
			"I suppose with the crystal destroyed, the exact nature of its effect on Vek mortality matters less. But the information could still have been valuable, should another such crystal be found.",
		},
		KillOnly = {
			--"Didn't kill crystal, but killed a vek while it was alive.",
			"At least we know the Vek can still be killed. And I suppose Vertex forces also benefit from that crystal...",
			"Good to know that crystal doesn't keep the Vek alive forever. Since you failed to destroy it, maybe we can at least continue to study its properties... if the Vek don't prevent access.",
		},
		Success = {
			--"Did both.",
			"Excellent, commander. If we do ever run across another such crystal, we know the Vek can still be killed while under its influence.",
			"My researchers will attempt to study the shards of that crystal, but you did well by documenting its effects and then destroying it. Its regenerative aura would certainly favor the Vek in the long term, given their quantity.",
		},
	},
}