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
		/datum/crafting_recipe/plant_extract,
		/datum/crafting_recipe/energy_extract_1,
		/datum/crafting_recipe/energy_extract_2,
		/datum/crafting_recipe/death_extract_1,
// complext extracts
		/datum/crafting_recipe/life_extract,
		/datum/crafting_recipe/mutandis,
// mutandis mutations
		/datum/crafting_recipe/mut_shadowshroom,
		/datum/crafting_recipe/mut_cotton,
		/datum/crafting_recipe/mut_towercap,
// scanners
		/datum/crafting_recipe/magic_scanner_blood,
		/datum/crafting_recipe/magic_scanner_mineral,
		/datum/crafting_recipe/magic_scanner_grass,
// magic items
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
// basic extracts:

/obj/item/extract
	name = "magic extract"
	desc = "A powder extracted from an object with magical potential for a more convenient use in rituals or artifact creation."
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_iris/modules/magic_quirk/icons.dmi'
	icon_state = "canned_extract_template"
	var/magic_desc = "no extra info about the extract"

// decided to make an infinite pile of cans as a tool instead of individual cans as a material to avoid the problem of the cans disappearing after crafts
// also it's slightly more convenient
/obj/item/extract/cans
	name = "canning supplies"
	desc = "A pile of cans carved out of sandstone for storing magical extracts."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "canning_supplies"
	magic_desc = "Caaaaaaanssssdjknjkksjnkfjgnkj"

/obj/item/extract/cans/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!do_after(user, 2 SECONDS, src))
		balloon_alert(user, "extraction failed!")
		return NONE

	if (istype(interacting_with, /obj/item))
		var/obj/item/I = interacting_with
// it didn't work with a switch statement so...
		if(istype(I, /obj/item/bodypart/arm/right/skeleton) || istype(I, /obj/item/bodypart/head/skeleton) || \
istype(I, /obj/item/bodypart/leg/left/skeleton) || istype(I, /obj/item/bodypart/arm/left/skeleton) || istype(I, /obj/item/bodypart/leg/right/skeleton))
			new /obj/item/extract/death(get_turf(src))
			I.burn() // limbs turn into ash because simple qdeletion looks boring
			return
		if(istype (I, /obj/item/organ/tongue/bone) || istype (I, /obj/item/organ/stomach/bone) || istype (I, /obj/item/organ/liver/bone))
			new /obj/item/extract/death(get_turf(src))
			I.acid_melt()//organs melt instead for an unknown reason because magic
			return
		if(istype (I, /obj/item/stock_parts/power_store))
			var/obj/item/stock_parts/power_store/ps = interacting_with
			if (ps.charge() >= STANDARD_CELL_CHARGE * 23)
				ps.change(-STANDARD_CELL_CHARGE * 23)
				new /obj/item/extract/energy(get_turf(src))
			else
				balloon_alert(user, "not enough energy!")
			return

	// mob interactions

//STANDARD_CELL_CHARGE * 23




/datum/crafting_recipe/canning_supplies
	name = "Canning supplies"
	result = /obj/item/extract/cans
	time = 80
	reqs = list(/obj/item/stack/sheet/mineral/sandstone = 10,)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC



/obj/item/extract/fire
	name = "fire extract"
	desc = "A pretty bright and possible flamable powder."
	grind_results = list(/datum/reagent/phlogiston = 20)
	icon_state = "fire_extract"
	magic_desc = "An extract linked to the alchemical elemet of phlogiston. Can be obtained from plasma and fire blossoms"

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
	magic_desc = "Extracted from shadowshrooms or dead rats, the preferred offering of the maint god."

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



/obj/item/extract/energy
	name = "energy extract"
	desc = "A material that somehow stores a lot of condensed energy."
	icon_state = "energy_extract"
	magic_desc = "Can be extracted from different kinds of nutrition. Can also be harvested from electricity, but will require a lot of it"

/datum/crafting_recipe/energy_extract_1
	name = "Energy extract"
	result = /obj/item/extract/energy
	time = 40
	reqs = list(/datum/reagent/consumable/nutriment = 20)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans)

