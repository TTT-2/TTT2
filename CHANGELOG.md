# Changelog

All notable changes to TTT2 will be documented here. Inspired by [keep a changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased

### Fixed

- Inheriting from the same base using the classbuilder in different folders did not work

## [v0.8.0b](https://github.com/TTT-2/TTT2/tree/v0.8.0b) (2021-02-06)

### Added

- Added a new vgui system
  - Introduced new development interfaces to easily create menues and settings for addons
- Introduced a global scale factor based on screen resolution to scale HUD elements accordingly
- Added automatical scale factor change on resolution change that works even if the resolution was changed while TTT2 wasn't loaded
- Added `drawsc` library featuring scalable draw functions
- Added Drag&Drop role layering VGUI, accessible with the console command `ttt2_edit_rolelayering`
- Added a new event system
  - Added a cancelable hook `TTT2OnTriggeredEvent` that is called once an event is about to be added
  - Added a hook `TTT2AddedEvent` that is called after an event was added
- Added `orm` library to simplify database access
- Added French translation (by @MisterClems)
- Added a few table module functions
- Added a few LANG module functions
- Added a new classbuilder that can be used to create classes from files
- Added a `targetid` library, that can be used to draw TargetIDs for entities
- Added a hook `TTT2CanTransferCredits` that is called before credits are transferred
- Credits can now be transferred across teams and from roles whom the recipient does not know

### Changed

- The F1 menu is completely overhauled
- Cleaned up language files, they are now identical on a line by line comparison
- Inverted some convars to have a uniform "Enable feature X", not a mixture of enable and disable
- TargetID text is now scaled with the global scale factor
- Cleaned up draw function files
- Changed several functions' scopes
- Added minimal documentation to every datastructure
- Removed C4 defuse restriction for teammates
- Moved role specific score variables into the role base
- Changed the language identifiers to generic english names
- moved functions from sh_util into their respective library files
- Moved functions from sh_util into their respective library files
- Updated the list of troublesome addons used by the addonchecker
- Updated Simplified Chinese localization (by @TheOnly8Z)
- Updated Italian localization (by @ThePlatynumGhost)
- Updated English localization (by @Satton2)
- Updated Russian localization (by @scientistnt and @Satton2)
- Updated German translation (by @Creyox)

### Fixed

- Fixed weapon pickup bug, where weapons would not get dropped but stayed in inventory
- Fixed a roleselection bug, where forced roles would not be deducted from the available roles
- Fixed a credit award bug, where detectives would receive a pointless notification about being awarded with 0 credits
- Fixed a karma bug, where damage would still be reduced even though the karma system was disabled
- Fixed a roleselection bug, where invalid layers led to skipping the next layer too
- Fixed Magneto Stick ragdoll pinning instructions not showing for innocents when `ttt_ragdoll_pinning_innocents` is enabled
- Fixed a bug where the targetID info broke if the pickup key is unbound

## [v0.7.4b](https://github.com/TTT-2/TTT2/tree/v0.7.4b) (2020-09-28)

### Added

- Added ConVar to toggle double-click buying
- Added Japanese translation (by @Westoon)
- Added `table.ExtractRandomEntry(tbl, filterFn)` function
- Added a team indicator in front of every name in the scoreboard (just known teams will be displayed)
- Added a hook `TTT2ModifyCorpseCallRadarRecipients` that is called once "call detective" is pressed

### Changed

- The weapon pickup system has been improved to increase stability and remove edge cases in temporary weapon teleportation
- Updated Spanish translation (by @DennisWolfgang)
- Fixed subrole selection (issues happened with max_roles enabled, etc.). Subroles are now directly connected with their related baseroles

### Fixed

- Fixed foregoing fetch fix
- Fixed HUD savingKeys variable not being unique across all HUDs
- Fixed drawing web images, seamless web images and avatar images
- Fixed correctly saving setting a bind to NONE, while a default is defined
- Fixed a weapon pickup targetID bug where the +use key was displayed even though pickup has its own keybind
- Fixed DNA scanner crash if using an old/different weapon base
- Fixed rare initialization bug in the speed calculation when joining as a spectator

## [v0.7.3b](https://github.com/TTT-2/TTT2/tree/v0.7.3b) (2020-08-09)

### Added

- Added a new custom file loader that loads lua files from `lua/terrortown/autorun/`
  - it basically works the same as the native file loader
  - there are three subfolders: `client`, `server` and `shared`
  - the files inside this folder are loaded after all TTT2 gamemode files and library extensions are loaded
- Added Spanish version for base addon (by @Tekiad and @DennisWolfgang)
- Added Chinese Simplified translation (by @TheOnly8Z)
- Added double-click buying
- Added a default avatar for players and an avatar for bots

### Changed

- Roles are now only getting synced to clients if the role is known, not just the body being confirmed
- Airborne players can no longer replenish stamina
- Detective overhead icon is now shown to innocents and traitors
- moved language files from `lua/lang/` to `lua/terrortown/lang`
- Stopped teleporting players to players they're not spectating if they press the "duck"-Key while roaming
- Moved shop's equipment list generation into a coroutine
- Removed TTT2PlayerAuthedCacheReady hook
- Internal changes to the b-draw library for fetching avatars

### Fixed

- Fixed death handling spawning multiple corpses when killed multiple times in the same frame
- Radar now shows bombs again, that do not have the team property set
- Fix HUDManager not saving forcedHUD and defaultHUD values
- Fixed wrong parameter default in `EPOP:AddMessage` documentation
- Fixed shop switching language issue
- Fixed shop refresh activated even not buyable equipments
- Fixed wrong shop view displayed as forced spectator

## [v0.7.2b](https://github.com/TTT-2/TTT2/tree/v0.7.2b) (2020-06-26)

### Added

- Added Hooks to the targetID system to modify the displayed data
  - `GM:TTTModifyTargetedEntity(ent, distance)`: Modify the entity that is targeted. This is useful for addons like an "Identity Disguiser".
- Added Hooks to interact with door destruction
  - `GM:TTT2BlockDoorDestruction(doorEntity, activator)`: Hook to block the door destruction.
  - `GM:TTT2DoorDestroyed(doorPropEntity, activator)`: Hook that is called after the door is destroyed.
- Added a new function to force a new radar scan: `ply:ForceRadarScan()`
- Added a new convar to change the default radar time for players without custom radar times: `ttt2_radar_charge_time`
- Added a new client ConVar `ttt_crosshair_lines` to add the possibility to disable the crosshair lines

### Changed

- Moved the disguiser icon to the status system to be only displayed when the player is actually disguised
- Reworked the addonchecker and added a command to execute the checker at a later point
- Renamed `RADAR.SetRadarTime(ply, time)` to `ply:SetRadarTime(time)`
- Updated Italian translation (Thanks @ThePlatinumGhost)
- Removed Is[ROLE] functions of all roles except default TTT ones
- Moved legacy item initialization to the `items` module (`items.MigrateLegacyItems()`)
- ttt_end_round now resets when the map changes
- Reworked the SWEP HUD help (legacy function SWEP:AddHUDHelp is still supported)
  - allows any number of lines now
  - visualization of the respective key
- Players who disconnect now leave a corpse

### Fixed

- Fixed shadow texture of the "Pure Skin HUD" for low texture quality settings
- Fixed inno subrole upgrading if many roles are installed
- Fixed and improved the radar role/team modification hook
- Fixed area portals on servers for destroyed doors
- Fixed revive fail function reference reset
- Removed the DNA Scanner hudelement for spectators
- Fixed a rare clientside error that happens if a player connects in the moment the preparing time just started
- Fixed the image in the confirmation notification whenever a bot's corpse gets identified
- Fixed bad role selection due to RNG reseeding
- Fixed missing role column translation
- Fixed viewmodel not showing correct hands on model change

## [v0.7.1b](https://github.com/TTT-2/TTT2/tree/v0.7.1b) (2020-06-02)

### Fixed
- Fixed max roles / max base roles interaction with the roleselection. Also does not crash with values != 0 anymore.

## [v0.7.0b](https://github.com/TTT-2/TTT2/tree/v0.7.0b) (2020-06-01)

### Added

- Added new convars to change the behavior of the armor
	- `ttt_item_armor_block_headshots (default: 0)` - Block headshots. Thanks @TheNickSkater
	- `ttt_item_armor_block_blastdmg (default: 0)` - Block blast damage. Thanks @Pustekuchen98
- Added essential items: 8 different types of items that are often used in other addons. You can remove them from the shop if you don't like them.
- Added server proxy for `EPOP:AddMessage()`
- Added `PrintMessage` overwrites so this function now uses TTT2 systems
- Added a new HUD element to show information about an ongoing revival to the player that is revived
- Added a load of functions to the `spawn` scope that can be used by addons
- Added a thermal vision module, which can be used by addons to render entities with a thermal vision effect
- Added a few door related hooks and convenience functions
- Added entityOutputs library to register map entity outputs easier
- Added speed handling system based on the `TTTPlayerSpeedModifier` hook
- Added a convenience function for the creation of radar points: `RADAR.CreateTargetTable(ply, pos, ent, color)`
- Added the possibility to change the radar time by either setting `ROLE.radarTime` or calling `RADAR.SetRadarTime(ply, time)`
- Added two new convars to change the confirmation behaviour
  - `ttt2_confirm_detective_only (default: 0)` - Everybody can search the corpse, but only detectives can confirm them
  - `ttt2_inspect_detective_only (default: 0)` - Only detectives can search and confirm corpses

### Changed

- Added Infinity Gauntlet SEWP to buggy addons list (interferes with the sprinting system)
- Remove GetWeapons and HasWeapon overrides (see https://github.com/Facepunch/garrysmod/pull/1648)
- Improved role module to also use `isAbstract` instead of a base role class name
- Migrated the HUDManager settings to the new network sync system
- Renamed `TTT2NET` to `ttt2net` and removed unnecessary self references
- The `ttt2net` library can now also synchronize small to medium sized tables (adds the metadata type "table")
- Reworked the old DNA Scanner
  - New world- and viewmodel with an interactive screen
  - Removed the overcomplicated UI menu (simple handling with default keys instead)
  - The new default scanner behavior shows the direction and distance to the target
- Changed TargetID colors for confirmed bodies
- Improved the `plymeta:Revive()` function
  - Added a revive position argument
  - revive makes now sure the position is valid and the player is not stuck in the wall
- Improved the player spawn handling
- Moved radar handling from client to server
- Reworked the event popup
  - texts can now be blocking or non blocking
  - there's now a popup queue
  - popups are now also shown to dead players as well
- Refactored the role selection code to reside in its own module and cleaned up the code
- Refactored some internal functions in CLSCORE to prevent errors (thanks @Kefta)
- Moved CLSCORE event report syncing to the new net.SendStream / net.ReceiveStream functions

### Fixed

- Fixed round info (the top panel) being displayed in other HUDs
- Fix GetEyeTrace override (see https://github.com/Facepunch/garrysmod/pull/1647)
- Fixed an error with the pickup system in singleplayer
- Fixed propsurfing with the magneto stick
- Fixed healthstation TargetID text
- Fixed keyinfo for doors where no key can be used
- Spawn points that have no solid ground beneath will be ignored
- Fixed role selection issues with subroles not properly replacing their baserole etc.
- Fixed map lock/unlock trigger of doors not updating targetID
- Fixed roles having sometimes the wrong radar color
- Fixed miniscoreboard update issue and players not getting shown when entering force-spec mode
- Fixed the CLSCORE window being too small for large winning team titles (will now adjust on demand)

## [v0.6.4b](https://github.com/TTT-2/TTT2/tree/v0.6.4b) (2020-04-03)

### Added

- Added Italian translation (thanks @PinoMartirio)

### Fixed

- Fixed TTT2 files running when the gamemode is not `terrortown`
- Fixed double sprinting issues
- Fixed Polish translation
- Fixed convar saving by removing terrortown settings

## [v0.6.3b](https://github.com/TTT-2/TTT2/tree/v0.6.3b) (2020-03-05)

### Added

- Added a Polish translation (Thanks @Wukerr)
- Added fallback icons for equipment
- Added a new variable that counts the played rounds per map: `GAMEMODE.roundCount`

### Fixed

- Fix `body_found` for bots
- Fix NWVarSyncing when using `TTT2NET:Set()`

## [v0.6.2b](https://github.com/TTT-2/TTT2/tree/v0.6.2b) (2020-03-01)

### Fixed

- Increased the maximum number of roles that can be used. (Fixes weird role issues with many roles installed)

## [v0.6.1b](https://github.com/TTT-2/TTT2/tree/v0.6.1b) (2020-02-17)

### Fixed

- Fixed a bug with the spawn wave interval

## [v0.6b](https://github.com/TTT-2/TTT2/tree/v0.6b) (2020-02-16)

### Added

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

### Changed

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

## [v0.5.7b](https://github.com/TTT-2/TTT2/tree/0.5.7b) (2019-10-07)

### Added

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

### Changed

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

## [v0.5.6b-h1](https://github.com/TTT-2/TTT2/tree/0.5.6b-h1) (2019-09-06)

### Fixed

- Traitor shop bug (caused by the september'19 GMod update)
- ShopEditor bugs and added a response for non-admins
- Glitching head icons

## [v0.5.6b](https://github.com/TTT-2/TTT2/tree/0.5.6b) (2019-09-03)

### Added

- Marks module
- New sprint and stamina hooks for add-ons
- Added a documentation of TTT2
- Added GetColumns function for the scoreboard

### Changed

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

## [v0.5.5b](https://github.com/TTT-2/TTT2/tree/0.5.5b) (2019-07-07)

### Added

- Added convars to hide scoreboard badges
- A small text that explains the spectator mode
- Weapon pickup notifications are now moved to the new HUD system
- Weapon pickup notifications support now pure_skin
- New shadowed text rendering with font mipmapping

### Changed

- Refactored the code to move all language strings into the language files

### Fixed

- Fixed the reroll per buy bug
- Fixed HUD switcher bug, now infinite amounts of HUDs are supported
- Fixed the outline border of the sidebar beeing wrong
- Fixed problem with the element restriction

## [v0.5.4b](https://github.com/TTT-2/TTT2/tree/v0.5.4b) (2019-06-18)

### Added

- Added a noTeam indicator to the HUD
- intriduced a new drowned death symbol
- `ttt2_crowbar_shove_delay` is now used to set the crowbar attack delay
- introduced a status system alongside the perk system

### Changed

- Included LeBroomer in the TTT2 logo

### Fixed

- Fixed a problem with colors (seen with sidekick death confirms)
- Fixed the team indicator when in spectator mode
- Credits now can be transfered to everyone, this fixes a bug with the spy

## [v0.5.3b](https://github.com/TTT-2/TTT2/tree/0.5.3b) (2019-05-09)

### Added

- Added a **Reroll System** for the **Random Shop**
- Rerolls can be done in the Traitor Shop similar to the credit transferring
- Various parameters in the **ShopEditor** are possible (reroll, cost, reroll per buy)
- Added the reroll possibility for the **Team Random Shop** (very funny)

### Changed

- Added a separate slot for class items
- Added help text to the **"Not Alive"-Shop**
- Minor design tweaks

### Fixed

- Fixed critical crash issue (ty to @nick)

## v0.5.2b (2019-04-32)

### Added

- Added spectator indicator in the Miniscoreboard
- Added icons with higher resolution (native 512x512)
- Added Heroes badge
- Added HUD documentation
- Added some more hooks to modify TTT2 externally

### Changed

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

## [v0.5.1b](https://github.com/TTT-2/TTT2/tree/v0.5.1b) (2019-03-05)

### Changed

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

## [v0.5b](https://github.com/TTT-2/TTT2/tree/v0.5b) (2019-03-03)

### Added

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
