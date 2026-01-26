/// Holds all of our phone components
GLOBAL_LIST_EMPTY_TYPED(phones, /datum/component/phone)

/datum/component/phone
	/// Our phone category which sorts us into tabs in the phone menu TGUI
	var/phone_category = "Uncategorised"
	/// The id of our phone which shows up when we talk. Recommended to make unique. Do not include "(#:".
	var/phone_id = "Telephone"
	/// Our phone icon that is displayed in the phone menu TGUI
	var/phone_icon
	/// What actually holds our phone, defaults to parent but may be set differently
	var/atom/holder

	/// Our connected handset
	var/obj/item/handset/phone_handset
	/// The looping ringing sound when the phone is called
	var/datum/looping_sound/phone_ringing/ringing_loop

	/// Current call state using PHONE_STATE_* defines
	var/call_state = PHONE_STATE_IDLE
	/// A phone we are calling or has called us
	var/datum/component/phone/calling_phone
	/// The Phone_ID of the last person to call this telephone
	var/last_caller
	/// The user who is currently in a call with this phone (needed for notifications even if they drop handset)
	var/mob/call_user
	/// The ID of our timer to cancel an attempted call and "go to voicemail"
	var/timeout_timer_id
	/// The time it takes for our timer to end to cancel an attempted call and "go to voicemail"
	var/timeout_duration = 30 SECONDS

	/// Whether or not the phone is receiving calls or not. Varies between on/off or forcibly on/off.
	var/do_not_disturb = PHONE_DND_OFF
	/// Whether the phone is able to be called or not
	var/enabled = TRUE
	/// If the phone is activated by COMSIG_PHONE_BUTTON_USE or not. And if true Will only allow COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND if receiving a call.
	var/overlay_interactable = FALSE

	/// Networks that this phone can take calls from
	var/list/networks_receive = list()
	/// Networks that this phone can call
	var/list/networks_transmit = list()

	/// Call log with text entries (like fax machines)
	var/list/call_log = list()
	/// Current user holding the handset (for proper signal cleanup)
	var/mob/current_handset_user

	/// List of PDAs linked to this phone for call notifications
	var/list/linked_pdas = list()

/datum/component/phone/Initialize(phone_category, phone_id, phone_icon, do_not_disturb, list/networks_receive, list/networks_transmit, holder, overlay_interactable)
	. = ..()
	if(!istype(parent, /atom))
		return COMPONENT_INCOMPATIBLE

	if(!setup_phone_properties(arglist(args)))
		return COMPONENT_INCOMPATIBLE

	if(!setup_phone_hardware())
		return COMPONENT_INCOMPATIBLE

	if(!setup_phone_networking())
		return COMPONENT_INCOMPATIBLE

	register_phone_signals()
	GLOB.phones += src

/datum/component/phone/Destroy()
	cleanup_phone_hardware()
	cleanup_phone_networking()
	cleanup_phone_timers()
	unlink_all_pdas()

	GLOB.phones -= src
	SStgui.close_uis(src)
	set_call_state(PHONE_STATE_IDLE)
	return ..()

/// Sets up all phone properties from initialization arguments
/datum/component/phone/proc/setup_phone_properties(phone_category, phone_id, phone_icon, do_not_disturb, list/networks_receive, list/networks_transmit, holder, overlay_interactable)
	src.phone_category = phone_category || src.phone_category
	src.phone_id = phone_id || src.phone_id
	src.phone_icon = phone_icon || src.phone_icon
	src.do_not_disturb = isnull(do_not_disturb) ? src.do_not_disturb : do_not_disturb
	src.networks_receive = networks_receive ? networks_receive.Copy() : src.networks_receive
	src.networks_transmit = networks_transmit ? networks_transmit.Copy() : src.networks_transmit
	src.holder = holder || parent
	src.overlay_interactable = isnull(overlay_interactable) ? src.overlay_interactable : overlay_interactable

	// Ensure unique phone ID
	src.phone_id = generate_unique_phone_id(src.phone_id)
	return TRUE

