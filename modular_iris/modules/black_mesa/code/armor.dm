/datum/atom_skin/hecu_vest
	abstract_type = /datum/atom_skin/hecu_vest
	change_base_icon_state = TRUE

/datum/atom_skin/hecu_vest/basic
	preview_name = "Basic"
	new_icon_state = "ceramic_vest"

/datum/atom_skin/hecu_vest/corpsman
	preview_name = "Corpsman"
	new_icon_state = "ceramic_vest_medic"

/datum/atom_skin/hecu_vest/basicblack
	preview_name = "Basic Black"
	new_icon_state = "ceramic_vest_black"

/datum/atom_skin/hecu_vest/corpsmanblack
	preview_name = "Corpsman Black"
	new_icon_state = "ceramic_vest_medic_black"

/obj/item/clothing/suit/armor/vest/hecu
	name = "combat vest"
	desc = "Vest designed to take heavy beating and probably keep the user alive in the process."
	armor_type = /datum/armor/vest_hecu
	icon_state = "ceramic_vest"
	icon = 'modular_nova/modules/awaymissions_nova/icons/hecucloth.dmi'
	worn_icon = 'modular_nova/modules/awaymissions_nova/icons/hecumob.dmi'
	worn_icon_digi = 'modular_nova/modules/awaymissions_nova/icons/hecumob_digi.dmi'

/obj/item/clothing/suit/armor/vest/hecu/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hecu_vest)

/datum/armor/vest_hecu
	melee = 40
	bullet = 40
	laser = 40
	energy = 40
	bomb = 40
	fire = 80
	acid = 100
	wound = 30

/datum/atom_skin/hecu_helmet
	abstract_type = /datum/atom_skin/hecu_helmet
	change_base_icon_state = TRUE

/datum/atom_skin/hecu_helmet/basic
	preview_name = "Basic"
	new_icon_state = "ceramic_helmet"

/datum/atom_skin/hecu_helmet/corpsman
	preview_name = "Corpsman"
	new_icon_state = "ceramic_helmet_medic"

/datum/atom_skin/hecu_helmet/basicblack
	preview_name = "Basic Black"
	new_icon_state = "ceramic_helmet_black"

/datum/atom_skin/hecu_helmet/corpsmanblack
	preview_name = "Corpsman Black"
	new_icon_state = "ceramic_helmet_medic_black"

/obj/item/clothing/head/helmet/hecu
	name = "combat helmet"
	desc = "Helmet designed to take heavy beating and probably keep the user alive in the process."
	armor_type = /datum/armor/helmet_hecu
	icon_state = "ceramic_helmet"
	icon = 'modular_nova/modules/awaymissions_nova/icons/hecucloth.dmi'
	worn_icon = 'modular_nova/modules/awaymissions_nova/icons/hecumob.dmi'
	worn_icon_digi = 'modular_nova/modules/awaymissions_nova/icons/hecumob_muzzled.dmi'

/obj/item/clothing/head/helmet/hecu/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hecu_helmet)

/datum/armor/helmet_hecu
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	fire = 80
	acid = 100
	wound = 30
