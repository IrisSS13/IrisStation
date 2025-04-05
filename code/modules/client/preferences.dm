GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	/// The path to the general savefile for this datum
	var/path
	/// Whether or not we allow saving/loading. Used for guests, if they're enabled
	var/load_and_save = TRUE
	/// Ensures that we always load the last used save, QOL
	var/default_slot = 1
	/// The maximum number of slots we're allowed to contain
	var/max_save_slots = 30 //NOVA EDIT - ORIGINAL 3

	/// Bitflags for communications that are muted
	var/muted = NONE
	/// Last IP that this client has connected from
	var/last_ip
	/// Last CID that this client has connected from
	var/last_id

	/// Cached changelog size, to detect new changelogs since last join
	var/lastchangelog = ""

	/// List of ROLE_X that the client wants to be eligible for
	var/list/be_special = list() //Special role selection

	/// Custom keybindings. Map of keybind names to keyboard inputs.
	/// For example, by default would have "swap_hands" -> list("X")
	var/list/key_bindings = list()

	/// Cached list of keybindings, mapping keys to actions.
	/// For example, by default would have "X" -> list("swap_hands")
	var/list/key_bindings_by_key = list()

	var/toggles = TOGGLES_DEFAULT
	var/db_flags = NONE
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"

	//character preferences
	var/slot_randomized //keeps track of round-to-round randomization of the character slot, prevents overwriting

	var/list/randomise = list()

	//Quirk list
	var/list/all_quirks = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

	/// The current window, PREFERENCE_TAB_* in [`code/__DEFINES/preferences.dm`]
	var/current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES

	var/unlock_content = 0

	var/list/ignoring = list()

	var/list/exp = list()

	var/action_buttons_screen_locs = list()

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until
	///What outfit typepaths we've favorited in the SelectEquipment menu
	var/list/favorite_outfits = list()

	/// A preview of the current character
	var/atom/movable/screen/map_view/char_preview/character_preview_view

	/// A list of instantiated middleware
	var/list/datum/preference_middleware/middleware = list()

	/// The json savefile for this datum
	var/datum/json_savefile/savefile

	/// The savefile relating to character preferences, PREFERENCE_CHARACTER
	var/list/character_data

	/// A list of keys that have been updated since the last save.
	var/list/recently_updated_keys = list()

	/// A cache of preference entries to values.
	/// Used to avoid expensive READ_FILE every time a preference is retrieved.
	var/value_cache = list()

	/// If set to TRUE, will update character_profiles on the next ui_data tick.
	var/tainted_character_profiles = FALSE

/datum/preferences/Destroy(force)
	QDEL_NULL(character_preview_view)
	QDEL_LIST(middleware)
	value_cache = null
	//NOVA EDIT ADDITION
	if(pref_species)
		QDEL_NULL(pref_species)
	//NOVA EDIT END
	return ..()

/datum/preferences/New(client/parent)
	src.parent = parent

	for (var/middleware_type in subtypesof(/datum/preference_middleware))
		middleware += new middleware_type(src)

	if(IS_CLIENT_OR_MOCK(parent))
		load_and_save = !is_guest_key(parent.key)
		load_path(parent.ckey)
		if(load_and_save && !fexists(path))
			try_savefile_type_migration()

		refresh_membership()
	else
		CRASH("attempted to create a preferences datum without a client or mock!")
	load_savefile()

	// give them default keybinds and update their movement keys
	key_bindings = deep_copy_list(GLOB.default_hotkeys)
	key_bindings_by_key = get_key_bindings_by_key(key_bindings)
	randomise = get_default_randomization()

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			// NOVA EDIT START - Sanitizing preferences
			sanitize_languages()
			sanitize_quirks()
			// NOVA EDIT END
			return // NOVA EDIT - Don't remove this. Just don't. Nothing is worth forced random characters.
	//we couldn't load character data so just randomize the character appearance + name
	randomise_appearance_prefs() //let's create a random character then - rather than a fat, bald and naked man.
	if(parent)
		apply_all_client_preferences()
		parent.set_macros()

	if(!loaded_preferences_successfully)
		save_preferences()
	save_character() //let's save this new random character so it doesn't keep generating new ones.

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	// There used to be code here that readded the preview view if you "rejoined"
	// I'm making the assumption that ui close will be called whenever a user logs out, or loses a window
	// If this isn't the case, kill me and restore the code, thanks

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		character_preview_view = create_character_preview_view(user)
		ui = new(user, src, "PreferencesMenu")
		ui.set_autoupdate(FALSE)
		ui.open()
		character_preview_view.display_to(user, ui.window)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

