#define GERMANY_RELAY_ADDR "byond://germany.irisstation.lol:4200"
#define US_EAST_RELAY_ADDR "byond://useast.irisstation.lol:4200"
#define US_WEST_RELAY_ADDR "byond://uswest.irisstation.lol:4200"
#define SYDNEY_RELAY_ADDR "byond://sydney.irisstation.lol:4200"
#define SINGAPORE_RELAY_ADDR "byond://singapore.irisstation.lol:4200"
#define NO_RELAY_ADDR "byond://play.irisstation.lol:4200"

#define GERMANY_RELAY "Connect to Germany (Europe)"
#define US_EAST_RELAY "Connect to US-East (Virginia)"
#define US_WEST_RELAY "Connect to US-West (California)"
#define SYDNEY_RELAY "Connect to Sydney (Australia)"
#define SINGAPORE_RELAY "Connect to Singapore (Asia)"
#define NO_RELAY "No Relay (Direct Connect)"

/client/verb/go2relay()
	var/list/static/relays = list(
		GERMANY_RELAY,
		US_EAST_RELAY,
		US_WEST_RELAY,
		SYDNEY_RELAY,
		SINGAPORE_RELAY,
		NO_RELAY,
	)
	var/choice = tgui_input_list(usr, "Which relay do you wish to use? Relays help with improving ping and keeping it stable.", "Relay Select", relays)
	var/destination
	switch(choice)
		if(GERMANY_RELAY)
			destination = GERMANY_RELAY_ADDR
		if(US_EAST_RELAY)
			destination = US_EAST_RELAY_ADDR
		if(US_WEST_RELAY)
			destination = US_WEST_RELAY_ADDR
		if(SYDNEY_RELAY)
			destination = SYDNEY_RELAY_ADDR
		if(SINGAPORE_RELAY)
			destination = SINGAPORE_RELAY_ADDR
		if(NO_RELAY)
			destination = NO_RELAY_ADDR
	if(destination)
		usr << link(destination)
		sleep(1 SECONDS)
		winset(usr, null, "command=.quit")
	else
		usr << "You didn't select a relay."

#undef GERMANY_RELAY_ADDR
#undef US_EAST_RELAY_ADDR
#undef US_WEST_RELAY_ADDR
#undef SYDNEY_RELAY_ADDR
#undef SINGAPORE_RELAY_ADDR
#undef NO_RELAY_ADDR

#undef GERMANY_RELAY
#undef US_EAST_RELAY
#undef US_WEST_RELAY
#undef SYDNEY_RELAY
#undef SINGAPORE_RELAY
#undef NO_RELAY
