#define MINIMUM_CLOTHING_STOCK 5

/obj/machinery/vending
	/// Additions to the `products` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/products_iris
	/// Additions to the `product_categories` list of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/product_categories_iris
	/// Additions to the `premium` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/premium_iris
	/// Additions to the `contraband` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/contraband_iris

/obj/machinery/vending/Initialize(mapload)
	if(products_iris)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in products_iris)
			products[item_to_add] = products_iris[item_to_add]

	if(product_categories_iris)
		for(var/category in product_categories_iris)
			var/already_exists = FALSE
			for(var/existing_category in product_categories)
				if(existing_category["name"] == category["name"])
					existing_category["products"] += category["products"]
					already_exists = TRUE
					break

			if(!already_exists)
				product_categories += list(category)

	if(premium_iris)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in premium_iris)
			premium[item_to_add] = premium_iris[item_to_add]

	if(contraband_iris)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in contraband_iris)
			contraband[item_to_add] = contraband_iris[item_to_add]

	// Time to make clothes amounts consistent!
	for (var/obj/item/clothing/item in products)
		if(products[item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
			products[item] = MINIMUM_CLOTHING_STOCK

	for (var/category in product_categories)
		for(var/obj/item/clothing/item in category["products"])
			if(category["products"][item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
				category["products"][item] = MINIMUM_CLOTHING_STOCK

	for (var/obj/item/clothing/item in premium)
		if(premium[item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
			premium[item] = MINIMUM_CLOTHING_STOCK

	QDEL_NULL(products_iris)
	QDEL_NULL(product_categories_iris)
	QDEL_NULL(premium_iris)
	QDEL_NULL(contraband_iris)
	return ..()

#undef MINIMUM_CLOTHING_STOCK
