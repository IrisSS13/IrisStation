/datum/map_template/shuttle/ruin/indie_freighter
	prefix = "_maps/shuttles/iris/"
	suffix = "indie_freighter"
	name = "Independent Freighter"
	description = "A massive independent freighter that has faced boarding by a large force of pirates. Its crew lie in stasis, guns to-hand in their locked-down quarters."
	admin_notes = "This bad boy is HUGE compared to even whiteships. Please spawn responsibly."

/area/shuttle/indie_freighter
	name = "Freighter"

/area/shuttle/indie_freighter/bridge
	name = "Freighter Bridge"

/area/shuttle/indie_freighter/hallway
	name = "Freighter Hallways"

/area/shuttle/indie_freighter/dorms
	name = "Freighter Crew Quarters"

/area/shuttle/indie_freighter/mining
	name = "Freighter Mining Bay"

/area/shuttle/indie_freighter/cargo
	name = "Freighter Cargo Hold"

/area/shuttle/indie_freighter/med
	name = "Freighter Infirmary"

/area/shuttle/indie_freighter/canteen
	name = "Freighter Canteen"

/area/shuttle/indie_freighter/engine
	name = "Freighter Engineering"

/area/shuttle/indie_freighter/electrical
	name = "Freighter Electrical"

/area/shuttle/indie_freighter/maintenance
	name = "Freighter Maintenance"

/area/shuttle/indie_freighter/maintenance/fore
	name = "Freighter Fore Maintenance"

/area/shuttle/indie_freighter/maintenance/aft
	name = "Freighter Aft Maintenance"

/area/shuttle/indie_freighter/vault
	name = "Freighter Vault"

/area/shuttle/indie_freighter/armoury
	name = "Freighter Armoury"

/area/shuttle/indie_freighter/cryogenics
	name = "Freighter Cryogenics Bay"

/area/shuttle/indie_freighter/hydro
	name = "Freighter Hydroponics"

/area/shuttle/indie_freighter/boarding_pod
	name = "Embedded Boarding Pod"

/obj/machinery/computer/shuttle/freighter
	name = "freighter helm console"
	desc = "The main control computer for the freighter."
	circuit = /obj/item/circuitboard/computer/freighter_helm
	shuttleId = "freighter"
	possible_destinations = "freighter_home;freighter_custom"
	may_be_remote_controlled = TRUE

/obj/item/circuitboard/computer/freighter_helm
	name = "Freighter Helm"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/freighter

/obj/machinery/computer/camera_advanced/shuttle_docker/freighter
	name = "freighter navigation console"
	desc = "Used to set a specific destination location for the Freighter."
	shuttleId = "freighter"
	lock_override = NONE
	circuit = /obj/item/circuitboard/computer/freighter_nav
	shuttlePortId = "freighter_custom"
	jump_to_ports = list("freighter_home" = 1, "whiteship_home" = 1, "whiteship_z4" = 1, "whiteship_waystation" = 1)
	view_range = 25
	x_offset = 10
	y_offset = -10
	designate_time = 150 //this bad boy is HUGE. youre gonna need time. not as much time as ds-2 though the computers here dont suck

/obj/item/circuitboard/computer/freighter_nav
	name = "Freighter Navigation"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/freighter

/obj/item/circuitboard/machine/powerator/freighter
	name = "\improper Freighter Powerator"
	build_path = /obj/machinery/powerator/freighter

/obj/machinery/powerator/freighter
	name = "\improper Freighter Powerator"
	credits_account = ACCOUNT_INDIE_CARGO
	power_cap = 6000 KILO WATTS
	divide_ratio = 150 KILO WATTS
	tax = 30
	circuit = /obj/item/circuitboard/machine/powerator/freighter
