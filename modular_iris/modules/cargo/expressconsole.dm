/obj/item/circuitboard/computer/cargo/express/ghost/freighter
	name = "Independent Express Supply Console"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/cargo/express/ghost/freighter
	contraband = TRUE

/obj/machinery/computer/cargo/express/ghost/freighter
	name = "\improper Independent Express Supply Console"
	desc = "A specialized express cargo console, linked to the open market. This one specifically is programmed to deliver all orders via high-speed railgun pods, capable of making a delivery in mere seconds no matter how far away they are."
	circuit = /obj/item/circuitboard/computer/cargo/express/ghost/freighter
	req_access = list(ACCESS_CARGO)
	cargo_account = ACCOUNT_INDIE_CARGO
