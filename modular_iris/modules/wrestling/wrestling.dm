/mob/living/carbon/human
	var/is_wrestling = FALSE
	var/mob/living/carbon/human/wrestled_mob = null
	var/datum/component/wrestle_tackling = null

/mob/living/carbon/human/proc/user_toggle_wrestling()
	if(stat != CONSCIOUS)
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

	if(!is_wrestling)
		exit_wrestling_stance()

	visible_message(span_danger("[src] begins to assume a wrestling stance..."))
	if(do_after(src, 1.5 SECONDS))
		if(get_num_held_items() >= 1)
			to_chat(src, span_warning("You quickly empty your hands in order to wrestle!"))
			drop_all_held_items()

		if(!istype(get_item_by_slot(ITEM_SLOT_GLOVES), /obj/item/clothing/gloves/tackler))
			wrestle_tackling = src.AddComponent(/datum/component/tackler, stamina_cost = 40, base_knockdown = 1 SECONDS, range = 2, speed = 1, skill_mod = -1, min_distance = 0)

		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(exit_wrestling_stance(involuntary = TRUE)))
		RegisterSignal(src, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(exit_wrestling_stance(involuntary = TRUE)))
		RegisterSignal(src, COMSIG_MOB_LOGOUT, PROC_REF(exit_wrestling_stance(involuntary = TRUE))) //to prevent infinite grapple fuckery

		is_wrestling = current_state
		visible_message(span_danger("[src] has assumed a wrestling stance!"))
		log_message("<font color='cyan'>[src] has entered a wrestling stance!</font>", LOG_ATTACK)

		if(!combat_indicator)
			set_combat_indicator()

/mob/living/carbon/human/proc/exit_wrestling_stance(involuntary = FALSE)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(src, COMSIG_MOB_UNEQUIPPED_ITEM)
	UnregisterSignal(src, COMSIG_MOB_LOGOUT)

	if(wrestle_tackling)
		QDEL_NULL(wrestle_tackling)

	is_wrestling = FALSE
	if(involuntary)
		log_message("<font color='cyan'>[src] has been forced out of [src.p_their()] wrestling stance!</font>", LOG_ATTACK)
	else
		log_message("<font color='cyan'>[src] has voluntarily exited [src.p_their()] wrestling stance!</font>", LOG_ATTACK)
	visible_message(span_danger("[src] is no longer in a wrestling stance!"))
