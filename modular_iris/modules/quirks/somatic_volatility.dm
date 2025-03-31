/datum/quirk/somatic_volatility
	name = "Somatic Volatility"
	desc = "Your body is unstable and will self-destruct upon death."
	icon = FA_ICON_EXPLOSION
	value = -8
	gain_text = span_danger("You feel physiologically volatile.")
	lose_text = span_notice("You feel stable again, physiologically.")
	medical_record_text = "Examination of the patient suggests potential for somatic self-destruction on death."
	mob_trait = TRAIT_SOMATIC_VOLATILITY
