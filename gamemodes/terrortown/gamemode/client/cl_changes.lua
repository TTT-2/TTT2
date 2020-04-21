---
-- @section changes

local changesVersion = CreateClientConVar("changes_version", "v0.0.0.0")

local changesPanel
local changes
local currentVersion

local btnPanelColor = Color(22, 42, 57)

---
-- Adds a change into the changes list
-- @param string version
-- @param string text
-- @param number[default=nil] date the date when this update got released
-- @realm client
function AddChange(version, text, date)
	changes = changes or {}

	-- adding entry to table
	-- if no date is given, a negative index is stored as secondary sort parameter
	table.insert(changes, 1, {version = version, text = text, date = date or -1 * (#changes + 1)})

	currentVersion = version
end

local htmlStart = [[
	<head>
		<style>
			body {
				font-family: Verdana, Trebuchet;
				background-color: rgb(22, 42, 57);
				color: white;
				font-weight: 100;
			}
			body * {
				font-size: 13pt;
			}
			h1 {
				font-size: 16pt;
				text-decoration: underline;
			}
		</style>
	</head>
	<body>
]]

local htmlEnd = [[
	</body>
]]

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
	]], os.time({year = 2020, month = 03, day = 5}))

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
	]], os.time({year = 2020, month = 04, day = 3}))

	-- run hook for other addons to add their changelog as well
	hook.Run("TTT2AddChange", changes, currentVersion)
end

---
-- Creates the HTML panel
-- @param PANEL panel
-- @param table change
-- @realm client
-- @internal
local function MakePanel(panel, change)
	local header = "<h1>" .. change.version .. " Update"

	if change.date > 0 then
		header = header .. " <i> - (date: " .. os.date("%Y/%m/%d", change.date) .. ")</i>"
	end

	header = header .. "</h1>"

	local html = vgui.Create("DHTML", panel)

	html:SetHTML(htmlStart .. header .. change.text .. htmlEnd)
	html:Dock(FILL)
	html:DockMargin(10, 10, 10, 10)

	panel.htmlSheet = html
end

---
-- Displays the changes window
-- @realm client
function ShowChanges()
	if IsValid(changesPanel) then
		changesPanel:Remove()

		return
	end

	CreateChanges()

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
	frame:Center()
	frame:SetTitle("Update " .. currentVersion)
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)
	frame:SetDeleteOnClose(true)

	local sheet = vgui.Create("DColumnSheet", frame)
	sheet:Dock(FILL)

	sheet.Navigation:SetWidth(256)

	-- sort changes list by date
	table.sort(changes, function(a, b)
		if a.date < 0 and b.date < 0 then
			return a.date < b.date
		else
			return a.date > b.date
		end
	end)

	for i = 1, #changes do
		local change = changes[i]

		local panel = vgui.Create("DPanel", sheet)
		panel:Dock(FILL)

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, btnPanelColor)
		end

		local leftBtn = sheet:AddSheet(change.version, panel).Button

		local oldClick = leftBtn.DoClick
		leftBtn.DoClick = function(slf)
			if currentVersion == change.version then return end

			oldClick(slf)

			frame:SetTitle("TTT2 Update - " .. change.version)

			if not panel.htmlSheet then
				MakePanel(panel, change)
			end

			currentVersion = change.version
		end

		if change.version == currentVersion then
			MakePanel(panel, change)

			sheet:SetActiveButton(leftBtn)
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	changesPanel = frame

	return changesPanel
end

net.Receive("TTT2DevChanges", function(len)
	if changesVersion:GetString() ~= GAMEMODE.Version then
		ShowChanges()

		RunConsoleCommand("changes_version", GAMEMODE.Version)
	end
end)
