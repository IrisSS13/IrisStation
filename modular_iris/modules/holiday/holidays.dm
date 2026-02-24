/datum/holiday/iris // Iris' Anniversary
	name = "Iris Station's Anniversary"
	timezones = list(TIMEZONE_EDT, TIMEZONE_CDT, TIMEZONE_MDT, TIMEZONE_MST, TIMEZONE_PDT, TIMEZONE_AKDT, TIMEZONE_HDT, TIMEZONE_HST)
	begin_day = 12
	end_day = 14
	begin_month = JUNE
	holiday_hat = /obj/item/clothing/head/costume/nova/flowerpin/iris
	holiday_colors = list(
	COLOR_PRIDE_PURPLE,
	COLOR_WHITE,
	COLOR_PRIDE_YELLOW,
	)

/datum/holiday/iris/greet()
	return "On the day 12th of June, Iris Station was formed. Happy Birthday, Iris Station. Thanks for playing! <3"

/datum/holiday/iris/getStationPrefix()
	return pick("Cabriole","Iris","Anniversary","Aimatios")

/datum/holiday/iris/end // A week to remember
	name = "Iris Week"
	begin_day = 23
	begin_month = FEBRUARY
	end_day = 28
	holiday_hat = /obj/item/clothing/head/costume/nova/flowerpin/iris

/datum/holiday/iris/end/greet()
	return "Happy Iris Week! 28th of February marks the end of Iris Station. Thank you for being part of it!"
