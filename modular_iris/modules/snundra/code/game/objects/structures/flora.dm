/obj/structure/flora/lunar_plant/snundra
	name = "glowing plant"
	desc= "Local bioluminescent flora."
	icon_state = "lunar_plant"
	icon = 'icons/obj/fluff/flora/xenoflora.dmi'
	density = FALSE
	light_color = "#c25492"
	light_range = 2

/obj/structure/flora/lunar_plant/snundra/Initialize(mapload)
	. = ..()
	icon_state = "lunar_plant[rand(1,3)]"

/obj/structure/flora/lunar_plant/snundra/style_1
	icon_state = "lunar_plant1"

/obj/structure/flora/lunar_plant/snundra/style_2
	icon_state = "lunar_plant2"

/obj/structure/flora/lunar_plant/snundra/style_3
	icon_state = "lunar_plant3"
