/obj/item/clothing/shoes/ballet_heels
	name = "ballet heels"
	desc = "Restrictive, knee-high heels. Unfathomably difficult to walk in."
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/ballet_heels"
	post_init_icon_state = "ballet_heels"
	greyscale_colors = "#e8e8e8"
	greyscale_config = /datum/greyscale_config/ballet_heels
	greyscale_config_worn = /datum/greyscale_config/ballet_heels/worn
	greyscale_config_worn_digi  = /datum/greyscale_config/ballet_heels/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/shoes/ballet_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_iris/modules/customization/modules/sound/highheel1.ogg' = 1, 'modular_iris/modules/customization/modules/sound/highheel2.ogg' = 1), 70)

/obj/item/clothing/shoes/ballet_heels/boss_heels
	name = "boss heels"
	desc = "A pair of aesthetically pleasing heels. Slay girlboss."
	icon = 'modular_iris/modules/GAGS/icons/shoes/high_heels.dmi'
	worn_icon = 'modular_iris/modules/GAGS/icons/shoes/high_heels_worn.dmi'
	worn_icon_digi = 'modular_iris/modules/GAGS/icons/shoes/high_heels_digi.dmi'
	icon_state = "boss_heels"
	post_init_icon_state = null
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/shoes/sandal/kumi
	name = "shrine keeper's sandals"
	desc = "A fancy pair of sandals made of hinoki."
	icon = 'modular_iris/icons/obj/clothing/feet/feet.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/feet/feet.dmi'
	worn_icon_digi = 'modular_iris/icons/mob/clothing/feet/feet_digi.dmi'
	icon_state = "sandals_kumi"
