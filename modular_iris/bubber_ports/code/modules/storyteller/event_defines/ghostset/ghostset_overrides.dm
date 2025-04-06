/datum/round_event_control/nightmare
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_SPOOKY)
	weight = 4

/datum/round_event_control/space_dragon
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_CHAOTIC)
	weight = 2

/datum/round_event_control/space_ninja
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT)
	weight = 4
	min_players = 8
	max_occurrences = 1

/datum/round_event_control/changeling
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)
	min_players = 10
	weight = 6

/datum/round_event_control/alien_infestation
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_SPOOKY, TAG_CHAOTIC)
	weight = 2
	min_players = 10

/datum/round_event_control/spider_infestation
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_CHAOTIC)
	weight = 0
