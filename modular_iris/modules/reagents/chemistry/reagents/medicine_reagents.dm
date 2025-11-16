/datum/reagent/medicine/earthsblood //Created by ambrosia gaia plants
	name = "Earthsblood"
	description = "Ichor from an extremely powerful plant. Great for restoring wounds, but it's a little heavy on the brain. For some strange reason, it also induces temporary pacifism in those who imbibe it and semi-permanent pacifism in those who overdose on it."
	color = "#FFAF00"
	metabolization_rate = REAGENTS_METABOLISM //Math is based on specific metab rate so we want this to be static AKA if define or medicine metab rate changes, we want this to stay until we can rework calculations.
	overdose_threshold = 25
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 14)
	metabolized_traits = list(TRAIT_PACIFISM)

/datum/reagent/medicine/earthsblood/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustBruteLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype) //slow to start, but very quick healing once it gets going
	need_mob_update += affected_mob.adjustFireLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustOxyLoss(-6 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjustToxLoss(-5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustStaminaLoss(-8 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM * seconds_per_tick, 150, affected_organ_flags)
	affected_mob.adjust_jitter_up_to(6 SECONDS * REM * seconds_per_tick, 1 MINUTES)
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.say(return_hippie_line(), forced = /datum/reagent/medicine/earthsblood)
		affected_mob.adjust_drugginess_up_to(20 SECONDS * REM * seconds_per_tick, 30 SECONDS * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/earthsblood/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_instability(-round(volume*0.75))
		myseed.adjust_potency(round(volume * 1))
		myseed.adjust_yield(round(volume * 1))
		myseed.adjust_endurance(round(volume*0.75))
		myseed.adjust_production(round(volume*0.25))
