// This file contains all of the "static" define strings that tie to a trait.
// WARNING: The sections here actually matter in this file as it's tested by CI. Please do not toy with the sections."

// BEGIN TRAIT DEFINES

/*
 *Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
 */

//mob traits

//Makes you illiterate while not wearing glasses, part of https://github.com/lizardqueenlexi/orbstation/pull/254
#define TRAIT_FARSIGHT "farsighted"

//HANDEDNESS_QUIRK
#define TRAIT_HANDEDNESS "handedness"
#define TRAIT_HANDEDNESS_LEFT "handedness_left"

//Trait sources

//Special trait source for illiteracy granted by farsightedness, part of https://github.com/lizardqueenlexi/orbstation/pull/254
#define FARSIGHT_TRAIT "farsighted_trait"

//Items

//Helps users examine items with custom text, part of https://github.com/DopplerShift13/DopplerShift/pull/345
#define TRAIT_WORN_EXAMINE "worn_examine"
