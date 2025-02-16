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
