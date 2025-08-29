///a superlist containing relics and artifacts shared between the several xenoarch scanning experiments for each techweb.
GLOBAL_LIST_EMPTY(scanned_xenoarch_by_techweb)

/**
 * Xenoarch experiments to unlock advanced tools and acquire research points.
 * Based on the fish scanning experiment code.
 */
/datum/experiment/scanning/points/xenoarch
	name = "Advanced Xenoarchaeology Tools"
	description = "It is possible to create even more advanced tools for xenoarchaeoloy."
	required_points = 10
	required_atoms = list(
		/obj/item/xenoarch/useless_relic = 1,
		/obj/item/xenoarch/broken_item = 2,
	)
	///Further experiments added to the techweb when this one is completed.
	var/list/next_experiments = list(/datum/experiment/scanning/points/xenoarch/survey, /datum/experiment/scanning/points/xenoarch/artifact)

/**
 * We make sure the scanned list is shared between all xenoarch scanning experiments for this techweb,
 * since we want each experiment to count items seperately, this prevents items from counting for multiple experiments.
 */
/datum/experiment/scanning/points/xenoarch/New(datum/techweb/techweb)
	. = ..()
	if(isnull(techweb))
		return
	var/techweb_ref = REF(techweb)
	var/list/scanned_xenoarch = GLOB.scanned_xenoarch_by_techweb[techweb_ref]
	if(isnull(scanned_xenoarch))
		scanned_xenoarch = list()
		GLOB.scanned_xenoarch_by_techweb[techweb_ref] = scanned_xenoarch
	for(var/atom_type in required_atoms)
		LAZYINITLIST(scanned_xenoarch[atom_type])
	scanned = scanned_xenoarch

/**
 * After a xenoarch scanning experiment is done, more may be unlocked. If so, add them to the techweb
 * and automatically link the handler to the next experiment in the list as a bit of qol.
 */
/datum/experiment/scanning/points/xenoarch/finish_experiment(datum/component/experiment_handler/experiment_handler, ...)
	. = ..()
	if(next_experiments)
		experiment_handler.linked_web.add_experiments(next_experiments)
		var/datum/experiment/next_in_line = locate(next_experiments[1]) in experiment_handler.linked_web.available_experiments
		experiment_handler.link_experiment(next_in_line)

/datum/experiment/scanning/points/xenoarch/survey
	name = "Xenoarchaeology Survey 1"
	description = "There is much to learn from relics of the past."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 25
	required_atoms = list(
		/obj/item/xenoarch/useless_relic = 1,
		/obj/item/xenoarch/broken_item = 2,
	)
	next_experiments = list(/datum/experiment/scanning/points/xenoarch/survey/second)

/datum/experiment/scanning/points/xenoarch/survey/second
	name = "Xenoarchaeology Survey 2"
	description = "There is more to learn from relics of the past."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 50
	required_atoms = list(
		/obj/item/xenoarch/useless_relic = 1,
		/obj/item/xenoarch/broken_item = 2,
	)
	next_experiments = list(/datum/experiment/scanning/points/xenoarch/survey/third)

/datum/experiment/scanning/points/xenoarch/survey/third
	name = "Xenoarchaeology Survey 3"
	description = "There is much more to learn from relics of the past."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 100
	required_atoms = list(
		/obj/item/xenoarch/useless_relic = 1,
		/obj/item/xenoarch/broken_item = 2,
	)

/datum/experiment/scanning/points/xenoarch/artifact
	name = "Xenoarchaeology Artifact Scan 1"
	description = "Scan the powerful ancient artifacts exhumed from Lavaland's surface."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 1
	required_atoms = list(/obj/machinery/artifact = 1)
	next_experiments = list(/datum/experiment/scanning/points/xenoarch/artifact/second)

/datum/experiment/scanning/points/xenoarch/artifact/second
	name = "Xenoarchaeology Artifact Scan 2"
	description = "Scan more powerful ancient artifacts exhumed from Lavaland's surface."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 2
	required_atoms = list(/obj/machinery/artifact = 1)
	next_experiments = list(/datum/experiment/scanning/points/xenoarch/artifact/third)

/datum/experiment/scanning/points/xenoarch/artifact/third
	name = "Xenoarchaeology Artifact Scan 3"
	description = "Scan even more powerful ancient artifacts exhumed from Lavaland's surface."
	points_reward = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS )
	required_points = 3
	required_atoms = list(/obj/machinery/artifact = 1)
