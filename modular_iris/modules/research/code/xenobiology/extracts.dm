/obj/item/slime_extract/unique/cobalt
	name = "cobalt slime extract"
	icon_state = "cobalt-core"
	activate_reagents = list(
		/datum/reagent/blood,
		/datum/reagent/toxin/plasma,
	)

/datum/chemical_reaction/slime/shockwave
	results = list(/datum/reagent/sorium = 10)
	required_reagents = list(/datum/reagent/blood = 1)
	required_container = /obj/item/slime_extract/unique/cobalt
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_SLIME | REAGENT_HOLDER_INSTANT_REACT
	var/reacted = FALSE

/datum/chemical_reaction/slime/shockwave/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(!reacted)
		reacted = TRUE
		holder.chem_temp = 700
		holder.handle_reactions()
		return
	return ..()

/datum/chemical_reaction/slime/shockwave/delete_extract(datum/reagents/holder) // Just delete us, our reagents are gone.
	qdel(holder.my_atom)

/datum/chemical_reaction/slime/antishockwave
	results = list(/datum/reagent/liquid_dark_matter = 10)
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	required_container = /obj/item/slime_extract/unique/cobalt
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_SLIME | REAGENT_HOLDER_INSTANT_REACT
	var/reacted = FALSE

/datum/chemical_reaction/slime/antishockwave/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(!reacted)
		reacted = TRUE
		holder.chem_temp = 700
		holder.handle_reactions()
		return
	return ..()

/datum/chemical_reaction/slime/shockwave/delete_extract(datum/reagents/holder)
	qdel(holder.my_atom)

/obj/item/slime_extract/unique/darkgrey
	name = "dark grey slime extract"
	icon_state = "dark-grey-core"
	activate_reagents = list(
		/datum/reagent/toxin/plasma,
		/datum/reagent/toxin/slimejelly,
	)

/datum/chemical_reaction/slime/legionification
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	required_container = /obj/item/slime_extract/unique/darkgrey
	deletes_extract = FALSE
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_SLIME | REACTION_TAG_DANGEROUS

/datum/chemical_reaction/slime/legionification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/obj/item/slime_extract/M = holder.my_atom
	deltimer(M.qdel_timer)
	..()
	addtimer(CALLBACK(src, PROC_REF(summon_legion), holder), 5 SECONDS)
	M.qdel_timer = addtimer(CALLBACK(src, PROC_REF(delete_extract), holder), 5.5 SECONDS, TIMER_STOPPABLE)
	T.visible_message(span_danger("The slime extract begins to vibrate violently!"))

