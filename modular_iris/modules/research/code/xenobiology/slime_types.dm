// Turns the slime into a unique variant, if available
/mob/living/basic/slime/proc/unique_mutate(needed_color = SLIME_TYPE_GREY, datum/slime_type/unique/unique_type, obj/item/item = null)
	unique_type = possible_slime_types[unique_type]
	if(slime_type.colour == needed_color && life_stage == SLIME_LIFE_STAGE_ADULT && !unique_type.obtained && stat == CONSCIOUS)
		if(item)
			item.forceMove(src)
		unique_type.obtained = TRUE
		set_slime_type(unique_type.type)
		flick("[unique_type.colour]-transformation", src)
		visible_message(span_danger("[src] [unique_type.mutation_message]"))
		if(item)
			QDEL_IN(item, 1 SECONDS) // let the animation finish

// Unique types below, these cannot be gotten from any random generation method nor normal mutations
// Additionally you can only obtain one of these from their respective methods, after that you have to reproduce them
/datum/slime_type/unique
	var/obtained = FALSE
	var/mutation_message = null

/datum/slime_type/unique/cobalt
	colour = SLIME_TYPE_COBALT
	core_type = /obj/item/slime_extract/unique/cobalt
	mutations = list(
		/datum/slime_type/unique/cobalt = 1,
	)
	rgb_code = COLOR_NAVY
	mutation_message = "Shudders under the intense gravity, flecks of blue swirling in their golden membrane as they turn a deep blue!"

/datum/slime_type/unique/darkgrey
	colour = SLIME_TYPE_DARK_GREY
	core_type = /obj/item/slime_extract/unique/darkgrey
	mutations = list(
		/datum/slime_type/unique/darkgrey = 1,
	)
	rgb_code = COLOR_DARK
	mutation_message = "The legion skull quickly dissolves into the black slime as it turns a strange shade of grey!"

/datum/slime_type/unique/crimson
	colour = SLIME_TYPE_CRIMSON
	core_type = /obj/item/slime_extract/unique/crimson
	mutations = list(
		/datum/slime_type/unique/crimson = 1,
	)
	rgb_code = LIGHT_COLOR_BLOOD_MAGIC
	mutation_message = "The slime absorbs the surrounding flames turning a deep crimson!"

/datum/slime_type/unique/lightgreen
	colour = SLIME_TYPE_LIGHT_GREEN
	transparent = TRUE
	core_type = /obj/item/slime_extract/unique/lightgreen
	mutations = list(
		/datum/slime_type/unique/lightgreen = 1,
	)
	rgb_code = LIGHT_COLOR_SLIME_LAMP
	mutation_message = "The slime slowly turns a lighter shade of green."
