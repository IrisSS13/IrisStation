/obj/machinery/vending/access/command/build_access_list(list/access_lists) // MONKESTATION EDIT ADDITION
	. = ..()

	access_lists["[ACCESS_CENT_GENERAL]"] += list(
		/obj/item/clothing/suit/jacket/tailcoat/centcom = 1,
	)

/obj/machinery/vending/wardrobe/cent_wardrobe // MONKESTATION EDIT ADDITION
	products_iris = list(
		/obj/item/clothing/suit/jacket/tailcoat/centcom = 2,
	)