// Without this, a hacker would be able to edit other people's preferences if
// they had the ref to Topic to.
/datum/preferences/ui_status(mob/user, datum/ui_state/state)
	return user.client == parent ? UI_INTERACTIVE : UI_CLOSE

/datum/preferences/ui_data(mob/user)
	var/list/data = list()

	if (tainted_character_profiles)
		data["character_profiles"] = create_character_profiles()
		tainted_character_profiles = FALSE
	//NOVA EDIT ADDITION BEGIN
	data["preview_selection"] = preview_pref
	data["quirk_points_enabled"] = !CONFIG_GET(flag/disable_quirk_points)
	data["quirks_balance"] = GetQuirkBalance()
	data["positive_quirk_count"] = GetPositiveQuirkCount()
	//NOVA EDIT ADDITION END

	data["character_preferences"] = compile_character_preferences(user)

	data["active_slot"] = default_slot

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_data(user)

	return data

/datum/preferences/ui_static_data(mob/user)
	var/list/data = list()

	data["preview_options"] = list(PREVIEW_PREF_JOB, PREVIEW_PREF_LOADOUT, PREVIEW_PREF_UNDERWEAR, PREVIEW_PREF_NAKED)

	data["character_profiles"] = create_character_profiles()

	data["character_preview_view"] = character_preview_view.assigned_map
	data["overflow_role"] = SSjob.get_job_type(SSjob.overflow_role).title
	data["window"] = current_window

	data["content_unlocked"] = unlock_content

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_static_data(user)

	return data

