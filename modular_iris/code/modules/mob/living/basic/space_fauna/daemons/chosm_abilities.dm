// Basic Membrane
/datum/action/cooldown/mob_cooldown/lay_membrane
	name = "Produce Membrane"
	desc = "Produce a membraneous film. Spread its influence."
	button_icon = 'icons/mob/actions/actions_animal.dmi' // change
	button_icon_state = "spider_web"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	cooldown_time = 0 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE
	click_to_activate = FALSE
	/// How long it takes to produce Membrane
	var/webbing_time = 4 SECONDS

/datum/action/cooldown/mob_cooldown/lay_membrane/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	ADD_TRAIT(owner, TRAIT_WEB_WEAVER, REF(src))
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/mob_cooldown/lay_membrane/Remove(mob/removed_from)
	. = ..()
	REMOVE_TRAIT(removed_from, TRAIT_WEB_WEAVER, REF(src))
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/mob_cooldown/lay_membrane/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(HAS_TRAIT(owner.loc, TRAIT_SPINNING_WEB_TURF))
		if (feedback)
			owner.balloon_alert(owner, "already being produced!")
		return FALSE
	if(obstructed_by_other_membrane())
		if (feedback)
			owner.balloon_alert(owner, "already influenced!")
		return FALSE
	return TRUE

/// Returns true if there's a membrane we can't put stuff on in our turf
/datum/action/cooldown/mob_cooldown/lay_membrane/proc/obstructed_by_other_membrane()
	return !!(locate(/obj/structure/chosm/membrane) in get_turf(owner))

/datum/action/cooldown/mob_cooldown/lay_membrane/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner) // Try to change spider_turf maybe? Oh god
	var/obj/structure/chosm/membrane/membrane = locate() in spider_turf // Changed 'web' to 'membrane' here
	if(membrane)
		owner.balloon_alert_to_viewers("sealing web...") // Remove
	else
		owner.balloon_alert_to_viewers("spooling membrane...")
	ADD_TRAIT(spider_turf, TRAIT_SPINNING_WEB_TURF, REF(src))
	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_web(spider_turf, membrane)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	REMOVE_TRAIT(spider_turf, TRAIT_SPINNING_WEB_TURF, REF(src))
	build_all_button_icons()

/// Creates a web in the current turf
/datum/action/cooldown/mob_cooldown/lay_membrane/proc/plant_web(turf/target_turf, obj/structure/chosm/membrane/existing_web) // Change plant_web? // Change existing_web?
	new /obj/structure/chosm/membrane(target_turf)

// The actual membrane itself
/datum/action/cooldown/mob_cooldown/lay_membrane/sinuous_tissue
	name = "Spool Sinuous Tissue"
	desc = "Spool a thick membrane. Spread the Chosm's influence."
	button_icon_state = "spider_ropes" // change
	cooldown_time = 5 SECONDS
	webbing_time = 3 SECONDS

// Ranged hook attack for Scion, extremely long cooldown.
/datum/action/cooldown/spell/pointed/projectile/chosmhook
	name = "chosm hook"
	desc = "Launch at your prey to pull them in closer."
	button_icon = 'modular_nova/modules/spider/icons/abilities.dmi'
	button_icon_state = "webhook"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"

	cooldown_time = 3 MINUTES
	spell_requirements = NONE

	active_msg = "You prepare to launch a chosm hook at your target!"
	cast_range = 8
	projectile_type = /obj/projectile/hook/chosm

// chosm hook projectile, keeps every but subtypes the icons
/obj/projectile/hook/chosm
	name = "chosmhook"
	icon_state = "hook" // Okay so the way the original web-hook was made is upsettingly off-set. Im pretty sure I'd have to just align them properly to fix it,
	// But god that would suck to go back and do. Also the code might just misalign it anyways. Fuck.
	icon = 'modular_iris/modules/daemons/icons/chosm_abilities.dmi'
	chain_icon = 'modular_iris/modules/daemons/icons/chosm_abilities.dmi'
	projectile_phasing =  PASSTABLE | PASSGRILLE | PASSSTRUCTURE // THIS IS VITAL TO ENSURE IT DOESN'T HIT THE MEMBRANE



// Scion Ranged Projectile
/datum/action/cooldown/spell/pointed/projectile/chosm_spit
	name = "volatile essence"
	desc = "Launch at your prey to harm them."
	button_icon = 'modular_iris/icons/mob/simple/chosm_projectiles.dmi'
	button_icon_state = "volatile_essence"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

	active_msg = "You prepare to spit volatile essence at your target!"
	cast_range = 10
	projectile_type = /obj/projectile/volatile_essence

/obj/projectile/volatile_essence
	name = "volatile essence"
	icon = 'modular_iris/icons/mob/simple/chosm_projectiles.dmi'
	icon_state = "volatile_essence"
	damage = 20 // This is maybe too high. Needs extensive testing because of the potentially high fire-rate.
	// So this is basically to avoid hitting membrane before the person
	projectile_phasing =  PASSTABLE | PASSGRILLE | PASSSTRUCTURE
	reflectable = FALSE
	stutter = 8 SECONDS
	stamina = 10

