/datum/quirk/winged
	name = "Functional Wings"
	desc = "Your wings are not just for show, fly and hover with ease!"
	icon = FA_ICON_FEATHER
	value = 10
	//mob_trait = TRAIT_MOVE_FLYING
	gain_text = span_notice("You feel like the sky's the limit!")
	lose_text = span_danger("You feel a little bit more grounded.")
	medical_record_text = "Patient excels at aerial movement."
	mail_goodies = list(/obj/item/storage/fancy/nugget_box)

/datum/quirk/winged/add_unique(client/client_source)
	. = ..()
	var/obj/item/organ/wings/functional/gizzard/gizzard = new()
	gizzard.mob_insert(quirk_holder)
