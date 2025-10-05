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

		// Try to use the icon state as provided
		var/can_use_state = icon_exists(icon_file, icon_state)
		var/final_state = icon_state

		// If that fails and it's a full path, try just the last part
		if(!can_use_state && findtext(icon_state, "/"))
			var/last_part = copytext(icon_state, findlasttext(icon_state, "/") + 1)
			if(last_part && icon_exists(icon_file, last_part))
				final_state = last_part
				can_use_state = TRUE

		// If we can't find the icon state, skip this item
		if(!can_use_state)
			// Report it in test mode
			if(PERFORM_ALL_TESTS(focus_only/invalid_vending_machine_icon_states))
				var/icon_states_string
				for(var/an_icon_state in icon_states(icon_file))
					if(!icon_states_string)
						icon_states_string = "[json_encode(an_icon_state)]([text_ref(an_icon_state)])"
					else
						icon_states_string += ", [json_encode(an_icon_state)]([text_ref(an_icon_state)])"
				stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([text_ref(icon_state)]), icon_states=[icon_states_string]")
			if(temp_obj)
				qdel(temp_obj)
			continue

		// Generate the icon
		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")

		// Check for greyscale items
		if(initial(item.greyscale_config) && initial(item.greyscale_colors))
			insert_icon(imgid, gags_to_universal_icon(item))
			if(temp_obj)
				qdel(temp_obj)
		else if(temp_obj)
			// For instances, use uni_icon directly with the instance's properties
			insert_icon(imgid, uni_icon(temp_obj.icon, final_state, color=temp_obj.color))
			qdel(temp_obj)
		else
			// For paths, use get_display_icon_for which handles preview states and colors
			insert_icon(imgid, get_display_icon_for(item))
