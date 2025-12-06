/datum/deathmatch_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	// Intercept host actions to check minimum player requirement
	if(action == "host" && isobserver(usr))
		// Check if there are enough active players
		if(get_active_player_count_deathmatch() < CONFIG_GET(number/deathmatch_min_players))
			tgui_alert(usr, "There must be at least [CONFIG_GET(number/deathmatch_min_players)] active players to create a deathmatch lobby.")
			return TRUE // Prevent the parent call

	return ..()
