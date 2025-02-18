//tea pots and cups

/obj/item/reagent_containers/cup/teapot
	name = "teapot"
	desc = "I'm a little teapot, short and stout."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teapot"
	fill_icon_thresholds = null
	volume = 120
	spillable = FALSE

/obj/item/reagent_containers/cup/teapot/assassins
	var/datum/reagents/reagents_store = null //we will be using this to store the reagents we do not want to transfer depending on the mode of interaction

/obj/item/reagent_containers/cup/teapot/assassins/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	//remove reagents not intended for consumption when we pour with left-click
	for(var/datum/reagent/reagent in reagents)
		if(istype(reagent, /datum/reagent/consumable))
			continue
		reagents_store += reagent
		reagents -= reagent
	. = ..()
	//add them back when the transfer of remaining reagents is complete
	reagents += reagents_store

/obj/item/reagent_containers/cup/teapot/assassins/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	//remove reagents intended for consumption when we pour with right-click
	for(var/datum/reagent/reagent in reagents)
		if(istype(reagent, /datum/reagent/consumable))
			reagents_store += reagent
			reagents -= reagent
	. = ..()
	//add them back when the transfer of remaining reagents is complete
	reagents += reagents_store

/obj/item/reagent_containers/cup/teacup
	name = "teacup"
	desc = "Never a bad time for a spot of tea, old chum."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teacup"
	fill_icon_thresholds = list(0)
	volume = 30 //we must leave room for milk and sugar, afterall

/obj/item/reagent_containers/cup/miniature_jug
	ame = "miniature jug"
	desc = "A tiny jug, typically used to store milk at the table."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teacup"
	fill_icon_thresholds = null
	volume = 15

//saucers

/obj/item/plate/small/saucer
	name = "saucer"
	desc = "A very small plate shaped for the support of a teacup, with room for a spoon or dainty sweet on the side."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "saucer"
	max_items = 3
	max_x_offset = 3
	max_height_offset = 4
