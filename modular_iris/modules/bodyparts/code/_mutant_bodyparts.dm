//Used to add choiced footprint sprites on people
/obj/item/bodypart/leg/on_adding(mob/living/carbon/new_owner)
	. = ..()
	var/mob/living/carbon/human/human_owner = new_owner
	if(istype(human_owner) && human_owner.footprint_sprite)
		footprint_sprite = human_owner.footprint_sprite
