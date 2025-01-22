/datum/quirk/handedness
	name = "Dominant Hand"
	desc = "One of your hands is noticeably better coordinated than the other. You've found that attempting to use your weaker hand often results in unfortunate mishaps."
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	value = -4

/datum/quirk_constant_data/handedness
	associated_typepath = /datum/quirk/handedness
	customization_options = list(/datum/preference/choiced/handedness)

/datum/quirk/handedness/add(client/client_source)
	var/datum/quirk/handedness/side_choice = GLOB.side_choice_handedness[client_source?.prefs?.read_preference(/datum/preference/choiced/handedness)]
	if(isnull(side_choice))  // Client gone or they chose a random side
		side_choice = GLOB.side_choice_handedness[pick(GLOB.side_choice_handedness)]

	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_quirk(side_choice)

/datum/quirk/handedness/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.remove_quirk(/datum/quirk/handedness) //need to remove derivative quirk too

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
