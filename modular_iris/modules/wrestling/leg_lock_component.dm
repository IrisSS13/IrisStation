/datum/component/leg_locked
	/// Holds the mob applying the leg lock to our parent
	var/mob/living/carbon/human/lock_source

/datum/component/leg_locked/Initialize(lock_source)
	. = ..()
	if(!(istype(parent, /mob/living/carbon/human) && istype(lock_source, /mob/living/carbon/human)))
		return COMPONENT_INCOMPATIBLE
	src.lock_source = lock_source
	START_PROCESSING(SSprocessing, src)

/datum/component/leg_locked/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/victim = parent //component won't be added if this isn't true, so no need to check again
	if(lock_source.is_wrestling && victim.dna.species.grab_maneuver_state_check(lock_source, victim))
		victim.Immobilize(2.1 SECONDS, TRUE)
	else
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)
