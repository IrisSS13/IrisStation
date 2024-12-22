//Subtype for use in augments
/obj/item/organ/lungs/fish/no_overlay
	name = "gills"
	desc = "An aquatic-adapted respiratory organ that requires its host to breathe water vapor, or keep themselves covered in water."

/obj/item/organ/lungs/fish/no_overlay/on_bodypart_insert(obj/item/bodypart/limb)
	. = ..()
	if(gills)
		limb.remove_bodypart_overlay(gills)

//Subtype for use in augments
/obj/item/organ/lungs/fish/amphibious/no_overlay
	name = "semi-aquatic lungs"
	desc = "A set of semi-aquatic lungs, formerly owned by some hapless amphibian. Enjoy breathing underwater without drowning outside water."
