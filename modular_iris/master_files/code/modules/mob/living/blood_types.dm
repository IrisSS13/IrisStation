/datum/blood_type/nabber
	name = BLOOD_TYPE_NABBER
	color = BLOOD_COLOR_NABBER
	compatible_types = list(
		/datum/blood_type/nabber,
	)

/datum/blood_type/vox
	name = BLOOD_TYPE_VOX
	color = BLOOD_COLOR_VOX
	compatible_types = list(
		/datum/blood_type/vox,
	)

/datum/blood_type/insect
	name = BLOOD_TYPE_INSECT
	color = BLOOD_COLOR_INSECT
	compatible_types = list(
		/datum/blood_type/insect,
	)

/datum/blood_type/skrell
	name = BLOOD_TYPE_SKRELL
	color = /datum/reagent/copper::color
	compatible_types = list(
		/datum/blood_type/skrell,
	)

// For Proteans
/datum/blood_type/nanite_slurry
	name = BLOOD_TYPE_NANITE_SLURRY
	dna_string = "Nanite Slurry"
	reagent_type = /datum/reagent/medicine/nanite_slurry
	color = BLOOD_COLOR_NANITE_SLURRY
	restoration_chem = null
	compatible_types = list(
		/datum/blood_type/nanoblood,
	)

/datum/blood_type/nanite_slurry/get_emissive_alpha(atom/source, is_worn = FALSE)
	if (is_worn)
		return 102
	return 125

/datum/blood_type/nanite_slurry/set_up_blood(obj/effect/decal/cleanable/blood/blood, new_splat = FALSE)
	. = ..()
	blood.emissive_alpha = max(blood.emissive_alpha, new_splat ? 125 : 63)
	if (new_splat)
		return
	blood.can_dry = FALSE
