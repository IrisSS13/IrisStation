//"""soups"""

/datum/crafting_recipe/food/reaction/soup/beurre_noisette
	reaction = /datum/chemical_reaction/food/soup/beurre_noisette
	expected_container = /obj/item/reagent_containers/cup/bottle

//cakes

/datum/crafting_recipe/food/bienenstich_cake
	name = "Bienenstich Cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/whipped_cream = 20,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/honey = 10,
		/obj/item/food/grown/korta_nut/sweet = 2,
	)
	result = /obj/item/food/cake/bienenstich_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/madeira_cake
	name = "Madeira Cake"
	reqs = list(
		/obj/item/food/cake/pound_cake = 1,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/citrus/orange = 1
	)
	result = /obj/item/food/cake/madeira_cake
	category = CAT_CAKE

//pastries

/datum/crafting_recipe/food/eccles_cake
	name = "Eccles Cake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/butterslice = 1,
		/obj/item/food/no_raisin = 1,
		/datum/reagent/consumable/sugar = 5
	)
	result = /obj/item/food/eccles_cake
	category = CAT_PASTRY

/datum/crafting_recipe/food/custard_slice
	name = "Custard Slice"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/vanillapudding = 5
	)
	result = /obj/item/food/custard_slice
	category = CAT_PASTRY

/datum/crafting_recipe/food/financier
	name = "Financier"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/nutriment/soup/beurre_noisette = 5
	)
	result = /obj/item/food/financier
	category = CAT_PASTRY

/datum/crafting_recipe/food/punschkrapfen
	name = "Punschkrapfen"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/candy = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/datum/reagent/consumable/ethanol/rum = 5
	)
	result = /obj/item/food/punschkrapfen
	category = CAT_PASTRY

/datum/crafting_recipe/food/rock_cake
	name = "Rock Cake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1,
		/obj/item/food/no_raisin = 1
	)
	result = /obj/item/food/rock_cake
	category = CAT_PASTRY

/datum/crafting_recipe/food/rock_cake_jamaican
	name = "Jamaican Rock Cake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1,
		/obj/item/food/no_raisin = 1,
		//I somehow gaslit myself into believing coconuts were a growable thing in this game, their milk will have to serve as a substitute for the time being
		/datum/reagent/consumable/coconut_milk = 5
	)
	result = /obj/item/food/rock_cake/jamaican
	category = CAT_PASTRY
