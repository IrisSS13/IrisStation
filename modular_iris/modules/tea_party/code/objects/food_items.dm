
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
