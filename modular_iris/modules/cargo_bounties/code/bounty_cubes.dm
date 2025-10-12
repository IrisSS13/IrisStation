/datum/bounty/proc/get_completion_string()
	return "[claimed == TRUE ? "Shipped" : "Not Shipped"]"

/datum/bounty/item/get_completion_string()
	return "[shipped_count]/[required_count] Shipped"

/datum/bounty/reagent/get_completion_string()
	return "[shipped_volume]/[required_volume] Shipped"

/datum/bounty/pill/get_completion_string()
	return "[shipped_ammount]/[required_ammount] Shipped"
