/// Tracks which `from_when` values we've already scheduled fades for,
var/list/scheduled_fades = list()

/datum/component/echolocation/proc/delete_single_image(params)
	var/mob/living/echolocate_receiver = params[1]
	var/image/previous_image = params[2]
	if(!echolocate_receiver || !echolocate_receiver.client)
		return
	if(previous_image in echolocate_receiver.client.images)
		echolocate_receiver.client.images -= previous_image
	// Clean up any stray receiver entries that still reference this image
	if(receivers[echolocate_receiver])
		for(var/atom/rendered_atom as anything in list(receivers[echolocate_receiver]))
			if(receivers[echolocate_receiver][rendered_atom]["image"] == previous_image)
				receivers[echolocate_receiver] -= rendered_atom
