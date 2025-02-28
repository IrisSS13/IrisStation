//tea pots and cups

/obj/item/reagent_containers/cup/teapot
	name = "teapot"
	desc = "I'm a little teapot, short and stout."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teapot"
	fill_icon_thresholds = null
	volume = 120

/obj/item/reagent_containers/cup/teacup
	name = "teacup"
	desc = "Never a bad time for a spot of tea, old chum."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "teacup"
	fill_icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	fill_icon_thresholds = list(0, 1, 10, 20)
	volume = 30 //we must leave room for milk and sugar, afterall

/obj/item/reagent_containers/cup/miniature_jug
	name = "miniature jug"
	desc = "A tiny jug, typically used to store milk at the table."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "jug"
	fill_icon_thresholds = null
	volume = 15

/obj/item/reagent_containers/cup/sugar_pot
	name = "sugar pot"
	desc = "A pot for storing any sugar set aside for the purpose of sweeting beverages."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "sugar_pot"
	fill_icon_thresholds = null
	volume = 30

//saucers

/obj/item/plate/small/saucer
	name = "saucer"
	desc = "A very small plate shaped for the support of a teacup, with room for a spoon or dainty sweet on the side."
	icon = 'modular_iris/modules/tea_party/icons/tableware.dmi'
	icon_state = "saucer"
	max_items = 3
	max_x_offset = 4
	max_height_offset = 3
