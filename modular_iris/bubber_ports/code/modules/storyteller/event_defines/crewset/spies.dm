/datum/round_event_control/antagonist/solo/spy
	name = "Spies"
	roundstart = TRUE

	antag_flag = ROLE_SPY
	antag_datum = /datum/antagonist/spy
	weight = 5
	min_players = 5
	maximum_antags = 1

	tags = list(TAG_CREW_ANTAG)

/datum/round_event_control/antagonist/solo/spy/midround
	name = "Spies (Midround)"
	roundstart = FALSE
	maximum_antags = 1
	min_players = 8
