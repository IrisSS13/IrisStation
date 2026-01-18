/obj/item/clothing/under/dress/iris
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/under/dress.dmi'

/obj/item/clothing/under/dress/iris/princess
	name = "princess dress"
	desc = "A luxurious dress, it makes you feel like you can sing to the animals and they would answer your call."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/iris/princess"
	greyscale_config = /datum/greyscale_config/princess_dress
	greyscale_config_worn = /datum/greyscale_config/princess_dress/worn
	post_init_icon_state = "princess_dress"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#FFFFFF"
	can_adjust = FALSE
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/clothing/under/dress/iris/magic
	name = "magical dress"
	desc = "A magical dress, contrary to the name its not actually magic - It simply makes you feel magical with its beguiling style."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/iris/magic"
	post_init_icon_state = "magical_dress"
	can_adjust = FALSE
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/clothing/under/dress/iris/chima
	name = "hanbok chima"
	desc = "An elegant skirt, usually pulled high on the torso. It pairs well with the hanbok."
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/iris/chima"
	greyscale_config = /datum/greyscale_config/hanbok_chima
	greyscale_config_worn = /datum/greyscale_config/hanbok_chima/worn
	post_init_icon_state = "hanbok_chima"
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#4F4287#756C9B#F5FC9C"
	can_adjust = FALSE
	alternate_worn_layer = UNDER_SUIT_LAYER
