// Akari Modsuit Skin Applier
/obj/item/mod/skin_applier/akari
	name = "nanite MODsuit refitter"
	desc = "A small kit full of nanites designed to refit a MODsuit to Akari's personal design. Only compatible with fused MODsuits due to the refit's reliance on a symbiote."
	icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	icon_state = "skinapplier"
	skin = "akari"
	universal = TRUE
// Akari Modsuit Theme
/datum/mod_theme/akari
	name = "akari"
	desc = "A sleek and agile MODsuit design, featuring a unique symbiotic interface that adapts to its wearer."
	default_skin = "akari"


	variants = list("akari" = list(
		MOD_ICON_OVERRIDE = 'modular_nova/master_files/icons/donator/obj/clothing/modsuit.dmi',
		MOD_WORN_ICON_OVERRIDE = 'modular_nova/master_files/icons/donator/mob/clothing/modsuit.dmi',
		/obj/item/clothing/head/mod = list(
			UNSEALED_LAYER = HEAD_LAYER,
			UNSEALED_CLOTHING = SNUG_FIT,
			UNSEALED_COVER = HEADCOVERSEYES|PEPPERPROOF,
			UNSEALED_INVISIBILITY = HIDEHAIR|HIDEEYES|HIDESNOUT,
			SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
			SEALED_INVISIBILITY =  HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
			SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
			UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
			SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
		),
		/obj/item/clothing/suit/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			SEALED_INVISIBILITY = HIDEJUMPSUIT|HIDETAIL,
			UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
			SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
		),
		/obj/item/clothing/gloves/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			CAN_OVERSLOT = TRUE,
			UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
			SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
		),
		/obj/item/clothing/shoes/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			CAN_OVERSLOT = TRUE,
			UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
			SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
		)
	))


// donation reward for Bonkai, the funny jumper
/obj/item/mod/skin_applier/jumper
	name = "\improper PA-4 MK-7 J.S supply crate"
	desc = "A crate made mostly of titanium with handles on the side to carry. It seems to be pressure sealed and the lid seems to be hydraulically assisted. The inside of the crate opens up and folds out to display an entire toolkit with all the essentials to convert most armor into a Mark 7 PA-7 Variant Jump suit. This crate seems to have the emblem relating to a certain Commando... Perhaps you should return it to the owner where you found it, if you can even lift it."
	icon = 'modular_nova/master_files/icons/donator/obj/custom.dmi'
	lefthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_left.dmi'
	righthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_right.dmi'
	icon_state = "jumper-box"
	skin = "jumper"
	universal = TRUE

// Jumper Modsuit Theme
/datum/mod_theme/jumper
	name = "jumper"
	desc = "A highly advanced Mark 7 PA-7 Variant Jump suit, featuring specialized armor plating and enhanced mobility systems."
	default_skin = "jumper"

	variants = list("jumper" = list(
		MOD_ICON_OVERRIDE = 'modular_nova/master_files/icons/donator/obj/clothing/modsuit.dmi',
		MOD_WORN_ICON_OVERRIDE = 'modular_nova/master_files/icons/donator/mob/clothing/modsuit.dmi',
		/obj/item/clothing/head/mod = list(
			UNSEALED_LAYER = HEAD_LAYER,
			UNSEALED_CLOTHING = SNUG_FIT,
			UNSEALED_COVER = HEADCOVERSEYES|PEPPERPROOF,
			UNSEALED_INVISIBILITY = HIDEHAIR|HIDEEYES|HIDESNOUT,
			SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
			SEALED_INVISIBILITY =  HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
			SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
			UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
			SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
		),
		/obj/item/clothing/suit/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			SEALED_INVISIBILITY = HIDEJUMPSUIT|HIDETAIL,
			UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
			SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
		),
		/obj/item/clothing/gloves/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			CAN_OVERSLOT = TRUE,
			UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
			SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
		),
		/obj/item/clothing/shoes/mod = list(
			UNSEALED_CLOTHING = THICKMATERIAL,
			SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
			CAN_OVERSLOT = TRUE,
			UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
			SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
		)
	))
