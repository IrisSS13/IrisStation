/obj/structure/statue/iris
	name = ""
	desc = ""
	//icon = ''
	icon_state = ""
	max_integrity = 12062024
	impressiveness = 100
	uncarveable = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/computer/terminal/iris
	name = "info terminal"
	desc = "A relatively low-tech info board. Not as low-tech as an actual sign though. Appears to be quite old."
	icon_state = "plaque"
	icon_screen = "plaque_screen"
	icon_keyboard = null
	max_integrity = 28022026
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | EMP_PROTECT_SELF

/obj/machinery/computer/terminal/iris/screwdriver_act()
	return FALSE

/obj/machinery/computer/terminal/iris/thanks
	upperinfo = "COPYRIGHT 2500 NANOSOFT-TM - DO NOT REDISTRIBUTE - Now with audio!"
	content = list(
		"Experimental Test Satellite 37B<br/>Nanotrasen™️ approved deep space experimentation lab<br/><br/>Entry 1:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>We have acquired a biological sample of unknown origins \[Species 501-C-12\] from an NT outpost on the far reaches. Initial experiments have determined the sample to be a creature never previously recorded. It weighs approximately 7 grams and seems to be docile. Initial examinations determine that it is an extremely fast replicating organism which can alter its physiology to take multiple differing shapes. \[Recording Terminated\]<br/>- Dr. Phil Cornelius",
		"Entry 2:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>The creature responds to electrical stimuli. It has failed to respond to Light, Heat, Cold, Oxygen, Plasma, CO2, Nitrogen. It, within moments, seemed to have generated muscle tissue within its otherwise shapeless form and moved away from the source of electricity. Feeding the creature has been a simple matter, it consumed just about any form of protein. It appears to rapidly digest and convert forms of protein into more of itself. Any undigestible products are simply left alone. Will continue to monitor creature and provide reports to Nanotrasen Central Command. \[Recording Terminated\]<br/>- Dr. Phil Cornelius",
		"Entry 3:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>Any attempts at contacting Nanotrasen has failed. I've never seen anything like it. I... I don't think I'm going to survive much longer, I can hear it pushing on my room door. If anyone reads this, let my family know that I- \[Loud crash\]<br/>GET BACK \[Gunshots\]<br/>AHHHHHHHHHHHH \[Recording Terminated\]<br/>- Dr. Phil Cornelius"
	)

/obj/machinery/computer/terminal/iris/admins

/obj/machinery/computer/terminal/iris/history

/obj/structure/chair/sofa/bench/color/iris
	post_init_icon_state = "bench_middle"
	greyscale_config = /datum/greyscale_config/bench_middle
	greyscale_colors = "#5d419f"

/obj/structure/chair/sofa/bench/color/iris/left
	post_init_icon_state = "bench_left"
	greyscale_config = /datum/greyscale_config/bench_left

/obj/structure/chair/sofa/bench/color/iris/right
	post_init_icon_state = "bench_right"
	greyscale_config = /datum/greyscale_config/bench_right
