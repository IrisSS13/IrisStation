// Blood Moon Event - Announcements
// Handles all announcement functions

/// Announce blood moon Act I
/datum/blood_moon_controller/proc/announce_blood_moon_act_1()
	priority_announce("Attention all personnel. \n\
		Astronomical sensors have detected an unusual celestial phenomenon. \n\n\
		A rare 'Blood Moon' event is currently in progress. This may cause minor atmospheric disturbances and lighting anomalies throughout the station. \n\n\
		This is a natural occurrence and poses no immediate threat. Remain calm and continue your duties. \n\n\
		Medical staff should be aware that some crew members may experience heightened anxiety or unease during this event.",
		"Anomalous Celestial Event Detected",
		sound = 'modular_nova/modules/alerts/sound/alerts/commandreport.ogg',
		color_override = "yellow")

/// Announce blood moon Act II
/datum/blood_moon_controller/proc/announce_blood_moon_act_2()
	priority_announce("Station logs indicate rising electromagnetic disturbances correlated with lunar activity. \n\n\
		Medbay should monitor for psychological irregularities. \n\n\
		Remain calm and report anomalies.",
		"Anomalous Disturbances Detected",
		sound = 'sound/announcer/announcement/announce_syndi.ogg',
		color_override = "orange")

/// Announce blood moon Act III
/datum/blood_moon_controller/proc/announce_blood_moon_act_3()
	priority_announce("The lunar body is eclipsing the system sun. Station's orbit is locked. \n\n\
		Magnetic interference rising. Seal all blast doors and- \n\n\
		\[TRANSMISSION LOST, NO CONNECTION\]",
		"Critical Disturbances Detected",
		sound = 'modular_iris/modules/alerts/sound/alerts/sirenfullalert.ogg',
		color_override = "red")
