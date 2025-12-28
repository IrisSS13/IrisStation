#define SPIDER_WEB_TINT	"web_colour_tint"

/obj/structure/chosm
	name = "membrane"
	icon = 'modular_iris/icons/obj/smooth_structures/sinuous_tissue.dmi'
	desc = "A sinuous dark-tyrian mass of interwoven tissue."
	anchored = TRUE
	density = FALSE
	max_integrity = 5

/obj/structure/chosm/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)
	ADD_TRAIT(src, TRAIT_INVERTED_DEMOLITION, INNATE_TRAIT)
	//transform = transform.Scale(0.8, 0.8)

/obj/structure/chosm/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BURN)//the stickiness of the membrane mutes all attack sounds except fire damage type
		playsound(loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/structure/chosm/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == MELEE)
		switch(damage_type)
			if(BURN)
				damage_amount *= 0.25
			if(BRUTE)
				damage_amount *= 1.25
	return ..()

/obj/structure/chosm/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 350 // Remove

/obj/structure/chosm/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0) // Remove

/obj/structure/chosm/membrane
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'modular_iris/icons/obj/smooth_structures/sinuous_tissue.dmi'
	base_icon_state = "tissue"
	icon_state = "tissue-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = null
	canSmoothWith = SMOOTH_GROUP_WALLS
	///Whether or not the web is from the genetics power
	var/genetic = FALSE // Definitely Remove probably.
	///Whether or not the web is a sealed web
	var/sealed = FALSE // Remove
	///Do we need to offset this based on a sprite frill?
	var/has_frill = TRUE // What? Try to remove I guess?
	/// Chance that someone will get stuck when trying to cross this tile
	var/stuck_chance = 50
	/// Chance that a bullet will hit this instead of flying through it
	var/projectile_stuck_chance = 30

/obj/structure/chosm/membrane/Initialize(mapload)
	// Offset on init so that they look nice in the map editor
	//transform = transform.Scale(0.5, 0.5)
	if (has_frill)
		pixel_x = -9
		pixel_y = -9
	return ..()

/obj/structure/chosm/membrane/Destroy()
	playsound(src.loc, 'modular_iris/sound/daemons/membrane_death.ogg', 50, TRUE)
	return ..()


/obj/structure/chosm/membrane/attack_hand(mob/user, list/modifiers)
	.= ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_WEB_WEAVER))
		return
	loc.balloon_alert_to_viewers("spooling...")
	if(!do_after(user, 2 SECONDS))
		loc.balloon_alert(user, "interrupted!")
		return
	qdel(src)
	var/obj/item/stack/sheet/cloth/woven_cloth = new /obj/item/stack/sheet/cloth
	user.put_in_hands(woven_cloth)

/obj/structure/chosm/membrane/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(genetic) // Remove
		return
	if(sealed)
		return FALSE
	if(isliving(mover))
		if(HAS_TRAIT(mover, TRAIT_WEB_SURFER))
			return TRUE
		if(mover.pulledby && HAS_TRAIT(mover.pulledby, TRAIT_WEB_SURFER))
			return TRUE
		if(prob(stuck_chance))
			stuck_react(mover)
			return FALSE
		return .
	if(isprojectile(mover))
		return prob(projectile_stuck_chance)
	return .

/// Show some feedback when you can't pass through something
/obj/structure/chosm/membrane/proc/stuck_react(atom/movable/stuck_guy)
	loc.balloon_alert(stuck_guy, "stuck in membrane!")
	stuck_guy.Shake(duration = 0.1 SECONDS)

//Actual Tissue that is spawned in-game
/obj/structure/chosm/membrane/sinuous_tissue
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'modular_iris/icons/obj/smooth_structures/sinuous_tissue.dmi' // Change later
	base_icon_state = "tissue"
	icon_state = "tissue-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = null
	canSmoothWith = SMOOTH_GROUP_WALLS


/obj/structure/chosm/membrane/sinuous_tissue/Initialize(mapload)
	// Offset on init so that they look nice in the map editor
	if (has_frill)
		pixel_x = -9
		pixel_y = -9
	return ..()


