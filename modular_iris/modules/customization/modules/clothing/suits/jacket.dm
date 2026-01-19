/obj/item/clothing/suits/jacket/iris
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/suits/jacket.dmi'
	abstract_type = /obj/item/clothing/suit/jacket
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/toy,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/lighter,
		/obj/item/radio,
		)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/jacket/Initialize(mapload)
	. = ..()
	allowed += GLOB.personal_carry_allowed


/obj/item/clothing/suit/iris/jeogori
	name = "Hanbok Jeogori"
	desc = "A blazer jacket."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suits/jacket/iris/jeogori"
	post_init_icon_state = "hanbok_jeogori"
	greyscale_config = /datum/greyscale_config/hanbok_jeogori
	greyscale_config_worn = /datum/greyscale_config/hanbok_jeogori/worn
	greyscale_colors = "#4f4287#8d84b5#9989df"
	flags_1 = IS_PLAYER_COLORABLE_1
	blood_overlay_type = "coat"
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR
