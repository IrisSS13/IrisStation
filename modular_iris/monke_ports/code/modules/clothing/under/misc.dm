//ALL BUNNY STUFF BY DimWhat OF MONKESTATION

/obj/item/clothing/under/costume/playbunny
	name = "bunny suit"
	desc = "The staple of any bunny themed waiters and the like. It has a little cottonball tail too."
	icon = 'modular_iris/monke_ports/icons/obj/clothing/under/costume.dmi'
	worn_icon = 'modular_iris/monke_ports/icons/mob/clothing/under/costume.dmi'
	worn_icon_digi = 'modular_iris/monke_ports/icons/mob/clothing/under/costume_digi.dmi'
	icon_state = "playbunny"
	post_init_icon_state = "playbunny"
	greyscale_colors = "#39393f#39393f#ffffff#87502e"
	greyscale_config = /datum/greyscale_config/bunnysuit
	greyscale_config_worn = /datum/greyscale_config/bunnysuit/worn
	greyscale_config_worn_digi = /datum/greyscale_config/bunnysuit/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|GROIN|LEGS
	alt_covers_chest = TRUE

/obj/item/clothing/under/costume/playbunny/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/tiny)

/obj/item/clothing/under/costume/playbunny/magician
	name = "magician's bunny suit"
	desc = "The staple of any bunny themed stage magician."
	icon_state = "playbunny_wiz"
	post_init_icon_state = "playbunny_wiz"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/obj/item/clothing/under/costume/playbunny/magician/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/tiny/magician)

/datum/storage/pockets/tiny/magician/New() //this is probably a good idea
	. = ..()
	var/static/list/exception_cache = typecacheof(list(
		/obj/item/gun/magic/wand,
		/obj/item/warp_whistle,
	))
	exception_hold = exception_cache

/obj/item/clothing/under/costume/playbunny/centcom
	name = "centcom bunnysuit"
	desc = "A modified Centcom version of a bunny outfit, using Lunarian technology to condense countless amounts of rabbits into a material that is extremely comfortable and light to wear."
	icon_state = "playbunny_centcom"
	post_init_icon_state = "playbunny_centcom"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/obj/item/clothing/under/costume/playbunny/british
	name = "british bunny suit"
	desc = "The staple of any bunny themed monarchists. It has a little cottonball tail too."
	icon_state = "playbunny_brit"
	post_init_icon_state = "playbunny_brit"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/obj/item/clothing/under/costume/playbunny/communist
	name = "really red bunny suit"
	desc = "The staple of any bunny themed communists. It has a little cottonball tail too."
	icon_state = "playbunny_communist"
	post_init_icon_state = "playbunny_communist"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/obj/item/clothing/under/costume/playbunny/usa
	name = "striped bunny suit"
	desc = "A bunny outfit stitched together from several American flags. It has a little cottonball tail too."
	icon_state = "playbunny_usa"
	post_init_icon_state = "playbunny_usa"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

//BUNNY STUFF END, SPRITES BY DimWhat OF MONKE STATION
