/datum/cinematic/chosm_summon

/datum/cinematic/chosm_summon/play_cinematic()
	cleanup_time = 5 SECONDS
	screen.icon = 'modular_iris/code/datums/cinematics/delay.dmi'
	screen.icon_state = "delay"
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/something_is_terribly_wrong.ogg'))
	stoplag(3.0 SECONDS)
	screen.icon = 'modular_iris/code/datums/cinematics/fading_stars.dmi'
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/chosm_summon_rumble.ogg'))
	screen.icon_state = "stars_fading"
	stoplag(8.0 SECONDS)
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/chosm_atmosphere.ogg'))
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/chosm_rumbling.ogg'))
	screen.icon = 'modular_iris/code/datums/cinematics/chosmic_tide.dmi'
	screen.icon_state = "tide"
	stoplag(2.0 SECONDS)
	screen.icon = 'modular_iris/code/datums/cinematics/chosm_pause.dmi'
	screen.icon_state = "pause"


/datum/cinematic/chosm_victory

/datum/cinematic/chosm_victory/play_cinematic()
	cleanup_time = 6 SECONDS
	screen.icon = 'modular_iris/code/datums/cinematics/chosm_win.dmi'
	screen.icon_state = "win"
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/chosmwin.ogg'))
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/chosm_rumbling.ogg'))


/datum/cinematic/angel_arrive

/datum/cinematic/angel_arrive/play_cinematic()
	cleanup_time = 3 SECONDS
	screen.icon = 'modular_iris/code/datums/cinematics/angel_arrive.dmi'
	screen.icon_state = "arrive"
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/emissary_arrival.ogg'))


/datum/cinematic/angel_victory

/datum/cinematic/angel_victory/play_cinematic()
	cleanup_time = 8 SECONDS
	screen.icon = 'modular_iris/code/datums/cinematics/angel_victory.dmi'
	screen.icon_state = "victory"
	stoplag(1.0 SECONDS)
	play_cinematic_sound(sound('modular_iris/sound/daemons/cinematics/angel_laser.ogg'))
