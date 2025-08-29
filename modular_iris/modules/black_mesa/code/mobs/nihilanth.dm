/**
 * Nihilanth - The final boss of Black Mesa
 *
 * A massive floating entity that serves as the master of the Xen forces.
 * Uses powerful ranged attacks and becomes more desperate as its health decreases.
 */
/mob/living/basic/hostile/blackmesa/xen/nihilanth
	name = "nihilanth"
	desc = "Holy shit."
	COOLDOWN_DECLARE(voice_cooldown)
	icon = 'modular_iris/modules/black_mesa/icons/nihilanth.dmi'
	icon_state = "nihilanth"
	icon_living = "nihilanth"
	SET_BASE_PIXEL(-32, -32)
	base_pixel_x = -32
	base_pixel_y = -32
	bound_height = 64
	bound_width = 64
	bound_x = -16  // Center the 64-pixel hitbox
	bound_y = -16
	density = TRUE
	move_resist = INFINITY  // Can't be pushed or pulled
	icon_dead = "bullsquid_dead"
	maxHealth = 3000
	health = 3000
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_verb_continuous = "lathes"
	attack_verb_simple = "lathe"
	attack_sound = 'sound/items/weapons/punch1.ogg'
	status_flags = NONE
	basic_mob_flags = DEL_ON_DEATH
	ai_controller = /datum/ai_controller/basic_controller/nihilanth

	/// Items to drop on death
	var/static/list/death_loot = list(
		/obj/effect/gibspawner/xeno = 1,
		/obj/item/stack/sheet/bluespace_crystal/fifty = 1,
		/obj/item/key/gateway = 1,
		/obj/item/uber_teleporter = 1
	)

/obj/item/stack/sheet/bluespace_crystal/fifty
	amount = 50

/obj/projectile/nihilanth
	name = "portal energy"
	icon_state = "seedling"
	damage = 20
	damage_type = BURN
	light_range = 2
	armor_flag = ENERGY
	light_color = LIGHT_COLOR_BRIGHT_YELLOW
	hitsound = 'sound/items/weapons/sear.ogg'
	hitsound_wall = 'sound/items/weapons/effects/searwall.ogg'
	nondirectional_sprite = TRUE

/mob/living/basic/hostile/blackmesa/xen/nihilanth/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/death_drops, death_loot)
	AddElement(/datum/element/simple_flying)
	RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(on_death), override = TRUE)
	AddComponent(\
		/datum/component/ranged_attacks,\
		projectile_type = /obj/projectile/nihilanth,\
		projectile_sound = 'sound/items/weapons/lasercannonfire.ogg',\
		cooldown_time = 3 SECONDS,\
		burst_shots = 1\
	)

/// Called when nihilanth dies - play death sound
/mob/living/basic/hostile/blackmesa/xen/nihilanth/proc/on_death(datum/source)
	SIGNAL_HANDLER
	playsound(src, pick(list(
		'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_pain01.ogg',
		'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_freeeemmaan01.ogg'
	)), 100)

/mob/living/basic/hostile/blackmesa/xen/nihilanth/play_attack_sound(damage_amount, damage_type, damage_flag)
	if(COOLDOWN_FINISHED(src, voice_cooldown))
		var/sound_to_play
		switch(health)
			if(0 to 999)
				sound_to_play = pick(list(
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_pain01.ogg',
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_freeeemmaan01.ogg'
				))
			if(1000 to 2999)
				sound_to_play = pick(list(
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_youalldie01.ogg',
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_foryouhewaits01.ogg'
				))
			if(3000 to 6000)
				sound_to_play = pick(list(
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_whathavedone01.ogg',
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_deceiveyou01.ogg'
				))
			else
				sound_to_play = pick(list(
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_thetruth01.ogg',
					'modular_iris/modules/black_mesa/sound/mobs/nihilanth/nihilanth_iamthelast01.ogg'
				))
		playsound(src, sound_to_play, 100)
		COOLDOWN_START(src, voice_cooldown, 3 SECONDS)

/**
 * AI controller for the Nihilanth boss mob
 *
 * Handles ranged combat behavior and targeting
 */
/datum/ai_controller/basic_controller/nihilanth
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_RANGED_SKIRMISH_MIN_DISTANCE = 3,
		BB_RANGED_SKIRMISH_MAX_DISTANCE = 5,
		BB_MAX_PATHING_ATTEMPTS = 2,
		BB_TARGETING_TIMEOUT = 30 SECONDS // Don't waste time searching if no targets found
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/ranged_skirmish,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper,
		/datum/ai_planning_subtree/target_retaliate
	)
