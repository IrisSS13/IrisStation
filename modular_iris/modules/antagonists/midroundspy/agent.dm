/datum/antagonist/spy/midround
	name = "\improper Agent"
	job_rank = ROLE_AGENT

/// Midround Traitor Ruleset (From Living)
/datum/dynamic_ruleset/midround/from_living/agent
	var/static/list/sleeper_current_polling = list()
	var/static/list/rejected_spy = list()
	name = "Agent"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT
	antag_datum = /datum/antagonist/spy
	antag_flag = ROLE_AGENT
	antag_flag_override = ROLE_SPY
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
	)
	required_candidates = 1
	weight = 35
	cost = 0
	requirements = list(0,0,0,0,0,0,0,0,0,0)
	repeatable = TRUE

/datum/dynamic_ruleset/midround/from_living/agent/trim_candidates()
	..()
	candidates = living_players
	for(var/mob/living/player in candidates)
		if(issilicon(player)) // Your assigned role doesn't change when you are turned into a silicon.
			candidates -= player
		else if(is_centcom_level(player.z))
			candidates -= player // We don't autotator people in CentCom
		else if(player.mind && (player.mind.special_role || !player.mind.can_roll_midround(antag_datum)))
			candidates -= player // We don't autotator people with roles already
		//NOVA EDIT ADDITION
		else if(player in rejected_spy)
			candidates -= player
		else if(player in sleeper_current_polling)
			candidates -= player
		//NOVA EDIT END

/datum/dynamic_ruleset/midround/from_living/agent/execute()
	var/mob/M = pick(poll_candidates_for_one(candidates)) // NOVA EDIT CHANGE - ORIGINAL: var/mob/M = pick(candidates)
	assigned += M
	candidates -= M
	var/datum/antagonist/traitor/agent = new
	M.mind.add_antag_datum(agent)
	message_admins("[ADMIN_LOOKUPFLW(M)] was selected by the [name] ruleset and has been made into a midround traitor.")
	log_dynamic("[key_name(M)] was selected by the [name] ruleset and has been made into a midround traitor.")
	return TRUE

/datum/dynamic_ruleset/midround/from_living/agent/proc/poll_candidates_for_one(candidates)
	message_admins("Attempting to poll [length(candidates)] people individually to become a Midround Spy...first one to say yes gets chosen.")
	var/list/potential_candidates = shuffle(candidates)
	var/list/yes_candidate = list()
	for(var/mob/living/candidate in potential_candidates)
		potential_candidates -= candidate
		sleeper_current_polling += candidate
		yes_candidate += SSpolling.poll_candidates(
		question = "Do you want to be a spy? If you ignore this, you will be considered to have declined and will be inelegible for all future rolls this round.",
		group = list(candidate),
		poll_time = 20 SECONDS,
		flash_window = TRUE,
		start_signed_up = FALSE,
		announce_chosen = FALSE,
		role_name_text = "Agent",
		alert_pic = /obj/structure/sign/poster/contraband/gorlex_recruitment,
		custom_response_messages = list(
			POLL_RESPONSE_SIGNUP = "You have signed up to be a spy!",
			POLL_RESPONSE_ALREADY_SIGNED = "You are already signed up to be a spy.",
			POLL_RESPONSE_NOT_SIGNED = "You aren't signed up to be a spy.",
			POLL_RESPONSE_TOO_LATE_TO_UNREGISTER = "It's too late to decide against being a spy.",
			POLL_RESPONSE_UNREGISTERED = "You decide against being a spy.",
		),
		chat_text_border_icon = /obj/structure/sign/poster/contraband/gorlex_recruitment,
	)
		if(length(yes_candidate))
			sleeper_current_polling -= candidate
			break
		else
			message_admins("Candidate [candidate] has declined to be a spy.")
			rejected_spy += candidate
			sleeper_current_polling -= candidate

	return yes_candidate
