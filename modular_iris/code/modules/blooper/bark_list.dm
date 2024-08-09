/datum/blooper/mutedc2
	name = "Muted String (Low)"
	id = "mutedc2"
	soundpath = 'sound/runtime/instruments/synthesis_samples/guitar/crisis_muted/C2.ogg'
	allow_random = TRUE

/datum/blooper/mutedc3
	name = "Muted String (Medium)"
	id = "mutedc3"
	soundpath = 'sound/runtime/instruments/synthesis_samples/guitar/crisis_muted/C3.ogg'
	allow_random = TRUE

/datum/blooper/mutedc4
	name = "Muted String (High)"
	id = "mutedc4"
	soundpath = 'sound/runtime/instruments/synthesis_samples/guitar/crisis_muted/C4.ogg'
	allow_random = TRUE

/datum/blooper/banjoc3
	name = "Banjo (Medium)"
	id = "banjoc3"
	soundpath = 'sound/runtime/instruments/banjo/Cn3.ogg'
	allow_random = TRUE

/datum/blooper/banjoc4
	name = "Banjo (High)"
	id = "banjoc4"
	soundpath = 'sound/runtime/instruments/banjo/Cn4.ogg'
	allow_random = TRUE

/datum/blooper/squeaky
	name = "Squeaky"
	id = "squeak"
	soundpath = 'sound/items/toysqueak1.ogg'
	maxspeed = 4

/datum/blooper/beep
	name = "Beepy"
	id = "beep"
	soundpath = 'sound/machines/terminal_select.ogg'
	maxpitch = 1 //Bringing the pitch higher just hurts your ears :<
	maxspeed = 4 //This soundbyte's too short for larger speeds to not sound awkward

/datum/blooper/chitter
	name = "Chittery"
	id = "chitter"
	minspeed = 4 //Even with the sound being replaced with a unique, shorter sound, this is still a little too long for higher speeds
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/chitter.ogg'

/datum/blooper/synthetic_grunt
	name = "Synthetic (Grunt)"
	id = "synthgrunt"
	soundpath = 'sound/misc/bloop.ogg'

/datum/blooper/synthetic
	name = "Synthetic (Normal)"
	id = "synth"
	soundpath = 'sound/machines/uplinkerror.ogg'

/datum/blooper/bullet
	name = "Windy"
	id = "bullet"
	maxpitch = 1.6
	soundpath = 'sound/weapons/bulletflyby.ogg'

/datum/blooper/coggers
	name = "Brassy"
	id = "coggers"
	soundpath = 'sound/machines/clockcult/integration_cog_install.ogg'

/datum/blooper/moff/short
	name = "Moth Squeak"
	id = "moffsqueak"
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/mothsqueak.ogg'
	allow_random = TRUE
	ignore = FALSE

/datum/blooper/meow //Meow blooper?
	name = "Meow"
	id = "meow"
	allow_random = TRUE
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/meow1.ogg'
	minspeed = 5
	maxspeed = 11

/datum/blooper/chirp
	name = "Chirp"
	id = "chirp"
	allow_random = TRUE
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/chirp.ogg'

/datum/blooper/caw
	name = "Caw"
	id = "caw"
	allow_random = TRUE
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/caw.ogg'

/datum/blooper/chitter/alt
	name = "Chittery Alt"
	id = "chitter2"
	soundpath = 'modular_iris/code/modules/blooper/voice/bloopers/moth/mothchitter2.ogg'
