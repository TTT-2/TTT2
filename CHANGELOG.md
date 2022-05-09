# Changelog

All notable changes to TTT2 will be documented here. Inspired by [keep a changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased

### Added

- Reworked our simplified Dropdowns MakePanel `PANEL:MakeComboBox(data)` version
  - Added possibility to manipulate serverside ConVars with Dropdowns. Just add .serverConvar with the conVarName to the given data similar to .convar
  - .serverConVar and .conVar are also supported
  - data.choices can now be a table containing `{title, value, select, icon, additionalData}`
  - data.selectValue is added, use it instead of data.selectName to choose the value you set
  - data.selectTitle is added and shall replace data.selectName
- New setting to disable session limits entirely. (by @Reispfannenfresser)
- Added `GM:TTT2AdminCheck` hook
  - Replaced all `IsSuperAdmin()` checks with this hook
  - This hook can be used to allow custom usergroups through these checks

### Breaking Changes

- Reworked Dropdowns Panel `DComboBoxTTT2` itself
  - `PANEL:AddChoice(title, value, select, icon, data)` now uses the second argument as value string for setting convars, use the fifth argument for special data instead
  - `PANEL:ChooseOption(title, index, ignoreConVar)` is deprecated and no longer chooses the displayed text, only per index
- Reworked our simplified Dropdowns MakePanel `PANEL:MakeComboBox(data)` version
  - `data.OnChange(value, additionalData, comboBoxPanel)` is now called with the two important arguments at first. They are the value that e.g. convars are set, the additionalData and the Panel

### Fixed

- Fixed addon compatibility checker fussing over disabled addons
- Fixed ammo entities blocking +use traces

## [v0.11.4b](https://github.com/TTT-2/TTT2/tree/v0.11.4b) (2021-12-17)

### Changed

- Updated Japanese translation (by @westooooo)
- Switched from the voicerecord commands to the GMod permission system due to a recent GMod update breaking the old voice chat

## [v0.11.3b](https://github.com/TTT-2/TTT2/tree/v0.11.3b) (2021-11-18)

### Fixed

- Fixed Equipment-Editor not showing the current synced values, but the cached ones

### Changed

- Changed serverConVars not indexing with 0 in tables (could cause issues when iterating)

## [v0.11.2b](https://github.com/TTT-2/TTT2/tree/v0.11.2b) (2021-11-17)

### Fixed

- Fixed correct role Karma multipliers used in Karma-module

## [v0.11.1b](https://github.com/TTT-2/TTT2/tree/v0.11.1b) (2021-11-16)

### Added

- Added four new Karma multipliers as role variables. They are applied **after** all other Karma calculations are done_
  - `ROLE.karma.teamKillPenaltyMultiplier`: The multiplier that is used to calculate the Karma penalty for a team kill
  - `ROLE.karma.teamHurtPenaltyMultiplier`: The multiplier that is used to calculate the Karma penalty for team damage
  - `ROLE.karma.enemyKillBonusMultiplier`: The multiplier that is used to calculate the Karma given to the killer if a player from an enemy team is killed
  - `ROLE.karma.enemyHurtBonusMultiplier`: The multiplier that is used to calculate the Karma given to the attacker if a player from an enemy team is damaged

### Fixed

- Fixed `ply:Give(weapon)` to work again, when weapons are cached, fixing the spawneditor to work again
- Fixed spawneditor not causing errors, when going through walls due to many steps
- Set default traitor button variable back to 0
- Fixed unchanged or unscaled damage being sent to the client, leading to a wrongly working damage-overlay

## [v0.11.0b](https://github.com/TTT-2/TTT2/tree/v0.11.0b) (2021-11-15)

### Added

- Added the hook `GM:TTT2CalledPolicingRole` that is called after all policing role players were called to a corpse
- Added all TTT2 convars into the F1 menu
  - most convars are located in the 'administration' menu
  - equipment specific settings can be found in the 'edit equipment' menu
- Added icon to the magneto stick
- Added the function `AddToSettingsMenu` to both `SWEP` and `ITEM` to add settings to the equipment menu
- Added the role flag `.isOmniscientRole`; if set to true the role is able to see missing in action players and the haste mode time
- Added `GM:TTT2ModifyOverheadIcon` to add, remove or modify the overhead icons of players

### Fixed

- Fixed that every policing player could be called to a corpse, this is now again restricted to alive only players
- Fixed inconsistency between `.disabledTeamChatRecv` and `.disabledTeamChatRec`
- Fixed non-public policing roles having hats and therefore confirming them
- Fixed triggered spawns on maps like 'ttt_lttp_kakariko_a5' with the vases and 'ttt_mc_jondome' with the chests
- Fixed roleselection layering with base roles to ensure layer order is considered correctly when selecting roles
- Fixed hotreloading items
- Fixed random playermodel selection on map change not working
- Fixed `ply:Give` sometimes picking up all surrounding weapon entities, if auto pickup is enabled
- Fixes weapon pickup sometimes causing floating weapons
- Fixes weapon pickup sometimes failing if a weapon with the same class as a weapon in the inventory should be picked up

### Changed

- All public policing roles now appear as detectives in the chat
- Change blocking revival mode from `true`/`false` to
  - `REVIVAL_BLOCK_NONE`: don't block the winning condition during the revival process [default, previously `nil`/`false`]
  - `REVIVAL_BLOCK_AS_ALIVE`: only block the winning condition, if the player being alive would change the outcome [previously `true`]
  - `REVIVAL_BLOCK_ALL`: block the winning condition until the revival process is ended
  - the old arguments still work, they are automatically converted
- Changed logs folder to `terrortown/logs/` to be inline with everything else
- Added more role agnostics
  - voice drain rate is now no longer bound to Detectives but to all public policing roles
  - Karma multiplier is now no longer bound to Detectives but to all public policing roles
  - all non-innocent roles are now able to pin ragdolls if enabled (previous only Traitors could do this)
- Overhead icons are now also either colored black or white depending on the role's color

### Breaking Changes

- Renamed some convars to be inline with our 'opt-in style', all values were changed so that the default value is kept
  - `ttt_no_prop_throwing` is now `ttt_prop_throwing`
  - `ttt_limit_spectator_chat` is now `ttt_spectators_chat_globally`
  - `ttt_no_nade_throw_during_prep` is now `ttt_nade_throw_during_prep`
  - `ttt_armor_classic` is now `ttt_armor_dynamic`

## [v0.10.3b](https://github.com/TTT-2/TTT2/tree/v0.10.3b) (2021-10-29)

### Fixed

- Fixed the hook scope in the disguiser causing an error
- Fixed the classic entity spawn mode breaking on maps without all three spawn types
- Fixed weapons not using their average firerate with a tickrate dependent fix. Function `SWEP:SetNextPrimaryFire(nextTime)` was overwritten with our fix `SWEP:SetNextPrimaryFire(nextTime, skipTickrateFix)`

### Changed

- Added new param `skipTickrateFix` to `SWEP:SetNextPrimaryFire(nextTime, skipTickrateFix)` to skip our inbuilt tickrate fix

## [v0.10.2b](https://github.com/TTT-2/TTT2/tree/v0.10.2b) (2021-10-21)

### Added

- Added a new hook `GM:TTT2ModifyRadioTarget` to modify the current radio target
- Added documentation to all hooks

### Fixed

- Fixed the reset button not working for Sliders in the F1 Menu
- Fixed defuser only working for detectives
- Fixed some weapon packs like ArcCW to be working again, weapons are now initialized with ttt2 variables after the `InitPostEntity` hook

### Changed

- Changed the Sliders to only update after dragging ends, no matter where you clicked on the slider before dragging
- Changed `TTTPlayerUsedHealthStation` hook, return `false` to cancel health regeneration tick
- Changed all C4 hooks to be cancelable

### Removed

- Removed old concommand `shopeditor` and the old shopeditor

### Breaking Changes

- Renamed hook `GM:TTT2CheckWeaponForID` to `GM:TTT2RegisterWeaponID` better fitting its purpose as its probably nowhere used yet anyway

## [v0.10.1b](https://github.com/TTT-2/TTT2/tree/v0.10.1b) (2021-10-15)

### Fixed

- Fixed Playermodels not correctly loading changes on game start
- Fixed setting defaults before assigning a resetButton not throwing an error anymore
- Fixed invisible preview for entity spawn placements

## [v0.10.0b](https://github.com/TTT-2/TTT2/tree/v0.10.0b) (2021-10-14)

### Added

- Added a new scoring variable named `score.survivePenaltyMultiplier` to punish surviving players of a losing team
- Added in game spawn editor system that can be found in F1->Administration
- Moved all TTT weapons to this repository (with cleaned up code)
- Added in four new libraries
  - map: A library which handles map specific data
  - entspawn: A library that handles the spawning and spawns of all entity types
  - entspawnscript: A library that handles the new TTT2 entity spawn script to customize spawns
  - plyspawn: A library that builds on top of entspawn to handle the more complex player spawn (originally named spawn, see `Breaking changes`)
- Added a new submenu to the administration settings regarding basic role setup
- Added a new menu to the F1 menu to set up and configure all installed menus
- Added two new hooks to modify the contents of the newly added menu
  - `ROLE:AddToSettingsMenu(parent)`
  - `ROLE:AddToSettingsMenuCreditsForm(parent)`
- Added a new in-game player model selector
  - Added new convars that can change the way playermodels are selected (these can be found in the gamemode menu)
  - Added a new ConVar `ttt2_use_custom_models` (def: 0) to enable the custom player model selector
  - Added indicator that shows if a model has a headshot hitbox
  - Added possibility to enable/disable detective hats for individual player models
- Added a new admin only menu for server addon settings
- Added automatic default values for serverConVars
- Added two new role variables:
  - `isPublicRole`: This makes the role behave like a detective in such a way, that the role is public known and shown in the scoreboard. This means other roles can use this without special role syncing; additionally roles with that flag will be handled like a detective if killed by an 'evil' role, meaning that they will receive a credit bonus
  - `isPolicingRole`: This rolevar adds all "detective-like" features to the detective, for example the ability to be called to a corpse etc.
- Added two new role conVar variables:
  - `creditsAwardDeadEnable`: To award this role if a certain percentage of players from the enemy teams died
  - `creditsAwardKillEnable`: To award this role if they killed a high value public role

### Changed

- Split up kill, suicide and teamkill in the round end screen to make it more clear
- Decreased the minimum cost of equipment in the equipment editor to 0
- Changed disguise such that every role can now use the function
- Completely reworked how weapons, ammo and players spawn in the world
- Sliders only update ConVars on mouseRelease now
- Changed the way credits on kills are distributed in a way that non-default roles can easily use this as well

### Breaking Changes

- Removed the (unused?) ConVar `ttt2_custom_models`
- Removed the function `GetRandomPlayerModel()`, use `playermodels.GetRandomPlayerModel()` instead
- Renamed the `spawn` module to `plyspawn`
- Hook `PlayerSelectSpawn` doesnt return a spawnEntity anymore
- SpawnWillingPlayers is deleted and not available anymore
- renamed the `ttt_credits_starting` to `ttt_traitor_credits_starting` to be more in-line with all other roles
  **WARNING:** This means that every traitor now starts with 0 credits until the convar reset button is pressed (on existing servers)
- removed the `alone_bonus` convar because it only complicated the credits system further without adding much benefit

## [v0.9.3b](https://github.com/TTT-2/TTT2/tree/v0.9.3b) (2021-09-25)

### Added

- Add Traditional Chinese Translation (by @TEGTianFan)
- Added a searchbar to submenus
- Added full-sized icons to the equipment-editor
- Hotreload functionality for weapons, they are now fully compatible to TTT2 after hotreload
- Added experimental `SWEP.HotReloadableKeys` a list of strings to weapons, that makes data saved with `weapons.GetStored()` persistent across hotreloads
- Extended cvars library to support manipulation of serverside ConVars
- Added possibility to manipulate serverside ConVars with Checkboxes and Sliders
  - Just add .serverConvar with the conVarName to the given data similar to .convar

### Fixed

- Updated Japanese translation (by @westooooo)
- Fixed text positioning in pure_skin bar (by @LukasMandok)
- Fixed data being not persistent after hot reloading
  - HUDs are now still available
  - ttt2net keeps its data
  - bindings are not lost on reload
- Fixed id-errors of weapons registered before TTT2 was loaded

### Changed

- Revise and additions simplified Chinese (by @TEGTianFan)
- Prevent spectators from gathering info on players if they're about to revive (by @AaronMcKenney)
- ROLE_NONE does not count as a special role anymore (by @TheNickSkater)

### Internal Breaking Changes

- Removed first argument of `GetEquipmentBase(data, equipment)`, it only takes the equipment as argument now `GetEquipmentBase(equipment)` and generally merges it with `EquipMenuData`
- Added equipment as argument to `InitDefaultEquipmentForRole(roleData)`, it now only initializes the given equipment not all `InitDefaultEquipmentForRole(roleData, equipment)`
- Added equipment as argument to `CleanUpDefaultCanBuyIndices()`, it now only initializes the given equipment not all `CleanUpDefaultCanBuyIndices(equipment)`

## [v0.9.2b](https://github.com/TTT-2/TTT2/tree/v0.9.2b) (2021-06-20)

### Fixed

- Fixed low karma autokick convar
- Fixed multi-layer inheritance by introducing a recursion based approach

## [v0.9.1b](https://github.com/TTT-2/TTT2/tree/v0.9.1b) (2021-06-19)

### Fixed

- Fixed shop convars not being shared / breaking the shop

## [v0.9.0b](https://github.com/TTT-2/TTT2/tree/v0.9.0b) (2021-06-19)

### Added

- All new roundend menu
  - new info panel that shows detailed role distribution during the round
  - info panel also states detailed score events
  - new timeline that displays the events that happened during the round
  - added two new round end conditions: `time up` and `no one wins`
- Added `ROLE_NONE` (ID `3` by default)
  - Players now default to `ROLE_NONE` instead of `ROLE_INNOCENT`
  - Enables the possibility to give Innocents access to a custom shop (`shopeditor`)
- Karma now stores changes
  - Is shown in roundend menu
- Added a new hook `TTT2ModifyLogicCheckRole` that can be used to modify the tested role for map related role checks
- Added the ConVar `ttt2_random_shop_items` for the number of items in the randomshop
- Added per-player voice control by hovering over the mute icon and scrolling

### Fixed

- Updated French translation (by @MisterClems)
- Fixed IsOffScreen function being global for compatibility
- Fixed a German translation string (by @FaRLeZz)
- Fixed a Polish translation by adding new lines (by @Wuker)
- Fixed a data initialization bug that appeared on the first (initial) spawn
- Fixed silent Footsteps, while crouched bhopping
- Fixed issue where base innocents could bypass the TTT2AvoidGeneralChat and TTT2AvoidTeamChat hooks with the team chat key
- Fixed issue where roles with unknownTeam could see messages sent with the team chat key
- Fixed the admin section label not being visible in the main menu
- Fixed the auto resizing of the buttons based on the availability of a scrollbar not working
- Fixed reopening submenus of the legacy addons in F1 menu not working
- TTT: Fixed karma autokick evasion
- TTT: Fixed karma being applied to weapon damage even though karma is disabled

### Changed

- Microoptimization to improve code performance
- Converted `roles`, `huds`, `hudelements`, `items` and `pon` modules into libraries
- Moved `bind` library to the libraries folder
- Moved favorites functions for equipment to the equipment shop and made them local functions
- Code cleanup and removed silly negations
- Extended some ttt2net functions
- Changed `bees` win to `nones` win
- By default all evil roles are now counted as traitor roles for map related checks
- Changed the ConVar `ttt2_random_shops` to only disable the random shop (if set to `0`)
- Shopeditor settings are now available in the F1 Menu
- Moved the F1 menu generating system from a hook based system to a file based system
  - removed the hooks `TTT2ModifyHelpMainMenu` and `TTT2ModifyHelpSubMenu`
  - menus are now generated based on files located in `lua/terrortown/menus/gamemode/`
  - submenus are generated from files located in folders with the menu name
- Menus without content are now always hidden in the main menu
- Moved Custom Shopeditor and linking shop to roles to the F1 menu
- Moved inclusion of cl_help to the bottom as nothing depends on it, but menus created by it could depend on other client files
- Shopeditor equipment is now available in F1 menu
- Moved the role layering menu to the F1 menu (administration submenu)
  - removed the command `ttt2_edit_rolelayering`
- moved the internal path of `lang/`, `vskin/` and `events/` (this doesn't change anything for addons)
- Sort teammates first in credit transfer selection and add an indicator to them

### Removed

- Removed the custom loading screen (GMOD now only accepts http(s) URLs for sv_loadingurl)

### Breaking Changes

- Adjusted `Player:HasRole()` and `Player:HasTeam()` to support simplified role and team checks (no parameter are supported anymore, use `Player:GetRole()` or `Player:GetTeam()` instead)
- Moved global roleData to the `roles` library (e.g. `INNOCENT` to `roles.INNOCENT`). `INNOCENT`, `TRAITOR` etc. is not supported anymore. `ROLE_<ROLENAME>` is still supported and won't be changed.
- Shopeditor function `ShopEditor.ReadItemData()` now only updates a number of key-parameters, must be given as UInt. Messages were changed accordingly (`TTT2SESaveItem`,`TTT2SyncDBItems`)
- Equipment shop favorite functions are now local and not global anymore (`CreateFavTable`, `AddFavorite`, `RemoveFavorite`, `GetFavorites` & `IsFavorite`)


## [v0.8.2b](https://github.com/TTT-2/TTT2/tree/v0.8.2b) (2021-03-25)

### Fixed

- TTT: fix instant reload of dropped weapon (by @svdm)
- TTT: fix ragdoll pinning HUD for innocents (by @Flapchik)
- Fixed outline library not working

### Changed

- Added global alias for IsOffScreen function to util.IsOffScreen
- Updated Japanese localization (by @Westoon)
- Moved rendering modules to libraries
- Assigned PvP category to the gamemode.
- Updated German and English localization

## [v0.8.1b](https://github.com/TTT-2/TTT2/tree/v0.8.1b) (2021-02-19)

### Fixed

- Inheriting from the same base using the classbuilder in different folders did not work
- Fixed a docstring in the vskin module
- Made TTT2CanTransferCredits hook a part of GM for API Documentation sanity

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
