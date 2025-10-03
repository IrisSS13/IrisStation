/datum/quirk/equipping/nerve_staple
	name = "Nerve Stapled"
	desc = "You're a pacifist. Not because you want to be, but because of the device stapled into your eye."
	value = -10 // pacifism = -8, losing eye slots = -2
	gain_text = span_danger("You suddenly can't raise a hand to hurt others!")
	lose_text = span_notice("You think you can defend yourself again.")
	medical_record_text = "Patient is nerve stapled and is unable to harm others."
	icon = FA_ICON_FACE_ANGRY
	/// The nerve staple attached to the quirk
	var/obj/item/clothing/glasses/nerve_staple/staple

/datum/quirk/equipping/nerve_staple/add_unique(client/client_source)
	var/nerve_staple_type
	if(client_source?.prefs)
		var/choice = client_source.prefs.read_preference(/datum/preference/choiced/nerve_staple_choice)
		nerve_staple_type = GLOB.nerve_staple_choice[choice] || /obj/item/clothing/glasses/nerve_staple
	else
		nerve_staple_type = /obj/item/clothing/glasses/nerve_staple

	// Store the type for later use in post_equip
	staple = new nerve_staple_type(quirk_holder.loc)

	// Try to equip immediately, but don't worry if it fails - we'll try again in post_equip
	var/success = force_equip_item(quirk_holder, staple, ITEM_SLOT_EYES, check_item = FALSE)
	if(!success)
		qdel(staple)
		staple = null

/datum/quirk/equipping/nerve_staple/post_add()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(delayed_equip_staple)), 1 SECONDS)

/datum/quirk/equipping/nerve_staple/proc/delayed_equip_staple()
	if(QDELETED(staple) || quirk_holder.get_item_by_slot(ITEM_SLOT_EYES) != staple)
		if(QDELETED(staple))
			var/nerve_staple_type = /obj/item/clothing/glasses/nerve_staple
			if(quirk_holder.client?.prefs)
				var/choice = quirk_holder.client.prefs.read_preference(/datum/preference/choiced/nerve_staple_choice)
				nerve_staple_type = GLOB.nerve_staple_choice[choice] || /obj/item/clothing/glasses/nerve_staple

			staple = new nerve_staple_type(quirk_holder.loc)

		var/obj/item/old_glasses = quirk_holder.get_item_by_slot(ITEM_SLOT_EYES)
		if(old_glasses)
			quirk_holder.temporarilyRemoveItemFromInventory(old_glasses, force = TRUE)

			// So let's try to put it in the backpack first
			var/obj/item/storage/backpack/backpack = quirk_holder.get_item_by_slot(ITEM_SLOT_BACK)
			if(istype(backpack) && backpack.atom_storage?.can_insert(old_glasses, quirk_holder))
				backpack.atom_storage.attempt_insert(old_glasses, quirk_holder, messages = FALSE)
			else
				// If there's no backpack or it can't fit for some odd reason, let us try to put it in their hands
				var/obj/item/held = quirk_holder.get_active_held_item()
				if(!held && quirk_holder.put_in_hands(old_glasses))
					to_chat(quirk_holder, span_notice("You catch [old_glasses] in your hands."))
				else
					// Or, drop it at their feet I guess....
					old_glasses.forceMove(quirk_holder.drop_location())
					to_chat(quirk_holder, span_warning("Your [old_glasses] falls to the ground!"))


		if(quirk_holder.equip_to_slot_if_possible(staple, ITEM_SLOT_EYES, disable_warning = TRUE, bypass_equip_delay_self = TRUE))
			on_equip_item(staple, TRUE)
		else
			qdel(staple)
			staple = null

/datum/quirk/equipping/nerve_staple/on_equip_item(obj/item/equipped, successful)
	if (!istype(equipped, /obj/item/clothing/glasses/nerve_staple))
		return
	staple = equipped
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(istype(human_holder) && human_holder.glasses != staple)
		human_holder.equip_to_slot_if_possible(staple, ITEM_SLOT_EYES, disable_warning = TRUE, bypass_equip_delay_self = TRUE)

/datum/quirk/equipping/nerve_staple/remove()
	. = ..()
	if(!staple || quirk_holder.get_item_by_slot(ITEM_SLOT_EYES) != staple)
		return
	to_chat(quirk_holder, span_warning("The nerve staple suddenly falls off your face and melts[istype(quirk_holder.loc, /turf/open/floor) ? " on the floor" : ""]!"))
	qdel(staple)
	staple = null

// IRIS EDIT - adds a way to choose where the nerve staple goes

/datum/quirk_constant_data/nerve_staple
	associated_typepath = /datum/quirk/equipping/nerve_staple
	customization_options = list(/datum/preference/choiced/nerve_staple_choice)

/datum/preference/choiced/nerve_staple_choice
	savefile_key = "nerve_staple_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED

/datum/preference/choiced/nerve_staple_choice/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return "Nerve Stapled" in preferences.all_quirks

/datum/preference/choiced/nerve_staple_choice/init_possible_values()
	var/list/values = list("Right Eye", "Left Eye")
	return values

/datum/preference/choiced/nerve_staple_choice/apply_to_human(mob/living/carbon/human/target, value)
	return

GLOBAL_LIST_INIT(nerve_staple_choice, list(
	"Left Eye" = /obj/item/clothing/glasses/nerve_staple,
	"Right Eye" = /obj/item/clothing/glasses/nerve_staple/right,
))
