// The legion has a nasty habit of destroying its own chests, so these ones are non-dense until moved
/obj/structure/closet/crate/necropolis/tendril/legion
	name = "transparent necropolis chest"
	desc = "It's watching you suspiciously. You need a skeleton key to open it. Looks you can move through it."
	density = FALSE
	alpha = 150

/obj/structure/closet/crate/necropolis/tendril/legion/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/obj/structure/closet/crate/necropolis/tendril/legion/Destroy(force)
	if(!density)
		UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	return ..()

/obj/structure/closet/crate/necropolis/tendril/legion/proc/on_moved()
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	name = "necropolis chest"
	desc = "It's watching you suspiciously. You need a skeleton key to open it."
	density = TRUE
	animate(src, time = 3 SECONDS, alpha = 255)
