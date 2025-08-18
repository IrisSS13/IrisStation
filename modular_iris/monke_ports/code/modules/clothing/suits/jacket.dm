//ALL BUNNY STUFF BY DimWhat OF MONKEESTATION

/obj/item/clothing/suit/jacket/tailcoat //parent type
	name = "tailcoat"
	desc = "A coat usually worn by bunny themed waiters and the like."
	worn_icon = 'modular_iris/monke_ports/icons/mob/clothing/suits/jacket.dmi'
	worn_icon_digi = 'modular_iris/monke_ports/icons/mob/clothing/suits/jacket_digi.dmi'
	icon = 'modular_iris/monke_ports/icons/obj/clothing/suits/jacket.dmi'
	icon_state = "tailcoat"
	post_init_icon_state = "tailcoat"
	greyscale_colors = "#39393f"
	greyscale_config = /datum/greyscale_config/tailcoat
	greyscale_config_worn = /datum/greyscale_config/tailcoat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/jacket/tailcoat/bartender
	name = "bartender's tailcoat"
	desc = "A coat usually worn by bunny themed bartenders. It has an interior holster for firearms and some extra padding for minor protection."
	icon_state = "tailcoat_bar"
	post_init_icon_state = "tailcoat_bar"
	greyscale_colors = "#39393f#ffffff"
	greyscale_config = /datum/greyscale_config/tailcoat_bar
	greyscale_config_worn = /datum/greyscale_config/tailcoat_bar/worn
	armor_type = /datum/armor/suit_armor


/obj/item/clothing/suit/jacket/tailcoat/bartender/Initialize(mapload) //so bartenders can use cram their shotgun inside
	. = ..()
	allowed += list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/gun/ballistic,
		/obj/item/gun/energy,
	)

/obj/item/clothing/suit/wizrobe/magician //Not really a robe but it's MAGIC
	name = "magician's tailcoat"
	desc = "A magnificent, gold-lined tailcoat that seems to radiate power."
	worn_icon = 'modular_iris/monke_ports/icons/mob/clothing/suits/jacket.dmi'
	worn_icon_digi = 'modular_iris/monke_ports/icons/mob/clothing/suits/jacket_digi.dmi'
	icon = 'modular_iris/monke_ports/icons/obj/clothing/suits/jacket.dmi'
	icon_state = "tailcoat_wiz"
	post_init_icon_state = "tailcoat_wiz"
	inhand_icon_state = null
	flags_inv = null

/obj/item/clothing/suit/jacket/tailcoat/centcom
	name = "Centcom tailcoat"
	desc = "An official coat usually worn by bunny themed executives. The inside is lined with comfortable yet tasteful bunny fluff."
	icon_state = "tailcoat_centcom"
	post_init_icon_state = "tailcoat_centcom"
	armor_type = /datum/armor/armor_centcom_formal_nt_consultant
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null


/obj/item/clothing/suit/jacket/tailcoat/british
	name = "british flag tailcoat"
	desc = "A tailcoat emblazoned with the Union Jack. Perfect attire for teatime."
	icon_state = "tailcoat_brit"
	post_init_icon_state = "tailcoat_brit"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null


/obj/item/clothing/suit/jacket/tailcoat/communist
	name = "really red tailcoat"
	desc = "A red tailcoat emblazoned with a golden star. The official uniform of the Bunny Waiter Union."
	icon_state = "tailcoat_communist"
	post_init_icon_state = "tailcoat_communist"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/suit/jacket/tailcoat/usa
	name = "stars tailcoat"
	desc = "A vintage coat worn by the 5th bunny battalion during the Revolutionary War. Smooth-bore musket not included."
	icon_state = "tailcoat_stars"
	post_init_icon_state = "tailcoat_stars"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

//BUNNY STUFF END, SPRITES BY DimWhat OF MONKE STATION
