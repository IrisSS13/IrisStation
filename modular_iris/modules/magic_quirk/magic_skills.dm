/datum/quirk/magic_crafts
	name = "Magic skills"
	desc = "You are experienced at magic. Although you did not master it as much as wizards do, you still can craft some magical artifacts. \
(You can flavor it any way you want and call the extracts differently. \
You can also ask for custom rituals through prayers, but it's not guaranteed someone will respond)"
	icon = FA_ICON_CIRCLE_HALF_STROKE //this is probably the best fitting icon i could add and i couldn't figure out which font stores the quirk hud icons
	value = 2
	gain_text = span_notice("You feel like you understand magic!")
	lose_text = span_danger("You feel like you no longer understand magic.")
//	mail_goodies = list(/obj/item/storage/fancy/nugget_box)
	var/list/crafting_recipe_types = list(
		/datum/crafting_recipe/canning_supplies,
		/datum/crafting_recipe/fire_extract_1,
		/datum/crafting_recipe/fire_extract_2,
		/datum/crafting_recipe/fire_extract_3,
		/datum/crafting_recipe/shadow_extract_1,
		/datum/crafting_recipe/shadow_extract_2,
		/datum/crafting_recipe/life_extract,
		/datum/crafting_recipe/energy_extract_1,
		/datum/crafting_recipe/death_extract_1,
		/datum/crafting_recipe/dark_candle
		)



/datum/quirk/magic_crafts/add_unique(client/client_source)
	. = ..()
	for(var/crafting_recipe_type in crafting_recipe_types)
		quirk_holder.mind.teach_crafting_recipe(crafting_recipe_type)


// I hope this works
//#define CAT_MAGIC "Magic"
// it didn't

//~~~~~~~~~~~~~~~~~~~~~~~~\\
//       THE EXTRACTS
//~~~~~~~~~~~~~~~~~~~~~~~~\\
//

/obj/item/extract
	name = "magic extract"
	desc = "A powder extracted from an object with magical potential for a more convenient use in rituals or artifact creation."
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_iris/modules/magic_quirk/icons.dmi'
	icon_state = "canned_extract_template"

// decided to make an infinite pile of cans as a tool instead of individual cans as a material to avoid the problem of the cans disappearing after crafts
// also it's slightly more convenient
/obj/item/extract/cans
	name = "canning supplies"
	desc = "A pile of cans carved out of sandstone for storing magical extracts."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "canning_supplies"

/datum/crafting_recipe/canning_supplies
	name = "Canning supplies"
	result = /obj/item/extract/cans
	time = 80
	reqs = list(/obj/item/stack/sheet/mineral/sandstone = 10,)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC



/obj/item/extract/fire
	name = "fire extract"
	desc = "A pretty flamable powder linked to the alchemical elemet of phlogiston."
	grind_results = list(/datum/reagent/phlogiston = 20)
	icon_state = "fire_extract"

/datum/crafting_recipe/fire_extract_1
	name = "Fire extract"
	result = /obj/item/extract/fire
	time = 40
	reqs = list(/obj/item/food/grown/ash_flora/fireblossom = 1,)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

/datum/crafting_recipe/fire_extract_2
	name = "Fire extract"
	result = /obj/item/extract/fire
	time = 40
	reqs = list(/obj/item/stack/sheet/mineral/plasma = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

/datum/crafting_recipe/fire_extract_3
	name = "Fire extract"
	result = /obj/item/extract/fire
	time = 40
	reqs = list(/obj/item/stack/ore/plasma = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC


/obj/item/extract/shadow
	name = "shadow extract"
	desc = "A material capable of absorbing light around itself quite effectively."
	icon_state = "shadow_extract"

/datum/crafting_recipe/shadow_extract_1
	name = "Shadow extract"
	result = /obj/item/extract/shadow
	time = 40
	reqs = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

/datum/crafting_recipe/shadow_extract_2
	name = "Shadow extract"
	result = /obj/item/extract/shadow
	time = 40
	reqs = list(/obj/item/food/deadmouse = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC



/obj/item/extract/life
	name = "life extract"
	desc = "A powder with slight healing properties, more useful for altering living organisms and animating inanimate objects. \
It is hard to extract from living tissue so it's usually obtained by mixing other extracts."
	grind_results = list(/datum/reagent/medicine/omnizine = 10, /datum/reagent/medicine/strange_reagent = 1)
	icon_state = "life_extract"

/datum/crafting_recipe/life_extract
	name = "Life extract"
	result = /obj/item/extract/life
	time = 40
	reqs = list(/obj/item/extract/death = 1, /obj/item/extract/energy = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC


/obj/item/extract/energy
	name = "energy extract"
	desc = "A material that somehow stores a lot of condensed energy."
	icon_state = "energy_extract"


/datum/crafting_recipe/energy_extract_1
	name = "Energy extract"
	result = /obj/item/extract/energy
	time = 40
	reqs = list(/datum/reagent/consumable/nutriment = 80)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans)
// ToDo: add a craft that makes it from electricity in a battery but doesn't eat the battery itself



/obj/item/extract/death
	name = "death extract"
	desc = "A powder made from the dead."
	icon_state = "death_extract"

/datum/crafting_recipe/death_extract_1
	name = "Death extract"
	result = /obj/item/extract/death
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 6)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans)
// ToDo: add a second craft from skeleton bodyparts

//~~~~~~~~~~~~~~~~~~~~~~~~\\
//    THE MAGIC ITEMS
//~~~~~~~~~~~~~~~~~~~~~~~~\\
//

/obj/item/flashlight/flare/candle/dark
	name = "dark candle"
	desc = "Burns for very long while absorbing nearby light."
//	icon = 'icons/obj/candle.dmi'
//	icon_state = "candle1"
//	inhand_icon_state = "candle"
//	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
//	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
//	w_class = WEIGHT_CLASS_TINY
//	heat = 1000
	light_range = 0
	light_power = 0
	light_color = LIGHT_COLOR_FIRE
	fuel = 240 MINUTES
// just setting light power to negative didn't work so i am copying code from the flashdark
	light_color = COLOR_WHITE
	light_system = COMPLEX_LIGHT
	var/dark_light_range = 3
	///Variable to preserve old lighting behavior in flashlights, to handle darkness.
	var/dark_light_power = -5

/obj/item/flashlight/flare/candle/dark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/overlay_lighting, dark_light_range, dark_light_power, force = TRUE)

/obj/item/flashlight/flare/candle/dark/update_brightness()
	. = ..()
	set_light(dark_light_range, dark_light_power)




/datum/crafting_recipe/dark_candle
	name = "Dark candle"
	result = /obj/item/flashlight/flare/candle/dark
	time = 60
	reqs = list(/obj/item/flashlight/flare/candle = 1, /obj/item/extract/shadow = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC





