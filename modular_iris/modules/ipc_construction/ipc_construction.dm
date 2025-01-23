/obj/item/syth_chest
	name = "synth chest (synth assembly)"
	desc = "A complex metal chest cavity with standard limb sockets and pseudomuscle anchors."
	icon = 'modular_nova/modules/bodyparts/icons/ipc_parts.dmi'
	icon_state = "synth_chest"

/obj/item/synth_chest/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/species/synth/synth_body = new /mob/living/carbon/human/species/synth(get_turf(src))
	/// Remove those bodyparts
	for(var/synth_body_parts in synth_body.bodyparts)
		var/obj/item/bodypart/bodypart = synth_body_parts
		if(bodypart.body_part != CHEST)
			QDEL_NULL(bodypart)
	/// Remove those organs
	for (var/synth_organ in synth_body.organs)
		qdel(synth_organ)

	/// Update current body to be limbless
	synth_body.update_icon()
	ADD_TRAIT(synth_body, TRAIT_EMOTEMUTE, type)
	synth_body.death()
	REMOVE_TRAIT(synth_body, TRAIT_EMOTEMUTE, type)
	/// Remove placeholder synth_chest
	qdel(src)

/datum/design/synth_construction
	name = "Android Construction"
	id = "synth_construction"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/synth_chest
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
