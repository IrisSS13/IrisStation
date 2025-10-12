// Blood Moon Event - Atmospheric Effects
/// Simple fog effect for blood moon
/obj/effect/blood_moon_fog
	name = "ominous fog"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke2"
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	alpha = 0

/obj/effect/blood_moon_fog/Initialize(mapload)
	. = ..()
	add_atom_colour("#4D0000", FIXED_COLOUR_PRIORITY)
	setDir(pick(GLOB.cardinals))
	animate(src, alpha = 150, time = 3 SECONDS)

/// Helper proc to check if a turf is valid for fog spawning
/datum/blood_moon_controller/proc/is_valid_fog_turf(turf/T)
	if(locate(/obj/effect/blood_moon_fog) in T)
		return FALSE
	if(T.density)
		return FALSE
	// Check for dense objects that should block fog
	for(var/obj/O in T.contents)
		if(O.density && (istype(O, /obj/structure/window) || istype(O, /obj/structure/grille)))
			return FALSE
	return TRUE

/// Spawn fog in Hallways and Maintenance from vents/scrubbers
/datum/blood_moon_controller/proc/spawn_hallway_fog(mob/user, amount = 250)
	var/count = 0
	var/list/valid_turfs = list()
	
	// Collect all turfs in hallways/maintenance
	for(var/area/area_to_check in GLOB.areas)
		if(istype(area_to_check, /area/station/hallway) || istype(area_to_check, /area/station/maintenance))
			for(var/turf/open/T in area_to_check.get_turfs_from_all_zlevels())
				if(is_valid_fog_turf(T))
					valid_turfs += T

	// Spawn fog randomly
	valid_turfs = shuffle(valid_turfs)
	for(var/i in 1 to min(amount, length(valid_turfs)))
		var/turf/T = valid_turfs[i]
		var/obj/effect/blood_moon_fog/F = new(T)
		spawned_fog += F
		count++
		if(count % 50 == 0)
			CHECK_TICK

	log_admin("[key_name(user)] spawned [count] fog clouds from vents/scrubbers")
	message_admins("[key_name_admin(user)] spawned [count] fog clouds from vents/scrubbers")
	to_chat(user, span_adminnotice("Spawned [count] fog clouds from vents/scrubbers in hallways and maintenance."), confidential = TRUE)

/// Clear fog from the current area with a fade effect
/datum/blood_moon_controller/proc/clear_room_fog(mob/user)
	var/area/A = get_area(user)
	var/count = 0

	for(var/obj/effect/blood_moon_fog/F as anything in spawned_fog)
		if(get_area(F) == A)
			animate(F, alpha = 0, time = 3 SECONDS)
			QDEL_IN(F, 3 SECONDS)
			count++
			spawned_fog -= F

	log_admin("[key_name(user)] cleared [count] fog clouds from [A.name]")
	message_admins("[key_name_admin(user)] cleared [count] fog clouds from [A.name]")

/// Spawn fog in current area from doors (spreads into room)
/datum/blood_moon_controller/proc/spawn_room_fog(mob/user, amount = 10)
	var/list/valid_turfs = list()
	var/area/user_area = get_area(user)
	if(!user_area)
		to_chat(user, span_warning("Could not determine your current area."), confidential = TRUE)
		return

	// Collect all valid turfs in the current area
	for(var/turf/open/T in user_area.get_turfs_from_all_zlevels())
		if(is_valid_fog_turf(T))
			valid_turfs += T

	// Randomize and take first [amount] turfs
	valid_turfs = shuffle(valid_turfs)
	for(var/i in 1 to min(amount, length(valid_turfs)))
		var/turf/T = valid_turfs[i]
		var/obj/effect/blood_moon_fog/F = new(T)
		spawned_fog += F

	var/actual_amount = min(amount, length(valid_turfs))
	log_admin("[key_name(user)] spawned [actual_amount] fog clouds in [user_area.name]")
	message_admins("[key_name_admin(user)] spawned [actual_amount] fog clouds in [user_area.name]")
	to_chat(user, span_adminnotice("Spawned [actual_amount] fog clouds in [user_area.name]."), confidential = TRUE)

/// Clear all spawned fog
/datum/blood_moon_controller/proc/clear_all_fog(mob/user)
	var/count = 0
	for(var/obj/effect/blood_moon_fog/F as anything in spawned_fog)
		animate(F, alpha = 0, time = 3 SECONDS)
		QDEL_IN(F, 3 SECONDS)
		count++
	spawned_fog.Cut()

	if(user)
		log_admin("[key_name(user)] cleared [count] fog effects")
		message_admins("[key_name_admin(user)] cleared [count] fog effects")
		to_chat(user, span_adminnotice("Clearing [count] fog effects (fading out over 3 seconds)."), confidential = TRUE)