/datum/crafting_recipe/energy_extract_2
	name = "Energy extract"
	result = /obj/item/extract/energy
	time = 40
	reqs = list(/obj/item/food/meat/slab = 2)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans,/obj/item/organ/stomach)


/obj/item/extract/death
	name = "death extract"
	desc = "A powder made from the dead."
	icon_state = "death_extract"
	magic_desc = "Found in bones. Skeletons that had been dead for a long time have more of it than bones of the recently killed fauna.\
It is technically capable of raising the dead... but not animating them."
// corpses stay on the ground because of the traits: floored (stat), incapacitated  (stat). remove incapacitated before floored for them to stand up

/obj/item/extract/death/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (istype(interacting_with, /mob/living/carbon))
		var/mob/living/carbon/liv = interacting_with
		if (liv.stat == DEAD)
			REMOVE_TRAIT(liv, TRAIT_INCAPACITATED, STAT_TRAIT)
			REMOVE_TRAIT(liv, TRAIT_FLOORED, STAT_TRAIT)
			qdel(src)


/datum/crafting_recipe/death_extract_1
	name = "Death extract"
	result = /obj/item/extract/death
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 6)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans)
// ToDo: add a second craft from skeleton bodyparts



/obj/item/extract/plant_life
	name = "plant life extract"
	desc = "A can of some green powder."
	grind_results = list(/datum/reagent/diethylamine = 1, /datum/reagent/saltpetre = 4)
	icon_state = "plant_life_extract"
	magic_desc = "Can be extracted from any plant. Contains a little bit of fertilizer"

/datum/crafting_recipe/plant_extract
	name = "Plant life extrect"
	result = /obj/item/extract/plant_life
	time = 10
//extracting it from mushrooms that aren't technically plants will send an angry gang of mushrom people to your real life location
	reqs = list(/obj/item/food/grown = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/extract/cans)

//<><><>
// complex extracts
/obj/item/extract/life
	name = "life extract"
	desc = "A red powder that seems to be flickering."
	grind_results = list(/datum/reagent/medicine/omnizine = 10, /datum/reagent/medicine/strange_reagent = 5)
	icon_state = "life_extract"
	magic_desc = "A powder with slight healing properties, more useful for altering living organisms and animating inanimate objects. \
	It is hard to extract from living tissue so it's usually mixed from death and energy extracts."

