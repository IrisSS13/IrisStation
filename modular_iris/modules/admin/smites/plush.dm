/datum/smite/plush
	name = "Make into a marketable plush"
	smite_flags = SMITE_STUN

/datum/smite/plush/effect(client/user, mob/living/target)
	. = ..()
	target.say("NO, DON'T TURN ME INTO A MARKETABLE PLUSH!!")
	sleep(1 SECONDS)
	target.emote("scream")
	var/obj/item/toy/plush/living/plush = new(target.loc, target, TRUE)
	sleep(1 SECONDS)
	if(prob(50))
		target.say("NOOO!!")
	else
		plush.manual_emote("[pick(plush.attack_verb_continuous)] angrily!")

/obj/item/toy/plush/living
	name = "Unknown marketable plush"
	icon_state = "plushie_human"
	young = TRUE // Let's not make player plushies able to kiss other plushes, or worse.
	/// The current mob being contained by the plushie
	var/mob/living/carbon/human/current_owner = null

/obj/item/toy/plush/living/Initialize(mapload, mob/living/carbon/human/target = null, bind_target = FALSE)
	. = ..()
	if(target)
		make_marketable(target, bind_target)

// Actually turns the plush to look like whoever 'target' is, 'target' being required and 'bind_target' being optional
/obj/item/toy/plush/living/proc/make_marketable(mob/living/carbon/human/target = null, bind_target = FALSE)
	name = "Marketable [target] plush"
	if(bind_target)
		current_owner = target
		ADD_TRAIT(target, TRAIT_NOBREATH, src)
		target.forceMove(src)
		RegisterSignal(target, COMSIG_QDELETING, PROC_REF(clear_owner))

	if(!istype(target))
		return

	var/list/species_to_plush = list(
		/datum/species/abductor = /obj/item/toy/plush/abductor/agent,
		/datum/species/abductor/abductorweak = /obj/item/toy/plush/abductor,
		/datum/species/android = /obj/item/toy/plush/pkplush,
		/datum/species/lizard = /obj/item/toy/plush/lizard_plushie/greyscale,
		/datum/species/monkey/kobold = /obj/item/toy/plush/lizard_plushie/greyscale,
		/datum/species/monkey = /obj/item/toy/plush/monkey,
		/datum/species/moth = /obj/item/toy/plush/moth,
		/datum/species/plasmaman = /obj/item/toy/plush/plasmamanplushie,
		/datum/species/jelly/slime = /obj/item/toy/plush/slimeplushie,
		/datum/species/jelly/roundstartslime = /obj/item/toy/plush/slimeplushie,
		/datum/species/jelly/luminescent = /obj/item/toy/plush/slimeplushie,
		/datum/species/jelly/stargazer = /obj/item/toy/plush/slimeplushie,
		/datum/species/nabber = /obj/item/toy/plush/snakeplushie,
		/datum/species/vox = /obj/item/toy/plush/nova/borbplushie,
		/datum/species/mammal - /obj/item/toy/plush/nova/ian,
		/datum/species/akula = /obj/item/toy/plush/shark, // Yes
		/datum/species/aquatic = /obj/item/toy/plush/shark,
		/datum/species/insect = /obj/item/toy/plush/beeplushie,
		/datum/species/insectoid = /obj/item/toy/plush/beeplushie,
		/datum/species/polysmorph = /obj/item/toy/plush/rouny,
		/datum/species/human/felinid = /obj/item/toy/plush/nova/cat,
	)

	var/obj/item/toy/plush/plush = species_to_plush[target.dna.species.type]
	if(isnull(plush))
		plush = /obj/item/toy/plush/human

	plush = new plush(src) // Sorry, i need those lists that you are keeping away from me

	desc = plush.desc
	icon = plush.icon
	icon_state = plush.icon_state
	inhand_icon_state = plush.inhand_icon_state
	attack_verb_continuous = plush.attack_verb_continuous
	attack_verb_simple = plush.attack_verb_simple
	squeak_override = plush.squeak_override
	var/skin_color = target.dna.features["mcolor"]
	if(plush.greyscale_config && skin_color)
		greyscale_config = plush.greyscale_config
		greyscale_colors = "#[skin_color]#[target.eye_color_left]"
		update_greyscale()

	qdel(plush)

/obj/item/toy/plush/living/Destroy(force)
	if(current_owner)
		clear_owner()
	return ..()

/obj/item/toy/plush/living/proc/clear_owner(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(current_owner, COMSIG_QDELETING)
	REMOVE_TRAIT(current_owner, TRAIT_NOBREATH, src)
	current_owner = null

/obj/item/toy/plush/living/attackby(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	if(isnull(current_owner))
		return ..()
	var/previous_stuffing = stuffed
	. = ..()
	if(previous_stuffing && !stuffed) // They ripped out the stuffing
		current_owner.death()
