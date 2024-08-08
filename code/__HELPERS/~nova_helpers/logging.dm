/// This logs character creator changes in debug.log
/proc/log_creator(text, list/data)
	logger.Log(LOG_CATEGORY_DEBUG_CHARACTER_CREATOR, text, data)

/// Logging for borer evolutions
/proc/log_borer_evolution(text, list/data)
	logger.Log(LOG_CATEGORY_UPLINK_BORER, text, data)
