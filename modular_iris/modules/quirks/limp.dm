//Port from https://github.com/MrMelbert/MapleStationCode/pull/584, minus the changes to how crutches work
#define CANE_BASIC "Cane (Black)"
#define CANE_MEDICAL "Cane (Medical)"
#define CANE_WOODEN "Cane (Wooden)"
#define NO_CANE "None"

#define INTENSITY_LOW "Low (1/5th of a second)"
#define INTENSITY_MEDIUM "Medium (2/5ths of a second)"
#define INTENSITY_HIGH "High (3/5ths of a second)"

#define SIDE_LEFT "Left"
#define SIDE_RIGHT "Right"
#define SIDE_RANDOM "Random"


/datum/quirk/limp
	name = "Limp"
	desc = "You have a limp, making you slower and less agile."
	icon = FA_ICON_WALKING
	value = -4
	gain_text = span_danger("You feel a limp.")
	lose_text = span_notice("You feel less of a limp.")
	medical_record_text = "Patient has a limp in one of their legs."
	mail_goodies = list(
		/obj/item/cane,
		/obj/item/cane/crutch,
		/obj/item/cane/crutch/wood,
		/obj/item/reagent_containers/applicator/pill/morphine/diluted,
	)
/datum/quirk/limp/add_unique(client/client_source)
	var/cane = client_source?.prefs?.read_preference(/datum/preference/choiced/limp_cane) || NO_CANE
	var/side = client_source?.prefs?.read_preference(/datum/preference/choiced/limp_side) || SIDE_RANDOM
	if(side == SIDE_RANDOM)
		side = pick(SIDE_LEFT, SIDE_RIGHT)

	switch(cane)
		if(CANE_BASIC)
			give_cane(/obj/item/cane, side)
		if(CANE_MEDICAL)
			give_cane(/obj/item/cane/crutch, side)
		if(CANE_WOODEN)
			give_cane(/obj/item/cane/crutch/wood, side)

/datum/quirk/limp/add(client/client_source)
	var/intensity = client_source?.prefs?.read_preference(/datum/preference/choiced/limp_intensity) || INTENSITY_LOW
	var/side = client_source?.prefs?.read_preference(/datum/preference/choiced/limp_side) || SIDE_RANDOM
	if(side == SIDE_RANDOM)
		side = pick(SIDE_LEFT, SIDE_RIGHT)
	quirk_holder.apply_status_effect(/datum/status_effect/limp/permanent, side, intensity)

/datum/quirk/limp/proc/give_cane(cane_type, side)
	. = FALSE

	var/obj/item/given = new cane_type()
	if(side == SIDE_LEFT)
		. = quirk_holder.put_in_r_hand(given) // reversed (it makes sense just think about it)
	if(side == SIDE_RIGHT)
		. = quirk_holder.put_in_l_hand(given) // reversed (same)
	if(!.)
		. = quirk_holder.put_in_hands(given) // if it fails now, it will dump the ground. acceptable

	return .

/datum/quirk/limp/remove()
	quirk_holder.remove_status_effect(/datum/status_effect/limp/permanent)

/datum/status_effect/limp/permanent
	id = "perma_limp"
	alert_type = null

/datum/status_effect/limp/permanent/on_creation(mob/living/new_owner, side = pick(SIDE_LEFT, SIDE_RIGHT), intensity = INTENSITY_LOW)
	// setting to 150, because adrenaline halves limp chance
	switch(side)
		if(SIDE_LEFT)
			limp_chance_left = 150
		if(SIDE_RIGHT)
			limp_chance_right = 150

	// we can set both since it'll have a 0% chance for the unused side anyways
	switch(intensity)
		if(INTENSITY_LOW)
			slowdown_left = slowdown_right = 0.2 SECONDS
		if(INTENSITY_MEDIUM)
			slowdown_left = slowdown_right = 0.4 SECONDS
		if(INTENSITY_HIGH)
			slowdown_left = slowdown_right = 0.6 SECONDS

	return ..()

/datum/status_effect/limp/permanent/update_limp()
	left = owner.get_bodypart(BODY_ZONE_L_LEG)
	right = owner.get_bodypart(BODY_ZONE_R_LEG)
	next_leg = null


/datum/quirk_constant_data/limp
	associated_typepath = /datum/quirk/limp
	customization_options = list(
		/datum/preference/choiced/limp_cane,
		/datum/preference/choiced/limp_intensity,
		/datum/preference/choiced/limp_side,
	)

/datum/preference/choiced/limp_cane
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "limp_cane"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	should_generate_icons = TRUE

/datum/preference/choiced/limp_cane/create_default_value()
	return CANE_BASIC

/datum/preference/choiced/limp_cane/init_possible_values()
	return list(CANE_BASIC, CANE_MEDICAL, CANE_WOODEN, NO_CANE)

/datum/preference/choiced/limp_cane/icon_for(value)
	switch(value)
		if(CANE_BASIC)
			return uni_icon('icons/obj/weapons/staff.dmi', "cane")
		if(CANE_MEDICAL)
			return uni_icon('icons/obj/weapons/staff.dmi', "crutch_med")
		if(CANE_WOODEN)
			return uni_icon('icons/obj/weapons/staff.dmi', "crutch_wood")
		if(NO_CANE)
			return uni_icon('icons/hud/screen_gen.dmi', "x")

	return icon('icons/effects/random_spawners.dmi', "questionmark")

/datum/preference/choiced/limp_cane/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/limp::name in preferences.all_quirks

/datum/preference/choiced/limp_cane/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/limp_intensity
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "limp_intensity"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/limp_intensity/create_default_value()
	return INTENSITY_LOW

/datum/preference/choiced/limp_intensity/init_possible_values()
	return list(INTENSITY_LOW, INTENSITY_MEDIUM, INTENSITY_HIGH)

/datum/preference/choiced/limp_intensity/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/limp::name in preferences.all_quirks

/datum/preference/choiced/limp_intensity/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/limp_side
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "limp_side"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/limp_side/create_default_value()
	return SIDE_RANDOM

/datum/preference/choiced/limp_side/init_possible_values()
	return list(SIDE_LEFT, SIDE_RIGHT, SIDE_RANDOM)

/datum/preference/choiced/limp_side/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/limp::name in preferences.all_quirks

/datum/preference/choiced/limp_side/apply_to_human(mob/living/carbon/human/target, value)
	return

#undef CANE_BASIC
#undef CANE_MEDICAL
#undef CANE_WOODEN
#undef NO_CANE

#undef INTENSITY_LOW
#undef INTENSITY_MEDIUM
#undef INTENSITY_HIGH

#undef SIDE_LEFT
#undef SIDE_RIGHT
#undef SIDE_RANDOM
