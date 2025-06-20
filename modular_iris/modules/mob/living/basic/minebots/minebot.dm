/mob/living/basic/mining_drone
	var/static/living_limit = 0

/mob/living/basic/mining_drone/Initialize(mapload)
	. = ..()
	living_limit++
	if(living_limit > 10)
		var/obj/item/card/mining_point_card/card = new(loc)
		card.points = floor(675 / cargo_cost_multiplier)
		qdel(src)

/mob/living/basic/mining_drone/Destroy(force)
	living_limit--
	return ..()