/// Sets up phone hardware components (handset, audio)
/datum/component/phone/proc/setup_phone_hardware()
	if(!holder)
		stack_trace("Phone component setup_phone_hardware called without valid holder!")
		return FALSE

	phone_handset = new(null, src, src.holder)
	if(!phone_handset)
		stack_trace("Failed to create handset for phone component!")
		return FALSE

	RegisterSignal(phone_handset, COMSIG_QDELETING, PROC_REF(on_handset_deleted))
	ringing_loop = new(src.holder)

	// Disable phone if holder is an item (portable phones start disabled)
	if(istype(src.holder, /obj/item))
		enabled = FALSE

	return TRUE

/// Sets up networking capabilities
/datum/component/phone/proc/setup_phone_networking()
	// Validate and set default networks
	if(!networks_receive || !length(networks_receive))
		networks_receive = list("Station")
	if(!networks_transmit || !length(networks_transmit))
		networks_transmit = list("Station")

	// Ensure networks are proper lists
	if(!islist(networks_receive))
		networks_receive = list("Station")
	if(!islist(networks_transmit))
		networks_transmit = list("Station")

	return TRUE

/// Registers all necessary signals for phone operation
/datum/component/phone/proc/register_phone_signals()
	RegisterSignal(src.holder, COMSIG_ATOM_ATTACKBY, PROC_REF(on_holder_attackby))
	RegisterSignal(src.holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))

	if(!src.overlay_interactable)
		RegisterSignal(src.holder, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_holder_clicked))
	else
		RegisterSignal(src.holder, COMSIG_ATOM_PHONE_BUTTON_USE, PROC_REF(on_holder_clicked))

	if(istype(src.holder, /obj/item))
		RegisterSignal(src.holder, COMSIG_ITEM_PICKUP, PROC_REF(on_holder_picked_up))
		RegisterSignal(src.holder, COMSIG_ITEM_DROPPED, PROC_REF(on_holder_dropped))

/// Cleans up phone hardware on destruction
/datum/component/phone/proc/cleanup_phone_hardware()
	if(phone_handset)
		UnregisterSignal(phone_handset, COMSIG_QDELETING)
		phone_handset.cleanup_handset()
		if(!phone_handset.loc) // Only force delete if in nullspace
			qdel(phone_handset)
		phone_handset = null

	QDEL_NULL(ringing_loop)

/// Cleans up networking lists
/datum/component/phone/proc/cleanup_phone_networking()
	networks_receive = null
	networks_transmit = null

/// Cleans up any active timers
/datum/component/phone/proc/cleanup_phone_timers()
	if(timeout_timer_id)
		deltimer(timeout_timer_id)
		timeout_timer_id = null

/// Sets the current call state and handles state transitions
/datum/component/phone/proc/set_call_state(new_state)
	if(call_state == new_state)
		return

	var/old_state = call_state
	call_state = new_state

	// Handle state transition effects
	switch(new_state)
		if(PHONE_STATE_IDLE)
			cleanup_phone_timers()
			if(calling_phone && old_state != PHONE_STATE_IDLE)
				calling_phone.set_call_state(PHONE_STATE_IDLE)
			calling_phone = null
			stop_ringing()
			unregister_overlay_interaction()

		if(PHONE_STATE_DIALING)
			start_call_timeout()

		if(PHONE_STATE_RINGING)
			start_ringing()
			register_overlay_interaction()

		if(PHONE_STATE_CONNECTED)
			stop_ringing()
			cleanup_phone_timers()

	// Notify all registered listeners of the state change
	SEND_SIGNAL(src, COMSIG_GLOB_PHONE_STATE_CHANGED, new_state)

/// Starts the call timeout timer
/datum/component/phone/proc/start_call_timeout()
	cleanup_phone_timers()
	timeout_timer_id = addtimer(CALLBACK(src, PROC_REF(on_call_timeout)), timeout_duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)

/// Called when a call times out
/datum/component/phone/proc/on_call_timeout()
	timeout_timer_id = null
	handle_call_end(timeout = TRUE)

/// Starts ringing sound and effects
/datum/component/phone/proc/start_ringing()
	ringing_loop?.start()
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_RINGING)
	notify_linked_pdas_ringing()

/// Stops ringing sound and effects
/datum/component/phone/proc/stop_ringing()
	ringing_loop?.stop()
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_STOPPED_RINGING)

/// Notifies all linked PDAs of an incoming call
/datum/component/phone/proc/notify_linked_pdas_ringing()
	for(var/datum/computer_file/program/phone_monitor/pda_program as anything in linked_pdas)
		if(!QDELETED(pda_program))
			SEND_SIGNAL(pda_program, COMSIG_PHONE_LINKED_CALL_INCOMING, src)

