//"""soups"""

/datum/crafting_recipe/food/reaction/soup/beurre_noisette
	reaction = /datum/chemical_reaction/food/soup/beurre_noisette
	expected_container = /obj/item/reagent_containers/cup/beaker

//cakes

/datum/crafting_recipe/food/madeira_cake
	name = "\improper Madeira cake"
	reqs = list(
		/obj/item/food/cake/pound_cake = 1,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/citrus/orange = 1
	)

//pastries

/datum/crafting_recipe/food/custard_slice
	name = "custard slice"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/vanillapudding = 5
	)
	result = /obj/item/food/custard_slice
	category = CAT_PASTRY

/datum/crafting_recipe/food/financier
	name = "financier"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/nutriment/soup/beurre_noisette = 5
	)
	result = /obj/item/food/financier
	category = CAT_PASTRY

//desserts
