/datum/component/edible/proc/find_adjacent_tables(mob/living/eater)
	var/list/potential_tables = orange(1, eater)
	for(var/obj/structure/table/table_to_eat_with in potential_tables)
		if(istype(table_to_eat_with, /obj/structure/table) && eater.Adjacent(table_to_eat_with))
			return TRUE
