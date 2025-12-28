//KNOWN ISSUES/BUGS

// ISSUE-1: When the creatures die and then are revived (Should not happen naturally), their offset is reset (pixel_x and pixel_y). This makes them much harder to control
// But this shouldn't be an issue since revivals should NOT be happening.
// ISSUE-2: For all of the icons for the buttons we use shit from Nova. I'll be honest, this is some real bad Tech-Debt. In the event of Nova fucking around with those,
// This entire file alongside abilities will just shit the bed and die. Definitely in the future need to add custom icons for the buttons.





/mob/living/basic/daemons/chosm_entities/vacant
	name = "vacant"
	desc = "YOU SHOULDN'T BE SEEING THIS. YOU SHOULDN'T BE SEEING THIS. YOU SHOULDN'T BE SEEING THIS."
	icon = 'modular_iris/icons/mob/simple/chosms.dmi'
	icon_state = "vacant"
	icon_living = "vacant"
	icon_dead = "vacant_dead"
	speed = 0.6
	maxHealth = 200
	health = 200
	obj_damage = 40
	pixel_x = -40
	pixel_y = -20
	melee_damage_lower = 20
	melee_damage_upper = 25
	ai_controller = /datum/ai_controller/basic_controller/chosm_basic
	max_grab = GRAB_AGGRESSIVE
	faction = list(FACTION_NETHER)
	melee_attack_cooldown = CLICK_CD_MELEE
	response_help_continuous = "pets"
	response_help_simple = "pet"
	speak_emote = list("echoes")
	initial_language_holder = /datum/language_holder/human_basic
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0)
	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	attack_sound = 'modular_iris/sound/items/weapons/distort_strike.ogg'
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	attack_vis_effect = ATTACK_EFFECT_VOID
	unique_name = TRUE
	max_stamina = 500
	stamina_crit_threshold = BASIC_MOB_NO_STAMCRIT
	stamina_recovery = 5
	max_stamina_slowdown = 12
	/// Actions to grant on Initialize
	var/list/innate_actions = null
	var/web_speed = 1
	var/web_type = /datum/action/cooldown/mob_cooldown/lay_membrane


/mob/living/basic/daemons/chosm_entities/vacant/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_WEB_SURFER, TRAIT_FENCE_CLIMBER), INNATE_TRAIT) // This is required due to how I've implemented Membranes. Anyone with the Web Surfer trait can just walk over them.
	grant_actions_by_list(innate_actions)
	transform = transform.Scale(0.8, 0.8)
	// Actually adding the lay_membrane ability to all children of this mob type. This is extremely useful because of how modifiable it is.
	var/datum/action/cooldown/mob_cooldown/lay_membrane/sinuous_tissue/webbing = new web_type(src)
	webbing.webbing_time *= web_speed
	webbing.Grant(src)
	ai_controller?.set_blackboard_key(BB_SPIDER_WEB_ACTION, webbing)

// Grunt, should have middling stats overall.
/mob/living/basic/daemons/chosm_entities/vacant/drudge
	name = "drudge"
	desc = "A conjoined mass, this one twitches rythmically."
	icon = 'modular_iris/icons/mob/simple/chosms.dmi'
	icon_state = "drudge"
	icon_living = "drudge"
	icon_dead = "drudge_dead"
	gender = MALE
	maxHealth = 200
	health = 200
	melee_damage_lower = 20
	melee_damage_upper = 25
	obj_damage = 40
	speed = 0.8
	innate_actions = null //list()

/mob/living/basic/daemons/chosm_entities/vacant/drudge/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/web_walker)
	transform = transform.Scale(0.8, 0.8)


// Glass-Cannon charger. High damage, low health. High speed.
/mob/living/basic/daemons/chosm_entities/vacant/fool
	name = "fool"
	desc = "A hulking mass of absent, black void. This one has six swirling eyes and an incandescent core. It glides on six tiny legs."
	icon = 'modular_iris/icons/mob/simple/chosms.dmi'
	icon_state = "fool"
	icon_living = "fool"
	icon_dead = "fool_dead"
	gender = MALE
	maxHealth = 100
	health = 100
	pixel_y = -10
	melee_damage_lower = 40
	melee_damage_upper = 45
	obj_damage = 50
	speed = 0.4
	innate_actions = list(
	/datum/action/cooldown/mob_cooldown/charge/basic_charge/chosm_charge) // While I would like to add more pizazz to this maybe in the future, for now this is fine as just a basic charge.

/mob/living/basic/daemons/chosm_entities/vacant/fool/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/web_walker)
	transform = transform.Scale(0.9, 0.9)



// Nexus tender, Ranged Unit with good wound ability. Low damage with middling health.
/mob/living/basic/daemons/chosm_entities/vacant/scion
	name = "scion"
	desc = "A many limbed bulbous mass of absent, black void. This one is brimming with malfeasant iridescent energy and several gland-like projectors."
	icon = 'modular_iris/icons/mob/simple/chosms.dmi'
	icon_state = "scion"
	icon_living = "scion"
	icon_dead = "scion_dead"
	gender = FEMALE
	maxHealth = 150
	health = 150
	melee_damage_lower = 15
	melee_damage_upper = 20
	wound_bonus = 25
	exposed_wound_bonus = 50
	web_speed = 0.25
	sharpness = SHARP_EDGED
	sight = SEE_TURFS // Has Meson vision, basically.
	obj_damage = 60 // Highest Object damage because they need to clear room for the Nexus.
	speed = 1 // Pretty bad speed stat, they shouldn't be moving away from the Nexus anyways.
	innate_actions = list(
	/datum/action/cooldown/spell/pointed/projectile/chosmhook,
	/datum/action/cooldown/spell/pointed/projectile/chosm_spit,
	/datum/action/cooldown/mob_cooldown/lay_membrane/create_cyst,



	)

/mob/living/basic/daemons/chosm_entities/vacant/scion/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wall_tearer) // To spread the Nexus.
	AddElement(/datum/element/web_walker)
	transform = transform.Scale(0.8, 0.8)
