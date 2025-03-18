---
-- @section changes

-- some micro-optimizations (localizing globals)
local os = os
local hook = hook
local table = table

---
-- @realm client
-- @internal
local changesVersion = CreateConVar("changes_version", "v0.0.0.0", FCVAR_ARCHIVE)

local changes, currentVersion

---
-- Adds a change into the changes list
-- @param string version
-- @param string text
-- @param[opt] number date the date when this update got released
-- @realm client
function AddChange(version, text, date)
    changes = changes or {}

    -- adding entry to table
    -- if no date is given, a negative index is stored as secondary sort parameter
    table.insert(
        changes,
        1,
        { version = version, text = text, date = date or (-1 * (#changes + 1)) }
    )

    currentVersion = version
end

---
-- Creates the changes list
-- @realm client
-- @internal
function CreateChanges()
    if changes then
        return
    end

    changes = {}

    AddChange(
        "TTT2 Base - v0.3.5.6b",
        [[
        <ul>
            <li><b>many fixes</b></li>
            <li>enabled picking up grenades in prep time</li>
            <li>roundend scoreboard fix</li>
            <li>disabled useless prints that have spammed the console</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.5.7b",
        [[
        <ul>
            <li><b>code optimization</b></li>
            <br />
            <li>added different CVars</li>
            <br />
            <li>fixed loadout and model issue on changing the role</li>
            <li>bugfixes</li>
            <br />
            <li>removed <code>PLAYER:UpdateRole()</code> function and hook <code>TTT2RoleTypeSet</code></li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.5.8b",
        [[
        <ul>
            <li><b>selection system update</b></li>
            <br />
            <li>added different ConVars</li>
            <li>added possibility to force a role in the next roleselection</li>
            <br />
            <li>bugfixes</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.6b",
        [[
        <ul>
            <li>new <b>networking system</b></li>
            <br />
            <li>added <b>gs_crazyphysics detector</b></li>
            <li>added RoleVote support</li>
            <li>added new multilayed icons (+ multilayer system)</li>
            <li>added credits</li>
            <li>added changes window</li>
            <li>added <b>detection for registered incompatible add-ons</b></li>
            <li>added autoslay support</li>
            <br />
            <li>karma system improvement</li>
            <li>huge amount of bugfixes</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.7b",
        [[
        <ul>
            <li>added hook <code>TTT2ToggleRole</code></li>
            <li>added <code>GetActiveRoles()</code></li>
            <br />
            <li>fixed TTT spec label issue</li>
            <br />
            <li>renamed hook <code>TTT_UseCustomPlayerModels</code> into <code>TTTUseCustomPlayerModels</code></li>
            <li>removed <code>Player:SetSubRole()</code> and <code>Player:SetBaseRole()</code></li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.7.1b",
        [[
        <ul>
            <li>added possibility to disable roundend if a player is reviving</li>
            <li>added own Item Info functions</li>
            <li>added debugging function</li>
            <li>added TEAM param <code>.alone</code></li>
            <li>added possibility to set the cost (credits) for any equipment</li>
            <li>added <code>Player:RemoveEquipmentItem(id)</code> and <code>Player:RemoveItem(id)</code> / <code>Player:RemoveBought(id)</code></li>
            <li>added possibility to change velocity with hook <code>TTT2ModifyRagdollVelocity</code></li>
            <br />
            <li>improved external icon addon support</li>
            <li>improved binding system</li>
            <br />
            <li>fixed loadout bug</li>
            <li>fixed loadout item reset bug</li>
            <li>fixed respawn loadout issue</li>
            <li>fixed bug that items were removed on changing the role</li>
            <li>fixed search icon display issue</li>
            <li>fixed model reset bug on changing role</li>
            <li>fixed <code>Player:GiveItem(...)</code> bug used on round start</li>
            <li>fixed dete glasses bug</li>
            <li>fixed rare corpse bug</li>
            <li>fixed Disguiser</li>
            <li>Some more small fixes</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.7.2b",
        [[
        <ul>
            <li>reworked the <b>credit system</b> (Thanks to Nick!)</li>
            <li>added possibility to override the init.lua and cl_init.lua file in TTT2</li>
            <br />
            <li>fixed server errors in combination with TTT Totem (now, TTT2 will just not work)</li>
            <li>fixed ragdoll collision server crash (issue is still in the normal TTT)</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.7.3b",
        [[
        <ul>
            <li>reworked the <b>selection system</b> (balancing and bugfixes)</li>
            <br />
            <li>fixed playermodel issue</li>
            <li>fixed toggling role issue</li>
            <li>fixed loadout doubling issue</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.7.4b",
        [[
        <ul>
            <li>fixed playermodel reset bug (+ compatibility with PointShop 1)</li>
            <li>fixed external HUD support</li>
            <li>fixed credits bug</li>
            <li>fixed detective hat bug</li>
            <li>fixed selection and jester selection bug</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.8b",
        [[
        <ul>
            <li>added new TTT2 Logo</li>
            <li>added ShopEditor missing icons (by Mineotopia)</li>
            <br />
            <li><b>reworked weaponshop → ShopEditor</b></li>
            <li>changed file based shopsystem into sql</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.8.1b",
        [[
        <ul>
            <li>fixed credit issue in ShopEditor (all Data will load and save correct now)</li>
            <li>fixed item credits and minPlayers issue</li>
            <li>fixed radar, disguiser and armor issue in ItemEditor</li>
            <li>fixed shop syncing issue with ShopEditor</li>
            <br />
            <li>small performance improvements</li>
            <li>cleaned up some useless functions</li>
            <li>removed <code>ALL_WEAPONS</code> table (SWEP will cache the initialized data now in it's own table / entity data)</li>
            <li>some function renaming</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.8.2b",
        [[
        <ul>
            <li>added <b>russian translation</b> (by Satton2)</li>
            <li>added <code>.minPlayers</code> indicator for the shop</li>
            <br />
            <li>replaced <code>.globalLimited</code> param with <code>.limited</code> param to toggle whether an item is just one time per round buyable for each player</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.8.3b",
        [[
        <ul>
            <li>ammoboxes will store the correct amount of ammo now
            <li>connected <b>radio commands</b> with <b>scoreboard #tagging</b> (https://github.com/Exho1/TTT-ScoreboardTagging/blob/master/lua/client/ttt_scoreboardradiocmd.lua)</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.3.9b",
        [[
        <ul>
            <li>reimplemented all these nice unaccepted PullRequest for TTT on GitHub:
                <ul>
                    <li><b>Custom Crosshairs</b> (<code>F1 → Settings</code>): 'https://github.com/Facepunch/garrysmod/pull/1376/' by nubpro</li>
                    <li>Performance improvements with the help of 'https://github.com/Facepunch/garrysmod/pull/1287' by markusmarkusz and Alf21</li>
                </ul>
            </li>
            <br />
            <li>added possibility to use <b>random shops!</b> (<code>ShopEditor → Options</code>)</li>
            <li>balanced karma system (Roles that are aware of their teammates can't earn karma anymore. This will lower teamkilling)</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.4.0b",
        [[
        <ul>
            <li>ShopEditor:
                <ul>
                    <li>added <code>.notBuyable</code> param to hide item in the shops</li>
                    <li>added <code>.globalLimited</code> and <code>.teamLimited</code> params to limit equipment</li>
                </ul>
            </li>
            <br />
            <li>added <b>new shop</b> (by tkindanight)</li>
                <ul>
                    <li>you can toggle the shop everytime (your role doesn't matter)</li>
                    <li>the shop will update in real time</li>
                </ul>
            </li>
            <br />
            <li>added new icons</li>
            <li>added warming up for <b>randomness</b> to make things happen... yea... random</li>
            <li>added auto-converter for old items</li>
            <br />
            <li>decreased speed modification lags</li>
            <li>improved performance</li>
            <li>implemented <b>new item system!</b> TTT2 now supports more than 16 passive items!</li>
            <li>huge amount of fixes</li>
        </ul>
    ]]
    )

    AddChange(
        "TTT2 Base - v0.5.0b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added new <b>HUD system</b></li>
                <ul>
                    <li>Added <b>HUDSwitcher</b> (<code>F1 → Settings → HUDSwitcher</code>)</li>
                    <li>Added <b>HUDEditor</b> (<code>F1 → Settings → HUDSwitcher</code>)</li>
                    <li>Added old TTT HUD</li>
                    <li>Added <b>new</b> PureSkin HUD, an improved and fully integrated new HUD</li>
                        <ul>
                            <li>Added a Miniscoreboard / Confirm view at the top</li>
                            <li>Added support for SubRole informations in the player info (eg. used by TTT Heroes)</li>
                            <li>Added a team icon to the top</li>
                            <li>Redesign of all other HUD elements...</li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>Added possibility to give every player his <b>own random shop</b></li>
            <li>Added <b>sprint</b> to TTT2</li>
            <li>Added a <b>drowning indicator</b> into TTT2</li>
            <li>Added possibility to toggle auto afk</li>
            <li>Added possibility to modify the time a player can dive</li>
            <li>Added parameter to the bindings to detect if a player released a key</li>
            <li>Added possibility to switch between team-synced and individual random shops</li>
            <li>Added some nice <b>badges</b> to the scoreboard</li>
            <li>Added a sql library for saving and loading specific elements (used by the HUD system)</li>
            <li>Added and fixed Bulls draw lib</li>
            <li>Added an improved player-target add-on</li>
        </ul>
        <br />
        <h2><b>Changed:</b></h2>
        <ul>
            <li>Changed convar <code>ttt2_confirm_killlist</code> to default <code>1</code></li>
            <li>Improved the changelog (as you can see :D)</li>
            <li>Improved Workshop page :)</li>
            <li>Reworked <b>F1 menu</b></li>
            <li>Reworked the <b>slot system</b> (by LeBroomer)</li>
                <ul>
                    <li>Amount of carriable weapons are customizable</li>
                    <li>Weapons won't block slots anymore automatically</li>
                    <li>Slot positions are generated from weapon types</li>
                </ul>
            </li>
            <li>Reworked the <b>ROLES</b> system</li>
                <ul>
                    <li>Roles can now be created like weapons utilizing the new roles lua module</li>
                    <li>They can also inherit from other roles</li>
                </ul>
            </ul>
            <li>Improved the MSTACK to also support messages with images</li>
            <li>Confirming a player will now display an imaged message in the message stack</li>
        </ul>
        <br />
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed TTT2 binding system</li>
            <li>Fixed Ammo pickup</li>
            <li>Fixed karma issue with detective</li>
            <li>Fixed DNA Scanner bug with the radar</li>
            <li>Fixed loading issue in the items module</li>
            <li>Fixed critical bug in the process of saving the items data</li>
            <li>Fixed the Sidekick color in corpses</li>
            <li>Fixed bug that detective were not able to transfer credits</li>
            <li>Fixed kill-list confirm role syncing bug</li>
            <li>Fixed crosshair reset bug</li>
            <li>Fixed confirm button on corpse search still showing after the corpse was confirmed or when a player was spectating</li>
            <li>Fixed draw.GetWrappedText() containing a ' ' in its first row</li>
            <li>Fixed shop item information not readable when the panel is too small -> added a scrollbar</li>
            <li>Fixed shop item being displayed as unbuyable when the items price is set to 0 credits</li>
            <li>Other small bugfixes</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 03, day = 03 })
    )

    AddChange(
        "TTT2 Base - v0.5.1b",
        [[
        <h2>Improved:</h2>
        <ul>
            <li>Improved the binding library and extended the functions</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed target reset bug</li>
            <li>Fixed / Adjusted hud element resize handling</li>
            <li>Fixed strange weapon switch error</li>
            <li>Fixed critical model reset bug</li>
            <li>Fixed hudelements borders, childs will now extend the border of their parents</li>
            <li>Fixed mstack shadowed text alpha fadeout</li>
            <li>Fixed / Adjusted scaling calculations</li>
            <li>Fixed render order</li>
            <li>Fixed "player has no SteamID64" bug</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 03, day = 05 })
    )

    AddChange(
        "TTT2 Base - v0.5.2b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added spectator indicator in the Miniscoreboard</li>
            <li>Added icons with higher resolution (native 512x512)</li>
            <li>Added Heroes badge</li>
            <li>Added HUD documentation</li>
            <li>Added some more hooks to modify TTT2 externally</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Improved the project structure / <b>Code refactoring</b></li>
            <li>Improved HUD sidebar of items / perks</li>
            <li>Improved HUD loading</li>
            <li>Improved the sql library</li>
            <li>Improved item handling and item converting</li>
            <li><b>Improved performance / performance optimization</b></li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed SetModel bugs</li>
            <li>Fixed some model-selector bugs</li>
            <li>Fixed a sprint bug</li>
            <li>Fixed some ConVars async bugs</li>
            <li>Fixed some shopeditor bugs</li>
            <li>Fixed an HUD scaling bug</li>
            <li>Fixed old_ttt HUD</li>
            <li>Fixed border's alpha value</li>
            <li>Fixed confirmed player ordering in the Miniscoreboard</li>
            <li><b>Fixed <u>critical</u> TTT2 bug</b></li>
            <li><b>Fixed a crash that randomly happens in the <u>normal TTT</u></b></li>
            <li>Fixed PS2 incompatibility</li>
            <li>Fixed spectator bug with Roundtime and Haste Mode</li>
            <li>Fixed many small HUD bugs</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 04, day = 32 })
    )

    AddChange(
        "TTT2 Base - v0.5.3b",
        [[
        <h2>New:</h2>
        <li>Added a <b>Reroll System</b> for the <b>Random Shop</b></li>
        <ul>
            <li>Rerolls can be done in the Traitor Shop similar to the credit transferring</li>
            <li>Various parameters in the <b>ShopEditor</b> are possible (reroll, cost, reroll per buy)</li>
            <li>Added the reroll possibility for the <b>Team Random Shop</b> (very funny)</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Added a separate slot for class items</li>
            <li>Added help text to the <b>"Not Alive"-Shop</b></li>
            <li>Minor design tweaks</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed critical crash issue (ty to @nick)</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 05, day = 09 })
    )

    AddChange(
        "TTT2 Base - v0.5.4b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added a noTeam indicator to the HUD</li>
            <li>intriduced a new drowned death symbol</li>
            <li><i>ttt2_crowbar_shove_delay<i> is now used to set the crowbar attack delay</li>
            <li>introduced a status system alongside the perk system</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Included LeBroomer in the TTT2 logo</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed a problem with colors (seen with sidekick death confirms)</li>
            <li>Fixed the team indicator when in spectator mode</li>
            <li>Credits now can be transfered to everyone, this fixes a bug with the spy</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 06, day = 18 })
    )

    AddChange(
        "TTT2 Base - v0.5.5b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added convars to hide scoreboard badges</li>
            <li>A small text that explains the spectator mode</li>
            <li>Weapon pickup notifications are now moved to the new HUD system</li>
            <li>Weapon pickup notifications support now pure_skin</li>
            <li>New shadowed text rendering with font mipmapping</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Refactored the code to move all language strings into the language files</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed the reroll per buy bug</li>
            <li>Fixed HUD switcher bug, now infinite amounts of HUDs are supported</li>
            <li>Fixed the outline border of the sidebar beeing wrong</li>
            <li>Fixed problem with the element restriction</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 07, day = 07 })
    )

    AddChange(
        "TTT2 Base - v0.5.6b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Marks module</li>
            <li>New sprint and stamina hooks for add-ons</li>
            <li>Added a documentation of TTT2</li>
            <li>Added GetColumns function for the scoreboard</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Restrict HUD element movement when element is not rendered</li>
            <li>Sidebar icons now turn black if the hudcolor is too bright</li>
            <li>Binding functions are no longer called when in chat or in console</li>
            <li>Improved the functionality of the binding system</li>
            <li>Improved rendering of overhead role icons</li>
            <li>Improved equipment searching</li>
            <li>Improved the project structure</li>
            <li>Improved shadow color for dark texts</li>
            <li>Some small performance improvements</li>
            <li>Removed some unnecessary debug messages</li>
            <li>Updated the TTT2 .fgd file</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed the shop bug that occured since the new GMod update</li>
            <li>Fixed search sometimes not working</li>
            <li>Fixed a shop reroll bug</li>
            <li>Fixed GetAvoidDetective compatibility</li>
            <li>Fixel two cl_radio errors</li>
            <li>Fixed animation names</li>
            <li>Fixed wrong karma print</li>
            <li>Fixed a language module bug</li>
            <li>Fixed an inconsistency in TellTraitorsAboutTraitors function</li>
            <li>Fixed the empty weaponswitch bug on first spawn</li>
            <li>Fixed an error in the shadow rendering of a font</li>
            <li>Small bugfixes</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 09, day = 03 })
    )

    AddChange(
        "TTT2 Base - v0.5.6b-h1 (Hotfix)",
        [[
        <h2>Fixed:</h2>
        <ul>
            <li>Traitor shop bug (caused by the september'19 GMod update)</li>
            <li>ShopEditor bugs and added a response for non-admins</li>
            <li>Glitching head icons</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 09, day = 06 })
    )

    AddChange(
        "TTT2 Base - v0.5.7b",
        [[
        <h2>New:</h2>
        <ul>
            <li>New Loadout Give/Remove functions to cleanup role code and fix item raceconditions</li>
            <ul>
                <li>Roles now always get their equipment on time</li>
                <li>On role changes, old equipment gets removed first</li>
            </ul>
            <li>New armor system</li>
            <ul>
                <li>Armor is now displayed in the HUD</li>
                <li>Previously it was a simple stacking percetual calculation, which got stupid with multiple armor effects. Three times armoritems with 70% damage each resulted in 34% damage recveived</li>
                <li>The new system has an internal armor value that is displayed in the HUD</li>
                <li>It works basically the same as the vanilla system, only the stacking is a bit different</li>
                <li>Reaching an armor value of 50 (by default) increases its strength</li>
                <li>Armor depletes over time</li>
            </ul>
            <li>Allowed items to be bought multiple times, if <i>.limited</i> is set to <i>true</i></li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Dynamic loading of role icons</li>
            <li>Improved performance slightly</li>
            <li>Improved code consistency</li>
            <li>Caching role icons in <i>ROLE.iconMaterial</i> to prevent recreation of icon materials</li>
            <li>Improved bindings menu and added language support</li>
            <li>Improved SQL module</li>
            <li>Improved radar icon</li>
            <li>Made parameterized overheadicon function callable</li>
            <li>Improved codereadablity by refactoring huge parts</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed sometimes unavailable shops even if set</li>
            <li>Team confirmation convar issue in network-syncing</li>
            <li>Reset radar timer on item remove, fixes problems with rolechanges</li>
            <li>Fixed an exploitable vulnerability</li>
        </ul>
    ]],
        os.time({ year = 2019, month = 10, day = 06 })
    )

    AddChange(
        "TTT2 Base - v0.6b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added new weapon switch system</li>
            <ul>
                <li>Players can now manually pick up focused weapons</li>
                <li>If the slot is blocked, the current weapon is automatically dropped</li>
                <li>Added new convar to prevent auto pickup: <i>ttt_weapon_autopickup (default: 1)</i></li>
            </ul>
            <li>Added new targetID system</li>
            <ul>
                <li>Looking at entities shows now more detailed ans structured info</li>
                <li>Integrated into the new weapon switch system</li>
                <li>Supports all TTT entities by default</li>
                <li>Supports doors</li>
                <li>Added a new hook to add targetID support to custom entities: <i>TTTRenderEntityInfo</i></li>
            </ul>
            <li>Added the outline module for better performance</li>
            <li><i>TTT2DropAmmo</i> hook to prevent/change the ammo drop of a weapon</li>
            <li>Added new HUD element: the eventpopup</li>
            <li>Added a new <i>TTT2PlayerReady</i> hook that is called once a player is ingame and can move around</li>
            <li>Added new removable decals</li>
            <li>Added a new default loading screen</li>
            <li>Added new convar to allow Enhanced Player Model Selector to overwrite TTT2 models: <i>ttt_enforce_playermodel (default: 1)</i></li>
            <li>Added new hooks to jam the chat</li>
            <li>Allow any key double tap sprint</li>
            <li>Regenerate sprint stamina after a delay if exhausted</li>
            <li>Moved voice bindings to the TTT2 binding system (F1 menu)</li>
            <li>Added new voice and text chat hooks to prevent the usage in certain situations</li>
            <li>Added new client only convar (F1->Gameplay->Hold to aim) to change to a "hold rightclick to aim" mode</li>
            <li>Added a new language file system for addons, language files have to be in <i>lua/lang/<the_language>/<addon>.lua</i></li>
            <li>New network data system including network data tables to better manage state updates on different clients</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Microoptimization to improve code performance</li>
            <li>Improved the icon rendering for the pure_skin HUD</li>
            <li>Improved multi line text rendering in the MSTACK</li>
            <li>Improved role color handling</li>
            <li>Improved language (german, english, russian)</li>
            <li>Improved traitor buttons</li>
            <ul>
                <li>By default only players in the traitor team can use them</li>
                <li>Each role has a convar to enable traitor button usage for them - yes, innocents can use traitor buttons if you want to</li>
                <li>There is an admin mode to edit each button individually</li>
                <li>Uses the new targetID</li>
            </ul>
            <li>Improved damage indicator overlay with customizability in the F1 settings</li>
            <li>Improved hud help font</li>
            <li>Added a new flag to items to hide them from the bodysearch panel</li>
            <li>Moved missing hardcoded texts to language files</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed a bug with baserole initialization</li>
            <li>Small other bugfixes</li>
            <li>added legacy supported for limited items</li>
            <li>Fixed C4 defuse for non-traitor roles</li>
            <li>Fixed radio, works now for all roles</li>
            <li>Restricted huds are hidden in HUD Switcher</li>
            <li>Fixed ragdoll skins (hairstyles, outfits, ...)</li>
            <li>Prevent give_equipment timer to block the shop in the next round</li>
            <li>Fix sprint consuming stamina when there is no move input</li>
            <li>Fix confirmation of players with no team</li>
            <li>Fix voice still sending after death</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 02, day = 16 })
    )

    AddChange(
        "TTT2 Base - v0.6.1b",
        [[
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed a bug with the spawn wave interval</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 02, day = 17 })
    )

    AddChange(
        "TTT2 Base - v0.6.2b",
        [[
        <h2>Fixed:</h2>
        <ul>
            <li>Increased the maximum number of roles that can be used. (Fixes weird role issues with many roles installed)</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 03, day = 1 })
    )

    AddChange(
        "TTT2 Base - v0.6.3b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added a Polish translation (Thanks @Wukerr)</li>
            <li>Added fallback icons for equipment</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fix <i>body_found</i> for bots</li>
            <li>Fix NWVarSyncing when using <i>TTT2NET:Set()</i></li>
        </ul>
    ]],
        os.time({ year = 2020, month = 03, day = 05 })
    )

    AddChange(
        "TTT2 Base - v0.6.4b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added an Italian translation (Thanks @PinoMartirio)</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed a rare bug where the player had the default GMod sprint on top of the TTT2 sprint</li>
            <li>Fixed some convars that did not save in ulx by removing them all from the gamemode file</li>
            <li>Fixed a bug that happened when TTT2 is installed but not the active gamemode</li>
            <li>Fixed a few Polish language strings</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 04, day = 03 })
    )

    AddChange(
        "TTT2 Base - v0.7.0b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added two new convars to change the behavior of the armor</li>
            <li>Added two new convars to change the confirmation behaviour</li>
            <li>Added essential items: 8 different types of items that are often used in other addons. You can remove them from the shop if you don't like them.</li>
            <li>Added a new HUD element to show information about an ongoing revival to the player that is revived</li>
            <li>Added the possibility to change the radar time</li>
            <li>Added a few new modules that are used by TTT2 and can be used by different addons</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Updated addon checker list</li>
            <li>Migrated the HUDManager settings to the new network sync system</li>
            <li>Reworked the old DNA Scanner and replaced it with an improved version</li>
                <ul>
                    <li>New world- and viewmodel with an interactive screen</li>
                    <li>Removed the overcomplicated UI menu (simple handling with default keys instead)</li>
                    <li>The new default scanner behavior shows the direction and distance to the target</li>
                </ul>
            <li>Changed TargetID colors for confirmed bodies</li>
            <li>Improved the player revival system</li>
                <ul>
                    <li>Revive makes now sure the position is valid and the player is not stuck in the wall</li>
                    <li>All revival related messages are now localized</li>
                    <li>Integration with the newly added revival HUD element</li>
                </ul>
            <li>Improved the player spawn handling, no more invalid spawn points where a player will be stuck or spawn in the air and fall to their death</li>
            <li>Refactored the role selection code to reside in its own module and cleaned up the code</li>
            <li>Improved the round end screen to support longer round end texts</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed round info (the top panel with the miniscoreboard) being displayed in other HUDs</li>
            <li>Fixed an error with the pickup system in singleplayer</li>
            <li>Fixed propsurfing with the magneto stick</li>
            <li>Fixed healthstation TargetID text</li>
            <li>Fixed keyinfo for doors where no key can be used</li>
            <li>Fixed role selection issues with subroles not properly replacing their baserole etc</li>
            <li>Fixed map lock/unlock trigger of doors not updating targetID</li>
            <li>Fixed roles having sometimes the wrong radar color</li>
            <li>Fixed miniscoreboard update issue and players not getting shown when entering force-spec mode</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 06, day = 01 })
    )

    AddChange(
        "TTT2 Base - v0.7.1b",
        [[
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed max roles / max base roles interaction with the roleselection. Also does not crash with values != 0 anymore.</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 06, day = 02 })
    )

    AddChange(
        "TTT2 Base - v0.7.2b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added Hooks to the targetID system to modify the displayed data</li>
            <li>Added Hooks to interact with door destruction</li>
            <li>Added a new function to force a new radar scan</li>
            <li>Added a new convar to change the default radar time for players without custom radar times: <i>ttt2_radar_charge_time</i></li>
            <li>Added a new client ConVar <i>ttt_crosshair_lines</i> to add the possibility to disable the crosshair lines</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Moved the disguiser icon to the status system to be only displayed when the player is actually disguised</li>
            <li>Reworked the addonchecker and added a command to execute the checker at a later point</li>
            <li>Updated Italian translation (Thanks @ThePlatinumGhost)</li>
            <li>Removed Is[ROLE] functions of all roles except default TTT ones</li>
            <li>ttt_end_round now resets when the map changes</li>
            <li>Reworked the SWEP HUD help (legacy function SWEP:AddHUDHelp is still supported)</li>
            <li>Players who disconnect now leave a corpse</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed shadow texture of the "Pure Skin HUD" for low texture quality settings</li>
            <li>Fixed inno subrole upgrading if many roles are installed</li>
            <li>Fixed and improved the radar role/team modification hook</li>
            <li>Fixed area portals on servers for destroyed doors</li>
            <li>Fixed revive fail function reference reset</li>
            <li>Removed the DNA Scanner hudelement for spectators</li>
            <li>Fixed the image in the confirmation notification whenever a bot's corpse gets identified</li>
            <li>Fixed bad role selection due to RNG reseeding</li>
            <li>Fixed missing role column translation</li>
            <li>Fixed viewmodel not showing correct hands on model change</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 06, day = 26 })
    )

    AddChange(
        "TTT2 Base - v0.7.3b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added a new custom file loader that loads lua files from <i>lua/terrortown/autorun/</i></li>
            <ul>
                <li>it basically works the same as the native file loader</li>
                <li>there are three subfolders: <i>client</i>, <i>server</i> and <i>shared</i></li>
                <li>the files inside this folder are loaded after all TTT2 gamemode files and library extensions are loaded</li>
            </ul>
            <li>Added Spanish version for base addon   (by @Tekiad and @DennisWolfgang)</li>
            <li>Added Chinese Simplified translation (by @TheOnly8Z)</li>
            <li>Added double-click buying</li>
            <li>Added a default avatar for players and an avatar for bots</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>Roles are now only getting synced to clients if the role is known, not just the body being confirmed</li>
            <li>Airborne players can no longer replenish stamina</li>
            <li>Detective overhead icon is now shown to innocents and traitors</li>
            <li>moved language files from <i>lua/lang/</i> to <i>lua/terrortown/lang</i></li>
            <li>Stopped teleporting players to players they're not spectating if they press the "duck"-Key while roaming</li>
            <li>Moved shop's equipment list generation into a coroutine</li>
            <li>Removed TTT2PlayerAuthedCacheReady hook</li>
            <li>Internal changes to the b-draw library for fetching avatars</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed death handling spawning multiple corpses when killed multiple times in the same frame</li>
            <li>Radar now shows bombs again, that do not have the team property set</li>
            <li>Fix HUDManager not saving forcedHUD and defaultHUD values</li>
            <li>Fixed wrong parameter default in <i>EPOP:AddMessage</i> documentation</li>
            <li>Fixed shop switching language issue</li>
            <li>Fixed shop refresh activated even not buyable equipments</li>
            <li>Fixed wrong shop view displayed as forced spectator</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 08, day = 09 })
    )

    AddChange(
        "TTT2 Base - v0.7.4b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added ConVar to toggle double-click buying</li>
            <li>Added Japanese translation (by @Westoon)</li>
            <li>Added <i>table.ExtractRandomEntry(tbl, filterFn)</i> function</li>
            <li>Added a team indicator in front of every name in the scoreboard (just known teams will be displayed)</li>
            <li>Added a hook <i>TTT2ModifyCorpseCallRadarRecipients</i> that is called once "call detective" is pressed</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>The weapon pickup system has been improved to increase stability and remove edge cases in temporary weapon teleportation</li>
            <li>Updated Spanish translation (by @DennisWolfgang)</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed foregoing avatar fetch fix</li>
            <li>Fixed HUD savingKeys variable not being unique across all HUDs</li>
            <li>Fixed drawing web images, seamless web images and avatar images</li>
            <li>Fixed correctly saving setting a bind to NONE, while a default is defined</li>
            <li>Fixed a weapon pickup targetID bug where the +use key was displayed even though pickup has its own keybind</li>
            <li>Fixed DNA scanner crash if using an old/different weapon base</li>
            <li>Fixed rare initialization bug in the speed calculation when joining as a spectator</li>
        </ul>
    ]],
        os.time({ year = 2020, month = 09, day = 28 })
    )

    AddChange(
        "TTT2 Base - v0.8.0b",
        [[
        <h2>New:</h2>
        <ul>
            <li>Added new vgui system with new F1 menu</li>
            <li>Introduced a global scale factor based on screen resolution to scale HUD elements accordingly</li>
            <li>Added automatical scale factor change on resolution change that works even if the resolution was changed while TTT2 wasn't loaded</li>
            <li>Added Drag&Drop role layering VGUI (preview), accessible with the console command <i>ttt2_edit_rolelayering</i></li>
            <li>Added a new event system</li>
            <li>Credits can now be transferred across teams and from roles whom the recipient does not know</li>
        </ul>
        <br>
        <h2>Improved:</h2>
        <ul>
            <li>TargetID text is now scaled with the global scale factor</li>
            <li>Removed C4 defuse restriction for teammates</li>
            <li>Changed the language identifiers to generic english names</li>
            <li>Updated Simplified Chinese localization (by @TheOnly8Z)</li>
            <li>Updated Italian localization (by @ThePlatynumGhost)</li>
            <li>Updated English localization (by @Satton2)</li>
            <li>Updated Russian localization (by @scientistnt and @Satton2)</li>
            <li>Updated German translation (by @Creyox)</li>
        </ul>
        <br>
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed weapon pickup bug, where weapons would not get dropped but stayed in inventory</li>
            <li>Fixed a roleselection bug, where forced roles would not be deducted from the available roles</li>
            <li>Fixed a credit award bug, where detectives would receive a pointless notification about being awarded with 0 credits</li>
            <li>Fixed a karma bug, where damage would still be reduced even though the karma system was disabled</li>
            <li>Fixed a roleselection bug, where invalid layers led to skipping the next layer too</li>
            <li>Fixed Magneto Stick ragdoll pinning instructions not showing for innocents when <i>ttt_ragdoll_pinning_innocents</i> is enabled</li>
            <li>Fixed a bug where the targetID info broke if the pickup key is unbound</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 02, day = 06 })
    )

    AddChange(
        "TTT2 Base - v0.8.1b",
        [[
        <h2>Fixed:</h2>
        <ul>
            <li>Fixed inheriting from the same base using the classbuilder in different folders</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 02, day = 19 })
    )

    AddChange(
        "TTT2 Base - v0.8.2b",
        [[
        <h2>Improved:</h2>
        <ul>
            <li>Added global alias for IsOffScreen function to util.IsOffScreen</li>
            <li>Updated Japanese localization (by @Westoon)</li>
            <li>Moved rendering modules to libraries</li>
            <li>Assigned PvP category to the gamemode.</li>
        </ul>
        <h2>Fixed:</h2>
        <ul>
            <li>TTT: fix instant reload of dropped weapon (by @svdm)</li>
            <li>TTT: fix ragdoll pinning HUD for innocents (by @Flapchik)</li>
            <li>Fixed outline library not working</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 03, day = 25 })
    )

    AddChange(
        "TTT2 Base - v0.9.0b",
        [[
        <h2>Added:</h2>
        <ul>
            <li>All new roundend menu</li>
            <ul>
                <li>new info panel that shows detailed role distribution during the round</li>
                <li>info panel also states detailed score events</li>
                <li>new timeline that displays the events that happened during the round</li>
                <li>added two new round end conditions: <code>time up </code>and <code>no one wins</code></li>
            </ul>
            <li>Added <code>ROLE_NONE</code> (ID <code>3</code> by default)</li>
            <ul>
                <li>Players now default to <code>ROLE_NONE</code> instead of <code>ROLE_INNOCENT</code></li>
                <li>Enables the possibility to give Innocents access to a custom shop (<code>shopeditor</code>)</li>
            </ul>
            <li>Karma now stores changes</li>
            <ul>
                <li>Is shown in roundend menu</li>
            </ul>
            <li>Added a new hook <code>TTT2ModifyLogicCheckRole</code> that can be used to modify the tested role for map related role checks</li>
            <li>Added the ConVar <code>ttt2_random_shop_items</code> for the number of items in the randomshop</li>
            <li>Added per-player voice control by hovering over the mute icon and scrolling</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Updated French translation (by @MisterClems)</li>
            <li>Fixed IsOffScreen function being global for compatibility</li>
            <li>Fixed a German translation string (by @FaRLeZz)</li>
            <li>Fixed a Polish translation by adding new lines (by @Wuker)</li>
            <li>Fixed a data initialization bug that appeared on the first (initial) spawn</li>
            <li>Fixed silent Footsteps, while crouched bhopping</li>
            <li>Fixed issue where base innocents could bypass the TTT2AvoidGeneralChat and TTT2AvoidTeamChat hooks with the team chat key</li>
            <li>Fixed issue where roles with unknownTeam could see messages sent with the team chat key</li>
            <li>Fixed the admin section label not being visible in the main menu</li>
            <li>Fixed the auto resizing of the buttons based on the availability of a scrollbar not working</li>
            <li>Fixed reopening submenus of the legacy addons in F1 menu not working</li>
            <li>TTT: Fixed karma autokick evasion</li>
            <li>TTT: Fixed karma being applied to weapon damage even though karma is disabled</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Microoptimization to improve code performance</li>
            <li>Converted <code>roles</code>, <code>huds</code>, <code>hudelements</code>, <code>items</code> and <code>pon</code> modules into libraries</li>
            <li>Moved <code>bind</code> library to the libraries folder</li>
            <li>Moved favorites functions for equipment to the equipment shop and made them local functions</li>
            <li>Code cleanup and removed silly negations</li>
            <li>Extended some ttt2net functions</li>
            <li>Changed <code>bees</code> win to <code>nones</code> win</li>
            <li>By default all evil roles are now counted as traitor roles for map related checks</li>
            <li>Changed the ConVar <code>ttt2_random_shops</code> to only disable the random shop (if set to <code>0</code>)</li>
            <li>Shopeditor settings are now available in the F1 Menu</li>
            <li>Moved the F1 menu generating system from a hook based system to a file based system</li>
            <ul>
                <li>removed the hooks <code>TTT2ModifyHelpMainMenu</code> and <code>TTT2ModifyHelpSubMenu</code></li>
                <li>menus are now generated based on files located in <code>lua/terrortown/menus/gamemode/</code></li>
                <li>submenus are generated from files located in folders with the menu name</li>
            </ul>
            <li>Menus without content are now always hidden in the main menu</li>
            <li>Moved Custom Shopeditor and linking shop to roles to the F1 menu</li>
            <li>Moved inclusion of cl_help to the bottom as nothing depends on it, but menus created by it could depend on other client files</li>
            <li>Shopeditor equipment is now available in F1 menu</li>
            <li>Moved the role layering menu to the F1 menu (administration submenu)</li>
            <ul>
                <li>removed the command <code>ttt2_edit_rolelayering</code></li>
            </ul>
            <li>moved the internal path of <code>lang/</code>, <code>vskin/</code> and <code>events/</code> (this doesn't change anything for addons)</li>
            <li>Sort teammates first in credit transfer selection and add an indicator to them</li>
        </ul>

        <h2>Removed</h2>
        <ul>
            <li>Removed the custom loading screen (GMOD now only accepts http(s) URLs for sv_loadingurl)</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Adjusted <code>Player:HasRole()</code> and <code>Player:HasTeam()</code> to support simplified role and team checks (no parameter are supported anymore, use <code>Player:GetRole()</code> or <code>Player:GetTeam()</code> instead)</li>
            <li>Moved global roleData to the <code>roles</code> library (e.g. <code>INNOCENT</code> to <code>roles.INNOCENT</code>). <code>INNOCENT</code>, <code>TRAITOR</code> etc. is not supported anymore. <code>ROLE_<ROLENAME></code> is still supported and won't be changed.</li>
            <li>Shopeditor function <code>ShopEditor.ReadItemData()</code> now only updates a number of key-parameters, must be given as UInt. Messages were changed accordingly (<code>TTT2SESaveItem</code>,<code>TTT2SyncDBItems</code>)</li>
            <li>Equipment shop favorite functions are now local and not global anymore (<code>CreateFavTable</code>, <code>AddFavorite</code>, <code>RemoveFavorite</code>, <code>GetFavorites</code> & <code>IsFavorite</code>)</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 06, day = 19 })
    )

    AddChange(
        "TTT2 Base - v0.9.1b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed shop convars not being shared / breaking the shop</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 06, day = 19 })
    )

    AddChange(
        "TTT2 Base - v0.9.2b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed low karma autokick convar</li>
            <li>Fixed multi-layer inheritance by introducing a recursion based approach</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 06, day = 20 })
    )

    AddChange(
        "TTT2 Base - v0.9.3b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Add Traditional Chinese Translation (by @TEGTianFan)</li>
            <li>Added a searchbar to submenus</li>
            <li>Added full-sized icons to the equipment-editor</li>
            <li>Hotreload functionality for weapons, they are now fully compatible to TTT2 after hotreload</li>
            <li>Added experimental <code>SWEP.HotReloadableKeys</code> a list of strings to weapons, that makes data saved with <code>weapons.GetStored()</code> persistent across hotreloads</li>
            <li>Extended cvars library to support manipulation of serverside ConVars</li>
            <li>Added possibility to manipulate serverside ConVars with Checkboxes and Sliders</li>
            <ul>
                <li>Just add .serverConvar with the conVarName to the given data similar to .convar</li>
            </ul>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Updated Japanese translation (by @westooooo)</li>
            <li>Fixed text positioning in pure_skin bar (by @LukasMandok)</li>
            <li>Fixed data being not persistent after hot reloading</li>
            <ul>
                <li>HUDs are now still available</li>
                <li>ttt2net keeps its data</li>
                <li>bindings are not lost on reload</li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Revise and additions simplified Chinese (by @TEGTianFan)</li>
            <li>Prevent spectators from gathering info on players if they're about to revive (by @AaronMcKenney)</li>
            <li>ROLE_NONE does not count as a special role anymore (by @TheNickSkater)</li>
        </ul>

        <h2>Internal Breaking Changes</h2>
        <ul>
            <li>Removed first argument of <code>GetEquipmentBase(data, equipment)</code>, it only takes the equipment as argument now <code>GetEquipmentBase(equipment)</code> and generally merges it with <code>EquipMenuData</code></li>
            <li>Added equipment as argument to <code>InitDefaultEquipmentForRole(roleData)</code>, it now only initializes the given equipment not all <code>InitDefaultEquipmentForRole(roleData, equipment)</code></li>
            <li>Added equipment as argument to <code>CleanUpDefaultCanBuyIndices()</code>, it now only initializes the given equipment not all <code>CleanUpDefaultCanBuyIndices(equipment)</code></li>
        </ul>
    ]],
        os.time({ year = 2021, month = 09, day = 25 })
    )

    AddChange(
        "TTT2 Base - v0.10.0b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added a new scoring variable named <code>score.survivePenaltyMultiplier</code> to punish surviving players of a losing team</li>
            <li>Added in game spawn editor system that can be found in F1->Administration</li>
            <li>Moved all TTT weapons to this repository (with cleaned up code)</li>
            <li>Added in four new libraries</li>
            <ul>
                <li>map: A library which handles map specific data</li>
                <li>entspawn: A library that handles the spawning and spawns of all entity types</li>
                <li>entspawnscript: A library that handles the new TTT2 entity spawn script to customize spawns</li>
                <li>plyspawn: A library that builds on top of entspawn to handle the more complex player spawn (originally named spawn, see <code>Breaking changes</code>)</li>
            </ul>
            <li>Added a new submenu to the administration settings regarding basic role setup</li>
            <li>Added a new menu to the F1 menu to set up and configure all installed menus</li>
            <li>Added two new hooks to modify the contents of the newly added menu</li>
            <ul>
                <li><code>ROLE:AddToSettingsMenu(parent)</code></li>
                <li><code>ROLE:AddToSettingsMenuCreditsForm(parent)</code></li>
            </ul>
            <li>Added a new in-game player model selector</li>
            <ul>
                <li>Added new convars that can change the way playermodels are selected (these can be found in the gamemode menu)</li>
                <li>Added a new ConVar <code>ttt2_use_custom_models</code> (def: 0) to enable the custom player model selector</li>
                <li>Added indicator that shows if a model has a headshot hitbox</li>
                <li>Added possibility to enable/disable detective hats for individual player models</li>
            </ul>
            <li>Added a new admin only menu for server addon settings</li>
            <li>Added automatic default values for serverConVars</li>
            <li>Added two new role variables:</li>
            <ul>
                <li><code>isPublicRole</code>: This makes the role behave like a detective in such a way, that the role is public known and shown in the scoreboard. This means other roles can use this without special role syncing; additionally roles with that flag will be handled like a detective if killed by an 'evil' role, meaning that they will receive a credit bonus</li>
                <li><code>isPolicingRole</code>: This rolevar adds all "detective-like" features to the detective, for example the ability to be called to a corpse etc.</li>
            </ul>
            <li>Added two new role conVar variables:</li>
            <ul>
                <li><code>creditsAwardDeadEnable</code>: To award this role if a certain percentage of players from the enemy teams died</li>
                <li><code>creditsAwardKillEnable</code>: To award this role if they killed a high value public role</li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Split up kill, suicide and teamkill in the round end screen to make it more clear</li>
            <li>Decreased the minimum cost of equipment in the equipment editor to 0</li>
            <li>Changed disguise such that every role can now use the function</li>
            <li>Completely reworked how weapons, ammo and players spawn in the world</li>
            <li>Sliders only update ConVars on mouseRelease now</li>
            <li>Changed the way credits on kills are distributed in a way that non-default roles can easily use this as well</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Removed the (unused?) ConVar <code>ttt2_custom_models</code></li>
            <li>Removed the function <code>GetRandomPlayerModel()</code>, use <code>playermodels.GetRandomPlayerModel()</code> instead</li>
            <li>Renamed the <code>spawn</code> module to <code>plyspawn</code></li>
            <li>Hook <code>PlayerSelectSpawn</code> doesnt return a spawnEntity anymore</li>
            <li>SpawnWillingPlayers is deleted and not available anymore</li>
            <li>renamed the <code>ttt_credits_starting</code> to <code>ttt_traitor_credits_starting</code> to be more in-line with all other roles</li>
            <li><b>WARNING:</b> This means that every traitor now starts with 0 credits until the convar reset button is pressed (on existing servers)</li>
            <li>removed the <code>alone_bonus</code> convar because it only complicated the credits system further without adding much benefit</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 10, day = 14 })
    )

    AddChange(
        "TTT2 Base - v0.10.1b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed Playermodels not correctly loading changes on game start</li>
            <li>Fixed setting defaults before assigning a resetButton not throwing an error anymore</li>
            <li>Fixed invisible preview for entity spawn placements</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 10, day = 15 })
    )

    AddChange(
        "TTT2 Base - v0.10.2b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added a new hook <code>GM:TTT2ModifyRadioTarget</code> to modify the current radio target</li>
            <li>Added documentation to all hooks</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed the reset button not working for Sliders in the F1 Menu</li>
            <li>Fixed defuser only working for detectives</li>
            <li>Fixed some weapon packs like ArcCW to be working again, weapons are now initialized with ttt2 variables after the <code>InitPostEntity</code> hook<br>
            <b>Note:</b> This might only take effect after a reinstall or a reset of the server; if you don't want to reset your server, you have to change the spawnability manually in the equipment editor or delete the sql table "ttt2_items" of the sv.db to force a reset only on equipment</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Changed the Sliders to only update after dragging ends, no matter where you clicked on the slider before dragging</li>
            <li>Changed <code>TTTPlayerUsedHealthStation</code> hook, return <code>false</code> to cancel health regeneration tick</li>
            <li>Changed all C4 hooks to be cancelable</li>
        </ul>

        <h2>Removed</h2>
        <ul>
            <li>Removed old concommand <code>shopeditor</code> and the old shopeditor</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Renamed hook <code>GM:TTT2CheckWeaponForID</code> to <code>GM:TTT2RegisterWeaponID</code> better fitting its purpose as its probably nowhere used yet anyway</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 10, day = 21 })
    )

    AddChange(
        "TTT2 Base - v0.10.3b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed the hook scope in the disguiser causing an error</li>
            <li>Fixed the classic entity spawn mode breaking on maps without all three spawn types</li>
            <li>Fixed weapons not using their average firerate with a tickrate dependent fix. Function <code>SWEP:SetNextPrimaryFire(nextTime)</code>  was overwritten with our fix <code>SWEP:SetNextPrimaryFire(nextTime, skipTickrateFix)</code>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Added new param <code>skipTickrateFix</code> to <code>SWEP:SetNextPrimaryFire(nextTime, skipTickrateFix)</code> to skip our inbuilt tickrate fix</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 10, day = 29 })
    )

    AddChange(
        "TTT2 Base - v0.11.0b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added the hook <code>GM:TTT2CalledPolicingRole</code> that is called after all policing role players were called to a corpse</li>
            <li>Added all TTT2 convars into the F1 menu</li>
            <ul>
                <li>most convars are located in the <code>administration</code> menu</li>
                <li>equipment specific settings can be found in the <code>edit equipment</code> menu</li>
            </ul>
            <li>Added icon to the magneto stick</li>
            <li>Added the function <code>AddToSettingsMenu</code> to both <code>SWEP</code> and <code>ITEM</code> to add settings to the equipment menu</li>
            <li>Added the role flag <code>.isOmniscientRole</code>; if set to true the role is able to see missing in action players and the haste mode time</li>
            <li>Added <code>GM:TTT2ModifyOverheadIcon</code> to add, remove or modify the overhead icons of players</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed that every policing player could be called to a corpse, this is now again restricted to alive only players</li>
            <li>Fixed inconsistency between <code>.disabledTeamChatRecv</code> and <code>.disabledTeamChatRec</code></li>
            <li>Fixed non-public policing roles having hats and therefore confirming them</li>
            <li>Fixed triggered spawns on maps like <code>ttt_lttp_kakariko_a5</code> with the vases and <code>ttt_mc_jondome</code> with the chests</li>
            <li>Fixed roleselection layering with base roles to ensure layer order is considered correctly when selecting roles</li>
            <li>Fixed hotreloading items</li>
            <li>Fixed random playermodel selection on map change not working</li>
            <li>Fixed <code>ply:Give</code> sometimes picking up all surrounding weapon entities, if auto pickup is enabled</li>
            <li>Fixes weapon pickup sometimes causing floating weapons</li>
            <li>Fixes weapon pickup sometimes failing if a weapon with the same class as a weapon in the inventory should be picked up</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>All public policing roles now appear as detectives in the chat</li>
            <li>Change blocking revival mode from <code>true</code>/<code>false</code> to</li>
            <ul>
                <li><code>REVIVAL_BLOCK_NONE</code>: don't block the winning condition during the revival process [default, previously <code>nil</code>/<code>false</code>]</li>
                <li><code>REVIVAL_BLOCK_AS_ALIVE</code>: only block the winning condition, if the player being alive would change the outcome [previously <code>true</code>]</li>
                <li><code>REVIVAL_BLOCK_ALL</code>: block the winning condition until the revival process is ended</li>
                <li>the old arguments still work, they are automatically converted</li>
            </ul>
            <li>Changed logs folder to <code>terrortown/logs/</code> to be inline with everything else</li>
            <li>Added more role agnostics</li>
            <ul>
                <li>voice drain rate is now no longer bound to Detectives but to all public policing roles</li>
                <li>Karma multiplier is now no longer bound to Detectives but to all public policing roles</li>
                <li>all non-innocent roles are now able to pin ragdolls if enabled (previous only Traitors could do this)</li>
            </ul>
            <li>Overhead icons are now also either colored black or white depending on the role's color</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Renamed some convars to be inline with our <code>opt-in style</code>, all values were changed so that the default value is kept</li>
            <ul>
                <li><code>ttt_no_prop_throwing</code> is now <code>ttt_prop_throwing</code></li>
                <li><code>ttt_limit_spectator_chat</code> is now <code>ttt_spectators_chat_globally</code></li>
                <li><code>ttt_no_nade_throw_during_prep</code> is now <code>ttt_nade_throw_during_prep</code></li>
                <li><code>ttt_armor_classic</code> is now <code>ttt_armor_dynamic</code></li>
            </ul>
        </ul>
    ]],
        os.time({ year = 2021, month = 11, day = 15 })
    )

    AddChange(
        "TTT2 Base - v0.11.1b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added four new Karma multipliers as role variables. They are applied **after** all other Karma calculations are done:</li>
            <ul>
                <li><code>ROLE.karma.teamKillPenaltyMultiplier</code>: The multiplier that is used to calculate the Karma penalty for a team kill</li>
                <li><code>ROLE.karma.teamHurtPenaltyMultiplier</code>: The multiplier that is used to calculate the Karma penalty for team damage</li>
                <li><code>ROLE.karma.enemyKillBonusMultiplier</code>: The multiplier that is used to calculate the Karma given to the killer if a player from an enemy team is killed</li>
                <li><code>ROLE.karma.enemyHurtBonusMultiplier</code>: The multiplier that is used to calculate the Karma given to the attacker if a player from an enemy team is damaged</li>
            </ul>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed <code>ply:Give(weapon)</code> to work again, when weapons are cached, fixing the spawneditor to work again</li>
            <li>Fixed spawneditor not causing errors, when going through walls due to many steps</li>
            <li>Set default traitor button variable back to 0</li>
            <li>Fixed unchanged or unscaled damage being sent to the client, leading to a wrongly working damage-overlay</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 11, day = 16 })
    )

    AddChange(
        "TTT2 Base - v0.11.2b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed correct role Karma multipliers used in Karma-module</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 11, day = 17 })
    )

    AddChange(
        "TTT2 Base - v0.11.3b",
        [[
        <h2>Fixed</h2>
        <ul>
            <li>Fixed Equipment-Editor not showing the current synced values, but the cached ones</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Changed serverConVars not indexing with 0 in tables (could cause issues when iterating)</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 11, day = 18 })
    )

    AddChange(
        "TTT2 Base - v0.11.4b",
        [[
        <h2>Changed</h2>
        <ul>
            <li>Switched from the voicerecord commands to the GMod permission system due to a recent GMod update breaking the old voice chat</li>
            <li>Updated Japanese translation (by @westooooo)</li>
        </ul>
    ]],
        os.time({ year = 2021, month = 12, day = 17 })
    )

    AddChange(
        "TTT2 Base - v0.11.5b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Reworked our simplified Dropdowns MakePanel <code>PANEL:MakeComboBox(data)</code> version</li>
            <ul>
                <li>Added possibility to manipulate serverside ConVars with Dropdowns. Just add .serverConvar with the conVarName to the given data similar to .convar</li>
                <li>.serverConVar and .conVar are also supported</li>
                <li>data.choices can now be a table containing <code>{title, value, select, icon, additionalData}</code></li>
                <li>data.selectValue is added, use it instead of data.selectName to choose the value you set</li>
                <li>data.selectTitle is added and shall replace data.selectName</li>
            </ul>
            <li>New setting to disable session limits entirely. (by @Reispfannenfresser)</li>
            <li>Added <code>GM:TTT2AdminCheck</code> hook</li>
            <ul>
                <li>Replaced all <code>IsSuperAdmin()</code> checks with this hook</li>
                <li>This hook can be used to allow custom usergroups through these checks</li>
            </ul>
            <li>Added convars to modify how fall damage is applied</li>
            <ul>
                <li><code>ttt2_falldmg_enable (default: 1)</code> toggles whether or not to apply fall damage at all</li>
                <li><code>ttt2_falldmg_min_velocity (default: 450)</code> sets the minimum velocity threshold for fall damage to occur</li>
                <li><code>ttt2_falldmg_exponent (default: 1.75)</code> sets the exponent to increase fall damage in relation to velocity</li>
                <li>All these convars can also be adjusted in the F1->Administration->Player Settings menu</li>
            </ul>
            <li>Added portuguese translation</li>
            <li>Added a <code>database</code> library, that handles shared Interaction with the sql database</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Reworked Dropdowns Panel <code>DComboBoxTTT2</code> itself</li>
            <ul>
                <li><code>PANEL:AddChoice(title, value, select, icon, data)</code> now uses the second argument as value string for setting convars, use the fifth argument for special data instead</li>
                <li><code>PANEL:ChooseOption(title, index, ignoreConVar)</code> is deprecated and no longer chooses the displayed text, only per index</li>
            </ul>
            <li>Reworked our simplified Dropdowns MakePanel <code>PANEL:MakeComboBox(data)</code> version</li>
            <ul>
                <li><code>data.OnChange(value, additionalData, comboBoxPanel)</code> is now called with the two important arguments at first. They are the value that e.g. convars are set, the additionalData and the Panel</li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Corrected incorrect translation (by @sbzlzh)</li>
            <li>Optimized damage indicator vgui images to be smaller</li>
            <li>Improved hotreload of TTT2 roles library with RoleList not being global</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed addon compatibility checker fussing over disabled addons</li>
            <li>Fixed ammo entities blocking <code>+use</code> traces</li>
            <li>Fixed double call of <code>GM:TTT2UpdateTeam</code>, when a role change leads to a team change</li>
        </ul>
    ]],
        os.time({ year = 2022, month = 08, day = 21 })
    )

    AddChange(
        "TTT2 Base - v0.11.6b",
        [[
        <h2>Changed</h2>
        <ul>
            <li>Fixed and updated the Chinese translation file (by @sbzlzh)</li>
            <li>Updated Japanese translation (by @westooooo)</li>
            <li>Updated Simplified and Traditional Chinese (by @TEGTianFan)</li>
            <li>Add placeholder message to the ingame ttt2 guide (F1 Menu)</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed the spawn editor tool not having a TargetID in some scenarios by always rendering the 'ttt_spawninfo_ent' (by @NickCloudAT)</li>
            <li>Roleselection for a lot of roles now considers all possible subroles one after another</li>
            <li>Fixed portuguese translation of the equipment editor not working</li>
        </ul>
    ]],
        os.time({ year = 2022, month = 09, day = 25 })
    )

    AddChange(
        "TTT2 Base - v0.11.7b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added a new font in default_skin.lua to fit the localization (by @Satton2)</li>
            <li>Fixed knife death effect being permanently applied on every following death</li>
            <li>Added <code>PANEL:MakeTextEntry(data)</code> to <code>DFormTTT2</code> for strings or string-backed cvars (by @EntranceJew)</li>
            <li>Allow admin spectators to enter "Spawn Edit" mode. (by @EntranceJew)</li>
            <li>Added cvar <code>ttt2_bots_lock_on_death</code> (default: 0) to prevent bots from causing log-spam while wandering as spectators. (by @EntranceJew)</li>
            <li>Added <code>TTT2ModifyFinalRoles</code> hook for last minute opportunity to override role distribution prior to them being announced for the first time (by @EntranceJew)</li>
            <li><code>weapon_tttbase</code>:</li>
            <ul>
                <li>Added <code>SWEP:ShouldRemove</code> to facilitate intercepting <code>SWEP:Remove</code> (by @EntranceJew)</li>
                <li>Added <code>SWEP.damageScaling</code> for weapons that utilize <code>ShootBullet</code> (by @EntranceJew)</li>
            </ul>
            <li>Edit Equipment Menu</li>
            <ul>
                <li><code>AllowDrop</code> can now be overridden per-weapon (by @EntranceJew)</li>
                <li><code>Kind</code> can now be overridden per-weapon (by @EntranceJew)</li>
                <li><code>overrideDropOnDeath</code> now permits forcing weapons to be dropped instead of removed on death (by @EntranceJew)</li>
                <li>"Damage Scaling" editable under "Balance Settings" (by @EntranceJew)</li>
            </ul>
            <li><code>vgui.CreateTTT2Form</code> passes the name on so that it can be accessed via <code>Panel:GetName()</code> (by @EntranceJew)</li>
            <li>Added two GAMEMODE hooks to provide the ability for additional addons to extend role/equipment menus.</li>
            <ul>
                <li><code>GM:TTT2OnEquipmentAddToSettingsMenu(equipment, parent)</code></li>
                <ul>
                    <li>Called after <code>ITEM:AddToSettingsMenu(parent)</code>.</li>
                </ul>
                <li><code>GM:TTT2OnRoleAddToSettingsMenu(role, parent)</code></li>
                <ul>
                    <li>Called after <code>ROLE:AddToSettingsMenu(parent)</code></li>
                </ul>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li><code>weapon_tttbase</code>:</li>
            <ul>
                <li>Removal of <code>SWEP.IronSightsTime</code> as it was completely unused and conflicts with a networked value intended for the same purpose</li>
                <li>Commented-out default values for <code>SWEP.IronSightsPos</code> and <code>SWEP.IronSightsAng</code> to match vanilla TTT behaviour</li>
                <ul>
                    <li>SWEPs can still use these names as normal, they just don't have a base value to inherit anymore</li>
                </ul>
            </ul>
            <li>Updated Russian and English localization files (by @Satton2):</li>
            <ul>
                <li>Updated strings in English localization file</li>
                <li>Localized outdated and new strings into Russian</li>
            </ul>
            <li>Updated all localization files (by @Satton2):</li>
            <ul>
                <li>Added missing and new strings</li>
                <li>Marked (out-) updated strings</li>
                <li>Removed some duplicated strings</li>
                <li>Removed some old unused strings</li>
                <li>Fixed some broken source strings (line names)</li>
            </ul>
            <li>Simplified Chinese and Traditional Chinese localization updates (by @sbzlzh):</li>
            <ul>
                <li>Update Simplified Chinese Translation</li>
                <li>Improve translation (by @TheOnly8Z)</li>
            </ul>
            <li>Localization parameters for <code>{walkkey} + {usekey}</code> prompts made into the predominant style.</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed hotreload of TTT2 roles library by a fresh reinitialization</li>
            <li>Fixed a wrong localization line call in roles.lua (by @Satton2)</li>
            <li>Fixed +zoom bind</li>
            <li>Fixed ttt_quickslot command</li>
            <li>Fixed an issue in <code>table.GetEqualEntryKeys</code> when nil is provided instead of a table. (by @sbzlzh):</li>
            <ul>
                <li>This fixes spawn problems on maps with invalid spawn points</li>
                <li>This fixes errors in the F1 Menu language selection</li>
            </ul>
            <li>Fixed the check for dynamic armor being inverted (<code>1</code> disabled it, <code>0</code> enabled it)</li>
            <li>Fixed two unmatched ConVars in performance menu (by @NickCloudAT)</li>
            <li>Fixed Round End Scoreboard (Round Begin) error if a player disconnected while round with no score events (by @NickCloudAT)</li>
            <li>Fixed behavior of <code>entspawn.SpawnRandomAmmo</code> to produce non-deagle ammo. (by @NickCloudAT, mostly)</li>
        </ul>
    ]],
        os.time({ year = 2023, month = 08, day = 27 })
    )

    AddChange(
        "TTT2 Base - v0.12.0b",
        [[
        <h2>Added</h2>
        <ul>
            <li>added the ability to edit slider numbers directly via an input field by clicking on the number (by @nickcloudat)</li>
            <li>Added a new way to alter player volume separately from the scoreboard (by @EntranceJew):</li>
            <ul>
                <li><code>VOICE.(Get/Set)PreferredPlayerVoiceVolume</code> for setting the voice volume instead of <code>Player:SetVoiceVolumeScale</code></li>
                <li><code>VOICE.(Get/Set)PreferredPlayerVoiceMute</code> for setting the voice mute instead of <code>Player:SetMuted</code></li>
                <li><code>VOICE.UpdatePlayerVoiceVolume</code> commits / updates the voice setting according to player preferences</li>
            </ul>
            <ul>
                <li>Added a convar <code>ttt2_voice_scaling</code> to control voice volume scaling, options like "power4" or "log" cause the volume scaling to have a greater perceptual impact between discrete volume settings.</li>
                <li>Added convars <code>ttt2_voice_duck_spectator</code> and <code>ttt2_voice_duck_spectator_amount</code> to lower spectator voice volume automatically.</li>
                <ul>
                    <li>A value of <code>0.13</code> ducks someone's volume at 90% down to effectively 78%, according to the client's scaling mode.</li>
                </ul>
            </ul>
            <li>Added the option for <code>DButtonTTT2</code> to have an icon next to the title (by @TimGoll)</li>
            <li>Added a cached equipment item icon to its table as <code>.iconMaterial</code> (by @TimGoll)</li>
            <li>Added a new <code>bodysearch</code> library that handles the search (by @TimGoll)</li>
            <li>Completely reworked the body search UI (by @TimGoll)</li>
            <ul>
                <li>new UI that fits the UI rework</li>
                <li>added player model to UI</li>
                <li>highlighted player role and team in the UI</li>
                <li>redesigned data list so that everything can be seen without clicking through a list</li>
                <li>added more details to list like: water level, ground type, kill distance, kill direction, hit group, last damage amount</li>
                <li>The UI is now more responsive, it is updated when the server changes states on the body and timers are updated live in the UI</li>
            </ul>
            <li>Added that the healthbar will pulsate when below 25% health. Toggleable in F1 Menu (by @NickCloudAT)</li>
            <li>Added new menu section in F1 menu under <code>Appearance > Hud Switcher</code> for HudElement based features (by @NickCloudAT)</li>
            <li>Brought in code files for <code>ttt_hat_deerstalker</code>, <code>weapon_ttt_phammer</code>, <code>ttt_flame</code>, and <code>weapon_ttt_push</code>.</li>
            <li>Translated all strings still needed to german (by @NickCloudAT)</li>
            <li>Added new sidebar information, when the scoreboard is open (by @TimGoll)</li>
            <li>Added keybinding information to the bottom of the screen (by @TimGoll)</li>
            <ul>
                <li>Can be disabled in Appearance->Interface</li>
                <li>Shows binding name when scoreboard is opened</li>
            </ul>
            <li>Added option to render rotated text on screen (by @TimGoll)</li>
            <li>Added <code>TTT2GiveFoundCredits</code> hook for preventing / overriding the transfer of credits from a body to a player (by @Spanospy)</li>
            <li>Added Ukrainian translation from base TTT (by @ErickMaksimets)</li>
            <li>Added Swedish translation from base TTT (by @Kefta)</li>
            <li>Added Turkish translation (by @NovaDiablox)</li>
            <li>Added <code>ttt_dropclip</code> to drop loaded ammo from your active weapon. (by @wgetJane, implemented by @EntranceJew)</li>
            <li>Added window flash and noise to alert players they're being revived (by @EntranceJew)</li>
            <li>Added sql database access to panel elements</li>
            <ul>
                <li><code>DNumSliderTTT2</code>, <code>DCheckBoxLabelTTT2</code>, <code>DComboBoxTTT2</code></li>
            </ul>
            <li>Added dashing to propspec (by @TimGoll)</li>
            <li>Added new functions to database module</li>
            <ul>
                <li><code>database.SetDefaultValuesFromItem(accessName, itemName, item)</code></li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Changed sprint stamina to also consume while in air</li>
            <li>Updated Simplified Chinese and Traditional Chinese localization files (by @sbzlzh):</li>
            <ul>
                <li>Add the missing <code>L.c4_disarm_t</code> translation in C4</li>
                <li>Remove redundant string translations and spaces</li>
                <li>Added all new translation strings</li>
            </ul>
            <li>Updated file code to read from <code>data_static</code> as fallback in new location allowed in .gma (by @EntranceJew)</li>
            <li>Scoreboard now sets preferred player volume and mute state in client's new <code>ttt2_voice</code> table (by @EntranceJew)</li>
            <ul>
                <li>Keyed by steamid64, making it more reliable than UniqueID or the per-session mute and volume levels.</li>
            </ul>
            <li>Changed the body search convars and reworked the UI accordingly (by @TimGoll)</li>
            <ul>
                <li>Moved <code>ttt2_confirm_detective_only</code> and <code>ttt2_inspect_detective_only</code> to a new covar: <code>ttt2_inspect_confirm_mode</code></li>
                <ul>
                    <li>mode 0: default mode, normal TTT. Everyone can search and identify corpses. However now a player has to be confirmed first to take credits</li>
                    <li>mode 1: everyone can see information, but only public policing roles can actually confirm bodies</li>
                    <li>mode 2: only public policing roles can see informatiom. They have to confirm bodies so that other people are able to see this information as well</li>
                </ul>
                <li>to comply with mode 1 and 2 now everyone is able to see in the targetID if a player was searched by a public policing role</li>
            </ul>
            <li>renamed <code>search_result</code> to <code>bodySearchResult</code> which contains the search result data</li>
            <li>changed the credit text color from yellow to gold (by @TimGoll)</li>
            <li>Updated the disguiser to make it more clear in the HUD if it is enabled or not</li>
            <li>Updated the equipment HUD help boxes in a new style and added missing help boxes (by @TimGoll)</li>
            <li>Changed LMB press behavior in observer mode to iterate backwards through player list instead of slecting a random player (by @TimGoll)</li>
            <li>Improved translation of some Simplified Chinese strings (by @TheOnly8Z)</li>
            <li>Dropping ammo with <code>ttt_dropammo</code> drops from reserve ammo instead of your active weapon's clip (by @wgetJane, implemented by @EntranceJew)</li>
            <li>Added item name for <code>ttt_hat_deerstalker</code> (by @EntranceJew)</li>
            <li>Changed syncing of database module to use whole tables instead of custom method</li>
            <li>Replaced equipmenteditor syncing with database module</li>
            <li>Replaced internal equipment syncing with database module</li>
            <li>Moved reset buttons onto the left (by @a7f3)</li>
            <li>Added ammo icons to the weapon switch HUD and player status HUD elements (by @EntranceJew)</li>
            <li>Changed the disguiser icon to be more fitting (by @TimGoll)</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed prediction of the sprinting system, for high ping situations (by @saibotk, thanks to @wgetJane)</li>
            <li>Fixed removing the convar change callback in <code>DComboboxTTT2</code>, <code>DCheckBoxLabelTTT2</code>, <code>DNumSliderTTT2</code> (by @saibotk)</li>
            <li>Multiple internal fixes</li>
            <ul>
                <li>biggest teamkiller award should now work</li>
                <li>item model caching should now work properly</li>
                <li>role info popup for traitors should now show teammembers again if the traitor shop is disabled</li>
                <li><code>pon</code> and <code>table</code> libraries got a small fix respectively</li>
                <li>the shop and roleselection now reference <code>roles.INNOCENT</code> instead of the removed <code>INNOCENT</code> global, same for <code>TRAITOR</code> and <code>DETECTIVE</code></li>
                <li>Fixed wrong translation % in F1-Menu when changing language (by @NickCloudAT)</li>
            <ul>
            <li>Fixed disguiser breaking UI on hot reload (by @TimGoll)</li>
            <li>Fixed blurred box rendering for boxes not starting at <code>0,0</code> (by @TimGoll)</li>
            <li>Fixed spectated entity not being reset properly which can cause issues (by @TimGoll)</li>
            <li>Optimized allocations by using global Vector / Angle when possible.</li>
            <li>Fixed the dynamic armor damage calculation being wrong when damage can only get partially reduced</li>
            <li>Fixed propspec inputs behaving sometimes unexpectedly (by @TimGoll)</li>
            <li>Fixed ComboBoxes not working with integer values (by @NickCloudAT)</li>
            <li>net.SendStream() can now also handle tables larger than 256kB, which exceeded the maximum net receive buffer</li>
            <li>Fixed nil value of SetValue in <code>DNumSliderTTT2</code> , <code>DCheckBoxLabelTTT2</code>. And fix nil value for boxCache[name] in <code>PlayerModels</code> (by @sbzlzh)</li>
            <li>Prevent weapon_tttbase Lua errors with NPCs (by @BuzzHaddaBig in base TTT)</li>
            <li>Fix miniscoreboard HUD from showing confirmed players that switched to spectator as having been revived (by @EntranceJew)</li>
        </ul>

        <h2>Deprecated</h2>
        <ul>
            <li>Deprecated <code>AccessorFuncDT()</code>, Addons should remove the function call and replace <code>DTVar()</code> calls with <code>NetworkVar()</code></li>
        </ul>

        <h2>Removed</h2>
        <ul>
            <li>Removed <code>ttt_confirm_death</code> and <code>ttt_call_detective</code> as they are now handled via proper net messages</li>
            <li>Removed spectator texts from the UI in favor of the new key binding information (by @TimGoll)</li>
            <li>Removed double tap sprinting, for easier prediction handling (by @saibotk)</li>
            <li>Removed explicit "Sprint" key bind, please use the GMod native sprint key binding (by @saibotk)</li>
            <li>Removed unused clientside <code>Player.preventSprint</code> flag (by @saibotk)</li>
        </ul>
    ]],
        os.time({ year = 2023, month = 12, day = 11 })
    )

    AddChange(
        "TTT2 Base - v0.12.1b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added a new `fastutf8` library that provides faster utf8 functions (added by @saibotk, created by @blitmap)</li>
        </ul>

        <h2>Changed</h2>
        <ul>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed the UI being unable to handle wrapping text with non-utf8 languages that do not use ASCII whitespaces (by @TimGoll & @saibotk)</li>
            <li>Fixed ttt_game_text not working due to a refactor</li>
            <li>Fixed dete call HUD being invisible</li>
            <li>Fixed edgecase where undefined killer angle or pos were accessed</li>
            <li>Fixed fallback ammo icon missing</li>
            <li>Fixed a null entity error in the miniscoreboard</li>
            <li>Fixed missing bodysearch information if victim was killed without leaving a trace caused by a weapon hit</li>
        </ul>
    ]],
        os.time({ year = 2023, month = 12, day = 12 })
    )

    AddChange(
        "TTT2 Base - v0.12.2b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added the beacon back into TTT2, an equipment that was disabled long ago in base TTT</li>
            <ul>
                <li>Can only be bought by policing roles</li>
                <li>Creates a wallhack in a sphere around it, which is visible to everyone</li>
            </ul>
            <li>Added recognizable badge for builtin equipment and roles (by @EntranceJew)</li>
            <ul>
                <li>Buy Equipment menu has builtin indicators, replacing the (C) custom marker decorating a majority of equipment</li>
                <li>F1 > Edit Equipment now has builtin indicators on equipment</li>
                <li>Added tooltip to F1 > Edit Equipment menu with the equipment's class name.</li>
                <li>F1 > Role Settings now has builtin indicators for roles</li>
                <li>F1 > Edit Shops now has builtin indicators for roles</li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Updated the Turkish localization file (by @NovaDiablox)</li>
            <li>Radio can now only be picked up by placer</li>
            <li>Radar now clears existing waypoints when removed or on changing role (by @EntranceJew)</li>
            <li>Comboboxes can now handle numbers and strings as values</li>
            <ul>
                <li>Defaults work now with numbers</li>
                <li>OnChange-Callback is called with the correct type for ConVars</li>
            </ul>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Binoculars scan no longer gets interrupted when changing zoom level</li>
            <li>Fixed missing water level icon breaking scoreboard</li>
            <li>DNA Tester works now with more than one fingerprint on a weapon</li>
            <li>TraitorButton config files should now actually work</li>
            <li>Translation strings not rendering on detective's body search mode combobox</li>
            <li>C4 defusal prompt now suggesting the right key</li>
            <li>Disable to unscope from weapons without ironsights</li>
            <li>Fixed typo preventing targetid from showing role icons correctly</li>
            <li>Mitigated issue with CTakeDamageInfo becoming ephemeral outside their hook of origin</li>
            <li>ttt_game_text can now properly send to "All except traitors", as described.</li>
            <li>Fixed corpses not listing their kills</li>
            <li>Comboboxes now show correct values for database driven entries</li>
            <li>Database-Callbacks are now called with the correct valuetype</li>
        </ul>
    ]],
        os.time({ year = 2023, month = 12, day = 20 })
    )

    AddChange(
        "TTT2 Base - v0.12.3b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added some missing vanilla TTT entities into TTT2</li>
            <li>Added debug.print(message)</li>
            <ul>
                <li>This puts quotation marks around print statements</li>
                <li>Can handle single values or a sequential table to be printed</li>
                <li>Can handle `nil` entries in a nearly sequential table</li>
            </ul>
            <li>Added new hooks `TTT2BeaconDetectPlayer` and `TTT2BeaconDeathNotify` to allow preventing / overriding a beacon's player detection & alerts (by @spanospy)</li>
            <li>Added indentation to subsettings in F1 menu (by @TimGoll)</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Updated the Turkish localization file (by @NovaDiablox)</li>
            <li>Keyhelp and weapon HUD Help now use the global scale factor</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed targetID hints for old addons now correctly working for all entities</li>
            <li>Fixed visualizer having pickup hint even though player is unable to pick up</li>
            <li>targetid wasn't showing named corpse's role, information which was already present on the scoreboard (by @EntranceJew)</li>
            <li>Damage Scaling now has a help description</li>
            <li>Fixed the database module setting a global variable called `callback` which breaks addons such as PointShop2</li>
            <li>Fixed voicechat keybinds being shown even if voice is disabled</li>
            <li>Coerced ammo types to lowercase for better matching in HUD</li>
            <li>The binocular zoom now uses a DataTable that is not already used by its weaponbase</li>
            <li>Fixed round scoreboard tooltips not being wide enough for their strings (by @EntranceJew)</li>
            <li>Errors when looking at a player's corpse that disconnected (by @EntranceJew)</li>
            <li>Fixed `TTT2FinishedLoading` hook not called on server on hot reload (by @TimGoll)</li>
            <li>Shopeditor now correctly shows resetted and default values</li>
        </ul>
    ]],
        os.time({ year = 2024, month = 01, day = 07 })
    )

    AddChange(
        "TTT2 Base - v0.13.0b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added migrations between TTT2-versions, some breaking changes could now be migrated instead</li>
            <li>Added a new markerVision module that adds information to a specific point in space to replace the old C4 radar; it is currently used by these builtin weapons (by @TimGoll)</li>
            <ul>
                <li>C4</li>
                <li>Radio</li>
                <li>Beacon</li>
            </ul>
            <li>Binoculars now retain search progress if interrupted. Progress decays based on time since last observed (by @EntranceJew)</li>
            <li>Reworked the way the player camera is handled (by @TimGoll)</li>
            <ul>
                <li>Added FOV change on speed change</li>
                <li>Added view bobbing on walking, swimming, falling and strafing</li>
                <li>Added convars to disable those changes</li>
            </ul>
            <li>Added <code>draw.Arc</code> and <code>draw.ShadowedArc</code> from TTTC to TTT2 to draw arcs (by @TimGoll und @Alf21)</li>
            <li>Added possibility to cache and remove items, similar to how it is already possible with weapons with <code>CacheAndStripItems</code> (by @TimGoll)</li>
            <li>Added an option for weapons to hide the pickup notification by setting <code>SWEP.silentPickup</code> to <code>true</code> (by @TimGoll)</li>
            <li>Added <code>TTT2FetchAvatar</code> hook for intercepting avatar URIs (by @EntranceJew)</li>
            <li>Added <code>draw.DropCacheAvatar</code> to allow destroying and refreshing an existing avatar, so bots can intercept avatar requests and circumvent the limited unique SteamID64s they're given (by @EntranceJew)</li>
            <li><code>weapon_tttbase</code> changes to correct non-looping animations which affected ADS scoping (by @EntranceJew)</li>
            <ul>
                <li>Added <code>SWEP.IdleAnim</code> to allow specifying an idle animation.</li>
                <li>Added <code>SWEP.idleResetFix</code> to allow the animations for CS:S weapons to automatically be returned to an idle position.</li>
                <li>Added <code>SWEP.ShowDefaultViewModel</code> to prevent a weapon from drawing a ViewModel when set to false at all without FOV hacks or Deploy code which has no effect.</li>
            </ul>
            <li>Added a new vgui element: <code>DWeaponPreview_TTT2</code> to render a player with their equipped weapon (by @TimGoll)</li>
            <ul>
                <li>Supports any normal weapon that has a <code>.HoldType</code> and a <code>.WorldModel</code></li>
                <li>Supports any weapon that is made with the SWEP Construction Kit (boomerang, melonmine, ...) or made for our custom world model renderer</li>
            </ul>
            <li>Made beacon model and icon unique from decoy (by @EntranceJew)</li>
            <li>Added <code>SWEP:ClearHUDHelp()</code> to allow blanking the help text, for dynamically updating help text on equipment (by @EntranceJew)</li>
            <li>Added custom world and view models to some builtin weapons (by @TimGoll)</li>
            <li>Added custom world and view models to some builtin weapons (by @TimGoll)</li>
            <ul>
                <li>added for: radio, beacon, decoy, binoculars, visualizer</li>
            </ul>
            <li>Added support for easy addition of custom view and world models (by @TimGoll)</li>
            <ul>
                <li>Added <code>AddCustomViewModel</code> to add custom view models</li>
                <li>Added <code>AddCustomWorldModel</code> to add custom world models</li>
                <li>Added an automatic fix for badly coded addons that break the view model fingers</li>
            </ul>
            <li>Added <code>ttt_base_placeable</code> entity that is used to handle any placeable / destroyable entity (by @TimGoll)</li>
            <ul>
                <li>moved <code>ttt_c4</code>, <code>ttt_health_station</code>, <code>ttt_beacon</code>, <code>ttt_decoy</code>, <code>ttt_radio</code> and <code>ttt_cse_proj</code> to that base</li>
                <li>also handles pickup of those entities</li>
            </ul>
            <li>Throwables (grenades) now have a <code>:GetPullTime()</code> accessor (by @EntranceJew)</li>
            <li>Throwables (grenades) show UI for the amount of time remaining before detonation (fuse time) (by @EntranceJew)</li>
            <li>UI for grenade throw arcs from colemclaren's TTT fork (integrated by @EntranceJew)</li>
            <li><code>gameEffects</code> library for global effects that are useful, such as starting fires (by @EntranceJew)</li>
            <li>Added weapon pickup sounds when picking up weapons manually (by @TimGoll)</li>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Refactored client shop logic into separate shop-class (by @ZenBre4ker</li>
            <ul>
                <li>Enabled shared shop class to buy and check equipment</li>
                <li>Removed third argument of <code>TTT2CanOrderEquipment</code>-Hook, no message is outputted anymore</li>
            </ul>
            <li>dframe_ttt2 panels can now manually enable bindings while they are open (by @ZenBre4ker)</li>
            <li>Binoculars now have a world model that isn't paper towels (by @EntranceJew)</li>
            <li>Decreased shooting accuracy while sprinting or in air (by @TimGoll)</li>
            <li>A player whose weapons are stripped and cached will keep <code>weapon_ttt_unarmed</code> which means they keep their crosshair (by @TimGoll)</li>
            <li>Updated the German localization file (by @NickCloudAT)</li>
            <li>Updated the Turkish localization file (by @NovaDiablox)</li>
            <li>Grenades have icons</li>
            <li>Brought <code>C4</code>, <code>defuser</code>, <code>flaregun</code>, <code>health_station</code>, <code>radio</code> weapons down from upstream (by @a7f3)</li>
            <li>Updated help text for <code>C4</code>, <code>defuser</code>, <code>flaregun</code>, <code>health_station</code>, <code>radio</code>, <code>knife</code>, <code>phammer</code>, <code>push</code>, and <code>zm_carry</code> weapons (by @a7f3)</li>
            <li>Brought down the <code>EFFECT</code>s: <code>crimescene_dummy</code>, <code>crimescene_shot</code>, <code>pulse_sphere</code>, <code>teleport_beamdown</code>, <code>teleport_beamup</code></li>
            <li>Brought down the <code>ENT</code>s: <code>ttt_basegrenade_proj</code>, <code>ttt_carry_handler</code> (unused), <code>ttt_firegrenade_proj</code>, <code>ttt_smokegrenade_proj</code>, <code>ttt_weapon_check</code></li>
            <li>Brought down the <code>SWEP</code>: <code>weapon_ttt_stungun</code></li>
            <li>Brought down the menu for arming/defusing C4</li>
            <li>Updated and improved Simplified Chinese translation (by @sbzlzh and @TheOnly8Z)</li>
            <li>Improved Simplified Chinese translation（by @TEGTainFan）</li>
            <li>Consolidated hat logic</li>
            <li>Player role selection logic uses <code>Player:CanSelectRole()</code> now instead of duplicating logic</li>
            <li>Role avoidance is no longer an option</li>
            <li>All <code>builtin</code> weapons can now be configured to drop via <code>Edit Equipment</code> (by @EntranceJew)</li>
            <li>Removed redundant checks outside of <code>SWEP:DrawHelp</code>, protected only <code>SWEP:DrawHelp</code></li>
            <li>Spectator name labels now use a skin font and scaling (by @EntranceJew)</li>
            <li>The built-in radar now displays distances in meters (by @TimGoll)</li>
            <li>Converted <code>ttt_ragdoll_pinning</code> and <code>ttt_ragdoll_pinning_innocents</code> into per-role permissions</li>
            <li>Magneto stick now allows right-clicking to instantly drop something, while left-clicking still releases/throws it</li>
            <li>Magneto stick now shows tooltips respective to its current state</li>
            <li>Scoreboard shows non-policing detective results, in sync with the miniscoreboard (by @EntranceJew)</li>
            <li><code>ttt_flame</code> is visible while it is moving (by @EntranceJew)</li>
            <li><code>ttt_flame</code>'s hurtbox is more accurate to its visuals (by @EntranceJew)</li>
            <li>The built-in DNA scanner now displays distances in meters (by @TimGoll)</li>
            <li>Noisy prints are now gated behind various levels of <code>developer</code> convar (by @EntranceJew)</li>
            <li>Any warnings developers should fix will now print with stack traces (by @EntranceJew)</li>
            <li>Changed the way the role overhead icon is rendered (by @TimGoll)</li>
            <ul>
                <li>It now tracks the players head position</li>
                <li>Rendering order is based on distance, no more weird visual glitches</li>
                <li>Hidden when observing a player in first person view</li>
            </ul>
            <li>Your own spectator nametag will not display when looking directly up in post-round (by @EntranceJew)</li>
            <li>Made sure the last weapon is selected by default if the current weapon is removed; overwrite <code>OnRemove</code> to prevent that (by @TimGoll)</li>
            <li>Changed the way weapon icon caching is working to make sure all weapons always have a cached icon material (by @TimGoll)</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed database now properly saving boolean <code>false</code> values (by @ZenBre4ker)</li>
            <li>Fixed cached weapons not being selected after giving them back to the owner (by @TimGoll)</li>
            <li>The roundendscreen can now be closed with the correct Binding (by @ZenBre4ker)</li>
            <li>Fixed last seen player being wrongly visible for every search instead of only public policing role search (by @TimGoll)</li>
            <li>Fixed the crosshair being offcenter on some UI scales (by @TimGoll)</li>
            <li>Fixed to wrong line calculations for wrapped text (by @NickCloudAT)</li>
            <li>Fixed marks library having self zfailing and color issues (by @WardenPotato)</li>
            <li>Fixed <code>IsPlayer</code> failing if a non-entity is passed to it (by @TimGoll)</li>
            <li>Fixed <code>draw.Arc</code> when gmod_mcore_test is set to 1 (by @WardenPotato)</li>
            <li>Fixed weapon help box width for wide bindings with short descriptions (by @TimGoll)</li>
            <li>Fixed <code>GM:TTTBodySearchPopulate</code> using the wrong data variable (by @TimGoll)</li>
            <li>Fixed font initialization to not trip engine font fallback behavior (by @EntranceJew)</li>
            <li>Fixed the decoy producing a wrong colored icon for other teams (by @NickCloudAT)</li>
            <li>Fixed the scoreboard being stuck open sometimes if the inflictor was no weapon (by @TimGoll)</li>
            <li>Fixed door health displaying as a humongous string of decimals (by @EntranceJew)</li>
            <li>Fixed weapons that use the wrong weapon base from throwing errors in the F1 menu (by @TimGoll)</li>
        </ul>

        <h2>Removed</h2>
        <ul>
            <li>Removed some crosshair related convars and replaced them with other ones, see the crosshair settings menu for details</li>
            <li>Removed DX8/SW models that aren't used</li>
            <li>Removed the convar <code>ttt_damage_own_healthstation</code> as it was inconsistent and probably unused as well</li>
            <li>Removed <code>ttt_fire_fallback</code>, there's no situation where the fire shouldn't draw anymore</li>
            <li>Removed <code>resource.AddFile</code> calls, server operators should use the workshop version or manually bundle loose files</li>
        </ul>

        <h2>Breaking Changes</h2>
        <ul>
            <li>Moved global shared <code>EquipmentIsBuyable(tbl, ply)</code> to <code>shop.CanBuyEquipment(ply, equipmentName)</code></li>
            <ul>
                <li>Returned text and result are now replaced by a statusCode</li>
            </ul>
            <li>No more <code>plymeta:GetAvoidRole(role)</code> or <code>plymeta:GetAvoidDetective()</code></li>
            <li>Moved global <code>TEAMBUYTABLE</code> to <code>shop.teamBuyTable</code> and separated <code>BUYTABLE</code> into <code>shop.buyTable</code> and <code>shop.globalBuyTable</code></li>
            <ul>
                <li>Use new Accessors <code>shop.IsBoughtFor(ply, equipmentName)</code>, <code>shop.IsGlobalBought(equipmentName)</code> and <code>shop.IsTeamBoughtFor(ply, equipmentName)</code></li>
                <li>Use new Setter <code>shop.SetEquipmentBought(ply, equipmentName)</code>, <code>shop.SetEquipmentGlobalBought(equipmentName)</code> and <code>shop.SetEquipmentTeamBought(ply, equipmentName)</code></li>
            </ul>
        </ul>
    ]],
        os.time({ year = 2024, month = 02, day = 23 })
    )

    AddChange(
        "TTT2 Base - v0.13.1b",
        [[

        <h2>Fixed</h2>
        <ul>
            <li>Fixed rendering for weapons not based on the TTT2 base (e.g. TFA) (by @TimGoll)</li>
            <li>Fixed bodysearch entries not having a title breaking the rendering (by @TimGoll)</li>
            <li>Fixed <code>GetViewModel</code> error on the client when joining a server (by @TimGoll)</li>
            <li>Fixed the new view changes preventing weapons from modifying the playerview (by @TimGoll)</li>
            <li>Fixed the new view changes affecting non-player entities (by @TimGoll)</li>
            <li>Fixed an error in an error message (by @mexikoedi)</li>
        </ul>
    ]],
        os.time({ year = 2024, month = 02, day = 27 })
    )

    AddChange(
        "TTT2 Base - v0.13.2b",
        [[
        <h2>Added</h2>
        <ul>
            <li>Added upstream content files to base TTT2</li>
            <li>Added <code>plymeta:IsFullySignedOn()</code> to allow excluding players that have not gotten control yet (by @EntranceJew)</li>
        </ul>
        <h2>Changed</h2>
        <ul>
            <li>Crosshair rendering now is a bit more flexible and customizable</li>
            <li>A crosshair is now also drawn when holding a nade, making it less confusing when looking at entities</li>
            <li>Hides item settings in the equipment editor that are only relevant for weapons</li>
            <li>The binoculars now use the default crosshair as well</li>
        </ul>
        <h2>Fixed</h2>
        <ul>
            <li>Fixed the AFK timer accumulating while player not fully joined (by @EntranceJew)</li>
            <li>Fixed weapons which set a custom view model texture having an error texture</li>
            <li>Fixed the equipment menu throwing errors when clicking on some items</li>
            <li>TTT2 now ignores Gmods SWEP.DrawCrosshair and always draws just its own crosshair to prevent two crosshairs at once</li>
            <li>Fixed hud help text not being shown for some old weapons</li>
            <li>Fixed detective search being overwritten by player search results</li>
        </ul>
    ]],
        os.time({ year = 2024, month = 03, day = 10 })
    )

    AddChange(
        "TTT2 Base - v0.14.0b",
        [[

        <h2>Added</h2>
        <ul>
            <li>Added hook <code>ENTITY:ClientUse()</code>, which is triggered clientside if an entity is used</li>
            <ul>
                <li>Return true to prevent also using this on the server for clientside only usecases</li>
            </ul>
            <li>Added hook <code>ENTITY:RemoteUse(ply)</code>, which is shared</li>
            <ul>
                <li>Return true if only clientside should be used</li>
            </ul>
            <li>Added RemoteUse to radio, you can now directly access it via use button on marker focus</li>
            <li>Added sounds to multiple UI interactions (can be disabled in settings: Gameplay > Client-Sounds)</li>
            <li>Added a globally audible sound when searching a body</li>
            <li>Added the option to add a subtitle to a marker vision element</li>
            <li>Added the option to assign random unique models at round start</li>
            <li>Added a new voice chat UI</li>
            <li>Added new credit related hooks</li>
            <ul>
                <li>Added <code>GM:TTT2CanTakeCredits()</code> hook for overriding whether a player is allowed to take credits from a given corpse</li>
                <li>Added <code>GM:TTT2OnGiveFoundCredits()</code> hook which is called when a player has been given credits for searching a corpse</li>
                <li>Added <code>GM:TTT2OnReceiveKillCredits()</code> hook which is called when a player receives credits for a kill</li>
                <li>Added <code>GM:TTT2OnReceiveTeamAwardCredits()</code> hook which is called when a player receives credits as a team award</li>
                <li>Added <code>GM:TTT2OnTransferCredits()</code> hook which is called when a player has successfully transferred a credit to another player</li>
            </ul>
            <li>Disabled locational voice during the preparing phase by default</li>
            <ul>
                <li>Added a ConVar <code>ttt_locational_voice_prep</code> to reenable it</li>
            </ul>
            <li>Added SWEP.EnableConfigurableClip and SWEP.ConfigurableClip to set the weapon's clip on buy via the equipment editor</li>
            <li>Added Text / Nickname length limiting</li>
            <li>Added <code>ttt_locational_voice_range</code> to set a cut-off radius for the locational voice chat range</li>
            <li>Added a convar <code>ttt2_inspect_credits_always_visible</code> to control whether credits are visible to players that do not have a shop</li>
            <li>Added multiple global voice chat activation modes for clients to choose from (Gameplay > Voice & Volume):</li>
            <ul>
                <li>Push-to-Talk (default)</li>
                <li>Push-to-Mute</li>
                <li>Toggle</li>
                <li>Toggle (Activate on Join)</li>
            </ul>
            <li>Team Voice Chat is always push-to-talk and temporarily disables global voice chat while being used</li>
            <li>Added a new generic button to F1 menu elements to be used in custom menus</li>
            <li>Added toggle and run buttons to many F1 menu elements</li>
            <li>Added combo cards to the UI, clickable cards that act like combo boxes</li>
            <li>Added a run button to bindings in the bindings menu</li>
            <li>Added a new admin commands menu</li>
            <ul>
                <li>Added a submenu to change maps</li>
                <li>Added a submenu to issue basic commands</li>
            </ul>
            <li>Added a new gameloop module that contains all functions related to the round structure</li>
            <li>Added a loading screen that hides the visible and audible lag introduced by the map cleanup on round change</li>
            <li>Added a voice battery module that handles the voice battery</li>
            <li>Added <code>admin.IsAdmin(ply)</code> as a wrapper that automatically calls <code>GM:TTT2AdminCheck</code></li>
            <ul>
                <li>Made sure this new function is used in our whole codebase for all admin checks</li>
            </ul>
            <li>Added <code>ENTITY:IsPlayerRagdoll</code> to check if a corpse is a real player ragdoll</li>
            <li>Added improved vFire integration for everything in TTT2 that spawns fire</li>
            <li>Added the <code>SWEP.DryFireSound</code> field to the weapon base to allow the dryfire sound to be easily changed</li>
            <li>Added role derandomization options for perceptually fairer role distribution, enabled by default</li>
            <li>Added targetID to buttons</li>
            <li>Added force role admin command</li>
            <li>Added <code>draw.RefreshAvatars(id64)</code> to refresh avatar icons</li>
            <li>Added <code>GM:TTT2OnButtonUse(ply, ent, oldState)</code>: a hook that is triggered when a button is pressed and that is able to prevent that button press</li>
            <li>Added TargetID and keyInfo to vehicles</li>
            <li>Added <code>GM:TTT2PostButtonInitialization(buttonList)</code>: a hook that is called after all buttons on the map have been initialized</li>
            </ul>
        <h2>Changed</h2>
        <ul>
            <li>Placeable Entities are now checked for pickup clientside first</li>
            <ul>
                <li>C4 UI is not routed over the server anymore</li>
            </ul>
            <li>Visualizer can now only be picked up by the originator</li>
            <li>TargetID is now hidden when a marker vision element is focused</li>
            <li>Tracers are now drawn for every shot/pellet instead of only 25% of shots/pellets</li>
            <li>The ConVar <code>ttt_debug_preventwin</code> will now also prevent the time limit from ending the round</li>
            <li><code>GM:TTT2GiveFoundCredits</code> hook is no longer called when checking whether a player is allowed to take credits from a given corpse</li>
            <li>Micro optimizations</li>
            <ul>
                <li>use <code>net.ReadPlayer</code> / <code>net.WritePlayer</code> if applicable instead of <code>net.Read|WriteEntity</code></li>
                <li>Reduced radar bit size for net message</li>
                <li>The holdtype for pistol weapons now matches the viewmodel</li>
            </ul>
            <li><code>VOICE.IsSpeaking(ply)</code> (clientside) can now be used to check if any player is speaking to you</li>
            <li>Unified the spec color usage throughout the whole UI</li>
            <li>Cleanup and performance optimizations for marks library</li>
            <li>Updated the Turkish localization file</li>
            <li>The level time now starts with the first preparing phase, meaning that idle on connect doesn't decrease the map time</li>
            <li>Minor cleanup and optimizations in weapon code</li>
            <li>Shotgun weapon changes</li>
            <ul>
                <li>Dry firing (attempting to shoot with no ammo) will now make you reload if possible, like all the other weapons do</li>
                <li>Interrupting the reload should look and feel less jank</li>
                <li>A third-person animation now plays when each shell is loaded (the pistol reload animation seems to fit best)</li>

            <li>Now always properly checks if an entity is a true ragdoll to make sure no other props get ragdoll handling</li>
            <li>Spectators are now able to look at corpses on fire</li>
            <li>Corpses on fire display that information in targetID and MStack</li>
            <li>Updated Russian and English localization files</li>
            <li>Made <code>ply:IsReviving</code> a shared player variable</li>
            <li>Updated and improved the Simplified Chinese localization file</li>
            <li>Avatar icons are not fetched anymore but instead created with AvatarImage (fixes missing icons for Chinese players)</li>
            <li><code>GM:TTT2PlayerReady</code> is now called for every player even on clients</li>
            <li>Updated Japanese translation</li>
            <li><code>plyspawn.GetSpawnPointsAroundSpawn</code> now tries to find spawns that are on the ground if possible</li>
        </ul>
        <h2>Fixed</h2>
        <ul>
            <li>DynamicCamera error when a weapon's CalcView doesn't return complete values</li>
            <li>Roundendscreen showing karma changes even if karma is disabled</li>
            <li>The player's FOV staying zoomed in if their weapon is removed while scoped in</li>
            <li>The player's FOV staying zoomed in with the binoculars if they're removed from you</li>
            <li>Weapon unscoping (or generally any time FOV is set back to default) being delayed due to the player's lag</li>
            <li>Overhead icons sometimes being stuck at random places</li>
            <li>A null entity error in the ShootBullet function in <code>weapon_tttbase</code></li>
            <li>A nil compare error in the DrawHUD function in <code>weapon_tttbasegrenade</code></li>
            <li>Players sometimes not receiving their role if they joined late to the game</li>
            <li>Crowbar attack animation not being visible to the player swinging it</li>
            <li>Weapon dryfire sound interrupting the weapon's gunshot sound</li>
            <li>Incendiaries sometimes exploding without fire</li>
            <li>Scoreboard not showing any body search info on players that changed to forced spec during a round</li>
            <li>vFire explosions killing a player even if they have NoExplosionDamage equipped</li>
            <li>A nil error in the PreDrop function in weapon_ttt_cse</li>
            <li><code>table.FullCopy(tbl)</code> behavior when tbl contained a Vector or Angle</li>
            <li>The bodysearch showing a wrong player icon when searching a fake body</li>
            <li>Players respawned with <code>ply:Revive</code> sometimes spawning on a fake corpse</li>
            <li>Undefined Keys breaking the gamemode</li>
            <li>markerVision elements being visible to teammates of unknown teams (such as team Innocent)</li>
            <li>Inverted settings being inverted twice in the equipment editor</li>
            <li>OldTTT HUD sidebar elements missing translation</li>
            <li>Avatar icons not refreshing if they were changed on Steam</li>
            <li>A wrong label for the sprint speed multiplier in the F1 menu</li>
            <li>Own player name being shown in targetID when in vehicle</li>
            <li>Fixed <code>ShopEditor.BuildValidEquipmentCache()</code> being called too early on the client, resulting in a wrong cache state</li>
        </ul>
        <h2>Removed</h2>
        <ul>
            <li>Radio tab in shop UI</li>
            <li>All uses of UseOverride-Hook inside TTT2 (It's still available for addons!)</li>
            <li><code>round_restart</code>, <code>round_selected</code> and <code>round_started</code> MStack messages to reduce message spam</li>
            <li>The old tips panel visible to spectators (moved to the new loading screen)</li>
        </ul>
        <h2>Breaking Changes</h2>
        <ul>
            <li>Renamed <code>GM:TTT2ModifyVoiceChatColor(ply, clr)</code> to <code>GM:TTT2ModifyVoiceChatMode(ply, mode)</code></li>
            <li>Renamed <code>ply:GetHeightVector()</code> to <code>ply:GetHeadPosition()</code></li>
            <li>Removed the TIPS module and replaced it with a new tips module</li>
            <li>Removed <code>draw.WebImage(url, x, y, width, height, color, angle, cornerorigin)</code> and <code>draw.SeamlessWebImage(url, parentwidth, parentheight, xrep, yrep, color)</code> from the draw module</li>
            <li>Due to <code>GM:TTT2PlayerReady</code> now being called for every player, addon devs have to make sure to check the player on the client</li>
        </ul>

    ]],
        os.time({ year = 2024, month = 09, day = 20 })
    )

    AddChange(
        "TTT2 Base - v0.14.1b",
        [[

        <h2>Added</h2>
        <ul>
            <li>Added Korean translation (by @Kojap)</li>
            <li>Added diagnostic information to the addonchecker output.</li>
            <ul>
                <li>This also includes a Garry's Mod version check which triggers a warning if TTT2 is not compatible. First baseline version is '240313' (by @NickCloudAT)</li>
            </ul>
            <li>Added <code>GM:TTT2PlayDeathScream</code> hook to cancel or overwrite/change the deathscream sound that plays, when you die (by @NickCloudAT)</li>
            <li>Added support for "toggle_zoom" binds to trigger the radio commands menu (by @TW1STaL1CKY)</li>
            <li>Added option to use right click to enable/disable roles in the role layering menu (by @TimGoll)</li>
            <li>Added a menu to allow admins to inspect, in detail, how and why roles are distributed as they are (by @nike4613)</li>
            <li>Added option to enable team name next to role name on the HUD (by @milkwxter)</li>
            <li>Added score event for winning with configurable role parameter (by @MrXonte)</li>
            <li>Added ExplosiveSphereDamage game effect for easy calculation of explosion damage through walls (by @MrXonte)</li>
            <li>Added support for outlines of different thickness (by @Wardenpotato)</li>
        </ul>
        <h2>Fixed</h2>
        <ul>
            <li>Fixed missing translation for None role error by removing it (by @mexikoedi)</li>
            <li>Fixed sometimes entity use triggering the wrong or no entity (by @TimGoll)</li>
            <li>Fixed translation of muting Terrorists and Spectators (by @mexikoedi)</li>
            <li>Fixed continuous use being broken, meaing that holding E on a health station did nothing (by @TimGoll)</li>
            <li>Fixed the loadingscreen disable causing an error (by @TimGoll)</li>
            <li>Fixed the rounds left always displaying one less than actually left (by @TimGoll)</li>
            <li>Fixed rendering glitches in the loading screen (by @TimGoll)</li>
            <li>Fixed weapon pickup through walls (by @MrXonte)</li>
            <li>Fixed spectating player still being visible through thermalvision after killing that player (by @MrXonte)</li>
            <li>Fixed Magneto-stick not using C_Hands (by @SvveetMavis)</li>
            <li>Fixed console error when dropping ammo for weapons with no AmmoEnt (by @MrXonte)</li>
            <li>Fixed client error for a not fully initialized client (by @Histalek)</li>
            <li>Fixed the targetID corpse hint not respecting <code>ttt_identify_body_woconfirm</code> (by @Histalek)</li>
            <li>Fixed the beacon not being properly translated when placed (by @Histalek)</li>
            <li>Fixed binoculars zooming not being predicted (by @Histalek)</li>
            <li>Fixed an error when trying to pickup a placed equipment (e.g. beacon) (by @Histalek)</li>
            <li>Fixed corpse searching sound playing when searched by a spectator, searched covertly, or searched long range (by @TW1STaL1CKY)</li>
            <li>Fixed the mute button in the scoreboard not working (by @TW1STaL1CKY)</li>
            <li>Fixed a few errors in shop error messages (by @Histalek)</li>
            <li>Fixed <code>markerVision</code>'s registry table being able to contain duplicate obsolete entries, thus fixing potential syncing issues with markers (by @TW1STaL1CKY)</li>
            <li>Fixed issue in new Ammo dropping that could cause an error when dropping for modified weapon bases. (by @MrXonte)</li>
            <li>Fixed C4 not showing the correct inflictor when the player is killed (by @TimGoll)</li>
            <li>Fixed M16 Ironsight misalignment (by @SvveetMavis)</li>
            <li>Fixed outline interactions with certain weapon scopes (by @WardenPotato)</li>
            <li>Fixed outlines not rendering uniformly (by @WardenPotato)</li>
        </ul>
        <h2>Changed</h2>
        <ul>
            <li>Updated French translation (by @MisterClems)</li>
            <li>Updated Turkish localization (by @NovaDiablox)</li>
            <li>Changed it so that continous use doesn't require direct focus; healing at a health station also works when looking around as long as you stay close by (by @TimGoll)</li>
            <li>Updated Russian localization (by @Satton2)</li>
            <li>Updated targetID to use <code>Vehicle:GetDriver</code> instead of the <code>ttt_driver</code> NWEntity (by @Histalek)</li>
            <li>Updated Russian and English localization files (by @Satton2)</li>
            <li>Updated old TTT HUD to show name of spectated player (by @somefnfplayerlol)</li>
            <li>Changes to the enabled map prefixes will not be announced to players anymore (by @Histalek)</li>
            <li>By default only <code>ttt</code> and <code>ttt2</code> map prefixes are enabled (by @Histalek)</li>
            <li>Updated <code>ttt_identify_body_woconfirm</code> to be replicated across the server and client (by @Wryyyong)</li>
            <li>Changed how Ammo is dropped; if drop should be from reserve ammo, now tries to drop a full ammo box instead of a full clip. (by @MrXonte)</li>
            <li>Updated <code>ttt_spec_prop_control</code> to be replicated across the server and client (by @NickCloudAT)</li>
            <ul>
                <li>With this, the KeyHelp feature also hides the PropSpec bind if PropSpec is disabled on the server</li>
            </ul>
            <li>Renamed <code>ttt_session_limits_enabled</code> to <code>ttt_session_limits_mode</code>, introducing a four-mode control (0-3) for managing how TTT2 ends a session. (by @NickCloudAT)</li>
            <ul>
                <li>Modes: 0 = No session limit, 1 = Default TTT, 2 = Only time limit, 3 = Only round limit</li>
            </ul>
            <li>Moved all role-related admin options into the "Roles" menu (by @nike4613)</li>
            <li>Improved description of role layering (by @nike4613)</li>
            <li>Improved the role layering menu by showing which role is enabled and which is disabled (by @TimGoll)</li>
            <li>Reworked C4 damage calculation with new gameEffect ExplosiveSphereDamage (by @MrXonte)</li>
            <li>Changed the amount the M16 zooms in (by @SvveetMavis)</li>
        </ul>

    ]],
        os.time({ year = 2025, month = 02, day = 01 })
    )

    AddChange(
        "TTT2 Base - v0.14.2b",
        [[

        <h2>Fixed</h2>
        <ul>
            <li>Fixed new outlines' `OUTLINE_MODE_VISIBLE` and `OUTLINE_MODE_BOTH`</li>
        </ul>

    ]],
        os.time({ year = 2025, month = 02, day = 02 })
    )

    AddChange(
        "TTT2 Base - v0.14.3b",
        [[

        <h2>Added</h2>
        <ul>
            <li>Added C4 cvars for adjusting the range & falloff of C4 explosions (by @Spanospy)</li>
            <ul>
                <li>C4 explosions will now also respect the weapon's configured damage scaling</li>
            </ul>
            <li>Added option to select preferred unit of length for distance displays (by @wgetJane)</li>
            <li>Added <code>GM:TTT2ArmorHandlePlayerTakeDamage</code> hook for modifying/overriding armor behavior (by @wgetJane)</li>
            <li>Added server option for body armor to protect against crowbar damage (by @wgetJane)</li>
            <li>Added <code>GM:TTTLastWordsMsg</code> hook from base TTT (by @wgetJane)</li>
            <li>Port new TTT entity <code>ttt_filter_role</code> to TTT2 (by @figardo, ported by @wgetJane)</li>
            <li>Added 2 new sprint settings (by @wgetJane)</li>
            <ul>
                <li>Stamina cooldown time before stamina begins regenerating after sprinting, 0.8 seconds by default</li>
                <li>Option to require forward key to be held to sprint, enabled by default</li>
            </ul>
        </ul>

        <h2>Changed</h2>
        <ul>
            <li>Updated Russian and English localization files (by @Satton2)</li>
            <li>Updated the list of troublesome addons used by the addonchecker</li>
            <li>Changed option for body armor to protect against headshot damage by default (by @wgetJane)</li>
        </ul>

        <h2>Fixed</h2>
        <ul>
            <li>Fixed classic armour protecting against crowbar damage (by @wgetJane)</li>
            <li>Fixed C4/Radio sounds not playing outside of PAS (by @figardo)</li>
            <li>Fixed players sometimes being revealed as dead when they chat/voicechat right as they die (by @wgetJane)</li>
            <li>Fixed various bugs related to using doors and buttons, to match base TTT behavior (by @wgetJane)</li>
            <ul>
                <li>Fixed brush doors on certain maps not being usable</li>
                <li>Fixed certain doors on certain maps being forcibly usable when they shouldn't be</li>
                <li>Fixed func_rotating being forcibly usable</li>
                <li>Fixed vehicles not being usable</li>
                <li>Removed forced button solidity</li>
                <li>Improved targetID trace detection for doors and buttons</li>
                <li>Allow brush doors to be detected as destructible for targetID</li>
                <li>Use NW2Vars instead of NWVars for door variables for more efficient networking</li>
                <li>Fixed clientside door.GetAll() to return a more updated list of doors</li>
                <li>Removed clientside TTT2PostDoorSetup hook</li>
                <li>Changed crowbar unlocking behavior to match base TTT</li>
            </ul>
            <li>Fixed lua errors after autorefresh (by @wgetJane)</li>
            <li>Fixed Hud errors when picking up items or weapons with no viable icon (by @NickCloudAT)</li>
        </ul>

    ]],
        os.time({ year = 2025, month = 03, day = 18 })
    )

    ---
    -- run hook for other addons to add their changelog as well
    -- @realm client
    hook.Run("TTT2AddChange", changes, currentVersion)
end

---
-- @realm client
function GetSortedChanges()
    CreateChanges()

    -- sort changes list by date
    table.sort(changes, function(a, b)
        if a.date < 0 and b.date < 0 then
            return a.date < b.date
        else
            return a.date > b.date
        end
    end)

    return changes
end

net.Receive("TTT2DevChanges", function(len)
    if changesVersion:GetString() == GAMEMODE.Version then
        return
    end

    --ShowChanges()

    RunConsoleCommand("changes_version", GAMEMODE.Version)
end)

---
-- This hook can be used to populate the changelog table. It is recommended
-- to use @{AddChange} to add an entry to the changelog.
-- @param table changesTbl The current changelog table
-- @param string currentVersionNumber The current version number
-- @hook
-- @realm client
function GM:TTT2AddChange(changesTbl, currentVersionNumber) end
