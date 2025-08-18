/obj/machinery/vending/access/command/build_access_list(list/access_lists) // MONKESTATION EDIT ADDITION
	. = ..()

	access_lists["[ACCESS_CENT_GENERAL]"] += list(
		/obj/item/clothing/head/playbunnyears/centcom = 1,
		/obj/item/clothing/neck/tie/bunnytie/centcom = 1,
		/obj/item/clothing/suit/jacket/tailcoat/centcom = 1,
		/obj/item/clothing/under/costume/playbunny/centcom = 1,
	)

