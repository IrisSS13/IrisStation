#define ADD_MINING_TRAIT(Path)\
##Path/Initialize(mapload){\
	. = ..();\
	ADD_TRAIT(src, TRAIT_MINING_ITEM, TRAIT_MINING_ITEM);\
}

/obj/machinery/outfit_changer
	name = "automatic civilian outfitter"
	desc = "A specialized gate capable of changing the clothing of miners into combative for lavaland and civilian for station-side"
	icon = 'icons/obj/machines/scangate.dmi'
	icon_state = "scangate"
	dir = NORTH
	layer = ABOVE_MOB_LAYER

	var/scanline_timer
	/// Visual-only effect placed in us, projected via vis_contents
	var/obj/effect/overlay/scanline = null

	var/active = TRUE
	/// Current people that are in our turf
	var/list/mob/living/carbon/detected_mobs = list()
	/// Associative list of all stored items, id_card = list(item_slot = item)
	/// the item_slot part is actually a number inside of a string, because otherwise we'd be checking the 512's position in a 0 len list
	var/list/stored_items = list()
	/// Associative list of ID's to directions, so if people are going twice in the same direction (teleports) we ignore them
	var/list/stored_states = list()

/obj/machinery/outfit_changer/Initialize(mapload)
	. = ..()
	set_scanline("passive")
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	AddElement(/datum/element/contextual_screentip_bare_hands, rmb_text = "Switch automatic activation")

/obj/machinery/outfit_changer/Destroy(force)
	QDEL_NULL(scanline)
	detected_mobs = null
	empty_contents()
	return ..()

/obj/machinery/outfit_changer/examine(mob/user)
	. = ..()
	. += span_notice("It can be right-clicked with an empty hand to get rid of all currently held objects.")
	. += span_notice("It can be tapped with an ID card to retrieve all objects stored in that ID's index.")
	. += span_notice("You can change if an object is considered for mining or not by tapping it against the gate.")

