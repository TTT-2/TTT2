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
	table.insert(changes, 1, {version = version, text = text, date = date or -1 * (#changes + 1)})

	currentVersion = version
end

---
-- Creates the changes list
-- @realm client
-- @internal
function CreateChanges()
	if changes then return end

	changes = {}

	AddChange("TTT2 Base - v0.3.5.6b", [[
		<ul>
			<li><b>many fixes</b></li>
			<li>enabled picking up grenades in prep time</li>
			<li>roundend scoreboard fix</li>
			<li>disabled useless prints that have spammed the console</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.5.7b", [[
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
	]])

	AddChange("TTT2 Base - v0.3.5.8b", [[
		<ul>
			<li><b>selection system update</b></li>
			<br />
			<li>added different ConVars</li>
			<li>added possibility to force a role in the next roleselection</li>
			<br />
			<li>bugfixes</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.6b", [[
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
	]])

	AddChange("TTT2 Base - v0.3.7b", [[
		<ul>
			<li>added hook <code>TTT2ToggleRole</code></li>
			<li>added <code>GetActiveRoles()</code></li>
			<br />
			<li>fixed TTT spec label issue</li>
			<br />
			<li>renamed hook <code>TTT_UseCustomPlayerModels</code> into <code>TTTUseCustomPlayerModels</code></li>
			<li>removed <code>Player:SetSubRole()</code> and <code>Player:SetBaseRole()</code></li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.7.1b", [[
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
	]])

	AddChange("TTT2 Base - v0.3.7.2b", [[
		<ul>
			<li>reworked the <b>credit system</b> (Thanks to Nick!)</li>
			<li>added possibility to override the init.lua and cl_init.lua file in TTT2</li>
			<br />
			<li>fixed server errors in combination with TTT Totem (now, TTT2 will just not work)</li>
			<li>fixed ragdoll collision server crash (issue is still in the normal TTT)</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.7.3b", [[
		<ul>
			<li>reworked the <b>selection system</b> (balancing and bugfixes)</li>
			<br />
			<li>fixed playermodel issue</li>
			<li>fixed toggling role issue</li>
			<li>fixed loadout doubling issue</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.7.4b", [[
		<ul>
			<li>fixed playermodel reset bug (+ compatibility with PointShop 1)</li>
			<li>fixed external HUD support</li>
			<li>fixed credits bug</li>
			<li>fixed detective hat bug</li>
			<li>fixed selection and jester selection bug</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.8b", [[
		<ul>
			<li>added new TTT2 Logo</li>
			<li>added ShopEditor missing icons (by Mineotopia)</li>
			<br />
			<li><b>reworked weaponshop → ShopEditor</b></li>
			<li>changed file based shopsystem into sql</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.8.1b", [[
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
	]])

	AddChange("TTT2 Base - v0.3.8.2b", [[
		<ul>
			<li>added <b>russian translation</b> (by Satton2)</li>
			<li>added <code>.minPlayers</code> indicator for the shop</li>
			<br />
			<li>replaced <code>.globalLimited</code> param with <code>.limited</code> param to toggle whether an item is just one time per round buyable for each player</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.8.3b", [[
		<ul>
			<li>ammoboxes will store the correct amount of ammo now
			<li>connected <b>radio commands</b> with <b>scoreboard #tagging</b> (https://github.com/Exho1/TTT-ScoreboardTagging/blob/master/lua/client/ttt_scoreboardradiocmd.lua)</li>
		</ul>
	]])

	AddChange("TTT2 Base - v0.3.9b", [[
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
	]])

	AddChange("TTT2 Base - v0.4.0b", [[
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
	]])

	AddChange("TTT2 Base - v0.5.0b", [[
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
	]], os.time({year = 2019, month = 03, day = 03}))

	AddChange("TTT2 Base - v0.5.1b", [[
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
	]], os.time({year = 2019, month = 03, day = 05}))

	AddChange("TTT2 Base - v0.5.2b", [[
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
	]], os.time({year = 2019, month = 04, day = 32}))

	AddChange("TTT2 Base - v0.5.3b", [[
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
	]], os.time({year = 2019, month = 05, day = 09}))

	AddChange("TTT2 Base - v0.5.4b", [[
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
	]], os.time({year = 2019, month = 06, day = 18}))

	AddChange("TTT2 Base - v0.5.5b", [[
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
	]], os.time({year = 2019, month = 07, day = 07}))

	AddChange("TTT2 Base - v0.5.6b", [[
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
	]], os.time({year = 2019, month = 09, day = 03}))

	AddChange("TTT2 Base - v0.5.6b-h1 (Hotfix)", [[
		<h2>Fixed:</h2>
		<ul>
			<li>Traitor shop bug (caused by the september'19 GMod update)</li>
			<li>ShopEditor bugs and added a response for non-admins</li>
			<li>Glitching head icons</li>
		</ul>
	]], os.time({year = 2019, month = 09, day = 06}))

	AddChange("TTT2 Base - v0.5.7b", [[
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
	]], os.time({year = 2019, month = 10, day = 06}))

	AddChange("TTT2 Base - v0.6b", [[
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
	]], os.time({year = 2020, month = 02, day = 16}))

	AddChange("TTT2 Base - v0.6.1b", [[
		<h2>Fixed:</h2>
		<ul>
			<li>Fixed a bug with the spawn wave interval</li>
		</ul>
	]], os.time({year = 2020, month = 02, day = 17}))

	AddChange("TTT2 Base - v0.6.2b", [[
		<h2>Fixed:</h2>
		<ul>
			<li>Increased the maximum number of roles that can be used. (Fixes weird role issues with many roles installed)</li>
		</ul>
	]], os.time({year = 2020, month = 03, day = 1}))

	AddChange("TTT2 Base - v0.6.3b", [[
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
	]], os.time({year = 2020, month = 03, day = 05}))

	AddChange("TTT2 Base - v0.6.4b", [[
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
	]], os.time({year = 2020, month = 04, day = 03}))

	AddChange("TTT2 Base - v0.7.0b", [[
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
	]], os.time({year = 2020, month = 06, day = 01}))

	AddChange("TTT2 Base - v0.7.1b", [[
		<h2>Fixed:</h2>
		<ul>
			<li>Fixed max roles / max base roles interaction with the roleselection. Also does not crash with values != 0 anymore.</li>
		</ul>
	]], os.time({year = 2020, month = 06, day = 02}))

	AddChange("TTT2 Base - v0.7.2b", [[
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
	]], os.time({year = 2020, month = 06, day = 26}))

	AddChange("TTT2 Base - v0.7.3b", [[
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
	]], os.time({year = 2020, month = 08, day = 09}))

	AddChange("TTT2 Base - v0.7.4b", [[
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
	]], os.time({year = 2020, month = 09, day = 28}))

	AddChange("TTT2 Base - v0.8.0b", [[
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
	]], os.time({year = 2021, month = 02, day = 06}))

	AddChange("TTT2 Base - v0.8.1b", [[
		<h2>Fixed:</h2>
		<ul>
			<li>Fixed inheriting from the same base using the classbuilder in different folders</li>
		</ul>
	]], os.time({year = 2021, month = 02, day = 19}))

	AddChange("TTT2 Base - v0.8.2b", [[
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
	]], os.time({year = 2021, month = 03, day = 25}))

	AddChange("TTT2 Base - v0.9.0b", [[
		<h2>Added:</h2>
		<ul>
			<li>All new roundend menu</li>
			<ul>
				<li>new info panel that shows detailed role distribution during the round</li>
				<li>info panel also states detailed score events</li>
				<li>new timeline that displays the events that happened during the round</li>
				<li>added two new round end conditions: `time up` and `no one wins`</li>
			</ul>
			<li>Added `ROLE_NONE` (ID `3` by default)</li>
			<ul>
				<li>Players now default to `ROLE_NONE` instead of `ROLE_INNOCENT`</li>
				<li>Enables the possibility to give Innocents access to a custom shop (`shopeditor`)</li>
			</ul>
			<li>Karma now stores changes</li>
			<ul>
				<li>Is shown in roundend menu</li>
			</ul>
			<li>Added a new hook `TTT2ModifyLogicCheckRole` that can be used to modify the tested role for map related role checks</li>
			<li>Added the ConVar `ttt2_random_shop_items` for the number of items in the randomshop</li>
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
			<li>Converted `roles`, `huds`, `hudelements`, `items` and `pon` modules into libraries</li>
			<li>Moved `bind` library to the libraries folder</li>
			<li>Moved favorites functions for equipment to the equipment shop and made them local functions</li>
			<li>Code cleanup and removed silly negations</li>
			<li>Extended some ttt2net functions</li>
			<li>Changed `bees` win to `nones` win</li>
			<li>By default all evil roles are now counted as traitor roles for map related checks</li>
			<li>Changed the ConVar `ttt2_random_shops` to only disable the random shop (if set to `0`)</li>
			<li>Shopeditor settings are now available in the F1 Menu</li>
			<li>Moved the F1 menu generating system from a hook based system to a file based system</li>
			<ul>
				<li>removed the hooks `TTT2ModifyHelpMainMenu` and `TTT2ModifyHelpSubMenu`</li>
				<li>menus are now generated based on files located in `lua/terrortown/menus/gamemode/`</li>
				<li>submenus are generated from files located in folders with the menu name</li>
			</ul>
			<li>Menus without content are now always hidden in the main menu</li>
			<li>Moved Custom Shopeditor and linking shop to roles to the F1 menu</li>
			<li>Moved inclusion of cl_help to the bottom as nothing depends on it, but menus created by it could depend on other client files</li>
			<li>Shopeditor equipment is now available in F1 menu</li>
			<li>Moved the role layering menu to the F1 menu (administration submenu)</li>
			<ul>
				<li>removed the command `ttt2_edit_rolelayering`</li>
			</ul>
			<li>moved the internal path of `lang/`, `vskin/` and `events/` (this doesn't change anything for addons)</li>
			<li>Sort teammates first in credit transfer selection and add an indicator to them</li>
		</ul>

	  	<h2>Removed</h2>
		<ul>
			<li>Removed the custom loading screen (GMOD now only accepts http(s) URLs for sv_loadingurl)</li>
		</ul>

	  	<h2>Breaking Changes</h2>
		<ul>
			<li>Adjusted `Player:HasRole()` and `Player:HasTeam()` to support simplified role and team checks (no parameter are supported anymore, use `Player:GetRole()` or `Player:GetTeam()` instead)</li>
			<li>Moved global roleData to the `roles` library (e.g. `INNOCENT` to `roles.INNOCENT`). `INNOCENT`, `TRAITOR` etc. is not supported anymore. `ROLE_<ROLENAME>` is still supported and won't be changed.</li>
			<li>Shopeditor function `ShopEditor.ReadItemData()` now only updates a number of key-parameters, must be given as UInt. Messages were changed accordingly (`TTT2SESaveItem`,`TTT2SyncDBItems`)</li>
			<li>Equipment shop favorite functions are now local and not global anymore (`CreateFavTable`, `AddFavorite`, `RemoveFavorite`, `GetFavorites` & `IsFavorite`)</li>
		</ul>
	]], os.time({year = 2021, month = 06, day = 19}))

	AddChange("TTT2 Base - v0.9.1b", [[
	  	<h2>Fixed</h2>
		<ul>
			<li>Fixed shop convars not being shared / breaking the shop</li>
		</ul>
	]], os.time({year = 2021, month = 06, day = 19}))

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
	if changesVersion:GetString() == GAMEMODE.Version then return end

	--ShowChanges()

	RunConsoleCommand("changes_version", GAMEMODE.Version)
end)
