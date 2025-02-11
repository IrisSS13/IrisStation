//standard version
/datum/round_event_control/cognomerge
	name = "Monadic Cognomerge"
	typepath = /datum/round_event/cognomerge
	weight = 15
	min_players = 5
	max_occurrences = 2
	category = EVENT_CATEGORY_HEALTH
	description = "All crewmembers temporarily gain a random negative quirk."
	admin_setup = list(
		/datum/event_admin_setup/input_number/cognomerge/duration,
		/datum/event_admin_setup/listed_options/cognomerge/vary_duration
	)

/datum/round_event/cognomerge
	announce_when = 1
	start_when = 21
	end_when = 51
	//list of quirks this version of the event can add, only includes those that might produce interesting scenarios and will have time to do so
	var/list/cognomerge_quirk_pool = list(
		/datum/quirk/item_quirk/allergic/noitem,
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
	priority_announce("Alert [station_name()]: Unitary conceptual metastasization in progress, temporary cognitive and physiological maluses may result.",
	sound = audio_alert,
	sender_override = "Metaphysical Entity Watchdog")

/datum/round_event/cognomerge/start()
	var/datum/quirk/chosen_quirk = pick(cognomerge_quirk_pool)

	var/duration = cognomerge_duration
	if(vary_duration)
		duration *= rand(1, 3)
	end_when = (start_when + ROUND_UP((duration * 0.05) + 5)) //end proc should be called ~10s after quirk removal

	var/list/victims = GLOB.human_list
	for(var/mob/living/carbon/human/victim in victims)
		if(!victim.client)
			continue //skip clientless
		var/turf/victim_turf = get_turf(victim)
		if(!is_station_level(victim_turf.z))
			continue //skip those not on the station level
		if(try_add_quirk(victim, chosen_quirk)) //only set a timer to remove the quirk if adding it succeeds (it will fail if they already possess the quirk)
			addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, remove_quirk), chosen_quirk), duration, TIMER_DELETE_ME)

/datum/round_event/cognomerge/try_add_quirk(mob/living/carbon/human/victim, datum/quirk/chosen_quirk)
	//handle our noitem special cases
	switch(chosen_quirk)
		if(/datum/quirk/item_quirk/allergic/noitem)
			if(victim.has_quirk(/datum/quirk/item_quirk/allergic))
				return FALSE
		if(/datum/quirk/item_quirk/deafness/noitem)
			if(victim.has_quirk(/datum/quirk/item_quirk/deafness))
				return FALSE
		if(/datum/quirk/item_quirk/blindness/noitem)
			if(victim.has_quirk(/datum/quirk/item_quirk/blindness))
				return FALSE
		if(/datum/quirk/paraplegic/noitem)
			if(victim.has_quirk(/datum/quirk/paraplegic))
				return FALSE

	if(victim.add_quirk(chosen_quirk))
		return TRUE
	else
		return FALSE

/datum/round_event/cognomerge/end()
	priority_announce("Update [station_name()]: The assimilatory phase has reached its conclusion, no further health risk is anticipated at this time.",
	sound = audio_alert,
	sender_override = "Metaphysical Entity Watchdog")

//extreme version (adds harsher quirks)
/datum/round_event_control/cognomerge/extreme
	name = "Xtrm. Monadic Cognomerge"
	typepath = /datum/round_event/cognomerge/extreme
	weight = 5
	max_occurrences = 1
	description = "All crewmembers temporarily gain a harsh random negative quirk."

/datum/round_event/cognomerge/extreme
	cognomerge_quirk_pool = list(
		/datum/quirk/cursed,
		/datum/quirk/item_quirk/deafness/noitem,
		/datum/quirk/item_quirk/blindness/noitem,
		/datum/quirk/hemiplegic,
		/datum/quirk/paraplegic/noitem
	)
	audio_alert = 'sound/announcer/notice/notice3.ogg'

//admin options
/datum/event_admin_setup/input_number/cognomerge/duration
	input_text = "For how long should a quirk be applied (in seconds)?"
	default_value = 15
	max_value = 300
	min_value = 1

/datum/event_admin_setup/input_number/cognomerge/duration/prompt_admins()
	var/customize_duration = tgui_alert(usr, "Set event duration!", event_control.name, list("Default", "Custom"))
	switch(customize_duration)
		if("Custom")
			return ..()
		if("Default")
			chosen_value = default_value
		else
			return ADMIN_CANCEL_EVENT

/datum/event_admin_setup/input_number/cognomerge/duration/apply_to_event(datum/round_event/cognomerge/event)
	event.cognomerge_duration = chosen_value SECONDS

/datum/event_admin_setup/listed_options/cognomerge/vary_duration
	input_text = "Randomly vary the event duration? May be 100, 200 or 300% of the selected time."
	normal_run_option = "Yes"

/datum/event_admin_setup/listed_options/cognomerge/vary_duration/get_list()
	return list("No")

/datum/event_admin_setup/listed_options/cognomerge/vary_duration/apply_to_event(datum/round_event/cognomerge/event)
	switch(chosen)
		if("No")
			event.vary_duration = FALSE
		if("Yes")
			event.vary_duration = TRUE
		else
			return ADMIN_CANCEL_EVENT

