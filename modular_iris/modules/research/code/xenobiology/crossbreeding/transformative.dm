/datum/movespeed_modifier/transformative_sepia
	multiplicative_slowdown = -0.3

/obj/effect/mob_spawn/ghost_role/slime
	name = "enslaved slime"
	desc = "They seem to pulse slightly with an inner life."
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	prompt_name = "enslaved slime"
	you_are_text = "You are an enslaved slime."
	flavour_text = "You were suddenly awakened with the power of a strange, foreign core inside of you."
	important_text = "Assist your master at all costs." // Master's name is added after we spawn.
	role_ban = ROLE_GHOST_ROLE

/obj/effect/mob_spawn/ghost_role/slime/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)
			attack_ghost(ghost)

/obj/effect/mob_spawn/ghost_role/slime/allow_spawn(mob/user, silent = FALSE)
	var/mob/living/basic/slime/slime = loc
	if(slime.ckey)
		if(!silent)
			to_chat(user, span_warning("This slime was already possessed via other means!"))
		return FALSE
	return TRUE

/obj/effect/mob_spawn/ghost_role/slime/create(mob/mob_possessor, newname, use_loadout = FALSE)
	special(loc, mob_possessor)
	return loc // We dont actually want to create anything, just give them our mob

/obj/effect/mob_spawn/ghost_role/slime/special(mob/living/basic/slime/slime, mob/mob_possessor)
	. = ..() // We can assume we're in a slime, if we aren't something is TERRIBLY wrong
	slime.spawner = null

/mob/living/basic/slime
	var/transformative_effect = null
	var/obj/effect/mob_spawn/ghost_role/slime/spawner = null
	var/master = "" // Used only for the spawner, its here and not there because the spawner can get deleted

/mob/living/basic/slime/attack_ghost(mob/user)
	if(spawner)
		spawner.attack_ghost(user)
	return ..()

/mob/living/basic/slime/Destroy()
	if(spawner)
		QDEL_NULL(spawner)
	return ..()

/mob/living/basic/slime/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	. = ..()
	if(!.) //dead or deleted
		return

	switch(transformative_effect)
		if(SLIME_TYPE_PURPLE)
			adjustBruteLoss(-0.25 * seconds_per_tick)

		if(SLIME_TYPE_DARK_PURPLE)
			var/datum/gas_mixture/environment = loc.return_air()
			if(environment.gases[/datum/gas/plasma])
				var/amount = (life_stage == SLIME_LIFE_STAGE_ADULT ? 20 : 10)
				if(environment.gases[/datum/gas/plasma][MOLES] >= amount)
					environment.gases[/datum/gas/plasma][MOLES] -= amount
					environment.assert_gas(/datum/gas/oxygen)
					environment.gases[/datum/gas/oxygen][MOLES] += amount
					adjustBruteLoss(-amount * 0.1) // Technically better than purple, technically.
					environment.garbage_collect()

		if(SLIME_TYPE_RAINBOW)
			if(prob(2.5 * seconds_per_tick))
				random_colour()

/mob/living/basic/slime/proc/transform_effect(mob/living/user)
	regenerate_icons()
	switch(transformative_effect)
		if(SLIME_TYPE_RED)
			obj_damage *= 1.1
			melee_damage_lower *= 1.1
			melee_damage_upper *= 1.1

		if(SLIME_TYPE_BLACK)
			alpha = 64

		if(SLIME_TYPE_METAL)
			health *= 1.3
			maxHealth *= 1.3

		if(SLIME_TYPE_PINK)
			var/datum/language_holder/holder = get_language_holder()
			holder.grant_language(/datum/language/common, source = SOURCE_TRANSFORMATIVE_EXTRACT)
			holder.selected_language = /datum/language/common

		if(SLIME_TYPE_LIGHT_PINK)
			spawner = new(src)
			if(user)
				master = user.name
				spawner.important_text = "Assist [master] at all costs."

		if(SLIME_TYPE_SEPIA)
			add_movespeed_modifier(/datum/movespeed_modifier/transformative_sepia)

		if(SLIME_TYPE_SILVER)
			if(!hunger_disabled) // We do this so if you give a silver transformative extract to a pet slime, we dont override
				hunger_disabled = 2

