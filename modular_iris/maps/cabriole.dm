///////////////////////////////////////////////////////////////////
//////// Dedicated to staff and players of Iris Station 13 ////////
///////////////////////////////////////////////////////////////////

/obj/structure/iris_hologram
	name = "Iris"
	desc = "A holographic projection of an Iris flower. Looking at it brings back memories."
	icon = 'modular_iris/icons/iris_logo.dmi'
	icon_state = "iris"
	max_integrity = 12062024
	plane = 4
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/soundloop_type = /datum/looping_sound/iris_hologram
	var/datum/proximity_monitor/elevator_music_area/sound_player
	var/impressiveness = 100

/datum/looping_sound/iris_hologram
	mid_sounds = list(
		'sound/ambience/aurora_caelus/aurora_caelus_short.ogg'
	)
	volume = 15
	direct = TRUE

/obj/structure/iris_hologram/Initialize(mapload)
	. = ..()
	makeHologram()
	transform = transform.Scale(3, 3)
	if(check_holidays("Iris Week","Iris Station's Anniversary"))
		sound_player = new(src, range = 4, soundloop_type = src.soundloop_type)
	AddElement(/datum/element/art, impressiveness)
	AddElement(/datum/element/beauty, impressiveness * 75)

/obj/structure/iris_hologram/Destroy(force)
	QDEL_NULL(sound_player)
	return ..()

/obj/machinery/computer/terminal/iris
	name = "info terminal"
	desc = "A relatively low-tech info board."
	icon_state = "plaque"
	icon_screen = "plaque_screen"
	icon_keyboard = null
	max_integrity = 28022026
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | EMP_PROTECT_SELF
	tguitheme = "ntos"
	upperinfo = "In memory of Cabriole Sector, 12 VI 2564 - 28 II 2566"
	content = list(
		"While its many stories come to an abrupt close, many more await. No matter the paths we all choose to take, those stories are now part of who we are.",
		"Thank you, to everyone who made it so special, no matter how much or how little they may have contributed. None of it could have been the same without them."
	)

/obj/machinery/computer/terminal/iris/screwdriver_act()
	return FALSE

/obj/structure/chair/sofa/bench/color/iris
	post_init_icon_state = "bench_middle"
	greyscale_config = /datum/greyscale_config/bench_middle
	greyscale_colors = "#5d419f"

/obj/structure/chair/sofa/bench/color/iris/left
	post_init_icon_state = "bench_left"
	greyscale_config = /datum/greyscale_config/bench_left

/obj/structure/chair/sofa/bench/color/iris/right
	post_init_icon_state = "bench_right"
	greyscale_config = /datum/greyscale_config/bench_right

/obj/item/clothing/head/costume/nova/flowerpin/iris
	greyscale_colors = "#5d419f"
	desc = "A small flower pin resembling an iris flower."

/obj/item/kirbyplants/iris
	icon_state = "iris"
	icon = 'modular_iris/master_files/icons/obj/plants.dmi'
