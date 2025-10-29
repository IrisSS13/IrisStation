// Blood Moon Event - Main Controller
// Provides admin tools for creating spooky atmospheric effects

/// Admin verb to control Blood Moon atmospheric effects
ADMIN_VERB(blood_moon_controls, R_ADMIN|R_FUN, "Blood Moon Controls", "Control atmospheric effects for RP events.", ADMIN_CATEGORY_FUN)
	var/datum/blood_moon_controller/controller = GLOB.blood_moon_controller
	if(!controller)
		GLOB.blood_moon_controller = new
		controller = GLOB.blood_moon_controller

	controller.ui_interact(user.mob)
	log_admin("[key_name(user)] opened Blood Moon controls.")
	message_admins("[key_name_admin(user)] opened Blood Moon controls.")
	BLACKBOX_LOG_ADMIN_VERB("Blood Moon Controls")

/// Global singleton for blood moon effects
GLOBAL_DATUM(blood_moon_controller, /datum/blood_moon_controller)

/datum/blood_moon_controller
	var/original_starlight_color
	var/original_starlight_range
	var/original_starlight_power
	var/list/original_turfs = list() // type = list(turfs)
	var/list/affected_lights = list()
	var/list/spawned_fog = list()
	var/list/rusted_areas = list()
	var/current_light_color = "#8B0000"
	var/current_light_brightness = 0.6

/datum/blood_moon_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BloodMoonControls")
		ui.open()

/datum/blood_moon_controller/ui_state(mob/user)
	return GLOB.admin_state

/datum/blood_moon_controller/ui_data(mob/user)
	var/list/data = list()
	data["starlight_color"] = GLOB.starlight_color
	data["affected_lights_count"] = length(affected_lights)
	data["fog_count"] = length(spawned_fog)
	// Count total rusted items across all areas
	var/total_rusted = 0
	for(var/area/A in rusted_areas)
		total_rusted += length(rusted_areas[A])
	data["rusted_areas_count"] = total_rusted
	data["current_light_color"] = current_light_color
	data["current_light_brightness"] = current_light_brightness
	return data

/datum/blood_moon_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("change_starlight")
			var/new_color = input(user, "Pick starlight color (red recommended for blood moon)", "Starlight Color") as color|null
			if(new_color)
				set_starlight(new_color)
				log_admin("[key_name(user)] changed starlight to [new_color]")
				message_admins("[key_name_admin(user)] changed starlight to [new_color]")
			return TRUE

		if("reset_starlight")
			reset_starlight()
			log_admin("[key_name(user)] reset starlight to default")
			message_admins("[key_name_admin(user)] reset starlight to default")
			return TRUE

		if("flicker_all_lights")
			flicker_station_lights(user)
			return TRUE

		if("flicker_room_lights")
			flicker_room_lights(user)
			return TRUE

		if("dim_all_lights")
			dim_station_lights(user)
			return TRUE

		if("change_light_color")
			var/new_color = input(user, "Pick light color", "Light Color") as color|null
			if(new_color)
				current_light_color = new_color
				log_admin("[key_name(user)] changed light color to [new_color]")
				message_admins("[key_name_admin(user)] changed light color to [new_color]")
			return TRUE

		if("change_light_brightness")
			var/new_brightness = params["brightness"]
			if(new_brightness)
				current_light_brightness = new_brightness
				log_admin("[key_name(user)] changed light brightness to [new_brightness]")
				message_admins("[key_name_admin(user)] changed light brightness to [new_brightness]")
			return TRUE

		if("update_fog_density")
			var/new_density = params["density"]
			if(!isnull(new_density))
				update_fog_density(new_density)
				log_admin("[key_name(user)] updated fog density to [new_density]")
				message_admins("[key_name_admin(user)] updated fog density to [new_density]")
			return TRUE

		if("restore_all_lights")
			restore_all_lights(user)
			return TRUE

		if("spawn_hallway_fog")
			var/amount = params["amount"] || 50
			var/fog_density = params["fog_density"]
			spawn_hallway_fog(user, amount, fog_density)
			return TRUE

		if("spawn_room_fog")
			var/amount = params["amount"] || 20
			var/fog_density = params["fog_density"]
			spawn_room_fog(user, amount, fog_density)
			return TRUE

		if("clear_fog")
			clear_all_fog(user)
			return TRUE

		if("clear_room_fog")
			clear_room_fog(user)
			return TRUE

		if("pulse_fog")
			pulse_fog()
			return TRUE

		if("rust_random_areas")
			rust_random_areas(user)
			return TRUE

		if("clear_rust")
			clear_all_rust(user)
			return TRUE

		if("rust_around_user")
			rust_around_user(user)
			return TRUE

		if("announce_act_1")
			announce_blood_moon_act_1()
			return TRUE

		if("announce_act_2")
			announce_blood_moon_act_2()
			return TRUE

		if("announce_act_3")
			announce_blood_moon_act_3()
			return TRUE


