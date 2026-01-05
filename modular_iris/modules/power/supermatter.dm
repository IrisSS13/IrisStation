MAPPING_DIRECTIONAL_HELPERS(/obj/structure/railing, 0)

/obj/machinery/power/supermatter_crystal/engine/Initialize(mapload)
	. = ..()

	for(var/dir in GLOB.cardinals)
		var/railing = text2path("/obj/structure/railing/directional/[dir2text(REVERSE_DIR(dir))]")
		new railing(get_step(src, dir))