/datum/preferences/ui_assets(mob/user)
	var/list/assets = list(
		get_asset_datum(/datum/asset/spritesheet_batched/preferences),
		get_asset_datum(/datum/asset/json/preferences),
	)

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		assets += preference_middleware.get_ui_assets()

	return assets

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	if(SSlag_switch.measures[DISABLE_CREATOR] && action != "change_slot")
		to_chat(usr, "The creator has been disabled. Please do not ahelp.")
		return

	log_creator("[key_name(usr)] ACTED [action] | PREFERENCE: [params["preference"]] | VALUE: [params["value"]]")

	switch (action)
		if ("change_slot")
			// Save existing character
			save_character()
			// SAFETY: `switch_to_slot` performs sanitization on the slot number
			switch_to_slot(params["slot"])
			return TRUE
		if ("remove_current_slot")
			remove_current_slot()
			return TRUE
		if ("rotate")
			/* NOVA EDIT - Bi-directional prefs menu rotation - ORIGINAL:
			character_preview_view.setDir(turn(character_preview_view.dir, -90))
			*/ // ORIGINAL END - NOVA EDIT START:
			var/backwards = params["backwards"]
			character_preview_view.setDir(turn(character_preview_view.dir, backwards ? 90 : -90))
			// NOVA EDIT END
			return TRUE
		if ("set_preference")
			var/requested_preference_key = params["preference"]
			var/value = params["value"]

			for (var/datum/preference_middleware/preference_middleware as anything in middleware)
				if (preference_middleware.pre_set_preference(usr, requested_preference_key, value))
					return TRUE

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			// SAFETY: `update_preference` performs validation checks
			if (!update_preference(requested_preference, value))
				return FALSE

			if (istype(requested_preference, /datum/preference/name))
				tainted_character_profiles = TRUE
			//NOVA EDIT ADDITION START
			update_mutant_bodyparts(requested_preference)
			for (var/datum/preference_middleware/preference_middleware as anything in middleware)
				if (preference_middleware.post_set_preference(usr, requested_preference_key, value))
					return TRUE
			//NOVA EDIT ADDITION END
			return TRUE
		if ("set_color_preference")
			var/requested_preference_key = params["preference"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/color))
				return FALSE

			var/default_value = read_preference(requested_preference.type)

			// Yielding
			var/new_color = input(
				usr,
				"Select new color",
				null,
				default_value || COLOR_WHITE,
			) as color | null

			if (!new_color)
				return FALSE

			if (!update_preference(requested_preference, new_color))
				return FALSE

			return TRUE
		// NOVA EDIT ADDITION START
		if("update_preview")
			preview_pref = params["updated_preview"]
			character_preview_view.update_body()
			return TRUE

		// IRIS EDIT ADDITION START: Background Selection from https://github.com/Bubberstation/Bubberstation/pull/3015
		if("update_background")
			update_preference(GLOB.preference_entries[/datum/preference/choiced/background_state], params["new_background"])
			return TRUE
		//IRIS EDIT ADDITION END: Background Selection

		if ("open_food")
			GLOB.food_prefs_menu.ui_interact(usr)
			return TRUE

		if ("set_tricolor_preference")
			var/requested_preference_key = params["preference"]
			var/index_key = params["value"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/tri_color))
				return FALSE

			var/default_value_list = read_preference(requested_preference.type)
			if (!islist(default_value_list))
				return FALSE
			var/default_value = default_value_list[index_key]

			// Yielding
			var/new_color = input(
				usr,
				"Select new color",
				null,
				default_value || COLOR_WHITE,
			) as color | null

			if (!new_color)
				return FALSE

			default_value_list[index_key] = new_color

			if (!update_preference(requested_preference, default_value_list))
				return FALSE

			return TRUE

		// For the quirks in the prefs menu.
		if ("get_quirks_balance")
			return TRUE
		//NOVA EDIT ADDITION END

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/delegation = preference_middleware.action_delegations[action]
		if (!isnull(delegation))
			return call(preference_middleware, delegation)(params, usr)

	return FALSE

/datum/preferences/ui_close(mob/user)
	save_character()
	save_preferences()
	QDEL_NULL(character_preview_view)

/datum/preferences/Topic(href, list/href_list)
	. = ..()
	if (.)
		return

	if (href_list["open_keybindings"])
		current_window = PREFERENCE_TAB_KEYBINDINGS
		update_static_data(usr)
		ui_interact(usr)
		return TRUE

/datum/preferences/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, src)
	character_preview_view.generate_view("character_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()

	return character_preview_view

/datum/preferences/proc/compile_character_preferences(mob/user)
	var/list/preferences = list()

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (!preference.is_accessible(src))
			continue

		var/value = read_preference(preference.type)
		var/data = preference.compile_ui_data(user, value)

		LAZYINITLIST(preferences[preference.category])
		preferences[preference.category][preference.savefile_key] = data


	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/list/append_character_preferences = preference_middleware.get_character_preferences(user)
		if (isnull(append_character_preferences))
			continue

		for (var/category in append_character_preferences)
			if (category in preferences)
				preferences[category] += append_character_preferences[category]
			else
				preferences[category] = append_character_preferences[category]

	return preferences

/// Applies all PREFERENCE_PLAYER preferences
/datum/preferences/proc/apply_all_client_preferences()
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_PLAYER)
			continue

		value_cache -= preference.type
		preference.apply_to_client(parent, read_preference(preference.type))