// Fool Charge ability
/datum/action/cooldown/mob_cooldown/charge/basic_charge/chosm_charge
	name = "Chosmic Charge"
	cooldown_time = 3 SECONDS
	charge_delay = 0.5 SECONDS
	charge_distance = 6
	melee_cooldown_time = 0
	/// Amount of time to stun self upon impact
	recoil_duration = 0.3 SECONDS
	/// Amount of time to knock over an impacted target
	knockdown_duration = 1 SECONDS


// FUCK WHY AM I TRYING TO ADD THIS!!! KILL ME!!
// Update: This all worked first try. Which is terrifying. Might be severely broken.
// Create Membrane Nexus. This will NOT be used by anything because it is supposed to just be admin-spawned.
/datum/action/cooldown/mob_cooldown/lay_membrane/create_nexus
	name = "Create Nexus"
	desc = "Create a Chosm Nexus. Begin the Devouring."
	button_icon = 'modular_iris/modules/daemons/icons/chosm_nexus.dmi'
	cooldown_time = 5 SECONDS
	button_icon_state = "nexus"

/datum/action/cooldown/mob_cooldown/lay_membrane/create_nexus/vacant
	cooldown_time = 5 SECONDS

/datum/action/cooldown/mob_cooldown/lay_membrane/create_nexus/plant_web(turf/target_turf, obj/structure/chosm/membrane/existing_web)
	new /obj/structure/chosm/membrane/alive/chosm_nexus(target_turf) // TO BE VERY CLEAR THIS CODE IS SAYING WHAT THE NEXUS IS GOING TO CREATE.

// base web structure subtype, we wanna keep the web functions but make it so they can spread
/obj/structure/chosm/membrane/alive
	var/chosm_nexus_range = 10 // 10 Might be too much. We'll find out.
	///the parent node that will determine if we grow or die
	var/obj/structure/chosm/membrane/alive/chosm_nexus/parent_node
	///the list of turfs that the weeds will not be able to grow over
	var/static/list/blacklisted_turfs = list(
		/turf/open/space,
		/turf/open/chasm,
		/turf/open/lava,
		/turf/open/water,
		/turf/open/openspace,
	)

/obj/structure/chosm/membrane/alive/Initialize(mapload)
	. = ..()

/obj/structure/chosm/membrane/alive/Destroy()
	if(parent_node)
		UnregisterSignal(parent_node, COMSIG_QDELETING)
		parent_node = null
	return ..()

/**
 * Called when the chosm_nexus is trying to grow/expand
 */
/obj/structure/chosm/membrane/alive/proc/try_expand()
	//we cant grow without a parent spider_effigy
	if(!parent_node)
		return
	//lets make sure we are still on a valid location
	var/turf/src_turf = get_turf(src)
	if(is_type_in_list(src_turf, blacklisted_turfs))
		qdel(src)
		return
	//lets try to grow in a direction
	for(var/turf/check_turf in src_turf.get_atmos_adjacent_turfs())
		//we cannot grow on blacklisted turfs
		if(is_type_in_list(check_turf, blacklisted_turfs))
			continue
		var/obj/structure/chosm/membrane/alive/check_membrane = locate() in check_turf
		//we cannot grow onto other webs
		if(check_membrane)
			continue
		//spawn a new one in the turf
		check_membrane = new(check_turf)
		//set the new one's parent spider_effigy to our parent spider_effigy
		check_membrane.parent_node = parent_node

// This is the actual Nexus Object code. All of the above shit is growth/membrane code.
/obj/structure/chosm/membrane/alive/chosm_nexus
	name = "Unsettling plinth"
	desc = "A cylindrical plinth surrounded by sinuous membrane. Staring at it too long gives you a dizzying headache - As though it's tearing reality around it apart."
	icon = 'modular_iris/modules/daemons/icons/chosm_nexus.dmi'
	icon_state = "nexus"
	base_icon_state = "nexus"
	smoothing_flags = NONE
	smoothing_groups = NONE
	canSmoothWith = NONE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = TRUE
	light_range = 3
	light_color = COLOR_AMETHYST
	light_power = 0.5
	max_integrity = 900 // This survives 10+ Laser Carbine shots. Honestly not alot.
	anchored = TRUE
	plane = -1
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD // Reflector code
	receive_ricochet_chance_mod = INFINITY
	var/mob_types = list(/mob/living/basic/daemons/chosm_entities/vacant/drudge, /mob/living/basic/daemons/chosm_entities/vacant/scion, /mob/living/basic/daemons/chosm_entities/vacant/fool)
	var/obj/effect/abstract/particle_holder/spooky_particles
	///the minimum time it takes for another weed to spread from this one
	var/minimum_growtime = 5 SECONDS
	///the maximum time it takes for another weed to spread from this one
	var/maximum_growtime = 10 SECONDS
	//the cooldown between each growth
	COOLDOWN_DECLARE(growtime)

