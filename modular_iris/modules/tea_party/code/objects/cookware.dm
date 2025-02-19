/obj/item/reagent_containers/cup/soup_pot/kettle
	name = "kettle"
	desc = "An old-fashioned kettle for heating liquids atop a stove."
	icon = 'modular_iris/modules/tea_party/icons/cookware.dmi'
	icon_state = "kettle"
	volume = 240 //enough to fill a teapot twice
	possible_transfer_amounts = list(10, 20, 40, 60, 120, 240)
	amount_per_transfer_from_this = 60

/obj/item/reagent_containers/cup/soup_pot/kettle/update_overlays() //override parent behaviour with nothing here because we don't have a kettle overlay, change this if one gets added
	return FALSE
