/datum/quirk/cursed
	name = "Cursed"
	desc = "You are cursed with bad luck. You are much more likely to suffer from accidents and mishaps. When it rains, it pours."
	icon = FA_ICON_CLOUD_SHOWERS_HEAVY
	value = -8
	mob_trait = TRAIT_CURSED
	gain_text = span_danger("You feel like you're going to have a bad day.")
	lose_text = span_notice("You feel like you're going to have a good day.")
	medical_record_text = "Patient is cursed with bad luck."
	hardcore_value = 8

/datum/quirk/cursed/add(client/client_source)
	quirk_holder.AddComponent(/datum/component/omen/quirk)

//IRIS EDIT ADDITION BEGIN - COGNOMERGE_EVENT - Prevents people from becoming permanently cursed if the extreme cognomerge event rolls it
/datum/quirk/cursed/remove(client/client_source)
	var/datum/component/omen/quirk/omen_to_destroy = quirk_holder.GetExactComponent(/datum/component/omen/quirk)
	omen_to_destroy.Destroy()
//IRIS EDIT ADDITION END
