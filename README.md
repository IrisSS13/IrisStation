## Iris Station 13 (/tg/station Downstream)

[![CI Suite](https://github.com/IrisSS13/IrisStation/workflows/CI%20Suite/badge.svg)](https://github.com/IrisSS13/IrisStation/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/IrisSS13/IrisStation.svg)](https://isitmaintained.com/project/IrisSS13/IrisStation "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/IrisSS13/IrisStation.svg)](https://isitmaintained.com/project/IrisSS13/IrisStation "Average time to resolve an issue")
![Coverage](https://img.shields.io/codecov/c/github/IrisSS13/IrisStation)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website                 | Link                                                                                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Git / GitHub cheatsheet | [https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833](https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833) |
| Guide to Modularization | [./modular_nova/readme.md](./modular_nova/readme.md)                                                                                   |
| Guide to Mirroring      | [./modular_nova/mirroring_guide.md](./modular_nova/mirroring_guide.md)                                                                 |
| Code                    | [https://github.com/NovaSector/NovaSector](https://github.com/NovaSector/NovaSector)                                                   |
| Wiki                    | [https://wiki.irisstation.lol/](https://wiki.irisstation.lol/)                                                                         |
| Codedocs                | [https://NovaSector.github.io/NovaSector/](https://NovaSector.github.io/NovaSector/)                                                   |
| Iris Station's Discord  | [https://discord.gg/azps5ydx2F](https://discord.gg/azps5ydx2F)                                                                         |
| Coderbus Discord        | [https://discord.gg/Vh8TJp9](https://discord.gg/Vh8TJp9)                                                                               |

This is Iris' downstream fork of Nova Sector, which in turn is a downstream fork of /tg/station created in BYOND.

There are NSFW sprites in the codebase, but all NSFW code has been removed. Sprites will be removed when possible. This is a SFW fork.

Space Station 13 is a paranoia-laden round-based roleplaying game set against the backdrop of a nonsensical, metal death trap masquerading as a space station, with charming spritework designed to represent the sci-fi setting and its dangerous undertones. Have fun, and survive!

## Important note - TEST YOUR PULL REQUESTS

You are responsible for the testing of your content and providing proof of such in your pull request. You should not mark a pull request ready for review until you have actually tested it. If you require a separate client for testing, you can use a guest account by logging out of BYOND and connecting to your test server. Test merges are not for bug finding, they are for stress tests where local testing simply doesn't allow for this.

## DEVELOPMENT FLOWCHART

![image](https://i.imgur.com/aJnE4WT.png)

[Modularisation Guide](./modular_nova/readme.md)

## DOWNLOADING

[Downloading](.github/guides/DOWNLOADING.md)

[Running on the server](.github/guides/RUNNING_A_SERVER.md)

[Maps and Away Missions](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## Compilation

Find `BUILD.bat` here in the root folder of tgstation, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Getting started

For contribution guidelines refer to the
[Guides for Contributors](.github/CONTRIBUTING.md).

For getting started (dev env, compilation) see the HackMD document [here](https://hackmd.io/@tgstation/HJ8OdjNBc#tgstation-Development-Guide).

For overall design documentation see [HackMD](https://hackmd.io/@tgstation).

For TG lore, [see Common Core](https://github.com/tgstation/common_core). Iris doesn't have official lore at this time, and is subject to changes.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/\_\_DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
