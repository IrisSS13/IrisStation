/obj/item/storage/bag/xeno/debug
	name = "magic xenobiology science bag of learning how to ignore the rules and powergame"
	storage_type = /datum/storage/bag/xeno/debug

/obj/item/storage/bag/xeno/debug/PopulateContents()
	for(var/obj/item/slime_extract/extract as anything in subtypesof(/obj/item/slime_extract))
		for(var/i in 1 to 50)
			new extract(src)

/datum/storage/bag/xeno/debug
	max_slots = INFINITY
	max_specific_storage = INFINITY
	max_total_storage = INFINITY
