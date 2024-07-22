#define PERSONAL_SPACE_DAMAGE 2

// Emotes
/mob/living/carbon/disarm(mob/living/carbon/target)
	if(zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/target_on_help_and_unarmed = !target.combat_mode && !target.get_active_held_item()
		if(target_on_help_and_unarmed || HAS_TRAIT(target, TRAIT_RESTRAINED))
			do_slap_animation(target)
			playsound(target.loc, 'sound/weapons/slap.ogg', 50, TRUE, -1)
			visible_message("<span class='danger'>[src] slaps [target] in the face!</span>",
				"<span class='notice'>You slap [target] in the face! </span>",\
			"You hear a slap.")
			target.unwag_tail()
			return
	return ..()

#undef PERSONAL_SPACE_DAMAGE
#undef ASS_SLAP_EXTRA_RANGE
