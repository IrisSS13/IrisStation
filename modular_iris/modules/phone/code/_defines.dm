// Equipment Macros
#define PHONE_DND_FORCED 2
#define PHONE_DND_ON 1
#define PHONE_DND_OFF 0
#define PHONE_DND_FORBIDDEN -1

/// Phone call states for clearer state management
#define PHONE_STATE_IDLE 0
#define PHONE_STATE_DIALING 1
#define PHONE_STATE_RINGING 2
#define PHONE_STATE_CONNECTED 3

#define PHONE_ON_BASE_UNIT_ICON_STATE "[initial(icon_state)]"
#define PHONE_OFF_BASE_UNIT_ICON_STATE "[initial(icon_state)]_ear"
#define PHONE_RINGING_ICON_STATE "[initial(icon_state)]_ring"

#define HANDSET_RANGE 7

// Sound Effect Macros
#define SFX_PHONE_RTB_HANDSET "phone_rtb_handset"

// Signal Macros
/// From /datum/action/item_action/rto_pack/use_phone/action_activate()
#define COMSIG_ATOM_PHONE_BUTTON_USE "atom_phone_button_use"

/// From /datum/component/phone/proc/picked_up_call() and /datum/component/phone/proc/post_call_phone()
#define COMSIG_ATOM_PHONE_PICKED_UP "atom_phone_picked_up"
/// From /datum/component/phone/proc/recall_handset()
#define COMSIG_ATOM_PHONE_HUNG_UP "atom_phone_hung_up"
/// From /datum/component/phone/proc/call_phone()
#define COMSIG_ATOM_PHONE_RINGING "atom_phone_ringing"
/// From /datum/component/phone/proc/reset_call()
#define COMSIG_ATOM_PHONE_STOPPED_RINGING "atom_phone_stopped_ringing"

/// Global signal sent when any phone changes state (tgui will make me insane)
#define COMSIG_GLOB_PHONE_STATE_CHANGED "glob_phone_state_changed"

/// From /datum/computer_file/program/phone_monitor, when a linked phone receives an incoming call
#define COMSIG_PHONE_LINKED_CALL_INCOMING "phone_linked_call_incoming"
/// From /datum/computer_file/program/phone_monitor, when the linked phone is destroyed/deconstructed
#define COMSIG_PHONE_LINKED_UNLINKED "phone_linked_unlinked"
