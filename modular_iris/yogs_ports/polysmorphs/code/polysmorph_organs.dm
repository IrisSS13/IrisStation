#define ORGAN_ICON_POLYSMORPH 'modular_iris/yogs_ports/polysmorphs/icons/poly_organs.dmi'

/obj/item/organ/liver/polysmorph
	name = "Polysmorph Liver"
	icon_state = "liver-x"
	icon = ORGAN_ICON_POLYSMORPH
	liver_resistance = 1.2
	toxTolerance = 15

/obj/item/organ/liver/polysmorph/handle_chemical(mob/living/carbon/owner, datum/reagent/toxin/chem, seconds_per_tick, times_fired)
	. = ..()
	if(. & COMSIG_MOB_STOP_REAGENT_TICK)
		return
	if(chem.type == /datum/reagent/toxin/plasma || chem.type == /datum/reagent/toxin/hot_ice)
		chem.toxpwr = 0
	if(chem.type == /datum/reagent/toxin/acid)
		chem.toxpwr = 0
		owner.adjustBruteLoss(0 * REM * seconds_per_tick, updating_health = FALSE) //Still deals damage when you JUST drink it apparently
#undef ORGAN_ICON_POLYSMORPH
