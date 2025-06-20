/mob/living/basic/mining_drone
	var/static/living_limit = 0

/mob/living/basic/mining_drone/Initialize(mapload)
	. = ..()
	living_limit++
	if(living_limit > 10)
		var/obj/item/card/mining_point_card/card = new(loc)
		card.points = 438 // Roughly the cost of a minebot if ordered via shuttle
		qdel(src)

/mob/living/basic/mining_drone/Destroy(force)
	living_limit--
	return ..()
