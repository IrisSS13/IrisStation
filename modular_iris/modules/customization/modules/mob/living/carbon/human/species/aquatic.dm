
/// How long the mob will stay wet for, AKA how long until they get a mood debuff
#define DRY_UP_TIME 10 MINUTES
/// How many wetstacks the mob will get upon creation
#define WETSTACK_INITIAL 5
/// How many wetstacks the mob needs to activate the TRAIT_SLIPPERY trait
#define WETSTACK_THRESHOLD 3
//IRIS ADDITION END

/datum/species/aquamorph
	name = "Aquatic Anthromorph"
	id = SPECIES_AQUAMORPH
	mutantbrain = /obj/item/organ/brain/carp/akula
	mutantheart = /obj/item/organ/heart/carp/akula
	mutantlungs = /obj/item/organ/lungs/carp/akula
	mutanttongue = /obj/item/organ/tongue/carp/akula
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_WATER_BREATHING,
		TRAIT_SLICK_SKIN,
		TRAIT_MUTANT_COLORS,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list()
	payday_modifier = 1.0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	examine_limb_id = SPECIES_AQUATIC
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/aquatic,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/aquatic,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/aquatic,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/aquatic,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/aquatic,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/aquatic,
	)
	/// This variable stores the timer datum which appears if the mob becomes wet
	var/dry_up_timer = TIMER_ID_NULL

/datum/species/aquamorph/get_default_mutant_bodyparts()
	return list(
		"tail" = list("Shark", TRUE),
		"snout" = list("Shark", TRUE),
		"horns" = list("None", FALSE),
		"ears" = list("Hammerhead", TRUE),
		"legs" = list("Normal Legs", FALSE),
		"wings" = list("None", FALSE),
	)

/datum/species/aquamorph/randomize_features(mob/living/carbon/human/human_mob)
	var/list/features = ..()
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of sharkish colors, with a whiter secondary and tertiary
	switch(random)
		if(1)
			main_color = "#668899"
			second_color = "#BBCCDD"
		if(2)
			main_color = "#334455"
			second_color = "#DDDDEE"
		if(3)
			main_color = "#445566"
			second_color = "#DDDDEE"
		if(4)
			main_color = "#666655"
			second_color = "#DDDDEE"
		if(5)
			main_color = "#444444"
			second_color = "#DDDDEE"
	features["mcolor"] = main_color
	features["mcolor2"] = second_color
	features["mcolor3"] = second_color
	return features

/datum/species/aquamorph/get_random_body_markings(list/passed_features)
	var/name = "Shark"
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings

// Spawn with a hydrovaporizer so you don't die
/datum/species/aquamorph/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	. = ..()
	if(job?.aquatic_outfit)
		equipping.equipOutfit(job.aquatic_outfit, visuals_only)

/datum/species/aquamorph/get_species_description()
	return placeholder_description

/datum/species/aquamorph/get_species_lore()
	return list(placeholder_lore)

