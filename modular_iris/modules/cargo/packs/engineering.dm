/datum/supply_pack/engineering/teg
	name = "Thermo-Electric Generator Parts"
	desc = "Ancient thing we dug up from our old stocks. Please don't blow the station up with it."
	cost = CARGO_CRATE_VALUE * 30
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/item/circuitboard/machine/circulator = 2,
					/obj/item/circuitboard/machine/thermoelectric_generator,
				)
	crate_name= "thermo-electric generator parts crate"
