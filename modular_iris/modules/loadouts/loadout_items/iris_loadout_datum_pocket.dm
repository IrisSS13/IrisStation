/datum/loadout_item/pocket_items/drugs_psicodine
	name = "Psicodine Pills"
	item_path = /obj/item/storage/pill_bottle/psicodine

/datum/loadout_item/pocket_items/wheelchair
	name = "Wheelchair"
	item_path = /obj/item/wheelchair

// Mod Platings for Proteans
/datum/loadout_item/pocket_items/plating
	name = "Standard Plating"
	item_path = /obj/item/mod/construction/plating
	restricted_species = list(SPECIES_PROTEAN) // Might have to remove this
	group = "Species-Unique"

/datum/loadout_item/pocket_items/plating/engineering
	name = "Engineering Plating"
	item_path = /obj/item/mod/construction/plating/engineering

/datum/loadout_item/pocket_items/plating/atmospherics
	name = "Atmospherics Plating"
	item_path = /obj/item/mod/construction/plating/atmospheric

/datum/loadout_item/pocket_items/plating/medical
	name = "Medical Plating"
	item_path = /obj/item/mod/construction/plating/medical

/datum/loadout_item/pocket_items/plating/security
	name = "Security Plating"
	item_path = /obj/item/mod/construction/plating/security
	restricted_roles = list(JOB_WARDEN, JOB_DETECTIVE, JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER)
