/datum/uplink_item/role_restricted/assassins_teapot
	name = "Assassin's Teapot"
	desc = "A teapot with a hidden chamber for the stealthy application of poison; liquid flows from the chamber only when the teapot is poured in a specific manner, allowing the poisoner to administer it in plain view. \
			(OOC: After filling, left-click with combat mode enabled to pour reagents designated as 'drugs' or 'toxins' in the code, pouring without combat mode will pour any other stored reagents instead.)"
	item = /obj/item/reagent_containers/cup/teapot/assassins
	cost = 1
	restricted_roles = list(JOB_BARTENDER, JOB_CHEF)
	limited_stock = 1
	surplus = 5