/// A preview of a character for use in the preferences menu
/atom/movable/screen/map_view/char_preview
	name = "character_preview"

	/// The body that is displayed
	var/mob/living/carbon/human/dummy/body
	/// The preferences this refers to
	var/datum/preferences/preferences
	/// Whether we show current job clothes or nude/loadout only
	var/show_job_clothes = TRUE

	// IRIS EDIT ADDITION START: Better character preview: Rescales between 32x32, 64x64 and 96x96, from https://github.com/Bubberstation/Bubberstation/pull/3015
	var/image/canvas
	var/last_canvas_size
	var/last_canvas_state
	var/oversized_species
	// IRIS EDIT END

/atom/movable/screen/map_view/char_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	src.preferences = preferences

/atom/movable/screen/map_view/char_preview/Destroy()
	// IRIS EDIT ADDITION START: Better character preview, from https://github.com/Bubberstation/Bubberstation/pull/3015
	canvas?.cut_overlays()
	QDEL_NULL(canvas)
	// IRIS EDIT END
	QDEL_NULL(body)
	preferences?.character_preview_view = null
	preferences = null
	return ..()

/// Updates the currently displayed body
/atom/movable/screen/map_view/char_preview/proc/update_body()
	if (isnull(body))
		create_body()
	else
		body.wipe_state()

	// IRIS EDIT BEGIN: Better character preview, from https://github.com/Bubberstation/Bubberstation/pull/3015
	// appearance = preferences.render_new_preview_appearance(body, show_job_clothes) // ORIGINAL CODE
	if (canvas)
		canvas.cut_overlays()

	preferences.render_new_preview_appearance(body, show_job_clothes)

	var/canvas_size = 0
	var/canvas_state = preferences.read_preference(/datum/preference/choiced/background_state)

	// Our list of species who are default larger than 32x32, used to call a larger canvas
	oversized_species = list(
		/datum/species/nabber,
	)

	/* NOW ENTERING: THE CLOUDYNEWT SHITCODE ZONE
		The following section controls what canvas size our dummy decides to use.
		Due to byond shennanigans, we can't cleanly scale directly in 48x48,
		so we'll be using multiples of 32x32. As a result, SOME of the canvas
		sizes require you to scale the dummy up, while others require the dummy
		to be at a base.

		On the off-chance some poor soul needs to use this code, I'll break down
		each canvas' use case. I hope to God no other person needs to touch this,
		however.

		[CANVAS 0 - 32x32]
		This is our base canvas, meant to mimic the base implementation of /tg/
		in all the ways that matter. Stick to this unless we NEED a larger space.

		[CANVAS 1 - 160x160]
		The first curveball of the bunch, this canvas should be used on anything
		that stays within the max "tall" bounds	of sprite accessories. Currently
		sized to fit the tallest ears and horns located in their big_[...].dmi's.
		To make sure the character appears accurately scaled, we multiply the
		dummy's body size by *= 4. This is all done to simulate a 40x40 display.

		P.S. This size does not properly support the extra-large wings or tails.
		If you know how to put exclusively the extra-large ones on Canvas 2, by
		all means please do so.

		[CANVAS 2 - 192x192]
		The estranged sister of Canvas 1, Canvas 2 should be used whenever we think
		we might go over the tallest existing sprite accessory. In a perfect world,
		this would be used for when our body size multiplier has been set above 1.1
		while using accessories that could otherwise break the bounds of our 32x32
		base. Unfortunately, I couldn't figure out a good way to get the dummy to
		accurately show the body size as seen in-game. As such, Canvas 2 is as-of-now
		used only when the dummy is a species that is considered "oversized," such
		as Nabbers/GAS. Lastly, it should be noted that Canvas 2 simulates a 48x48
		display.

		[CANVAS 3 - 64x64]
		Back to our "normal" sized canvases, this should be used for sprites that
		we know will break a 48x48 model - namely, taurs. Has a snowflake clause
		to remove the *=4 body size in case your taur is using other sprite
		accessories. Importantly, retains the scaling from the standard body size
		selector.

		P.S. Until a better solution to Canvas 2's body size multiplier is fixed,
		Canvas 3 is ALSO used for characters who have their body size multiplier
		(as selected in the character creator) set to anything other than 1.

		[FALLBACK CANVAS - 96x96]
		On the off-chance something goes catastrophically wrong, we fall back to
		our 96x96 behemoth. Characters with the oversized quirk will use this by
		default, but you really shouldn't see this otherwise. Has a snowflake
		clause to remove the *=4 body size in case your character is using other
		sprite accessories.*/


	// If we have sprite accessories that could go beyond the bounds of the standard 32x32, scale up to Canvas 1
	if (
		(body.dna.mutant_bodyparts["ears"] && body.dna.mutant_bodyparts["ears"]["name"] != "None") \
		|| (body.dna.mutant_bodyparts["horns"] && body.dna.mutant_bodyparts["horns"]["name"] != "None") \
		|| (body.dna.mutant_bodyparts["tail"] && body.dna.mutant_bodyparts["tail"]["name"] != "None") \
	)
		canvas_size = 1
		body.dna.features["body_size"] *= 4
		body.dna.update_body_size()

	// If they have been scaled up one step AND have a body size other than default, scale up to Canvas 3. Would scale to Canvas 2 if I could get the size multiplier working correctly.
	if (!isnull(body.dna.features["body_size"]) && body.dna.features["body_size"] != 4 && canvas_size == 1)
		canvas_size = 3
		body.dna.features["body_size"] /= 4
		body.dna.update_body_size()
	// If we haven't been scaled up one step but we have a body size greater than 1.1, we'll use Canvas 3 to retain the wonky scaling. If it's less than 1, we'll use the base canvas, so it's a little clearer what you're looking at.
	else if(!isnull(body.dna.features["body_size"]) && body.dna.features["body_size"] != 1 && (!canvas_size == 1))
		if(body.dna.features["body_size"] > 1)
			canvas_size = 3
		else if(body.dna.features["body_size"] < 1)
			canvas_size = 0

	// Scales up to Canvas 2 if your species is larger than 32x32
	if(body.dna.species.type in oversized_species)
		if(body.dna.features["body_size"] >= 3.2)
			canvas_size = 2
		else
			body.dna.features["body_size"] *= 4
			body.dna.update_body_size()
			canvas_size = 2

	// Being a taur scales us up to Canvas 3
	if (body.dna.mutant_bodyparts["taur"] && body.dna.mutant_bodyparts["taur"]["name"] != "None")
		canvas_size = 3
		if(body.dna.features["body_size"] >= 3.2)
			body.dna.features["body_size"] /= 4
			body.dna.update_body_size()

	// Fully zooms out if we're oversized
	if (preferences.all_quirks.Find("Oversized"))
		canvas_size += 4
		if(body.dna.features["body_size"] >= 3.2)
			body.dna.features["body_size"] /= 4
			body.dna.update_body_size()

	/* NOW EXITING: THE CLOUDYNEWT SHITCODE ZONE
		On to better code that I DIDN'T write! The following section, taken from Bubber,
		helps our preview find which canvas dimensions we want to use.

		If you ever need to add a new canvas size, for some god-forsaken reason, just
		plug in a if(4) before the final else in the switch statement.

		Pixel_X controls the offset to make certain your dummy is centered in the preview.
		As a general rule of thumb, pixel_x should be 16((Dimensions/32)-1). For example,
		for a canvas set to 192x192, you would do 16((192/32)-1) = 16(6-1) = 16(5) = 80.
	*/
	if (last_canvas_size != canvas_size || last_canvas_state != canvas_state)
		QDEL_NULL(canvas)
		switch(canvas_size)
			if(0)
				body.pixel_x = 0
				canvas = image('modular_iris/icons/customization/template.dmi', icon_state = canvas_state)
			if(1)
				body.pixel_x = 64
				canvas = image('modular_iris/icons/customization/template_160x160.dmi', icon_state = canvas_state)
			if(2)
				body.pixel_x = 80
				canvas = image('modular_iris/icons/customization/template_192x192.dmi', icon_state = canvas_state)
			if(3)
				body.pixel_x = 16
				canvas = image('modular_iris/icons/customization/template_64x64.dmi', icon_state = canvas_state)
			else
				body.pixel_x = 32
				canvas = image('modular_iris/icons/customization/template_96x96.dmi', icon_state = canvas_state)

	last_canvas_size = canvas_size
	last_canvas_state = canvas_state

	canvas.add_overlay(body.appearance)
	appearance = canvas.appearance
	// IRIS EDIT END

