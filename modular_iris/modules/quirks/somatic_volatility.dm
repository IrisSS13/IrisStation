/datum/quirk/somatic_volatility
	name = "Somatic Volatility"
	desc = "Your body is unstable and will self-destruct upon death. (Note: You will not be able to be revived by normal means.)"
	icon = FA_ICON_EXPLOSION
	value = 0
	gain_text = span_danger("You feel physiologically volatile.")
	lose_text = span_notice("You feel stable again, physiologically.")
	medical_record_text = "Examination of the patient suggests potential for somatic self-destruction on death."
	mob_trait = TRAIT_SOMATIC_VOLATILITY

/datum/quirk_constant_data/somatic_volatility
	associated_typepath = /datum/quirk/somatic_volatility
	customization_options = list(/datum/preference/choiced/somatic_volatility_gib_choice)

/datum/preference/choiced/somatic_volatility_gib_choice
	savefile_key = "somatic_volatility_gib_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED

/datum/preference/choiced/somatic_volatility_gib_choice/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return "Somatic Volatility" in preferences.all_quirks

/datum/preference/choiced/somatic_volatility_gib_choice/init_possible_values()
	var/list/values = list("Default", "Inflation", "Dust (to remains)", "Dust (to ashes)")
	return values

/datum/preference/choiced/somatic_volatility_gib_choice/apply_to_human(mob/living/carbon/human/target, value)
	return
