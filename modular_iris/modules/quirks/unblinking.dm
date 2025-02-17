/datum/quirk/unblinking
	name = "Unblinking"
	desc = "For whatever reason, you do not need to blink to keep your eyes (or equivalent visual apparatus) functional."
	icon = FA_ICON_FACE_FLUSHED //closest thing I could find to a stare
	value = 0
	gain_text = span_notice("You no longer feel the need to blink.")
	lose_text = span_notice("You feel the need to blink again.")
	medical_record_text = "Patient does not need to blink."
	mob_trait = TRAIT_NO_EYELIDS //also prevents eye-shutting in knockout and death
