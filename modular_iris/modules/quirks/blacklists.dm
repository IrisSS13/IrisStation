/datum/quirk/item_quirk/allergic/is_species_appropriate(datum/species/mob_species)
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/body_purist/is_species_appropriate(datum/species/mob_species)
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/item_quirk/food_allergic/is_species_appropriate(datum/species/mob_species)
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()
