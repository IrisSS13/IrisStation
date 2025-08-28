/obj/item/summoning_flute
	name = "summoning flute (Mega Arachnid)"
	desc = "A flute which calls out to the spirit of a vanquished fauna when played. The tune of this one will attract a Mega Arachnid."
	icon = 'icons/obj/art/musician.dmi'
	icon_state = "recorder"
	var/summoned_mega = /mob/living/basic/mega_arachnid

/obj/item/summoning_flute/attack_self(mob/user, modifiers)
	. = ..()
	if(do_after(user, 3 SECONDS, src))
		if(!is_mining_level(z))
			to_chat(user, span_warning("In this environment, the flute produces no sound."))
			return
		to_chat(user, span_userdanger("A terrifying rumbling portends the arrival of the summoned one..."))
		var/spawn_location = loc
		var/obj/effect/temp_visual/dragon_swoop/spawn_telegraph = new(spawn_location)
		sleep(2 SECONDS)
		new summoned_mega(spawn_location)
		qdel(spawn_telegraph)
		to_chat(user, span_warning("With its magic spent, [src] crumbles into dust."))
		qdel(src)

/obj/item/summoning_flute/drake
	name = "summoning flute (Ash Drake)"
	desc = "A flute which calls out to the spirit of a vanquished fauna when played. The tune of this one will attract an Ash Drake."
	summoned_mega = /mob/living/simple_animal/hostile/megafauna/dragon

/obj/item/summoning_flute/bubblegum
	name = "summoning flute (Bubblegum)"
	desc = "A flute which calls out to the spirit of a vanquished fauna when played. The tune of this one will attract Bubblegum."
	summoned_mega = /mob/living/simple_animal/hostile/megafauna/bubblegum
