/proc/make_nova_datum_references()
	init_prefs_emotes()
	make_default_mutant_bodypart_references()
	make_body_marking_references()
	make_body_marking_set_references()
	make_augment_references()

/proc/init_prefs_emotes()
	//Scream types
	for(var/spath in subtypesof(/datum/scream_type))
		var/datum/scream_type/S = new spath()
		GLOB.scream_types[S.name] = spath
	sort_list(GLOB.scream_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	//Laugh types
	for(var/spath in subtypesof(/datum/laugh_type))
		var/datum/laugh_type/L = new spath()
		GLOB.laugh_types[L.name] = spath
	sort_list(GLOB.laugh_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	//Voice_Bark
	for(var/sound_blooper_path in subtypesof(/datum/blooper))
		var/datum/blooper/blooper = new sound_blooper_path()
		GLOB.blooper_list[blooper.id] = sound_blooper_path
		if(blooper.allow_random)
			GLOB.blooper_random_list[blooper.id] = sound_blooper_path

/proc/make_default_mutant_bodypart_references()
	// Build the global list for default species' mutant_bodyparts
	for(var/species_path in subtypesof(/datum/species))
		var/datum/species/species = GLOB.species_prototypes[species_path]
		if(isnull(species.name))
			continue

		var/list/default_parts = species.get_default_mutant_bodyparts()
		if(!islist(default_parts))
			continue

		GLOB.default_mutant_bodyparts[species.name] = default_parts

/proc/make_body_marking_references()
	// Here we build the global list for all body markings
	for(var/path in subtypesof(/datum/body_marking))
		var/datum/body_marking/BM = path
		if(initial(BM.name))
			BM = new path()
			GLOB.body_markings[BM.name] = BM
			//We go through all the possible affected bodyparts and a name reference where applicable
			for(var/marking_zone in GLOB.marking_zones)
				var/bitflag = GLOB.marking_zone_to_bitflag[marking_zone]
				if(BM.affected_bodyparts & bitflag)
					if(!GLOB.body_markings_per_limb[marking_zone])
						GLOB.body_markings_per_limb[marking_zone] = list()
					GLOB.body_markings_per_limb[marking_zone] += BM.name

/proc/make_body_marking_set_references()
	// Here we build the global list for all body markings sets
	for(var/path in subtypesof(/datum/body_marking_set))
		var/datum/body_marking_set/BM = path
		if(initial(BM.name))
			BM = new path()
			GLOB.body_marking_sets[BM.name] = BM

/proc/init_nova_stack_recipes()
	var/list/additional_stack_recipes = list(
		/obj/item/stack/sheet/leather = list(GLOB.nova_leather_recipes, GLOB.nova_leather_belt_recipes),
		/obj/item/stack/sheet/mineral/titanium = list(GLOB.nova_titanium_recipes),
		/obj/item/stack/sheet/mineral/snow = list(GLOB.nova_snow_recipes),
		/obj/item/stack/sheet/iron = list(GLOB.nova_metal_recipes, GLOB.nova_metal_airlock_recipes),
		/obj/item/stack/sheet/plasteel = list(GLOB.nova_plasteel_recipes),
		/obj/item/stack/sheet/mineral/wood = list(GLOB.nova_wood_recipes),
		/obj/item/stack/sheet/cardboard = list(GLOB.nova_cardboard_recipes),
		/obj/item/stack/sheet/cloth = list(GLOB.nova_cloth_recipes),
		/obj/item/stack/ore/glass = list(GLOB.nova_sand_recipes),
		/obj/item/stack/sheet/mineral/sandstone = list(GLOB.nova_sandstone_recipes),
		/obj/item/stack/rods = list(GLOB.nova_rod_recipes),
		/obj/item/stack/sheet/plastic = list(GLOB.nova_plastic_recipes),
		/obj/item/stack/sheet/mineral/stone = list(GLOB.stone_recipes),
		/obj/item/stack/sheet/mineral/clay = list(GLOB.clay_recipes),
		/obj/item/stack/sheet/plastic_wall_panel = list(GLOB.plastic_wall_panel_recipes),
		/obj/item/stack/sheet/spaceshipglass = list(GLOB.spaceshipglass_recipes),
	)
	for(var/stack in additional_stack_recipes)
		for(var/material_list in additional_stack_recipes[stack])
			for(var/stack_recipe in material_list)
				if(istype(stack_recipe, /datum/stack_recipe_list))
					var/datum/stack_recipe_list/stack_recipe_list = stack_recipe
					for(var/nested_recipe in stack_recipe_list.recipes)
						if(!nested_recipe)
							continue
						var/datum/crafting_recipe/stack/recipe = new/datum/crafting_recipe/stack(stack, nested_recipe)
						if(recipe.name != "" && recipe.result)
							GLOB.crafting_recipes += recipe
				else
					if(!stack_recipe)
						continue
					var/datum/crafting_recipe/stack/recipe = new/datum/crafting_recipe/stack(stack, stack_recipe)
					if(recipe.name != "" && recipe.result)
						GLOB.crafting_recipes += recipe

/proc/make_augment_references()
	// Here we build the global loadout lists
	for(var/path in subtypesof(/datum/augment_item))
		var/datum/augment_item/L = path
		if(initial(L.path))
			L = new path()
			GLOB.augment_items[L.path] = L

			if(!GLOB.augment_slot_to_items[L.slot])
				GLOB.augment_slot_to_items[L.slot] = list()
				if(!GLOB.augment_categories_to_slots[L.category])
					GLOB.augment_categories_to_slots[L.category] = list()
				GLOB.augment_categories_to_slots[L.category] += L.slot
			GLOB.augment_slot_to_items[L.slot] += L.path

/// If the "Remove ERP Interaction" config is disabled, remove ERP things from various lists
/// ERP GUTTED. leaving comments in case something breaks
	// Chemical reactions aren't handled here because they're loaded in the reagents SS
	// See Initialize() on SSReagents
