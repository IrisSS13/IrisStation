// Blood Moon Event - Decay and Rust Effects
// Handles environmental decay and rust

/// Rust the area the user is currently in
/datum/blood_moon_controller/proc/rust_random_areas(mob/user, amount = 10)
	var/count = 0

	// Get the area the user is in
	var/area/user_area = get_area(user)
	if(!user_area)
		to_chat(user, span_warning("Could not determine your current area."), confidential = TRUE)
		return

	// Track all rusted items
	var/list/rusted_items = list()

	// Rust walls (30% chance)
	for(var/turf/closed/wall/W in user_area.get_turfs_from_all_zlevels())
		if(prob(30))
			if(!HAS_TRAIT(W, TRAIT_RUSTY))
				// Store original state
				if(!original_turfs[W.type])
					original_turfs[W.type] = list()
				original_turfs[W.type] += W
				
				W.rust_turf()
				rusted_items += W
				count++

		if(count % 10 == 0)
			CHECK_TICK

	// Convert floors to rust (20% chance)
	for(var/turf/open/floor/F in user_area.get_turfs_from_all_zlevels())
		if(prob(20))
			if(istype(F, /turf/open/floor/plating/rust) || !istype(F, /turf/open/floor))
				continue
			
			// Store original state
			if(!original_turfs[F.type])
				original_turfs[F.type] = list()
			original_turfs[F.type] += F
			
			F.ChangeTurf(/turf/open/floor/plating/rust, flags = CHANGETURF_INHERIT_AIR)
			rusted_items += F
			count++

		if(count % 10 == 0)
			CHECK_TICK

	if(length(rusted_items))
		if(!rusted_areas[user_area])
			rusted_areas[user_area] = list()
		rusted_areas[user_area] += rusted_items

	log_admin("[key_name(user)] rusted [count] tiles in [user_area.name]")
	message_admins("[key_name_admin(user)] rusted [count] tiles in [user_area.name]")
	to_chat(user, span_adminnotice("Rusted [count] tiles in [user_area.name]."), confidential = TRUE)

/// Clear all rust and restore floors
/datum/blood_moon_controller/proc/clear_all_rust(mob/user)
	var/count = 0
	for(var/turf_type in original_turfs)
		for(var/turf/T in original_turfs[turf_type])
			if(istype(T, /turf/open/floor/plating/rust))
				T.ChangeTurf(turf_type, flags = CHANGETURF_INHERIT_AIR)
			else if(istype(T, /turf/closed/wall))
				T.RemoveElement(/datum/element/rust)
				T.RemoveElement(/datum/element/rust/heretic)
				T.update_appearance()
			count++
	original_turfs.Cut()
	rusted_areas.Cut()

	if(user)
		log_admin("[key_name(user)] cleared rust from [count] items")
		message_admins("[key_name_admin(user)] cleared rust from [count] items")
		to_chat(user, span_adminnotice("Cleared rust from [count] items."), confidential = TRUE)

/// Rust the area around the user with spreading effect
/datum/blood_moon_controller/proc/rust_around_user(mob/user, amount = 20, range = 7)
	var/count = 0
	var/turf/center_turf = get_turf(user)
	var/chaos_factor = 0.3 // 30% chance for chaotic jumps

	if(!center_turf)
		to_chat(user, span_warning("Could not determine your location."), confidential = TRUE)
		return

	var/list/current_spread = list(center_turf)
	var/list/next_spread = list()
	var/list/spread_turfs = list()
	var/area/center_area = get_area(center_turf)
	
	if(!rusted_areas[center_area])
		rusted_areas[center_area] = list()

	for(var/distance in 0 to range)
		for(var/turf/T in current_spread)
			if(count >= amount)
				break
			
			// Chaotic jump
			if(prob(chaos_factor * 100))
				T = pick(RANGE_TURFS(2, T))
			
			if((istype(T, /turf/open/floor/plating/rust) || (istype(T, /turf/closed/wall) && HAS_TRAIT(T, TRAIT_RUSTY))) || !istype(T, /turf/open/floor) && !istype(T, /turf/closed/wall) || get_area(T) != center_area)
				continue
			
			addtimer(CALLBACK(src, PROC_REF(apply_rust_effect), T), distance * 0.5 SECONDS)
			rusted_areas[center_area] += T
			count++
			
			// Get adjacent turfs for next spread iteration
			for(var/turf/adjacent in RANGE_TURFS(1, T))
				if(!(adjacent in spread_turfs) && get_dist(adjacent, center_turf) <= range && (istype(adjacent, /turf/open/floor) || istype(adjacent, /turf/closed/wall)))
					next_spread += adjacent
					spread_turfs += adjacent
		
		if(count >= amount)
			break
		current_spread = next_spread.Copy()
		next_spread.Cut()

	log_admin("[key_name(user)] started rust spread at [AREACOORD(center_turf)]")
	message_admins("[key_name_admin(user)] started rust spread at [AREACOORD(center_turf)]")
	to_chat(user, span_adminnotice("Started rust spread from your location. Rust will spread to [count] tiles."), confidential = TRUE)

/// Helper proc for associative distance sorting
/proc/cmp_dist_assoc(list/A, list/B, turf/center)
	return A[center] - B[center]

/// Apply rust effect to a floor
/datum/blood_moon_controller/proc/apply_rust_effect(turf/T)
	if(!original_turfs[T.type])
		original_turfs[T.type] = list()
	original_turfs[T.type] += T

	playsound(T, 'modular_nova/master_files/sound/effects/rustle1.ogg', 30, TRUE, frequency = rand(0.9, 1.1))

	if(istype(T, /turf/open/floor))
		T.ChangeTurf(/turf/open/floor/plating/rust, flags = CHANGETURF_INHERIT_AIR)
	else if(istype(T, /turf/closed/wall) && !HAS_TRAIT(T, TRAIT_RUSTY))
		T.rust_turf()
