/obj/item/stack/impure_telecrystal
	name = "impure telecrystals"
	desc = "A crystal humming with energy, the dim, ruby light pulsing within is partly obscured by a matrix of impurities."
	singular_name = "impure telecrystal"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "telecrystal"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 50
	item_flags = NOBLUDGEON
	merge_type = /obj/item/stack/impure_telecrystal
	novariants = FALSE

/datum/supply_pack/misc/impure_telecrystal
	name = "Impure Telecrystal"
	desc = "Fuel for mobile dive anchors."
	cost = CARGO_CRATE_VALUE * 25
	contains = list(/obj/item/stack/impure_telecrystal)
	crate_name = "dive anchor fuel crate"
