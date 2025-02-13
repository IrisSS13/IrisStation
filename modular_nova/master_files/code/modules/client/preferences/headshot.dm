// Hey listen! Imgur doesn't actually work, it's been tested.

/datum/preference/text/headshot
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "headshot"
	maximum_value_length = MAX_MESSAGE_LEN
	/// Assoc list of ckeys and their link, used to cut down on chat spam
	var/list/stored_link = list()
	var/static/link_regex = regex("files.catbox.moe|images2.imgbox.com|i.gyazo.com") //IRIS EDIT: updates to use catbox instead of gyazo and byond files. still supports gyazo but i dont recommend it
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

/datum/preference/text/headshot/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target?.dna.features["headshot"] = preferences?.headshot

/datum/preference/text/headshot/is_valid(value)
	if(!length(value)) // Just to get blank ones out of the way
		usr?.client?.prefs?.headshot = null
		return TRUE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		to_chat(usr, span_warning("Your link must be https!"))
		return

	if(!findtext(value, "."))
		to_chat(usr, span_warning("Invalid link!"))
		return
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		to_chat(usr, span_warning("The image must be one of the following extensions: '[english_list(valid_extensions)]'"))
		return

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		to_chat(usr, span_warning("The image must be hosted on one of the following sites: 'Catbox (catbox.moe), Imgbox (images2.imgbox.com)'")) //IRIS EDIT - made it have catbox instead
		return

	apply_headshot(value)
	return TRUE

/datum/preference/text/headshot/proc/apply_headshot(value) // we want a fully sfw image, not a relatively one - IRIS EDIT
	if(usr.client?.get_exp_living(pure_numeric = TRUE) / 0 < 300) //adds check for hours - Iris EDIT
		to_chat(usr, span_warning("You need to play more before you can upload a headshot!"))
		return FALSE
	if(stored_link[usr.ckey] != value)
		to_chat(usr, span_notice("Please use a SFW image of the head and shoulder area to maintain immersion level. Think of it as a headshot for your ID. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
		to_chat(usr, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
		to_chat(usr, span_notice("Keep in mind that the photo will be downsized to 250x250 pixels, so the more square the photo, the better it will look."))
		log_game("[usr] has set their Headshot image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.headshot = value
	return TRUE
