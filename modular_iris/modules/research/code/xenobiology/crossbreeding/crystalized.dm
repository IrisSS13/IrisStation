/obj/item/slimecross/crystalline
	name = "crystalline extract"
	desc = "It's crystalline,"
	effect = "crystalline"
	icon = 'modular_iris/modules/research/icons/slimecrossing.dmi'
	icon_state = "crystalline"
	effect_desc = "Use to place a pylon."
	var/obj/structure/slime_crystal/crystal_type

/obj/item/slimecross/crystalline/attack_self(mob/user)
	. = ..()

	// Check before the progress bar so they don't wait for nothing
	if(locate(/obj/structure/slime_crystal) in range(6, get_turf(user)))
		to_chat(user,span_notice("You can't build crystals that close to each other!"))
		return

	var/user_turf = get_turf(user)

	if(!do_after(user, 15 SECONDS, src))
		return

	// check after in case someone placed a crystal in the meantime (im watching you aramix)
	if(locate(/obj/structure/slime_crystal) in range(6, get_turf(user)))
		to_chat(user,span_notice("You can't build crystals that close to each other!"))
		return

	new crystal_type(user_turf)
	qdel(src)

/obj/structure/slime_crystal
	name = "slimic pylon"
	desc = "Glassy, pure, transparent. Powerful artifact that relays the slimecore's influence onto space around it."
	max_integrity = 5
	anchored = TRUE
	density = TRUE
	icon = 'modular_iris/modules/research/icons/slimecrossing.dmi'
	icon_state = "slime_pylon"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	///Assoc list of affected mobs, the key is the mob while the value of the map is the amount of ticks spent inside of the zone.
	var/list/affected_mobs = list()
	///What color is it?
	var/colour
	///Does it use process?
	var/uses_process = TRUE

/obj/structure/slime_crystal/New(loc, obj/structure/slime_crystal/master_crystal, ...)
	. = ..()
	if(master_crystal) // This is for rainbow pylons if ya were wondering
		invisibility = INVISIBILITY_MAXIMUM
		max_integrity = 1000
		atom_integrity = 1000

/obj/structure/slime_crystal/Initialize(mapload)
	. = ..()
	name =  "[colour] slimic pylon"
	var/itemcolor = "#FFFFFF"
	switch(colour)
		if(SLIME_TYPE_ORANGE)
			itemcolor = COLOR_SLIME_ORANGE
		if(SLIME_TYPE_PURPLE)
			itemcolor = COLOR_SLIME_PURPLE
		if(SLIME_TYPE_BLUE)
			itemcolor = COLOR_SLIME_BLUE
		if(SLIME_TYPE_METAL)
			itemcolor = COLOR_SLIME_METAL
		if(SLIME_TYPE_YELLOW)
			itemcolor = COLOR_SLIME_YELLOW
		if(SLIME_TYPE_DARK_PURPLE)
			itemcolor = COLOR_SLIME_DARK_PURPLE
		if(SLIME_TYPE_DARK_BLUE)
			itemcolor = COLOR_SLIME_DARK_BLUE
		if(SLIME_TYPE_SILVER)
			itemcolor = COLOR_SLIME_SILVER
		if(SLIME_TYPE_BLUESPACE)
			itemcolor = COLOR_SLIME_BLUESPACE
		if(SLIME_TYPE_SEPIA)
			itemcolor = COLOR_SLIME_SEPIA
		if(SLIME_TYPE_CERULEAN)
			itemcolor = COLOR_SLIME_CERULEAN
		if(SLIME_TYPE_PYRITE)
			itemcolor = COLOR_SLIME_PYRITE
		if(SLIME_TYPE_RED)
			itemcolor = COLOR_SLIME_RED
		if(SLIME_TYPE_GREEN)
			itemcolor = COLOR_SLIME_GREEN
		if(SLIME_TYPE_PINK)
			itemcolor = COLOR_SLIME_PINK
		if(SLIME_TYPE_GOLD)
			itemcolor = COLOR_SLIME_GOLD
		if(SLIME_TYPE_OIL)
			itemcolor = COLOR_SLIME_OIL
		if(SLIME_TYPE_BLACK)
			itemcolor = COLOR_SLIME_BLACK
		if(SLIME_TYPE_LIGHT_PINK)
			itemcolor = COLOR_SLIME_LIGHT_PINK
		if(SLIME_TYPE_ADAMANTINE)
			itemcolor = COLOR_SLIME_ADAMANTINE

	add_atom_colour(itemcolor, FIXED_COLOUR_PRIORITY)
	if(uses_process)
		START_PROCESSING(SSobj, src)

