/datum/round_event_control/antagonist/solo/spy
	name = "Spies"
	roundstart = TRUE

	antag_flag = ROLE_SPY
	antag_datum = /datum/antagonist/spy
	weight = 8
	min_players = 7
	max_occurrences = 1

	tags = list(TAG_CREW_ANTAG)

/datum/round_event_control/antagonist/solo/spy/midround
	name = "Spies (Midround)"
	roundstart = FALSE
	max_occurrences = 1
