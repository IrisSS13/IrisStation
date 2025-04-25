// Port of https://github.com/MrMelbert/MapleStationCode/pull/632
// Uses the same values as the colorblind test debug. As always, they're not accurate and if you argue about that or argue like it is accurate i will SLAP YOU
/datum/quirk/colorblind
	name = "Colorblind"
	desc = "You are partially colorblind and are unable to percieve the full color spectrum."
	icon = FA_ICON_PALETTE
	value = 0
	gain_text = span_notice("You suddenly can't see as many colors anymore.")
	lose_text = span_danger("You can see the world in full color now! It's not that great...")
	medical_record_text = "Patient is afflicted with color blindness."
	var/colorblind_type = COLORBLINDNESS_DEUTERANOPIA //cached to prevent on-the-fly prefs switching causing issues

/datum/quirk/colorblind/add(client/client_source)
	colorblind_type = client_source?.prefs?.read_preference(/datum/preference/choiced/colorblindedness)
	switch(colorblind_type)
		if(COLORBLINDNESS_PROTANOPIA)
			quirk_holder.add_client_colour(/datum/client_colour/colorblind/protanopia)
		if(COLORBLINDNESS_DEUTERANOPIA)
			quirk_holder.add_client_colour(/datum/client_colour/colorblind/deuteranopia)
		if(COLORBLINDNESS_TRITANOPIA)
			quirk_holder.add_client_colour(/datum/client_colour/colorblind/tritanopia)

/datum/quirk/colorblind/remove()
	switch(colorblind_type)
		if(COLORBLINDNESS_PROTANOPIA)
			quirk_holder.remove_client_colour(/datum/client_colour/colorblind/protanopia)
		if(COLORBLINDNESS_DEUTERANOPIA)
			quirk_holder.remove_client_colour(/datum/client_colour/colorblind/deuteranopia)
		if(COLORBLINDNESS_TRITANOPIA)
			quirk_holder.remove_client_colour(/datum/client_colour/colorblind/tritanopia)

/datum/quirk_constant_data/colorblind
	associated_typepath = /datum/quirk/colorblind
	customization_options = list(/datum/preference/choiced/colorblindedness)

/datum/preference/choiced/colorblindedness
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "colorblindedness"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/colorblindedness/create_default_value()
	return COLORBLINDNESS_DEUTERANOPIA // most common type

/datum/preference/choiced/colorblindedness/init_possible_values()
	return list(COLORBLINDNESS_PROTANOPIA, COLORBLINDNESS_DEUTERANOPIA, COLORBLINDNESS_TRITANOPIA)

/datum/preference/choiced/colorblindedness/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/colorblind::name in preferences.all_quirks

/datum/preference/choiced/colorblindedness/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/client_colour/colorblind
	priority = 10 // PRIORITY_HIGH

/datum/client_colour/colorblind/protanopia
	color = list(0.56,0.43,0,0, 0.55,0.44,0,0, 0,0.24,0.75,0, 0,0,0,1, 0,0,0,0)

/datum/client_colour/colorblind/deuteranopia
	color = list(0.62,0.37,0,0, 0.70,0.30,0,0, 0,0.30,0.70,0, 0,0,0,1, 0,0,0,0)

/datum/client_colour/colorblind/tritanopia
	color = list(0.95,0.5,0,0, 0,0.43,0.56,0, 0,0.47,0.52,0, 0,0,0,1, 0,0,0,0)
