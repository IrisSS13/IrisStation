/datum/round_event_control/antagonist/solo/changeling
	name = "Changelings"
	roundstart = TRUE

	antag_flag = ROLE_CHANGELING
	antag_datum = /datum/antagonist/changeling
	weight = 5
	min_players = 12
	maximum_antags_global = 2

	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/round_event_control/antagonist/solo/changeling/midround
	name = "Genome Awakening (Changelings)"
	roundstart = FALSE
