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

//cakes

/obj/item/food/cake/madeira_cake
	name = "\improper Madeira cake"
	desc = "A condensed cake with mixed in citrus rinds, often served with tea."
	icon_state = "madeira_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 40,
		/datum/reagent/consumable/nutriment/vitamin = 20,
	)
	tastes = list("cake" = 5, "citrus" = 2)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD
	slice_type = /obj/item/food/cakeslice/pound_cake_slice
	yield = 4
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cakeslice/madeira_cake_slice
	name = "\improper Madeira cake slice"
	desc = "A slice of condensed cake with mixed in citrus rinds, often served with tea."
	icon_state = "madeira_cake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("cake" = 5, "citrus" = 2)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD
	crafting_complexity = FOOD_COMPLEXITY_3

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
	name = "financier"
	desc = "A small, oblong, crisp-shelled cake, made with browned butter."
	icon = 'modular_iris/modules/tea_party/icons/food_items.dmi'
	icon_state = "financier"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("cake" = 3, "sugar" = 1, "butter" = 1)
	foodtypes = GRAIN | SUGAR | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/punschkrapfen
	name = "\improper Punschkrapfen"
	desc = "A little rum-soaked sponge cake filled with nougat and jelly."
	icon = 'modular_iris/modules/tea_party/icons/food_items.dmi'
	icon_state = "punschkrapfen"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	tastes = list("cake" = 2, "rum" = 1, "jelly" = 1, "chocolate" = 1, "nougat" = 1)
	foodtypes = GRAIN | SUGAR | DAIRY | JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4
