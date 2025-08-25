#define ORGAN_ICON_POLYSMORPH 'modular_iris/yogs_ports/polysmorphs/icons/poly_organs.dmi'

//TODO: organ descriptions, cybernetic plasma vessel?

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

/obj/item/organ/lungs/polysmorph
	name = "Polysmorph Lungs"
	icon_state = "lungs-x"
	icon = ORGAN_ICON_POLYSMORPH
	safe_plasma_max = 0

/obj/item/organ/brain/polysmorph
	name = "Polysmorph Brain"
	icon_state = "brain-x-d" //lol xD
	icon = ORGAN_ICON_POLYSMORPH

/obj/item/organ/brain/polysmorph/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "alien", BUBBLE_ICON_PRIORITY_ORGAN)


//Just reskins atm
/obj/item/organ/stomach/polysmorph
	name = "Polysmorph Stomach"
	icon_state = "stomach-x"
	icon = ORGAN_ICON_POLYSMORPH

/obj/item/organ/heart/polysmorph
	name = "Polysmorph Heart"
	icon_state = "heart-x"
	icon = ORGAN_ICON_POLYSMORPH

/obj/item/organ/alien/plasmavessel/roundstart
	icon_state = "plasma_small" //it's a worse version, ofc it will be small
	icon = ORGAN_ICON_POLYSMORPH

/obj/item/organ/alien/resinspinner/roundstart
	icon_state = "acid"
	icon = ORGAN_ICON_POLYSMORPH

#undef ORGAN_ICON_POLYSMORPH
