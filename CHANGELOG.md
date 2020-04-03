# Changelog

All notable changes to TTT2 will be documented here. Inspired by [keep a changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased

### Fixed

- Fixed TTT2 files running when the gamemode is not `terrortown`
- Fixed double sprinting issues
- Fixed Polish translation
- Fixed convar saving by removing terrortown settings

## v0.6.3b (2020-03-05)

### New

- Added a Polish translation (Thanks @Wukerr)
- Added fallback icons for equipment

### Fixed

- Fix `body_found` for bots
- Fix NWVarSyncing when using `TTT2NET:Set()`

## v0.6.2b (2020-03-01)

### Fixed

- Increased the maximum number of roles that can be used. (Fixes weird role issues with many roles installed)

## v0.6.1b (2020-02-17)

### Fixed

- Fixed a bug with the spawn wave interval

## v0.6.b (2020-02-16)

### New

- Added new weapon switch system
  - Players can now manually pick up focused weapons
  - If the slot is blocked, the current weapon is automatically dropped
  - Added new convar to prevent auto pickup: `ttt_weapon_autopickup (default: 1)`
- Added new targetID system
  - Looking at entities shows now more detailed ans structured info
  - Integrated into the new weapon switch system
  - Supports all TTT entities by default
  - Supports doors
  - Added a new hook to add targetID support to custom entities: `TTTRenderEntityInfo`
- Added the outline module for better performance
- `TTT2DropAmmo` hook to prevent/change the ammo drop of a weapon
- Added new HUD element: the eventpopup
- Added a new `TTT2PlayerReady` hook that is called once a player is ingame and can move around
- Added new removable decals
- Added a new default loading screen
- Added new convar to allow Enhanced Player Model Selector to overwrite TTT2 models: `ttt_enforce_playermodel (default: 1)`
- Added new hooks to jam the chat
- Allow any key double tap sprint
- Regenerate sprint stamina after a delay if exhausted
- Moved voice bindings to the TTT2 binding system (F1 menu)
- Added new voice and text chat hooks to prevent the usage in certain situations
- Added new client only convar (F1->Gameplay->Hold to aim) to change to a "hold rightclick to aim" mode
- Added a new language file system for addons, language files have to be in `lua/lang/<the_language>/<addon>.lua`
- New network data system including network data tables to better manage state updates on different clients

### Improved

- Microoptimization to improve code performance
- Improved the icon rendering for the pure_skin HUD
- Improved multi line text rendering in the MSTACK
- Improved role color handling
- Improved language (german, english, russian)
- Improved traitor buttons
  - By default only players in the traitor team can use them
  - Each role has a convar to enable traitor button usage for them - yes, innocents can use traitor buttons if you want to
  - There is an admin mode to edit each button individually
  - Uses the new targetID
- Improved damage indicator overlay with customizability in the F1 settings
- Improved hud help font
- Added a new flag to items to hide them from the bodysearch panel
- Moved missing hardcoded texts to language files

### Fixed

- Fixed a bug with baserole initialization
- Small other bugfixes
- Added legacy supported for limited items
- Fixed C4 defuse for non-traitor roles
- Fixed radio, works now for all roles
- Restricted huds are hidden in HUD Switcher
- Fixed ragdoll skins (hairstyles, outfits, ...)
- Prevent give_equipment timer to block the shop in the next round
- Fix sprint consuming stamina when there is no move input
- Fix confirmation of players with no team
- Fix voice still sending after death
- Fix persisting the reset of a bind

## v0.5.7b (2019-10-07)

### New

- New loadout Give/Remove functions to cleanup role code and fix item race conditions
  - Roles now always get their equipment on time
  - On role changes, old equipment gets removed first
- New armor system
  - Armor is now displayed in the HUD
  - Previously it was a simple stacking percentual calculation, which got stupid with multiple armor effects. Three times armor items with 70% damage each resulted in 34% damage received
  - The new system has an internal armor value that is displayed in the HUD
  - It works basically the same as the vanilla system, only the stacking is a bit different
  - Reaching an armor value of 50 (by default) increases its strength
  - Armor depletes over time
- Allowed items to be bought multiple times, if .limited is set to false

### Improved

- Dynamic loading of role icons
- Improved performance slightly
- Improved code consistency
- Caching role icons in ROLE.iconMaterial to prevent recreation of icon materials
- Improved bindings menu and added language support
- Improved SQL module
- Improved radar icon
- Made parameterized overheadicon function callable
- Improved code readability by refactoring huge parts

### Fixed

- Adjusted Role Init system
  - fixes unavailable shops for roles, that usually have one
- Team confirmation ConVar issue in network-syncing
- Reset radar timer on item remove, fixes problems with role changes
- Fixed an exploitable vulnerability

## v0.5.6b-h1 (2019-09-06)

### Fixed

- Traitor shop bug (caused by the september'19 GMod update)
- ShopEditor bugs and added a response for non-admins
- Glitching head icons

## v0.5.6b (2019-09-03)

### New

- Marks module
- New sprint and stamina hooks for add-ons
- Added a documentation of TTT2
- Added GetColumns function for the scoreboard

### Improved

- Restrict HUD element movement when element is not rendered
- Sidebar icons now turn black if the hudcolor is too bright
- Binding functions are no longer called when in chat or in console
- Improved the functionality of the binding system
- Improved rendering of overhead role icons
- Improved equipment searching
- Improved the project structure
- Improved shadow color for dark texts
- Some small performance improvements
- Removed some unnecessary debug messages
- Updated the TTT2 .fgd file

### Fixed

- Fixed the shop bug that occured since the new GMod update
- Fixed search sometimes not working
- Fixed a shop reroll bug
- Fixed GetAvoidDetective compatibility
- Fixel two cl_radio errors
- Fixed animation names
- Fixed wrong karma print
- Fixed a language module bug
- Fixed an inconsistency in TellTraitorsAboutTraitors function
- Fixed the empty weaponswitch bug on first spawn
- Fixed an error in the shadow rendering of a font
- Small bugfixes

## v0.5.5b (2019-07-07)

### New

- Added convars to hide scoreboard badges
- A small text that explains the spectator mode
- Weapon pickup notifications are now moved to the new HUD system
- Weapon pickup notifications support now pure_skin
- New shadowed text rendering with font mipmapping

### Improved

- Refactored the code to move all language strings into the language files

### Fixed

- Fixed the reroll per buy bug
- Fixed HUD switcher bug, now infinite amounts of HUDs are supported
- Fixed the outline border of the sidebar beeing wrong
- Fixed problem with the element restriction

## v0.5.4b (2019-06-18)

### New

- Added a noTeam indicator to the HUD
- intriduced a new drowned death symbol
- `ttt2_crowbar_shove_delay` is now used to set the crowbar attack delay
- introduced a status system alongside the perk system

### Improved

- Included LeBroomer in the TTT2 logo

### Fixed

- Fixed a problem with colors (seen with sidekick death confirms)
- Fixed the team indicator when in spectator mode
- Credits now can be transfered to everyone, this fixes a bug with the spy

## v0.5.3b (2019-05-09)

### New

- Added a **Reroll System** for the **Random Shop**
- Rerolls can be done in the Traitor Shop similar to the credit transferring
- Various parameters in the **ShopEditor** are possible (reroll, cost, reroll per buy)
- Added the reroll possibility for the **Team Random Shop** (very funny)

### Improved

- Added a separate slot for class items
- Added help text to the **"Not Alive"-Shop**
- Minor design tweaks

### Fixed

- Fixed critical crash issue (ty to @nick)

## v0.5.2b (2019-04-32)

### New

- Added spectator indicator in the Miniscoreboard
- Added icons with higher resolution (native 512x512)
- Added Heroes badge
- Added HUD documentation
- Added some more hooks to modify TTT2 externally

### Improved

- Improved the project structure / **Code refactoring**
- Improved HUD sidebar of items / perks
- Improved HUD loading
- Improved the sql library
- Improved item handling and item converting
- **Improved performance / performance optimization**

### Fixed

- Fixed SetModel bugs
- Fixed some model-selector bugs
- Fixed a sprint bug
- Fixed some ConVars async bugs
- Fixed some shopeditor bugs
- Fixed an HUD scaling bug
- Fixed old_ttt HUD
- Fixed border's alpha value
- Fixed confirmed player ordering in the Miniscoreboard
- **Fixed critical TTT2 bug**
- **Fixed a crash that randomly happens in the normal TTT**
- Fixed PS2 incompatibility
- Fixed spectator bug with Roundtime and Haste Mode
- Fixed many small HUD bugs

## v0.5.1b (2019-03-05)

### Improved

- Improved the binding library and extended the functions

### Fixed

- Fixed target reset bug
- Fixed / Adjusted hud element resize handling
- Fixed strange weapon switch error
- Fixed critical model reset bug
- Fixed hudelements borders, childs will now extend the border of their parents
- Fixed mstack shadowed text alpha fadeout
- Fixed / Adjusted scaling calculations
- Fixed render order
- Fixed "player has no SteamID64" bug

## v0.5.0b (2019-03-03)

### New

- Added new **HUD** system
  - Added **HUDSwitcher** (`F1 → Settings → HUDSwitcher`)
  - Added **HUDEditor** (`F1 → Settings → HUDSwitcher`)
  - Added old TTT HUD
  - Added **new** PureSkin HUD, an improved and fully integrated new HUD
  - Added a Miniscoreboard / Confirm view at the top
    - Added support for SubRole informations in the player info (eg. used by TTT Heroes)
    - Added a team icon to the top
    - Redesign of all other HUD elements...
- Added possibility to give every player his **own random shop**
- Added **sprint** to TTT2
- Added a **drowning indicator** into TTT2
- Added possibility to toggle auto afk
- Added possibility to modify the time a player can dive
- Added parameter to the bindings to detect if a player released a key
- Added possibility to switch between team-synced and individual random shops
- Added some nice **badges** to the scoreboard
- Added a sql library for saving and loading specific elements (used by the HUD system)
- Added and fixed Bulls draw lib
- Added an improved player-target add-on

### Changed

- Changed convar `ttt2_confirm_killlist` to default `1`
- Improved the changelog (as you can see :D)
- Improved Workshop page :)
- Reworked **F1 menu**
- Reworked the **slot system** (by LeBroomer)
  - Amount of carriable weapons are customizable
  - Weapons won't block slots anymore automatically
  - Slot positions are generated from weapon types
- Reworked the **ROLES** system
  - Roles can now be created like weapons utilizing the new roles lua module
  - They can also inherit from other roles
- Improved the MSTACK to also support messages with images
- Confirming a player will now display an imaged message in the message stack

### Fixed

- Fixed TTT2 binding system
- Fixed Ammo pickup
- Fixed karma issue with detective
- Fixed DNA Scanner bug with the radar
- Fixed loading issue in the items module
- Fixed critical bug in the process of saving the items data
- Fixed the Sidekick color in corpses
- Fixed bug that detective were not able to transfer credits
- Fixed kill-list confirm role syncing bug
- Fixed crosshair reset bug
- Fixed confirm button on corpse search still showing after the corpse was confirmed or when a player was spectating
- Fixed MSTACK:WrapText containing a ' ' in its first row
- Fixed shop item information not readable when the panel is too small -> added a scrollbar
- Fixed shop item being displayed as unbuyable when the items price is set to 0 credits
- Other small bugfixes

## v0.4.0b

- ShopEditor
  - added `.notBuyable` param to hide item in the shops
  - added `.globalLimited` and `.teamLimited` params to limit equipment

- added **new shop** (by tkindanight)
  - you can toggle the shop everytime (your role doesn't matter)
  - the shop will update in real time

- added new icons
- added warming up for **randomness** to make things happen... yea... random
- added auto-converter for old items

- decreased speed modification lags
- improved performance
- implemented **new item system!** TTT2 now supports more than 16 passive items!
- huge amount of fixes

## v0.3.9b

- reimplemented all these nice unaccepted PullRequest for TTT on GitHub:

  - **Custom Crosshairs** (`F1 → Settings`): [gmod-PR](https://github.com/Facepunch/garrysmod/pull/1376/) by nubpro
  - Performance improvements with the help of [gmod-PR](https://github.com/Facepunch/garrysmod/pull/1287) by markusmarkusz and Alf21

- added possibility to use **random shops!** (`ShopEditor → Options`)
- balanced karma system (Roles that are aware of their teammates can't earn karma anymore. This will lower teamkilling)

## v0.3.8.3b

- ammoboxes will store the correct amount of ammo now
- connected **radio commands** with **scoreboard #tagging** [ref](https://github.com/Exho1/TTT-ScoreboardTagging/blob/master/lua/client/ttt_scoreboardradiocmd.lua)

## v0.3.8.2b

- added **russian translation** (by Satton2)
- added `.minPlayers` indicator for the shop

- replaced `.globalLimited` param with `.limited` param to toggle whether an item is just one time per round buyable for each player

## v0.3.8.1b

- fixed credit issue in ShopEditor (all Data will load and save correct now)
- fixed item credits and minPlayers issue
- fixed radar, disguiser and armor issue in ItemEditor
- fixed shop syncing issue with ShopEditor

- small performance improvements
- cleaned up some useless functions
- removed `ALL_WEAPONS` table (SWEP will cache the initialized data now in it's own table / entity data)
- some function renaming

## v0.3.8b

- added new TTT2 Logo
- added ShopEditor missing icons (by Mineotopia)

- **reworked weaponshop → ShopEditor**
- changed file based shopsystem into sql

## v0.3.7.4b

- fixed playermodel reset bug (+ compatibility with PointShop 1)
- fixed external HUD support
- fixed credits bug
- fixed detective hat bug
- fixed selection and jester selection bug

## v0.3.7.3b

- reworked the **selection system** (balancing and bugfixes)

- fixed playermodel issue
- fixed toggling role issue
- fixed loadout doubling issue

## v0.3.7.2b

- reworked the **credit system** (Thanks to Nick!)
- added possibility to override the init.lua and cl_init.lua file in TTT2

- fixed server errors in combination with TTT Totem (now, TTT2 will just not work)
- fixed ragdoll collision server crash (issue is still in the normal TTT)

## v0.3.7.1b

- added possibility to disable roundend if a player is reviving
- added own Item Info functions
- added debugging function
- added TEAM param `.alone`
- added possibility to set the cost (credits) for any equipment
- added `Player:RemoveEquipmentItem(id)` and `Player:RemoveItem(id)` / `Player:RemoveBought(id)`
- added possibility to change velocity with hook `TTT2ModifyRagdollVelocity`

- improved external icon addon support
- improved binding system

- fixed loadout bug
- fixed loadout item reset bug
- fixed respawn loadout issue
- fixed bug that items were removed on changing the role
- fixed search icon display issue
- fixed model reset bug on changing role
- fixed `Player:GiveItem(...)` bug used on round start
- fixed dete glasses bug
- fixed rare corpse bug
- fixed Disguiser
- Some more small fixes

## v0.3.7b

- added hook `TTT2ToggleRole`
- added `GetActiveRoles()`

- fixed TTT spec label issue

- renamed hook `TTT_UseCustomPlayerModels` into `TTTUseCustomPlayerModels`
- removed `Player:SetSubRole()` and `Player:SetBaseRole()`

## v0.3.6b

- new **networking system**

- added **gs_crazyphysics detector**
- added RoleVote support
- added new multilayed icons (+ multilayer system)
- added credits
- added changes window
- added **detection for registered incompatible add-ons**
- added autoslay support

- karma system improvement
- huge amount of bugfixes

## v0.3.5.8b

- **selection system update**

- added different ConVars
- added possibility to force a role in the next roleselection

- bugfixes

## v0.3.5.7b

- **code optimization**

- added different CVars

- fixed loadout and model issue on changing the role
- bugfixes

- removed `PLAYER:UpdateRole()` function and hook `TTT2RoleTypeSet`

## v0.3.5.6b

- **many fixes**
- enabled picking up grenades in prep time
- roundend scoreboard fix
- disabled useless prints that have spammed the console
