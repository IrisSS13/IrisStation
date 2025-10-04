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

		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)
		if(!icon_state || !istext(icon_state))
			continue

		// Try to load the icon - first with the given state
		if(!icon_exists(icon_file, icon_state))
			// If that fails, try using just the last part of a full path
			var/last_part = copytext(icon_state, findlasttext(icon_state, "/") + 1)
			if(last_part && icon_exists(icon_file, last_part))
				icon_state = last_part
			else
				if (PERFORM_ALL_TESTS(focus_only/invalid_vending_machine_icon_states))
					stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([text_ref(icon_state)])")
				continue

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")
		insert_icon(imgid, get_display_icon_for(item))
