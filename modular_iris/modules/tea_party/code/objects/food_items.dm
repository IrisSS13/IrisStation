//"""soups"""

/datum/reagent/consumable/nutriment/soup/beurre_noisette
	name = "beurre noisette"
	description = "Liquid butter, melted in a saucepan and left to brown."
	data = list("melted butter" = 1)
	color = COLOR_BROWNER_BROWN

/datum/chemical_reaction/food/soup/beurre_noisette
	required_ingredients = list(
		/obj/item/food/butter = 1
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/beurre_noisette = 15
	)

//pastries

/obj/item/food/custard_slice
	name = "custard slice"
	desc = "Two layers of puff pastry sandwiching a goopy, vanilla custard filling."
	icon = 'modular_iris/modules/tea_party/icons/food_items.dmi'
	icon_state = "custard_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7)
	tastes = list("puff pastry" = 2, "vanilla custard" = 3)
	foodtypes = GRAIN | SUGAR | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/financier
	name = "financier
	desc = "Two layers of puff pastry sandwiching a goopy, vanilla custard filling."
	icon = 'modular_iris/modules/tea_party/icons/food_items.dmi'
	icon_state = "financier"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("cake" = 3, "sugar" = 1, "butter" = 1)
	foodtypes = GRAIN | SUGAR | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
