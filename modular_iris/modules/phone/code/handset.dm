/obj/item/handset
	name = "telephone handset"
	desc = "A telephone handset connected to a base unit by a cord."
	icon = 'modular_iris/modules/phone/icons/phone.dmi'
	icon_state = "rpb_phone"
	w_class = WEIGHT_CLASS_BULKY

	/// The phone component this handset belongs to
	var/datum/component/phone/phone_component
	/// The phone base unit this handset is tethered to
	var/atom/holder

/obj/item/handset/Initialize(mapload, datum/component/phone/phone_comp, atom/phone_holder)
	. = ..()
	phone_component = phone_comp
	holder = phone_holder

	// Handset starts in nullspace, holder is optional during initialization

/// Returns handset to base when out of range
/obj/item/handset/proc/snap_back()
	if(!phone_component)
		return

	// Clean up signals first
	cleanup_signals()

	// Force return to base - just call the phone's return handler
	return_to_base()

/// Cleans up all handset references
/obj/item/handset/proc/cleanup_handset()
	lose_hearing_sensitivity()
	cleanup_signals()
	phone_component = null
	holder = null

/obj/item/handset/Destroy()
	cleanup_handset()
	return ..()

/// Returns the handset to the phone base (single point of return)
/obj/item/handset/proc/return_to_base()
	if(!phone_component)
		return FALSE

	// Clean up signals FIRST to prevent timing conflicts
	cleanup_signals()

	// Drop from user if held
	if(ismob(loc))
		var/mob/user = loc
		user.dropItemToGround(src, silent = TRUE)

	// Move back to nullspace where handsets live
	moveToNullspace()

	// Let the phone component handle the rest
	phone_component.on_handset_returned()

	return TRUE

/// Cleans up movement tracking signals
/obj/item/handset/proc/cleanup_signals()
	// The phone component handles all signal registration/unregistration
	// This is being kept for future extensibility

/obj/item/handset/attack_hand(mob/user)
	// Prevent pickup if out of range
	if(holder)
		var/distance = get_dist(src, holder)
		if(distance > HANDSET_RANGE)
			to_chat(user, span_warning("The handset is out of range of its base unit!"))
			return FALSE
	return ..()

/obj/item/handset/equipped(mob/user, slot)
	. = ..()
	if(!holder || !user || !phone_component)
		return

	// Clean up any existing signals first
	cleanup_signals()

	// Become hearing sensitive so we can receive Hear() calls
	become_hearing_sensitive()

/obj/item/handset/dropped(mob/user)
	. = ..()
	UnregisterSignal(holder, COMSIG_MOVABLE_MOVED)
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

	// Stop being hearing sensitive when not held
	lose_hearing_sensitivity()

	// Only snap back if we're not being picked up by another mob
	// If loc is a mob, we're being transferred to their hands
	if(!ismob(loc))
		if(user)
			to_chat(user, span_notice("The handset snaps back into the main unit."))
		snap_back()

/obj/item/handset/on_enter_storage(obj/item/storage/S)
	. = ..()
	snap_back()

/obj/item/handset/moveToNullspace()
	. = ..()


/obj/item/handset/Hear(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range)
	. = ..()
	if(!phone_component || QDELETED(phone_component) || !istype(speaker, /mob) || radio_freq)
		return

	var/mob/talker = speaker
	var/direct_talking = (talker == loc)  // Speech from holder

	if(direct_talking)
		// Send through phone system - this gets the properly formatted speech
		phone_component.handle_speak(raw_message, message_language, talker, spans, message_mods, TRUE)
	else
		// Apply distance muffling for nearby speakers
		var/distance = get_dist(src, talker)
		if(distance > 1)
			return
		var/muffled_message = stars(raw_message, (100 - (distance * 40 + rand(-15, 15))))
		phone_component.handle_speak(muffled_message, message_language, talker, spans, message_mods, FALSE)
