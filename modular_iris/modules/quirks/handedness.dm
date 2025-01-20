//quirk itself

/datum/quirk/handedness
	name = "Dominant Hand (Right)"
	desc = "Your right hand is noticeably better coordinated than your left. You've found that attempting to use your left will often result in unfortunate mishaps."
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	value = -4
	mob_trait = TRAIT_HANDEDNESS
	gain_text = span_danger("You no longer feel able to fully control your left hand.")
	lose_text = span_notice("You feel able to control your left hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their left hand."

/datum/quirk/handedness/left
	name = "Dominant Hand (Left)"
	desc = "Your left hand is noticeably better coordinated than your right. You've found that attempting to use your right will often result in unfortunate mishaps."
	mob_trait = TRAIT_HANDEDNESS_LEFT
	gain_text = span_danger("You no longer feel able to fully control your right hand.")
	lose_text = span_notice("You feel able to control your right hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their right hand."

//mutations

/datum/mutation/human/handedness
	name = "Right Hand Dominance"
	desc = "A genome that weakens motor control of the left hand."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("Your hand movement feels off.")

/datum/mutation/human/handedness/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_HANDEDNESS, GENETIC_MUTATION)

/datum/mutation/human/handedness/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_HANDEDNESS, GENETIC_MUTATION)

/datum/mutation/human/handedness/left
	name = "Left Hand Dominance"
	desc = "A genome that weakens motor control of the right hand."

/datum/mutation/human/handedness/left/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_HANDEDNESS_LEFT, GENETIC_MUTATION)

/datum/mutation/human/handedness/left/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_HANDEDNESS_LEFT, GENETIC_MUTATION)
