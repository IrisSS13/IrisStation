#define MODULAR_EYES_ICON 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'
#define MODULAR_EYES_WORN_ICON 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'

/obj/item/clothing/glasses/eyepatch/wrap
	name = "eye wrap"
	desc = "A glorified bandage. At least this one's actually made for your head..."
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "eyewrap"
	base_icon_state = "eyewrap"

/obj/item/clothing/glasses/eyepatch/white
	name = "white eyepatch"
	desc = "This is what happens when a pirate gets a PhD."
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "eyepatch_white"
	base_icon_state = "eyepatch_white"

///GLASSES
/obj/item/clothing/glasses/regular/modern
	name = "modern glasses"
	desc = "After Nerd. Co went bankrupt for tax evasion and invasion, they were bought out by Dork.Co, who revamped their classic design."
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "glasses_alt"
	inhand_icon_state = "glasses"

/obj/item/clothing/glasses/trickblindfold/hamburg
	name = "thief visor"
	desc = "Perfect for stealing hamburgers from innocent multinational capitalist monopolies."
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "thiefmask"

//IRIS ADDITION START:

// GAGS variant of base prescription glasses, so we don't fuck up everything else
/obj/item/clothing/glasses/regular/color
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/glasses/regular/color"
	post_init_icon_state = "glasses_regular_color"
	greyscale_config = /datum/greyscale_config/glasses_regular_color
	greyscale_config_worn = /datum/greyscale_config/glasses_regular_color/worn
	greyscale_colors = "#0d0d0d#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1

// transparent variety of three prescription glasses
/obj/item/clothing/glasses/regular/transparent
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/glasses/regular/transparent"
	post_init_icon_state = "glasses_transparent_regular_color"
	greyscale_config = /datum/greyscale_config/glasses_transparent_regular_color
	greyscale_config_worn = /datum/greyscale_config/glasses_transparent_regular_color/worn
	greyscale_colors = "#0d0d0d#9CCBFB"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/glasses/regular/circle/transparent
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/glasses/regular/circle/transparent"
	post_init_icon_state = "glasses_transparent_circle_color"
	greyscale_config = /datum/greyscale_config/glasses_transparent_circle_color
	greyscale_config_worn = /datum/greyscale_config/glasses_transparent_circle_color/worn
	greyscale_colors = "#0d0d0d#9CCBFB"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/glasses/regular/thin/transparent
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/glasses/regular/thin/transparent"
	post_init_icon_state = "glasses_transparent_thin_color"
	greyscale_config = /datum/greyscale_config/glasses_transparent_thin_color
	greyscale_config_worn = /datum/greyscale_config/glasses_transparent_thin_color/worn
	greyscale_colors = "#0d0d0d#9CCBFB"
	flags_1 = IS_PLAYER_COLORABLE_1

//IRIS ADDITION END

///GOGGLES
/obj/item/clothing/glasses/biker
	name = "biker goggles"
	desc = "Brown leather riding gear, You can leave, just give us the gas."
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "biker"
	inhand_icon_state = "welding-g"
	clothing_traits = list(TRAIT_NEARSIGHTED_CORRECTED)

// Like sunglasses, but without any protection
/obj/item/clothing/glasses/fake_sunglasses
	name = "low-UV sunglasses"
	desc = "A cheaper brand of sunglasses rated for much lower UV levels. Offers the user no protection against bright lights."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"
