/**
 * Bullsquid (/mob/living/basic/blackmesa/xen/bullsquid)
 * An aggressive alien creature from Xen that uses both melee and ranged attacks.
 *
 * A hostile mob that switches between biting nearby targets and spitting acid at distant ones.
 * Uses standard melee attacks when adjacent and acid spit when at range.
 * Each bullsquid is hostile to other bullsquids, creating organic free-for-all combat.
 */
/mob/living/basic/blackmesa/xen/bullsquid
	name = "bullsquid"
	desc = "Some highly aggressive alien creature. Thrives in toxic environments."
	icon = 'modular_iris/modules/black_mesa/icons/mobs.dmi'
	icon_state = "bullsquid"
	icon_living = "bullsquid"
	icon_dead = "bullsquid_dead"

	// Health and combat
	maxHealth = 110
	health = 110
	melee_damage_lower = 15
	melee_damage_upper = 18
	obj_damage = 50
	combat_mode = TRUE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'modular_iris/modules/black_mesa/sound/mobs/bullsquid/attack1.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)

	// Mob traits
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	basic_mob_flags = FLAMMABLE_MOB
	unsuitable_cold_damage = 15
	unsuitable_heat_damage = 15
	speak_emote = list("growls")

	// AI and behavior
	ai_controller = /datum/ai_controller/basic_controller/bullsquid
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("bullsquid") // Each bullsquid is its own faction to make them fight each other

	alert_sounds = list(
		'modular_iris/modules/black_mesa/sound/mobs/bullsquid/detect1.ogg',
		'modular_iris/modules/black_mesa/sound/mobs/bullsquid/detect2.ogg',
		'modular_iris/modules/black_mesa/sound/mobs/bullsquid/detect3.ogg'
	)

/mob/living/basic/blackmesa/xen/bullsquid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_listen_to_weather)
	// Add ranged attack component with proper targeting
	AddComponent(/datum/component/ranged_attacks, projectile_type = /obj/projectile/bullsquid, projectile_sound = 'modular_iris/modules/black_mesa/sound/mobs/bullsquid/goo_attack3.ogg', cooldown_time = 3 SECONDS)
	// Make each bullsquid unique to fight each other
	faction = list("[REF(src)]")

/datum/ai_controller/basic_controller/bullsquid
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_BASIC_MOB_MELEE_ATTACK_RANGE = 1,
		BB_BASIC_MOB_CURRENT_TARGET = null,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/bullsquid_attack,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/// Handles the bullsquid's acid spit attack based on distance.
/// Works alongside basic_melee_attack_subtree which handles biting.
/datum/ai_planning_subtree/bullsquid_attack
	COOLDOWN_DECLARE(acid_cooldown)
	/// Time between acid spit attacks
	var/acid_cooldown_time = 3 SECONDS
	/// Minimum range before we'll try to spit acid
	var/min_spit_range = 2
	/// Maximum range at which we can spit acid
	var/max_spit_range = 6

/datum/ai_planning_subtree/bullsquid_attack/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return

	var/mob/living/basic/blackmesa/xen/bullsquid/pawn = controller.pawn
	if(QDELETED(pawn))
		return

	var/distance = get_dist(pawn, target)

	// Let basic_melee_attack_subtree handle melee range combat
	if(distance <= 1)
		return

	// Try acid spit if in valid range and attack is ready
	if(distance >= min_spit_range && distance <= max_spit_range && COOLDOWN_FINISHED(src, acid_cooldown))
		controller.queue_behavior(/datum/ai_behavior/basic_ranged_attack, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETING_STRATEGY)
		COOLDOWN_START(src, acid_cooldown, acid_cooldown_time)

/obj/item/ammo_casing/bullsquid
	name = "nasty ball of ooze"
	projectile_type = /obj/projectile/bullsquid

/obj/projectile/bullsquid
	name = "nasty ball of ooze"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = BURN
	knockdown = 20
	armor_flag = BIO
	impact_effect_type = /obj/effect/temp_visual/impact_effect/neurotoxin
	hitsound = 'modular_iris/modules/black_mesa/sound/mobs/bullsquid/splat1.ogg'
	hitsound_wall = 'modular_iris/modules/black_mesa/sound/mobs/bullsquid/splat1.ogg'
	pass_flags = PASSTABLE
	speed = 0.8

/// Creates toxic residue where the projectile hits
/obj/projectile/bullsquid/on_hit(atom/target, blocked = 0, pierce_hit)
	new /obj/effect/decal/cleanable/greenglow(target.loc)
	return ..()
