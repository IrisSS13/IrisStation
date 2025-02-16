/datum/antagonist/miscreant
	name = "\improper Miscreant"
	roundend_category = "miscreants"
	antagpanel_category = "Miscreants"
	job_rank = ROLE_MISCREANT
	antag_moodlet = /datum/mood_event/miscreant
	hud_icon = 'modular_iris/modules/miscreants/icons/miscreants_hud.dmi'
	antag_hud_name = "miscreant"
	var/datum/team/miscreants/miscreant_team

/datum/antagonist/miscreant/can_be_owned(datum/mind/new_owner)
	if((new_owner.assigned_role.departments_bitflags & (DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_CAPTAIN | DEPARTMENT_BITFLAG_CENTRAL_COMMAND)) > 0)
		return FALSE
	return ..()

/datum/antagonist/miscreant/admin_add(datum/mind/new_owner, mob/admin)
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has made [key_name_admin(new_owner)] a miscreant.")
	log_admin("[key_name(admin)] has made [key_name(new_owner)] a miscreant.")
	to_chat(new_owner.current, span_userdanger("You are a miscreant!"))

/datum/antagonist/miscreant/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_team_hud(M, /datum/antagonist/miscreant)

/datum/antagonist/miscreant/on_gain()
	. = ..()
	var/list/miscreant_teams = list()
	for(var/datum/team/miscreants/team in GLOB.antagonist_teams)
		miscreant_teams += team
	if(miscreant_teams.len == 0) //no existing teams so make a new one
		miscreant_team = new/datum/team/miscreants(clamp(round(GLOB.alive_player_list.len * 0.2, 1), 2, 8))
	var/full_teams_count = 0
	for(var/datum/team/miscreants/existing_team in miscreant_teams)
		if(existing_team.members.len >= existing_team.max_miscreants)
			full_teams_count++
			if(full_teams_count == miscreant_teams.len) //all existing teams are full so make a new one
				miscreant_team = new/datum/team/miscreants(clamp(round(GLOB.alive_player_list.len * 0.2, 1), 2, 8))
				break
			continue
		miscreant_team = existing_team //otherwise assign to first team with a spot
		miscreant_team.members += owner
		break
	objectives += miscreant_team.objectives
	owner.current.log_message("has been converted into a miscreant!", LOG_ATTACK, color="red")

/datum/antagonist/miscreant/on_removal()
	objectives -= miscreant_team.objectives
	. = ..()

/datum/antagonist/miscreant/greet()
	. = ..()
	to_chat(owner, span_userdanger("Help your cause. Do not harm your fellow miscreants. You can identify your comrades by the brown \"M\" icons."))
	handle_announcements(miscreant_team)

///Announce team flavor text, objectives and OOC notes to miscreant
/datum/antagonist/miscreant/proc/handle_announcements(datum/team/miscreants/team)
	if(!team)
		return
	to_chat(owner, span_notice("[team.flavor_text]"))
	owner.announce_objectives()
	if(team.ooc_text)
		to_chat(owner, span_userdanger("[team.ooc_text]"))

/datum/antagonist/miscreant/get_team()
	return miscreant_team

/datum/antagonist/miscreant/get_admin_commands()
	. = ..()
	.["Move to Team"] = CALLBACK(src, PROC_REF(admin_move))
	//.["Move to New Team"] = CALLBACK(src, PROC_REF(admin_move_to_new))

/datum/antagonist/miscreant/proc/admin_move(mob/admin)
	var/list/miscreant_teams = list()
	for(var/datum/team/miscreants/team in GLOB.antagonist_teams)
		miscreant_teams += team
	if(!(miscreant_teams.len > 1))
		to_chat(admin, span_userdanger("Cannot move miscreant when one or fewer teams exist."))
		return

	var/datum/team/miscreants/destination_team = tgui_input_list(admin, "Select a destination team for the miscreant.", "Miscreant destination team?", miscreant_teams)
	if(!destination_team || (destination_team == miscreant_team))
		return
	//Remove old team info
	owner.objectives -= miscreant_team.objectives
	miscreant_team.members -= owner
	//Add new team info
	destination_team.members += owner
	owner.objectives += destination_team.objectives
	//Announce the new info to the player
	handle_announcements(destination_team)

	//Log the move
	var/datum/mind/O = owner
	message_admins("[key_name_admin(admin)] has moved miscreant [O] to team [destination_team].")
	log_admin("[key_name(admin)] has moved miscreant [O] to team [destination_team].")

	//Update the miscreant_team var
	miscreant_team = destination_team

/datum/antagonist/miscreant/get_preview_icon()
	var/icon/final_icon = render_preview_outfit(preview_outfit)

	final_icon.Blend(make_assistant_icon("Business Hair"), ICON_UNDERLAY, -8, 0)
	final_icon.Blend(make_assistant_icon("CIA"), ICON_UNDERLAY, 8, 0)

	// Apply the miscreant HUD, but scale up the preview icon a bit beforehand.
	// Otherwise, the M gets cut off.
	final_icon.Scale(64, 64)

	var/icon/miscreant_icon = icon('modular_iris/modules/miscreants/icons/miscreants_hud.dmi', "miscreant")
	miscreant_icon.Scale(48, 48)
	miscreant_icon.Crop(1, 1, 64, 64)
	miscreant_icon.Shift(EAST, 10)
	miscreant_icon.Shift(NORTH, 16)
	final_icon.Blend(miscreant_icon, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/antagonist/miscreant/proc/make_assistant_icon(hairstyle)
	var/mob/living/carbon/human/dummy/consistent/assistant = new
	assistant.set_hairstyle(hairstyle, update = TRUE)

	var/icon/assistant_icon = render_preview_outfit(/datum/outfit/job/assistant/consistent, assistant)
	assistant_icon.ChangeOpacity(0.5)

	qdel(assistant)

	return assistant_icon
