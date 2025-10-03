/**
 * Headcrab (/mob/living/basic/blackmesa/xen/headcrab)
 * Parasitic alien that jumps at targets and can zombify humans.
 *
 * A classic Half-Life enemy that uses jumping attacks and can turn humans into zombies.
 * - Jumps at targets from range
 * - Can zombify unprotected humans on headshot
 * - Detaches from zombies on death with a chance to survive
 */
/mob/living/basic/blackmesa/xen/headcrab
	name = "headcrab"
	desc = "Don't let it latch onto your hea-... hey, that's kinda cool."
	icon = 'modular_iris/modules/black_mesa/icons/mobs.dmi'
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	base_icon_state = "headcrab"

	// Health and combat
	maxHealth = 50
	health = 50
	melee_damage_lower = 0  // No melee attacks, only jump attacks
	melee_damage_upper = 0
	combat_mode = TRUE

	// Mob traits
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	basic_mob_flags = NONE
	ai_controller = /datum/ai_controller/basic_controller/headcrab

	// Movement
	speed = 3
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK
	pixel_x = -8
	base_pixel_x = -8
	faction = list(FACTION_XEN) // Friendly to other Xen creatures
	can_be_shielded = FALSE  // Headcrabs don't use shield pylons

	// Spawning and loot
	gold_core_spawnable = HOSTILE_SPAWN
	butcher_results = list(
		/obj/item/stack/sheet/bone = 1
	)

	/// Maximum distance this headcrab can jump in tiles
	var/throw_at_range = 10

	/// Base speed at which this headcrab jumps (actual speed varies with distance)
	var/throw_at_speed = 2

	/// Track if we've attached to a human, to prevent multiple zombifications
	var/is_zombie = FALSE

/mob/living/basic/blackmesa/xen/headcrab
	alert_sounds = list('modular_iris/modules/black_mesa/sound/mobs/headcrab/alert1.ogg')

/mob/living/basic/blackmesa/xen/headcrab/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_IMPACT, PROC_REF(handle_impact))
	ai_controller.set_blackboard_key(BB_TARGET_MINIMUM_STAT, HARD_CRIT) // Allow targeting unconscious people

/// Execute the jump after the telegraph
/datum/ai_planning_subtree/headcrab_hunt/proc/execute_jump(mob/living/basic/blackmesa/xen/headcrab/jumper, atom/target, distance, speed)
	if(QDELETED(jumper) || QDELETED(target))
		return

	// Make it spin during the jump! The faster the jump, the faster the spin
	var/spin_speed = speed * 2
	jumper.throw_at(target, distance, speed, jumper, TRUE, TRUE, null, 0.1, FALSE, spin_speed)

