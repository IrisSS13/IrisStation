/client
	/// Number of times this client has adminwho'd since the last logging cooldown
	var/awho_count_since = 0
	COOLDOWN_DECLARE(adminwho_alert_cooldown)

/client/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	. = ..()

	if(COOLDOWN_FINISHED(src, adminwho_alert_cooldown) && !is_admin(src))
		var/laststring = "has checked adminwho."
		if(awho_count_since > 0)
			laststring += " ([awho_count_since] checks since last cooldown)"
		awho_count_since = 0
		message_admins("[ADMIN_STEALTHLOOKUPFLW(mob)] [laststring]")
		log_admin_private("[key_name(src)] [laststring]")
		COOLDOWN_START(src, adminwho_alert_cooldown, 1 MINUTES)

	awho_count_since++
