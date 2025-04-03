/datum/storyteller/default
	name = "Default Andy (Medium Chaos)"
	desc = "Default Andy is the default Storyteller, and the comparison point for every other Storyteller. \
	More frequent events than the Chill or the Fragile, but less frequent events than The Gamer or the Clown. Best for an average, varied experience."
	welcome_text = "If I chopped you up in a meat grinder..."
	antag_divisor = 8
	storyteller_type = STORYTELLER_TYPE_ALWAYS_AVAILABLE

	track_data = /datum/storyteller_data/tracks/default

/datum/storyteller_data/tracks/default
	threshold_mundane = 30
	threshold_moderate = 50
	threshold_major = 80
	threshold_crewset = 7000
	threshold_ghostset = 6000
