/obj/item/clothing/neck/human_petcollar
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule."
	icon_state = "pet"
	greyscale_config = /datum/greyscale_config/collar/pet
	greyscale_config_worn = /datum/greyscale_config/collar/pet/worn
	greyscale_colors = "#44BBEE#FFCC00"
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	flags_1 = IS_PLAYER_COLORABLE_1
	alternate_worn_layer = UNDER_SUIT_LAYER

// incompatible storage by default stops attack chain, but this does not, allows pen renaming
/obj/item/clothing/neck/human_petcollar/storage_insert_on_interacted_with(datum/storage/storage, obj/item/inserted, mob/living/user)
	return is_type_in_typecache(inserted, storage.can_hold)

/* Fix these before making them usable pls lol, also don't add more again lmao

/obj/item/clothing/neck/human_petcollar/choker
	name = "spiked collar"
	desc = "Quite fashionable... if you're an edgy teen."
	icon_state = "spike"
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

*/
