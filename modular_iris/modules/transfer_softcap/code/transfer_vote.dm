#define CHOICE_TRANSFER "Initiate Crew Transfer"

/datum/vote/transfer_vote/get_vote_result(list/non_voters)
	var/transfer_progression = CONFIG_GET(number/transfer_progression)
	if(transfer_progression)
		var/static/progression = 0
		var/total_votes = 0
		for(var/option in choices)
			total_votes += choices[option]

		choices[CHOICE_TRANSFER] += (total_votes * progression)

		var/maximum_progression = CONFIG_GET(number/transfer_maximum)
		transfer_progression *= 0.01 // config can't handle integers, its so fuckin over
		maximum_progression *= 0.01
		progression = min(transfer_progression + progression, maximum_progression)

	return ..()

#undef CHOICE_TRANSFER
