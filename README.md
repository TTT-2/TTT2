# TTT2 - Trouble in Terrorist Town 2

![CI](https://github.com/TTT-2/TTT2/workflows/CI/badge.svg?branch=master)
[![Steam Subscriptions](https://img.shields.io/steam/subscriptions/1357204556)](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556)
[![Steam Downloads](https://img.shields.io/steam/downloads/1357204556)](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556)
[![Discord](https://img.shields.io/discord/442107660955942932)](https://discord.gg/9njYXGY)

**This is still a beta version.**

Please make sure to check out [our FAQ page](https://docs.ttt2.neoxult.de/troubleshooting/)
and browse [existing issues](https://github.com/TTT-2/TTT2/issues)
before [reporting bugs](https://github.com/TTT-2/TTT2/issues/new?assignees=&labels=&projects=&template=bug_report.md)
or [suggestions](https://github.com/TTT-2/TTT2/issues/new?assignees=&labels=&projects=&template=feature_request.md)!

* Discord: [https://discord.gg/Npcbb4W](https://discord.gg/Npcbb4W)
* Design-Guidelines: [https://github.com/TTT-2/TTT2/blob/master/DESIGNGUIDELINES.md](https://github.com/TTT-2/TTT2/blob/master/DESIGNGUIDELINES.md)
* Documentation: [https://docs.ttt2.neoxult.de/](https://docs.ttt2.neoxult.de/)
* API-Documentation: [https://api-docs.ttt2.neoxult.de/](https://api-docs.ttt2.neoxult.de/)
* Steam Workshop: [https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556)

## MOTIVATION

TTT2 was the next logical step after TTT was such a massive success.
It is a spiritual successor to this classic gamemode by Bad King Urgrain.
Aiming to introduce new features, fix old bugs and modernize the user interface.

## ADDONS

We know that TTT lives from its huge community and all its great addons.
Because of this, **compatibility** is one of the highest priorities.
Almost every item that works with TTT also works with TTT2.
HUD and role related addons are the exceptions.

Additionally we have introduced a compatibility checker.
On server start it prints incompatible or outdated addons to the server console.
More on this in our documentation [here](https://docs.ttt2.neoxult.de/troubleshooting/#addon-checker).

TTT2 also features some additions which TTT needed addons for:

* overhauled equipment menu
* drowning indicator
* sprinting and stamina

## NEW GAMEMODES

There are a few new gamemodes based on TTT2.
Click on these icons to open the steam collection to these official gamemodes.

[![TTT2 Totem](https://i.imgur.com/5JAsxin.png)](https://steamcommunity.com/sharedfiles/filedetails/?id=1672031318)
[![TTT2 Fate](https://i.imgur.com/qwEkCPb.png)](https://steamcommunity.com/sharedfiles/filedetails/?id=1672014264)
[![TTT2 Heroes](https://i.imgur.com/WVuPmxP.png)](https://steamcommunity.com/sharedfiles/filedetails/?id=1737047642)

## SETUP

The setup is fairly easy. Just subscribe to TTT2 and the addons you want to use.

It’s recommended to use ULX to set it up ingame, there’s an [ULX addon for TTT2](https://steamcommunity.com/sharedfiles/filedetails/?id=1362430347).
Commands for the admin shop editor etc. are found in [this wiki article](https://docs.ttt2.neoxult.de/).

<p align="center">
    <img src="https://i.imgur.com/pbZHURE.png" alt="'Custom Role Support' Banner">
</p>

Custom roles are a very big part of TTT2.
They add the possibility to introduce new roles leading to a fresh gameplay experience.
All of this is achieved while maintaining an easy to access framework to create
new roles and a high level of compatibility.

[Check out this workshop list](https://steamcommunity.com/workshop/filedetails/?id=1737053146)
for a overview of roles for TTT2.

If you plan on creating your own custom role, check out [this wiki article](https://docs.ttt2.neoxult.de/features/roles/).

<p align="center">
    <img src="https://i.imgur.com/hYR2Qzg.png" alt="'New Class System' Banner">
</p>

Inspired by TTT Fate and vastly improved for TTT Heroes,
classes are another possibility to change the default gameplay.
They add the possibility to have a custom property besides roles.
Classes can contain whatever the author likes to introduce.
From passive effects to traitor items to custom abilities like in TTT Heroes.

You have to use the addon
[TTTC](https://steamcommunity.com/sharedfiles/filedetails/?id=1368035687)
in order to play with custom classes.

[Check out this workshop list](https://steamcommunity.com/workshop/filedetails/?id=1368039514)
for a overview of classes for TTT2.

If you plan on creating your own custom class, check out [this wiki article](https://docs.ttt2.neoxult.de/developers/content-creation/creating-a-class/).

<p align="center">
    <img src="https://i.imgur.com/0xNyZvG.png" alt="'Rethought UI System' Banner">
</p>

The user interface was long overdue and became a huge new project.
It started with a simple icon swap and evolved into an complete overhaul.
Besides a new default skin `PureSkin`,
which was developed with continuous community feedback,
is the new and powerful HUD management system `HudSwitcher`.
It is now possible to change HUDs ingame from the F1-menu without changing or editing
any files.

Additionally the HudSwitcher allows for customizability:
moving and resizing every element, setting a base color and more is possible.

## Currently Available Themes

* TTT Old Hud \[built-in\]:
The classic look of TTT
* TTT Pure skin \[built-in\]:
Our redesign of the TTT user interface. Modern and elegant!
* TTT Octagonal Hud: [\[Download here\]](https://steamcommunity.com/sharedfiles/filedetails/?id=1795267605):
A reinterpretation of the beloved HUD addon

If you plan on adding your own HUD design check out
[this wiki article](https://docs.ttt2.neoxult.de/developers/content-creation/creating-a-hud-theme/).
The nice thing about the new system is,
that you only have to extend the base class in order to have features like
rescaling, positioning and on-the-fly hud switching.
Besides relying on these features for a new hud-design,
addons can use this system for an easy UI integration too.

<p align="center">
    <img src="https://i.imgur.com/3oOr9u6.png" alt="'New Item System' Banner">
</p>

The passive item system was changed completely.
Previously TTT limited the amount of passive items to 16.
In TTT2 we have not only removed this limitation but additionally allow
perks and status effects to be displayed in a sidebar.
Learn [how to add this feature to your addon](https://docs.ttt2.neoxult.de/developers/content-creation/creating-a-hud-theme/)

<p align="center">
    <img src="https://i.imgur.com/cuDeB2T.png" alt="'Advanced Shop System' Banner">
</p>

Inspired by the ideas in TOT and BEM, we created a new shop system.
The shop now has a search bar and a system to set favorites.
You can even edit your shop when you're dead by pressing C and selecting a role.
Additionally features like an admin shop editor and a random shop are implemented.
The admin shop editor is a very powerful yet simple tool to edit team-based shops,
link them together and set preferences to each item.
Learn [here](https://docs.ttt2.neoxult.de/server-owners/manual-install/) how to setup
and install a dedicated server.

<p align="center">
    <img src="https://i.imgur.com/vErWhx9.png" alt="'Development' banner">
</p>

A main aspect of TTT2 is the new dev interface which allows for greater
compatibility between different addons.
Check them out [in our documentation](https://docs.ttt2.neoxult.de/)!
[This design guideline](https://docs.ttt2.neoxult.de/developers/content-creation/icon-and-design-guideline/)
helps you with creating custom addons visually fitting seamless into TTT2.
A WIP autogenerated API-Docu is available as well [here](https://api-docs.ttt2.neoxult.de/).

## THE HISTORY OF TTT2

The idea of TTT2 was born in early 2018 by Alf21.
He was annoyed of all these different role mods
(such as [TTT Totem](https://steamcommunity.com/sharedfiles/filedetails/?id=828347015)
and [Town Of Terror](https://steamcommunity.com/sharedfiles/filedetails/?id=1092556189))
that wouldn’t work together.
So he created a new role system and called it TTT2.

Mineotopia was the first one to join his team.
He is by himself a very active player and server admin and liked the concept.
There was only one big problem: The icons were the definition of ugly.
He offered to help with graphics and over time he became an active member of TTT2.

The next big step was a project with two german youtubers, Dhalucard and PietSmiet.
We created an exclusive addon for TTT2, called TTT Heroes.
At this point, Saibotk joined the team and the development rate increased.
The idea of a completely revamped user interface was born!

## Credits

Credit to [rubiez](https://sketchfab.com/rubiez) for creating the DNA Scanner model.
It was ported to source engine and animated.
The original can be found [here](https://sketchfab.com/3d-models/flir-e5-c5c37e8cd607424fbdb06c7ae2924924)
It is licensed under the [CC BY 4.0 license](https://creativecommons.org/licenses/by/4.0/).
