/obj/item/organ/wings/functional/gizzard
	name = "gizzard"
	icon_state = "eggsac"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_GIZZARD
	w_class = WEIGHT_CLASS_BULKY
	//actions_types = list(/datum/action/innate/flight/gizzard)
	//fly = /datum/action/innate/flight/gizzard
	organ_flags = ORGAN_ORGANIC | ORGAN_EDIBLE | ORGAN_VIRGIN
	use_mob_sprite_as_obj_sprite = FALSE
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional/gizzard

/obj/item/organ/wings/functional/gizzard/get_action_path()
    return /datum/action/innate/flight/gizzard

/obj/item/organ/wings/functional/gizzard/handle_flight(mob/living/carbon/human/human)
  . = ..()
  if(HAS_TRAIT_FROM(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT))
  		human.adjust_stamina_loss(8)


/obj/item/organ/wings/functional/gizzard
	name = "Natural wings"
	desc = "This should help you fly"
	sprite_accessory_override = /datum/sprite_accessory/wings/dragon


/datum/bodypart_overlay/mutant/wings/functional/gizzard

/datum/bodypart_overlay/mutant/wings/functional/gizzard/can_draw_on_bodypart(mob/living/carbon/human/human)
	return FALSE

/datum/action/innate/flight/gizzard
	name = "Toggle Flight (Natural)"

/datum/action/innate/flight/gizzard/Activate()
	var/mob/living/carbon/human/human = owner
	var/obj/item/organ/wings/functional/gizzard/gizzard = human.get_organ_slot(ORGAN_SLOT_GIZZARD)
	if(gizzard?.can_fly())
		gizzard.toggle_flight(human)