/datum/chemical_reaction/slime/legionification/proc/summon_legion(datum/reagents/holder)
	new /mob/living/basic/mining/legion/spawner_made(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/legionsteroid
	required_reagents = list(/datum/reagent/toxin/slimejelly = 1)
	required_container = /obj/item/slime_extract/unique/darkgrey

/datum/chemical_reaction/slime/legionsteroid/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	new /obj/item/slimepotion/slime/legiondrugs(get_turf(holder.my_atom))
	..()

/obj/item/slime_extract/unique/crimson
	name = "crimson slime extract"
	icon_state = "crimson-core"
	activate_reagents = list(
		/datum/reagent/water,
		/datum/reagent/toxin/plasma,
		/datum/reagent/uranium,
	)

/datum/chemical_reaction/slime/oxygenflood
	required_reagents = list(/datum/reagent/water = 1)
	required_container = /obj/item/slime_extract/unique/crimson

/datum/chemical_reaction/slime/oxygenflood/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/open/turf = get_turf(holder.my_atom)
	if(!istype(turf))
		turf.visible_message(span_notice("The slime extract quietly fizzles."))
		return ..()
	var/datum/gas_mixture/gas_mix = turf.return_air()
	ASSERT_GAS(/datum/gas/oxygen, gas_mix)
	gas_mix.gases[/datum/gas/oxygen][MOLES] += 4000 // Basically the same as round-start spawned canisters
	turf.air_update_turf(FALSE, FALSE) // We need to force the turf to update, else we get turfs with invisible gas waiting there
	turf.visible_message(span_danger("The slime extract quickly bursts outwards with oxygen!"))
	return ..()

/datum/chemical_reaction/slime/plasmaflood
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	required_container = /obj/item/slime_extract/unique/crimson

/datum/chemical_reaction/slime/plasmaflood/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/open/turf = get_turf(holder.my_atom)
	if(!istype(turf))
		turf.visible_message(span_notice("The slime extract quietly fizzles."))
		return ..()
	var/datum/gas_mixture/gas_mix = turf.return_air()
	ASSERT_GAS(/datum/gas/plasma, gas_mix)
	gas_mix.gases[/datum/gas/plasma][MOLES] += 4000
	turf.air_update_turf(FALSE, FALSE)
	turf.visible_message(span_danger("The slime extract quickly bursts outwards with plasma gas!"))
	return ..()

/datum/chemical_reaction/slime/tritiumflood // Has science gone too far?
	required_reagents = list(/datum/reagent/uranium = 1)
	required_container = /obj/item/slime_extract/unique/crimson

/datum/chemical_reaction/slime/tritiumflood/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/open/turf = get_turf(holder.my_atom)
	if(!istype(turf))
		turf.visible_message(span_notice("The slime extract quietly fizzles."))
		return ..()
	var/datum/gas_mixture/gas_mix = turf.return_air()
	ASSERT_GAS(/datum/gas/tritium, gas_mix)
	gas_mix.gases[/datum/gas/tritium][MOLES] += 4000
	turf.air_update_turf(FALSE, FALSE)
	turf.visible_message(span_userdanger("The slime extract quickly bursts outwards with tritium, oh god!"))
	return ..()

/obj/item/slime_extract/unique/lightgreen
	name = "light green slime extract"
	icon_state = "light-green-core"
	activate_reagents = list(
		/datum/reagent/water,
		/datum/reagent/blood,
	)

/datum/chemical_reaction/slime/plantfood
	results = list(/datum/reagent/plantnutriment/slime_nutriment = 10)
	required_reagents = list(/datum/reagent/water = 1)
	required_container = /obj/item/slime_extract/unique/lightgreen

/datum/reagent/plantnutriment/slime_nutriment
	name = "Slime Isotope P+"
	description = "Rare fertilizer produced by a specific variety of slime, \
		shares similarities with both EZ-nutrient and Robust Harvest \
		yet the chemical composition is too costly to artificially produce leaving many botanists dissapointed."
	color = LIGHT_COLOR_SLIME_LAMP

/datum/reagent/plantnutriment/slime_nutriment/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	var/obj/item/seeds/myseed = mytray.myseed
	if(myseed)
		myseed.adjust_potency(floor(volume * 0.4)) // This is straight up just both of them combined, quite good.
		myseed.adjust_yield(floor(volume * 0.3))
		myseed.adjust_instability(-0.05)

/datum/chemical_reaction/slime/planttoxin
	results = list(/datum/reagent/plantnutriment/slime_planttoxin = 5)
	required_reagents = list(/datum/reagent/blood = 1)
	required_container = /obj/item/slime_extract/unique/lightgreen

/datum/reagent/plantnutriment/slime_planttoxin
	name = "Slime Isotope Anti-P"
	description = "A strong neurotoxin that very effectivelly kills small animals and plantlife, \
		after extensive research it was found to not cause any major reactions inside of creatures larger than a newborn puppy. \
		It is highly advised to be carefull with the dose applied to cultivated plants as it causes rapid genetic instability \
		and severe damage to the plant in the process."
	color = LIGHT_COLOR_SLIME_LAMP

/datum/reagent/plantnutriment/slime_planttoxin/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_weedlevel(-2)
	mytray.adjust_pestlevel(-2)
	mytray.adjust_plant_health(-floor(volume * 0.5))
	mytray.myseed?.adjust_instability(floor(volume))
