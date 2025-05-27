/obj/item/clothing/under/dress/iris
	icon = 'modular_iris/icons/obj/clothing/under/dress.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/under/dress.dmi'

/obj/item/clothing/under/dress/iris/princess
	name = "princess dress"
	desc = "A luxurious dress, it makes you feel like you can sing to the animals and they would answer your call."
	icon_state = "princess_dress"
	greyscale_config = /datum/greyscale_config/princess_dress
	greyscale_config_worn = /datum/greyscale_config/princess_dress/worn
	post_init_icon_state = null
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#FFFFFF"
	can_adjust = FALSE
	alternate_worn_layer = UNDER_SUIT_LAYER
