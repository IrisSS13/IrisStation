/datum/quirk/unusual_bodytemp
	name = "Unusual Body Temperature"
	desc = "Your body's temperature differs from that of a typical crew member. The selected amount is added to the species' standard temperature."
	value = 0
	gain_text = span_danger("Your body temperature is feeling off.")
	lose_text = span_notice("Your body temperature is feeling right.")
	//species_blacklist = list(SPECIES_SKRELL) //Skrell already have a insane +70 to their body temp
	medical_record_text = "Patient's body keeps itself at an unusual temperature."
	icon = FA_ICON_THERMOMETER_HALF
	var/difference = 0
	var/species_normal = 0
	var/species_heat = 0
	var/species_cold = 0

/datum/quirk_constant_data/unusual_bodytemp
	associated_typepath = /datum/quirk/unusual_bodytemp
	customization_options = list(/datum/preference/numeric/bodytemp_customization/difference,)


/datum/preference/numeric/bodytemp_customization
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = -40 //Plasmamen
	maximum = 70 //Skrell

/datum/preference/numeric/bodytemp_customization/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/numeric/bodytemp_customization/create_default_value()
	return 20

/datum/preference/numeric/bodytemp_customization/difference
	savefile_key = "unusual_bodytemp"

/datum/quirk/unusual_bodytemp/post_add()
	. = ..()

	var/mob/living/carbon/human/user = quirk_holder
	var/datum/preferences/prefs = user.client.prefs
	difference = prefs.read_preference(/datum/preference/numeric/bodytemp_customization/difference)
	species_normal = user.dna.species.bodytemp_normal
	species_heat = user.dna.species.bodytemp_heat_damage_limit //Storing the species's default body temps incase the quirk is removed.
	species_cold = user.dna.species.bodytemp_cold_damage_limit
	user.dna.species.bodytemp_normal += difference
	user.dna.species.bodytemp_heat_damage_limit += difference
	user.dna.species.bodytemp_cold_damage_limit += difference

/datum/quirk/unusual_bodytemp/remove()
	. = ..()

	if(QDELETED(quirk_holder))
		return
	var/mob/living/carbon/human/user = quirk_holder
	difference = 0
	user.dna.species.bodytemp_normal = species_normal
	user.dna.species.bodytemp_heat_damage_limit = species_heat
	user.dna.species.bodytemp_cold_damage_limit = species_cold
