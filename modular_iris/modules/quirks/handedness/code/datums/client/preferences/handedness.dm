/datum/preference/choiced/handedness
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "handedness"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/handedness/init_possible_values()
	return list("Random", "Right Hand", "Left Hand")

/datum/preference/choiced/handedness/create_default_value()
	return "Random"

/datum/preference/choiced/handedness/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return "Dominant Hand" in preferences.all_quirks

/datum/preference/choiced/handedness/apply_to_human(mob/living/carbon/human/target, value)
	return
