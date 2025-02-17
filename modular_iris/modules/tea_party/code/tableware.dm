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
	name = "teacup
	desc = "Never a bad time for a spot of tea, old chum."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teacup"
	fill_icon_thresholds = list(0)

//saucers
