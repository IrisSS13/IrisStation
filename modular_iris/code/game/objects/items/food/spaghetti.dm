// This entire is ironically full of copypasta because the crafting system would otherwise break out pastas
/obj/item/food/spaghetti/pastatomato/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/food/triple,
		/datum/crafting_recipe/food/tower,
		/datum/crafting_recipe/food/spire,
		/datum/crafting_recipe/food/babel,
	)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/food/spaghetti/copypasta/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/food/triple)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/food/spaghetti/triple
	name = "triple pasta"
	desc = "Three times the charm, afterall 3 pastas are better than one."
	icon = 'modular_iris/icons/obj/food/spaghetti.dmi'
	icon_state = "triple"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 18,
		/datum/reagent/consumable/tomatojuice = 30,
		/datum/reagent/consumable/nutriment/vitamin = 12,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/triple/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/food/tower)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/food/spaghetti/tower
	name = "pasta tower"
	desc = "Before you stands a pasta tower, others may try to make towers out of pizza but this one is the proper one."
	icon = 'modular_iris/icons/obj/food/spaghetti.dmi'
	icon_state = "tower"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 24,
		/datum/reagent/consumable/tomatojuice = 40,
		/datum/reagent/consumable/nutriment/vitamin = 16,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/tower/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/food/spire)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/food/spaghetti/spire
	name = "inSPIREd pasta"
	desc = "Very carefully built pasta tower, mainly composed of tomato cards for perfect synergy with the pasta."
	icon = 'modular_iris/icons/obj/food/spaghetti.dmi'
	icon_state = "spire"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 30,
		/datum/reagent/consumable/tomatojuice = 50,
		/datum/reagent/consumable/nutriment/vitamin = 20,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/spire/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/food/babel)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/food/spaghetti/babel
	name = "babel pasta"
	desc = "A large tower of pasta whose comprehension is byond the imaginable extent, perhaps humanity was not meant to go this far."
	icon = 'modular_iris/icons/obj/food/spaghetti.dmi'
	icon_state = "babel"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 36,
		/datum/reagent/consumable/tomatojuice = 60,
		/datum/reagent/consumable/nutriment/vitamin = 24,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2
