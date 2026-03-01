/datum/quirk/soulless
	name = "Soulless"
	desc = "You have sold or somehow lost your soul. This will affect some magical effects and chapel deity interactions. Death and revival might lead to unforeseen side effects."
	icon = FA_ICON_FILE_CONTRACT
	value = -3 // not sure if the bonus should be lower or higher. Having no soul might get you in some RP trobules but the mechanical effects are barely present
	mob_trait = TRAIT_NO_SOUL
	gain_text = span_notice("Your soul is missing from your body.")
	lose_text = span_danger("You have gained your soul back.")
	medical_record_text = "???"
	hidden = TRUE

//FA_ICON_EGG FA_ICON_PERSON_CIRCLE_MINUS

/datum/quirk/no_reflection
	name = "No mirror reflection"
	desc = "You do not reflect in mirrors."
	icon = FA_ICON_PERSON_CIRCLE_MINUS //change this if you find both an icon better fitting no_reflection quirk and a quirk better fitting FA_ICON_PERSON_CIRCLE_MINUS icon
	value = 0
	mob_trait = TRAIT_NO_MIRROR_REFLECTION
	gain_text = span_notice("You no longer reflect in mirrors.")
	lose_text = span_danger("You no longer no longer reflect in mirrors.")
	medical_record_text = "???"
	hidden = TRUE