/// Links a PDA program to this phone (replaces old link if exists)
/datum/component/phone/proc/link_pda(datum/computer_file/program/phone_monitor/pda_program)
	if(!pda_program || QDELETED(pda_program))
		return FALSE

	linked_pdas = list(pda_program)
	return TRUE

/// Unlinks a specific PDA program from this phone
/datum/component/phone/proc/unlink_pda(datum/computer_file/program/phone_monitor/pda_program)
	if(!pda_program)
		return FALSE

	linked_pdas -= pda_program
	return TRUE

/// Unlinks all PDAs from this phone
/datum/component/phone/proc/unlink_all_pdas()
	for(var/datum/computer_file/program/phone_monitor/pda_program as anything in linked_pdas)
		if(!QDELETED(pda_program))
			SEND_SIGNAL(pda_program, COMSIG_PHONE_LINKED_UNLINKED, src)
	linked_pdas = list()

/// Registers overlay interaction for ringing phones
/datum/component/phone/proc/register_overlay_interaction()
	if(src.overlay_interactable)
		RegisterSignal(src.holder, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_holder_clicked))

/// Unregisters overlay interaction
/datum/component/phone/proc/unregister_overlay_interaction()
	if(src.overlay_interactable)
		UnregisterSignal(src.holder, COMSIG_ATOM_ATTACK_HAND)

/// Handles when handset is deleted unexpectedly
/datum/component/phone/proc/on_handset_deleted()
	SIGNAL_HANDLER
	recall_handset()

/// Handles items being used on the phone holder
/datum/component/phone/proc/on_holder_attackby(atom/phone, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER
	if(attacking_item == phone_handset)
		recall_handset()

/// Handles clicking on the phone holder
/datum/component/phone/proc/on_holder_clicked(atom/phone, mob/living/carbon/human/user, click_parameters)
	SIGNAL_HANDLER

	// Check if user is holding our handset
	if(user.is_holding(phone_handset))
		// If they're clicking WITH the handset (not empty hand), return it
		if(user.get_active_held_item() == phone_handset)
			recall_handset()
			to_chat(user, span_notice("You hang up the handset."))
			return
		// If they're holding handset but clicking with empty hand, open UI
		else if(!user.get_active_held_item())
			INVOKE_ASYNC(src, PROC_REF(ui_interact), user)
			return

	if(call_state == PHONE_STATE_RINGING)
		answer_incoming_call(user)
	else if(call_state == PHONE_STATE_IDLE && enabled)
		// Clean up any existing user signals first
		if(current_handset_user)
			UnregisterSignal(current_handset_user, COMSIG_MOVABLE_MOVED)
		// Give handset to user when opening UI
		playsound(get_turf(user), get_sfx(SFX_PHONE_RTB_HANDSET), 50)
		user.put_in_active_hand(phone_handset)
		SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_PICKED_UP)
		// Track current user and register for movement
		current_handset_user = user
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_handset_user_moved))
		INVOKE_ASYNC(src, PROC_REF(ui_interact), user)

/// Handles when holder is picked up (for portable phones)
/datum/component/phone/proc/on_holder_picked_up(obj/item/picked_up_holder, mob/user)
	SIGNAL_HANDLER
	enabled = TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		phone_id = "[human_user]"
	else
		phone_id = "[user]"

/// Handles when holder is dropped (for portable phones)
/datum/component/phone/proc/on_holder_dropped(obj/item/dropped_holder, mob/user)
	SIGNAL_HANDLER
	enabled = FALSE
	phone_id = "[holder]"

/// Handles when holder is moved
/datum/component/phone/proc/on_holder_moved(atom/movable/moving_atom, atom/destination)
	SIGNAL_HANDLER
	// Holder moved, handset will handle its own tether updates

/// Handles when user moves - update UI status
/datum/component/phone/proc/on_user_moved(mob/user, atom/old_loc, movement_dir)
	SIGNAL_HANDLER
	// Force UI status recheck when user moves
	SStgui.update_user_uis(user, src)

