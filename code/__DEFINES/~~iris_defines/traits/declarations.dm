// This file contains all of the "static" define strings that tie to a trait.
// WARNING: The sections here actually matter in this file as it's tested by CI. Please do not toy with the sections."

// BEGIN TRAIT DEFINES

/*
 *Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
 */

//mob traits

//Part of https://github.com/Monkestation/Monkestation2.0/pull/5623
#define TRAIT_CAFFEINE_DEPENDENCE "caffeine_dependence"

//COLORBLINDNESS_QUIRK, part of https://github.com/MrMelbert/MapleStationCode/pull/632
#define COLORBLINDNESS_PROTANOPIA "Protanopia (Red-Green)"
#define COLORBLINDNESS_DEUTERANOPIA "Deuteranopia (Red-Green)"
#define COLORBLINDNESS_TRITANOPIA "Tritanopia (Blue-Yellow)"

//Makes you illiterate while not wearing glasses, part of https://github.com/lizardqueenlexi/orbstation/pull/254
#define TRAIT_FARSIGHT "farsighted"

//HANDEDNESS_QUIRK
#define TRAIT_HANDEDNESS "handedness"
#define TRAIT_HANDEDNESS_LEFT "handedness_left"

//Trait for the Extra-Sensory Paranoia quirk, part of https://github.com/Monkestation/Monkestation2.0/pull/313
#define TRAIT_PARANOIA "paranoia"

//SALT_VULNERABILITY_QUIRK
#define TRAIT_SALT_VULNERABILITY "salt_vulnerability"

//SOMATIC_VOLATILITY_QUIRK
#define TRAIT_SOMATIC_VOLATILITY "somatic_volatility"

//Stowaway quirk taken from https://github.com/Monkestation/Monkestation2.0/pull/4642
#define TRAIT_STOWAWAY "stowaway"

///Mob hates eating without a table, goofkitchen
#define TRAIT_TABLE_EATING_ENJOYER "table_eating_enjoyer"

///Mob isn't burnt when injecting/ingesting sulfuric acid
#define TRAIT_ACIDBLOOD "acid_blood"

/// Gives us medium night vision, same as thermal but without seeing through walls
#define TRAIT_MEDIUM_NIGHT_VISION "medium_night_vision"

//Trait sources

//Special trait source for illiteracy granted by farsightedness, part of https://github.com/lizardqueenlexi/orbstation/pull/254
#define FARSIGHT_TRAIT "farsighted_trait"

//Items

//Helps users examine items with custom text, part of https://github.com/DopplerShift13/DopplerShift/pull/345
#define TRAIT_WORN_EXAMINE "worn_examine"

// /obj/item
/// Applied to a satchel that is being worn on the belt.
#define TRAIT_BELT_SATCHEL "belt_satchel"
