// manager datum for parallax admin helpers

GLOBAL_DATUM(parallax_manager, /datum/parallax_manager)

/datum/parallax_manager
	var/list/roundstart_parallax_defaults = null
	var/roundstart_parallax_base = null
	var/list/roundstart_plane_master_color = null
	var/roundstart_skybox_starlight = null
	var/roundstart_parallax_planet_x_offset = null
	var/roundstart_parallax_planet_y_offset = null
	var/list/roundstart_parallax_mob_overrides = list()
	var/roundstart_parallax_global_override = null

/datum/parallax_manager/New()
	. = ..()
	// reapply overrides when players finish Login()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_mob_login))
	// also reapply when new mobs are created (covers respawns/mob replacements)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_login))

/datum/parallax_manager/Destroy(force)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED)
	. = ..(force)

/datum/parallax_manager/proc/get_parallax_type_icon_state(var/typ)
	if(!typ)
		return list("", "")
	var/atom/typ_instance = new typ(null, null, TRUE)
	if(!typ_instance)
		return list("", "")
	var/iconpath = typ_instance.icon || ""
	var/iconst = typ_instance.icon_state || ""
	qdel(typ_instance)
	return list(iconpath, iconst)

/datum/parallax_manager/proc/save_roundstart_parallax_defaults()
	var/list/defaults = list()
	var/type_layer1 = /atom/movable/screen/parallax_layer/layer_1
	var/type_stars = /atom/movable/screen/parallax_layer/stars
	var/type_planet = /atom/movable/screen/parallax_layer/planet

	var/list/tmp_icon_state
	tmp_icon_state = get_parallax_type_icon_state(type_layer1)
	defaults += list(list(type_layer1, tmp_icon_state[1], tmp_icon_state[2]))
	roundstart_skybox_starlight = GLOB.base_starlight_color

	tmp_icon_state = get_parallax_type_icon_state(type_stars)
	defaults += list(list(type_stars, tmp_icon_state[1], tmp_icon_state[2]))

	if(SSparallax.random_layer && SSparallax.random_layer.type)
		var/random_type = SSparallax.random_layer.type
		tmp_icon_state = get_parallax_type_icon_state(random_type)
		defaults += list(list(random_type, tmp_icon_state[1], tmp_icon_state[2]))
	else
		defaults += list(list(null, "", ""))

	tmp_icon_state = get_parallax_type_icon_state(type_planet)
	defaults += list(list(type_planet, tmp_icon_state[1], tmp_icon_state[2]))

	roundstart_parallax_defaults = defaults
	roundstart_parallax_base = GLOB.base_starlight_color


	var/client/C = null
	for(var/ci = 1; ci <= length(GLOB.clients); ci++)
		var/client/cl = GLOB.clients[ci]
		if(cl?.mob?.hud_used && length(cl.parallax_layers))
			C = cl
			break

	var/list/captured_colours = list()
	var/list/captured_offsets = list()
	if(C)
		for(var/di = 1; di <= length(defaults); di++)
			var/entry = defaults[di]
			var/ent_type = entry[1]
			var/col = null
			var/off_x = 0
			var/off_y = 0
			var/pw = 0
			var/pz = 0
			if(ent_type)
				for(var/li = 1; li <= length(C.parallax_layers); li++)
					var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[li]
					if(!layer)
						continue
					if(istype(layer, ent_type))
						if(layer.atom_colours && LAZYLEN(layer.atom_colours) && layer.atom_colours[ADMIN_COLOUR_PRIORITY])
							col = layer.atom_colours[ADMIN_COLOUR_PRIORITY][ATOM_COLOR_VALUE_INDEX]
						// capture offsets/pixels so we can restore exact positioning
						off_x = layer.offset_x
						off_y = layer.offset_y
						pw = layer.pixel_w
						pz = layer.pixel_z
						break
			captured_colours += col
			captured_offsets += list(off_x, off_y, pw, pz)

	if(length(captured_colours))
		var/list/merged = list()
		for(var/i = 1; i <= length(defaults); i++)
			var/entry = defaults[i]
			var/ent_type = null
			var/iconp = ""
			var/iconst = ""
			if(islist(entry) && length(entry))
				ent_type = entry[1]
				iconp = entry[2] || ""
				iconst = entry[3] || ""
			var/col = i <= length(captured_colours) ? captured_colours[i] : null
			var/off_x = 0
			var/off_y = 0
			var/pw = 0
			var/pz = 0
			if(i <= length(captured_offsets))
				var/list/off_entry = captured_offsets[i]
				if(islist(off_entry) && length(off_entry) >= 4)
					off_x = off_entry[1]
					off_y = off_entry[2]
					pw = off_entry[3]
					pz = off_entry[4]
			merged += list(list(ent_type, iconp, iconst, col, off_x, off_y, pw, pz))
		roundstart_parallax_defaults = merged

	roundstart_plane_master_color = null
	for(var/ci2 = 1; ci2 <= length(GLOB.clients); ci2++)
		var/client/cl = GLOB.clients[ci2]
		if(cl?.mob?.hud_used)
			var/list/pms = cl.mob.hud_used.get_true_plane_masters(PLANE_SPACE)
			if(length(pms))
				roundstart_plane_master_color = pms[1].color
				break

	if(istype(SSparallax, /datum/controller/subsystem/parallax))
		roundstart_parallax_planet_x_offset = SSparallax.planet_x_offset
		roundstart_parallax_planet_y_offset = SSparallax.planet_y_offset

	SSblackbox.record_feedback("associative", "roundstart_parallax_defaults", 1, list("defaults" = roundstart_parallax_defaults))
	log_admin("Roundstart parallax defaults saved: [length(roundstart_parallax_defaults)] entries")
	return TRUE


