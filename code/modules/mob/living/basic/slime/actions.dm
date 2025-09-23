/datum/action/innate/slime
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	///Does the ability require a specific slime lifestage?
	var/life_stage_required
	///Does the ability requires the slime to hit max growth?
	var/needs_growth = FALSE
	///Does the ability cost nutrition?
	var/nutrition_cost = 0

/datum/action/innate/slime/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/basic/slime/slime_owner = owner

	if(!isnull(life_stage_required) && slime_owner.life_stage != life_stage_required)
		return FALSE

	if(slime_owner.nutrition < nutrition_cost)
		return FALSE

	if(needs_growth && slime_owner.amount_grown < SLIME_EVOLUTION_THRESHOLD)
		return FALSE
	return TRUE

//Evolving

/datum/action/innate/slime/evolve
	name = "Evolve"
	button_icon_state = "slimegrow"
	desc = "This will let you evolve from baby to adult slime."
	life_stage_required = SLIME_LIFE_STAGE_BABY
	needs_growth = TRUE
	nutrition_cost = SLIME_EVOLUTION_COST

///Turns a baby slime into an adult slime
/datum/action/innate/slime/evolve/Activate()
	var/mob/living/basic/slime/slime_owner = owner

	if(slime_owner.stat)
		slime_owner.balloon_alert(slime_owner, "unconscious!")
		return
	if(slime_owner.life_stage == SLIME_LIFE_STAGE_ADULT)
		slime_owner.balloon_alert(slime_owner, "already adult!")
		return
	if(slime_owner.amount_grown < SLIME_EVOLUTION_THRESHOLD)
		slime_owner.balloon_alert(slime_owner, "need to grow!")
		return
	if(slime_owner.nutrition < nutrition_cost)
		slime_owner.balloon_alert(slime_owner, "need food!")
		return

	slime_owner.adjust_nutrition(-nutrition_cost)

	slime_owner.set_life_stage(SLIME_LIFE_STAGE_ADULT)
	slime_owner.update_name()
	slime_owner.regenerate_icons()

	slime_owner.amount_grown = 0

//Reproduction

/datum/action/innate/slime/reproduce
	name = "Reproduce"
	button_icon_state = "slimesplit"
	desc = "This will make you split into four slimes."
	life_stage_required = SLIME_LIFE_STAGE_ADULT
	needs_growth = TRUE

/datum/action/innate/slime/reproduce/Activate()
	var/mob/living/basic/slime/slime_owner = owner
	slime_owner.reproduce()

///Splits the slime into multiple children if possible
/mob/living/basic/slime/proc/reproduce()

	if(stat != CONSCIOUS)
		balloon_alert(src, "not conscious!")
		return

	if(!isopenturf(loc))
		balloon_alert(src, "not here!")

	if(life_stage != SLIME_LIFE_STAGE_ADULT)
		balloon_alert(src, "not adult!")
		return

	if(amount_grown < SLIME_EVOLUTION_THRESHOLD)
		balloon_alert(src, "need growth!")
		return

	var/list/friends_list = list()
	for(var/mob/living/basic/slime/friend in loc)
		if(QDELETED(friend))
			continue
		if(friend == src)
			continue
		friends_list += friend

	overcrowded = length(friends_list) >= SLIME_OVERCROWD_AMOUNT
	if(overcrowded)
		balloon_alert(src, "overcrowded!")
		return

	var/new_nutrition = floor(nutrition * 0.9)
	var/new_powerlevel = floor(powerlevel * 0.25)
	var/turf/drop_loc = drop_location()

	var/list/created_slimes = list(src)
	var/list/slime_friends = list()
	for(var/faction_member in faction)
		var/mob/living/possible_friend = locate(faction_member) in GLOB.mob_living_list
		if(QDELETED(possible_friend))
			continue
		slime_friends += possible_friend

//	for(var/i in 1 to 3) IRIS EDIT OLD
	// IRIS EDIT NEW START
	var/split_amount = 3
	switch(transformative_effect)
		if(SLIME_TYPE_GREY)
			split_amount++

		if(SLIME_TYPE_CERULEAN)
			split_amount = 1

	for(var/i in 1 to split_amount)
		var/mob/living/basic/slime/baby = new(drop_loc, get_random_mutation())
		created_slimes += baby
		for(var/slime_friend in slime_friends)
			baby.befriend(slime_friend)

		var/mob/living/basic/slime/baby
		baby = new(drop_loc, child_colour)

		// IRIS ADDITION START
		if(transformative_effect)
			baby.transformative_effect = transformative_effect
			baby.transform_effect()
			if(baby.spawner)
				baby.master = master
				baby.spawner.important_text = "Assist [master] at all costs."

			if(transformative_effect == SLIME_TYPE_CERULEAN)
				baby.set_life_stage(SLIME_LIFE_STAGE_ADULT)
				baby.update_name()
				baby.regenerate_icons()
				baby.set_nutrition(new_nutrition)
		// IRIS ADDITION END

		SSblackbox.record_feedback("tally", "slime_babies_born", 1, baby.slime_type.colour)
		step_away(baby, src)

	set_nutrition(SLIME_STARTING_NUTRITION)
	for(var/mob/living/basic/slime/baby as anything in created_slimes)
		if(ckey) // Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
			baby.set_nutrition(new_nutrition)
		baby.powerlevel = new_powerlevel
		if(mutation_chance)
			baby.mutation_chance = clamp(mutation_chance + rand(-5, 5), 0, 100)
		else
			baby.mutation_chance = 0

//	set_life_stage(SLIME_LIFE_STAGE_BABY) // IRIS EDIT OLD -- Unique slimes
	// IRIS EDIT NEW START
	if(transformative_effect != SLIME_TYPE_CERULEAN)
		set_life_stage(SLIME_LIFE_STAGE_BABY)
	// IRIS EDIT NEW END
//	set_slime_type(get_random_mutation()) // IRIS EDIT OLD -- Unique slimes
	// IRIS EDIT NEW START
	if(transformative_effect != SLIME_TYPE_BLUE)
		set_slime_type(get_random_mutation())
	// IRIS EDIT NEW END
	amount_grown = 0
	mutator_used = FALSE

/mob/living/basic/slime/proc/get_random_mutation()
	// IRIS ADDITION START -- Unique slimes
	switch(transformative_effect)
		if(SLIME_TYPE_CERULEAN)
			return slime_type.type

		if(SLIME_TYPE_PYRITE)
			return pick(subtypesof(/datum/slime_type) - /datum/slime_type/rainbow - typesof(/datum/slime_type/unique))
	// IRIS ADDITION END
	if(mutation_chance >= 100)
		return /datum/slime_type/rainbow
	else if(prob(mutation_chance))
		return pick_weight(slime_type.mutations)
	else
		return slime_type.type
