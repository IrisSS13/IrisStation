//TODO: RACIAL BANEFITS/DRAWBACKS, fix names

//Instead of just slapping a pure damage reduction I'm giving them armor instead, difference is that it can be pierced by weapons and stuff
/datum/armor/polysmorph
	melee = 15
	bullet = 10
	wound = 25 //strong bones, not giving them full blunt immunity
	acid = 80 //their blood is literally acid

//Stronger legs, or something like that
/datum/movespeed_modifier/polysmorph
	movetypes = GROUND
	multiplicative_slowdown = -0.1 //10% faster

//ACTUAL SPECIES CODE HERE
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
		TRAIT_MINOR_NIGHT_VISION,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_ACIDBLOOD,
	)

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

	coldmod = 0.75
	heatmod = 1.5
	species_language_holder = /datum/language_holder/polysmorph
	exotic_bloodtype = BLOOD_TYPE_POLYSMORPH

	digitigrade_customization = DIGITIGRADE_OPTIONAL //'technically' optional, both types are digi
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/polysmorph,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/polysmorph,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/polysmorph,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/polysmorph,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/polysmorph,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/polysmorph,
	)



	mutantbrain = /obj/item/organ/brain/polysmorph
	mutanttongue = /obj/item/organ/tongue/polysmorph
	mutantliver = /obj/item/organ/liver/polysmorph
	mutantstomach = /obj/item/organ/stomach/polysmorph
	mutantlungs = /obj/item/organ/lungs/polysmorph
	mutantheart = /obj/item/organ/heart/polysmorph
	mutantappendix = null
	mutant_organs = list(
		/obj/item/organ/alien/plasmavessel/roundstart,
		/obj/item/organ/alien/resinspinner/roundstart,
		) //TODO ROUNDSTART HIVENODE WITHOUT HIVEMIND
/datum/species/polysmorph/get_species_description()
	return "https://web.archive.org/web/20250430125713/https://wiki.yogstation.net/wiki/Polysmorph, why yes I AM putting a link to waybackmachine, how can you tell? :chad:"

/datum/species/polysmorph/get_default_mutant_bodyparts()
	return list(
		"tail" = list("Polysmorph Tail", FALSE),
		"xenodorsal" = list("None", TRUE),
		"xenohead" = list("None", TRUE),
	)

/datum/species/polysmorph/on_species_gain(mob/living/carbon/human/polysmorph, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()
	polysmorph.physiology.armor = polysmorph.physiology.armor.add_other_armor(/datum/armor/polysmorph)
	polysmorph.add_movespeed_modifier(/datum/movespeed_modifier/polysmorph)

/datum/species/polysmorph/on_species_loss(mob/living/carbon/human/polysmorph, datum/species/new_species, pref_load)
	. = ..()
	polysmorph.physiology.armor = polysmorph.physiology.armor.subtract_other_armor(/datum/armor/polysmorph)
	polysmorph.remove_movespeed_modifier(/datum/movespeed_modifier/polysmorph)

/datum/species/polysmorph/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.dna.features["mcolor"] = "#444466"
	human_for_preview.dna.mutant_bodyparts["tail"] = list(MUTANT_INDEX_NAME = "Polysmorph Tail", MUTANT_INDEX_COLOR_LIST = list("#444466", "#FFFFFF", "#FFFFFF"))
	human_for_preview.dna.mutant_bodyparts["xenodorsal"] = list(MUTANT_INDEX_NAME = "Polysmorph Double", MUTANT_INDEX_COLOR_LIST = list("#444466", "#FFFFFF", "#FFFFFF"))
	human_for_preview.dna.mutant_bodyparts["xenohead"] = list(MUTANT_INDEX_NAME = "Polysmorph Queen", MUTANT_INDEX_COLOR_LIST = list("#444466", "#FFFFFF", "#FFFFFF"))
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)
