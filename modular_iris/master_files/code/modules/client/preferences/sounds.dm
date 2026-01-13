/datum/preference/choiced/sound_ghost_poll_prompt/apply_to_client_updated(client/client, value)
	var/polling_sound_volume = client?.prefs.read_preference(/datum/preference/numeric/sound_ghost_poll_prompt_volume)
	var/polling_sound
	// TODO? This should be a GLOB like GLOB.ghost_poll_prompt_sounds or something. but thats a PR for tg, and tg scares me.
	if(value == GHOST_POLL_PROMPT_1)
		polling_sound = 'sound/misc/prompt1.ogg'
	else if (value == GHOST_POLL_PROMPT_2)
		polling_sound = 'sound/misc/prompt2.ogg'
	if(polling_sound)
		SEND_SOUND(client, sound(polling_sound, volume = polling_sound_volume))
