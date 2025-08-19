//generic safe variant that cannot be hacked with a multitool and is easy for mappers to set up using the new vars
/obj/structure/secure_safe/unhackable
	name = "extra secure safe"
	var/list/stored_items = list()
	var/safe_code = "00000" //must be 5 digits long, also has to be a string

/obj/structure/secure_safe/unhackable/Initialize(mapload)
	. = ..()
	if(length(safe_code) != 5)
		CRASH("[src] spawned with invalid code - code must be a string exactly five digits long.")
	//regex check here
		CRASH("[src] spawned with invalid code - code must only contain numeric characters.")

	for(var/item in stored_items)
		atom_storage.set_holdable(item)

	AddComponent(/datum/component/lockable_storage, \
		lock_code = (safe_code ? safe_code : null), \
		can_hack_open = FALSE, \
	)

/obj/structure/secure_safe/unhackable/PopulateContents()
	for(var/item in stored_items)
		new item(src)