/// Handles when handset user moves - check if they're out of range
/datum/component/phone/proc/on_handset_user_moved(mob/user, atom/old_loc, movement_dir)
	SIGNAL_HANDLER
	// Check if user is still holding the handset and is out of range
	if(!user.is_holding(phone_handset))
		// User no longer has handset, stop tracking
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		current_handset_user = null
		return

	// Check distance from phone base
	var/distance = get_dist(user, holder)
	if(distance > HANDSET_RANGE) // Use handset range limit
		// Out of range, return handset
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		current_handset_user = null
		recall_handset()
		to_chat(user, span_warning("The handset's cord pulls tight and snaps back to the phone base!"))

/// Adds an entry to the call log with timestamp
/datum/component/phone/proc/add_call_log_entry(entry_text)
	if(!call_log)
		call_log = list()

	call_log.Insert(1, "[station_time_timestamp()] - [entry_text]")

	// Keep log size reasonable for performance
	if(length(call_log) > 15) // Reduced from 20 to 15 for better performance
		call_log.Cut(16)

/// Initiates a call to another phone
/datum/component/phone/proc/initiate_call(mob/user, target_phone_id)
	if(call_state != PHONE_STATE_IDLE)
		to_chat(user, span_warning("Phone is already in use."))
		return FALSE

	var/datum/component/phone/target_phone = find_phone_by_id(target_phone_id)
	if(!target_phone)
		to_chat(user, span_purple("[icon2html(holder, user)] No phone could be located with that ID!"))
		return FALSE

	if(!can_call_phone(target_phone))
		to_chat(user, span_warning("Unable to connect to that phone."))
		return FALSE

	// Check if target phone is genuinely busy (no one can call busy phones)
	if(target_phone.call_state != PHONE_STATE_IDLE || !target_phone.phone_handset || !target_phone.enabled || target_phone.phone_handset.loc)
		to_chat(user, span_warning("[target_phone_id] is currently unavailable."))
		return FALSE

	// Captain's Phone can call DND phones, others cannot
	var/is_captain_phone = (phone_id == "Captain's Telephone")
	if(!is_captain_phone && (target_phone.do_not_disturb == PHONE_DND_ON || target_phone.do_not_disturb == PHONE_DND_FORCED))
		to_chat(user, span_warning("[target_phone_id] is currently unavailable."))
		return FALSE

	// Start the call
	calling_phone = target_phone
	set_call_state(PHONE_STATE_DIALING)
	target_phone.receive_incoming_call(src)

	// Add to call log
	add_call_log_entry("Outgoing to [target_phone_id]")

	// Provide feedback (handset already picked up when UI opened)
	to_chat(user, span_purple("[icon2html(holder, user)] Dialing [target_phone_id].."))

	return TRUE

/// Handles receiving an incoming call
/datum/component/phone/proc/receive_incoming_call(datum/component/phone/incoming_phone)
	// First check if phone is genuinely busy - NO ONE can call busy phones
	if(call_state != PHONE_STATE_IDLE || !phone_handset || !enabled || phone_handset.loc)
		return FALSE

	// Captain's Phone can override DND, others use normal restrictions
	var/caller_is_captain = (incoming_phone.phone_id == "Captain's Telephone")
	if(!caller_is_captain && (do_not_disturb == PHONE_DND_ON || do_not_disturb == PHONE_DND_FORCED))
		return FALSE

	calling_phone = incoming_phone
	last_caller = incoming_phone.phone_id
	set_call_state(PHONE_STATE_RINGING)

	// Add to call log
	add_call_log_entry("Incoming from [incoming_phone.phone_id]")

	return TRUE

/// Answers an incoming call
/datum/component/phone/proc/answer_incoming_call(mob/user)
	if(call_state != PHONE_STATE_RINGING || !phone_handset || phone_handset.loc)
		return FALSE

	// Answer the call
	call_user = user
	set_call_state(PHONE_STATE_CONNECTED)
	calling_phone?.on_call_answered()

	// Give handset to user and provide feedback
	playsound(get_turf(user), get_sfx(SFX_PHONE_RTB_HANDSET), 50)
	user.put_in_active_hand(phone_handset)
	to_chat(user, span_purple("[icon2html(holder, user)] Picked up a call from [calling_phone.phone_id]."))
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_PICKED_UP)

	// Clean up any existing user signals first
	if(current_handset_user)
		UnregisterSignal(current_handset_user, COMSIG_MOVABLE_MOVED)

	// Track current user and register for movement
	current_handset_user = user
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_handset_user_moved))

	return TRUE

