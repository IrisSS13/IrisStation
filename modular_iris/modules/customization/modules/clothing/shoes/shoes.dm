/obj/item/clothing/shoes/ballet_heels
	name = "ballet heels"
	desc = "Restrictive, knee-high heels. Unfathomably difficult to walk in."
	icon_state = "ballet_heels"
	icon = 'modular_iris/modules/GAGS/icons/shoes/high_heels.dmi'
	worn_icon = 'modular_iris/modules/GAGS/icons/shoes/high_heels_worn.dmi'
	greyscale_colors = "#383840"
	greyscale_config = /datum/greyscale_config/ballet_heel
	greyscale_config_worn = /datum/greyscale_config/ballet_heel/worn
	greyscale_config_worn = /datum/greyscale_config/ballet_heel/worn/digi
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
	icon_state = "dominaheels"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
