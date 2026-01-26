/datum/ai_controller/basic_controller/carp/goodboy //GOODBOY WHO DOESNT ATTACK AND TELEPORT
	blackboard = list(
		BB_BASIC_MOB_STOP_FLEEING = TRUE,
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/not_friends,
		BB_TARGET_PRIORITY_TRAIT = TRAIT_SCARY_FISHERMAN,
		BB_CARPS_FEAR_FISHERMAN = TRUE,
	)
	ai_traits = PASSIVE_AI_FLAGS
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/flee_target/from_fisherman,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/no_fisherman,
	)
