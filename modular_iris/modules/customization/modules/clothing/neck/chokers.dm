/obj/item/clothing/neck/choker
	name = "choker"
	desc = "It's not a phase, mom."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/choker"
	greyscale_colors = "#2d2d33"
	greyscale_config = /datum/greyscale_config/thin_choker
	greyscale_config_worn = /datum/greyscale_config/thin_choker/worn
	post_init_icon_state = "thin_choker"
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/choker/cross
	name = "cross choker"
	desc = "A choker with a cross adorned on it."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/choker/cross"
	post_init_icon_state = "cross_choker"
	greyscale_colors = "#2d2d33#dead39"
	greyscale_config = /datum/greyscale_config/thin_choker/cross
	greyscale_config_worn = /datum/greyscale_config/thin_choker/cross/worn

/obj/item/clothing/neck/choker/thick
	name = "thick choker"
	desc = /obj/item/clothing/neck/choker::desc
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/choker/thick"
	post_init_icon_state = "thick_choker"
	greyscale_config = /datum/greyscale_config/thick_choker
	greyscale_config_worn = /datum/greyscale_config/thick_choker/worn

/obj/item/clothing/neck/choker/thick/cross
	name = "thick cross choker"
	desc = /obj/item/clothing/neck/choker/cross::desc
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/choker/thick/cross"
	post_init_icon_state = "thick_cross_choker"
	greyscale_colors = /obj/item/clothing/neck/choker/cross::greyscale_colors
	greyscale_config = /datum/greyscale_config/thick_choker/cross
	greyscale_config_worn = /datum/greyscale_config/thick_choker/cross/worn

/obj/item/clothing/neck/spiked_choker
	name = "spiked choker"
	desc = "A cool choker to show off your edgy style."
	icon = 'icons/map_icons/clothing/neck.dmi'
	worn_icon = 'modular_iris/modules/GAGS/icons/chokers/spiked_choker_worn.dmi'
	icon_state = "/obj/item/clothing/neck/spiked_choker"
	post_init_icon_state = "spike_choker"
	greyscale_colors = "#2d2d33#ffffff"
	greyscale_config = /datum/greyscale_config/spike_choker
	greyscale_config_worn = /datum/greyscale_config/spike_choker/worn
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = IS_PLAYER_COLORABLE_1
