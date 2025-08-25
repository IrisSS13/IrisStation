/obj/machinery/computer/anchor_controller
	name = "anchor controller"
	desc = "Used to reposition dive anchors."
	icon_screen = "teleport"
	icon_keyboard = "mining_key"
	circuit = /obj/item/circuitboard/computer/anchor_controller
	///Dive anchor linked to this controller, connected using a multitool
	var/obj/machinery/dive_anchor/anchor
	///Message shown in the UI after a successful or unsuccessful action
	var/message = "Nothing to report."
	///Coordinate values used in the UI
	var/ui_x = 1
	var/ui_y = 1
	var/ui_z = 5

/obj/machinery/computer/anchor_controller/multitool_act(mob/living/user, obj/item/tool)
	. = ..()
	var/obj/item/multitool/multitool = tool
	if(!(multitool.buffer))
		balloon_alert(user, "buffer is empty")
		return ITEM_INTERACT_BLOCKING
	if(!(istype(multitool.buffer, /obj/machinery/dive_anchor)))
		balloon_alert(user, "buffered machine data is incompatible")
		return ITEM_INTERACT_BLOCKING
	if(istype(multitool.buffer, /obj/machinery/dive_anchor/stationary))
		balloon_alert(user, "[src] refuses the stationary anchor")
		return ITEM_INTERACT_BLOCKING
	anchor = multitool.buffer
	ui_x = anchor.x
	ui_y = anchor.y
	ui_z = anchor.z
	balloon_alert(user, "anchor linked successfully")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/computer/anchor_controller/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnchorController", name)
		ui.open()

/obj/machinery/computer/anchor_controller/ui_data(mob/user)
	var/list/data = list()
	data["anchor"] = "none connected"
	data["fuel"] = "unknown"
	if(anchor)
		data["anchor"] = anchor.designation
		data["fuel"] = anchor.fuel_charges
	data["x_coord"] = clamp(ui_x, 1, 255)
	data["y_coord"] = clamp(ui_y, 1, 255)
	data["z_coord"] = clamp(ui_z, 5, 11) //unreserved z-levels only
	data["message"] = message
	return data

/obj/machinery/computer/anchor_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("send-home")
			if(!anchor)
				message = "Error: no anchor linked - link one to proceed."
				return
			if(!anchor.home_location)
				message = "Error: linked anchor has no home location - divine intervention required."
				return
			var/turf/home_turf = get_turf(anchor.home_location)
			if(home_turf.is_blocked_turf())
				message = "Error: home location obstructed - remove obstruction and try again."
				return
			anchor.relocate(anchor.home_location, FALSE)
			message = "Success: anchor moved to home location."
			return TRUE
		if("launch-to-coords")
			if(!anchor)
				message = "Error: no anchor linked - link one to proceed."
				return
			if(anchor.fuel_charges <= 0)
				message = "Error: insufficient fuel for journey - refuel anchor."
				return
			var/turf/target_turf = locate(ui_x, ui_y, ui_z)
			if(!is_spaceruins_level(target_turf.z))
				message = "Error: strange energy detected - try alternative Z coordinate."
				return
			if(!istype(target_turf, /turf/open/space) || target_turf.is_blocked_turf())
				message = "Error: target location obstructed - try alternative location."
				return
			anchor.relocate(target_turf.loc)
			message = "Success: anchor moved to input coordinates."
			return TRUE

/obj/item/circuitboard/computer/anchor_controller
	name = "Anchor Controller"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/anchor_controller

/datum/design/board/anchor_controller
	name = "Anchor Controller Board"
	desc = "Allows for the construction of circuit boards used to build anchor controllers."
	id = "anchor_controller"
	build_path = /obj/item/circuitboard/computer/anchor_controller
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
