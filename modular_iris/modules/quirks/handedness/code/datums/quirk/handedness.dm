/datum/quirk/handedness
	name = "Dominant Hand"
	desc = "One of your hands is noticeably better coordinated than the other. You've found that attempting to use your weaker hand often results in unfortunate mishaps."
	icon = FA_ICON_HANDSHAKE_SLASH
	value = -4
	gain_text = span_danger("You no longer feel able to accurately control your left hand.")
	lose_text = span_notice("You feel able to control your left hand again.")

/datum/quirk_constant_data/handedness
	associated_typepath = /datum/quirk/handedness
	customization_options = list(/datum/preference/choiced/handedness)

/datum/quirk/handedness/add(client/client_source)
	var/chosen_handedness = null

	if(client_source?.prefs)
		chosen_handedness = client_source.prefs.read_preference(/datum/preference/choiced/handedness)

	var/mob/living/carbon/human/human_holder = quirk_holder
	if(chosen_handedness == "Left Hand")
		gain_text = span_danger("You no longer feel able to accurately control your right hand.")
		lose_text = span_notice("You feel able to control your right hand again.")
		medical_record_text = "Patient demonstrates impaired adroitness when asked to use [human_holder.p_their()] right hand."
		ADD_TRAIT(human_holder, TRAIT_HANDEDNESS_LEFT, QUIRK_TRAIT)
	else
		medical_record_text = "Patient demonstrates impaired adroitness when asked to use [human_holder.p_their()] left hand."
		ADD_TRAIT(human_holder, TRAIT_HANDEDNESS, QUIRK_TRAIT)

/datum/quirk/handedness/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	//remove whichever of the traits they have
	if(HAS_TRAIT(human_holder, TRAIT_HANDEDNESS))
		REMOVE_TRAIT(human_holder, TRAIT_HANDEDNESS, QUIRK_TRAIT)
	else
		REMOVE_TRAIT(human_holder, TRAIT_HANDEDNESS_LEFT, QUIRK_TRAIT)

	human_holder.remove_quirk(/datum/quirk/handedness) //remove this quirk
