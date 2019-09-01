# TTT2 - Trouble in Terrorist Town 2 (Advanced Update)
[![Steam Subscriptions](https://img.shields.io/steam/subscriptions/1357204556)](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556) 
[![Steam Downloads](https://img.shields.io/steam/downloads/1357204556?label=Workshop%20downloads)](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556) 
[![Discord](https://img.shields.io/discord/442107660955942932)](https://discord.gg/9njYXGY)  

TTT2 is an updated version of the TTT gamemode for [Garry's Mod](https://gmod.facepunch.com/).

Find [TTT2 on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556)

**This is still a beta version. Bugs are expected and the documentation will follow as soon as possible. [Please report bugs and suggestions here](https://github.com/Alf21/TTT2/issues)!**  
  
* Discord: [https://discord.gg/9njYXGY](https://discord.gg/9njYXGY)  
* Source: [https://github.com/Alf21/TTT2](https://github.com/Alf21/TTT2)  
* Wiki: [https://github.com/Alf21/TTT2/wiki](https://github.com/Alf21/TTT2/wiki)
* Designguidelines: [https://github.com/Alf21/TTT2/blob/master/DESIGNGUIDELINES.md](https://github.com/Alf21/TTT2/blob/master/DESIGNGUIDELINES.md)
* GLua Beautifier: [https://gist.github.com/Alf21/e86601521f67fcbb88ddc34bfa778727](https://gist.github.com/Alf21/e86601521f67fcbb88ddc34bfa778727)
  
## MOTIVATION

TTT2 was the next logical step after TTT was such a massive success. It is a spiritual successor to this classic gamemode by Bad King Urgrain, which aims to introduce many new features, to fix old bugs and to lift the user interface into a modern era.  

## ADDONS

We know that TTT lives from its huge community and all its great addons. Because of this, **compatibility** is one of the highest priorities. Almost every item that works with TTT also works well with TTT2. There are a few minor exceptions though. Addons that modify the HUD, eg. Octagonal HUD, will not work with TTT2. If you plan on creating a new HUD for TTT2, you have to use the way more powerful HUD system from TTT2. Additionally addons that rely on roles may not work as intended with the newly added roles.  
  
Check out [this workshop list](https://steamcommunity.com/sharedfiles/filedetails/?id=1584725582) for addons that were reworked for TTT2.  
  
**Hint:** You do not need addons like “Better Equipment Menu”, “Drowning Indicator” or “TTT Sprint”, because features like these are included in TTT2 by default.  
  
## NEW GAMEMODES

There are a few new gamemodes based on TTT2. Click on these icons to open a list of needed addons to play these currently available official gamemodes.  
  
<a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1672031318"><img src="https://i.imgur.com/5JAsxin.png"></a> <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1672014264"><img src="https://i.imgur.com/qwEkCPb.png"></a>  

## SETUP

The setup is fairly easy. Just subscribe to TTT2 and the addons you want to use and get started. It’s recommended to use ULX to set it up ingame, there’s an [ULX addon for TTT2](https://steamcommunity.com/sharedfiles/filedetails/?id=1362430347). Commands for the weaponshop etc are found in [this wiki article](https://github.com/Alf21/TTT2/wiki/Commands).  
  
<br />
<br />

<p align="center">
<img src="https://i.imgur.com/pbZHURE.png">
</p>
  
Custom roles are a very big part of TTT2. It adds the possibility to introduce new roles to the game and to change the gameplay to everybodies preferences. All of this is achieved while maintaining an easy to access framework to create new roles and a high level of compatibility.  
  
[Check out this workshop list](https://steamcommunity.com/workshop/filedetails/?id=1357745995) for a overview of roles for TTT2.  
  
If you plan on creating your own custom role, check out this wiki article (TBA).  
  
<br />
<br />
  
<p align="center">
<img src="https://i.imgur.com/hYR2Qzg.png">
</p>
  
Inspired by TTT Fate and vastly improved for TTT Heroes, classes are another possibility to change the default gameplay. They add the possibility to have a custom property besides roles. Classes can contain whatever the author likes to introduce. From passive effects to traitor items to custom abilities like in TTT Heroes.  
  
However, this is still WIP. Right now you have to use [TTTC](https://steamcommunity.com/sharedfiles/filedetails/?id=1368035687) in order to play with custom classes.  
  
[Check out this workshop list](https://steamcommunity.com/workshop/filedetails/?id=1368039514) for a overview of classes for TTT2.  
  
If you plan on creating your own custom class, check out this wiki article.  
  
<br />
<br />
  
<p align="center">
<img src="https://i.imgur.com/0xNyZvG.png">
</p>
  
The user interface was long overdue and became a huge new project. It started with a simple icon swap and evolved into an complete overhaul. Besides a new default skin, called PureSkin, which was developed with continuous community feedback, is the new and powerful HUD management system, called HudSwitcher. It is now possible to change HUDs ingame from the F1-menu without changing or editing any files. Additionally the HudSwitcher allows for customizability. Also, it is now possible to move and resize every element, even setting a base color for your HUD is possible.  
  
<br />
<br />

## Currently Available Themes:

*   TTT Old Hud \[built-in\]: The classic look of TTT  
    
*   TTT Pure skin \[built-in\]: our new redesign of the TTT user interface. Modern and elegant!

  
If you plan on adding your own HUD design check out this wiki article \[TBA\]. The nice thing about the new system is, that you only have to extend the base class in order to have features like rescaling, positioning and on-the-fly hud switching.  
  
<br />
<br />
  
<p align="center">
<img src="https://i.imgur.com/3oOr9u6.png">
</p>
  
The passive item system was changed completely. Previously TTT limited the amount of passive items to 16. You might have noticed that after buying a passive item, it wasn’t buyable anymore but at the same time wasn’t transparent.  
  
<br /> 
<br />
  
<p align="center">
<img src="https://i.imgur.com/cuDeB2T.png">
</p>
  
Inspired by the ideas in TOT and BEM, we created a new shop system. The shop now has a search bar and a system to set favorites. You can even edit your shop when you’re dead by pressing C and selecting a role. Additionally features like an admin shop editor and a random shop (team or role basis) are implemented. The admin shop editor is a very powerful yet simple tool to edit team-based shops, link them together and set preferences to each item (team limitation, credit cost, …). But you don’t have to. You can always use the default settings.  
  
Additionally there is now a sidebar with items on the left side of the screen. Items can be registered to show up after purchase.  
  
<br />
<br />
  
<p align="center">
<img src="https://i.imgur.com/vErWhx9.png">
</p>
  
A main aspect of TTT2 is the new dev interface which allow for greater compatibility between different addons. Check them out in our wiki! \[TBA\]  
  
This is an open-source beta addon. You can report issues on GitHub and contribute to the source code!  
  
<br />

## THE HISTORY OF TTT2

The idea of TTT2 was born in early 2018 by Alf21. He was annoyed of all these different role mods (such as [TTT Totem](https://steamcommunity.com/sharedfiles/filedetails/?id=828347015) and [Town Of Terror](https://steamcommunity.com/sharedfiles/filedetails/?id=1092556189)) that wouldn’t work together. So he created a new role system and called it TTT2. Mineotopia was the first one to join his team. He is by himself a very active player and server admin and liked the concept. There was only one big problem: The icons were the definition of ugly. He offered to help with graphics and over time he became an active member of TTT2.  
  
The next big step was a project with two german youtubers, Dhalucard and PietSmiet. We created an exclusive addon for TTT2, called TTT Heroes. At this point, Tobse joined the team and the development rate increased. The idea of a completely revamped user interface was born!