// Assign the boi as the parent
/obj/structure/chosm/membrane/alive/chosm_nexus/Initialize(mapload)
	. = ..()
	//we are the parent chosm_nexus
	parent_node = src
	pixel_x = 0
	pixel_y = 0
	add_filter("Nexus", 2, list("type" = "outline", "color" = "#c72424ff", "size" = 0.12))
	var/filter = get_filter("Nexus")
	animate(filter, alpha = 230, time = 2 SECONDS, loop = -1)
	animate(alpha = 30, time = 0.5 SECONDS)
	// Spawner bullshit
	AddComponent(/datum/component/spawner, \
		spawn_types = mob_types, \
		spawn_time = 60 SECONDS, \
		max_spawned = 5, \
		faction = list(FACTION_NETHER) , \
		spawn_text = "Something wicked emerges from", \
		spawn_callback = CALLBACK(src, PROC_REF(on_mob_spawn)), \
	)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/chosm/membrane/alive/chosm_nexus/proc/on_mob_spawn(atom/created_atom)
	return

/obj/structure/chosm/membrane/alive/chosm_nexus/on_mob_spawn(atom/created_atom)
	created_atom.AddComponent(\
		/datum/component/ghost_direct_control,\
		role_name = "A Chosm Entity",\
		assumed_control_message = null,\
		after_assumed_control = CALLBACK(src, PROC_REF(became_player_controlled)),\
		playsound(src.loc, 'modular_iris/sound/daemons/nexus_emergence.ogg', 50, TRUE), \
	)

/obj/structure/chosm/membrane/alive/chosm_nexus/proc/became_player_controlled(mob/proteon)
	return


// we do this in LateInitialize() because membrane on the same loc may not be done initializing yet (as in create_and_destroy)
/obj/structure/chosm/membrane/alive/chosm_nexus/LateInitialize()
	//destroy any non-chosm_nexus membranes on turf
	var/obj/structure/chosm/membrane/alive/check_membrane = locate(/obj/structure/chosm/membrane/alive) in loc
	if(check_membrane && check_membrane != src)
		qdel(check_membrane)

	//start the cooldown
	COOLDOWN_START(src, growtime, rand(minimum_growtime, maximum_growtime))

	//start processing
	START_PROCESSING(SSobj, src)

/obj/structure/chosm/membrane/alive/chosm_nexus/process()
	//we need to have a cooldown, so check and then add
	if(!COOLDOWN_FINISHED(src, growtime))
		return
	COOLDOWN_START(src, growtime, rand(minimum_growtime, maximum_growtime))
	//attempt to grow all webs in range
	for(var/obj/structure/chosm/membrane/alive/growing_membrane in range(chosm_nexus_range, src))
		growing_membrane.try_expand()




/datum/action/cooldown/mob_cooldown/lay_membrane/create_cyst
	name = "Create Cyst"
	desc = "Create a Chosm Cyst. Spread the Devouring."
	button_icon = 'modular_iris/modules/daemons/icons/chosm_nexus.dmi'
	cooldown_time = 5 MINUTES
	button_icon_state = "cyst"

/datum/action/cooldown/mob_cooldown/lay_membrane/create_cyst/vacant
	cooldown_time = 5 MINUTES

/datum/action/cooldown/mob_cooldown/lay_membrane/create_cyst/plant_web(turf/target_turf, obj/structure/chosm/membrane/existing_web)
	new /obj/structure/chosm/membrane/alive/chosm_nexus/chosm_cyst(target_turf) // TO BE VERY CLEAR THIS CODE IS SAYING WHAT THE NEXUS IS GOING TO CREATE.


// This is the actual Nexus Object code. All of the above shit is growth/membrane code.
/obj/structure/chosm/membrane/alive/chosm_nexus/chosm_cyst
	name = "Unsettling cyst"
	desc = "A cylindrical plinth surrounded by sinuous membrane. Staring at it too long gives you a dizzying headache - As though it's tearing reality around it apart."
	icon = 'modular_iris/modules/daemons/icons/chosm_nexus.dmi'
	icon_state = "cyst"
	base_icon_state = "cyst"
	smoothing_flags = NONE
	smoothing_groups = NONE
	canSmoothWith = NONE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = TRUE
	light_range = 3
	light_color = COLOR_AMETHYST
	light_power = 0.5
	max_integrity = 300 // Much weaker than the Nexus for obvious reasons
	anchored = TRUE
	plane = -1
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD // Reflector code
	receive_ricochet_chance_mod = INFINITY
	mob_types = null
	///the minimum time it takes for another weed to spread from this one
	minimum_growtime = 20 SECONDS
	///the maximum time it takes for another weed to spread from this one
	maximum_growtime = 30 SECONDS
	//the cooldown between each growth


/obj/structure/chosm/membrane/alive/chosm_nexus/Destroy()
	playsound(src.loc, 'modular_iris/sound/daemons/cyst_death.ogg', 50, TRUE)
	return ..()