// Wet_stacks handling
// more about grab_resists in `code\modules\mob\living\living.dm` at li 1119
// more about slide_distance in `code\game\turfs\open\_open.dm` at li 233
/// Lets register the signal which calls when we are above 10 wet_stacks
/datum/species/aquamorph/on_species_gain(mob/living/carbon/aquamorph, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(aquamorph, COMSIG_MOB_TRIGGER_WET_SKIN, PROC_REF(wetted), aquamorph)
	// lets give 15 wet_stacks on initial
	aquamorph.set_wet_stacks(WETSTACK_INITIAL, remove_fire_stacks = FALSE)

/// Remove the signal on species loss
/datum/species/aquamorph/on_species_loss(mob/living/carbon/aquamorph, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(aquamorph, COMSIG_MOB_TRIGGER_WET_SKIN)

/// This proc is called when a mob with TRAIT_SLICK_SKIN gains over 10 wet_stacks
/datum/species/aquamorph/proc/wetted(mob/living/carbon/aquamorph)
	SIGNAL_HANDLER
	// Apply the slippery trait if it's not there yet
	if(!HAS_TRAIT(aquamorph, TRAIT_SLIPPERY))
		ADD_TRAIT(aquamorph, TRAIT_SLIPPERY, SPECIES_TRAIT)

	// Relieve the negative moodlet
	aquamorph.clear_mood_event("dry_skin")
	// The timer which will initiate above 10 wet_stacks, and call dried() once the timer runs out
	dry_up_timer = addtimer(CALLBACK(src, PROC_REF(dried), aquamorph), DRY_UP_TIME, TIMER_UNIQUE | TIMER_STOPPABLE)

/// This proc is called after a mob with the TRAIT_SLIPPERY has its related timer run out
/datum/species/aquamorph/proc/dried(mob/living/carbon/aquamorph)
	// A moodlet which will not go away until the user gets wet
	aquamorph.add_mood_event("dry_skin", /datum/mood_event/dry_skin)

/// A simple overwrite which calls parent to listen to wet_stacks
/datum/status_effect/fire_handler/wet_stacks/tick(delta_time)
	. = ..()
	if(!owner)
		return
	if(HAS_TRAIT(owner, TRAIT_SLICK_SKIN) && stacks >= WETSTACK_THRESHOLD)
		SEND_SIGNAL(owner, COMSIG_MOB_TRIGGER_WET_SKIN)

	if(HAS_TRAIT(owner, TRAIT_SLIPPERY) && stacks <= 0.5) // Removed just before we hit 0 and delete the /status_effect/
		REMOVE_TRAIT(owner, TRAIT_SLIPPERY, SPECIES_TRAIT)

#undef DRY_UP_TIME
#undef WETSTACK_INITIAL
#undef WETSTACK_THRESHOLD

/datum/species/aquamorph/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_TOOTH,
		SPECIES_PERK_NAME = "Big Bites",
		SPECIES_PERK_DESC = "Instead of throwing punches, you use your sharp teeth to bite for more damage."
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_PERSON_WALKING,
		SPECIES_PERK_NAME = "Space Walking",
		SPECIES_PERK_DESC = "You can move around in zero-gravity environments, just like your ancestors."
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_HAND,
		SPECIES_PERK_NAME = "Slippery Skin",
		SPECIES_PERK_DESC = "When sufficiently wet, you have a bonus chance to escape from grabs."
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIRT,
		SPECIES_PERK_NAME = "Hydro-vaporizer",
		SPECIES_PERK_DESC = "You spawn with an accessory that will keep you perpetually wet if not removed."
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_LUNGS,
		SPECIES_PERK_NAME = "Gills",
		SPECIES_PERK_DESC = "If you are not wet, you will not be able to breathe oxygen!",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_ARROW_DOWN,
		SPECIES_PERK_NAME = "Nomadic DNA",
		SPECIES_PERK_DESC = "You never want to stay in one place."
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_PERSON_FALLING,
		SPECIES_PERK_NAME = "Slippery Soles",
		SPECIES_PERK_DESC = "When sufficiently wet, all slips will send you flying, even just a wet floor.",
	))
	return perks

/mob/living/carbon/human/species/aquamorph
	race = /datum/species/aquamorph

/datum/species/aquamorph/prepare_human_for_preview(mob/living/carbon/human/aquamorph)
	var/main_color = "#5ea9e3"
	var/secondary_color = "#ededed"
	aquamorph.dna.features["mcolor"] = main_color
	aquamorph.dna.features["mcolor2"] = secondary_color
	aquamorph.dna.mutant_bodyparts["snout"] = list(MUTANT_INDEX_NAME = "Shark", MUTANT_INDEX_COLOR_LIST = list(main_color, secondary_color))
	aquamorph.dna.mutant_bodyparts["tail"] = list(MUTANT_INDEX_NAME = "Shark", MUTANT_INDEX_COLOR_LIST = list(main_color, secondary_color))
	aquamorph.dna.mutant_bodyparts["ears"] = list(MUTANT_INDEX_NAME = "Hammerhead", MUTANT_INDEX_COLOR_LIST = list(main_color, secondary_color))
	regenerate_organs(aquamorph, src, visual_only = TRUE)
	aquamorph.update_body(is_creating = TRUE)
