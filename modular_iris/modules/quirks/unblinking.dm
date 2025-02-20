/datum/quirk/unblinking
	name = "Unblinking"
	desc = "For whatever reason, you are unable to blink and cannot wink either. Perhaps your eyes are lidless, self-hydrating, or ornamental."
	icon = FA_ICON_FACE_FLUSHED //closest thing I could find to a stare
	value = 0
	gain_text = span_notice("You no longer feel the need to blink.")
	lose_text = span_notice("You feel the need to blink again.")
	medical_record_text = "Patient does not need to blink."
	mob_trait = TRAIT_NO_EYELIDS //also prevents eye-shutting in knockout and death

/datum/quirk/unblinking/add_unique(client/client_source)
	. = ..()
	var/obj/item/organ/eyes/eyes = quirk_holder.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	eyes.blink_animation = FALSE
	if(eyes.eyelid_left)
		QDEL_NULL(eyes.eyelid_left)
	if(eyes.eyelid_right)
		QDEL_NULL(eyes.eyelid_right)