/obj/machinery/outfit_changer/proc/on_entered(datum/source, atom/movable/thing)
	SIGNAL_HANDLER
	if(!active)
		return

	if(ishuman(thing))
		detected_mobs += thing
		playsound(src, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
		set_scanline("scanning", 1 SECONDS)
		RegisterSignal(thing, COMSIG_QDELETING, PROC_REF(the_mob_just_destroyed_itself_in_an_inconvinient_place))

/obj/machinery/outfit_changer/proc/on_exited(datum/source, atom/movable/thing)
	SIGNAL_HANDLER
	if(thing in detected_mobs)
		detected_mobs -= thing
		UnregisterSignal(thing, COMSIG_QDELETING)
		INVOKE_ASYNC(src, PROC_REF(change_outfit), thing)

/obj/machinery/outfit_changer/proc/change_outfit(mob/living/carbon/human)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	if(!istype(human))
		return

	var/obj/item/card/id/id_card = human.get_idcard(hand_first = FALSE)
	if(!id_card)
		return

	if(stored_items[id_card])
		if(stored_states[id_card] == human.dir) // They teleported behind us, ignore them
			return
	else
/*
		if(human.dir != dir) // Don't setup our code if the person is walking the wrong way
			return
*/
		stored_items[id_card] = list()
		RegisterSignal(id_card, COMSIG_QDELETING, PROC_REF(id_deleted))

	stored_states[id_card] = human.dir
	if(dir == human.dir) // They are going out to lavaland
		var/list/item_slots = stored_items[id_card]
		var/datum/component/toggle_attached_clothing/hood_component = null // We store any hood component we see into here, to deploy it correctly
		for(var/item_slot as anything in item_slots)
			var/obj/item/item = item_slots[item_slot]
			if(isnull(item) || !HAS_TRAIT(item, TRAIT_MINING_ITEM))
				continue

			UnregisterSignal(item, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
			item_slots[item_slot] = null
			var/obj/possible_obstruction = human.get_item_by_slot(text2num(item_slot))
			if(possible_obstruction)
				store_item(possible_obstruction, item_slot, human, id_card)

			var/success = human.equip_to_slot_if_possible(item, text2num(item_slot), disable_warning = TRUE)
			if(success)
				if(isnull(hood_component) && (item.slot_flags & ITEM_SLOT_OCLOTHING))
					var/datum/component/toggle_attached_clothing/hooded_clothes = item.GetComponent(/datum/component/toggle_attached_clothing)
					if(!isnull(hooded_clothes))
						hood_component = hooded_clothes
				continue

			else
				item.forceMove(get_turf(human))

		if(!isnull(hood_component))
			hood_component.toggle_deployable()

	else
		var/datum/component/toggle_attached_clothing/hood_component = null
		for(var/obj/item/scanned_item in human.get_all_contents())
			if(!HAS_TRAIT(scanned_item, TRAIT_MINING_ITEM))
				continue

			var/list/item_slots = stored_items[id_card]
			var/item_slot = human.get_slot_by_item(scanned_item)
			var/obj/possible_item = item_slots[num2text(item_slot)]
			store_item(scanned_item, num2text(item_slot), human, id_card)
			if(!isnull(possible_item))
				UnregisterSignal(possible_item, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
				var/success = human.equip_to_slot_if_possible(possible_item, item_slot, disable_warning = TRUE)
				if(success)
					if(isnull(hood_component) && (scanned_item.slot_flags & ITEM_SLOT_OCLOTHING))
						var/datum/component/toggle_attached_clothing/hooded_clothes = scanned_item.GetComponent(/datum/component/toggle_attached_clothing)
						if(!isnull(hooded_clothes))
							hood_component = hooded_clothes
				else
					possible_item.forceMove(get_turf(human))

		if(!isnull(hood_component))
			hood_component.toggle_deployable()

	use_energy(active_power_usage)

/obj/machinery/outfit_changer/proc/store_item(obj/item/item, item_slot, mob/living/carbon/human, obj/item/card/id/id_card)
	var/list/item_slots = stored_items[id_card]
	item_slots[item_slot] = item
	human.dropItemToGround(item)
	item.forceMove(src)
	RegisterSignals(item, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(item_escaped))
	if(item.slot_flags & ITEM_SLOT_OCLOTHING)
		var/datum/component/toggle_attached_clothing/hooded_clothing_component = item.GetComponent(/datum/component/toggle_attached_clothing)
		if(!isnull(hooded_clothing_component) && hooded_clothing_component.currently_deployed)
			hooded_clothing_component.remove_deployable()

/obj/machinery/outfit_changer/proc/empty_contents()
	for(var/obj/id_card as anything in stored_items)
		empty_id_contents(id_card)

	stored_items = list()
	stored_states = list()

/obj/machinery/outfit_changer/proc/empty_id_contents(obj/item/card/id/id_card)
	var/turf/output_turf = get_step(get_turf(src), dir)
	var/list/item_slots = stored_items[id_card]
	for(var/item_slot as anything in item_slots)
		var/obj/item = item_slots[item_slot]
		if(isnull(item))
			continue

		UnregisterSignal(item, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
		item.forceMove(output_turf)

	stored_items -= id_card
	stored_states -= id_card

/obj/machinery/outfit_changer/proc/set_scanline(scanline_type, duration)
	if (!isnull(scanline))
		vis_contents -= scanline
	else
		scanline = new(src)
		scanline.icon = icon
		scanline.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		scanline.layer = layer
	if(isnull(scanline_type))
		if(duration)
			scanline_timer = addtimer(CALLBACK(src, PROC_REF(set_scanline), "passive"), duration, TIMER_STOPPABLE)
		return
	scanline.icon_state = scanline_type
	vis_contents += scanline
	if(duration)
		scanline_timer = addtimer(CALLBACK(src, PROC_REF(set_scanline), "passive"), duration, TIMER_STOPPABLE)

/obj/machinery/outfit_changer/power_change()
	. = ..()
	if(machine_stat & (NOPOWER | BROKEN))
		say("Insufficient power detected to run, releasing the object compartment")
		empty_contents()
		set_scanline(null)
		return
	set_scanline("passive")

/obj/machinery/outfit_changer/attackby(obj/item/attacking_item, mob/user, params)
	var/obj/item/card/id/id_card = attacking_item.GetID()
	if(id_card)
		say("Emptying stored contents of [id_card]")
		empty_id_contents(id_card)
		return TRUE
	else
		var/list/forbidden_pieces = list(
			/obj/item/clothing/head/mod,
			/obj/item/clothing/suit/mod,
			/obj/item/clothing/gloves/mod,
			/obj/item/clothing/shoes/mod,
		)
		if(is_type_in_list(attacking_item, forbidden_pieces))
			say("Error: unable to mark object for automatic filtering")
			return ..()

		if(HAS_TRAIT(attacking_item, TRAIT_MINING_ITEM))
			REMOVE_TRAIT(attacking_item, TRAIT_MINING_ITEM, TRAIT_MINING_ITEM)
			say("[attacking_item] removed from automatic filtering.")
		else
			ADD_TRAIT(attacking_item, TRAIT_MINING_ITEM, TRAIT_MINING_ITEM)
			say("[attacking_item] registered for automatic filtering.")
	return ..()

/obj/machinery/outfit_changer/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	active = !active
	if(active)
		say("automatic outfitting systems enabled successfully!")
	else
		say("automatic outfitting systems have been disabled, opening the object compartment...")
		empty_contents()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/outfit_changer/proc/the_mob_just_destroyed_itself_in_an_inconvinient_place(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_QDELETING)
	detected_mobs -= source

/obj/machinery/outfit_changer/proc/id_deleted(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_QDELETING)
	empty_id_contents(source)

/obj/machinery/outfit_changer/proc/item_escaped(datum/source) // Probably the worst thing here, we have no way to make it better
	SIGNAL_HANDLER
	UnregisterSignal(source, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	for(var/obj/id_card as anything in stored_items)
		var/list/item_slots = stored_items[id_card]
		for(var/item_slot as anything in item_slots)
			if(source == item_slots[item_slot])
				item_slots[item_slot] = null
				return

/// Below is a list of things that we should detect and switch by default
// Suits
ADD_MINING_TRAIT(/obj/item/clothing/suit/hooded/explorer)
ADD_MINING_TRAIT(/obj/item/clothing/suit/hooded/cloak/drake)
ADD_MINING_TRAIT(/obj/item/clothing/suit/hooded/hostile_environment)
ADD_MINING_TRAIT(/obj/item/clothing/suit/hooded/berserker/gatsu)

// Misc clothes
ADD_MINING_TRAIT(/obj/item/kheiral_cuffs)

// Weapons/Generic mining-only items
ADD_MINING_TRAIT(/obj/item/resonator)
ADD_MINING_TRAIT(/obj/item/gun/energy/plasmacutter)
ADD_MINING_TRAIT(/obj/item/gun/energy/recharge/kinetic_accelerator)
ADD_MINING_TRAIT(/obj/item/kinetic_crusher)
ADD_MINING_TRAIT(/obj/item/lava_staff)
