// most code in: (code/game/say.dm)
/atom/movable/virtualspeaker
	var/realvoice

/atom/movable/virtualspeaker/get_voice(add_id_name = TRUE)
	if(add_id_name && realvoice)
		return realvoice
	else
		return "[src]"
