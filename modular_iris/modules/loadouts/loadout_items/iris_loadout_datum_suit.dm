// COSTUMES
/datum/loadout_item/suit/drfreeze_coat
	name = "Doctor Freeze's Labcoat"
	item_path = /obj/item/clothing/suit/costume/drfreeze_coat

/datum/loadout_item/suit/nemes
	name = "Pharoah Tunic"
	item_path = /obj/item/clothing/suit/costume/nemes

/datum/loadout_item/suit/tailcoat //Tailcoat from MonkeStation
	name = "Recolorable Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat

// JOBS
/datum/loadout_item/suit/labcoat_paramedic
	name = "Paramedic's Jacket"
	item_path = /obj/item/clothing/suit/toggle/labcoat/paramedic

/datum/loadout_item/suit/transform_wintercoat
	name = "Transformative Wintercoat (briefcase-only)"
	item_path = /obj/item/transformative_wintercoat

/datum/loadout_item/suit/tailcoat_bar //Tailcoat from MonkeStation
	name = "Bartender's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/bartender
	restricted_roles = list(JOB_BARTENDER)
	group = "Job-Locked"

/datum/loadout_item/suit/techpriest
	name = "Techpriest Robes"
	item_path = /obj/item/clothing/suit/hooded/techpriest

// NABBER ITEMS
/datum/loadout_item/suit/nabberponcho
	name = "Giant Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho
	species_whitelist = list(SPECIES_NABBER)

/datum/loadout_item/suit/nabberponcho_cargo
	name = "Cargo Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho/cargo
	species_whitelist = list(SPECIES_NABBER)

/datum/loadout_item/suit/nabberponcho_engi
	name = "Engineering Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho/engi
	species_whitelist = list(SPECIES_NABBER)

/datum/loadout_item/suit/nabberponcho_sec
	name = "Security Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho/security
	species_whitelist = list(SPECIES_NABBER)

/datum/loadout_item/suit/nabberponcho_sci
	name = "Science Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho/science
	species_whitelist = list(SPECIES_NABBER)

/datum/loadout_item/suit/nabberponcho_med
	name = "Medbay Poncho"
	item_path = /obj/item/clothing/suit/costume/nabber_poncho/medbay
	species_whitelist = list(SPECIES_NABBER)
