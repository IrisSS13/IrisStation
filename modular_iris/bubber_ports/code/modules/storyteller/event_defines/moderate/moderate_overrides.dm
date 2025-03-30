/datum/round_event_control/brand_intelligence
	tags = list(TAG_DESTRUCTIVE, TAG_COMMUNAL, TAG_CHAOTIC)
	min_players = 10

/datum/round_event_control/carp_migration
	tags = list(TAG_COMMUNAL)

/datum/round_event_control/communications_blackout
	tags = list(TAG_COMMUNAL, TAG_SPOOKY)

/datum/round_event_control/ion_storm
	tags = list(TAG_TARGETED)

/datum/round_event_control/processor_overload
	tags = list(TAG_COMMUNAL)
	min_players = 5

/datum/round_event_control/supermatter_surge
	tags = list(TAG_TARGETED)

/datum/round_event_control/stray_meteor
	tags = list(TAG_DESTRUCTIVE, TAG_SPACE)
	weight = 10
	min_players = 7

/datum/round_event_control/shuttle_catastrophe
	tags = list(TAG_COMMUNAL)

/datum/round_event_control/vent_clog
	tags = list(TAG_COMMUNAL)

/datum/round_event_control/anomaly
	weight = 10 // Lower from original 15 because it KEEPS SPAWNING THEM
	tags = list(TAG_COMMUNAL, TAG_DESTRUCTIVE)

/datum/round_event_control/spacevine
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_CHAOTIC)

/datum/round_event_control/portal_storm_syndicate
	tags = list(TAG_COMBAT, TAG_CHAOTIC)

/datum/round_event_control/portal_storm_narsie
	tags = list(TAG_COMBAT, TAG_CHAOTIC)

/datum/round_event_control/mold
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_CHAOTIC)
	weight = 5
	min_players = 10

/datum/round_event_control/obsessed
	tags = list(TAG_TARGETED)
	min_players = 7

/datum/round_event_control/operative
	track = EVENT_TRACK_MODERATE
	max_occurrences = 0

/datum/round_event_control/anomaly/anomaly_ectoplasm
	min_players = 10
