local changesVersion = CreateClientConVar("changes_version", "v0.0.0.0")

local changesPanel
local changes
local currentVersion

function AddChange(version, text)
	changes = changes or {}

	table.insert(changes, 1, {version = version, text = text})

	currentVersion = version
end

local htmlStart = [[
	<head>
		<style>
			body {
				color: black;
				background-color: white;
			}
			body * {
				font-size: 14pt;
			}
		</style>
	</head>
	<body>
]]

local htmlEnd = [[
	</body>
]]

function CreateChanges()
	if changes then return end

	changes = {}

	AddChange("0.3.5.6b", [[<ul>
	<li><b>many fixes</b></li>
	<li>enabled picking up grenades in prep time</li>
	<li>roundend scoreboard fix</li>
	<li>disabled useless prints that have spammed the console</li>
	</ul>]])

	AddChange("0.3.5.7b", [[<ul>
	<li><b>code optimization</b></li>
	<br />
	<li>added different CVars</li>
	<br />
	<li>fixed loadout and model issue on changing the role</li>
	<li>bugfixes</li>
	<br />
	<li>removed <code>PLAYER:UpdateRole()</code> function and hook <code>TTT2RoleTypeSet</code></li>
	</ul>]])

	AddChange("0.3.5.8b", [[<ul>
	<li><b>selection system update</b></li>
	<br />
	<li>added different ConVars</li>
	<li>added possibility to force a role in the next roleselection</li>
	<br />
	<li>bugfixes</li>
	</ul>]])

	AddChange("0.3.6b", [[<ul>
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
	</ul>]])

	AddChange("0.3.7b", [[<ul>
	<li>added hook <code>TTT2ToggleRole</code></li>
	<li>added <code>GetActiveRoles()</code></li>
	<br />
	<li>fixed TTT spec label issue</li>
	<br />
	<li>renamed hook <code>TTT_UseCustomPlayerModels</code> into <code>TTTUseCustomPlayerModels</code></li>
	<li>removed <code>Player:SetSubRole()</code> and <code>Player:SetBaseRole()</code></li>
	</ul>]])

	AddChange("0.3.7.1b", [[<ul>
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
	</ul>]])

	AddChange("0.3.7.2b", [[<ul>
	<li>reworked the <b>credit system</b> (Thanks to Nick!)</li>
	<li>added possibility to override the init.lua and cl_init.lua file in TTT2</li>
	<br />
	<li>fixed server errors in combination with TTT Totem (now, TTT2 will just not work)</li>
	<li>fixed ragdoll collision server crash (issue is still in the normal TTT)</li>
	</ul>]])

	AddChange("0.3.7.3b", [[<ul>
	<li>reworked the <b>selection system</b> (balancing and bugfixes)</li>
	<br />
	<li>fixed playermodel issue</li>
	<li>fixed toggling role issue</li>
	<li>fixed loadout doubling issue</li>
	</ul>]])

	AddChange("0.3.7.4b", [[<ul>
	<li>fixed playermodel reset bug (+ compatibility with PointShop 1)</li>
	<li>fixed external HUD support</li>
	<li>fixed credits bug</li>
	<li>fixed detective hat bug</li>
	<li>fixed selection and jester selection bug</li>
	</ul>]])

	AddChange("0.3.8b", [[<ul>
	<li>added new TTT2 Logo</li>
	<li>added ShopEditor missing icons (by Mineotopia)</li>
	<br />
	<li><b>reworked weaponshop -> ShopEditor</b></li>
	<li>changed file based shopsystem into sql</li>
	</ul>]])

	AddChange("0.3.8.1b", [[<ul>
	<li>fixed credit issue in ShopEditor (all Data will load and save correct now)</li>
	<li>fixed item credits and minPlayers issue</li>
	<li>fixed radar, disguiser and armor issue in ItemEditor</li>
	<li>fixed shop syncing issue with ShopEditor</li>
	<br />
	<li>small performance improvements</li>
	<li>cleaned up some useless functions</li>
	<li>removed <code>ALL_WEAPONS</code> table (SWEP will cache the initialized data now in it's own table / entity data)</li>
	<li>some function renaming</li>
	</ul>]])

	AddChange("0.3.8.2b", [[<ul>
	<li>added <b>russian translation</b> (by Satton2)</li>
	<li>added <code>.minPlayers</code> indicator for the shop</li>
	<br />
	<li>replaced <code>.globalLimited</code> param with <code>.limited</code> param to toggle whether an item is just one time per round buyable for each player</li>
	</ul>]])

	AddChange("0.3.8.3b", [[<ul>
	<li>ammoboxes will store the correct amount of ammo now
	<li>connected <b>radio commands</b> with <b>scoreboard #tagging</b> (https://github.com/Exho1/TTT-ScoreboardTagging/blob/master/lua/client/ttt_scoreboardradiocmd.lua)</li>
	</ul>]])

	AddChange("0.3.9b", [[<ul>
	<li>reimplemented all these nice unaccepted PullRequest for TTT on GitHub:
		<ul>
			<li><b>Custom Crosshairs</b> (<code>F1 -> Settings</code>): 'https://github.com/Facepunch/garrysmod/pull/1376/' by nubpro</li>
			<li>Performance improvements with the help of 'https://github.com/Facepunch/garrysmod/pull/1287' by markusmarkusz and Alf21</li>
		</ul>
	</li>
	<br />
	<li>added possibility to use <b>random shops!</b> (<code>ShopEditor -> Options</code>)</li>
	<li>balanced karma system (Roles that are aware of their teammates can't earn karma anymore. This will lower teamkilling)</li>
	</ul>]])

	AddChange("0.4.0b", [[<ul>
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
	</ul>]])

	AddChange("0.5.0", [[<ul>
	<li>added <b>HUDSwitcher</b> (<code>F1 -> TTT2 -> HUDSwitcher</code>)</li>
		<ul>
			<li>added old TTT HUD</li>
			<li>added PureSkin HUD</li>
		</ul>
	</li>
	<br />
	<li>added possibility to give every player his <b>own random shop</b></li>
	<li>added <b>sprint</b> to TTT2</li>
	<li>added a <b>drowning indicator</b> into TTT2</li>
	<li>added possibility to toggle auto afk</li>
	<li>added possibility to modify the time a player can dive</li>
	<li>added parameter to the bindings to detect if a player released a key</li>
	<li>added possibility to switch between team-synced and individual random shops</li>
	<li>added some nice <b>badges</b> to the scoreboard</li>
	<br />
	<li>fixed TTT2 binding system</li>
	<li>fixed Ammo pickup</li>
	<li>fixed karma issue with detective</li>
	<li>fixed DNA Scanner bug with the radar</li>
	<li>fixed loading issue in the items module</li>
	<li>fixed critical bug in the process of saving the items data</li>
	<li>fixed the Sidekick color in corpses</li>
	<li>fixed bug that detective were not able to transfer credits</li>
	<li>fixed kill-list confirm role syncing bug</li>
	<li>fixed crosshair reset bug</li>
	<li>other small bugfixes</li>
	<br />
	<li>changed convar <code>ttt2_confirm_killlist</code> to default <code>1</code></li>
	<li>improved player-target add-on</li>
	<li>improved the changelog (as you see :D)</li>
	<li>reworked sql and created a sql library</li>
	<br />
	<li>reworked the <b>slot system</b> (by LeBroomer)</li>
		<ul>
			<li>amount of carriable weapons are customizable</li>
			<li>weapons won't block slots anymore automatically</li>
			<li>slot positions are generated from weapon types</li>
		</ul>
	</li>
	</ul>]])

	hook.Run("TTT2AddChange")
end

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

	for _, change in ipairs(changes) do
		local panel = vgui.Create("DPanel", sheet)
		panel:Dock(FILL)

		panel.Paint = function(slf, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255))
		end

		local leftBtn = sheet:AddSheet("Update " .. change.version, panel).Button

		local oldClick = leftBtn.DoClick
		leftBtn.DoClick = function(slf)
			if currentVersion == change.version then return end

			oldClick(slf)

			frame:SetTitle("TTT2 Update - " .. change.version)

			if not panel.htmlSheet then
				local html = vgui.Create("DHTML", panel)
				html:SetHTML(htmlStart .. change.text .. htmlEnd)
				html:Dock(FILL)
				html:DockMargin(10, 10, 10, 10)

				panel.htmlSheet = html
			end

			currentVersion = change.version
		end

		if change.version == currentVersion then
			local html = vgui.Create("DHTML", panel)
			html:SetHTML(htmlStart .. change.text .. htmlEnd)
			html:Dock(FILL)
			html:DockMargin(10, 10, 10, 10)

			panel.htmlSheet = html

			sheet:SetActiveButton(leftBtn)
		end
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	changesPanel = frame
end

net.Receive("TTT2DevChanges", function(len)
	if changesVersion:GetString() ~= GAMEMODE.Version then
		ShowChanges()

		RunConsoleCommand("changes_version", GAMEMODE.Version)
	end
end)
