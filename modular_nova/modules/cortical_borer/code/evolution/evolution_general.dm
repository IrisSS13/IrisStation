/datum/borer_evolution/health_per_level
	name = "Health Increase"
	desc = "Increase the amount of health per level-up you gain."
	gain_text = "Over time, some worms have become harder to dissect post-mortem. Their skin membrane has become up to thrice as thick."
	tier = 2
	unlocked_evolutions = list()
	evo_cost = 1

/datum/borer_evolution/health_per_level/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.health_per_level += 2.5
	cortical_owner.recalculate_stats()

/datum/borer_evolution/host_speed
	name = "Boring Speed"
	desc = "Decrease the time it takes to enter a host when you are not hiding."
	gain_text = "Once or twice, I would blink, and see the non-host monkeys be grappling with a worm that was cross the room just moments before."
	tier = 3
	unlocked_evolutions = list()

/datum/borer_evolution/host_speed/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.upgrade_flags |= BORER_FAST_BORING

/datum/borer_evolution/upgrade_injection
	name = "Upgrade Injection"
	desc = "Upgrade your possible injection amount to 10 units."
	gain_text = "Their growth is astounding, their organs and glands can expand several times their size in mere days."
	unlocked_evolutions = list(/datum/borer_evolution/upgrade_injection/t2,
	/datum/borer_evolution/health_per_level,
	)
	tier = 1

/datum/borer_evolution/upgrade_injection/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.injection_rates_unlocked += cortical_owner.injection_rates[length(cortical_owner.injection_rates_unlocked) + 1]

/datum/borer_evolution/upgrade_injection/t2
	name = "Upgrade Injection II"
	desc = "Upgrade your possible injection amount to 25 units."
	unlocked_evolutions = list(/datum/borer_evolution/upgrade_injection/t3,
	/datum/borer_evolution/host_speed,
	)
	tier = 2

/datum/borer_evolution/upgrade_injection/t3
	name = "Upgrade Injection III"
	desc = "Upgrade your possible injection amount to 50 units."
	unlocked_evolutions = list()
	tier = 3

/datum/borer_evolution/sugar_immunity
	name = "Sugar Immunity"
	desc = "Become immune to the ill effects of sugar in you or a host."
	gain_text = "Of the biggest ones, a few have managed to resist the effects of sugar. Truly concerning if we wish to keep them contained."
	evo_cost = 5
	tier = 6

/datum/borer_evolution/sugar_immunity/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.upgrade_flags |= BORER_SUGAR_IMMUNE

/datum/borer_evolution/synthetic_borer
	name = "Synthetic Boring"
	desc = "Gain the ability to take synthetic humans as a host as well."
	gain_text = "Now, we used robots to take care of the worms when they're alive, but one day... they all went haywire. Security took them down, closer inspection showed that the worms managed their way into the processing units."
	evo_cost = 6
	tier = 6

/datum/borer_evolution/synthetic_borer/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.organic_restricted = FALSE

/datum/borer_evolution/synthetic_chems_positive
	name = "Synthetic Chemicals (+)"
	desc = "Gain access to a list of helpful, synthetic-compatible chemicals."
	gain_text = "Once we had established that robots weren't safe either, we began to experiment with them. Interestingly enough, some of them never needed to be oiled again."
	tier = 6
	evo_cost = 6
	var/static/list/added_chemicals = list(
		/datum/reagent/consumable/ethanol/synthanol,
		/datum/reagent/medicine/system_cleaner,
		/datum/reagent/medicine/nanite_slurry,
		/datum/reagent/medicine/liquid_solder,
		/datum/reagent/fuel/oil,
		/datum/reagent/fuel,
	)

/datum/borer_evolution/synthetic_chems_positive/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.potential_chemicals |= added_chemicals

/datum/borer_evolution/synthetic_chems_negative
	name = "Synthetic Chemicals (-)"
	desc = "Gain access to a list of synthetic-damaging chemicals."
	gain_text = "Good thing is, some of the worms were hostile to the robots, too. Corroded from the inside, some of them were basically husks."
	tier = 6
	evo_cost = 6
	var/static/list/added_chemicals = list(
		/datum/reagent/toxin/acid/fluacid, // More like anti everything but :shrug:
		/datum/reagent/thermite,
		/datum/reagent/pyrosium,
		/datum/reagent/oxygen,
	)

/datum/borer_evolution/synthetic_chems_negative/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.potential_chemicals |= added_chemicals