/mob/living/basic/slime/proc/untransform()
	switch(transformative_effect)
		if(SLIME_TYPE_RED)
			obj_damage /= 1.1
			melee_damage_lower /= 1.1
			melee_damage_upper /= 1.1

		if(SLIME_TYPE_BLACK)
			alpha = 255

		if(SLIME_TYPE_METAL)
			health /= 1.3
			maxHealth /= 1.3

		if(SLIME_TYPE_PINK)
			var/datum/language_holder/holder = get_language_holder()
			holder.remove_language(/datum/language/common, source = SOURCE_TRANSFORMATIVE_EXTRACT)
			holder.selected_language = /datum/language/slime

		if(SLIME_TYPE_LIGHT_PINK)
			if(spawner)
				qdel(spawner)
			spawner = null
			master = ""

		if(SLIME_TYPE_SEPIA)
			remove_movespeed_modifier(/datum/movespeed_modifier/transformative_sepia)

		if(SLIME_TYPE_SILVER)
			if(hunger_disabled == 2)
				hunger_disabled = FALSE

///Changes the slime's current life state
/mob/living/basic/slime/set_life_stage(new_life_stage = SLIME_LIFE_STAGE_BABY)
	if(transformative_effect == SLIME_TYPE_RED && new_life_stage == SLIME_LIFE_STAGE_ADULT) // Our parent uses addition so we are incompatible without this.
		obj_damage /= 1.1
		melee_damage_lower /= 1.1
		melee_damage_upper /= 1.1

	. = ..()
	switch(transformative_effect)
		if(SLIME_TYPE_METAL)
			health *= 1.3
			maxHealth *= 1.3

		if(SLIME_TYPE_RED)
			obj_damage *= 1.1
			melee_damage_lower *= 1.1
			melee_damage_upper *= 1.1

/mob/living/basic/slime/apply_water()
	if(transformative_effect != SLIME_TYPE_DARK_BLUE)
		return ..()
	adjustBruteLoss(rand(7.5, 10))
	discipline_slime()

/mob/living/basic/slime/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	exposed_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
	wound_clothing = TRUE,
)
	if(transformative_effect == SLIME_TYPE_ADAMANTINE && damagetype == BRUTE && damage && !forced)
		blocked = min(blocked + 50, 100)
	return ..()

/datum/status_effect/slime_leech/on_apply()
	. = ..()
	if(!.)
		return FALSE
	switch(our_slime.transformative_effect)
		if(SLIME_TYPE_BLACK)
			our_slime.alpha = 255
		if(SLIME_TYPE_OIL)
			owner.adjust_fire_stacks(2) // This is the same amount of firestacks orange applies, but you dont need charge

/mob/living/basic/slime/stop_feeding(silent = FALSE)
	. = ..()
	switch(transformative_effect)
		if(SLIME_TYPE_BLACK)
			alpha = 64

/mob/living/basic/slime/regenerate_icons()
	. = ..()
	if(transformative_effect)
		var/mutable_appearance/transformative_overlay = mutable_appearance('modular_iris/modules/research/icons/slimecrossing.dmi', "warping", MOB_BELOW_PIGGYBACK_LAYER)
		var/core_color = "#FFFFFF"
		switch(transformative_effect)
			if(SLIME_TYPE_ORANGE)
				core_color = COLOR_SLIME_ORANGE
			if(SLIME_TYPE_PURPLE)
				core_color = COLOR_SLIME_PURPLE
			if(SLIME_TYPE_BLUE)
				core_color = COLOR_SLIME_BLUE
			if(SLIME_TYPE_METAL)
				core_color = COLOR_SLIME_METAL
			if(SLIME_TYPE_YELLOW)
				core_color = COLOR_SLIME_YELLOW
			if(SLIME_TYPE_DARK_PURPLE)
				core_color = COLOR_SLIME_DARK_PURPLE
			if(SLIME_TYPE_DARK_BLUE)
				core_color = COLOR_SLIME_DARK_BLUE
			if(SLIME_TYPE_SILVER)
				core_color = COLOR_SLIME_SILVER
			if(SLIME_TYPE_BLUESPACE)
				core_color = COLOR_SLIME_BLUESPACE
			if(SLIME_TYPE_SEPIA)
				core_color = COLOR_SLIME_SEPIA
			if(SLIME_TYPE_CERULEAN)
				core_color = COLOR_SLIME_CERULEAN
			if(SLIME_TYPE_PYRITE)
				core_color = COLOR_SLIME_PYRITE
			if(SLIME_TYPE_RED)
				core_color = COLOR_SLIME_RED
			if(SLIME_TYPE_GREEN)
				core_color = COLOR_SLIME_GREEN
			if(SLIME_TYPE_PINK)
				core_color = COLOR_SLIME_PINK
			if(SLIME_TYPE_GOLD)
				core_color = COLOR_SLIME_GOLD
			if(SLIME_TYPE_OIL)
				core_color = COLOR_SLIME_OIL
			if(SLIME_TYPE_BLACK)
				core_color = COLOR_SLIME_BLACK
			if(SLIME_TYPE_LIGHT_PINK)
				core_color = COLOR_SLIME_LIGHT_PINK
			if(SLIME_TYPE_ADAMANTINE)
				core_color = COLOR_SLIME_ADAMANTINE

		transformative_overlay.color = core_color
		add_overlay(transformative_overlay)