/atom/movable/screen/map_view/char_preview/proc/create_body()
	QDEL_NULL(body)

	body = new

/datum/preferences/proc/create_character_profiles()
	var/list/profiles = list()

	for (var/index in 1 to max_save_slots)
		// It won't be updated in the savefile yet, so just read the name directly
		if (index == default_slot)
			profiles += read_preference(/datum/preference/name/real_name)
			continue

		var/tree_key = "character[index]"
		var/save_data = savefile.get_entry(tree_key)
		var/name = save_data?["real_name"]

		if (isnull(name))
			profiles += null
			continue

		profiles += name

	return profiles

/datum/preferences/proc/set_job_preference_level(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH)
		var/datum/job/overflow_role = SSjob.overflow_role
		var/overflow_role_title = initial(overflow_role.title)

		for(var/other_job in job_preferences)
			if(job_preferences[other_job] == JP_HIGH)
				// Overflow role needs to go to NEVER, not medium!
				if(other_job == overflow_role_title)
					job_preferences[other_job] = null
				else
					job_preferences[other_job] = JP_MEDIUM

	if(level == null)
		job_preferences -= job.title
	else
		job_preferences[job.title] = level

	return TRUE

/datum/preferences/proc/GetQuirkBalance()
	var/bal = 0
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	//NOVA EDIT ADDITION
	for(var/key in augments)
		var/datum/augment_item/aug = GLOB.augment_items[augments[key]]
		bal -= aug.cost
	//NOVA EDIT END
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