/// Called when the other party answers our call
/datum/component/phone/proc/on_call_answered()
	if(call_state != PHONE_STATE_DIALING)
		return

	set_call_state(PHONE_STATE_CONNECTED)

	if(ismob(phone_handset?.loc))
		var/mob/user = phone_handset.loc
		call_user = user
		to_chat(user, span_purple("[icon2html(calling_phone.holder, user)] [calling_phone.phone_id] has picked up."))

/// Ends the current call
/datum/component/phone/proc/handle_call_end(timeout = FALSE, recursed = FALSE)
	if(call_state == PHONE_STATE_IDLE)
		return

	var/old_calling_phone = calling_phone
	var/old_state = call_state

	// Make recursive call BEFORE setting to IDLE
	if(!recursed && old_calling_phone)
		var/datum/component/phone/calling_phone_cast = old_calling_phone
		calling_phone_cast.handle_call_end(timeout, recursed = TRUE)

	// Set to idle after notifying other side
	set_call_state(PHONE_STATE_IDLE)

	// Send feedback to user
	send_call_end_message(old_calling_phone, old_state, timeout, recursed)

	// Play call end sound only if the other side ended the call and it was connected
	if(recursed && old_state == PHONE_STATE_CONNECTED)
		var/sound_location
		// Prefer handset location if someone is holding it
		if(phone_handset && ismob(phone_handset.loc))
			sound_location = phone_handset.loc
		// Fall back to holder (phone base) if available
		else if(holder)
			sound_location = holder

		if(sound_location)
			playsound(sound_location, 'modular_iris/modules/phone/sound/phone_busy_shorter.ogg', 50)

	// Clear call user after message is sent
	call_user = null

/// Sends appropriate message when call ends
/datum/component/phone/proc/send_call_end_message(datum/component/phone/other_phone, old_state, timeout, recursed)
	// Only send messages for calls that actually connected
	if(old_state != PHONE_STATE_CONNECTED)
		return

	var/mob/user = null

	// Find who to notify
	if(phone_handset && ismob(phone_handset.loc))
		user = phone_handset.loc
	else if(call_user)
		user = call_user

	if(!user)
		return

	var/message
	if(recursed)
		message = "[icon2html(holder, user)] [other_phone.phone_id] has hung up on you."
	else if(timeout)
		message = "[icon2html(holder, user)] Your call to [other_phone.phone_id] has reached voicemail, you immediately disconnect the line."
	else
		message = "[icon2html(holder, user)] You have hung up on [other_phone.phone_id]."

	to_chat(user, span_purple(message))

/// Recalls the handset to the holder (forced recall) - Legacy method
/datum/component/phone/proc/recall_handset()
	if(!phone_handset)
		return

	if(ismob(phone_handset.loc))
		var/mob/user = phone_handset.loc
		// Clean up movement tracking
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		user.dropItemToGround(phone_handset, silent = TRUE)
		playsound(get_turf(user), get_sfx(SFX_PHONE_RTB_HANDSET), 50, FALSE)

	// Clear tracked user
	current_handset_user = null
	phone_handset.moveToNullspace()
	handle_call_end()
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_HUNG_UP)

/// Handles handset being returned via the simplified return system
/datum/component/phone/proc/on_handset_returned()
	if(!phone_handset)
		return

	// Clear tracked user
	if(current_handset_user)
		UnregisterSignal(current_handset_user, COMSIG_MOVABLE_MOVED)
		current_handset_user = null

	// Play return sound
	var/turf/sound_location = get_turf(holder)
	if(sound_location)
		playsound(sound_location, get_sfx(SFX_PHONE_RTB_HANDSET), 50, FALSE)

	// End any active call and update state
	handle_call_end()
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_HUNG_UP)

/// Finds a phone by its ID (with fuzzy suffix matching)
/datum/component/phone/proc/find_phone_by_id(phone_id)
	var/list/available_phones = get_available_phones()

	// First try exact match
	var/result = available_phones[phone_id]
	if(result)
		return result

	// If no exact match, try suffix matching (for hidden character prefixes)
	for(var/stored_id in available_phones)
		// Check if our search term matches the end of the stored ID
		if(length(stored_id) >= length(phone_id))
			var/suffix = copytext(stored_id, -length(phone_id))
			if(suffix == phone_id)
				return available_phones[stored_id]

	return null

