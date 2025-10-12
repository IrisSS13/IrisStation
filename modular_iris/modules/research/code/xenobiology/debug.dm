/obj/item/storage/bag/xeno/debug
	name = "magic xenobiology science bag of learning how to ignore the rules and powergame"
	storage_type = /datum/storage/bag/xeno/debug

/obj/item/storage/bag/xeno/debug/PopulateContents()
	for(var/obj/item/slime_extract/extract as anything in (subtypesof(/obj/item/slime_extract) - /obj/item/slime_extract/unique))
		for(var/i in 1 to 50)
			new extract(src)

/datum/storage/bag/xeno/debug
	max_slots = INFINITY
	max_specific_storage = INFINITY
	max_total_storage = INFINITY

/datum/storage/bag/xeno/debug/dump_content_at(atom/dest_object, dump_loc, mob/user) // This is for your safety.
	to_chat(user, span_notice("This bag has dropping disabled."))
	return FALSE

/datum/storage/bag/xeno/debug/remove_all(atom/drop_loc = parent.drop_location(), update_storage = TRUE)
	return FALSE
