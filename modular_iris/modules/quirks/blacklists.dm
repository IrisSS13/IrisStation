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

/datum/quirk/hard_soles/is_species_appropriate(datum/species/mob_species) //SYNTHETICS have this
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/complexdna/is_species_appropriate(datum/species/mob_species) //synthetic got no DNA
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/genetic_mutation/is_species_appropriate(datum/species/mob_species) //synthetic got no DNA
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/no_appendix/is_species_appropriate(datum/species/mob_species) //synthetic got no appendix to begin with???
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/item_quirk/breather/water_breather/is_species_appropriate(datum/species/mob_species) //synthetics can already do this
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/quadruple_amputee/is_species_appropriate(datum/species/mob_species) //augments look so bad on nabbers
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_NO_AUGMENTS in species_traits)
		return FALSE
	return ..()

/datum/quirk/quadruple_amputee/is_species_appropriate(datum/species/mob_species) //augments look so bad on nabbers
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_NO_AUGMENTS in species_traits)
		return FALSE
	return ..()

/datum/quirk/prosthetic_limb/is_species_appropriate(datum/species/mob_species) //augments look so bad on nabbers
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_NO_AUGMENTS in species_traits)
		return FALSE
	return ..()

/datum/quirk/salt_vulnerability/is_species_appropriate(datum/species/mob_species) //synthetics can't process salt
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/item_quirk/anosmia/is_species_appropriate(datum/species/mob_species) //synthetics can't smell shit to begin with
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_SYNTHETIC in species_traits)
		return FALSE
	return ..()

/datum/quirk/bighands/is_species_appropriate(datum/species/mob_species) //for nabbers
	var/datum/species_traits = GLOB.species_prototypes[mob_species].inherent_traits
	if(TRAIT_CHUNKYFINGERS in species_traits)
		return FALSE
	return ..()
