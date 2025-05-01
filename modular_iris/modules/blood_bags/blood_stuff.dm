/obj/item/reagent_containers/blood/nabber
	blood_type = BLOOD_TYPE_NABBER

/obj/item/reagent_containers/blood/nabber/examine()
	. = ..()
	. += span_notice("This deep blue blood is meant for Giant Armoured Serpentids.")

/datum/design/organic_bloodbag_nabber
	name = "H Blood Pack"
	id = "organic_bloodbag_nabber"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/reagent_containers/blood/nabber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_DEFOREST_BLOOD,
	)

/obj/item/reagent_containers/blood/vox
	blood_type = BLOOD_TYPE_VOX

/obj/item/reagent_containers/blood/vox/examine()
	. = ..()
	. += span_notice("This light blue blood is meant for Vox, both types.")

/datum/design/organic_bloodbag_vox
	name = "VO Blood Pack"
	id = "organic_bloodbag_vox"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/reagent_containers/blood/vox
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_DEFOREST_BLOOD,
	)

/obj/item/reagent_containers/blood/insect
	blood_type = BLOOD_TYPE_INSECT

/obj/item/reagent_containers/blood/insect/examine()
	. = ..()
	. += span_notice("This purple blood is meant for Insects.")

/datum/design/organic_bloodbag_insect
	name = "I Blood Pack"
	id = "organic_bloodbag_insect"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/reagent_containers/blood/insect
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_DEFOREST_BLOOD,
	)

/obj/item/reagent_containers/blood/skrell
	blood_type = BLOOD_TYPE_SKRELL

/obj/item/reagent_containers/blood/skrell/examine()
	. = ..()
	. += span_notice("This copper colored blood is meant for Skrell.")

/datum/design/organic_bloodbag_skrell
	name = "SK Blood Pack"
	id = "organic_bloodbag_skrell"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/reagent_containers/blood/skrell
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_DEFOREST_BLOOD,
	)
