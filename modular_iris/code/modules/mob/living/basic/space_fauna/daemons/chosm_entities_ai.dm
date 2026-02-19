/datum/ai_controller/basic_controller/chosm_basic
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking

	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/random_speech/insect, // Space spiders are taxonomically insects not arachnids, don't DM me
		/datum/ai_planning_subtree/find_unwebbed_turf,
		/datum/ai_planning_subtree/spin_web,
	)
