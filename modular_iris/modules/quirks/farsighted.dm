//Quirk ported in its entirety from Orbstation
//Original PR can be found here: https://github.com/lizardqueenlexi/orbstation/pull/254

/datum/quirk/item_quirk/farsighted
	name = "Farsighted"
	desc = "You are farsighted - you won't be able to read a thing without prescription glasses. Fortunately, you spawn with a pair."
	icon = FA_ICON_MAGNIFYING_GLASS
	value = -3
	gain_text = "<span class='danger'>Things close to you start looking blurry.</span>"
	lose_text = "<span class='notice'>You start seeing nearby things normally again.</span>"
	medical_record_text = "Patient requires prescription glasses in order to counteract farsightedness."
	mail_goodies = list(/obj/item/clothing/glasses/regular) // extra pair if orginal one gets broken by somebody mean
	var/glasses

/datum/quirk_constant_data/farsighted
	associated_typepath = /datum/quirk/item_quirk/farsighted
	customization_options = list(/datum/preference/choiced/glasses)

/datum/quirk/item_quirk/farsighted/add_unique(client/client_source)
	var/glasses_name = client_source?.prefs.read_preference(/datum/preference/choiced/glasses) || "Regular"
	var/obj/item/clothing/glasses/glasses_type

	glasses_name = glasses_name == "Random" ? pick(GLOB.nearsighted_glasses) : glasses_name
	glasses_type = GLOB.nearsighted_glasses[glasses_name]

	give_item_to_holder(glasses_type, list(
		LOCATION_EYES,
		LOCATION_BACKPACK,
		LOCATION_HANDS,
	))

/datum/quirk/item_quirk/farsighted/add()
	quirk_holder.become_farsighted(QUIRK_TRAIT)

/datum/quirk/item_quirk/farsighted/remove()
	quirk_holder.cure_farsighted(QUIRK_TRAIT)

/mob/living/proc/cure_farsighted(source)
	REMOVE_TRAIT(src, TRAIT_FARSIGHT, source)
	if(!HAS_TRAIT(src, TRAIT_FARSIGHT))
		REMOVE_TRAIT(src, TRAIT_ILLITERATE, FARSIGHT_TRAIT)

/mob/living/proc/become_farsighted(source)
	if(!HAS_TRAIT(src, TRAIT_FARSIGHT))
		ADD_TRAIT(src, TRAIT_ILLITERATE, FARSIGHT_TRAIT)
	ADD_TRAIT(src, TRAIT_FARSIGHT, source)
