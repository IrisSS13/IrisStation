/datum/keybinding/living/wrestling_stance
	hotkey_keys = list("ShiftC")
	name = "wrestling_stance"
	full_name = "Wrestling Stance"
	description = "After a short delay, enters your character into wrestling mode."
	keybind_signal = COMSIG_KB_LIVING_WRESTLING_STANCE

/datum/keybinding/living/wrestling_stance/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.user_toggle_wrestling()

/datum/config_entry/flag/wrestling_stance
