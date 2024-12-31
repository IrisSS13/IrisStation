/datum/map_generator/cave_generator/snundra
	weighted_open_turf_types = list(/turf/open/misc/asteroid/snow/icemoon = 20)
	initial_closed_chance = 15
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/snow = 100,
	)

	flora_spawn_chance = 60
	mob_spawn_chance = 1

	weighted_mob_spawn_list = list(
		/mob/living/basic/mining/wolf = 30,
		/obj/effect/spawner/random/lavaland_mob/raptor = 15,
		/mob/living/simple_animal/hostile/asteroid/polarbear = 10,
		/mob/living/basic/deer/ice = 50,
		/mob/living/basic/tree = 5,
	)

	weighted_flora_spawn_list = list(
		/obj/structure/flora/tree/pine/style_random = 18,
		/obj/structure/flora/tree/dead/style_random = 1,
		/obj/structure/flora/tree/stump = 1,
		/obj/structure/flora/rock/icy/style_random = 1,
		/obj/structure/flora/rock/pile/icy/style_random = 3,
		/obj/structure/flora/grass/both/style_random = 50,
		/obj/structure/flora/bush/flowers_pp/style_random = 25,
		/obj/structure/flora/ash/chilly = 15,
	)

	///Note that this spawn list is also in the lavaland generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater = 10,
		/obj/structure/geyser/plasma_oxide = 10,
		/obj/structure/geyser/protozine = 10,
		/obj/structure/geyser/random = 2,
		/obj/structure/geyser/wittel = 10,
	)
