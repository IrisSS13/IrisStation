https://github.com/Monkestation/Monkestation2.0/pull/2199
https://github.com/Sea-of-Lost-Souls/Tannhauser-Gate/pull/549
## \<NTSL Coding>

MODULE ID: NTSL

### Description:

Allows people to change how comms work via NTSL
for example, adding in their job after their name

### TG Proc/File Changes:

- code\datums\chatmessage.dm -- Added a if(!speaker); return; due to NTSL code not passing a speaker when you use broadcast()
- code\datums\id_trim\jobs.dm -- Added the ACCESS_TCOMMS_ADMIN to the CE's trim

- code\game\say.dm -- Adds a </a> to the end of endspanpart, also a lot of stuff for AI tracking
- code\game\machinery\telecomms\telecomunications.dm -- Added some logging if there's a wrong filter path
- code\game\machinery\telecomms\broadcasting.dm -- Added a lvls var to the signal, needed for broadcast() on comms to work
- code\game\machinery\telecomms\machines\server.dm -- Added stuff to make the servers actually compile NTSL

- code\modules\research\techweb\all_nodes.dm -- Added the programming console thingy to the telecomms techweb

- icons\ui\achievements\achievements.dmi -- Added the achievement icon for loud and silent birb

### Included files that are not contained in this module:

- modular_skyrat\modules\telecomms_specialist\telecomms_specialist.dm
- tgui\packages\tgui\interfaces\NTSLCoding.js -- Interface for the traffic console

### Defines:

- code\__DEFINES\~tannhauser_defines\NTSL.dm

- code\__DEFINES\access.dm
- code\__DEFINES\logging.dm -- Added NTSL log stuff

### Credits:

- Altoids1 -- Original author in 2019
- JohnFulpWillard -- Doing a lot of stuff apparently
- Gboster-0 -- Porting to Tannhauser, fixes
- huusk -- Porting from Tannhauser to Iris, so very little actual work besides a few fixes.
