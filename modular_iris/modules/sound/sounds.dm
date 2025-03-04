/**
 * playsound_if_pref is similar to `playsound` but it does not pass through walls, doesn't play for ghosts, and checks for prefs.
 * This is useful if we have something like the organic interface content, which everyone may not want to hear.
 *
 * source - Origin of sound.
 * soundin - Either a file, or a string that can be used to get an SFX.
 * vol - The volume of the sound, excluding falloff and pressure affection.
 * vary - bool that determines if the sound changes pitch every time it plays.
 * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * frequency - playback speed of audio.
 * channel - The channel the sound is played at.
 * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * pref_to_check - the path of the pref that we want to check - defaults to /datum/preference/toggle/sound_eating
 */

/* Nova put this in their lewd_items folder, which got deleted when we removed ERP content. I am adding this proc back in because it IS useful,
* and I hate dealing with the fucking conflicts every time we do an upstream merge! I also have misophonia so I hate hearing the eating and drinking.  - IRIS EDIT
*/

/proc/playsound_if_pref(
	atom/source,
	soundin,
	vol as num,
	vary,
	extrarange as num,
	falloff_exponent = SOUND_FALLOFF_EXPONENT,
	frequency = null,
	channel = 0,
	pressure_affected = TRUE,
	falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
	use_reverb = TRUE,
	pref_to_check = /datum/preference/toggle/sound_eating
)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)
	if(!turf_source || !soundin || !vol || !ispath(pref_to_check))
		return

	//allocate a channel if necessary now so it's the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/sound_to_play = sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	var/list/listeners = get_hearers_in_view(maxdistance, turf_source)
	. = list()//output everything that successfully heard the sound

	if(above_turf && istransparentturf(above_turf))
		listeners += get_hearers_in_view(maxdistance, above_turf)

	if(below_turf && istransparentturf(turf_source))
		listeners += get_hearers_in_view(maxdistance, below_turf)

	for(var/mob/listening_mob in listeners)
		var/checked_pref = listening_mob?.client?.prefs?.read_preference(pref_to_check)
		if(!checked_pref) // pref is disabled or 0 in the case of volume
			continue

		/// volume modifier--for radio noise only currently--can be different for each client based on their radio sound pref.
		var/vol_modifier = 1
		if(ispath(pref_to_check, /datum/preference/numeric/volume/sound_radio_noise))
			vol_modifier = checked_pref / 100

		if(!(get_dist(listening_mob, turf_source) <= maxdistance))
			continue

		listening_mob.playsound_local(turf_source, soundin, vol*vol_modifier, vary, frequency, falloff_exponent, channel, pressure_affected, sound_to_play, maxdistance, falloff_distance, 1, use_reverb)
		. += listening_mob
