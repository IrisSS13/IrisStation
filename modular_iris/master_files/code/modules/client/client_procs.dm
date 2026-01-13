/client/New()
	. = ..()

	if(QDELETED(src))
		return

	if(holder)
		var/devtool_toggle = mob.client?.prefs?.read_preference(/datum/preference/toggle/admin/auto_browser_inspect)
		if(devtool_toggle)
			winset(src, null, list("browser-options" = "+devtools"))
