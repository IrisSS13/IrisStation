/obj/structure/anchor_assembly
	name = "dive anchor assembly"
	desc = "An unfinished dive anchor."
	icon = 'icons/obj/machines/satellite.dmi'
	icon_state = "sat_active"
	density = TRUE
	anchored = FALSE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	max_integrity = 400
	var/obj/machinery/dive_anchor/target_type = /obj/machinery/dive_anchor

/obj/structure/anchor_assembly/examine(mob/user)
	. = ..()
	. += span_notice("A <b>screwdriver</b> can be used to tweak the model.")
	. += span_notice("It can be finished using a <b>wrench</b>.")

/obj/structure/anchor_assembly/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(istype(target_type, /obj/machinery/dive_anchor))
		name = "stationary dive anchor assembly"
		desc = "An unfinished stationary dive anchor."
		icon_state = "sat_inactive"
		target_type = /obj/machinery/dive_anchor/stationary
		return ITEM_INTERACT_SUCCESS
	name = "dive anchor assembly"
	desc = "An unfinished dive anchor."
	icon_state = "sat_active"
	target_type = /obj/machinery/dive_anchor
	return ITEM_INTERACT_SUCCESS

/obj/structure/anchor_assembly/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	var/turf/current_turf = get_turf(loc)
	if(istype(target_type, /obj/machinery/dive_anchor/stationary) && istype(current_turf, /turf/open/space))
		to_chat(user, span_warning("[src] can only be finished on a solid surface."))
		return ITEM_INTERACT_BLOCKING
	if(istype(target_type, /obj/machinery/dive_anchor) && !istype(current_turf, /turf/open/space))
		to_chat(user, span_warning("[src] can only be finished in space."))
		return ITEM_INTERACT_BLOCKING
	new target_type(loc)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/datum/crafting_recipe/anchor_assembly
	name = "Dive Anchor Assembly"
	result = /obj/structure/anchor_assembly
	reqs = list(
		/obj/item/stack/sheet/mineral/plastitanium = 10,
		/obj/item/stack/cable_coil = 5,
		/obj/item/assembly/signaler/anomaly/bluespace = 1
	)
	time = 10 SECONDS
	category = CAT_STRUCTURE
	tool_behaviors = list(TOOL_WELDER)
