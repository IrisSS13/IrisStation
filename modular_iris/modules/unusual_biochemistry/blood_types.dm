/datum/blood_type/haemoglobin
	name = "Haemoglobin"
	color = "#a70000"
	desc = "For cowards who want the original red blood. This can be found in humans and a majority of other species. You are only compatible with other haemoglobin users and O- blood users."
	restoration_chem = /datum/reagent/iron
	compatible_types = list(
		/datum/blood_type/haemoglobin,
		/datum/blood_type/human/o_minus,
	)

/datum/blood_type/haemotoxin
	name = "Haemotoxin"
	color = "#614d7d"
	desc = "Want some zest? Your blood can be restored with toxins. Typically found in venomous animals, such as snakes and spiders. It's also a cute purple colour."
	restoration_chem = /datum/reagent/toxin
	compatible_types = list(
		/datum/blood_type/haemotoxin,
	)