/**
 * transformative extracts:
 * apply a permanent effect to a slime and all of its babies
 */
/obj/item/slimecross/transformative
	name = "transformative extract"
	desc = "It seems to stick to any slime it comes in contact with."
	icon = 'modular_iris/modules/research/icons/slimecrossing.dmi'
	icon_state = "transformative"
	effect = "transformative"

/obj/item/slimecross/transformative/interact_with_atom(mob/living/basic/slime/target, mob/living/user, list/modifiers)
	if(!istype(target))
		return ITEM_INTERACT_FAILURE
	if(target.stat)
		to_chat(user, span_warning("The slime is dead!"))
		return ITEM_INTERACT_FAILURE
	if(target.transformative_effect == colour)
		to_chat(user, span_warning("This slime already has the [colour] transformative effect applied!"))
		return ITEM_INTERACT_FAILURE
	to_chat(user, span_notice("You apply [src] to [target]."))
	if(target.transformative_effect)
		target.untransform()
	target.transformative_effect = colour
	target.transform_effect(user)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/transformative/grey
	colour = SLIME_TYPE_GREY
	effect_desc = "Slimes split into one additional slime."

/obj/item/slimecross/transformative/orange
	colour = SLIME_TYPE_ORANGE
	effect_desc = "Slimes will light people on fire when they shock them."

/obj/item/slimecross/transformative/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Slimes will regenerate slowly."

/obj/item/slimecross/transformative/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Slime will always retain slime of its original colour when splitting."

/obj/item/slimecross/transformative/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Slimes will be able to sustain more damage before dying."

/obj/item/slimecross/transformative/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Slimes will gain electric charge faster."

/obj/item/slimecross/transformative/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Slime rapidly converts atmospheric plasma to oxygen, healing in the process."

/obj/item/slimecross/transformative/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Slimes takes reduced damage from water."

/obj/item/slimecross/transformative/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Slimes will no longer lose nutrition over time."

/obj/item/slimecross/transformative/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Slimes will teleport to targets when they have at least half electric charge."

/obj/item/slimecross/transformative/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Slimes move faster."

/obj/item/slimecross/transformative/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Slime makes another adult via mitosis rather than splitting, with half the nutrition."

/obj/item/slimecross/transformative/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Slime always splits into totally random colors, except rainbow. Can never yield a rainbow slime."

/obj/item/slimecross/transformative/red
	colour = SLIME_TYPE_RED
	effect_desc = "Slimes does 10% more damage when feeding and attacking."
/*
/obj/item/slimecross/transformative/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Grants sentient slimes the ability to become a luminescent at will, once."
*/
/obj/item/slimecross/transformative/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Slimes will speak in common rather than in slime."
/*
/obj/item/slimecross/transformative/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Slime extracts from these will sell for double the price."
*/
/obj/item/slimecross/transformative/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "Slime douses anything it feeds on in welding fuel."

/obj/item/slimecross/transformative/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Slime is nearly transparent."

/obj/item/slimecross/transformative/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Slimes may become possessed by supernatural forces."

/obj/item/slimecross/transformative/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Slimes takes reduced damage from brute attacks."

/obj/item/slimecross/transformative/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Slime randomly changes color periodically."
