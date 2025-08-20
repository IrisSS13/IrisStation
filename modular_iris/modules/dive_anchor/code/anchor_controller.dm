/obj/machinery/computer/anchor_controller
	name = "anchor controller"
	desc = "Used to reposition dive anchors."
	icon_screen = "teleport"
	icon_keyboard = "mining_key"
	circuit = /obj/item/circuitboard/computer/anchor_controller

/obj/item/circuitboard/computer/anchor_controller
	name = "Anchor Controller"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/anchor_controller

/datum/design/board/anchor_controller
	name = "Anchor Controller Console Board"
	desc = "Allows for the construction of circuit boards used to build anchor controller consoles."
	id = "anchor_controller"
	build_path = /obj/item/circuitboard/computer/anchor_controller
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
