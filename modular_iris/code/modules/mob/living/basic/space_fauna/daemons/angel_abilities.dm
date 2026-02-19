

// Fires a Shotgun-Esque Blast of the Angel Proj
/datum/action/cooldown/mob_cooldown/projectile_attack/angel_shotgun
	name = "Deliver Upon Them Divine Absolution"
	button_icon = 'icons/obj/weapons/guns/ballistic.dmi'
	button_icon_state = "shotgun"
	desc = "Fires Absolution in a shotgun pattern."
	cooldown_time = 2 SECONDS
	projectile_type = /obj/projectile/angel
	projectile_sound = 'modular_iris/sound/daemons/angel_deep_strike.ogg'
	var/list/shot_angles = list(12.5, 7.5, 2.5, -2.5, -7.5, -12.5)

/datum/action/cooldown/mob_cooldown/projectile_attack/angel_shotgun/attack_sequence(mob/living/firer, atom/target)
	fire_shotgun(firer, target, shot_angles)

/datum/action/cooldown/mob_cooldown/projectile_attack/angel_shotgun/proc/fire_shotgun(mob/living/firer, atom/target, list/chosen_angles)
	playsound(firer, projectile_sound, 200, TRUE, 2)
	for(var/spread in chosen_angles)
		shoot_projectile(firer, target, null, firer, spread, null)
	owner.icon_state = "hostile" // This definitely needs a check to make sure you are the proper mob for this, otherwise it breaks everyone else.



/obj/projectile/angel
	name = "absolution bolt"
	icon = 'modular_iris/icons/mob/simple/angel_projectiles.dmi'
	icon_state = "divine_bolt"
	damage = 50
	armour_penetration = 100
	speed = 0.5
	damage_type = BURN
	pass_flags = PASSTABLE
	plane = GAME_PLANE
	immobilize = 1 SECONDS

/obj/projectile/angel/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(isliving(target) && target != firer)
		direct_target = TRUE
	return ..(target, direct_target, ignore_loc, cross_failed)

// Fires a Resurrection Bolt
/datum/action/cooldown/mob_cooldown/projectile_attack/angel_grace
	name = "Divine Essence"
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "blastwave"
	desc = "Deliver Divine Essence upon a target to heal them for full."
	cooldown_time = 1.5 SECONDS
	projectile_type = /obj/projectile/magic/resurrection
	projectile_sound = 'modular_iris/sound/daemons/angel_revival.ogg'

/datum/action/cooldown/mob_cooldown/projectile_attack/angel_grace/Activate(atom/target_atom)
	. = ..()
	playsound(owner, projectile_sound, 200, TRUE, 2)
	owner.visible_message(span_danger("[owner] delivers Divine Grace!"))
	owner.face_atom(target_atom)
	owner.icon_state = "idle"




// Fires repeatedly many Angel Bolts
/datum/action/cooldown/mob_cooldown/projectile_attack/blind_rage
	name = "Divine Wrath"
	button_icon = 'icons/obj/weapons/guns/energy.dmi'
	button_icon_state = "kineticgun"
	desc = "Fires projectiles repeatedly at a given target."
	cooldown_time = 1.5 SECONDS
	projectile_type = /obj/projectile/angel
	projectile_sound = 'modular_iris/sound/daemons/angel_wrath.ogg'
	default_projectile_spread = 45
	/// Total shot count
	var/shot_count = 10
	/// Delay between shots
	var/shot_delay = 0.1 SECONDS

/datum/action/cooldown/mob_cooldown/projectile_attack/blind_rage/Activate(atom/target_atom)
	. = ..()
	playsound(owner, projectile_sound, 200, TRUE, 2)
	owner.icon_state = "hostile"

/datum/action/cooldown/mob_cooldown/projectile_attack/blind_rage/attack_sequence(mob/living/firer, atom/target)
	for(var/i in 1 to shot_count)
		shoot_projectile(firer, target, null, firer, rand(-default_projectile_spread, default_projectile_spread), null)
		SLEEP_CHECK_DEATH(shot_delay, src)
		playsound(owner, projectile_sound, 150, TRUE, 2)
