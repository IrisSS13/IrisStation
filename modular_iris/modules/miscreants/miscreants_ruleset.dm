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
	required_candidates = 2
	weight = 4
	cost = 10
	var/datum/team/miscreants/roundstart_miscreant_team

/datum/dynamic_ruleset/roundstart/miscreants/ready(population, forced = FALSE)
	required_candidates = get_antag_cap(population)
	return ..()

/datum/dynamic_ruleset/roundstart/miscreants/pre_execute(population)
	. = ..()
	var/miscreants = get_antag_cap(population)
	for(var/cultists_number = 1 to cultists)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_CULTIST
		M.mind.restricted_roles = restricted_roles
		GLOB.pre_setup_antags += M.mind
	return TRUE

/datum/dynamic_ruleset/roundstart/miscreants/execute()
	main_cult = new(population)
	for(var/datum/mind/M in assigned)
		var/datum/antagonist/cult/new_cultist = new antag_datum()
		new_cultist.cult_team = main_cult
		new_cultist.give_equipment = TRUE
		M.add_antag_datum(new_cultist)
		GLOB.pre_setup_antags -= M
	main_cult.setup_objectives()
	return TRUE
