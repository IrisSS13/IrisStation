/mob/living
	var/is_wrestling = FALSE
	var/mob/living/wrestled_mob = null

/mob/living/proc/user_toggle_wrestling()
	if(stat != CONSCIOUS)
		return
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("Wrestling could hurt someone."))
		return
	set_wrestling_stance(!is_wrestling)

/mob/living/proc/set_wrestling_stance(current_state)
	if(!CONFIG_GET(flag/wrestling_stance))
		return

	if(is_wrestling == current_state)
		return

	if(stat == DEAD)
		disable_wrestling_stance(involuntary)

	visible_message(span_danger("[src] begins to assume a wrestling stance..."))
	if(do_after(src, 1.5 SECONDS))
		if(get_num_held_items() >= 1)
			to_chat(src, span_warning("You quickly empty your hands in order to wrestle!"))
			drop_all_held_items()
		is_wrestling = current_state
		visible_message(span_danger("[src] has assumed a wrestling stance!"))

	SEND_SIGNAL(src, COMSIG_MOB_CI_TOGGLED)

	if(combat_indicator)
		enable_combat_indicator()
	else
		disable_combat_indicator()
