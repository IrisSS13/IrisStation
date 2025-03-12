//Port of https://github.com/Monkestation/Monkestation2.0/pull/5623
/datum/quirk/item_quirk/addict/caffeinedependence
	name = "Caffeine Dependence"
	desc = "You are just not the same without a cup of coffee."
	icon = FA_ICON_COFFEE
	value = -2
	gain_text = span_danger("You'd really like a cup of coffee.")
	lose_text = span_notice("Coffee just doesn't seem as appealing anymore.")
	medical_record_text = "Patient is highly dependent on caffeine."
	reagent_type = /datum/reagent/consumable/coffee
	drug_container_type = /obj/item/reagent_containers/cup/glass/coffee
	mob_trait = TRAIT_CAFFEINE_DEPENDENCE
	hardcore_value = 0
	drug_flavour_text = "Better make good friends with the coffee machine."
	mail_goodies = list(
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/icecoffee,
		/datum/reagent/consumable/hot_ice_coffee,
		/datum/reagent/consumable/soy_latte,
		/datum/reagent/consumable/cafe_latte,
		/datum/reagent/consumable/pumpkin_latte,
	)
