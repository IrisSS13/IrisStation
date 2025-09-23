// most code in: (code/game/say.dm)
/atom/movable/virtualspeaker
	var/realvoice

/atom/movable/virtualspeaker/get_voice(bool)
	if(bool && realvoice)
		return realvoice
	else
		return "[src]"
