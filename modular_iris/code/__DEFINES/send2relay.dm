#define US_EAST_RELAY_ADDR "byond://useast.irisstation.lol:4200"
#define NO_RELAY_ADDR "byond://play.irisstation.lol:4200"

#define US_EAST_RELAY "Connect to US-East (Virginia)"
#define NO_RELAY "No Relay (Direct Connect)"

/client/verb/go2relay()
	var/list/static/relays = list(
		US_EAST_RELAY,
		NO_RELAY,
	)
	var/choice = tgui_input_list(usr, "Which relay do you wish to use?", "Relay Select", relays)
	var/destination
	switch(choice)
		if(US_EAST_RELAY)
			destination = US_EAST_RELAY_ADDR
		if(NO_RELAY)
			destination = NO_RELAY_ADDR
	if(destination)
		usr << link(destination)
		sleep(1 SECONDS)
		winset(usr, null, "command=.quit")
	else
		usr << "You didn't select a relay."

#undef US_EAST_RELAY_ADDR
#undef NO_RELAY_ADDR

#undef US_EAST_RELAY
#undef NO_RELAY
