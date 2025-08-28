/datum/crafting_recipe/summoning_flute
	name = "Summoning Flute (Mega Arachnid)"
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 1,
		/obj/item/stack/sheet/animalhide/bileworm = 1
	)
	result = /obj/item/summoning_flute
	category = CAT_MISC
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/summoning_flute/drake
	name = "Summoning Flute (Ash Drake)"
	result = /obj/item/summoning_flute/drake

/datum/crafting_recipe/summoning_flute/bubblegum
	name = "Summoning Flute (Bubblegum)"
	result = /obj/item/summoning_flute/bubblegum

/datum/crafting_recipe/summoning_flute/hierophant
	name = "Summoning Flute (Hierophant)"
	result = /obj/item/summoning_flute/hierophant

/datum/crafting_recipe/summoning_flute/ice
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew/wolf = 1,
		/obj/item/stack/sheet/animalhide/bear = 1
	)
