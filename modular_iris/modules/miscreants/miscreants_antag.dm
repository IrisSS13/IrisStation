#define MISCREANT_OBJECTIVES_FILE "iris/miscreant_objectives.json"

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

/datum/antagonist/miscreant/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current

/datum/antagonist/miscreant/on_gain()
	. = ..()
	create_objectives()
	owner.current.log_message("has been converted into a miscreant!", LOG_ATTACK, color="red")

/datum/antagonist/miscreant/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/miscreant/greet()
	. = ..()
	to_chat(owner, span_userdanger("Help your cause. Do not harm your fellow miscreants. You can identify your comrades by the brown \"M\" icons."))
	owner.announce_objectives()

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

/datum/antagonist/rev/get_team()
	return rev_team

/datum/antagonist/rev/proc/create_objectives()
	objectives |= rev_team.objectives

/datum/antagonist/rev/proc/remove_objectives()
	objectives -= rev_team.objectives

/datum/antagonist/rev/get_admin_commands()
	. = ..()
	.["Promote"] = CALLBACK(src, PROC_REF(admin_promote))

/datum/antagonist/rev/proc/admin_promote(mob/admin)
	var/datum/mind/O = owner
	promote()
	message_admins("[key_name_admin(admin)] has head-rev'ed [O].")
	log_admin("[key_name(admin)] has head-rev'ed [O].")

/datum/antagonist/miscreant/get_preview_icon()
	var/icon/final_icon = render_preview_outfit(preview_outfit)

	final_icon.Blend(make_assistant_icon("Business Hair"), ICON_UNDERLAY, -8, 0)
	final_icon.Blend(make_assistant_icon("CIA"), ICON_UNDERLAY, 8, 0)

	// Apply the rev head HUD, but scale up the preview icon a bit beforehand.
	// Otherwise, the R gets cut off.
	final_icon.Scale(64, 64)

	var/icon/rev_head_icon = icon('icons/mob/huds/antag_hud.dmi', "rev_head")
	rev_head_icon.Scale(48, 48)
	rev_head_icon.Crop(1, 1, 64, 64)
	rev_head_icon.Shift(EAST, 10)
	rev_head_icon.Shift(NORTH, 16)
	final_icon.Blend(rev_head_icon, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/antagonist/miscreant/proc/make_assistant_icon(hairstyle)
	var/mob/living/carbon/human/dummy/consistent/assistant = new
	assistant.set_hairstyle(hairstyle, update = TRUE)

	var/icon/assistant_icon = render_preview_outfit(/datum/outfit/job/assistant/consistent, assistant)
	assistant_icon.ChangeOpacity(0.5)

	qdel(assistant)

	return assistant_icon

/datum/team/miscreants
	name = "\improper Band of Miscreants"
	var/max_miscreants = 8 //maximum number of miscreants that can be assigned to this team
	var/flavor_text = "If you see this miscreant flavor text, report it as a bug."
	var/ooc_text = "If you see this miscreant ooc text, report it as a bug."

/datum/team/miscreants/New(forced_max = 0, custom_flavor, custom_objective, custom_ooc)
	. = ..()
	if(forced_max)
		max_miscreants = forced_max

	var/selected_random_scenario = pick_list(MISCREANT_OBJECTIVES_FILE, "scenario")

	if(custom_flavor)
		flavor_text = custom_flavor
	else
		flavor_text = selected_random_scenario.flavor_text

	var/datum/objective/miscreant_goal/goal = new/datum/objective/miscreant_goal
	if(custom_objective)
		add_objective()

	if(custom_ooc)
		ooc_text = custom_ooc
	else
		ooc_text = selected_random_scenario.flavor_text

/datum/outfit/miscreant
	name = "Miscreant (Preview only)"

	uniform = /obj/item/clothing/under/costume/soviet
	head = /obj/item/clothing/head/costume/foilhat
	gloves = /obj/item/clothing/gloves/color/yellow
	l_hand = /obj/item/crayons
	r_hand = /obj/item/melee/cleric_mace

#undef MISCREANT_OBJECTIVES_FILE
