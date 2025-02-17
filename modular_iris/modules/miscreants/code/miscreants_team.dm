#define MISCREANT_OBJECTIVES_FILE "iris/miscreant_objectives.json"

/datum/team/miscreants
	name = "\improper Band of Miscreants"
	var/max_miscreants = 8 //maximum number of miscreants that can be assigned to this team
	var/flavor_text = "If you see this miscreant flavor text, report it as a bug."
	var/ooc_text = "If you see this miscreant ooc text, report it as a bug."

	//meeting location vars
	var/area/station/meeting_location
	var/meeting_has_started = FALSE

	//must only contain publicly accessible areas
	var/list/possible_meeting_places = list(
		/area/station/service/bar,
		/area/station/service/theater,
		/area/station/service/library,
		/area/station/service/chapel,
		/area/station/security/courtroom,
		/area/station/commons/dorms
	)

/datum/team/miscreants/New(forced_max = 0, custom_name, custom_flavor, custom_objective, custom_ooc)
	. = ..()
	if(forced_max > 0)
		max_miscreants = forced_max

	var/selected_random_scenario = pick_list(MISCREANT_OBJECTIVES_FILE, "scenarios")

	if(custom_name)
		name = "\improper [custom_name]"
	else
		name = "\improper [selected_random_scenario["group_name"]]"

	if(custom_flavor)
		flavor_text = custom_flavor
	else
		flavor_text = selected_random_scenario["flavor_text"]

	var/datum/objective/miscreant/goal = new/datum/objective/miscreant
	if(custom_objective)
		goal.explanation_text = "[custom_objective]"
	else
		goal.explanation_text = "[selected_random_scenario["objective"]]"
	add_objective(goal)

	if(custom_ooc)
		ooc_text = custom_ooc
	else
		ooc_text = selected_random_scenario["ooc_notes"]

	//pick a meeting location and begin the countdown to the meeting
	meeting_location = pick_meeting_location()
	addtimer(CALLBACK(src, PROC_REF(begin_meeting)), 10 MINUTES, TIMER_DELETE_ME)

/datum/team/miscreants/proc/begin_meeting()
	meeting_has_started = TRUE

/datum/team/miscreants/proc/pick_meeting_location()
	//pick from the list
	var/area/station/chosen_location = pick(possible_meeting_places)

	//check it exists on this map or redo
	if(!(chosen_location in GLOB.areas))
		possible_meeting_places -= chosen_location
		return pick_meeting_location()
	else
		return chosen_location

#undef MISCREANT_OBJECTIVES_FILE