/datum/preferences/proc/validate_quirks()
	if(CONFIG_GET(flag/disable_quirk_points))
		return
	if(GetQuirkBalance() < 0)
		all_quirks = list()

/**
 * Safely read a given preference datum from a given client.
 *
 * Reads the given preference datum from the given client, and guards against null client and null prefs.
 * The client object is fickle and can go null at times, so use this instead of read_preference() if you
 * want to ensure no runtimes.
 *
 * returns client.prefs.read_preference(prefs_to_read) or FALSE if something went wrong.
 *
 * Arguments:
 * * client/prefs_holder - the client to read the pref from
 * * datum/preference/pref_to_read - the type of preference datum to read.
 */
/proc/safe_read_pref(client/prefs_holder, datum/preference/pref_to_read)
	if(!prefs_holder)
		return FALSE
	if(prefs_holder && !prefs_holder?.prefs)
		stack_trace("[prefs_holder?.mob] ([prefs_holder?.ckey]) had null prefs, which shouldn't be possible!")
		return FALSE

	return prefs_holder?.prefs.read_preference(pref_to_read)

/**
 * Get the given client's chat toggle prefs.
 *
 * Getter function for prefs.chat_toggles which guards against null client and null prefs.
 * The client object is fickle and can go null at times, so use this instead of directly accessing the var
 * if you want to ensure no runtimes.
 *
 * returns client.prefs.chat_toggles or FALSE if something went wrong.
 *
 * Arguments:
 * * client/prefs_holder - the client to get the chat_toggles pref from.
 */
