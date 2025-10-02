/obj/item/clothing/under/rank/medical/iris
	icon = 'modular_iris/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/under/medical.dmi'
	worn_icon_digi = 'modular_iris/icons/mob/clothing/under/medical_digi.dmi'
	abstract_type = /obj/item/clothing/under/rank/medical
	armor_type = /datum/armor/clothing_under/rank_medical

/obj/item/clothing/under/rank/medical/iris/psychologist/turtleneck
	name = "psychologist's turtleneck"
	desc = "A light green turtleneck and tan khakis, for a chief medical officer with a superior sense of style."
	icon_state = "psychturtle"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/medical/iris/psychologist/turtleneck/skirt
	name = "psychologist's turtleneck skirt"
	desc = "A light green turtleneck and tan khaki skirt, for a chief medical officer with a superior sense of style."
	icon_state = "psychturtle_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/storage/bag/garment/psychologist
	name = "psychologist"
	desc = "A bag for storing extra clothes and shoes. This one belongs to a psychologist."

/obj/item/storage/bag/garment/psychologist/PopulateContents()
	new /obj/item/clothing/under/rank/medical/iris/psychologist/turtleneck(src)
	new /obj/item/clothing/under/rank/medical/iris/psychologist/turtleneck/skirt(src)
	new /obj/item/clothing/under/costume/buttondown/slacks/service(src)
	new /obj/item/clothing/under/costume/buttondown/skirt/service(src)
	new /obj/item/clothing/neck/tie/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/radio/headset/headset_srvmed(src)
