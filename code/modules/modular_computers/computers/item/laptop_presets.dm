//IRIS EDIT: Added notepad to civilian laptop
/obj/item/modular_computer/laptop/preset/civilian
	desc = "A low-end laptop often used for personal recreation."
	starting_programs = list(
		/datum/computer_file/program/notepad,
		/datum/computer_file/program/chatclient,
	)

//Used for Mafia testing purposes.
/obj/item/modular_computer/laptop/preset/mafia
	starting_programs = list(
		/datum/computer_file/program/mafia,
	)
