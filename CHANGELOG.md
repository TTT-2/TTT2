# Changelog

All notable changes to TTT2 will be documented here. Inspired by [keep a changelog](https://keepachangelog.com/en/1.0.0/)

## Unreleased

### Fixed

- Fixed health station continuous use not working (by @wgetJane)
- Fixed the shop search breaking when using certain special characters (by @NickCloudAT)
- Fixed propspec not working (by @wgetJane)
- Fixed a regression in TTT voice chat team colors (see <https://github.com/Facepunch/garrysmod/commit/38b7394ced29ffe318213e580efa4b1090828ac7>)

## [v0.14.3b](https://github.com/TTT-2/TTT2/tree/v0.14.3b) (2025-03-18)

### Added

- Added C4 cvars for adjusting the range & falloff of C4 explosions (by @Spanospy)
  - C4 explosions will now also respect the weapon's configured damage scaling
- Added option to select preferred unit of length for distance displays (by @wgetJane)
- Added `GM:TTT2ArmorHandlePlayerTakeDamage` hook for modifying/overriding armor behavior (by @wgetJane)
- Added server option for body armor to protect against crowbar damage (by @wgetJane)
- Added `GM:TTTLastWordsMsg` hook from base TTT (Facepunch/garrysmod/pull/2227, by @wgetJane)
- Port new TTT entity ttt_filter_role to TTT2 (Facepunch/garrysmod/pull/2225 by @figardo, ported by @wgetJane)
- Added 2 new sprint settings (by @wgetJane)
  - Stamina cooldown time before stamina begins regenerating after sprinting, 0.8 seconds by default
  - Option to require forward key to be held to sprint, enabled by default

### Changed

- Updated Russian and English localization files (by @Satton2)
- Updated the list of troublesome addons used by the addonchecker
- Changed option for body armor to protect against headshot damage by default (by @wgetJane)

### Fixed

- Fixed classic armour protecting against crowbar damage (by @wgetJane)
- Fixed C4/Radio sounds not playing outside of PAS (Facepunch/garrysmod/pull/2203, by @figardo)
- Fixed players sometimes being revealed as dead when they chat/voicechat right as they die (Facepunch/garrysmod/pull/2229, by @wgetJane)
- Fixed various bugs related to using doors and buttons, to match base TTT behavior (by @wgetJane)
  - Fixed brush doors on certain maps not being usable
  - Fixed certain doors on certain maps being forcibly usable when they shouldn't be
  - Fixed func_rotating being forcibly usable
  - Fixed vehicles not being usable
  - Removed forced button solidity
  - Improved targetID trace detection for doors and buttons
  - Allow brush doors to be detected as destructible for targetID
  - Use NW2Vars instead of NWVars for door variables for more efficient networking
  - Fixed clientside door.GetAll() to return a more updated list of doors
  - Removed clientside TTT2PostDoorSetup hook
  - Changed crowbar unlocking behavior to match base TTT
- Fixed lua errors after autorefresh (by @wgetJane)
- Fixed Hud errors when picking up items or weapons with no viable icon (by @NickCloudAT)

## [v0.14.2b](https://github.com/TTT-2/TTT2/tree/v0.14.2b) (2025-02-02)

### Fixed

- Fixed new outlines' `OUTLINE_MODE_VISIBLE` and `OUTLINE_MODE_BOTH`

## [v0.14.1b](https://github.com/TTT-2/TTT2/tree/v0.14.1b) (2025-02-01)

### Added

- Added Korean translation (by @Kojap)
- Added diagnostic information to the addonchecker output.
  - This also includes a Garry's Mod version check which triggers a warning if TTT2 is not compatible. First baseline version is '240313' (by @NickCloudAT)
- Added `GM:TTT2PlayDeathScream` hook to cancel or overwrite/change the deathscream sound that plays, when you die (by @NickCloudAT)
- Added support for "toggle_zoom" binds to trigger the radio commands menu (by @TW1STaL1CKY)
- Added option to use right click to enable/disable roles in the role layering menu (by @TimGoll)
- Added a menu to allow admins to inspect, in detail, how and why roles are distributed as they are (by @nike4613)
- Added option to enable team name next to role name on the HUD (by @milkwxter)
- Added score event for winning with configurable role parameter (by @MrXonte)
- Added ExplosiveSphereDamage game effect for easy calculation of explosion damage through walls (by @MrXonte)
- Added support for outlines of different thickness (by @Wardenpotato)

### Fixed

- Fixed missing translation for None role error by removing it (by @mexikoedi)
- Fixed sometimes entity use triggering the wrong or no entity (by @TimGoll)
- Fixed translation of muting Terrorists and Spectators (by @mexikoedi)
- Fixed continuous use being broken, meaing that holding E on a health station did nothing (by @TimGoll)
- Fixed the loadingscreen disable causing an error (by @TimGoll)
- Fixed the rounds left always displaying one less than actually left (by @TimGoll)
- Fixed rendering glitches in the loading screen (by @TimGoll)
- Fixed weapon pickup through walls (by @MrXonte)
- Fixed spectating player still being visible through thermalvision after killing that player (by @MrXonte)
- Fixed Magneto-stick not using C_Hands (by @SvveetMavis)
- Fixed console error when dropping ammo for weapons with no AmmoEnt (by @MrXonte)
- Fixed client error for a not fully initialized client (by @Histalek)
- Fixed the targetID corpse hint not respecting `ttt_identify_body_woconfirm` (by @Histalek)
- Fixed the beacon not being properly translated when placed (by @Histalek)
- Fixed binoculars zooming not being predicted (by @Histalek)
- Fixed an error when trying to pickup a placed equipment (e.g. beacon) (by @Histalek)
- Fixed corpse searching sound playing when searched by a spectator, searched covertly, or searched long range (by @TW1STaL1CKY)
- Fixed the mute button in the scoreboard not working (by @TW1STaL1CKY)
- Fixed a few errors in shop error messages (by @Histalek)
- Fixed `markerVision`'s registry table being able to contain duplicate obsolete entries, thus fixing potential syncing issues with markers (by @TW1STaL1CKY)
- Fixed issue in new Ammo dropping that could cause an error when dropping for modified weapon bases. (by @MrXonte)
- Fixed C4 not showing the correct inflictor when the player is killed (by @TimGoll)
- Fixed M16 Ironsight misalignment (by @SvveetMavis)
- Fixed outline interactions with certain weapon scopes (by @WardenPotato)
- Fixed outlines not rendering uniformly (by @WardenPotato)

### Changed

- Updated French translation (by @MisterClems)
- Updated Turkish localization (by @NovaDiablox)
- Changed it so that continous use doesn't require direct focus; healing at a health station also works when looking around as long as you stay close by (by @TimGoll)
- Updated Russian localization (by @Satton2)
- Updated targetID to use `Vehicle:GetDriver` instead of the `ttt_driver` NWEntity (by @Histalek)
- Updated Russian and English localization files (by @Satton2)
- Updated old TTT HUD to show name of spectated player (by @somefnfplayerlol)
- Changes to the enabled map prefixes will not be announced to players anymore (by @Histalek)
- By default only `ttt` and `ttt2` map prefixes are enabled (by @Histalek)
- Updated `ttt_identify_body_woconfirm` to be replicated across the server and client (by @Wryyyong)
- Changed how Ammo is dropped; if drop should be from reserve ammo, now tries to drop a full ammo box instead of a full clip. (by @MrXonte)
- Updated `ttt_spec_prop_control` to be replicated across the server and client (by @NickCloudAT)
  - With this, the KeyHelp feature also hides the PropSpec bind if PropSpec is disabled on the server
- Renamed `ttt_session_limits_enabled` to `ttt_session_limits_mode`, introducing a four-mode control (0-3) for managing how TTT2 ends a session. (by @NickCloudAT)
  - Modes: 0 = No session limit, 1 = Default TTT, 2 = Only time limit, 3 = Only round limit
- Moved all role-related admin options into the "Roles" menu (by @nike4613)
- Improved description of role layering (by @nike4613)
- Improved the role layering menu by showing which role is enabled and which is disabled (by @TimGoll)
- Reworked C4 damage calculation with new gameEffect ExplosiveSphereDamage (by @MrXonte)
- Changed the amount the M16 zooms in (by @SvveetMavis)

## [v0.14.0b](https://github.com/TTT-2/TTT2/tree/v0.14.0b) (2024-09-20)

### Added

- Added hook ENTITY:ClientUse(), which is triggered clientside if an entity is used (by @ZenBre4ker)
  - Return true to prevent also using this on the server for clientside only usecases
- Added hook ENTITY:RemoteUse(ply), which is shared (by @ZenBre4ker)
  - Return true if only clientside should be used
- Added RemoteUse to radio, you can now directly access it via use button on marker focus (by @ZenBre4ker)
- Added sounds to multiple UI interactions (can be disabled in settings: Gameplay > Client-Sounds) (by @TimGoll)
- Added a globally audible sound when searching a body (by @TimGoll and @mexikoedi)
- Added the option to add a subtitle to a marker vision element (by @TimGoll)
- Added the option to assign random unique models at round start (by @Exonen2)
- Added a new voice chat UI (by @TimGoll)
- Added new credit related hooks (by @Spanospy)
  - Added `GM:TTT2CanTakeCredits()` hook for overriding whether a player is allowed to take credits from a given corpse
  - Added `GM:TTT2OnGiveFoundCredits()` hook which is called when a player has been given credits for searching a corpse
  - Added `GM:TTT2OnReceiveKillCredits()` hook which is called when a player recieves credits for a kill
  - Added `GM:TTT2OnReceiveTeamAwardCredits()` hook which is called when a player recieves credits as a team award
  - Added `GM:TTT2OnTransferCredits()` hook which is called when a player has successfully transfered a credit to another player
- Disabled locational voice during the preparing phase by default (by @ruby0b)
  - Added a ConVar `ttt_locational_voice_prep` to reenable it
- Added `SWEP.EnableConfigurableClip` and `SWEP.ConfigurableClip` to set the weapon's clip on buy via the equipment editor (by @TimGoll)
- Added Text / Nickname length limiting (by @TimGoll)
- Added `ttt_locational_voice_range` to set a cut-off radius for the locational voice chat range (by @ruby0b)
- Added a convar `ttt2_inspect_credits_always_visible` to control whether credits are visible to players that do not have a shop (by @nike4613)
- Added multiple global voice chat activation modes for clients to choose from (Gameplay > Voice & Volume): (by @ruby0b)
  - Push-to-Talk (default)
  - Push-to-Mute
  - Toggle
  - Toggle (Activate on Join)
- Team Voice Chat is always push-to-talk and temporarily disables global voice chat while being used (by @ruby0b)
- Added a new generic button to F1 menu elements to be used in custom menus (by @TimGoll)
- Added toggle and run buttons to many F1 menu elements (by @TimGoll)
- Added combo cards to the UI, clickable cards that act like combo boxes (by @TimGoll)
- Added a run button to bindings in the bindings menu (by @TimGoll)
- Added a new admin commands menu (by @TimGoll)
  - Added a submenu to change maps
  - Added a submenu to issue basic commands
- Added a new `gameloop` module that contains all functions related to the round structure (by @Tim Goll)
- Added a loadingscreen that hides the visible and audible lag introduced by the map cleanup on round change (by @TimGoll)
- Added a voicebattery module that handles the voice battery (by @TimGoll)
- Added `admin.IsAdmin(ply)` as a wrapper that automatically calls `GM:TTT2AdminCheck` (by @TimGoll)
  - Made sure this new function is used in our whole codebase for all admin checks
- Added `ENTITY:IsPlayerRagdoll` to check if a corpse is a real player ragdoll (by @TimGoll)
- Added improved vFire integration for everything in TTT2 that spawns fire (by @TimGoll and @EntranceJew)
- Added the `SWEP.DryFireSound` field to the weapon base to allow the dryfire sound to be easily changed (by @TW1STaL1CKY)
- Added role derandomization options for perceptually fairer role distribution, enabled by default (by @nike4613)
- Added targetID to buttons (by @TimGoll)
- Added force role admin command (by @mexikoedi)
- Added `draw.RefreshAvatars(id64)` to refresh avatar icons (by @mexikoedi)
- Added `GM:TTT2OnButtonUse(ply, ent, oldState)`: a hook that is triggered when a button is pressed and that is able to prevent that button press (by @TimGoll)
- Added TargetID and keyInfo to vehicles (by @TimGoll)
- Added `GM:TTT2PostButtonInitialization(buttonList)`: a hook that is called after all buttons on the map have been initialized (by @TimGoll)

### Changed

- Placeable Entities are now checked for pickup clientside first (by @ZenBre4ker)
  - C4 UI is not routed over the server anymore
- Visualizer can now only be picked up by the originator (by @ZenBre4ker)
- TargetID is now hidden when a marker vision element is focused (by @TimGoll)
- Tracers are now drawn for every shot/pellet instead of only 25% of shots/pellets (by @EntranceJew)
- The ConVar "ttt_debug_preventwin" will now also prevent the time limit from ending the round (by @NickCloudAT)
- `GM:TTT2GiveFoundCredits` hook is no longer called when checking whether a player is allowed to take credits from a given corpse (by @Spanospy)
- Micro optimizations (by @EntranceJew)
  - use `net.ReadPlayer` / `net.WritePlayer` if applicable instead of `net.Read|WriteEntity`
  - Reduced radar bit size for net message
  - The holdtype for pistol weapons now matches the viewmodel
- `VOICE.IsSpeaking(ply)` (clientside) can now be used to check if any player is speaking to you (by @TimGoll)
- Unified the spec color usage throughout the whole UI (by @TimGoll)
- Cleanup and performance optimizations for marks library (by @WardenPotato)
- Updated the Turkish localization file (by @NovaDiablox)
- The level time now starts with the first preparing phase, meaning that idle on connect doesn't decrease the map time (by @TimGoll)
- Minor cleanup and optimizations in weapon code (by @TW1STaL1CKY)
- Shotgun weapon changes (by @TW1STaL1CKY)
  - Dry firing (attempting to shoot with no ammo) will now make you reload if possible, like all the other weapons do
  - Interrupting the reload should look and feel less jank
  - A thirdperson animation now plays when each shell is loaded (the pistol reload animation seems to fit best)
- Now always properly checks if an entity is a true ragdoll to make sure no other props get ragdoll handling (by @TimGoll)
- Spectators are now able to look at corpses on fire (by @TimGoll)
- Corpses on fire display that information in targetID and MStack (by @TimGoll)
- Updated Russian and English localization files (by @Satton2)
- Made `ply:IsReviving` a shared player variable (by @TimGoll)
- Updated and improved the Simplified Chinese localization file (by @sbzlzh and @TheOnly8Z)
- Avatar icons are not fetched anymore but instead created with `AvatarImage` (fixes missing icons for chinese players) (by @mexikoedi)
- `GM:TTT2PlayerReady` is now called for every player even on clients (by @TimGoll)
- Updated Japanese translation (by @westooooo)
- `plyspawn.GetSpawnPointsAroundSpawn` now tries to find spawns that are on the ground if possible (by @TimGoll)

### Fixed

- Fixed `DynamicCamera` error when a weapon's `CalcView` doesn't return complete values (by @TW1STaL1CKY)
- Fixed Roundendscreen showing karma changes even if karma is disabled (by @Histalek)
- Fixed the player's FOV staying zoomed in if their weapon is removed while scoped in (by @TW1STaL1CKY)
- Fixed the player's FOV staying zoomed in with the binoculars if they're removed from you (by @TW1STaL1CKY)
- Fixed weapon unscoping (or generally any time FOV is set back to default) being delayed due to the player's lag (by @TW1STaL1CKY)
- Fixed overhead icons sometimes being stuck at random places (by @TimGoll)
- Fixed a null entity error in the ShootBullet function in weapon_tttbase (by @mexikoedi)
- Fixed a nil compare error in the DrawHUD function in weapon_tttbasegrenade (by @mexikoedi)
- Fixed players sometimes not receiving their role if they joined late to the game (by @TimGoll)
- Fixed crowbar attack animation not being visible to the player swinging it (by @TW1STaL1CKY)
- Fixed weapon dryfire sound interrupting the weapon's gunshot sound (by @TW1STaL1CKY)
- Fixed incendiaries sometimes exploding without fire (by @TimGoll)
- Fixed scoreboard not showing any body search info on players that changed to forced spec during a round (by @TimGoll)
- Fixed vFire explosions killing a player even if they have `NoExplosionDamage` equipped (by @TimGoll)
- Fixed a nil error in the PreDrop function in weapon_ttt_cse (by @mexikoedi)
- Fixed `table.FullCopy(tbl)` behaviour when `tbl` contained a Vector or Angle (by @Histalek)
- Fixed the bodysearch showing a wrong player icon when searching a fake body (by @TimGoll)
- Fixed players respawned with `ply:Revive` sometimes spawning on a fake corpse (by @TimGoll)
- Fixed undefined Keys breaking the gamemode (by @TimGoll)
- Fixed markerVision elements being visible to team mates of unknown teams (such as team Innocent) (by @TimGoll)
- Fixed inverted settings being inverted twice in the equipment editor (by @TimGoll)
- Fixed OldTTT HUD sidebar elements missing translation (by @TimGoll)
- Fixed avatar icons not refreshing if they were changed on Steam (by @mexikoedi)
- Fixed a wrong label for the sprint speed multiplier in the F1 menu (by @TimGoll)
- Fixed own player name being shown in targetID when in vehicle (by @TimGoll)
- Fixed `ShopEditor.BuildValidEquipmentCache()` being called too early on the client, resulting in a wrong cache state (by @NickCloudAT and @12problems)

### Removed

- Removed radio tab in shop UI (by @ZenBre4ker)
- Removed all uses of UseOverride-Hook inside TTT2 (It's still available for addons!) (by @ZenBre4ker)
- Removed `round_restart`, `round_selected` and `round_started` MStack messages to reduce message spawm (by @TimGoll)
- Removed the old tips panel visible to spectators (moved to the new loading screen) (by @TimGoll)

### Breaking Changes

- Renamed `GM:TTT2ModifyVoiceChatColor(ply, clr)` to `GM:TTT2ModifyVoiceChatMode(ply, mode)`
- Renamed `ply:GetHeightVector()` to `ply:GetHeadPosition()`
- Removed the `TIPS` module and replaced it with a new `tips` module
- Removed `draw.WebImage(url, x, y, width, height, color, angle, cornerorigin)` and `draw.SeamlessWebImage(url, parentwidth, parentheight, xrep, yrep, color)` from the `draw` module
- Due to `GM:TTT2PlayerReady` now being called for every player, addon devs have to make sure to check the player on the client

## [v0.13.2b](https://github.com/TTT-2/TTT2/tree/0.13.2b) (2024-03-10)

### Added

- Added upstream content files to base TTT2
- Added `plymeta:IsFullySignedOn()` to allow excluding players that have not gotten control yet (by @EntranceJew)

### Changed

- Crosshair rendering now is a bit more flexible and customizable
- A crosshair is now also drawn when holding a nade, making it less confusing when looking at entities
- Hides item settings in the equipment editor that are only relevant for weapons
- The binoculars now use the default crosshair as well

### Fixed

- Fixed the AFK timer accumulating while player not fully joined (by @EntranceJew)
- Fixed weapons which set a custom view model texture having an error texture
- Fixed the equipment menu throwing errors when clicking on some items
- TTT2 now ignores Gmods SWEP.DrawCrosshair and always draws just its own crosshair to prevent two crosshairs at once
- Fixed hud help text not being shown for some old weapons
- Fixed detective search being overwritten by player search results

## [v0.13.1b](https://github.com/TTT-2/TTT2/tree/v0.13.1b) (2024-02-27)

### Fixed

- Fixed rendering for weapons not based on the TTT2 base (e.g. TFA) (by @TimGoll)
- Fixed bodysearch entries not having a title breaking the rendering (by @TimGoll)
- Fixed `GetViewModel` error on the client when joining a server (by @TimGoll)
- Fixed the new view changes preventing weapons from modifying the playerview (by @TimGoll)
- Fixed the new view changes affecting non-player entities (by @TimGoll)
- Fixed an error in an error message (by @mexikoedi)
- Fixed magneto stick not targeting certain props (by @homonovus)

## [v0.13.0b](https://github.com/TTT-2/TTT2/tree/v0.13.0b) (2024-02-21)

### Added

- Added migrations between TTT2-versions, some breaking changes could now be migrated instead
- Added a new markerVision module that adds information to a specific point in space to replace the old C4 radar; it is currently used by these builtin weapons (by @TimGoll)
  - C4
  - Radio
  - Beacon
- Binoculars now retain search progress if interrupted. Progress decays based on time since last observed (by @EntranceJew)
- Reworked the way the player camera is handled (by @TimGoll)
  - Added FOV change on speed change
  - Added view bobbing on walking, swimming, falling and strafing
  - Added convars to disable those changes
- Added `draw.Arc` and `draw.ShadowedArc` from TTTC to TTT2 to draw arcs (by @TimGoll und @Alf21)
- Added possibility to cache and remove items, similar to how it is already possible with weapons with `CacheAndStripItems` (by @TimGoll)
- Added an option for weapons to hide the pickup notification by setting `SWEP.silentPickup` to `true` (by @TimGoll)
- Readded global accessors to clientside shop favorites
  - `shop.IsFavorite(equipmentId)`
  - `shop.SetFavoriteState(equipmentId, isFavorite)`
  - `shop.GetFavorites()`
- Added `TTT2FetchAvatar` hook for intercepting avatar URIs (by @EntranceJew)
- Added `draw.DropCacheAvatar` to allow destroying and refreshing an existing avatar, so bots can intercept avatar requests and circumvent the limited unique SteamID64s they're given (by @EntranceJew)
- `weapon_tttbase` changes to correct non-looping animations which affected ADS scoping (by @EntranceJew)
  - Added `SWEP.IdleAnim` to allow specifying an idle animation.
  - Added `SWEP.idleResetFix` to allow the animations for CS:S weapons to automatically be returned to an idle position.
  - Added `SWEP.ShowDefaultViewModel` to prevent a weapon from drawing a ViewModel when set to `false` at all without FOV hacks or Deploy code which has no effect.
- Icon for gameplay menu
- Icon for accessibility menu
- Icon for `Voice & Volume` menu
- Added a new vgui element: `DWeaponPreview_TTT2` to render a player with their equipped weapon (by @TimGoll)
  - Supports any normal weapon that has a `.HoldType` and a `.WorldModel`
  - Supports any weapon that is made with the SWEP Construction Kit (boomerang, melonmine, ...) or made for our custom world model renderer
- Made beacon model and icon unique from decoy (by @EntranceJew)
- Added `SWEP:ClearHUDHelp()` to allow blanking the help text, for dynamically updating help text on equipment (by @EntranceJew)
- Added custom world and view models to some builtin weapons (by @TimGoll)
  - added for: radio, beacon, decoy, binoculars, visualizer
- Added support for easy addition of custom view and world models (by @TimGoll)
  - Added `AddCustomViewModel` to add custom view models
  - Added `AddCustomWorldModel` to add custom world models
  - Added an automatic fix for badly coded addons that break the view model fingers
- Added `ttt_base_placeable` entity that is used to handle any placeable / destroyable entity (by @TimGoll)
  - moved `ttt_c4`, `ttt_health_station`, `ttt_beacon`, `ttt_decoy`, `ttt_radio` and `ttt_cse_proj` to that base
  - also handles pickup of those entities
- Throwables (grenades) now have a `:GetPullTime()` accessor (by @EntranceJew)
- Throwables (grenades) show UI for the amount of time remaining before detonation (fuse time) (by @EntranceJew)
- UI for grenade throw arcs from [colemclaren's TTT fork](https://github.com/colemclaren/ttt/blob/master/addons/moat_addons/lua/weapons/weapon_tttbasegrenade.lua#L293-L353) (integrated by @EntranceJew)
- `gameEffects` library for global effects that are useful, such as starting fires (by @EntranceJew)
- Added weapon pickup sounds when picking up weapons manually (by @TimGoll)

### Changed

- Refactored client shop logic into separate shop-class (by @ZenBre4ker)
  - Enabled shared shop class to buy and check equipment
  - Removed third argument of `TTT2CanOrderEquipment`-Hook, no message is outputted anymore
- dframe_ttt2 panels can now manually enable bindings while they are open (by @ZenBre4ker)
- Binoculars now have a world model that isn't paper towels (by @EntranceJew)
- Decreased shooting accuracy while sprinting or in air (by @TimGoll)
- A player whose weapons are stripped and cached will keep `weapon_ttt_unarmed` which means they keep their crosshair (by @TimGoll)
- Updated the German localization file (by @NickCloudAT)
- Updated the Turkish localization file (by @NovaDiablox)
- Grenades have icons
- Brought `C4`, `defuser`, `flaregun`, `health_station`, `radio` weapons down from upstream (by @a7f3)
- Updated help text for `C4`, `defuser`, `flaregun`, `health_station`, `radio`, `knife`, `phammer`, `push`, and `zm_carry` weapons (by @a7f3)
- Brought down the `EFFECT`s: `crimescene_dummy`, `crimescene_shot`, `pulse_sphere`, `teleport_beamdown`, `teleport_beamup`
- Brought down the `ENT`s: `ttt_basegrenade_proj`, `ttt_carry_handler` (unused), `ttt_firegrenade_proj`, `ttt_smokegrenade_proj`, `ttt_weapon_check`
- Brought down the `SWEP`: `weapon_ttt_stungun`
- Brought down the menu for arming/defusing C4
- Updated and improved Simplified Chinese translation (by @sbzlzh and @TheOnly8Z)
- Improved Simplified Chinese translation（by @TEGTainFan）
- Consolidated hat logic
- Player role selection logic uses `Player:CanSelectRole()` now instead of duplicating logic
- Role avoidance is no longer an option
- All `builtin` weapons can now be configured to drop via `Edit Equipment` (by @EntranceJew)
- Removed redundant checks outside of `SWEP:DrawHelp`, protected only `SWEP:DrawHelp`
- Spectator name labels now use a skin font and scaling (by @EntranceJew)
- The built-in radar now displays distances in meters (by @TimGoll)
- Converted `ttt_ragdoll_pinning` and `ttt_ragdoll_pinning_innocents` into per-role permissions.
- Magneto stick now allows right-clicking to instantly drop something, while left-clicking still releases/throws it.
- Magneto stick now shows tooltips respective to its current state.
- Scoreboard shows non-policing detective results, in sync with the miniscoreboard (by @EntranceJew)
- `ttt_flame` is visible while it is moving (by @EntranceJew)
- `ttt_flame`'s hurtbox is more accurate to its visuals (by @EntranceJew)
- The built-in DNA scanner now displays distances in meters (by @TimGoll)
- Noisy prints are now gated behind various levels of `developer` convar (by @EntranceJew)
- Any warnings developers should fix will now print with stack traces (by @EntranceJew)
- Changed the way the role overhead icon is rendered (by @TimGoll)
  - It now tracks the players head position
  - Rendering order is based on distance, no more weird visual glitches
  - Hidden when observing a player in first person view
- Your own spectator nametag will not display when looking directly up in post-round (by @EntranceJew)
- Made sure the last weapon is selected by default if the current weapon is removed; overwrite `OnRemove` to prevent that (by @TimGoll)
- Changed the way weapon icon caching is working to make sure all weapons always have a cached icon material (by @TimGoll)

### Fixed

- Fixed database now properly saving boolean `false` values (by @ZenBre4ker)
- Fixed cached weapons not being selected after giving them back to the owner (by @TimGoll)
- The roundendscreen can now be closed with the correct Binding (by @ZenBre4ker)
- Fixed last seen player being wrongly visible for every search instead of only public policing role search (by @TimGoll)
- Fixed the crosshair being offcenter on some UI scales (by @TimGoll)
- Fixed to wrong line calculations for wrapped text (by @NickCloudAT)
- Fixed marks library having self zfailing and color issues (by @WardenPotato)
- Fixed `IsPlayer` failing if a non-entity is passed to it (by @TimGoll)
- Fixed draw.Arc when `gmod_mcore_test` is set to 1 (by @WardenPotato)
- Fixed weapon help box width for wide bindings with short descriptions (by @TimGoll)
- Fixed `GM:TTTBodySearchPopulate` using the wrong data variable (by @TimGoll)
- Fixed font initialization to not trip engine font fallback behavior (by @EntranceJew)
- Fixed the decoy producing a wrong colored icon for other teams (by @NickCloudAT)
- Fixed the scoreboard being stuck open sometimes if the inflictor was no weapon (by @TimGoll)
- Fixed door health displaying as a humongous string of decimals (by @EntranceJew)
- Fixed weapons that use the wrong weapon base from throwing errors in the F1 menu (by @TimGoll)

### Removed

- Removed some crosshair related convars and replaced them with other ones, see the crosshair settings menu for details
- Removed DX8/SW models that aren't used
- Removed the convar `ttt_damage_own_healthstation` as it was inconsistent and probably unused as well
- Removed `ttt_fire_fallback`, there's no situation where the fire shouldn't draw anymore.
- Removed `resource.AddFile` calls, server operators should use the workshop version or manually bundle loose files.

### Breaking Changes

- Moved global shared `EquipmentIsBuyable(tbl, ply)` to `shop.CanBuyEquipment(ply, equipmentName)`
  - Returned text and result are now replaced by a statusCode
- Removed use of `ttt_bem_fav` sql-table storing all favorites for steamid and roles
  - They are now stored under `ttt2_shop_favorites` for all users on one pc and all roles
- No more `plymeta:GetAvoidRole(role)` or `plymeta:GetAvoidDetective()`
- Moved global `TEAMBUYTABLE` to `shop.teamBuyTable` and separated `BUYTABLE` into `shop.buyTable` and `shop.globalBuyTable`
  - Use new Accessors `shop.IsBoughtFor(ply, equipmentName)`, `shop.IsGlobalBought(equipmentName)` and `shop.IsTeamBoughtFor(ply, equipmentName)`
  - Use new Setter `shop.SetEquipmentBought(ply, equipmentName)`, `shop.SetEquipmentGlobalBought(equipmentName)` and `shop.SetEquipmentTeamBought(ply, equipmentName)`

## [v0.12.3b](https://github.com/TTT-2/TTT2/tree/v0.12.3b) (2024-01-07)

### Added

- Added some missing vanilla TTT entities into TTT2
- Added debug.print(message)
  - This puts quotation marks around print statements
  - Can handle single values or a sequential table to be printed
  - Can handle `nil` entries in a nearly sequential table
- Added new hooks `TTT2BeaconDetectPlayer` and `TTT2BeaconDeathNotify` to allow preventing / overriding a beacon's player detection & alerts (by @spanospy)
- Added indentation to subsettings in F1 menu (by @TimGoll)

### Changed

- Updated the Turkish localization file (by @NovaDiablox)
- Crosshair now spreads while sprinting instead of being hidden
- Keyhelp and weapon HUD Help now use the global scale factor

### Fixed

- Fixed targetID hints for old addons now correctly working for all entities
- Fixed visualizer having pickup hint even though player is unable to pick up
- Targetid wasn't showing named corpse's role, information which was already present on the scoreboard (by @EntranceJew)
- Damage Scaling now has a help description
- Fixed the database module setting a global variable called `callback` which breaks addons such as PointShop2
- Fixed voicechat keybinds being shown even if voice is disabled
- Coerced ammo types to lowercase for better matching in HUD
- The binocular zoom now uses a DataTable that is not already used by its weaponbase
- Fixed round scoreboard tooltips not being wide enough for their strings (by @EntranceJew)
- Errors when looking at a player's corpse that disconnected (by @EntranceJew)
- Fixed `TTT2FinishedLoading` hook not called on server on hot reload (by @TimGoll)
- Shopeditor now correctly shows resetted and default values

## [v0.12.2b](https://github.com/TTT-2/TTT2/tree/v0.12.2b) (2023-12-20)

### Added

- Added the beacon back into TTT2, an equipment that was disabled long ago in base TTT
  - Can only be bought by policing roles
  - Creates a wallhack in a sphere around it, which is visible to everyone
- Added recognizable badge for `builtin` equipment and roles (by @EntranceJew)
  - Buy Equipment menu has `builtin` indicators, replacing the `(C)` custom marker decorating a majority of equipment
  - `F1 > Edit Equipment` now has `builtin` indicators on equipment
  - Added tooltip to `F1 > Edit Equipment` menu with the equipment's class name.
  - `F1 > Role Settings` now has `builtin` indicators for roles
  - `F1 > Edit Shops` now has `builtin` indicators for roles

### Changed

- Updated the Turkish localization file (by @NovaDiablox)
- Radio can now only be picked up by placer
- Radar now clears existing waypoints when removed or on changing role (by @EntranceJew)
- Comboboxes can now handle numbers and strings as values
  - Defaults work now with numbers
  - OnChange-Callback is called with the correct type for ConVars
- AFK/Idle timer now reads inputs instead of angle/pos checks to circumvent cheese

### Fixed

- Binoculars scan no longer gets interrupted when changing zoom level
- Fixed missing water level icon breaking scoreboard
- DNA Tester works now with more than one fingerprint on a weapon
- TraitorButton config files should now actually work
- Translation strings not rendering on detective's body search mode combobox
- C4 defusal prompt now suggesting the right key
- Disable to unscope from weapons without ironsights
- Fixed typo preventing targetid from showing role icons correctly
- Mitigated issue with CTakeDamageInfo becoming ephemeral outside their hook of origin
- `ttt_game_text` can now properly send to "All except traitors", as described.
- Fixed corpses not listing their kills
- Comboboxes now show correct values for database driven entries
- Database-Callbacks are now called with the correct valuetype

## [v0.12.1b](https://github.com/TTT-2/TTT2/tree/v0.12.1b) (2023-12-12)

### Added

- Added a new `fastutf8` library that provides faster utf8 functions (added by @saibotk, created by @blitmap)
- Added new hooks: `TTT2MapRegisterWeaponSpawns`, `TTT2MapRegisterAmmoSpawns`, `TTT2MapRegisterPlayerSpawns` to allow converting a wider variety of source map ports (by @EntranceJew)

### Fixed

- Fixed the UI being unable to handle wrapping text with non-utf8 languages that do not use ASCII whitespaces (by @TimGoll & @saibotk)
- Fixed ttt_game_text not working due to a refactor
- Fixed dete call HUD being invisible
- Fixed edgecase where undefined killer angle or pos were accessed
- Fixed fallback ammo icon missing
- Fixed a null entity error in the miniscoreboard
- Fixed missing bodysearch information if victim was killed without leaving a trace caused by a weapon hit
- Fixed "body_confirm" MSTACK noise by batching all the kills from a body into one message. (by @EntranceJew)
- Fixed "body_confirm" message sending before corpse confirmation message.

## [v0.12.0b](https://github.com/TTT-2/TTT2/tree/v0.12.0b) (2023-12-11)

### Added

- Added the ability to edit slider numbers directly via an input field by clicking on the number (by @NickCloudAT)
- Added a new way to alter player volume separately from the scoreboard (by @EntranceJew):
  - `VOICE.(Get/Set)PreferredPlayerVoiceVolume` for setting the voice volume instead of `Player:SetVoiceVolumeScale`
  - `VOICE.(Get/Set)PreferredPlayerVoiceMute` for setting the voice mute instead of `Player:SetMuted`
  - `VOICE.UpdatePlayerVoiceVolume` commits / updates the voice setting according to player preferences
- Added client submenu options for clients to change audio settings under `F1 > Gameplay > General` (by @EntranceJew):
  - Added a convar `ttt2_voice_scaling` to control voice volume scaling, options like "power4" or "log" cause the volume scaling to have a greater perceptual impact between discrete volume settings.
  - Added convars `ttt2_voice_duck_spectator` and `ttt2_voice_duck_spectator_amount` to lower spectator voice volume automatically.
    - A value of `0.13` ducks someone's volume at 90% down to effectively 78%, according to the client's scaling mode.
- Added the option for `DButtonTTT2` to have an icon next to the title (by @TimGoll)
- Added a cached equipment item icon to its table as `.iconMaterial` (by @TimGoll)
- Added a new `bodysearch` library that handles the search (by @TimGoll)
- Completely reworked the body search UI (by @TimGoll)
  - new UI that fits the UI rework
  - added player model to UI
  - highlighted player role and team in the UI
  - redesigned data list so that everything can be seen without clicking through a list
  - added more details to list like: water level, ground type, kill distance, kill direction, hit group, last damage amount
  - The UI is now more responsive, it is updated when the server changes states on the body and timers are updated live in the UI
- Added that the healthbar will pulsate when below 25% health. Toggleable in F1 Menu (by @NickCloudAT)
- Added new menu section in F1 menu under `Appearance > Hud Switcher` for HudElement based features (by @NickCloudAT)
- Brought in code files for `ttt_hat_deerstalker`, `weapon_ttt_phammer`, `ttt_flame`, and `weapon_ttt_push`.
- Translated all strings still needed to german (by @NickCloudAT)
- Added new sidebar information, when the scoreboard is open (by @TimGoll)
- Added keybinding information to the bottom of the screen (by @TimGoll)
  - Can be disabled in Appearance->Interface
  - Shows binding name when scoreboard is opened
- Added option to render rotated text on screen (by @TimGoll)
- Added `TTT2GiveFoundCredits` hook for preventing / overriding the transfer of credits from a body to a player (by @Spanospy)
- Added Ukrainian translation from base TTT (by @ErickMaksimets)
- Added Swedish translation from base TTT (by @Kefta)
- Added Turkish translation (by @NovaDiablox)
- Added `ttt_dropclip` to drop loaded ammo from your active weapon. (by @wgetJane, implemented by @EntranceJew)
- Added window flash and noise to alert players they're being revived (by @EntranceJew)
- Added sql database access to panel elements
  - `DNumSliderTTT2`, `DCheckBoxLabelTTT2`, `DComboBoxTTT2`
- Added dashing to propspec (by @TimGoll)
- Added new functions to database module
  - `database.SetDefaultValuesFromItem(accessName, itemName, item)`

### Changed

- Changed sprint stamina to also consume while in air
- Updated Simplified Chinese and Traditional Chinese localization files (by @sbzlzh):
  - Add the missing `L.c4_disarm_t` translation in C4
  - Remove redundant string translations and spaces
  - Added all new translation strings
- Updated file code to read from `data_static` as fallback in new location allowed in .gma (by @EntranceJew)
- Scoreboard now sets preferred player volume and mute state in client's new `ttt2_voice` table (by @EntranceJew)
  - Keyed by steamid64, making it more reliable than UniqueID or the per-session mute and volume levels.
- Changed the body search convars and reworked the UI accordingly (by @TimGoll)
  - Moved `ttt2_confirm_detective_only` and `ttt2_inspect_detective_only` to a new covar: `ttt2_inspect_confirm_mode`
    - mode 0: default mode, normal TTT. Everyone can search and identify corpses. However now a player has to be confirmed first to take credits
    - mode 1: everyone can see information, but only public policing roles can actually confirm bodies
    - mode 2: only public policing roles can see informatiom. They have to confirm bodies so that other people are able to see this information as well
  - to comply with mode 1 and 2 now everyone is able to see in the targetID if a player was searched by a public policing role
- renamed `search_result` to `bodySearchResult` which contains the search result data
- changed the credit text color from yellow to gold (by @TimGoll)
- Updated the disguiser to make it more clear in the HUD if it is enabled or not
- Updated the equipment HUD help boxes in a new style and added missing help boxes (by @TimGoll)
- Changed LMB press behavior in observer mode to iterate backwards through player list instead of slecting a random player (by @TimGoll)
- Improved translation of some Simplified Chinese strings (by @TheOnly8Z)
- Dropping ammo with `ttt_dropammo` drops from reserve ammo instead of your active weapon's clip (by @wgetJane, implemented by @EntranceJew)
- Added item name for `ttt_hat_deerstalker` (by @EntranceJew)
- Changed syncing of database module to use whole tables instead of custom method
- Replaced equipmenteditor syncing with database module
- Replaced internal equipment syncing with database module
- Moved reset buttons onto the left (by @a7f3)
- Added ammo icons to the weapon switch HUD and player status HUD elements (by @EntranceJew)
- Changed the disguiser icon to be more fitting (by @TimGoll)

### Fixed

- Fixed prediction of the sprinting system, for high ping situations (by @saibotk, thanks to @wgetJane)
- Fixed removing the convar change callback in `DComboboxTTT2`, `DCheckBoxLabelTTT2`, `DNumSliderTTT2` (by @saibotk)
- Multiple internal fixes
  - biggest teamkiller award should now work
  - item model caching should now work properly
  - role info popup for traitors should now show teammembers again if the traitor shop is disabled
  - `pon` and `table` libraries got a small fix respectively
  - the shop and roleselection now reference `roles.INNOCENT` instead of the removed `INNOCENT` global, same for `TRAITOR` and `DETECTIVE`
  - Fixed wrong translation % in F1-Menu when changing language (by @NickCloudAT)
- Fixed disguiser breaking UI on hot reload (by @TimGoll)
- Fixed blurred box rendering for boxes not starting at `0,0` (by @TimGoll)
- Fixed spectated entity not being reset properly which can cause issues (by @TimGoll)
- Optimized allocations by using global Vector / Angle when possible.
- Fixed the dynamic armor damage calculation being wrong when damage can only get partially reduced
- Fixed propspec inputs behaving sometimes unexpectedly (by @TimGoll)
- Fixed ComboBoxes not working with integer values (by @NickCloudAT)
- net.SendStream() can now also handle tables larger than 256kB, which exceeded the maximum net receive buffer
- Fixed nil value of SetValue in `DNumSliderTTT2` , `DCheckBoxLabelTTT2`. And fix nil value for boxCache[name] in `PlayerModels` (by @sbzlzh)
- Prevent weapon_tttbase Lua errors with NPCs (by @BuzzHaddaBig in base TTT)
- Fix miniscoreboard HUD from showing confirmed players that switched to spectator as having been revived (by @EntranceJew)

### Deprecated

- Deprecated `AccessorFuncDT()`, Addons should remove the function call and replace `DTVar()` calls with `NetworkVar()`

### Removed

- Removed `ttt_confirm_death` and `ttt_call_detective` as they are now handled via proper net messages
- Removed spectator texts from the UI in favor of the new key binding information (by @TimGoll)
- Removed double tap sprinting, for easier prediction handling (by @saibotk)
- Removed explicit "Sprint" key bind, please use the GMod native sprint key binding (by @saibotk)
- Removed unused clientside `Player.preventSprint` flag (by @saibotk)

## [v0.11.7b](https://github.com/TTT-2/TTT2/tree/v0.11.7b) (2023-08-27)

### Added

- Added a new font in default_skin.lua to fit the localization (by @Satton2)
- Fixed knife death effect being permanently applied on every following death
- Added `PANEL:MakeTextEntry(data)` to `DFormTTT2` for strings or string-backed cvars (by @EntranceJew)
- Allow admin spectators to enter "Spawn Edit" mode. (by @EntranceJew)
- Added cvar `ttt2_bots_lock_on_death` (default: 0) to prevent bots from causing log-spam while wandering as spectators. (by @EntranceJew)
- Added `TTT2ModifyFinalRoles` hook for last minute opportunity to override role distribution prior to them being announced for the first time (by @EntranceJew)
- `weapon_tttbase`:
  - Added `SWEP:ShouldRemove` to facilitate intercepting `SWEP:Remove` (by @EntranceJew)
  - Added `SWEP.damageScaling` for weapons that utilize `ShootBullet` (by @EntranceJew)
- Edit Equipment Menu
  - `AllowDrop` can now be overridden per-weapon (by @EntranceJew)
  - `Kind` can now be overridden per-weapon (by @EntranceJew)
  - `overrideDropOnDeath` now permits forcing weapons to be dropped instead of removed on death (by @EntranceJew)
  - "Damage Scaling" editable under "Balance Settings" (by @EntranceJew)
- `vgui.CreateTTT2Form` passes the name on so that it can be accessed via `Panel:GetName()` (by @EntranceJew)
- Added two GAMEMODE hooks to provide the ability for additional addons to extend role/equipment menus.
  - `GM:TTT2OnEquipmentAddToSettingsMenu(equipment, parent)`
    - Called after `ITEM:AddToSettingsMenu(parent)`.
  - `GM:TTT2OnRoleAddToSettingsMenu(role, parent)`
    - Called after `ROLE:AddToSettingsMenu(parent)`

### Changed

- `weapon_tttbase`:
  - Removal of `SWEP.IronSightsTime` as it was completely unused and conflicts with a networked value intended for the same purpose
  - Commented-out default values for `SWEP.IronSightsPos` and `SWEP.IronSightsAng` to match vanilla TTT behaviour
    - SWEPs can still use these names as normal, they just don't have a base value to inherit anymore
- Updated Russian and English localization files (by @Satton2):
  - Updated strings in English localization file
  - Localized outdated and new strings into Russian
- Updated all localization files (by @Satton2):
  - Added missing and new strings
  - Marked (out-) updated strings
  - Removed some duplicated strings
  - Removed some old unused strings
  - Fixed some broken source strings (line names)
- Simplified Chinese and Traditional Chinese localization updates (by @sbzlzh):
  - Update Simplified Chinese Translation
  - Improve translation (by @TheOnly8Z)
- Localization parameters for `{walkkey} + {usekey}` prompts made into the predominant style.

### Fixed

- Fixed hotreload of TTT2 roles library by a fresh reinitialization
- Fixed a wrong localization line call in roles.lua (by @Satton2)
- Fixed +zoom bind
- Fixed ttt_quickslot command
- Fixed an issue in `table.GetEqualEntryKeys` when nil is provided instead of a table. (by @sbzlzh):
  - This fixes spawn problems on maps with invalid spawn points
  - This fixes errors in the F1 Menu language selection
- Fixed the check for dynamic armor being inverted (`1` disabled it, `0` enabled it)
- Fixed two unmatched ConVars in performance menu (by @NickCloudAT)
- Fixed Round End Scoreboard (Round Begin) error if a player disconnected while round with no score events (by @NickCloudAT)
- Fixed behavior of `entspawn.SpawnRandomAmmo` to produce non-deagle ammo. (by @NickCloudAT, mostly)

## [v0.11.6b](https://github.com/TTT-2/TTT2/tree/v0.11.6b) (2022-09-25)

### Changed

- Fixed and updated the Chinese translation file (by @sbzlzh)
- Updated Japanese translation (by @westooooo)
- Updated Simplified and Traditional Chinese (by @TEGTianFan)
- Add placeholder message to the ingame ttt2 guide (F1 Menu)

### Fixed

- Fixed the spawn editor tool not having a TargetID in some scenarios by always rendering the 'ttt_spawninfo_ent' (by @NickCloudAT)
- Roleselection for a lot of roles now considers all possible subroles one after another
- Fixed portuguese translation of the equipment editor not working

## [v0.11.5b](https://github.com/TTT-2/TTT2/tree/v0.11.5b) (2022-08-21)

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
- Added convars to modify how fall damage is applied:
  - `ttt2_falldmg_enable (default: 1)` toggles whether or not to apply fall damage at all
  - `ttt2_falldmg_min_velocity (default: 450)` sets the minimum velocity threshold for fall damage to occur
  - `ttt2_falldmg_exponent (default: 1.75)` sets the exponent to increase fall damage in relation to velocity
  - All these convars can also be adjusted in the F1->Administration->Player Settings menu
- Added portuguese translation
- Added a `database` library, that handles shared Interaction with the sql database

### Breaking Changes

- Reworked Dropdowns Panel `DComboBoxTTT2` itself
  - `PANEL:AddChoice(title, value, select, icon, data)` now uses the second argument as value string for setting convars, use the fifth argument for special data instead
  - `PANEL:ChooseOption(title, index, ignoreConVar)` is deprecated and no longer chooses the displayed text, only per index
- Reworked our simplified Dropdowns MakePanel `PANEL:MakeComboBox(data)` version
  - `data.OnChange(value, additionalData, comboBoxPanel)` is now called with the two important arguments at first. They are the value that e.g. convars are set, the additionalData and the Panel

### Changed

- Corrected incorrect translation (by @sbzlzh)
- Optimized damage indicator vgui images to be smaller
- Improved hotreload of TTT2 roles library with RoleList not being global

### Fixed

- Fixed addon compatibility checker fussing over disabled addons
- Fixed ammo entities blocking +use traces
- Fixed double call of `GM:TTT2UpdateTeam`, when a role change leads to a team change

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

- Added four new Karma multipliers as role variables. They are applied **after** all other Karma calculations are done
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
- Remove GetWeapons and HasWeapon overrides (see <https://github.com/Facepunch/garrysmod/pull/1648>)
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
- Fix GetEyeTrace override (see <https://github.com/Facepunch/garrysmod/pull/1647>)
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
