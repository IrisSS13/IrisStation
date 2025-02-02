//standard version
/datum/round_event_control/cognomerge
	name = "Monadic Cognomerge"
	typepath = /datum/round_event/cognomerge
	weight = 15
	min_players = 5
	max_occurrences = 2
	category = EVENT_CATEGORY_HEALTH
	description = "All crewmembers temporarily gain a random negative quirk."

/datum/round_event/cognomerge
	announce_when = 1
	start_when = 21
	end_when = 51
	//list of quirks this version of the event can add, only includes those that might produce interesting scenarios and will have time to do so
	var/list/cognomerge_quirk_pool = list(
		/datum/quirk/item_quirk/allergic,
		/datum/quirk/bighands,
		/datum/quirk/clumsy,
		/datum/quirk/frail,
		/datum/quirk/illiterate,
		/datum/quirk/numb,
		/datum/quirk/nyctophobia,
		/datum/quirk/photophobia,
		/datum/quirk/poor_aim,
		/datum/quirk/prosopagnosia,
		/datum/quirk/social_anxiety,
		/datum/quirk/softspoken,
		/datum/quirk/touchy
	)
	//time before the quirk is removed after being added
	var/cognomerge_duration = 15 SECONDS
	//do we multiply this duration by a random value, 1 - 3
	var/vary_duration = TRUE
	//alert sound played during the announcement of this event
	var/audio_alert = 'sound/announcer/notice/notice2.ogg'

/datum/round_event/cognomerge/announce()
	priority_announce("[station_name()]: Alert! Unitary conceptual metastasization in progress, temporary cognitive and physiological maluses may result.",
	sound = audio_alert,
	sender_override = "Metaphysical Entity Watchdog")

/datum/round_event/cognomerge/start()
	var/datum/quirk/chosen_quirk = pick(cognomerge_quirk_pool)

	var/duration = cognomerge_duration
	if(vary_duration)
		duration *= rand(1, 3)

	var/list/victims = GLOB.human_list
	for(var/mob/living/carbon/human/victim in victims)
		if(!victim.client)
			continue //skip clientless
		var/turf/victim_turf = get_turf(victim)
		if(!is_station_level(victim_turf.z))
			continue //skip those not on the station level
		if(victim.add_quirk(chosen_quirk)) //only set a timer to remove the quirk if adding it succeeds (it will fail if they already possess the quirk)
			addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, remove_quirk), chosen_quirk), duration)

//extreme version (adds harsher quirks)
/datum/round_event_control/cognomerge/extreme
	name = "Extreme Monadic Cognomerge"
	typepath = /datum/round_event/cognomerge/extreme
	weight = 5
	max_occurrences = 1

/datum/round_event/cognomerge/extreme
	cognomerge_quirk_pool = list(
		/datum/quirk/cursed,
		/datum/quirk/item_quirk/deafness,
		/datum/quirk/item_quirk/blindness,
		/datum/quirk/hemiplegic,
		/datum/quirk/paraplegic
	)
	audio_alert = 'sound/announcer/notice/notice3.ogg'
