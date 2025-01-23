/datum/quirk/handedness
	name = "Dominant Hand"
	desc = "One of your hands is noticeably better coordinated than the other. You've found that attempting to use your weaker hand often results in unfortunate mishaps."
	icon = FA_ICON_HANDSHAKE_SLASH
	value = -4
	gain_text = span_danger("You no longer feel able to accurately control your left hand.")
	lose_text = span_notice("You feel able to control your left hand again.")
	medical_record_text = "Patient demonstrates impaired adroitness when asked to use their left hand."

/datum/quirk_constant_data/handedness
	associated_typepath = /datum/quirk/handedness
	customization_options = list(/datum/preference/choiced/handedness)

/datum/quirk/handedness/add(client/client_source)
	var/side_choice = GLOB.side_choice_handedness[client_source?.prefs?.read_preference(/datum/preference/choiced/handedness)]
	if(isnull(side_choice))  // Client gone or they chose a random side
		side_choice = GLOB.side_choice_handedness[pick(GLOB.side_choice_handedness)]

	if(side_choice == TRAIT_HANDEDNESS_LEFT)
		gain_text = span_danger("You no longer feel able to accurately control your right hand.")
		lose_text = span_notice("You feel able to control your right hand again.")
		medical_record_text = "Patient demonstrates impaired adroitness when asked to use their right hand."

	var/mob/living/carbon/human/human_holder = quirk_holder
	ADD_TRAIT(human_holder, side_choice, QUIRK_TRAIT)

/datum/quirk/handedness/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	//remove whichever of the traits they have
	if(HAS_TRAIT(human_holder, TRAIT_HANDEDNESS))
		REMOVE_TRAIT(human_holder, TRAIT_HANDEDNESS, QUIRK_TRAIT)
	else
		REMOVE_TRAIT(human_holder, TRAIT_HANDEDNESS_LEFT, QUIRK_TRAIT)

	human_holder.remove_quirk(/datum/quirk/handedness) //remove this quirk
