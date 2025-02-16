/datum/dynamic_ruleset/roundstart/miscreants
	name = "Miscreants"
	antag_flag = ROLE_MISCREANT
	antag_datum = /datum/antagonist/miscreant
	minimum_required_age = 0
	restricted_roles = list(
		JOB_AI,
		JOB_CAPTAIN,
		JOB_CYBORG,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BLUESHIELD,
		JOB_NT_REP
	)
	minimum_players = 10
	required_candidates = 2
	weight = 4 //slightly rarer than traitors
	cost = 8 //but at the same cost
	var/datum/team/miscreants/roundstart_miscreant_team

/datum/dynamic_ruleset/roundstart/miscreants/pre_execute(population)
	. = ..()
	var/miscreants = clamp(round(population * 0.2, 1), 2, 8)
	for(var/miscreants_number = 1 to miscreants)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_MISCREANT
		M.mind.restricted_roles = restricted_roles
		GLOB.pre_setup_antags += M.mind
	return TRUE

/datum/dynamic_ruleset/roundstart/miscreants/execute()
	for(var/datum/mind/M in assigned)
		M.add_antag_datum(/datum/antagonist/miscreant)
		GLOB.pre_setup_antags -= M
	return TRUE
