#define MISCREANT_OBJECTIVES_FILE "iris/miscreant_objectives.json"

/datum/antagonist/miscreant
	name = "\improper Miscreant"
	roundend_category = "miscreants"
	antagpanel_category = "Miscreants"
	job_rank = ROLE_MISCREANT
	antag_moodlet = /datum/mood_event/miscreant
	hud_icon = 'modular_iris/modules/miscreants/icons/miscreants_hud.dmi'
	antag_hud_name = "miscreant"
	var/datum/team/miscreants/miscreant_team

/datum/antagonist/miscreant/can_be_owned(datum/mind/new_owner)
	if((new_owner.assigned_role.departments_bitflags & (DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_CAPTAIN | DEPARTMENT_BITFLAG_CENTRAL_COMMAND)) > 0)
		return FALSE
	return ..()

/datum/antagonist/miscreant/admin_add(datum/mind/new_owner, mob/admin)
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has made [key_name_admin(new_owner)] a miscreant.")
	log_admin("[key_name(admin)] has made [key_name(new_owner)] a miscreant.")
	to_chat(new_owner.current, span_userdanger("You are a miscreant!"))

/datum/antagonist/miscreant/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_team_hud(M, /datum/antagonist/miscreant)

/datum/antagonist/miscreant/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current

/datum/antagonist/miscreant/on_gain()
	. = ..()
	create_objectives()
	owner.current.log_message("has been converted into a miscreant!", LOG_ATTACK, color="red")

/datum/antagonist/miscreant/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/miscreant/greet()
	. = ..()
	to_chat(owner, span_userdanger("Help your cause. Do not harm your fellow miscreants. You can identify your comrades by the brown \"M\" icons."))
	owner.announce_objectives()

/datum/antagonist/miscreant/create_team(datum/team/miscreants/new_team)
	if(!new_team)
		//For now only one revolution at a time
		for(var/datum/antagonist/miscreant/M in GLOB.antagonists)
			if(!M.owner)
				continue
			if(M.miscreant_team)
				miscreant_team = M.miscreant_team
				return
		miscreant_team = new /datum/team/miscreants
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	miscreant_team = new_team

/datum/antagonist/rev/get_team()
	return rev_team

/datum/antagonist/rev/proc/create_objectives()
	objectives |= rev_team.objectives

/datum/antagonist/rev/proc/remove_objectives()
	objectives -= rev_team.objectives

//Bump up to head_rev
/datum/antagonist/rev/proc/promote()
	var/old_team = rev_team
	var/datum/mind/old_owner = owner
	silent = TRUE
	owner.remove_antag_datum(/datum/antagonist/rev)
	var/datum/antagonist/rev/head/new_revhead = new()
	new_revhead.silent = TRUE
	old_owner.add_antag_datum(new_revhead,old_team)
	new_revhead.silent = FALSE
	to_chat(old_owner, span_userdanger("You have proved your devotion to revolution! You are a head revolutionary now!"))

/datum/antagonist/rev/get_admin_commands()
	. = ..()
	.["Promote"] = CALLBACK(src, PROC_REF(admin_promote))

/datum/antagonist/rev/proc/admin_promote(mob/admin)
	var/datum/mind/O = owner
	promote()
	message_admins("[key_name_admin(admin)] has head-rev'ed [O].")
	log_admin("[key_name(admin)] has head-rev'ed [O].")

/datum/antagonist/rev/head/go_through_with_admin_add(datum/mind/new_owner, mob/admin)
	give_flash = TRUE
	give_hud = TRUE
	remove_clumsy = TRUE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has head-rev'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has head-rev'ed [key_name(new_owner)].")
	to_chat(new_owner.current, span_userdanger("You are a member of the revolutionaries' leadership now!"))

/datum/antagonist/rev/head/get_admin_commands()
	. = ..()
	. -= "Promote"
	.["Take flash"] = CALLBACK(src, PROC_REF(admin_take_flash))
	.["Give flash"] = CALLBACK(src, PROC_REF(admin_give_flash))
	.["Repair flash"] = CALLBACK(src, PROC_REF(admin_repair_flash))
	.["Demote"] = CALLBACK(src, PROC_REF(admin_demote))

/datum/antagonist/rev/head/proc/admin_take_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/handheld/flash = locate() in L
	if (!flash)
		to_chat(admin, span_danger("Deleting flash failed!"))
		return
	qdel(flash)

