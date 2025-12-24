// Admin verb to apply parallax to players
ADMIN_VERB(apply_parallax, R_FUN, "Parallax", "Apply a parallax overlay to players (all or single).", ADMIN_CATEGORY_GAME)
	var/client/holder = usr.client
	if(!holder)
		return

	if(!GLOB.parallax_manager)
		GLOB.parallax_manager = new /datum/parallax_manager

	if(!(islist(GLOB.parallax_manager.roundstart_parallax_defaults) && length(GLOB.parallax_manager.roundstart_parallax_defaults)))
		GLOB.parallax_manager.save_roundstart_parallax_defaults()

	var/default_icon_path = ""
	var/default_icon_state = ""
	if(islist(GLOB.parallax_manager.roundstart_parallax_defaults) && length(GLOB.parallax_manager.roundstart_parallax_defaults))
		// saved format: [type, icon, state, maybe_color]
		var/default_entry = GLOB.parallax_manager.roundstart_parallax_defaults[1]
		if(islist(default_entry) && length(default_entry) >= 3)
			// in case theyre nested lists
			if(islist(default_entry[1]) && length(default_entry[1]) >= 3)
				default_icon_path = default_entry[1][2] || ""
				default_icon_state = default_entry[1][3] || ""
			else
				default_icon_path = default_entry[2] || ""
				default_icon_state = default_entry[3] || ""
	var/quick_choice = tgui_input_list(holder, "Quick Action", "Quick Action", list("Continue", "Clear Global Override"))
	if(quick_choice == "Clear Global Override")
		GLOB.parallax_manager.clear_parallax_global_override(TRUE)
		message_admins("[key_name_admin(usr)] cleared the global parallax override.")
		log_admin("[key_name(usr)] cleared the global parallax override.")
		return
	var/choice = tgui_input_list(holder, "Apply parallax to...", "Parallax Scope", list("All Connected Users", "Single Mob"))


	var/action_choice = tgui_input_list(holder, "Action", "Apply or Restore", list("Apply/Customize", "Restore to Default", "Cancel"))
	if(!action_choice || action_choice == "Cancel")
		return
	if(action_choice == "Restore to Default")
		if(choice == "All Connected Users")
			for(var/i = 1; i <= GLOB.player_list.len; i++)
				var/mob/player = GLOB.player_list[i]
				if(!player || QDELETED(player))
					continue
				if(!istype(player, /mob))
					continue
				if(!player.client || !player.hud_used)
					continue
				GLOB.parallax_manager.restore_parallax_defaults(player)
			SSblackbox.record_feedback("nested tally", "admin_parallax_used", 1, list("Parallax All Restore"))
			message_admins("[key_name_admin(usr)] restored parallax to default for all connected users.")
			log_admin("[key_name(usr)] restored parallax to default for all connected users.")
			return
		if(choice == "Single Mob")
			var/selected = tgui_input_list(holder, "Choose a player", "Target Player", GLOB.player_list)
			if(!selected)
				return
			var/mob/target_mob = null
			if(istype(selected, /mob))
				target_mob = selected
			else if(isnum(selected))
				target_mob = GLOB.player_list[selected]
			else if(istext(selected))
				for(var/mob/candidate_mob as anything in GLOB.player_list)
					if(key_name(candidate_mob) == selected || candidate_mob.real_name == selected)
						target_mob = candidate_mob
							break

			if(!target_mob || !target_mob.hud_used)
				to_chat(holder, span_warning("Target has no HUD or client."), confidential = TRUE)
				return
			GLOB.parallax_manager.restore_parallax_defaults(target_mob)
			SSblackbox.record_feedback("nested tally", "admin_parallax_used", 1, list("Parallax Single Restore", key_name(target_mob)))
			message_admins("[key_name_admin(usr)] restored parallax to default for [key_name(target_mob)].")
			log_admin("[key_name(usr)] restored parallax to default for [key_name(target_mob)].")
			return
	var/icon_path = tgui_input_text(holder, "Optional: Path to a DMI/icon to use for parallax", "Parallax Icon", default_icon_path) || null
	var/icon_state = tgui_input_text(holder, "Optional: Icon state in the DMI (e.g. planet, stars, dyable).", "Parallax State", default_icon_state) || null

	var/colour_choice = tgui_input_list(holder, "Parallax colour to apply", "Parallax Colour", list("Default", "Custom", "Remove Colour"))
	if(!colour_choice)
		return
	var/colour_input = null
	if(colour_choice == "Custom")
		colour_input = tgui_input_text(holder, "Custom hex colour (e.g. #RRGGBB)", "Parallax Colour (Custom)", "") || null

	var/color_mode = (colour_choice == "Default") ? "default" : ((colour_choice == "Remove Colour") ? "remove" : colour_input)

	var/mode = tgui_input_list(holder, "Parallax mode", "Mode", list("Default (all layers)", "Layer_1 only"))
	if(!mode)
		return
	var/mode_param = null
	switch(mode)
		if("Default (all layers)")
			mode_param = null
		if("Layer_1 only")
			mode_param = "layer_1"

	if(icon_path)
		icon_path = trim(icon_path)
		if(!length(icon_path))
			icon_path = null
		else if(!is_valid_dmi_file(icon_path))
			var/resolved = get_icon_dmi_path(icon_path)
			if(resolved)
				icon_path = resolved

	var/ok = TRUE
	var/msg = ""
	if(icon_path)
		if(!is_valid_dmi_file(icon_path))
			ok = FALSE
			msg = "The provided icon path does not look like a valid icons/*.dmi path."
		if(ok && icon_state && !icon_exists(icon_path, icon_state))
			ok = FALSE
			msg = "The icon state '[icon_state]' was not found in [icon_path]."
		if(ok && !icon_state && !icon_exists(icon_path, ""))
			ok = FALSE
			msg = "The icon file [icon_path] was not found on the server."
	if(!ok)
		var/choice_warn = tgui_alert(holder, "[msg]\n\nDo you want to apply the parallax anyway?", "Icon Validation Warning", list("Apply Anyway", "Cancel"))
		if(!choice_warn || choice_warn == "Cancel")
			return

	var/future_choice = tgui_input_list(holder, "Apply to new joiners?", "Future Joiners", list("No", "Yes - Make Global"))
	if(!future_choice)
		return

	var/apply_now_glob = FALSE
	if(future_choice == "Yes - Make Global")
		var/apply_now_choice = tgui_input_list(holder, "Also apply now to current players?", "Apply Now", list("No", "Yes - apply now"))
		if(!apply_now_choice)
			return
		apply_now_glob = (apply_now_choice == "Yes - apply now")

	if(choice == "All Connected Users")
		for(var/i = 1; i <= GLOB.player_list.len; i++)
			var/mob/player = GLOB.player_list[i]
			if(!player || QDELETED(player))
				continue
			if(!istype(player, /mob))
				continue
			if(!player.client || !player.hud_used)
				continue
			player.hud_used.create_custom_parallax(player, icon_path, icon_state, color_mode, mode_param)
			player.hud_used.update_parallax(player)
		if(future_choice == "Yes - Make Global")
			var/confirm_all = tgui_alert(holder, "Setting a global parallax override will affect future joiners and may affect current players if 'Apply now' is selected.\n\nDo you want to set this as the global override?", "Confirm Global Override", list("Set Global Override", "Cancel"))
			if(!confirm_all || confirm_all == "Cancel")
				to_chat(holder, span_warning("Global parallax override cancelled."), confidential = TRUE)
			else
				GLOB.parallax_manager.set_parallax_global_override(icon_path, icon_state, null, null, color_mode, mode_param, apply_now_glob)
				message_admins("[key_name_admin(usr)] set a global parallax override.")
				log_admin("[key_name(usr)] set global parallax override: [icon_path], [icon_state], colour_mode=[color_mode]")

		SSblackbox.record_feedback("nested tally", "admin_parallax_used", 1, list("Parallax All", icon_path, icon_state, color_mode))
		message_admins("[key_name_admin(usr)] applied parallax to all connected users.")
		log_admin("[key_name(usr)] applied parallax to all connected users. icon: [icon_path], state: [icon_state], colour_mode: [color_mode]")
		return

	if(choice == "Single Mob")
		var/selected = tgui_input_list(holder, "Choose a player", "Target Player", GLOB.player_list)
		if(!selected)
			return
		var/mob/target_mob = null
		if(istype(selected, /mob))
			target_mob = selected
		else if(isnum(selected))
			target_mob = GLOB.player_list[selected]
		else if(istext(selected))
			for(var/pi = 1; pi <= length(GLOB.player_list); pi++)
				var/mob/candidate_mob = GLOB.player_list[pi]
				if(key_name(candidate_mob) == selected || candidate_mob.real_name == selected)
					target_mob = candidate_mob
					break

		if(!target_mob || !target_mob.hud_used)
			to_chat(holder, span_warning("Target has no HUD or client."), confidential = TRUE)
			return

		target_mob.hud_used.create_custom_parallax(target_mob, icon_path, icon_state, color_mode, mode_param)
		target_mob.hud_used.update_parallax(target_mob)
		if(future_choice == "Yes - Make Global")
			var/confirm = tgui_alert(holder, "Setting a global parallax override will affect future joiners and may affect current players if 'Apply now' is selected.\n\nDo you want to set this as the global override?", "Confirm Global Override", list("Set Global Override", "Cancel"))
			if(!confirm || confirm == "Cancel")
				to_chat(holder, span_warning("Global parallax override cancelled."), confidential = TRUE)
			else
				GLOB.parallax_manager.set_parallax_global_override(icon_path, icon_state, null, null, color_mode, mode_param, apply_now_glob)
				message_admins("[key_name_admin(usr)] set a global parallax override.")
				log_admin("[key_name(usr)] set global parallax override: [icon_path], [icon_state], colour_mode=[color_mode]")
		SSblackbox.record_feedback("nested tally", "admin_parallax_used", 1, list("Parallax Single", key_name(target_mob), icon_path, icon_state, color_mode))
		message_admins("[key_name_admin(usr)] applied parallax to [key_name(target_mob)].")
		log_admin("[key_name(usr)] applied parallax to [key_name(target_mob)]. icon: [icon_path], state: [icon_state], colour_mode: [color_mode]")
		return
