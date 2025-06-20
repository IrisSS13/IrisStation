/mob/living/basic/mining_drone/Initialize(mapload)
	. = ..()
	GLOB.minebot_amount++

/mob/living/basic/mining_drone/Destroy(force)
	GLOB.minebot_amount--
	return ..()
