/datum/quirk/extra_sensory_paranoia
	name = "Extra-Sensory Paranoia"
	desc = "You feel like something wants to kill you..."
	mob_trait = TRAIT_PARANOIA
	value = -8
	icon = FA_ICON_GHOST

/datum/quirk/extra_sensory_paranoia/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(ishuman(human_holder))
		human_holder.gain_trauma(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/extra_sensory_paranoia/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(ishuman(human_holder))
		human_holder.cure_trauma_type(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_ABSOLUTE)
