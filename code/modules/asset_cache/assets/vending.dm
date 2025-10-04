/datum/asset/spritesheet_batched/vending
	name = "vending"

/datum/asset/spritesheet_batched/vending/create_spritesheets()
	// initialising the list of items we need
	var/target_items = list()
	for(var/obj/machinery/vending/vendor as anything in subtypesof(/obj/machinery/vending))
		vendor = new vendor() // It seems `initial(list var)` has nothing. need to make a type.
		target_items |= vendor.products
		target_items |= vendor.premium
		target_items |= vendor.contraband
		qdel(vendor)

	// building icons for each item
	for (var/atom/item as anything in target_items)
		if (!ispath(item, /atom))
			continue

		var/icon_state = initial(item.icon_state)
		if(ispath(item, /obj))
			var/obj/obj_atom = item
			if(initial(obj_atom.icon_state_preview))
				icon_state = initial(obj_atom.icon_state_preview)
		// IRIS EDIT - Always generate icons for all items, regardless of GAGS or color
		if (PERFORM_ALL_TESTS(focus_only/invalid_vending_machine_icon_states))
			if (!icon_exists(initial(item.icon), icon_state))
				var/icon_file = initial(item.icon)
				stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([text_ref(icon_state)])")
				continue

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")
		insert_icon(imgid, get_display_icon_for(item))
