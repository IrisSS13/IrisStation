/datum/quirk/complexdna
	name = "Complex DNA"
	desc = "For some reason your dna is too complex for DNA scanners. You can not gain mutations."
	icon = FA_ICON_PERSON_DOTS_FROM_LINE
	value = 0
	mob_trait = TRAIT_GENELESS
	gain_text = span_notice("You are Becoming.")
	lose_text = span_notice("You no longer feel like an Aristocrat.")
	medical_record_text = "Patient's DNA is unusually complex and seems to be impervious to any changes."
