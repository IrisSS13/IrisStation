/mob/living/carbon/human/species/polysmorph
	race = /datum/species/polysmorph

/datum/species/polysmorph
	id = SPECIES_POLYSMORPH
	name = "Polysmorph"
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
	)

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

	digitigrade_customization = DIGITIGRADE_OPTIONAL
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/polysmorph,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/polysmorph,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/polysmorph,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/polysmorph,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/polysmorph,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/polysmorph,
	)

	mutantbrain = /obj/item/organ/brain/xeno_hybrid
	mutanttongue = /obj/item/organ/tongue/xeno_hybrid
	mutantliver = /obj/item/organ/liver/xeno_hybrid
	mutantstomach = /obj/item/organ/stomach/xeno_hybrid
	mutantappendix = null

/datum/species/polysmorph/get_species_description()
	return "No"

