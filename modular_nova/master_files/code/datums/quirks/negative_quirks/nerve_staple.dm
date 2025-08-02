/datum/quirk/equipping/nerve_staple
	name = "Nerve Stapled"
	desc = "You're a pacifist. Not because you want to be, but because of the device stapled into your eye."
	value = -10 // pacifism = -8, losing eye slots = -2
	gain_text = span_danger("You suddenly can't raise a hand to hurt others!")
	lose_text = span_notice("You think you can defend yourself again.")
	medical_record_text = "Patient is nerve stapled and is unable to harm others."
	icon = FA_ICON_FACE_ANGRY
	// forced_items = list(/obj/item/clothing/glasses/nerve_staple = list(ITEM_SLOT_EYES))
	/// The nerve staple attached to the quirk
	var/obj/item/clothing/glasses/nerve_staple/staple

/datum/quirk/equipping/nerve_staple/on_equip_item(obj/item/equipped, successful)
	if (!istype(equipped, /obj/item/clothing/glasses/nerve_staple))
		return
	staple = equipped

/datum/quirk/equipping/nerve_staple/remove()
	. = ..()
	if (!staple || staple != quirk_holder.get_item_by_slot(ITEM_SLOT_EYES))
		return
	to_chat(quirk_holder, span_warning("The nerve staple suddenly falls off your face and melts[istype(quirk_holder.loc, /turf/open/floor) ? " on the floor" : ""]!"))
	qdel(staple)

// IRIS EDIT - adds a way to choose where the nerve staple goes

/datum/quirk_constant_data/nerve_staple
	associated_typepath = /datum/quirk/equipping/nerve_staple
	customization_options = list(/datum/preference/choiced/nerve_staple_choice)

/datum/preference/choiced/nerve_staple_choice
	savefile_key = "nerve_staple_choice"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED

/datum/preference/choiced/nerve_staple_choice/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return "Nerve Stapled" in preferences.all_quirks

/datum/preference/choiced/nerve_staple_choice/init_possible_values()
	var/list/values = list("Right Eye", "Left Eye")
	return values

/datum/preference/choiced/nerve_staple_choice/apply_to_human(mob/living/carbon/human/target, value)
	return

GLOBAL_LIST_INIT(nerve_staple_choice, list(
	"Left Eye" = /obj/item/clothing/glasses/nerve_staple,
	"Right Eye" = /obj/item/clothing/glasses/nerve_staple/right,
))