/obj/structure/slime_crystal/Destroy()
	if(uses_process)
		STOP_PROCESSING(SSobj, src)
	for(var/X in affected_mobs)
		on_mob_leave(X)
	return ..()

/obj/structure/slime_crystal/process()
	var/list/current_mobs = get_valid_targets()
	for(var/mob/living/mob_in_range in current_mobs)
		if(!(mob_in_range in affected_mobs))
			on_mob_enter(mob_in_range)
			affected_mobs[mob_in_range] = 0

		affected_mobs[mob_in_range]++
		on_mob_effect(mob_in_range)

	for(var/M in affected_mobs - current_mobs)
		on_mob_leave(M)
		affected_mobs -= M

/obj/structure/slime_crystal/proc/get_valid_targets()
	return range(3, src)

/obj/structure/slime_crystal/proc/master_crystal_destruction()
	qdel(src)

/obj/structure/slime_crystal/proc/on_mob_enter(mob/living/affected_mob)
	return

/obj/structure/slime_crystal/proc/on_mob_effect(mob/living/affected_mob)
	return

/obj/structure/slime_crystal/proc/on_mob_leave(mob/living/affected_mob)
	return

/obj/item/slimecross/crystalline/grey
	crystal_type = /obj/structure/slime_crystal/grey
	colour = SLIME_TYPE_GREY

/obj/structure/slime_crystal/grey
	colour = SLIME_TYPE_GREY

/obj/structure/slime_crystal/grey/get_valid_targets()
	return view(3, src)

/obj/structure/slime_crystal/grey/on_mob_effect(mob/living/basic/slime/affected_mob)
	if(!istype(affected_mob))
		return
	affected_mob.adjust_nutrition(2)

/obj/item/slimecross/crystalline/orange
	crystal_type = /obj/structure/slime_crystal/orange
	colour = SLIME_TYPE_ORANGE

/obj/structure/slime_crystal/orange
	colour = SLIME_TYPE_ORANGE

/obj/structure/slime_crystal/orange/get_valid_targets()
	return view(3, src)

/obj/structure/slime_crystal/orange/on_mob_effect(mob/living/affected_mob)
	if(!istype(affected_mob, /mob/living/carbon))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	carbon_mob.adjust_fire_stacks(1)
	carbon_mob.ignite_mob()

/obj/structure/slime_crystal/orange/process()
	. = ..()
	var/turf/open/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/gas = T.return_air()
	gas.temperature = (T0C + 200)
	T.air_update_turf(FALSE, FALSE)

/obj/item/slimecross/crystalline/purple
	crystal_type = /obj/structure/slime_crystal/purple
	colour = SLIME_TYPE_PURPLE

/obj/structure/slime_crystal/purple
	colour = SLIME_TYPE_PURPLE
	var/heal_amount = 2

/obj/structure/slime_crystal/purple/on_mob_effect(mob/living/affected_mob)
	if(!istype(affected_mob, /mob/living/carbon))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	var/rand_dam_type = rand(0, 10)

	new /obj/effect/temp_visual/heal(get_turf(affected_mob), "#e180ff")

	switch(rand_dam_type)
		if(0)
			carbon_mob.adjustBruteLoss(-heal_amount)
		if(1)
			carbon_mob.adjustFireLoss(-heal_amount)
		if(2)
			carbon_mob.adjustOxyLoss(-heal_amount)
		if(3)
			carbon_mob.adjustToxLoss(-heal_amount, forced = TRUE)
		if(5)
			carbon_mob.adjustStaminaLoss(-heal_amount)
		if(6 to 10)
			carbon_mob.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN,ORGAN_SLOT_HEART,ORGAN_SLOT_LIVER,ORGAN_SLOT_LUNGS), -heal_amount)

/obj/item/slimecross/crystalline/blue
	crystal_type = /obj/structure/slime_crystal/blue
	colour = SLIME_TYPE_BLUE

