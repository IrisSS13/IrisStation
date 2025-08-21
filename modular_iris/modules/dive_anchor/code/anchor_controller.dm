/obj/machinery/computer/anchor_controller
	name = "anchor controller"
	desc = "Used to reposition dive anchors."
	icon_screen = "teleport"
	icon_keyboard = "mining_key"
	circuit = /obj/item/circuitboard/computer/anchor_controller
	///dive anchor linked to this controller, connected using a multitool
	var/obj/machinery/dive_anchor/anchor

/obj/machinery/computer/anchor_controller/multitool_act(mob/living/user, obj/item/tool)
	. = ..()
	var/obj/item/multitool/multitool = tool
	if(!(multitool.buffer))
		balloon_alert(user, "buffer is empty")
		return ITEM_INTERACT_SUCCESS
	if(!(istype(multitool.buffer, /obj/machinery/dive_anchor)))
		balloon_alert(user, "buffered machine data is incompatible")
		return ITEM_INTERACT_SUCCESS
	if(istype(multitool.buffer, /obj/machinery/dive_anchor/stationary))
		balloon_alert(user, "the [src] refuses the stationary anchor")
		return ITEM_INTERACT_SUCCESS
	anchor = multitool.buffer
	balloon_alert(user, "anchor linked successfully")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/computer/anchor_controller/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnchorController", name)
		ui.open()

/obj/machinery/computer/anchor_controller/ui_data(mob/user)
	. = ..()

/obj/machinery/computer/anchor_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

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
