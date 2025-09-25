/obj/item/slimepotion/slime/legiondrugs
	name = "lavaland steroid"
	desc = "A chemical concoction that changes the makeup of certain fauna native to lavaland, bringing rare mutations to the surface."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "potred"

/obj/item/slimepotion/slime/legiondrugs/attack(mob/living/basic/target, mob/user)
	var/mob/living/basic/mining/new_monster = null
	switch(target.type)
		if(/mob/living/basic/mining/legion)
			new_monster = new /mob/living/basic/mining/legion/dwarf(target.loc)

		if(/mob/living/basic/mining/watcher)
			if(prob(50))
				new_monster = new /mob/living/basic/mining/watcher/magmawing(target.loc)
			else
				new_monster = new /mob/living/basic/mining/watcher/icewing(target.loc)

		if(/mob/living/basic/mining/goliath)
			new_monster = new /mob/living/basic/mining/goliath/ancient/immortal(target.loc)

	if(isnull(new_monster))
		user.visible_message(span_danger("This creature won't respond to the potion."))
		return

	if(isnull(target.mind))
		new_monster.PossessByPlayer(target.key)
	else
		target.mind.transfer_to(new_monster)

	user.visible_message(span_danger("[target] sheds its form, emerging from a pile of gibs with new and fresh limbs!"))
	target.gib()
	qdel(src)