/obj/structure/slime_crystal/blue
	colour = SLIME_TYPE_BLUE

/obj/structure/slime_crystal/blue/process()
	for(var/turf/open/T in view(2, src))
		if(isspaceturf(T))
			continue

		var/datum/gas_mixture/air = T.return_air()
		var/moles_to_remove = air.total_moles()
		T.remove_air(moles_to_remove)

		var/datum/gas_mixture/base_mix = SSair.parse_gas_string(OPENTURF_DEFAULT_ATMOS)
		T.assume_air(base_mix)
		T.air_update_turf(FALSE, FALSE)

/obj/item/slimecross/crystalline/metal
	crystal_type = /obj/structure/slime_crystal/metal
	colour = SLIME_TYPE_METAL

/obj/structure/slime_crystal/metal
	colour = SLIME_TYPE_METAL
	var/heal_amount = 3

/obj/structure/slime_crystal/metal/on_mob_effect(mob/living/affected_mob)
	if(!iscyborg(affected_mob))
		return
	var/mob/living/silicon/borgo = affected_mob
	borgo.adjustBruteLoss(-heal_amount)

/obj/item/slimecross/crystalline/yellow
	crystal_type = /obj/structure/slime_crystal/yellow
	colour = SLIME_TYPE_YELLOW

/obj/structure/slime_crystal/yellow
	colour = SLIME_TYPE_YELLOW
	light_color = LIGHT_COLOR_DIM_YELLOW //a good, sickly atmosphere
	light_power = 0.75
	uses_process = FALSE

/obj/structure/slime_crystal/yellow/Initialize(mapload)
	. = ..()
	set_light(3)

/obj/structure/slime_crystal/yellow/attacked_by(obj/item/stock_parts/power_store/cell, mob/living/user)
	if(istype(cell))
		//Punishment for greed
		if(cell.charge == cell.maxcharge)
			to_chat(span_danger(" You try to charge the cell, but it is already fully energized. You are not sure if this was a good idea..."))
			cell.explode()
			return
		to_chat(user, span_notice("You charged the [cell.name] on [name]!"))
		cell.give(cell.maxcharge)
		return
	return ..()

/obj/item/slimecross/crystalline/darkpurple
	crystal_type = /obj/structure/slime_crystal/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE

/obj/structure/slime_crystal/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE

/obj/structure/slime_crystal/darkpurple/process()
	var/turf/open/open_turf = get_turf(src)
	if(!istype(open_turf))
		return
	var/datum/gas_mixture/air = open_turf.return_air()
	if(air.gases[/datum/gas/plasma] && (air.gases[/datum/gas/plasma][MOLES] > 15))
		air.gases[/datum/gas/plasma][MOLES] -= 15
		air.garbage_collect()
		new /obj/item/stack/sheet/mineral/plasma(open_turf)

/obj/structure/slime_crystal/darkpurple/Destroy()
	atmos_spawn_air("[GAS_PLASMA]=20;[TURF_TEMPERATURE(500)]")
	return ..()

/obj/item/slimecross/crystalline/darkblue
	crystal_type = /obj/structure/slime_crystal/darkblue
	colour = SLIME_TYPE_DARK_BLUE

/obj/structure/slime_crystal/darkblue
	colour = SLIME_TYPE_DARK_BLUE

/obj/structure/slime_crystal/darkblue/process(seconds_per_tick)
	for(var/turf/open/T in RANGE_TURFS(5, src))
		if(SPT_PROB(75, seconds_per_tick))
			continue
		T.MakeDry(TURF_WET_LUBE)

	for(var/obj/item/trash/trashie in range(5, src))
		if(SPT_PROB(25, seconds_per_tick))
			qdel(trashie)

/obj/item/slimecross/crystalline/silver
	crystal_type = /obj/structure/slime_crystal/silver
	colour = SLIME_TYPE_SILVER

/obj/structure/slime_crystal/silver
	colour = SLIME_TYPE_SILVER

/obj/structure/slime_crystal/silver/process(seconds_per_tick)
	for(var/obj/machinery/hydroponics/hydr in range(5, src))
		hydr.weedlevel = 0
		hydr.pestlevel = 0
		if(SPT_PROB(10, seconds_per_tick))
			hydr.age++

