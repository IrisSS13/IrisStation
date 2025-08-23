/obj/item/bodypart/head/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_head"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = BIO_BONE
	limb_id = SPECIES_PLASMAMAN
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! IRIS EDIT - changes 1.5 to 1.15
	head_flags = HEAD_EYESPRITES|HEAD_EYECOLOR //IRIS EDIT - lets plasmamen set their eye color instead of it being blindingly white
	bodypart_flags = BODYPART_UNHUSKABLE
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)

/obj/item/bodypart/chest/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_chest"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = BIO_BONE
	limb_id = SPECIES_PLASMAMAN
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! changes 1.5 to 1.15
	bodypart_flags = BODYPART_UNHUSKABLE
	wing_types = null
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)

/obj/item/bodypart/chest/plasmaman/get_butt_sprite()
	return icon('icons/mob/butts.dmi', BUTT_SPRITE_PLASMA)

/obj/item/bodypart/arm/left/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_l_arm"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = (BIO_BONE|BIO_JOINTED)
	limb_id = SPECIES_PLASMAMAN
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! changes 1.5 to 1.15
	bodypart_flags = BODYPART_UNHUSKABLE
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)

/obj/item/bodypart/arm/right/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_r_arm"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = (BIO_BONE|BIO_JOINTED)
	limb_id = SPECIES_PLASMAMAN
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! changes 1.5 to 1.15
	bodypart_flags = BODYPART_UNHUSKABLE
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)

/obj/item/bodypart/leg/left/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_l_leg"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = (BIO_BONE|BIO_JOINTED)
	limb_id = SPECIES_PLASMAMAN
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! changes 1.5 to 1.15
	bodypart_flags = BODYPART_UNHUSKABLE
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)

/obj/item/bodypart/leg/right/plasmaman
	icon = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	icon_state = "plasmaman_r_leg"
	icon_static = 'icons/mob/human/species/plasmaman/bodyparts.dmi'
	biological_state = (BIO_BONE|BIO_JOINTED)
	limb_id = SPECIES_PLASMAMAN
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	brute_modifier = 1 //Plasmemes are BONE!!! IRIS EDIT - changes 1.5 to 1
	burn_modifier = 1.15 //Plasmemes are FLAMMABLE!!! changes 1.5 to 1.15
	bodypart_flags = BODYPART_UNHUSKABLE
	bodypart_effects = list(/datum/status_effect/grouped/bodypart_effect/plasma_based)
