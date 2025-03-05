/datum/quirk/system_shock
	name = "System Shock"
	desc = "You and electricity have a volatile relationship. One spark's liable to forcefully reboot your systems. Note: This quirk only works on synths."
	gain_text = span_danger("You start feeling nervous around plug sockets.")
	lose_text = span_notice("You feel normal about sparks.")
	medical_record_text = "Patient's processors are unusually uninsulated."
	value = -8
	mob_trait = TRAIT_SYSTEM_SHOCK
	icon = FA_ICON_PLUG_CIRCLE_XMARK
	quirk_flags = QUIRK_HUMAN_ONLY
	disabled_species = list(/datum/species/shadow, /datum/species/shadow/nightmare, /datum/species/voidwalker,
							/datum/species/abductor, /datum/species/abductor/abductorweak, /datum/species/android,
							/datum/species/dullahan, /datum/species/ethereal, /datum/species/ethereal/lustrous,
							/datum/species/human, /datum/species/human/felinid, /datum/species/human/felinid/primitive,
							/datum/species/human/vampire, /datum/species/human/krokodil_addict, /datum/species/fly,
							/datum/species/golem, /datum/species/jelly, /datum/species/jelly/slime,
							/datum/species/jelly/luminescent, /datum/species/jelly/stargazer, /datum/species/jelly/roundstartslime,
							/datum/species/lizard, /datum/species/lizard/ashwalker, /datum/species/lizard/silverscale,
							/datum/species/monkey, /datum/species/moth, /datum/species/mush,
							/datum/species/plasmaman, /datum/species/pod, /datum/species/pod/podweak,
							/datum/species/skeleton, /datum/species/snail, /datum/species/zombie,
							/datum/species/zombie/infectious, /datum/species/vox_primalis,
							/datum/species/akula, /datum/species/aquatic, /datum/species/dwarf,
							/datum/species/ghoul, /datum/species/humanoid, /datum/species/insect,
							/datum/species/mammal, /datum/species/skrell, /datum/species/tajaran,
							/datum/species/unathi, /datum/species/vox, /datum/species/vulpkanin,
							/datum/species/xeno, /datum/species/hemophage, /datum/species/teshari,
							/datum/species/mutant, /datum/species/mutant/infectious, /datum/species/mutant/infectious/fast,
							/datum/species/mutant/infectious/slow)

/datum/quirk/system_shock/add(client/client_source)
	if(issynthetic(quirk_holder))
		RegisterSignals(quirk_holder, list(COMSIG_LIVING_ELECTROCUTE_ACT, COMSIG_LIVING_MINOR_SHOCK), PROC_REF(on_electrocute))

/datum/quirk/system_shock/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_ELECTROCUTE_ACT, COMSIG_LIVING_MINOR_SHOCK))


/datum/quirk/system_shock/proc/on_electrocute()
	SIGNAL_HANDLER
	var/knockout_length = 0.9 SECONDS + rand(0 SECONDS, 0.5 SECONDS)
	quirk_holder.set_static_vision(knockout_length)
	quirk_holder.balloon_alert(quirk_holder, "system rebooting")
	to_chat(quirk_holder, span_danger("CRIT&!AL ERR%R: S#STEM REBO#TING."))
	addtimer(CALLBACK(src, PROC_REF(knock_out), knockout_length - 0.4 SECONDS), 2 SECONDS)
	//The intent with the 0.4 seconds is so that the visual static effect lasts longer than the actual knockout/sleeping effect.

/datum/quirk/system_shock/proc/knock_out(var/length)
	quirk_holder.Sleeping(length)
