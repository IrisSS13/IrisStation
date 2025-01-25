/mob/living/carbon/human
	/// Used for footstep type pref, to apply to any new legs that get added to this mob. Uses a var instead of checking prefs because there are a lot of clientless mob situations.
	var/footstep_type

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	mob_examine_panel = new(src) //create the datum

/mob/living/carbon/human/Destroy()
	QDEL_NULL(mob_examine_panel)
	return ..()


// so the lewd straight jacket behaves (and because the reason behind this is /too/ lewd for upstream) - also allows for more downstream freedom
/mob/living/carbon/human/resist_restraints()
	if(wear_suit?.breakouttime)
		changeNext_move(wear_suit.resist_cooldown)
		last_special = world.time + wear_suit.resist_cooldown
		cuff_resist(wear_suit)
	else
		return ..()
