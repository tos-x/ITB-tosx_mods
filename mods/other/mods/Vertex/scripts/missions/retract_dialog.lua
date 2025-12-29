
return {
	CEO_Vertex = {
		Briefing = {
			"Vertex relies on these energy transmission towers to feed power to remote corners of the Grid. They can be retracted underground for safety, but controls are manual. You'll need to get close to them with your Mechs.",
			"These transmission antennas are a vital component of the Grid and must be preserved. Use your Mechs to manually activate their safety routines, and then defend them while they retract underground.",
		},
		Failure = {
			--"Didn't retract both.",
			"Without both transmission towers, Grid throughput will be severely limited across the island.",
			"You serve the Grid, commander, as without it your Mechs are just dead metal. And the Grid will suffer without both of those antennas!",
		},
		Success = {
			--"Retracted both.",
			"You have served the Grid well. Now that the region is clear, both antennas can be extended and resume operation!",
			"All systems are still green on both transmitters, commander. Excellent work, safeguarding such vital installations!",
		},
	},
}