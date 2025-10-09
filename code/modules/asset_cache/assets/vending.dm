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

		// Get icon info
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		// Check for preview state
		if(ispath(item, /obj))
			var/obj/obj_atom = item
			if(initial(obj_atom.icon_state_preview))
				icon_state = initial(obj_atom.icon_state_preview)

		// Skip if we don't have an icon file
		if(!icon_file)
			continue

		var/has_gags = initial(item.greyscale_config) && initial(item.greyscale_colors)

		// For non-GAGS items, validate the icon state exists
		if(!has_gags)
			// Create temporary instance if we need runtime icon state computation
			var/obj/temp_obj
			if(isnull(icon_state))
				temp_obj = new item()
				icon_file = temp_obj.icon
				icon_state = temp_obj.icon_state

			// Skip if we still don't have a valid icon state
			if(!icon_state || !istext(icon_state))
				if(temp_obj)
					qdel(temp_obj)
				continue

			// Check if icon state exists in the file
			if(!icon_exists(icon_file, icon_state))
				// If it's a full path, try extracting just the last part
				if(findtext(icon_state, "/"))
					var/last_part = copytext(icon_state, findlasttext(icon_state, "/") + 1)
					if(last_part && icon_exists(icon_file, last_part))
						icon_state = last_part
					else
						// Invalid icon state, skip silently
						if(temp_obj)
							qdel(temp_obj)
						continue
				else
					// Invalid icon state, skip silently
					if(temp_obj)
						qdel(temp_obj)
					continue

			// Clean up temp object if we created one
			if(temp_obj)
				qdel(temp_obj)

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")
		insert_icon(imgid, get_display_icon_for(item))
