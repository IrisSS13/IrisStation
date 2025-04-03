/obj/item/stock_parts/capacitor/quantum
	name = "quantum Capacitor"
	desc = "A capacitor engineered with a mix of bluespace and quantum technologies."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_capacitor"
	rating = 5
	energy_rating = 20
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.1,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.9,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 0.7,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.5,
	)

/datum/stock_part/capacitor/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/capacitor/quantum

/obj/item/stock_parts/scanning_module/quantum
	name = "quantum field scanning module"
	desc = "A special scanning module using a mix of bluespace and quantum tech to scan even sub-atomic materials."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_scanning_module"
	rating = 5
	energy_rating = 20
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.1,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.9,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 0.3,
	)

/datum/stock_part/scanning_module/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/scanning_module/quantum

/obj/item/stock_parts/servo/quantum
	name = "quantum field servo"
	desc = "A strange, almost intangible servo that uses bluespace tech to manipulate and fold quantum states."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_servo"
	rating = 5
	energy_rating = 20
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.9,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.1,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 0.1,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 0.1,
	)

/datum/stock_part/servo/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/servo/quantum

/obj/item/stock_parts/micro_laser/quantum
	name = "quantum micro-laser"
	desc = "A modified quadultra micro-laser designed to make use of newly discovered quantum tech."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_micro_laser"
	rating = 5
	energy_rating = 20
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.9,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.9,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 0.5,
	)

/datum/stock_part/micro_laser/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/micro_laser/quantum

/obj/item/stock_parts/matter_bin/quantum
	name = "quantum entangled matter bin"
	desc = "A bluespace matter bin that makes use of entangled particles to store states of materials as energy."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_matter_bin"
	rating = 5
	energy_rating = 20
	custom_materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.1,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 0.5,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 0.7,
	)

/datum/stock_part/matter_bin/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/matter_bin/quantum

/obj/item/stock_parts/power_store/cell/quantum
	name = "quantum power cell"
	desc = "A rechargeable quantum entangled power cell."
	icon = 'modular_iris/modules/research/icons/quantum_parts.dmi'
	icon_state = "quantum_cell"
	maxcharge = STANDARD_CELL_CHARGE * 50
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 1.8,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)
	chargerate = STANDARD_CELL_RATE * 3

/obj/item/stock_parts/power_store/cell/quantum/empty
	empty = TRUE

/obj/item/storage/part_replacer/bluespace/tier5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/quantum(src)
		new /obj/item/stock_parts/scanning_module/quantum(src)
		new /obj/item/stock_parts/servo/quantum(src)
		new /obj/item/stock_parts/micro_laser/quantum(src)
		new /obj/item/stock_parts/matter_bin/quantum(src)
		new /obj/item/stock_parts/power_store/cell/quantum(src)
