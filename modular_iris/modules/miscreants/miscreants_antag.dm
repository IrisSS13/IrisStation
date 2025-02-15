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
	objectives |= miscreant_team?.objectives
	owner.current.log_message("has been converted into a miscreant!", LOG_ATTACK, color="red")

/datum/antagonist/miscreant/on_removal()
	objectives -= miscreant_team?.objectives
	. = ..()

/datum/antagonist/miscreant/greet()
	. = ..()
	to_chat(owner, span_userdanger("Help your cause. Do not harm your fellow miscreants. You can identify your comrades by the brown \"M\" icons."))
	to_chat(owner, span_notice("[miscreant_team?.flavor_text]"))
	owner.announce_objectives()
	if(miscreant_team?.ooc_text)
		to_chat(owner, span_userdanger("[miscreant_team?.ooc_text]"))

/datum/antagonist/miscreant/create_team(datum/team/miscreants/new_team)
	if(!new_team)
		//For now only one revolution at a time
		for(var/datum/antagonist/miscreant/M in GLOB.antagonists)
			if(!M.owner)
				continue
			if(M.miscreant_team)
				miscreant_team = M.miscreant_team
				return
		miscreant_team = new /datum/team/miscreants
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	miscreant_team = new_team

/datum/antagonist/miscreant/get_team()
	return miscreant_team

/datum/antagonist/miscreant/get_admin_commands()
	. = ..()
	.["Promote"] = CALLBACK(src, PROC_REF(admin_promote))

/datum/antagonist/miscreant/proc/admin_promote(mob/admin)
	var/datum/mind/O = owner
	promote()
	message_admins("[key_name_admin(admin)] has head-rev'ed [O].")
	log_admin("[key_name(admin)] has head-rev'ed [O].")

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
