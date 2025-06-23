///Similar to name2reagent list but contains only neuroware reagents.
GLOBAL_LIST_INIT(name2neuroware, build_name2neurowarelist())

///Same as build_name2reagentlist() but contains only neuroware reagents.
/proc/build_name2neurowarelist()
	var/list/neuroware_list = list()
	for (var/datum/reagent/reagent as anything in GLOB.chemical_reagents_list)
		if(reagent.chemical_flags & REAGENT_NEUROWARE)
			neuroware_list[initial(reagent.name)] = reagent
	return neuroware_list
