// Because plushes have a second desc var that needs to be updated
/obj/item/toy/plush/on_loadout_custom_described()
	normal_desc = desc

// // MODULAR PLUSHES
/obj/item/toy/plush/iris
	icon = 'modular_iris/master_files/icons/obj/plushes.dmi'
	inhand_icon_state = null

/obj/item/toy/plush/iris/harbinger
	name = "harbinger plushie"
	desc = "A plushie of a robust miner."
	icon_state = "harbinger"