/// Handle leap impacts
/mob/living/basic/blackmesa/xen/headcrab/proc/handle_impact(datum/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(!hit_atom || stat == DEAD)
		return
	if(!isliving(hit_atom))
		return

	playsound(src, 'modular_iris/modules/black_mesa/sound/mobs/headcrab/attack1.ogg', 100, FALSE)
	var/mob/living/hit_mob = hit_atom

	// More damage if we hit them at high speed
	var/damage = 8
	if(throwingdatum.speed >= 3)
		damage = 12

	hit_mob.apply_damage(damage, BRUTE)

	if(!ishuman(hit_atom))
		return

	var/mob/living/carbon/human/human_target = hit_atom

	// Regular damage if the target is conscious
	if(human_target.stat < UNCONSCIOUS)
		human_target.apply_damage(damage, BRUTE, BODY_ZONE_HEAD)
		return

	// Check for head protection on unconscious targets
	var/obj/item/clothing/head/head_protection = human_target.get_item_by_slot(ITEM_SLOT_HEAD)
	if(head_protection)
		head_protection.take_damage(15)
		return

	// Zombify unprotected unconscious targets
	if(zombify(human_target))
		// Visual and sound feedback
		playsound(src, 'modular_iris/modules/black_mesa/sound/mobs/headcrab/attack1.ogg', 100, FALSE)
		do_sparks(3, TRUE, human_target)

		// Log the zombification
		human_target.investigate_log("was zombified by [src] while unconscious.", INVESTIGATE_DEATHS)
		human_target.death(FALSE)

/mob/living/basic/blackmesa/xen/headcrab/death(gibbed)
	// Handle death sound if not gibbed
	if(!gibbed)
		playsound(src, pick(list(
			'modular_iris/modules/black_mesa/sound/mobs/headcrab/die1.ogg',
			'modular_iris/modules/black_mesa/sound/mobs/headcrab/die2.ogg'
		)), 100)
	return ..()

/// Transforms a human into a headcrab zombie
/mob/living/basic/blackmesa/xen/headcrab/proc/zombify(mob/living/carbon/human/target_human)
	// Sanity checks
	if(is_zombie || !target_human)
		return FALSE

	// Create the zombie at our location
	var/mob/living/basic/blackmesa/xen/headcrab_zombie/new_zombie = new(get_turf(src))
	new_zombie.name = "[target_human.name] zombie"

	// Copy the human's appearance
	target_human.set_hairstyle(null, update = FALSE)
	target_human.update_body_parts()
	new_zombie.copy_overlays(target_human)

	// Add the headcrab overlay
	var/mutable_appearance/blob_head_overlay = mutable_appearance('modular_iris/modules/black_mesa/icons/mobs.dmi', "headcrab_zombie")
	new_zombie.add_overlay(blob_head_overlay)

	// Store the human inside the zombie
	target_human.forceMove(new_zombie)
	new_zombie.zombified_human = target_human

	// If they have armor, apply it to the zombie
	var/obj/item/clothing/suit/armor/zombie_suit = target_human.wear_suit
	if(istype(zombie_suit))
		new_zombie.maxHealth += zombie_suit.get_armor_rating(MELEE) //That zombie's got armor, I want armor!
		new_zombie.health = new_zombie.maxHealth

	// Visual and sound feedback for zombie creation
	playsound(new_zombie, 'modular_iris/modules/black_mesa/sound/mobs/headcrab/attack1.ogg', 100, FALSE)
	visible_message(span_warning("The corpse of [target_human.name] suddenly rises, a headcrab controlling its lifeless body!"))

	// Delete the original headcrab
	qdel(src)
	return TRUE

/datum/ai_controller/basic_controller/headcrab
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/allow_items,
		BB_BASIC_MOB_CURRENT_TARGET = null,
		BB_BASIC_MOB_MELEE_ATTACK_RANGE = 0,  // No melee attacks
		BB_BASIC_MOB_CURRENT_TARGET_HIDING = FALSE,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT  // Allow targeting of unconscious people
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/headcrab_hunt
	)

/// Handles the headcrab's hunting behavior, trying to leap at targets when in range
/datum/ai_planning_subtree/headcrab_hunt
	/// Time between jump attempts
	var/jump_cooldown_time = 1 SECONDS  // Reduced cooldown for more frequent jumps
	COOLDOWN_DECLARE(jump_cooldown)

	/// Preferred range to start jumping
	var/preferred_jump_range = 4
	/// Maximum range at which we can leap
	var/max_jump_range = 10  // Increased range for better mobility

/datum/ai_planning_subtree/headcrab_hunt/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return

	var/mob/living/living_pawn = controller.pawn
	if(QDELETED(living_pawn))
		return

	if(!COOLDOWN_FINISHED(src, jump_cooldown))
		return

	var/distance = get_dist(living_pawn, target)

	// Always jump at target if in range
	if(distance <= max_jump_range)
		COOLDOWN_START(src, jump_cooldown, jump_cooldown_time)
		// Telegraph the jump with sound
		playsound(living_pawn, 'modular_iris/modules/black_mesa/sound/mobs/headcrab/attack2.ogg', 50, TRUE)

		// Calculate jump speed based on distance - faster at close range for better accuracy
		var/jump_speed = 3
		if(distance <= 3)
			jump_speed = 4 // Faster at close range
		else if(distance >= 7)
			jump_speed = 2 // Slower at long range

		addtimer(CALLBACK(src, PROC_REF(execute_jump), living_pawn, target, distance, jump_speed), 0.3 SECONDS)

/**
 * Fast Headcrab (/mob/living/basic/blackmesa/xen/headcrab/fast)
 * A variant of the standard headcrab that moves significantly faster.
 *
 * This version appears in later stages of Half-Life and represents a more dangerous variant.
 * - Moves much quicker than standard headcrabs
 * - Same jumping and zombification mechanics
 * - More dangerous due to increased mobility
 */
/mob/living/basic/blackmesa/xen/headcrab/fast
	speed = -2
	desc = "Don't let it latch onto your hea-... hey, that's kinda cool. This one looks faster than usual."
