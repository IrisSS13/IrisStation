/obj/item/organ/eyes/diona
	name = "receptor node"
	desc = "A combination of plant matter and neurons used to produce visual feedback."
	icon_state = "diona_eyeballs"
	organ_flags = ORGAN_UNREMOVABLE
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/organ/tongue/diona
	name = "diona tongue"
	desc = "It's an odd tongue, seemingly made of plant matter."
	icon_state = "diona_tongue"
	say_mod = "rustles"
	ask_mod = "quivers"
	yell_mod = "shrieks"
	exclaim_mod = "ripples"
	disliked_food = DAIRY | FRUIT | GRAIN | CLOTH | VEGETABLES
	liked_food = MEAT | RAW

/obj/item/organ/brain/diona
	name = "diona nymph"
	desc = "A small mass of roots and plant matter, it looks to be moving."
	icon_state = "diona_brain"
	decoy_override = TRUE

/obj/item/organ/brain/diona/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if(special)
		return
	organ_owner.dna.species.spec_death(FALSE, src)
	QDEL_NULL(src)

/obj/item/organ/liver/diona
	name = "liverwort"
	desc = "A mass of plant vines and leaves, seeming to be responsible for chemical digestion."
	icon_state = "diona_liver"

/obj/item/organ/lungs/diona
	name = "diona leaves"
	desc = "A small mass concentrated leaves, used for breathing."
	icon_state = "diona_lungs"

/obj/item/organ/stomach/diona
	name = "nutrient vessel"
	desc = "A group of plant matter and vines, useful for digestion of light and radiation."
	icon_state = "diona_stomach"

/obj/item/organ/ears/diona
	name = "trichomes"
	icon_state = "diona_ears"
	desc = "A pair of plant matter based ears."

/obj/item/organ/heart/diona
	name = "polypment segment"
	desc = "A segment of plant matter that is resposible for pumping nutrients around the body."
	icon_state = "diona_heart"
