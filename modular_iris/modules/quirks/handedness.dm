/datum/quirk/handedness
	name = "Dominant Hand"
	desc = "One of your hands is noticeably better coordinated than the other. You've found that attempting to use your weaker hand often results in unfortunate mishaps."
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	value = -4


/datum/quirk/handedness/right
	name = "Dominant Hand (Right)"
	desc = "Your right hand is noticeably better coordinated than your left. You've found that attempting to use your left often results in unfortunate mishaps."
	mob_trait = TRAIT_HANDEDNESS
	gain_text = span_danger("You no longer feel able to fully control your left hand.")
	lose_text = span_notice("You feel able to control your left hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their left hand."

/datum/quirk/handedness/left
	name = "Dominant Hand (Left)"
	desc = "Your left hand is noticeably better coordinated than your right. You've found that attempting to use your right often results in unfortunate mishaps."
	mob_trait = TRAIT_HANDEDNESS_LEFT
	gain_text = span_danger("You no longer feel able to fully control your right hand.")
	lose_text = span_notice("You feel able to control your right hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their right hand."
