/datum/techweb_node/parts_quantum
	id = TECHWEB_NODE_PARTS_QUANTUM
	display_name = "Quantum Technology"
	description = "Quantum stock parts are to Bluespace Technology what a spear is to a rock, something that has been properly and efficiently utilized."
	prereq_ids = list(TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"quantum_scanning_module",
		"quantum_servo",
		"quantum_matter_bin",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_QUANTUM_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/parts_power_quantum
	id = TECHWEB_NODE_PARTS_POWER_QUANTUM
	display_name = "Quantum Power Technology"
	description = "Full utilization of power storage and dispersal using Bluespace Technology."
	prereq_ids = list(TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"quantum_capacitor",
		"quantum_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_QUANTUM_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/parts_laser_quantum
	id = TECHWEB_NODE_PARTS_LASER_QUANTUM
	display_name = "Integrated Quantum Laser Theory"
	description = "Theoretics made manifest in the venture of utilizing planck-length Quantum Scanner's in order to make incredibly precise and controlled precisions."
	prereq_ids = list(TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"quantum_micro_laser",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_QUANTUM_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/botanygene
	id = TECHWEB_NODE_BOTANY_ADV
	display_name = "Experimental Botanical Engineering"
	description = "Further advancement in plant cultivation techniques and machinery, enabling careful manipulation of plant DNA."
	prereq_ids = list(TECHWEB_NODE_PARTS_ADV, TECHWEB_NODE_SELECTION)
	design_ids = list(
		"diskplantgene",
		"plantgene",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

/datum/techweb_node/declassified_modules
	id = TECHWEB_NODE_MOD_DECLASSIFIED
	display_name = "Declassified Modular Suit"
	description = "Modular Technology that was either reversed engineered or previously restricted to Nanotrasen's Higher-ups but later approved for normal research."
	prereq_ids = list(TECHWEB_NODE_MOD_ANOMALY)
	design_ids = list(
		"mod_storage_bluespace",
		"mod_shield_nt",
		"mod_medbeam_nt",
		)
	required_items_to_unlock = list(/obj/item/mod/module/energy_shield/nanotrasen)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
	hidden = TRUE
