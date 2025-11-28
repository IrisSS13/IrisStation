/obj/item/clothing/suit/toggle/labcoat/cmo/alt
	name = "chief medical officer's coat"
	desc = "A mix between a labcoat and just a regular coat. It's made out of a medical-grade antibacterial, anti-acidic, and anti-biohazardous synthetic fabric."
	icon_state = "labcoat_cmo_alt"
	icon = 'modular_iris/icons/obj/clothing/suits/labcoat_alt.dmi'
	worn_icon = 'modular_iris/icons/mob/clothing/suits/labcoat_alt.dmi'
	inhand_icon_state = null

/obj/item/clothing/suit/toggle/labcoat/cmo/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/obj/item/clothing/suit/toggle/labcoat/cmo/alt/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
		/obj/item/gun/energy/cell_loaded/medigun, //NOVA EDIT ADDITION - MEDIGUNS
		/obj/item/storage/medkit, //NOVA EDIT ADDITION
	)
