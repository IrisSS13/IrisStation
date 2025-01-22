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