/obj/item/slimecross/crystalline/bluespace
	crystal_type = /obj/structure/slime_crystal/bluespace
	colour = SLIME_TYPE_BLUESPACE

/obj/structure/slime_crystal/bluespace
	colour = SLIME_TYPE_BLUESPACE
	density = FALSE
	uses_process = FALSE
	var/static/list/slime_pylons = null
	///Is it in use?
	var/in_use = FALSE

/obj/structure/slime_crystal/bluespace/Initialize(mapload)
	. = ..()
	if(isnull(slime_pylons))
		slime_pylons = list()
	slime_pylons += src

/obj/structure/slime_crystal/bluespace/Destroy()
	slime_pylons -= src
	return ..()

/obj/structure/slime_crystal/bluespace/attack_hand(mob/user, list/modifiers)
	if(in_use)
		return

	var/list/local_bs_list = slime_pylons.Copy()
	local_bs_list -= src
	if(!LAZYLEN(local_bs_list))
		return ..()

	if(length(local_bs_list) == 1)
		do_teleport(user, local_bs_list[1])
		return

	in_use = TRUE

	var/list/assoc_list = list()

	for(var/BSC in local_bs_list)
		var/area/bsc_area = get_area(BSC)
		var/name = "[bsc_area.name] bluespace slimic pylon"
		var/counter = 0

		do
			counter++
		while(assoc_list["[name]([counter])"])

		name += "([counter])"

		assoc_list[name] = BSC

	var/chosen_input = input(user,"What destination do you want to choose",null) as null|anything in assoc_list
	in_use = FALSE

	if(!chosen_input || !assoc_list[chosen_input])
		return

	do_teleport(user ,assoc_list[chosen_input])

/obj/item/slimecross/crystalline/sepia
	crystal_type = /obj/structure/slime_crystal/sepia
	colour = SLIME_TYPE_SEPIA

/obj/structure/slime_crystal/sepia
	colour = SLIME_TYPE_SEPIA

/obj/structure/slime_crystal/sepia/on_mob_enter(mob/living/affected_mob)
	affected_mob.add_traits(list(TRAIT_NOBREATH, TRAIT_NOCRITDAMAGE, TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE, TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT), type)

/obj/structure/slime_crystal/sepia/on_mob_leave(mob/living/affected_mob)
	affected_mob.remove_traits(list(TRAIT_NOBREATH, TRAIT_NOCRITDAMAGE, TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE, TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT), type)

/obj/item/slimecross/crystalline/cerulean
	crystal_type = /obj/structure/slime_crystal/cerulean
	colour = SLIME_TYPE_CERULEAN

/obj/structure/slime_crystal/cerulean
	colour = SLIME_TYPE_CERULEAN
	uses_process = FALSE
	var/crystals = 0

/obj/structure/slime_crystal/cerulean/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 10) // doesn't guarantee 3 but it's a good effort
		spawn_crystal()

/obj/structure/slime_crystal/cerulean/proc/spawn_crystal()
	if(crystals >= 3)
		return
	for(var/turf/T as() in RANGE_TURFS(2,src))
		if(T.is_blocked_turf() || isspaceturf(T)  || T == get_turf(src) || prob(50))
			continue
		var/obj/structure/cerulean_slime_crystal/CSC = locate() in range(1,T)
		if(CSC)
			continue
		new /obj/structure/cerulean_slime_crystal(T, src)
		crystals++
		return

/obj/structure/cerulean_slime_crystal
	name = "Cerulean slime poly-crystal"
	desc = "Translucent and irregular, it can duplicate matter on a whim"
	anchored = TRUE
	density = FALSE
	icon = 'modular_iris/modules/research/icons/slimecrossing.dmi'
	icon_state = "cerulean_crystal"
	max_integrity = 5
	var/stage = 0
	var/max_stage = 5
	var/datum/weakref/pylon

/obj/structure/cerulean_slime_crystal/Initialize(mapload, obj/structure/slime_crystal/cerulean/master_pylon)
	. = ..()
	if(istype(master_pylon))
		pylon = WEAKREF(master_pylon)
	transform *= 1/(max_stage-1)
	stage_growth()

