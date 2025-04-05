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

//Stowaway quirk taken from https://github.com/Monkestation/Monkestation2.0/pull/4642
#define TRAIT_STOWAWAY "stowaway"

//Trait sources

//Special trait source for illiteracy granted by farsightedness, part of https://github.com/lizardqueenlexi/orbstation/pull/254
#define FARSIGHT_TRAIT "farsighted_trait"

//Items

//Helps users examine items with custom text, part of https://github.com/DopplerShift13/DopplerShift/pull/345
#define TRAIT_WORN_EXAMINE "worn_examine"
