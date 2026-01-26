/// Phone Monitor - PDA app to receive notifications from linked landline phones

/datum/computer_file/program/phone_monitor
	filename = "phone_monitor"
	filedesc = "Phone Monitor"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "text"
	extended_desc = "Links to a nearby landline telephone to receive incoming call notifications on your PDA."
	size = 5
	power_cell_use = NONE
	program_flags = PROGRAM_RUNS_WITHOUT_POWER | PROGRAM_CIRCUITS_RUN_WHEN_CLOSED
	can_run_on_flags = PROGRAM_PDA
	tgui_id = "PhoneMonitor"
	program_icon = "phone"
	alert_able = TRUE

	/// The phone component this PDA is linked to
	var/datum/component/phone/linked_phone = null
	/// The phone ID of the linked phone for tracking
	var/linked_phone_id = null

/datum/computer_file/program/phone_monitor/on_install()
	. = ..()
	RegisterSignal(src, COMSIG_PHONE_LINKED_CALL_INCOMING, PROC_REF(on_linked_phone_ringing))
	RegisterSignal(src, COMSIG_PHONE_LINKED_UNLINKED, PROC_REF(on_linked_phone_destroyed))

/datum/computer_file/program/phone_monitor/Destroy()
	if(linked_phone)
		linked_phone.unlink_pda(src)
		linked_phone = null
	return ..()

/// Handles when the linked phone receives an incoming call
/datum/computer_file/program/phone_monitor/proc/on_linked_phone_ringing(datum/source, datum/component/phone/ringing_phone)
	SIGNAL_HANDLER

	// Send notification to user in chat
	if(computer && computer.loc)
		var/turf/computer_turf = get_turf(computer.loc)
		if(computer_turf)
			computer_turf.visible_message(
				span_notice("[icon2html(computer, viewers(computer_turf))] [computer] displays an incoming call notification: [ringing_phone.phone_id] is calling!")
			)

	// Show alert on PDA
	if(!alert_silenced)
		alert_pending = TRUE
		computer?.update_appearance(UPDATE_ICON)

/// Handles when the linked phone is destroyed/deconstructed
/datum/computer_file/program/phone_monitor/proc/on_linked_phone_destroyed(datum/source, datum/component/phone/destroyed_phone)
	SIGNAL_HANDLER

	unlink_phone()
	alert_pending = TRUE
	computer?.update_appearance(UPDATE_ICON)

/// Links to a phone by its reference
/datum/computer_file/program/phone_monitor/proc/link_to_phone(datum/component/phone/phone_to_link)
	if(!phone_to_link || QDELETED(phone_to_link))
		return FALSE

	// Unlink from old phone if exists
	if(linked_phone && linked_phone != phone_to_link)
		linked_phone.unlink_pda(src)

	// Link to new phone
	linked_phone = phone_to_link
	linked_phone_id = phone_to_link.phone_id
	phone_to_link.link_pda(src)
	// Register for call state changes to detect when call is answered
	RegisterSignal(phone_to_link, COMSIG_GLOB_PHONE_STATE_CHANGED, PROC_REF(on_linked_phone_state_changed))

	return TRUE

/// Unlinks from the current phone
/datum/computer_file/program/phone_monitor/proc/unlink_phone()
	if(linked_phone)
		UnregisterSignal(linked_phone, COMSIG_GLOB_PHONE_STATE_CHANGED, PROC_REF(on_linked_phone_state_changed))
		linked_phone.unlink_pda(src)

	linked_phone = null
	linked_phone_id = null
	// Clear any active alert when unlinking
	alert_pending = FALSE
	computer?.update_appearance(UPDATE_ICON)

/// Handles when the linked phone's call state changes
/datum/computer_file/program/phone_monitor/proc/on_linked_phone_state_changed(datum/source, new_state)
	SIGNAL_HANDLER

	// Clear alert when call is answered or ends
	if(new_state == PHONE_STATE_CONNECTED || new_state == PHONE_STATE_IDLE)
		alert_pending = FALSE
		computer?.update_appearance(UPDATE_ICON)

/// Gets nearby phones that can be linked
/datum/computer_file/program/phone_monitor/proc/get_nearby_phones()
	if(!computer || !computer.loc)
		return list()

	var/list/phones_near = list()
	var/turf/my_turf = get_turf(computer.loc)

	if(!my_turf)
		return phones_near

	// Find all phones within 3 tiles
	for(var/datum/component/phone/phone as anything in GLOB.phones)
		if(!phone || QDELETED(phone))
			continue

		var/turf/phone_turf = get_turf(phone.holder)
		if(!phone_turf || phone_turf.z != my_turf.z)
			continue

		if(get_dist(my_turf, phone_turf) <= 3)
			phones_near[phone.phone_id] = phone

	return phones_near

/datum/computer_file/program/phone_monitor/ui_data(mob/user)
	var/list/data = list()

	data["linked_phone_id"] = linked_phone_id
	data["is_linked"] = !isnull(linked_phone) && !QDELETED(linked_phone)

	if(data["is_linked"])
		data["phone_category"] = linked_phone.phone_category
		data["phone_icon"] = linked_phone.phone_icon
		data["phone_call_state"] = linked_phone.call_state
		data["phone_do_not_disturb"] = linked_phone.do_not_disturb

	// Get nearby phones for linking
	var/list/nearby_phones = get_nearby_phones()
	var/list/phone_list = list()

	for(var/phone_id in nearby_phones)
		var/datum/component/phone/phone = nearby_phones[phone_id]
		phone_list += list(list(
			"phone_id" = phone.phone_id,
			"phone_category" = phone.phone_category,
			"phone_icon" = phone.phone_icon,
			"ref" = REF(phone)
		))

	data["nearby_phones"] = phone_list

	return data

/datum/computer_file/program/phone_monitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("link_phone")
			var/phone_ref = params["phone_ref"]
			if(!phone_ref)
				return FALSE

			var/datum/component/phone/phone_to_link = locate(phone_ref)
			if(!phone_to_link || QDELETED(phone_to_link))
				return FALSE

			if(link_to_phone(phone_to_link))
				to_chat(ui.user, span_notice("Phone monitor linked to [phone_to_link.phone_id]."))
				return TRUE

			return FALSE

		if("unlink_phone")
			if(!linked_phone)
				return FALSE

			unlink_phone()
			to_chat(ui.user, span_notice("Phone monitor unlinked."))
			return TRUE

		if("clear_alert")
			alert_pending = FALSE
			computer?.update_appearance(UPDATE_ICON)
			return TRUE

	return FALSE

/datum/computer_file/program/phone_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PhoneMonitor", "Phone Monitor")
		ui.open()
