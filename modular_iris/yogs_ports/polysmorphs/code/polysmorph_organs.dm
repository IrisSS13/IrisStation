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

/obj/item/organ/tongue/polysmorph
	name = "Polysmorph Tongue"
	icon_state = "tongue-x"
	icon = ORGAN_ICON_POLYSMORPH
	say_mod = "hisses"
	taste_sensitivity = 10
	modifies_speech = TRUE
	liked_foodtypes = MEAT| RAW | GORE
	disliked_foodtypes = DAIRY | GRAIN | FRUIT
	var/static/list/speech_replacements = list(
		new /regex("s+", "g") = "sssss",
		new /regex("S+", "g") = "SSSSS",
		new /regex(@"(\w)x", "g") = "$1kssss",
		new /regex(@"\bx([\-|r|R]|\b)", "g") = "eckssss$1",
		new /regex(@"\bX([\-|r|R]|\b)", "g") = "ECKSSSS$1",
	)

/obj/item/organ/tongue/polysmorph/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = speech_replacements, should_modify_speech = CALLBACK(src, PROC_REF(should_modify_speech)))

#undef ORGAN_ICON_POLYSMORPH