/obj/structure/cerulean_slime_crystal/proc/stage_growth()
	if(stage == max_stage)
		return

	if(stage == 3)
		density = TRUE

	stage ++

	var/matrix/M = new
	M.Scale(1/max_stage * stage)

	animate(src, transform = M, time = 120 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(stage_growth)), 120 SECONDS)

/obj/structure/cerulean_slime_crystal/Destroy()
	if(stage > 3)
		var/obj/item/cerulean_slime_crystal/crystal = new(get_turf(src))
		if(stage == 5)
			crystal.amount = rand(1, 3)
	if(pylon)
		var/obj/structure/slime_crystal/cerulean/C = pylon.resolve()
		if(C)
			C.crystals--
			C.spawn_crystal()
		else
			pylon = null
	return ..()

/obj/item/cerulean_slime_crystal
	name = "Cerulean slime poly-crystal"
	desc = "Translucent and irregular, it can duplicate matter on a whim"
	icon = 'modular_iris/modules/research/icons/slimecrossing.dmi'
	icon_state = "cerulean_item_crystal"
	var/amount = 1

/obj/item/cerulean_slime_crystal/interact_with_atom(obj/item/stack/target, mob/living/user, list/modifiers)
	if(!istype(target) || !istype(user, /mob/living/carbon))
		return ITEM_INTERACT_FAILURE

	if(istype(target, /obj/item/stack/telecrystal))
		var/mob/living/carbon/carbie = user
		to_chat(user,"<span class='big red'>You will pay for your hubris!</span>")
		carbie.gain_trauma(/datum/brain_trauma/special/beepsky,TRAUMA_RESILIENCE_ABSOLUTE)
		qdel(src)
		return ITEM_INTERACT_SUCCESS // I mean, technically

	target.add(amount)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/crystalline/pyrite
	crystal_type = /obj/structure/slime_crystal/pyrite
	colour = SLIME_TYPE_PYRITE

/obj/structure/slime_crystal/pyrite
	colour = SLIME_TYPE_PYRITE
	uses_process = FALSE

/obj/structure/slime_crystal/pyrite/Initialize(mapload)
	. = ..()
	change_colour()

/obj/structure/slime_crystal/pyrite/proc/change_colour()
	var/list/color_list = list(
		"#FFA500",
		"#B19CD9",
		"#ADD8E6",
		"#7E7E7E",
		"#FFFF00",
		"#551A8B",
		"#0000FF",
		"#D3D3D3",
		"#32CD32",
		"#704214",
		"#2956B2",
		"#FAFAD2",
		"#FF0000",
		"#00FF00",
		"#FF69B4",
		"#FFD700",
		"#505050",
		"#FFB6C1",
		"#008B8B",
	)
	for(var/turf/T as() in RANGE_TURFS(4,src))
		T.add_atom_colour(pick(color_list), FIXED_COLOUR_PRIORITY)

	addtimer(CALLBACK(src,PROC_REF(change_colour)),rand(0.75 SECONDS,1.25 SECONDS))

/obj/item/slimecross/crystalline/red
	crystal_type = /obj/structure/slime_crystal/red
	colour = SLIME_TYPE_RED

/obj/structure/slime_crystal/red
	colour = SLIME_TYPE_RED
	var/blood_amount = 0
	var/max_blood_amount = 300

/obj/structure/slime_crystal/red/examine(mob/user)
	. = ..()
	. += "It has [blood_amount] u of blood."

/obj/structure/slime_crystal/red/process()
	if(blood_amount == max_blood_amount)
		return

	for(var/obj/effect/decal/cleanable/blood/blood_around_us in range(3, src))
		if(blood_amount == max_blood_amount)
			return

		blood_amount++
		new /obj/effect/temp_visual/cult/turf/floor(get_turf(blood_around_us))
		qdel(blood_around_us)

/obj/structure/slime_crystal/red/attack_hand(mob/user, list/modifiers)
	if(blood_amount < 100)
		return ..()

	blood_amount -= 100
	var/type = pick(list(
		/obj/item/food/meat/slab,
		/obj/item/organ/heart,
		/obj/item/organ/lungs,
		/obj/item/organ/liver,
		/obj/item/organ/eyes,
		/obj/item/organ/tongue,
		/obj/item/organ/stomach,
		/obj/item/organ/ears,
	))
	new type(get_turf(src))

