//quirk itself

/datum/quirk/handedness
	name = "Right-Handedness"
	desc = "Your right hand is noticeably better coordinated than your left. You've found that attempting to use your left will often result in unfortunate accidents."
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	value = -4
	mob_trait = TRAIT_HANDEDNESS
	gain_text = span_danger("You no longer feel able to fully control your left hand.")
	lose_text = span_notice("You feel able to control your left hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their left hand."

/datum/quirk/handedness/left
	name = "Left-Handedness"
	desc = "Your left hand is noticeably better coordinated than your right. You've found that attempting to use your right will often result in unfortunate accidents."
	mob_trait = TRAIT_HANDEDNESS_LEFT
	gain_text = span_danger("You no longer feel able to fully control your right hand.")
	lose_text = span_notice("You feel able to control your right hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their right hand."

//mutations