/datum/crafting_recipe/life_extract
	name = "Life extract"
	result = /obj/item/extract/life
	time = 40
	reqs = list(/obj/item/extract/death = 1, /obj/item/extract/energy = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC



/obj/item/extract/mutandis
	name = "mutandis"
	desc = "A pile of what seems to be soil with green crystals."
	grind_results = list(/datum/reagent/toxin/mutagen = 30)
	icon_state = "mutandis"
	magic_desc = "A mixture capable of mutating plants."

/datum/crafting_recipe/mutandis
	name = "Mutandis"
	result = /obj/item/extract/mutandis
	time = 10
	reqs = list(/obj/item/stack/ore/glass = 2, /obj/item/extract/plant_life = 1, /datum/reagent/consumable/sugar = 5)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

//mutandis crafts:
/datum/crafting_recipe/mut_shadowshroom
	name = "Shadowshroom cluster"
	result = /obj/item/food/grown/mushroom/glowshroom/shadowshroom
	time = 40
	reqs = list(/obj/item/extract/mutandis = 1, /obj/item/extract/shadow = 1, /obj/item/food/grown/mushroom = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

/datum/crafting_recipe/mut_cotton
	name = "Cotton bundle"
	result = /obj/item/grown/cotton
	time = 40
	reqs = list(/obj/item/extract/mutandis = 1, /datum/reagent/medicine/omnizine = 2, /obj/item/stack/sheet/cloth = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

/datum/crafting_recipe/mut_towercap
	name = "Tower-cap log"
	result = /obj/item/grown/log
	time = 40
	reqs = list(/obj/item/extract/mutandis = 1, /datum/reagent/medicine/omnizine = 2, /obj/item/stack/sheet/mineral/wood = 1)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

// /obj/item/food/grown/mushroom

// /datum/reagent/consumable/sugar

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


/obj/item/shard/magic_scanner
	name = "magic scanner"
	desc = "A piece of glass that can hopefully detect magical effects. At least some of them."
	force = 0 // so you don't stab what you scan. keeping throwforce the same for the funny
	icon = 'modular_iris/modules/magic_quirk/icons.dmi'
	icon_state = "scanner_blood"
// because SOMEONE didn't sepparate the icon generation method from Iinitialize proc in /obj/item/shard, i have to do this shit
	var/icon_yes = "scanner_blood"

/obj/item/shard/magic_scanner/Initialize(mapload)
	. = ..()
	icon_state = icon_yes


/obj/item/shard/magic_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!do_after(user, 3 SECONDS, src))
		balloon_alert(user, "scan failed!")
		return NONE

	user.visible_message(span_notice("Scanning [interacting_with] for magical effects..."))

	if (istype(interacting_with, /obj/item/extract))
		var/obj/item/extract/E = interacting_with
		user.visible_message(E.magic_desc)



	if (HAS_TRAIT(interacting_with, TRAIT_NO_MIRROR_REFLECTION))
		user.visible_message(span_notice("[interacting_with] doesn't show up on the scanner!"))
		return NONE

	if (HAS_TRAIT(interacting_with, TRAIT_HOLY) || HAS_TRAIT(interacting_with, TRAIT_SPIRITUAL))
		user.visible_message(span_notice("[interacting_with] is connected to some deity"))

	if (HAS_TRAIT(interacting_with, TRAIT_ANTIMAGIC))
		user.visible_message(span_notice("[interacting_with] has some sort of magic resistance. The rest of the infortmation is obscured"))
		return NONE

	if (HAS_TRAIT(interacting_with, TRAIT_NO_SOUL))
		user.visible_message(span_notice("[interacting_with]'s soul is missing!"))

	if (HAS_TRAIT(interacting_with, TRAIT_CULT_HALO))
		user.visible_message(span_notice("[interacting_with] might be a cultist. Not sure though."))

	if (HAS_TRAIT(interacting_with, TRAIT_SCARY_FISHERMAN))
		user.visible_message(span_notice("Fish fear [interacting_with.p_them()]"))

	user.visible_message(span_notice("That's all the magic scanner detected"))
	return ITEM_INTERACT_SUCCESS
// might add checks for:
// TRAIT_MAGICALLY_GIFTED TRAIT_NODEATH

/obj/item/shard/magic_scanner/blood
	icon_state = "scanner_blood"
	icon_yes = "scanner_blood"

/datum/crafting_recipe/magic_scanner_blood
	name = "Magic scanner"
	result = /obj/item/shard/magic_scanner/blood
	time = 50
	reqs = list(/obj/item/shard = 1, /datum/reagent/blood = 30)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC
	tool_paths = list(/obj/item/pen)



/obj/item/shard/magic_scanner/mineral
	icon_state = "scanner_mineral"
	icon_yes = "scanner_mineral"
	custom_materials = list(/datum/material/alloy/plasmaglass=SHEET_MATERIAL_AMOUNT)

/datum/crafting_recipe/magic_scanner_mineral
	name = "Magic scanner"
	result = /obj/item/shard/magic_scanner/mineral
	time = 50
	reqs = list(/obj/item/shard/plasma = 1, /obj/item/stack/cable_coil = 6)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC



/obj/item/shard/magic_scanner/grass
	icon_state = "scanner_grass"
	icon_yes = "scanner_grass"

/datum/crafting_recipe/magic_scanner_grass
	name = "Magic scanner"
	result = /obj/item/shard/magic_scanner/grass
	time = 50
	reqs = list(/obj/item/shard = 1, /obj/item/food/grown/nettle = 2)
	crafting_flags = CRAFT_MUST_BE_LEARNED
	category = CAT_MAGIC

// unfinished
/*
/obj/item/extract/rite
	var/reusable = FALSE
	var/radius = 4

/obj/item/extract/rite/proc/effect()

	return FALSE
*/

