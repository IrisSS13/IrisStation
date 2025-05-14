//Default value is whatever your legs had first ie.lizards get claws, monkies paws etc.
/datum/preference/choiced/footprint_sprite
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "footprint_sprite"

/datum/preference/choiced/footprint_sprite/init_possible_values()
	return list("Default", "Paws", "Claws", "Snake Trail", "Hooves")

/datum/preference/choiced/footprint_sprite/create_default_value()
	return "Default"

/datum/preference/choiced/footprint_sprite/apply_to_human(mob/living/carbon/human/target, value)
	if(value == "Default")
		return

	var/static/list/value_to_define = list(
		"Paws" = FOOTPRINT_SPRITE_PAWS,
		"Claws" = FOOTPRINT_SPRITE_CLAWS,
		"Snake Trail" = FOOTPRINT_SPRITE_SNAKE,
		"Hooves" = FOOTPRINT_SPRITE_HOOVES
	)
	var/footprint_sprite = value_to_define[value]
	var/obj/item/bodypart/leg/left_leg = target.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/leg/right_leg = target.get_bodypart(BODY_ZONE_R_LEG)
	left_leg.footprint_sprite = footprint_sprite
	right_leg.footprint_sprite = footprint_sprite

	target.footprint_sprite = footprint_sprite
