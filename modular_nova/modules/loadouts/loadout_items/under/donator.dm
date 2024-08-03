/datum/loadout_category/donator
	category_name = "Donator"
	category_ui_icon = FA_ICON_QUESTION
	type_to_generate = /datum/loadout_item/donator/
	tab_order = /datum/loadout_category/feet::tab_order + 2

/datum/loadout_item/donator/under/jumpsuit/
	abstract_type = /datum/loadout_item/donator/under/jumpsuit/
	donator_only = TRUE

/datum/loadout_item/donator/under/jumpsuit/enclavesergeant
	name = "Enclave - Sergeant"
	item_path = /obj/item/clothing/under/syndicate/nova/enclave

/datum/loadout_item/donator/under/jumpsuit/enclaveofficer
	name = "Enclave - Officer"
	item_path = /obj/item/clothing/under/syndicate/nova/enclave/officer

/datum/loadout_item/donator/under/jumpsuit/blondie
	name = "Blonde Cowboy Uniform"
	item_path = /obj/item/clothing/under/rank/security/detective/cowboy/armorless