/datum/parallax_manager/proc/restore_parallax_defaults(mob/screenmob)
	if(!screenmob)
		return FALSE
	var/client/C = screenmob.client
	if(!C)
		return FALSE

	// recreate parallax layers so we have the full set to restore
	if(screenmob.hud_used)
		screenmob.hud_used.remove_parallax(screenmob)
		screenmob.hud_used.create_parallax(screenmob)
		screenmob.hud_used.update_parallax(screenmob)

	var/list/defaults = null
	if(islist(roundstart_parallax_defaults) && length(roundstart_parallax_defaults))
		defaults = roundstart_parallax_defaults
	else
		defaults = list()


	var/view = screenmob.client.view || world.view

	// ensure overrides survive client restarts
	if(!istype(roundstart_parallax_mob_overrides, /list))
		roundstart_parallax_mob_overrides = list()
	var/ckey = C.ckey || key_name(screenmob)
	var/found = 0
	for(var/mi = 1; mi <= length(roundstart_parallax_mob_overrides); mi++)
		if(roundstart_parallax_mob_overrides[mi][1] == ckey)
			found = mi
			break
	if(found)
		roundstart_parallax_mob_overrides[found] = list(ckey, null, null)
	else
		roundstart_parallax_mob_overrides += list(list(ckey, null, null))

	for(var/i = 1; i <= length(C.parallax_layers); i++)
		var/atom/movable/screen/parallax_layer/layer = C.parallax_layers[i]
		if(!layer)
			continue
		layer.remove_atom_colour(ADMIN_COLOUR_PRIORITY)

		var/matched = null
		if(islist(defaults) && length(defaults))
			for(var/di = 1; di <= length(defaults); di++)
				var/d = defaults[di]
				if(islist(d) && length(d) >= 2)
					var/ent_type = d[1]
					if(ent_type && istype(layer, ent_type))
						matched = d
						break

		if(!matched && islist(defaults) && i <= length(defaults))
			matched = defaults[i]

		if(matched)
			var/iconpath = matched[2] || ""
			var/iconst = matched[3] || ""
			var/ent_col = length(matched) >= 4 ? matched[4] : null
			var/ent_off_x = length(matched) >= 5 ? matched[5] : 0
			var/ent_off_y = length(matched) >= 6 ? matched[6] : 0
			var/ent_pixel_w = length(matched) >= 7 ? matched[7] : 0
			var/ent_pixel_z = length(matched) >= 8 ? matched[8] : 0
			if(length(iconpath))
				layer.icon = icon(iconpath, iconst)
				layer.icon_state = iconst
				if(ent_col)
					layer.add_atom_colour(ent_col, ADMIN_COLOUR_PRIORITY)
			layer.offset_x = ent_off_x
			layer.offset_y = ent_off_y
			layer.pixel_w = ent_pixel_w
			layer.pixel_z = ent_pixel_z
			layer.transform = matrix()
			layer.update_o(view)

	if(roundstart_skybox_starlight)
		set_base_starlight(roundstart_skybox_starlight)
	else if(roundstart_parallax_base)
		set_base_starlight(roundstart_parallax_base)

	if(islist(roundstart_plane_master_color) && length(roundstart_plane_master_color))
		var/plane_masters = screenmob.hud_used.get_true_plane_masters(PLANE_SPACE)
		for(var/pi = 1; pi <= length(plane_masters); pi++)
			var/atom/movable/screen/plane_master/pm = plane_masters[pi]
			pm.color = roundstart_plane_master_color
	else if(!roundstart_parallax_base)
		var/plane_masters_fallback = screenmob.hud_used.get_true_plane_masters(PLANE_SPACE)
		for(var/pi2 = 1; pi2 <= length(plane_masters_fallback); pi2++)
			var/atom/movable/screen/plane_master/pm = plane_masters_fallback[pi2]
			pm.color = list(
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				1, 1, 1, 1,
				0, 0, 0, 0
			)
	regenerate_parallax_overlays(screenmob)
	return TRUE


