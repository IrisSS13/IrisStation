/obj/structure/phone_base
	name = "telephone receiver"
	icon = 'modular_iris/modules/phone/icons/phone.dmi'
	icon_state = "wall_phone"
	desc = "It is a wall mounted telephone. The fine text reads: To log your details with the mainframe please insert your keycard into the slot below. Unfortunately the slot is jammed. You can still use the phone, however. Landline phones work without power."
	resistance_flags = INDESTRUCTIBLE

	var/phone_category = "Station"
	var/phone_id = "Telephone"
	var/phone_icon

	/// Whether or not the phone is receiving calls or not. Varies between on/off or forcibly on/off.
	var/do_not_disturb = PHONE_DND_OFF

	var/list/networks_receive = list("Station")
	var/list/networks_transmit = list("Station")

/obj/structure/phone_base/Initialize(mapload, ...)
	. = ..()

	AddComponent(/datum/component/phone, phone_category, phone_id, phone_icon, do_not_disturb, networks_receive, networks_transmit)
	RegisterSignal(src, COMSIG_ATOM_PHONE_PICKED_UP, PROC_REF(phone_picked_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_HUNG_UP, PROC_REF(phone_hung_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_RINGING, PROC_REF(phone_ringing))
	RegisterSignal(src, COMSIG_ATOM_PHONE_STOPPED_RINGING, PROC_REF(phone_stopped_ringing))

/obj/structure/phone_base/Destroy()
	networks_receive = null
	networks_transmit = null
	return ..()

/obj/structure/phone_base/proc/phone_picked_up()
	icon_state = PHONE_OFF_BASE_UNIT_ICON_STATE

/obj/structure/phone_base/proc/phone_hung_up()
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

/obj/structure/phone_base/proc/phone_ringing()
	icon_state = PHONE_RINGING_ICON_STATE

/obj/structure/phone_base/proc/phone_stopped_ringing()
	if(icon_state == PHONE_OFF_BASE_UNIT_ICON_STATE)
		return
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

/obj/structure/phone_base/hidden
	do_not_disturb = PHONE_DND_FORCED

/obj/structure/phone_base/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

/// Head of Staff phones - slightly distinguished
/obj/structure/phone_base/head_of_staff
	phone_category = "Command"

/obj/structure/phone_base/head_of_staff/Initialize(mapload, ...)
	if(!phone_id || phone_id == "Telephone")
		phone_id = "Command Telephone"
	return ..()

/obj/structure/phone_base/head_of_staff/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

/// Captain's phone - command distinction
/obj/structure/phone_base/captain
	name = "captain's telephone"
	phone_id = "Captain's Telephone"
	phone_category = "Command"
	icon_state = "wall_phone"  // Use existing icon state
	do_not_disturb = PHONE_DND_FORBIDDEN

// Machinery base class for movable phones
/obj/machinery/phone_base
	name = "telephone"
	icon = 'modular_iris/modules/phone/icons/phone.dmi'
	desc = "A telephone that can be moved around and secured to the floor."
	use_power = NO_POWER_USE  // Landlines don't need power
	resistance_flags = UNACIDABLE
	circuit = /obj/item/circuitboard/machine/phone

	var/phone_category = "Station"
	var/phone_color = "white"
	var/phone_id = "Telephone"
	var/phone_icon

	/// Whether or not the phone is receiving calls or not. Varies between on/off or forcibly on/off.
	var/do_not_disturb = PHONE_DND_OFF

	var/network_connection = TRUE
	var/speaker_functional = TRUE

	var/list/networks_receive = list("Station")
	var/list/networks_transmit = list("Station")

/obj/machinery/phone_base/Initialize(mapload, ...)
	. = ..()

	AddComponent(/datum/component/phone, phone_category, phone_id, phone_icon, do_not_disturb, networks_receive, networks_transmit)
	RegisterSignal(src, COMSIG_ATOM_PHONE_PICKED_UP, PROC_REF(phone_picked_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_HUNG_UP, PROC_REF(phone_hung_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_RINGING, PROC_REF(phone_ringing))
	RegisterSignal(src, COMSIG_ATOM_PHONE_STOPPED_RINGING, PROC_REF(phone_stopped_ringing))

/obj/machinery/phone_base/Destroy()
	networks_receive = null
	networks_transmit = null
	return ..()

/obj/machinery/phone_base/proc/phone_picked_up()
	icon_state = PHONE_OFF_BASE_UNIT_ICON_STATE

/obj/machinery/phone_base/proc/phone_hung_up()
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

/obj/machinery/phone_base/proc/phone_ringing()
	icon_state = PHONE_RINGING_ICON_STATE

/obj/machinery/phone_base/proc/phone_stopped_ringing()
	if(icon_state == PHONE_OFF_BASE_UNIT_ICON_STATE)
		return
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

//rotary desk phones (buildable and movable machinery)
/obj/machinery/phone_base/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	base_icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff. This one looks like it could be moved around. Landline phones work without power."
	anchored = FALSE
	pass_flags = PASSTABLE

/obj/machinery/phone_base/rotary/Initialize(mapload, ...)
	// Set phone ID based on area name
	var/area/current_area = get_area(src)
	if(current_area?.name)
		phone_id = current_area.name

	. = ..()

/obj/machinery/phone_base/rotary/wrench_act(mob/living/user, obj/item/tool)
	return default_unfasten_wrench(user, tool)

/obj/machinery/phone_base/rotary/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, base_icon_state, base_icon_state, tool)

/obj/machinery/phone_base/rotary/crowbar_act(mob/living/user, obj/item/tool)
	return (anchored) ? ITEM_INTERACT_BLOCKING : default_deconstruction_crowbar(tool)

/obj/machinery/phone_base/rotary/multitool_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		return ITEM_INTERACT_BLOCKING

	var/datum/component/phone/phone_comp = GetComponent(/datum/component/phone)
	if(!phone_comp)
		to_chat(user, span_warning("Phone component not found!"))
		return ITEM_INTERACT_BLOCKING

	var/new_phone_id = tgui_input_text(user, "Enter a new phone ID:", "Phone ID", phone_id, MAX_NAME_LEN)
	if(!new_phone_id || new_phone_id == phone_id)
		return ITEM_INTERACT_SUCCESS

	user.log_message("renamed [phone_id] (phone) to [new_phone_id].", LOG_GAME)

	// Update the phone component with unique ID generation
	phone_comp.phone_id = phone_comp.generate_unique_phone_id(new_phone_id)
	phone_id = phone_comp.phone_id // Sync our local variable
	to_chat(user, span_notice("You change the phone's ID to '[phone_id]'."))

	return ITEM_INTERACT_SUCCESS

/obj/machinery/phone_base/rotary/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

/obj/machinery/phone_base/rotary/head_of_staff
	phone_category = "Command"
	anchored = TRUE // Command phones start secured

/obj/machinery/phone_base/rotary/head_of_staff/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

/// Make the OG phone cursed - 1% chance to instantly kill you when used
/obj/item/phone
	special_desc = "Something feels... wrong about this one. You get a bad feeling using it."

/obj/item/phone/attack_hand(mob/living/carbon/human/user)
	return ..()

/obj/item/phone/attack_self(mob/living/carbon/human/user)
	if(prob(1)) // 1% chance of instant death
		var/turf/selected_turf = get_turf(user)
		selected_turf.visible_message(span_userdanger("[user] suddenly dies!"))
		user.investigate_log("has been killed by a cursed telephone.", INVESTIGATE_DEATHS)
		user.death()
		return
	// 99% of the time, just ring
	playsound(user, 'modular_iris/modules/phone/sound/telephone_ring.ogg', 30, FALSE)
	to_chat(user, span_notice("The phone rings ominously in your hands..."))