/datum/antagonist/rev/head/proc/admin_give_flash(mob/admin)
	//This is probably overkill but making these impact state annoys me
	var/old_give_flash = give_flash
	var/old_give_hud = give_hud
	var/old_remove_clumsy = remove_clumsy
	give_flash = TRUE
	give_hud = FALSE
	remove_clumsy = FALSE
	equip_rev()
	give_flash = old_give_flash
	give_hud = old_give_hud
	remove_clumsy = old_remove_clumsy

/datum/antagonist/rev/head/proc/admin_repair_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/handheld/flash = locate() in L
	if (!flash)
		to_chat(admin, span_danger("Repairing flash failed!"))
	else
		flash.burnt_out = FALSE
		flash.update_appearance()

/datum/antagonist/rev/head/proc/admin_demote(mob/admin)
	message_admins("[key_name_admin(admin)] has demoted [key_name_admin(owner)] from head revolutionary.")
	log_admin("[key_name(admin)] has demoted [key_name(owner)] from head revolutionary.")
	demote()

/datum/antagonist/rev/head
	name = "\improper Head Revolutionary"
	antag_hud_name = "rev_head"
	job_rank = ROLE_REV_HEAD

	preview_outfit = /datum/outfit/revolutionary
	hardcore_random_bonus = TRUE

	var/remove_clumsy = FALSE
	var/give_flash = FALSE
	var/give_hud = TRUE

/datum/antagonist/rev/head/pre_mindshield(mob/implanter, mob/living/mob_override)
	return COMPONENT_MINDSHIELD_RESISTED

/datum/antagonist/rev/head/on_removal()
	if(give_hud)
		var/mob/living/carbon/C = owner.current
		var/obj/item/organ/cyberimp/eyes/hud/security/syndicate/S = C.get_organ_slot(ORGAN_SLOT_HUD)
		if(S)
			S.Remove(C)
	return ..()

/datum/antagonist/rev/head/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/real_mob = mob_override || owner.current
	real_mob.AddComponentFrom(REF(src), /datum/component/can_flash_from_behind)
	RegisterSignal(real_mob, COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON, PROC_REF(on_flash_success))

/datum/antagonist/rev/head/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/real_mob = mob_override || owner.current
	real_mob.RemoveComponentSource(REF(src), /datum/component/can_flash_from_behind)
	UnregisterSignal(real_mob, COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON)

/// Signal proc for [COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON].
/// Bread and butter of revolution conversion, successfully flashing a carbon will make them a revolutionary
/datum/antagonist/rev/head/proc/on_flash_success(mob/living/source, mob/living/carbon/flashed, obj/item/assembly/flash/flash, deviation)
	SIGNAL_HANDLER

	if(flashed.stat == DEAD)
		return
	if(flashed.stat != CONSCIOUS)
		to_chat(source, span_warning("[flashed.p_They()] must be conscious before you can convert [flashed.p_them()]!"))
		return

	if(isnull(flashed.mind) || !GET_CLIENT(flashed))
		to_chat(source, span_warning("[flashed]'s mind is so vacant that it is not susceptible to influence!"))
		return

	var/holiday_meme_chance = check_holidays(APRIL_FOOLS) && prob(10)
	if(add_revolutionary(flashed.mind, mute = !holiday_meme_chance)) // don't mute if we roll the meme holiday chance
		if(holiday_meme_chance)
			INVOKE_ASYNC(src, PROC_REF(_async_holiday_meme_say), flashed)
		flash.times_used-- // Flashes are less likely to burn out for headrevs, when used for conversion
	else
		to_chat(source, span_warning("[flashed] seems resistant to [flash]!"))

/// Used / called async from [proc/on_flash] to deliver a funny meme line
/datum/antagonist/rev/head/proc/_async_holiday_meme_say(mob/living/carbon/flashed)
	if(ishuman(flashed))
		var/mob/living/carbon/human/human_flashed = flashed
		human_flashed.force_say()
	flashed.say("You son of a bitch! I'm in.", forced = "That son of a bitch! They're in. (April Fools)")

/datum/antagonist/rev/head/antag_listing_name()
	return ..() + "(Leader)"

