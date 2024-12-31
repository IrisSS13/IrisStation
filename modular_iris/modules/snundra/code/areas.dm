/area/snundra
	name = "Tundra Planet"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "explored"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_ICEMOON
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/snundra/outdoors // parent that defines if something is on the exterior of the station.
	name = "Tundra"
	outdoors = TRUE

/area/snundra/outdoors/nospawn

/area/snundra/outdoors/unexplored
	icon_state = "unexplored"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/snundra

/area/snundra/outdoors/unexplored/deep
	name = "Rocks 'n' Stones"
	map_generator = /datum/map_generator/cave_generator/snundra
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_ICEMOON