/// Gets all phones that we can call from our phone
/datum/component/phone/proc/get_available_phones()
	var/list/phone_list = list()
	var/is_captain_phone = (phone_id == "Captain's Telephone")

	for(var/datum/component/phone/target_phone as anything in GLOB.phones)
		// Skip self
		if(target_phone == src)
			continue

		// Skip phones that are truly offline/broken
		if(!target_phone.phone_handset || !target_phone.enabled)
			continue

		// Captain's Phone can see DND phones, others cannot
		if(!is_captain_phone && (target_phone.do_not_disturb == PHONE_DND_ON || target_phone.do_not_disturb == PHONE_DND_FORCED))
			continue

		// Check network compatibility
		if(!can_call_phone(target_phone))
			continue

		// Add phone to available list (even if busy - status will show in UI)
		phone_list[target_phone.phone_id] = target_phone

	return phone_list

/// Checks if we can call a specific phone (network compatibility)
/datum/component/phone/proc/can_call_phone(datum/component/phone/target_phone)
	if(!target_phone || QDELETED(target_phone))
		return FALSE

	for(var/network in networks_transmit)
		if(network in target_phone.networks_receive)
			return TRUE
	return FALSE

/// Checks if this phone can receive calls
/datum/component/phone/proc/can_receive_calls()
	if(call_state != PHONE_STATE_IDLE)
		return FALSE
	if(!phone_handset || !enabled)
		return FALSE
	if(phone_handset.loc) // Handset is already picked up
		return FALSE
	if(do_not_disturb == PHONE_DND_ON || do_not_disturb == PHONE_DND_FORCED)
		return FALSE
	return TRUE

/// Checks if the phone menu can be used
/datum/component/phone/proc/can_use_phone_menu()
	if(call_state != PHONE_STATE_IDLE)
		return FALSE
	if(!phone_handset || !enabled)
		return FALSE
	if(phone_handset.loc) // Handset is already picked up
		return FALSE
	return TRUE

/// Generates a unique phone ID to avoid conflicts
/datum/component/phone/proc/generate_unique_phone_id(desired_id)
	var/id = desired_id
	var/suffix = 2
	var/found_duplicate = TRUE

	while(found_duplicate)
		found_duplicate = FALSE
		for(var/datum/component/phone/other_phone as anything in GLOB.phones)
			if(other_phone == src)
				continue
			if(other_phone.phone_id == id)
				// Create unique suffix
				var/base_id = desired_id
				if(findtext(desired_id, " (#"))
					base_id = copytext(desired_id, 1, findtext(desired_id, " (#"))
				id = "[base_id] (#[suffix])"
				suffix++
				found_duplicate = TRUE
				break

	return id

/// Toggles do not disturb mode
/datum/component/phone/proc/toggle_dnd(mob/user)
	switch(do_not_disturb)
		if(PHONE_DND_ON)
			do_not_disturb = PHONE_DND_OFF
			to_chat(user, span_notice("Do Not Disturb has been disabled. You can now receive calls."))
			return TRUE
		if(PHONE_DND_OFF)
			do_not_disturb = PHONE_DND_ON
			to_chat(user, span_warning("Do Not Disturb has been enabled. No calls will be received."))
			return TRUE
		else
			to_chat(user, span_warning("Do Not Disturb mode cannot be changed."))
			return FALSE

/// Handles speech from handset users
/datum/component/phone/proc/handle_speak(message, datum/language/message_language, mob/speaker, list/spans, list/message_mods = list(), direct_talking = TRUE)
	// Only intercept speech if we're in a connected call
	if(call_state != PHONE_STATE_CONNECTED || !calling_phone)
		return NONE // Allow normal speech to continue

	// Sign language users who are actively signing cannot use phone
	if(HAS_TRAIT(speaker, TRAIT_SIGN_LANG))
		to_chat(speaker, span_warning("You cannot use sign language over the phone. Toggle sign language off to speak normally."))
		return COMPONENT_CANNOT_SPEAK

	if(direct_talking)
		// Send to the other phone
		calling_phone.receive_message(message, message_language, speaker, spans, message_mods, direct_talking)

		// Don't return anything special - let normal speech continue

	return NONE // Allow normal speech for non-direct talking