/proc/get_chat_toggles(client/target)
	if(ismob(target))
		var/mob/target_mob = target
		target = target_mob.client

	if(isnull(target))
		return NONE

	var/datum/preferences/preferences = target.prefs
	if(isnull(preferences))
		stack_trace("[key_name(target)] preference datum was null")
		return NONE

	return preferences.chat_toggles

/// Sanitizes the preferences, applies the randomization prefs, and then applies the preference to the human mob.
/datum/preferences/proc/safe_transfer_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, is_antag = FALSE)
	apply_character_randomization_prefs(is_antag)
	apply_prefs_to(character, icon_updates)

/// Applies the given preferences to a human mob.
/datum/preferences/proc/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, visuals_only = FALSE)  // NOVA EDIT - Customization - ORIGINAL: /datum/preferences/proc/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	character.dna.features = MANDATORY_FEATURE_LIST //NOVA EDIT CHANGE - We need to instansiate the list with the basic features.

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		preference.apply_to_human(character, read_preference(preference.type), src)

	// NOVA EDIT ADDITION START - middleware apply human prefs
	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		preference_middleware.apply_to_human(character, src, visuals_only = visuals_only)
	// NOVA EDIT ADDITION END

	character.dna.real_name = character.real_name

	if(icon_updates)
		character.icon_render_keys = list()
		character.update_body(is_creating = TRUE)

	SEND_SIGNAL(character, COMSIG_HUMAN_PREFS_APPLIED)

/// Returns whether the parent mob should have the random hardcore settings enabled. Assumes it has a mind.
/datum/preferences/proc/should_be_random_hardcore(datum/job/job, datum/mind/mind)
	if(!read_preference(/datum/preference/toggle/random_hardcore))
		return FALSE
	if(job.job_flags & JOB_HEAD_OF_STAFF) //No heads of staff
		return FALSE
	for(var/datum/antagonist/antag as anything in mind.antag_datums)
		if(antag.get_team()) //No team antags
			return FALSE
	return TRUE

/// Inverts the key_bindings list such that it can be used for key_bindings_by_key
/datum/preferences/proc/get_key_bindings_by_key(list/key_bindings)
	var/list/output = list()

	for (var/action in key_bindings)
		for (var/key in key_bindings[action])
			LAZYADD(output[key], action)

	return output

/// Returns the default `randomise` variable ouptut
/datum/preferences/proc/get_default_randomization()
	var/list/default_randomization = list()

	for (var/preference_key in GLOB.preference_entries_by_key)
		var/datum/preference/preference = GLOB.preference_entries_by_key[preference_key]
		if (preference.is_randomizable() && preference.randomize_by_default)
			default_randomization[preference_key] = RANDOM_ENABLED

	return default_randomization

/datum/preferences/proc/refresh_membership()
	var/byond_member = parent.IsByondMember()
	if(isnull(byond_member)) // Connection failure, retry once
		byond_member = parent.IsByondMember()
		var/static/admins_warned = FALSE
		if(!admins_warned)
			admins_warned = TRUE
			message_admins("BYOND membership lookup had a connection failure for a user. This is most likely an issue on the BYOND side but if this consistently happens you should bother your server operator to look into it.")
		if(isnull(byond_member)) // Retrying didn't work, warn the user
			log_game("BYOND membership lookup for [parent.ckey] failed due to a connection error.")
		else
			log_game("BYOND membership lookup for [parent.ckey] failed due to a connection error but succeeded after retry.")

	if(isnull(byond_member))
		to_chat(parent, span_warning("There's been a connection failure while trying to check the status of your BYOND membership. Reconnecting may fix the issue, or BYOND could be experiencing downtime."))

	unlock_content = !!byond_member
	donator_status = !!GLOB.donator_list[parent.ckey] // NOVA EDIT ADDITION - DONATOR CHECK
	if(unlock_content || donator_status) // NOVA EDIT CHANGE - ORIGINAL: if(unlock_content)
		max_save_slots = 50 //NOVA EDIT - ORIGINAL: max_save_slots = 8
