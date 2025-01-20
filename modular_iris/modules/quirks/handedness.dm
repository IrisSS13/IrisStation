//quirk itself

/datum/quirk/handedness
	name = "Right-Handedness"
	desc = "You're clumsy, a goofball, a silly dude. You big loveable dope you! Hope you weren't planning on using your hands for anything that takes even a LICK of dexterity."
	icon = FA_ICON_FACE_DIZZY
	value = -4
	mob_trait = TRAIT_HANDEDNESS
	gain_text = span_danger("You feel your IQ sink like your brain is liquid.")
	lose_text = span_notice("You feel like your IQ went up to at least average.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use a specific hand."

/datum/quirk/handedness/left
	name = "Left-Handedness"
	mob_trait = TRAIT_HANDEDNESS_LEFT

//mutations