/// Set starlight color - wrapper around global set_starlight
/datum/blood_moon_controller/proc/set_starlight(new_color, new_range = 2, new_power = 1)
	if(!original_starlight_color)
		original_starlight_color = GLOB.starlight_color
		original_starlight_range = GLOB.starlight_range
		original_starlight_power = GLOB.starlight_power

	// Save old color before changing it
	var/old_star_color = GLOB.starlight_color

	// Update globals
	GLOB.starlight_color = new_color
	GLOB.starlight_range = new_range
	GLOB.starlight_power = new_power

	// Update all space turfs
	for(var/turf/open/space/spess as anything in GLOB.starlight)
		spess.set_light(l_range = new_range, l_power = new_power, l_color = new_color)

	// Only update overlays and send signal if color actually changed
	if(new_color != old_star_color)
		// Update the base overlays
		for(var/obj/light as anything in GLOB.starlight_objects)
			light.color = new_color

		// Update parallax layers to match starlight color
		update_parallax_colors(new_color)

		// Send signal for other systems that use starlight color
		SEND_GLOBAL_SIGNAL(COMSIG_STARLIGHT_COLOR_CHANGED, old_star_color, new_color)

/// Update density of all existing fog instances
/datum/blood_moon_controller/proc/update_fog_density(new_density)
	for(var/obj/effect/blood_moon_fog/fog as anything in spawned_fog)
		fog.set_fog_density(new_density)
	log_admin("Updated fog density to [new_density] for [length(spawned_fog)] fog instances")

/// Make all fog instances pulse
/datum/blood_moon_controller/proc/pulse_fog()
	for(var/obj/effect/blood_moon_fog/fog as anything in spawned_fog)
		fog.pulse_fog()
	log_admin("Pulsed [length(spawned_fog)] fog instances")

/// Update parallax layer colors to match starlight
/datum/blood_moon_controller/proc/update_parallax_colors(new_color)
	// Update all clients' parallax layers
	for(var/client/C as anything in GLOB.clients)
		if(!C.parallax_layers_cached)
			continue

		// Only update layer_1 (background layer) and stars, but not the planet
		for(var/atom/movable/screen/parallax_layer/layer as anything in C.parallax_layers_cached)
			if(istype(layer, /atom/movable/screen/parallax_layer/planet))
				continue  // Skip the planet layer
			if(istype(layer, /atom/movable/screen/parallax_layer/layer_1) || istype(layer, /atom/movable/screen/parallax_layer/stars))
				layer.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
				layer.add_atom_colour(new_color, ADMIN_COLOUR_PRIORITY)

/// Reset starlight to default
/datum/blood_moon_controller/proc/reset_starlight()
	if(original_starlight_color)
		set_starlight(original_starlight_color, original_starlight_range, original_starlight_power)
	else
		set_starlight(COLOR_STARLIGHT, 2, 1)
