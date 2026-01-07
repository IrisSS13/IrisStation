///PODPEOPLE
/obj/item/bodypart/head/diona
	limb_id = SPECIES_DIONA
	is_dimorphic = TRUE
	burn_modifier = 1.25
	head_flags = HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)

/obj/item/bodypart/chest/diona
	limb_id = SPECIES_DIONA
	is_dimorphic = TRUE
	burn_modifier = 1.25
	wing_types = null

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)

/obj/item/bodypart/chest/diona/get_butt_sprite()
	return icon('icons/mob/butts.dmi', BUTT_SPRITE_FLOWERPOT)

/obj/item/bodypart/arm/left/diona
	limb_id = SPECIES_DIONA
	unarmed_attack_verbs = list("slash", "lash")
	unarmed_attack_verbs_continuous = list("slashes", "lashes")
	grappled_attack_verb = "lacerate"
	grappled_attack_verb_continuous = "lacerates"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'modular_iris/modules/diona/sounds/hit.ogg'
	unarmed_miss_sound = 'sound/items/weapons/punchmiss.ogg'
	burn_modifier = 1.25

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)

/obj/item/bodypart/arm/right/diona
	limb_id = SPECIES_DIONA
	unarmed_attack_verbs = list("slash", "lash")
	unarmed_attack_verbs_continuous = list("slashes", "lashes")
	grappled_attack_verb = "lacerate"
	grappled_attack_verb_continuous = "lacerates"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'modular_iris/modules/diona/sounds/hit.ogg'
	unarmed_miss_sound = 'sound/items/weapons/punchmiss.ogg'
	burn_modifier = 1.25

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)

/obj/item/bodypart/leg/left/diona
	limb_id = SPECIES_DIONA
	burn_modifier = 1.25

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)

/obj/item/bodypart/leg/right/diona
	limb_id = SPECIES_DIONA
	burn_modifier = 1.25

	bodytype = BODYTYPE_ORGANIC | BODYTYPE_PLANT
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/photosynthesis)