/obj/structure/slime_crystal/red/attacked_by(obj/item/I, mob/living/user)
	if(blood_amount < 10)
		return ..()

	if(!istype(I, /obj/item/reagent_containers/cup/beaker))
		return ..()

	var/obj/item/reagent_containers/cup/beaker/item_beaker = I

	if(!item_beaker.is_refillable() || (item_beaker.reagents.total_volume + 10 > item_beaker.reagents.maximum_volume))
		return ..()
	blood_amount -= 10
	item_beaker.reagents.add_reagent(/datum/reagent/blood, 10)

/obj/item/slimecross/crystalline/green // This may or may not work??? Mutations acted weird as hell on local
	crystal_type = /obj/structure/slime_crystal/green
	colour = SLIME_TYPE_GREEN

/obj/structure/slime_crystal/green
	colour = SLIME_TYPE_GREEN
	var/datum/mutation/stored_mutation

/obj/structure/slime_crystal/green/examine(mob/user)
	. = ..()
	if(stored_mutation)
		. += "It currently stores [stored_mutation.name]"
	else
		. += "It doesn't hold any mutations"

/obj/structure/slime_crystal/green/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!iscarbon(user) || !user.has_dna())
		return
	var/mob/living/carbon/carbon_user = user
	var/list/mutation_list = carbon_user.dna.mutations
	if(length(mutation_list))
		stored_mutation = pick(mutation_list)
		stored_mutation = stored_mutation.type

/obj/structure/slime_crystal/green/on_mob_effect(mob/living/affected_mob)
	if(!iscarbon(affected_mob) || !affected_mob.has_dna() || !stored_mutation || HAS_TRAIT(affected_mob,TRAIT_BADDNA))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	carbon_mob.dna.add_mutation(stored_mutation)

	if(affected_mobs[affected_mob] % 60 != 0)
		return

	var/list/mut_list = carbon_mob.dna.mutations
	var/list/secondary_list = list()

	for(var/X in mut_list)
		if(istype(X,stored_mutation))
			continue
		var/datum/mutation/t_mutation = X
		secondary_list += t_mutation.type

	var/datum/mutation/mutation = pick(secondary_list)
	carbon_mob.dna.remove_mutation(mutation)

/obj/structure/slime_crystal/green/on_mob_leave(mob/living/affected_mob)
	if(!iscarbon(affected_mob) || !affected_mob.has_dna())
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	carbon_mob.dna.remove_mutation(stored_mutation)

/obj/item/slimecross/crystalline/pink
	crystal_type = /obj/structure/slime_crystal/pink
	colour = SLIME_TYPE_PINK

/obj/structure/slime_crystal/pink
	colour = SLIME_TYPE_PINK

/obj/structure/slime_crystal/pink/on_mob_enter(mob/living/affected_mob)
	ADD_TRAIT(affected_mob, TRAIT_PACIFISM, type)

/obj/structure/slime_crystal/pink/on_mob_leave(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob, TRAIT_PACIFISM, type)

/obj/item/slimecross/crystalline/gold
	crystal_type = /obj/structure/slime_crystal/gold
	colour = SLIME_TYPE_GOLD

/obj/structure/slime_crystal/gold
	colour = SLIME_TYPE_GOLD

/obj/structure/slime_crystal/gold/process()
	var/list/current_mobs = get_valid_targets()
	for(var/M in affected_mobs - current_mobs)
		on_mob_leave(M)
		affected_mobs -= M

	for(var/mob/living/M in affected_mobs)
		if(M.stat == DEAD)
			on_mob_leave(M)
			affected_mobs -= M

/obj/structure/slime_crystal/gold/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(!istype(user))
		return

	var/mob/living/basic/pet/chosen_pet = pick(list(
		/mob/living/basic/pet/dog/corgi,
		/mob/living/basic/pet/dog/pug,
		/mob/living/basic/pet/dog/bullterrier,
		/mob/living/basic/pet/fox,
		/mob/living/basic/pet/cat/kitten,
		/mob/living/basic/pet/cat/space,
		/mob/living/basic/pet/penguin/emperor,
	))
	chosen_pet = new chosen_pet(get_turf(user))
	chosen_pet.apply_status_effect(/datum/status_effect/shapechange_mob, user, user)
	affected_mobs += chosen_pet

