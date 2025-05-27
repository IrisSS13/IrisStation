/datum/design/diskplantgene
	name = "Plant Data Disk"
	desc = "A disk for storing plant genetic data."
	id = "diskplantgene"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron=200, /datum/material/glass = 100)
	build_path = /obj/item/disk/plantgene
	category = list("Electronics")
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/spraycan/roboticist
	name = "Roboticist Spraycan"
	desc = "Paint for restyling unattached robotic limbs. Sadly doesn't shine like chrome."
	id = "spraycan_roboticist"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/toy/crayon/spraycan/roboticist
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_TOOLS + RND_SUBCATEGORY_EQUIPMENT_SCIENCE)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
