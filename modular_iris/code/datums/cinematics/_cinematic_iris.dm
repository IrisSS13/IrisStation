/datum/cinematic/chosm_summon

/datum/cinematic/chosm_summon/play_cinematic()
	cleanup_time = 5 SECONDS
	screen.icon = 'modular_iris/code/datums/cinematics/fading_stars.dmi'
	screen.icon_state = "stars_fading"
	stoplag(8.0 SECONDS)
	screen.icon = 'modular_iris/code/datums/cinematics/chosmic_tide.dmi'
	screen.icon_state = "tide"
	stoplag(2.0 SECONDS)
	screen.icon = 'modular_iris/code/datums/cinematics/chosm_pause.dmi'
	screen.icon_state = "pause"
