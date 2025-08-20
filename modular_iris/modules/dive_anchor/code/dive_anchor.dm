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

/obj/machinery/dive_anchor/examine(mob/user)
	. = ..()
	. += span_notice("Its designation is <b>[designation]</b>.")
	if(target_designation)
		. += span_notice("The designation of its target anchor is <b>[target_designation]</b>.")

/obj/machinery/dive_anchor/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/obj/machinery/dive_anchor/destination_anchor = GLOB.anchors[target_designation]
	if(!destination_anchor)
		audible_message(span_warning("Teleporation prevented: destination anchor unset or undetected!"))
		visible_message(span_warning("A red light blinks on the [src]."))
		return
	if(do_after(user, 3.5 SECONDS, src))
		perform_teleportation(destination_anchor.loc)

/obj/machinery/dive_anchor/multitool_act(mob/living/user, obj/item/tool)
	. = ..()
	var/obj/item/multitool/multitool = tool
	if(multitool.buffer && istype(multitool.buffer, /obj/machinery/dive_anchor))
		var/obj/machinery/dive_anchor/buffered_anchor = multitool.buffer
		target_designation = buffered_anchor.designation
		multitool.buffer = null
		balloon_alert(user, "destination anchor set, buffer cleared")
		return ITEM_INTERACT_SUCCESS
	multitool.set_buffer(src)
	balloon_alert(user, "anchor saved to multitool buffer")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/dive_anchor/multitool_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	var/new_designation = tgui_input_text(user, "Rename this anchor to:", "Input Designation", designation, 25)
	if(new_designation != designation)
		GLOB.anchors -= GLOB.anchors[designation]
		GLOB.anchors[new_designation] = src
		balloon_alert(user, "new designation set!")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/dive_anchor/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(target_designation && GLOB.anchors[target_designation])
		if(user)
			user.log_message("emagged [src].", LOG_ATTACK, color="red")
			balloon_alert(user, "system overloaded")
		playsound(src, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		var/obj/machinery/dive_anchor/target_anchor = GLOB.anchors[target_designation]
		//emagging one anchor zaps from the other
		target_anchor.supermatter_zap(power_level = 75 KILO WATTS)
		//and breaks the link between the two
		target_anchor.target_designation = null
		target_anchor.visible_message(span_warning("A red light blinks on the [target_anchor]."))
		target_designation = null
		visible_message(span_warning("A red light blinks on the [src]."))
		return TRUE
	if(user)
		balloon_alert(user, "system overload failed")
	return FALSE

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

	var/list/teleportables = list()
	for(var/turf/target_turf in circle_range_turfs(radius = 1))
		teleportables += target_turf.get_all_contents_type(/mob/living)

	for(var/atom/movable/teleportable in teleportables)
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

/obj/machinery/dive_anchor/stationary
	designation = "Space Station 13"
	target_designation = "Ad Astra"