/obj/structure/slime_crystal/gold/on_mob_leave(mob/living/affected_mob)
	affected_mob.remove_status_effect(/datum/status_effect/shapechange_mob)

/obj/item/slimecross/crystalline/oil
	crystal_type = /obj/structure/slime_crystal/oil
	colour = SLIME_TYPE_OIL

/obj/structure/slime_crystal/oil
	colour = SLIME_TYPE_OIL

/obj/structure/slime_crystal/oil/process()
	for(var/turf/open/turf_in_range in RANGE_TURFS(3,src))
		turf_in_range.MakeSlippery(TURF_WET_LUBE,5 SECONDS)

/obj/item/slimecross/crystalline/black
	crystal_type = /obj/structure/slime_crystal/black
	colour = SLIME_TYPE_BLACK

/obj/structure/slime_crystal/black
	colour = SLIME_TYPE_BLACK

/obj/structure/slime_crystal/black/on_mob_effect(mob/living/affected_mob)
	if(!ishuman(affected_mob) || isjellyperson(affected_mob))
		return

	if(affected_mobs[affected_mob] < 60) //Around 2 minutes
		return

	var/mob/living/carbon/human/human_transformed = affected_mob
	human_transformed.set_species(pick(subtypesof(/datum/species/jelly)))

/obj/item/slimecross/crystalline/lightpink
	crystal_type = /obj/structure/slime_crystal/lightpink
	colour = SLIME_TYPE_LIGHT_PINK

/obj/structure/slime_crystal/lightpink
	colour = SLIME_TYPE_LIGHT_PINK

/mob/living/basic/lightgeist/slime
	name = "crystalline lightgeist"

/obj/structure/slime_crystal/lightpink/attack_ghost(mob/user)
	. = ..()
	var/mob/living/basic/lightgeist/slime/L = new(get_turf(src))
	L.ckey = user.ckey
	affected_mobs[L] = 0
	ADD_TRAIT(L, TRAIT_MUTE, type)
	ADD_TRAIT(L, TRAIT_EMOTEMUTE, type)

/obj/structure/slime_crystal/lightpink/on_mob_leave(mob/living/affected_mob)
	if(istype(affected_mob, /mob/living/basic/lightgeist/slime))
		affected_mob.ghostize(TRUE)
		qdel(affected_mob)

/obj/item/slimecross/crystalline/adamantine
	crystal_type = /obj/structure/slime_crystal/adamantine
	colour = SLIME_TYPE_ADAMANTINE

/obj/structure/slime_crystal/adamantine
	colour = SLIME_TYPE_ADAMANTINE

/obj/structure/slime_crystal/adamantine/on_mob_enter(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/human = affected_mob
	human.physiology.damage_resistance += 10

/obj/structure/slime_crystal/adamantine/on_mob_leave(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/human = affected_mob
	human.physiology.damage_resistance -= 10

/obj/item/slimecross/crystalline/rainbow
	crystal_type = /obj/structure/slime_crystal/rainbow
	colour = SLIME_TYPE_RAINBOW

/obj/structure/slime_crystal/rainbow
	colour = SLIME_TYPE_RAINBOW
	uses_process = FALSE
	var/list/inserted_cores = list()

/obj/structure/slime_crystal/rainbow/Initialize(mapload)
	. = ..()
	for(var/X in subtypesof(/obj/item/slimecross/crystalline) - /obj/item/slimecross/crystalline/rainbow)
		inserted_cores[X] = FALSE

/obj/structure/slime_crystal/rainbow/attacked_by(obj/item/slimecross/crystalline/slimecross, mob/living/user)
	. = ..()
	if(!istype(slimecross) || istype(slimecross, /obj/item/slimecross/crystalline/rainbow))
		return

	if(inserted_cores[slimecross.type])
		return

	inserted_cores[slimecross.type] = new slimecross.crystal_type(get_turf(src), src)
	qdel(slimecross)

/obj/structure/slime_crystal/rainbow/Destroy()
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.master_crystal_destruction()
	return ..()

/obj/structure/slime_crystal/rainbow/attack_hand(mob/user, list/modifiers)
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.attack_hand(user)
	return ..()

/obj/structure/slime_crystal/rainbow/attacked_by(obj/item/I, mob/living/user)
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.attacked_by(user)
	return ..()