/datum/parallax_manager/proc/reapply_parallax_overrides(mob/screenmob)
	if(!screenmob)
		return FALSE
	var/client/C = screenmob.client
	if(!C)
		return FALSE
	var/applied = FALSE

	if(!screenmob.hud_used)
		screenmob.create_mob_hud()

	if(screenmob.hud_used)
		if(!length(C.parallax_layers))
			screenmob.hud_used.create_parallax(screenmob)
		else
			screenmob.hud_used.update_parallax(screenmob)
		regenerate_parallax_overlays(screenmob)

	// check for per-mob override first
	if(istype(roundstart_parallax_mob_overrides, /list))
		var/matching_key = C.ckey || key_name(screenmob)
		for(var/mi = 1; mi <= length(roundstart_parallax_mob_overrides); mi++)
			var/override_entry = roundstart_parallax_mob_overrides[mi]
			if(override_entry[1] == matching_key)
				var/persist_icon = length(override_entry) >= 4 ? override_entry[4] : null
				var/persist_state = length(override_entry) >= 5 ? override_entry[5] : null
				var/persist_color_mode = length(override_entry) >= 6 ? override_entry[6] : null
				var/persist_mode = length(override_entry) >= 7 ? override_entry[7] : null
				if(persist_icon || persist_state)
					screenmob.hud_used.create_custom_parallax(screenmob, persist_icon, persist_state, persist_color_mode, persist_mode)
					if(persist_mode == "layer_1" || (persist_mode == null && persist_icon))
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
				SSblackbox.record_feedback("tally", "parallax_persisted_applied", 1)
				applied = TRUE
				break
	// if no per-mob override was applied, fall back to any global override
	if(!applied && roundstart_parallax_global_override)
		var/global_override = roundstart_parallax_global_override
		var/g_icon = global_override[1]
		var/g_state = global_override[2]
		var/g_color_mode = length(global_override) >= 5 ? global_override[5] : null
		var/g_mode = length(global_override) >= 6 ? global_override[6] : null

		if(g_icon || g_state || g_color_mode || g_mode)
			if(screenmob.hud_used)
				screenmob.hud_used.create_custom_parallax(screenmob, g_icon, g_state, g_color_mode, g_mode)
			else
				screenmob.hud_used?.create_parallax(screenmob)
				screenmob.hud_used?.create_custom_parallax(screenmob, g_icon, g_state, g_color_mode, g_mode)
		else
			regenerate_parallax_overlays(screenmob)
		return TRUE

	return applied


/datum/parallax_manager/proc/set_parallax_global_override(icon_path = null, icon_state = null, planet_x = null, planet_y = null, color_mode = null, mode = null, apply_now = FALSE)
	roundstart_parallax_global_override = list(icon_path, icon_state, planet_x, planet_y, color_mode, mode)
	log_admin("Global parallax override set: [icon_path], state=[icon_state], px=[planet_x], py=[planet_y], color=[color_mode], mode=[mode]")
	if(apply_now)
		apply_global_parallax_override_now()
	return TRUE


/datum/parallax_manager/proc/clear_parallax_global_override(apply_now = FALSE)
	roundstart_parallax_global_override = null
	log_admin("Global parallax override cleared")
	if(apply_now)
		for(var/ci = 1; ci <= length(GLOB.clients); ci++)
			var/client/cl = GLOB.clients[ci]
			if(cl && cl.mob && cl.mob.hud_used)
				restore_parallax_defaults(cl.mob)
	return TRUE


/datum/parallax_manager/proc/apply_global_parallax_override_now()
	if(!roundstart_parallax_global_override)
		return 0
	var/count = 0
	var/global_override = roundstart_parallax_global_override
	var/g_icon = global_override[1]
	var/g_state = global_override[2]
	var/g_col = length(global_override) >= 5 ? global_override[5] : null
	var/g_mode = length(global_override) >= 6 ? global_override[6] : null

	for(var/ci = 1; ci <= length(GLOB.clients); ci++)
		var/client/cl = GLOB.clients[ci]
		if(!cl || !cl.mob)
			continue
		var/mob/sm = cl.mob

		if(sm.hud_used)
			sm.hud_used.create_custom_parallax(sm, g_icon, g_state, g_col, g_mode)
		else
			sm.hud_used?.create_parallax(sm)
			sm.hud_used?.create_custom_parallax(sm, g_icon, g_state, g_col, g_mode)
		count++
	SSblackbox.record_feedback("tally", "parallax_global_applied", count, list("icon" = g_icon, "state" = g_state, "mode" = g_mode, "color" = g_col))
	log_admin("Applied global parallax override to [count] clients")
	return count

/datum/parallax_manager/proc/on_mob_login(datum/source, mob/new_login)
	SIGNAL_HANDLER
	if(!new_login)
		return
	if(new_login.client)
		if(GLOB.parallax_manager)
			GLOB.parallax_manager.reapply_parallax_overrides(new_login)
