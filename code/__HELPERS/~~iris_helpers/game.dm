// Code for stowaway trait ported from https://github.com/Monkestation/Monkestation2.0/pull/4642
/// Used to get a random closed and non-secure locker on the station z-level, created for the Stowaway trait.
/proc/get_unlocked_closed_locker()
	var/list/eligible_lockers = list()
	for(var/obj/structure/closet/closet as anything in GLOB.roundstart_station_closets)
		if(QDELETED(closet) || closet.opened || istype(closet, /obj/structure/closet/secure_closet))
			continue
		var/turf/closet_turf = get_turf(closet)
		if(!closet_turf || !is_station_level(closet_turf.z) || !is_safe_turf(closet_turf, dense_atoms = TRUE))
			continue
		eligible_lockers += closet
	if(length(eligible_lockers))
		return pick(eligible_lockers)

///Get active station players who are playing excluding all ghosts
/proc/get_active_player_list_deathmatch()
	var/list/alive_players = list()
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!player_mob?.client)
			continue
		if(isnewplayer(player_mob)) // exclude people in the lobby
			continue
		if(isobserver(player_mob)) // exclude all ghosts
			continue
		alive_players += player_mob
	return alive_players

///Counts active station players who are playing excluding ghosts
/proc/get_active_player_count_deathmatch()
	return length(get_active_player_list_deathmatch())
