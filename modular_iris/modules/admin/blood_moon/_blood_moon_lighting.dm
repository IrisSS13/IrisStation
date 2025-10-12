// Blood Moon Event - Lighting Effects
// Handles all lighting-related functions

/// Apply light settings to all station lights
/datum/blood_moon_controller/proc/dim_station_lights(mob/user)
	var/count = 0

	// First, try to get all areas on station levels
	var/list/station_areas = list()
	for(var/area/A in GLOB.areas)
		if(!is_station_level(A.z))
			continue
		station_areas += A

	// Then get all lights in those areas
	for(var/obj/machinery/light/L in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		// Skip if not on station level, not in a station area, or not working
		if(!is_station_level(L.z) || !(get_area(L) in station_areas) || L.status != LIGHT_OK)
			continue

		var/is_new_light = !(L in affected_lights)

		// Store original state if this is a new light
		if(is_new_light)
			affected_lights[L] = list(
				"brightness" = L.brightness,
				"power" = L.bulb_power,
				"color" = L.bulb_colour,
				"was_on" = L.on
			)

		// Apply blood moon effect with current color and brightness
		var/original_brightness = is_new_light ? L.brightness : affected_lights[L]["brightness"]
		var/new_brightness = max(1, original_brightness * current_light_brightness)

		// Add a quick flicker effect
		if(L.on)
			spawn(rand(0, 5) * 0.1)
				L.flicker(rand(3, 5))
				sleep(0.5)

				// Update light properties after flicker
				L.brightness = new_brightness
				L.bulb_colour = current_light_color
				L.color = current_light_color
				L.update(FALSE, TRUE, FALSE)
		else
			// If light is off, just update without flicker
			L.brightness = new_brightness
			L.bulb_colour = current_light_color
			L.color = current_light_color
			L.update(FALSE, TRUE, FALSE)

		count++
		if(count % 50 == 0)
			CHECK_TICK

	log_admin("[key_name(user)] applied blood moon effect to [count] lights")
	message_admins("[key_name_admin(user)] applied blood moon effect to [count] lights")
	to_chat(user, span_adminnotice("Applied blood moon effect to [count] lights."), confidential = TRUE)

/// Flicker all station lights dramatically
/datum/blood_moon_controller/proc/flicker_station_lights(mob/user)
	var/count = 0
	for(var/obj/machinery/light/L in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(!is_station_level(L.z)) continue

		spawn(rand(0, 10))
			L.flicker(rand(3, 8))

		count++
		if(count % 50 == 0)
			CHECK_TICK

	log_admin("[key_name(user)] flickered [count] station lights")
	message_admins("[key_name_admin(user)] flickered [count] station lights")
	to_chat(user, span_adminnotice("Flickered [count] lights."), confidential = TRUE)

/// Flicker lights in current area
/datum/blood_moon_controller/proc/flicker_room_lights(mob/user)
	var/area/user_area = get_area(user)
	if(!user_area)
		to_chat(user, span_warning("Could not determine your current area."), confidential = TRUE)
		return

	var/count = 0
	for(var/obj/machinery/light/L as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(get_area(L) != user_area)
			continue

		spawn(rand(0, 10))
			L.flicker(rand(3, 8))
		count++

	log_admin("[key_name(user)] flickered [count] lights in [user_area.name]")
	message_admins("[key_name_admin(user)] flickered [count] lights in [user_area.name]")
	to_chat(user, span_adminnotice("Flickered [count] lights in [user_area.name]."), confidential = TRUE)

/// Restore all affected lights
/datum/blood_moon_controller/proc/restore_all_lights(mob/user)
	var/count = 0
	for(var/obj/machinery/light/L in affected_lights)
		// Check if light still exists and is valid
		if(QDELETED(L))
			continue

		var/list/original = affected_lights[L]
		if(!original)
			continue

		// Store current power state
		var/was_on = L.on

		// Restore the light's original properties
		L.brightness = original["brightness"]
		L.bulb_power = original["power"]
		L.bulb_colour = original["color"]
		L.color = original["color"]

		// Force an immediate update
		L.update(FALSE, TRUE, FALSE)

		// If the light was on originally and is still on, do the flicker effect
		if(original["was_on"] && was_on)
			spawn(rand(0, 5))
				L.flicker(rand(1, 2))
				sleep(2 SECONDS)
				L.update(FALSE, TRUE, FALSE)

		count++
		if(count % 50 == 0)
			CHECK_TICK

	affected_lights.Cut()

	if(user)
		log_admin("[key_name(user)] restored [count] lights")
		message_admins("[key_name_admin(user)] restored [count] lights")
		to_chat(user, span_adminnotice("Restored [count] lights with flicker effect."), confidential = TRUE)
