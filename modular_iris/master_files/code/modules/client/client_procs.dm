/client/New()
	. = ..()

	if(QDELETED(src))
		return

	if(holder)
		var/devtool_toggle = mob.client?.prefs?.read_preference(/datum/preference/toggle/admin/auto_browser_inspect)
		if(devtool_toggle)
			winset(src, null, list("browser-options" = "+devtools"))

// Same thing as the end of set_client_age_from_db() but manual, mostly just for isBanned so we can track connections.
// Since byond_Version and byond_builds are strings, we can just put data in there without having to add another column to the table.
/proc/log_client_to_db_connection_log_manual(ckey, address, computer_id, byond_version, byond_build)
	if(!SSdbcore.shutting_down)
		SSdbcore.FireAndForget({"
			INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`)
			VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid,:byond_version,:byond_build)
		"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id, "byond_version" = byond_version, "byond_build" = byond_build))
