/mob/living/basic/carp/goodboy //Very goodboy variation

	speak_emote = list("squeaks")
	gold_core_spawnable = NO_SPAWN
	gender = MALE
	ai_controller = /datum/ai_controller/basic_controller/carp/goodboy
	initial_language_holder = /datum/language_holder/carp/hear_common
	combat_mode = FALSE
	override = TRUE

/mob/living/basic/carp/pet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/pet_bonus, "bloop")

