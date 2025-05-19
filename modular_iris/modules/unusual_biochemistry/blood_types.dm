/datum/blood_type/haemoglobin
	name = "Haemoglobin"
	color = "#a70000"
	desc = "For cowards who want the original red blood. This can be found in humans and a majority of other species. You are only compatible with other haemoglobin users and O- blood users."
	restoration_chem = /datum/reagent/iron
	compatible_types = list(
		/datum/blood_type/haemoglobin,
		/datum/blood_type/human/o_minus,
	)