/datum/antagonist/rev/head/get_preview_icon()
	var/icon/final_icon = render_preview_outfit(preview_outfit)

	final_icon.Blend(make_assistant_icon("Business Hair"), ICON_UNDERLAY, -8, 0)
	final_icon.Blend(make_assistant_icon("CIA"), ICON_UNDERLAY, 8, 0)

	// Apply the rev head HUD, but scale up the preview icon a bit beforehand.
	// Otherwise, the R gets cut off.
	final_icon.Scale(64, 64)

	var/icon/rev_head_icon = icon('icons/mob/huds/antag_hud.dmi', "rev_head")
	rev_head_icon.Scale(48, 48)
	rev_head_icon.Crop(1, 1, 64, 64)
	rev_head_icon.Shift(EAST, 10)
	rev_head_icon.Shift(NORTH, 16)
	final_icon.Blend(rev_head_icon, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/antagonist/rev/head/proc/make_assistant_icon(hairstyle)
	var/mob/living/carbon/human/dummy/consistent/assistant = new
	assistant.set_hairstyle(hairstyle, update = TRUE)

	var/icon/assistant_icon = render_preview_outfit(/datum/outfit/job/assistant/consistent, assistant)
	assistant_icon.ChangeOpacity(0.5)

	qdel(assistant)

	return assistant_icon

/datum/antagonist/rev/proc/can_be_converted(mob/living/candidate)
	if(!candidate.mind)
		return FALSE
	if(!can_be_owned(candidate.mind))
		return FALSE
	var/mob/living/carbon/C = candidate //Check to see if the potential rev is implanted
	if(!istype(C)) //Can't convert simple animals
		return FALSE
	return TRUE

/**
 * Adds a new mind to our revoltuion
 *
 * * rev_mind - the mind we're adding
 * * stun - If TRUE, we will flash act and apply a long stun when we're applied
 * * mute - If TRUE, we will apply a mute when we're applied
 */
/datum/antagonist/rev/proc/add_revolutionary(datum/mind/rev_mind, stun = TRUE, mute = TRUE)
	if(!can_be_converted(rev_mind.current))
		return FALSE

	if(mute)
		rev_mind.current.set_silence_if_lower(10 SECONDS)
	if(stun)
		rev_mind.current.flash_act(1, 1)
		rev_mind.current.Stun(10 SECONDS)

	rev_mind.add_memory(/datum/memory/recruited_by_headrev, protagonist = rev_mind.current, antagonist = owner.current)
	rev_mind.add_antag_datum(/datum/antagonist/rev,rev_team)
	rev_mind.special_role = ROLE_REV
	return TRUE

/datum/antagonist/rev/head/proc/demote()
	var/datum/mind/old_owner = owner
	var/old_team = rev_team
	silent = TRUE
	owner.remove_antag_datum(/datum/antagonist/rev/head)
	var/datum/antagonist/rev/new_rev = new /datum/antagonist/rev()
	new_rev.silent = TRUE
	old_owner.add_antag_datum(new_rev,old_team)
	new_rev.silent = FALSE
	to_chat(old_owner, span_userdanger("Revolution has been disappointed of your leader traits! You are a regular revolutionary now!"))

/datum/antagonist/rev/farewell()
	owner.current.balloon_alert_to_viewers("deconverted!")
	if(ishuman(owner.current))
		owner.current.visible_message(span_deconversion_message("[owner.current] looks like [owner.current.p_theyve()] just remembered [owner.current.p_their()] real allegiance!"), null, null, null, owner.current)
		to_chat(owner, "<span class='deconversion_message bold'>You are no longer a brainwashed revolutionary! Your memory is hazy from the time you were a rebel...the only thing you remember is the name of the one who brainwashed you....</span>")
	else if(issilicon(owner.current))
		owner.current.visible_message(span_deconversion_message("The frame beeps contentedly, purging the hostile memory engram from the MMI before initializing it."), null, null, null, owner.current)
		to_chat(owner, span_userdanger("The frame's firmware detects and deletes your neural reprogramming! You remember nothing but the name of the one who flashed you."))

/datum/antagonist/rev/head/farewell()
	if (deconversion_source == DECONVERTER_STATION_WIN)
		return
	owner.current.balloon_alert_to_viewers("deconverted!")
	if((ishuman(owner.current)))
		if(owner.current.stat != DEAD)
			owner.current.visible_message(span_deconversion_message("[owner.current] looks like [owner.current.p_theyve()] just remembered [owner.current.p_their()] real allegiance!"), null, null, null, owner.current)
			to_chat(owner, "<span class='deconversion_message bold'>You have given up your cause of overthrowing the command staff. You are no longer a Head Revolutionary.</span>")
		else
			to_chat(owner, "<span class='deconversion_message bold'>The sweet release of death. You are no longer a Head Revolutionary.</span>")
	else if(issilicon(owner.current))
		owner.current.visible_message(span_deconversion_message("The frame beeps contentedly, suppressing the disloyal personality traits from the MMI before initializing it."), null, null, null, owner.current)
		to_chat(owner, span_userdanger("The frame's firmware detects and suppresses your unwanted personality traits! You feel more content with the leadership around these parts."))

/// Handles rev removal via IC methods such as borging, mindshielding, blunt force trauma to the head or revs losing.
/datum/antagonist/rev/proc/remove_revolutionary(deconverter)
	owner.current.log_message("has been deconverted from the revolution by [ismob(deconverter) ? key_name(deconverter) : deconverter]!", LOG_ATTACK, color=COLOR_CULT_RED)
	if(deconverter == DECONVERTER_BORGED)
		message_admins("[ADMIN_LOOKUPFLW(owner.current)] has been borged while being a [name]")
	owner.special_role = null
	if(iscarbon(owner.current) && deconverter)
		var/mob/living/carbon/formerrev = owner.current
		formerrev.Unconscious(10 SECONDS)
	deconversion_source = deconverter
	owner.remove_antag_datum(type)

/// This is for revheads, for which they ordinarily shouldn't be deconverted outside of revs losing. As an exception, forceborging can de-headrev them.
/datum/antagonist/rev/head/remove_revolutionary(deconverter)
	// If they're living and the station won, turn them into an exiled headrev.
	if(owner.current.stat != DEAD && deconverter == DECONVERTER_STATION_WIN)
		owner.add_antag_datum(/datum/antagonist/enemy_of_the_state)

	// Only actually remove headrev status on borging or when the station wins.
	if(deconverter == DECONVERTER_BORGED || deconverter == DECONVERTER_STATION_WIN)
		return ..()

/datum/antagonist/rev/head/equip_rev()
	var/mob/living/carbon/carbon_owner = owner.current
	if(!ishuman(carbon_owner))
		return

	if(give_flash)
		var/where = carbon_owner.equip_conspicuous_item(new /obj/item/assembly/flash/handheld)
		if (where)
			to_chat(carbon_owner, "The flash in your [where] will help you to persuade the crew to join your cause.")
		else
			to_chat(carbon_owner, "The Syndicate were unfortunately unable to get you a flash.")

	if(give_hud)
		var/obj/item/organ/cyberimp/eyes/hud/security/syndicate/hud = new()
		hud.Insert(carbon_owner)
		if(carbon_owner.get_quirk(/datum/quirk/body_purist))
			to_chat(carbon_owner, "Being a body purist, you would never accept cybernetic implants. Upon hearing this, your employers signed you up for a special program, which... for \
			some odd reason, you just can't remember... either way, the program must have worked, because you have gained the ability to keep track of who is mindshield-implanted, and therefore unable to be recruited.")
		else
			to_chat(carbon_owner, "Your eyes have been implanted with a cybernetic security HUD which will help you keep track of who is mindshield-implanted, and therefore unable to be recruited.")

/datum/team/miscreants
	name = "\improper Band of Miscreants"

	/// Maximum number of miscreants
	var/max_miscreants = 8

	/// List of all ex-headrevs. Useful because dynamic removes antag status when it ends, so this can be kept for the roundend report.
	var/list/ex_headrevs = list()

	/// List of all ex-revs. Useful because dynamic removes antag status when it ends, so this can be kept for the roundend report.
	var/list/ex_revs = list()

	/// The objective of the heads of staff, aka to kill the headrevs.
	var/list/datum/objective/mutiny/heads_objective = list()

/datum/outfit/miscreant
	name = "Miscreant (Preview only)"

	uniform = /obj/item/clothing/under/costume/soviet
	head = /obj/item/clothing/head/costume/foilhat
	gloves = /obj/item/clothing/gloves/color/yellow
	l_hand = /obj/item/crayons
	r_hand = /obj/item/melee/cleric_mace

#undef MISCREANT_OBJECTIVES_FILE
