/datum/supply_pack/costumes_toys/stickers/hearts
	name = "Sticker Pack Crate - Heart"
	desc = "This crate contains two boxes of heart-shaped stickers."
	contains = list()

/datum/supply_pack/costumes_toys/stickers/hearts/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to 2)
		new /obj/item/storage/box/stickers/hearts(crate)

/datum/supply_pack/costumes_toys/stickers/plush
	name = "Sticker Pack Crate - Plush"
	desc = "This crate contains two boxes of assorted plushie-themed stickers."
	contains = list()

/datum/supply_pack/costumes_toys/stickers/plush/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to 2)
		new /obj/item/storage/box/stickers/plush(crate)


/datum/supply_pack/costumes_toys/stickers/stars
	name = "Sticker Pack Crate - Star"
	desc = "This crate contains two boxes of star-shaped stickers."
	contains = list()

/datum/supply_pack/costumes_toys/stickers/stars/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to 2)
		new /obj/item/storage/box/stickers/stars(crate)
