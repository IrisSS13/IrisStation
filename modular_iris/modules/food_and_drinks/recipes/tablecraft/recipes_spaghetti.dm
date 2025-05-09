/datum/crafting_recipe/food/triple
	name = "Triple pasta"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 1,
		/obj/item/food/spaghetti/copypasta = 1
	)
	result = /obj/item/food/spaghetti/triple
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/tower
	name = "Pasta tower"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 1,
		/obj/item/food/spaghetti/triple = 1
	)
	result = /obj/item/food/spaghetti/tower
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/spire
	name = "InSPIREd pasta"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 1,
		/obj/item/food/spaghetti/tower = 1
	)
	result = /obj/item/food/spaghetti/spire
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/babel
	name = "Babel pasta"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 1,
		/obj/item/food/spaghetti/spire = 1
	)
	result = /obj/item/food/spaghetti/babel
	category = CAT_SPAGHETTI
