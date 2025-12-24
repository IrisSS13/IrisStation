// admin helper for creating custom parallax
/datum/hud/proc/create_custom_parallax(mob/viewmob, icon_path = null, icon_state = null, color_mode = null, mode = null)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	if(!C || !screenmob.hud_used)
		return FALSE
	var/list/PARALLAX_DEFAULT_LAYER_ICONS = new
	if(islist(GLOB.parallax_manager.roundstart_parallax_defaults) && length(GLOB.parallax_manager.roundstart_parallax_defaults))
		for(var/i = 1; i <= length(GLOB.parallax_manager.roundstart_parallax_defaults); i++)
			var/entry = GLOB.parallax_manager.roundstart_parallax_defaults[i]
			if(islist(entry) && length(entry) >= 3)
				var/iconp = entry[2] || ""
				var/iconst = entry[3] || ""
				var/col = length(entry) >= 4 ? entry[4] : null
				PARALLAX_DEFAULT_LAYER_ICONS += list(list(iconp, iconst, col))
	else
		PARALLAX_DEFAULT_LAYER_ICONS = list()
	var/old_base = initial(GLOB.base_starlight_color)

	// need this to get the overlays
	src.remove_parallax(screenmob)
	src.create_parallax(screenmob, icon_path, icon_state, mode)
	src.update_parallax(screenmob)

	var/view = screenmob.client.view || world.view

	if(mode == "layer_1")
		// remove from the main list and qdel the atoms to keep things tidy
		for(var/i = length(C.parallax_layers); i >= 1; i--)
			var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
			if(!layer)
				continue
			if(!istype(layer, /atom/movable/screen/parallax_layer/layer_1))
				C.parallax_layers.Cut(i)
				if(C.parallax_rock)
					C.parallax_rock.vis_contents -= layer
				qdel(layer)
		// clear cached templates so create_parallax will rebuild them fresh
		C.parallax_layers_cached = null

	if(icon_path)
		for(var/i = 1; i <= length(C.parallax_layers); i++)
			var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
			if(!layer)
				continue

			if(mode == "layer_1")
				if(istype(layer, /atom/movable/screen/parallax_layer/layer_1))
					layer.icon = icon(icon_path, icon_state)
					layer.icon_state = icon_state
					layer.update_o(view)
					break
				continue

			layer.icon = icon(icon_path, icon_state)
			layer.icon_state = icon_state
			layer.update_o(view)

	regenerate_parallax_overlays(screenmob)

	// store per-mob override for future reconnects
	var/ckey = C.ckey || key_name(screenmob)
	if(istype(GLOB.parallax_manager.roundstart_parallax_mob_overrides, /list))
		var/found = 0
		for(var/mi = 1; mi <= length(GLOB.parallax_manager.roundstart_parallax_mob_overrides); mi++)
			if(GLOB.parallax_manager.roundstart_parallax_mob_overrides[mi][1] == ckey)
				found = mi
				break
		if(found)
			GLOB.parallax_manager.roundstart_parallax_mob_overrides[found][4] = icon_path
			GLOB.parallax_manager.roundstart_parallax_mob_overrides[found][5] = icon_state
			GLOB.parallax_manager.roundstart_parallax_mob_overrides[found][6] = color_mode
			GLOB.parallax_manager.roundstart_parallax_mob_overrides[found][7] = mode
		else
			GLOB.parallax_manager.roundstart_parallax_mob_overrides += list(list(ckey, null, null, icon_path, icon_state, color_mode, mode))
	else
		GLOB.parallax_manager.roundstart_parallax_mob_overrides = list(list(ckey, null, null, icon_path, icon_state, color_mode, mode))

	var/plane_masters = screenmob.hud_used.get_true_plane_masters(PLANE_SPACE)
	for(var/pi = 1; pi <= length(plane_masters); pi++)
		var/atom/movable/screen/plane_master/plane_master = plane_masters[pi]
		if(screenmob != mymob)
			C.screen -= locate(/atom/movable/screen/plane_master/parallax_white) in C.screen
			C.screen += plane_master

		if(color_mode == null || color_mode == "default")
			if(GLOB.parallax_manager.roundstart_skybox_starlight)
				set_base_starlight(GLOB.parallax_manager.roundstart_skybox_starlight)
			else if(GLOB.parallax_manager.roundstart_parallax_base)
				set_base_starlight(GLOB.parallax_manager.roundstart_parallax_base)
			else
				plane_master.color = initial(plane_master.color)

	if(color_mode == "remove")
		for(var/i = 1; i <= length(C.parallax_layers); i++)
			var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
			if(layer)
				layer.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		set_base_starlight(old_base)
		regenerate_parallax_overlays(screenmob)
		return TRUE

	if(!length(C.parallax_layers))
		return TRUE

	for(var/i = 1; i <= length(C.parallax_layers); i++)
		var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
		if(layer)
			layer.remove_atom_colour(ADMIN_COLOUR_PRIORITY)

	if(color_mode == null || color_mode == "default")
		if(!icon_path)
			var/i = 1
			for(var/j = 1; j <= length(C.parallax_layers); j++)
				var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[j]
				if(layer)
					var/list/default = null
					if(i <= length(PARALLAX_DEFAULT_LAYER_ICONS))
						default = PARALLAX_DEFAULT_LAYER_ICONS[i]
					if(default)
						// support either [icon, state] or [[icon, state]] forms
						var/list/pair = null
						if(islist(default) && length(default) && islist(default[1]))
							pair = default[1]
						else
							pair = default
						var/iconpath = pair[1] || ""
						var/iconst = pair[2] || ""
						if(length(iconpath))
							layer.icon = icon(iconpath, iconst)
							layer.icon_state = iconst
							layer.update_o(view)
							if(length(pair) >= 3 && pair[3] && color_mode != "remove")
								layer.add_atom_colour(pair[3], ADMIN_COLOUR_PRIORITY)
				i++
		regenerate_parallax_overlays(screenmob)
		set_base_starlight(old_base)
		return TRUE

	if(color_mode == "remove")
		for(var/i = 1; i <= length(C.parallax_layers); i++)
			var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
			if(layer)
				layer.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		set_base_starlight(old_base)
		regenerate_parallax_overlays(screenmob)
		return TRUE

	var/parsed_color = color_mode
	var/atom/movable/screen/parallax_layer/target_layer = null
	for(var/i = 1; i <= length(C.parallax_layers); i++)
		var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
		if(istype(layer, /atom/movable/screen/parallax_layer/layer_1))
			target_layer = layer
			break
	if(!target_layer)
		target_layer = C.parallax_layers[1]

	if(target_layer)
		target_layer.add_atom_colour(parsed_color, ADMIN_COLOUR_PRIORITY)
	regenerate_parallax_overlays(screenmob)
	set_base_starlight(old_base)
	return TRUE

// regenerate overlay tiles for a client's parallax layers
/proc/regenerate_parallax_overlays(mob/screenmob)
	if(!screenmob)
		return
	var/client/C = screenmob.client
	if(!C)
		return
	var/view = C.view || world.view
	for(var/i = 1; i <= length(C.parallax_layers); i++)
		var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
		if(layer)
			layer.update_o(view)
