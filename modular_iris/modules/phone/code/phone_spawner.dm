// Phone spawning entries for head of staff quarters
// Each head gets their own entry to ensure phones spawn in ALL quarters, not just one random one

/datum/area_spawn/phone
	target_areas = list(/area/station/command/bridge)
	desired_atom = /obj/machinery/phone_base/rotary
	blacklisted_stations = list("Biodome", "Kilo Station", "Oshan", "Ouroboros", "Snowglobe Station", "Runtime Station", "MultiZ Debug", "Gateway Test", "Blueshift", "Minimal Runtime Station")

/datum/area_spawn/phone/ce
	target_areas = list(/area/station/command/heads_quarters/ce)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff

/datum/area_spawn/phone/cmo
	target_areas = list(/area/station/command/heads_quarters/cmo)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff

/datum/area_spawn/phone/hop
	target_areas = list(/area/station/command/heads_quarters/hop)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff

/datum/area_spawn/phone/hos
	target_areas = list(/area/station/command/heads_quarters/hos)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff/no_dnd

/datum/area_spawn/phone/qm
	target_areas = list(/area/station/command/heads_quarters/qm)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff

/datum/area_spawn/phone/rd
	target_areas = list(/area/station/command/heads_quarters/rd)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff

/datum/area_spawn/phone/nt_rep
	target_areas = list(/area/station/command/heads_quarters/nt_rep)
	desired_atom = /obj/machinery/phone_base/rotary/head_of_staff/no_dnd