/// Receives a message from the connected phone
/datum/component/phone/proc/receive_message(message, datum/language/message_language, mob/speaker, list/spans, list/message_mods = list(), direct_talking)
	if(!phone_handset || !ismob(phone_handset.loc))
		return

	var/mob/listener = phone_handset.loc

	// Ghosts should hear phones with this
	if(listener.stat == DEAD && listener.client && !(get_chat_toggles(listener.client) & CHAT_GHOSTEARS))
		return

	listener.Hear(speaker, message_language, span_purple("[message]"), null, null, null, null, message_mods, message_range = INFINITY)

/// Returns the current user of the phone (mob holding handset)
/datum/component/phone/proc/get_user()
	return ismob(phone_handset?.loc) ? phone_handset.loc : null

/datum/component/phone/ui_state(mob/user)
	return GLOB.physical_state

/datum/component/phone/ui_status(mob/user, datum/ui_state/state)
	if(!enabled || !phone_handset)
		return UI_CLOSE
	// Use the physical state to handle distance checking properly
	return GLOB.physical_state.can_use_topic(holder, user)

/datum/component/phone/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..() // Call parent

	switch(action)
		if("call_phone")
			if(call_state != PHONE_STATE_IDLE)
				return FALSE
			// Check if user is holding the handset
			if(!ui.user.is_holding(phone_handset))
				to_chat(ui.user, span_warning("You need to be holding the handset to make a call."))
				return FALSE
			var/phone_id_to_call = params["phone_id"]
			if(!phone_id_to_call)
				return FALSE
			initiate_call(ui.user, phone_id_to_call)
			return TRUE

		if("toggle_dnd")
			if(toggle_dnd(ui.user))
				return TRUE
			return FALSE

		if("hang_up")
			if(call_state != PHONE_STATE_IDLE)
				handle_call_end()
				to_chat(ui.user, span_notice("You hang up the call."))
				return TRUE
			else
				return FALSE

	return FALSE

/datum/component/phone/ui_data(mob/user)
	var/list/data = list()
	data["availability"] = do_not_disturb
	data["last_caller"] = last_caller
	data["call_state"] = call_state
	data["current_phone_id"] = phone_id
	data["current_phone_category"] = phone_category
	data["call_log"] = call_log
	data["virtual_phone"] = FALSE
	data["calling_phone_id"] = calling_phone?.phone_id
	data["being_called"] = (call_state == PHONE_STATE_RINGING)
	data["active_call"] = (call_state == PHONE_STATE_CONNECTED)

	// Get available phones once and use for both fields
	var/list/available_phones = get_available_phones()
	data["available_transmitters"] = available_phones

	// Build transmitters list for UI
	var/list/transmitters = list()
	for(var/target_phone_id in available_phones)
		var/datum/component/phone/other_phone = available_phones[target_phone_id]
		transmitters += list(list(
			"phone_id" = other_phone.phone_id,
			"phone_category" = other_phone.phone_category,
			"phone_icon" = other_phone.phone_icon
		))
	data["transmitters"] = transmitters

	// Generate phone statuses efficiently
	var/list/statuses = list()
	for(var/target_phone_id in available_phones)
		var/datum/component/phone/other_phone = available_phones[target_phone_id]
		statuses[other_phone.phone_id] = get_phone_status_string(other_phone)
	data["phone_statuses"] = statuses

	return data

/// Gets the status string for a phone for UI display
/datum/component/phone/proc/get_phone_status_string(datum/component/phone/other_phone)
	if(!other_phone || QDELETED(other_phone))
		return "offline"
	if(other_phone.call_state == PHONE_STATE_CONNECTED || other_phone.call_state == PHONE_STATE_DIALING)
		return "busy"
	if(other_phone.call_state == PHONE_STATE_RINGING)
		return "ringing"
	if(!other_phone.enabled)
		return "offline"
	if(other_phone.do_not_disturb == PHONE_DND_ON || other_phone.do_not_disturb == PHONE_DND_FORCED)
		return "dnd"
	if(other_phone.do_not_disturb == PHONE_DND_FORBIDDEN)
		return "dnd_forbidden"
	return "available"

/datum/component/phone/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PhoneMenu", phone_id)
		ui.open()
