/datum/quirk/poor_aim
	name = "Stormtrooper Aim"
	desc = "You've never hit anything you were aiming for in your life."
	icon = FA_ICON_BULLSEYE
	value = -4
	medical_record_text = "Patient possesses a strong tremor in both hands."
	hardcore_value = 3
	mail_goodies = list(/obj/item/cardboard_cutout) // for target practice
	//IRIS EDIT ADDITION BEGIN - COGNOMERGE_EVENT
	gain_text = span_danger("The thought of shooting a gun sets your hands trembling.")
	lose_text = span_notice("Your hands no longer tremble when you think about shooting guns.")
	//IRIS EDIT ADDITION END

/datum/quirk/poor_aim/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOB_FIRED_GUN, PROC_REF(on_mob_fired_gun))

/datum/quirk/poor_aim/remove(client/client_source)
	UnregisterSignal(quirk_holder, COMSIG_MOB_FIRED_GUN)

/datum/quirk/poor_aim/proc/on_mob_fired_gun(mob/user, obj/item/gun/gun_fired, target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	bonus_spread_values[MIN_BONUS_SPREAD_INDEX] += 10
	bonus_spread_values[MAX_BONUS_SPREAD_INDEX] += 35
