/datum/species/akula
	smoker_lungs = /obj/item/organ/lungs/carp/akula/akula_smoker

// DISGUSTING DEFINES
#define SMOKER_ORGAN_HEALTH (STANDARD_ORGAN_THRESHOLD * 0.75)
#define SMOKER_LUNG_HEALING (STANDARD_ORGAN_HEALING * 0.75)

/obj/item/organ/lungs/carp/akula/akula_smoker
	name = "smoker azulean lungs"
	desc = "Carp DNA infused into what was once some normal lungs, now discolored and tarred from heavy smoking."
	// no custom icon state because haha im lazy
	maxHealth = SMOKER_ORGAN_HEALTH
	healing_factor = SMOKER_LUNG_HEALING

#undef SMOKER_ORGAN_HEALTH
#undef SMOKER_LUNG_HEALING
