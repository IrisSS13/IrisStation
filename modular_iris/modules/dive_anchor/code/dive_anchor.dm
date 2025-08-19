GLOBAL_LIST_EMPTY(anchors)

/obj/machinery/dive_anchor
	name = "dive anchor"
	desc = "They've been working on a unified theory."
	density = TRUE
	use_power = NO_POWER_USE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Unique name for this anchor
	var/designation = "Ad Astra"
	///Name of linked anchor
	var/target_designation = "Space Station 13"

/obj/machinery/dive_anchor/Initialize(mapload)
	. = ..()
	GLOB.anchors[designation] = src

/obj/machinery/dive_anchor/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/obj/machinery/dive_anchor/destination_anchor = GLOB.anchors[target_designation]
	if(!destination_anchor)
		audible_message(span_warning("Teleporation prevented: destination anchor unset or undetected!"))
		visible_message(span_warning("A red light blinks on the [src]."))
		return
	if(do_after(user, 3.5 SECONDS, src))
		perform_teleportation(destination_anchor.loc)

/obj/machinery/dive_anchor/proc/perform_teleportation(target_loc)
	if(!target_loc)
		return

	var/list/safe_landing_turfs = list()
	for(var/turf/open/possible_landing_turf in circle_range_turfs(target_loc, radius = 1))
		if(istype(possible_landing_turf, /turf/open/lava) || istype(possible_landing_turf, /turf/open/chasm))
			continue
		if(!(possible_landing_turf.is_blocked_turf(exclude_mobs = TRUE)))
			safe_landing_turfs += possible_landing_turf

	if(!safe_landing_turfs)
		audible_message(span_warning("Teleportation prevented: all disembarkation angles blocked!"))
		visible_message(span_warning("A red light blinks on the [src]."))
		return

	var/datum/effect_system/spark_spread/quantum/quantum_sparks = new

	for(var/atom/movable/teleportable in gather_teleportables_in_range())
		//pre-tp sparks
		quantum_sparks.set_up(rand(4, 8), FALSE, teleportable)
		quantum_sparks.attach(teleportable)
		quantum_sparks.start()
		//do the tp
		teleportable.forceMove(pick(safe_landing_turfs))
		//knock 'em down if we can, for vibes
		if(iscarbon(teleportable))
			var/mob/living/carbon/teleported_carbon = teleportable
			teleported_carbon.Knockdown(3 SECONDS)
		//post tp sparks
		quantum_sparks.start()

/obj/machinery/dive_anchor/proc/gather_teleportables_in_range()
	var/list/teleportables = list()

	for(var/turf/target_turf in circle_range_turfs(radius = 1))
		teleportables += target_turf.get_all_contents_type(/mob/living)

	return teleportables

/obj/machinery/dive_anchor/stationary
	designation = "Space Station 13"
	target_designation = "Ad Astra"
