#define WRESTLING_STANCE_TRAIT "wrestling_stance"

/*
	WRESTLING STANCE
*/

/mob/living/carbon/human
	var/is_wrestling = FALSE
	var/mob/living/carbon/human/wrestled_mob = null
	var/datum/component/wrestle_tackling = null

/mob/living/carbon/human/proc/user_toggle_wrestling()
	if(stat != CONSCIOUS)
		return
	if(resting)
		return
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("Wrestling could hurt someone."))
		return
	set_wrestling_stance(!is_wrestling)

/mob/living/carbon/human/proc/set_wrestling_stance(current_state)
	if(!CONFIG_GET(flag/wrestling_stance))
		return

	if(is_wrestling == current_state)
		return

	if(stat != CONSCIOUS)
		exit_wrestling_stance(involuntary = TRUE)

	if(is_wrestling)
		exit_wrestling_stance()

	visible_message(span_danger("[src] begins to assume a wrestling stance..."))
	if(do_after(src, 1.5 SECONDS))
		var/held_item = get_active_held_item()
		if(held_item)
			to_chat(src, span_warning("You quickly empty your [IS_RIGHT_INDEX(active_hand_index) ? "right" : "left"] hand in order to wrestle!"))
			dropItemToGround(held_item)

		if(!istype(get_item_by_slot(ITEM_SLOT_GLOVES), /obj/item/clothing/gloves/tackler))
			var/tackle_range = 2
			if(HAS_TRAIT(src, TRAIT_FREERUNNING))
				tackle_range = 3
			wrestle_tackling = src.AddComponent(/datum/component/tackler, stamina_cost = 40, base_knockdown = 1 SECONDS, range = tackle_range, speed = 1, skill_mod = -1, min_distance = 0)

		ADD_TRAIT(src, TRAIT_STRONG_GRABBER, WRESTLING_STANCE_TRAIT)

		RegisterSignals(src, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_UPDATED_RESTING, COMSIG_MOB_LOGOUT), PROC_REF(exit_stance_wrapper), TRUE)

		is_wrestling = current_state
		visible_message(span_danger("[src] has assumed a wrestling stance!"))
		log_message("<font color='cyan'>[src] has entered a wrestling stance!</font>", LOG_ATTACK)

		if(!combat_indicator)
			set_combat_indicator(TRUE)

/mob/living/carbon/human/proc/exit_wrestling_stance(involuntary = FALSE)
	UnregisterSignal(src, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_UPDATED_RESTING, COMSIG_MOB_LOGOUT))

	if(wrestle_tackling)
		QDEL_NULL(wrestle_tackling)

	if(HAS_TRAIT_FROM(src, TRAIT_STRONG_GRABBER, WRESTLING_STANCE_TRAIT))
		REMOVE_TRAIT(src, TRAIT_STRONG_GRABBER, WRESTLING_STANCE_TRAIT)

	is_wrestling = FALSE
	if(involuntary)
		log_message("<font color='cyan'>[src] has been forced out of [src.p_their()] wrestling stance!</font>", LOG_ATTACK)
	else
		log_message("<font color='cyan'>[src] has voluntarily exited [src.p_their()] wrestling stance!</font>", LOG_ATTACK)
	visible_message(span_danger("[src] is no longer in a wrestling stance!"))

/mob/living/carbon/human/proc/exit_stance_wrapper()
	SIGNAL_HANDLER
	exit_wrestling_stance(involuntary = TRUE)

/*
	LEG LOCK ABILITY
*/

/mob/living/carbon/human/click_alt_secondary(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human_user = user
	if(human_user != src && human_user.combat_mode && !human_user.dna.species.try_leg_lock(user, src))
		return CLICK_ACTION_BLOCKING

/datum/species/proc/try_leg_lock(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target == user)
		return FALSE
	//check target is grabbed
	if(!grab_maneuver_state_check(user, target))
		return FALSE
	//check user has at least two functioning legs with which to grapple
	if(user.usable_legs < 2)
		user.balloon_alert(user, "need two working legs!")
		return FALSE
	//check target isn't already leg-locked
	if(HAS_TRAIT(target, TRAIT_LEG_LOCKED))
		target.balloon_alert(user, "already leg-locked!")
		return FALSE
	//check user is in wrestling stance
	if(!(user.is_wrestling))
		user.balloon_alert(user, "not wrestling!")
		return FALSE
	target.AddComponent(/datum/component/leg_locked, lock_source = user)

#undef WRESTLING_STANCE_TRAIT
