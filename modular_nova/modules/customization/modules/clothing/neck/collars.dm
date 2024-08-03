/datum/storage/pockets/small/collar
	max_slots = 1

/datum/storage/pockets/small/collar/New()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie))

/obj/item/clothing/neck/human_petcollar
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule."
	icon_state = "pet"
	greyscale_config = /datum/greyscale_config/collar/pet
	greyscale_config_worn = /datum/greyscale_config/collar/pet/worn
	greyscale_colors = "#44BBEE#FFCC00"
	flags_1 = IS_PLAYER_COLORABLE_1
	alternate_worn_layer = UNDER_SUIT_LAYER
	/// What's the name on the tag, if any?
	var/tagname = null
	/// What treat item spawns inside the collar?
	var/treat_path = /obj/item/food/cookie

/obj/item/clothing/neck/human_petcollar/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/small/collar)
	if(treat_path)
		new treat_path(src)

/obj/item/clothing/neck/human_petcollar/attack_self(mob/user)
	tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN)
	if(tagname)
		name = "[initial(name)] - [tagname]"

/obj/item/clothing/neck/human_petcollar/choker
	name = "spiked collar"
	desc = "Quite fashionable... if you're an edgy teen."
	icon_state = "choker"
	greyscale_config = /datum/greyscale_config/collar/spike
	greyscale_config_worn = /datum/greyscale_config/collar/spike/worn
	greyscale_colors = "#222222"

/obj/item/clothing/neck/human_petcollar/thinchoker
	name = "thin choker"
	desc = "Like the normal one, but thinner!"
	icon_state = "thinchoker"
	greyscale_config = /datum/greyscale_config/collar/thinchoker
	greyscale_config_worn = /datum/greyscale_config/collar/thinchoker/worn
	greyscale_colors = "#222222"

