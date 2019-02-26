local changesVersion = CreateClientConVar("changes_version", "v0.0.0.0")

local changesPanel
local changes
local currentVersion

function AddChange(version, text)
	changes = changes or {}

	table.insert(changes, 1, {version = version, text = text})

	currentVersion = version
end

function CreateChanges()
	if changes then return end

	changes = {}

	AddChange("0.3.5.6b", [[
	- many fixes
	- enabled picking up grenades in prep time
	- roundend scoreboard fix
	- disabled useless prints that have spammed the console
	]])

	AddChange("0.3.5.7b", [[
	- code optimization

	- added different CVars

	- fixed loadout and model issue on changing the role
	- bugfixes

	- removed PLAYER:UpdateRole() function and hook "TTT2RoleTypeSet"
	]])

	AddChange("0.3.5.8b", [[
	- selection system update

	- added different ConVars
	- added possibility to force a role in the next roleselection

	- bugfixes
	]])

	AddChange("0.3.6b", [[
	- new networking system

	- added gs_crazyphysics detector
	- added RoleVote support
	- added new multilayed icons (+ multilayer system)
	- added credits
	- added changes window
	- added detection for registered incompatible add-ons
	- added autoslay support

	- karma system improvement
	- huge amount of bugfixes
	]])

	AddChange("0.3.7b", [[
	- added hook TTT2ToggleRole
	- added GetActiveRoles()

	- fixed TTT spec label issue

	- renamed hook "TTT_UseCustomPlayerModels" into "TTTUseCustomPlayerModels"
	- removed Player:SetSubRole() and Player:SetBaseRole()
	]])

	AddChange("0.3.7.1b", [[
	- added possibility to disable roundend if a player is reviving
	- added own Item Info functions
	- added debugging function
	- added TEAM param .alone
	- added possibility to set the cost (credits) for any equipment
	- added Player:RemoveEquipmentItem(id) and Player:RemoveItem(id) / Player:RemoveBought(id)
	- added possibility to change velocity with hook "TTT2ModifyRagdollVelocity"

	- improved external icon addon support
	- improved binding system

	- fixed loadout bug
	- fixed loadout item reset bug
	- fixed respawn loadout issue
	- fixed bug that items were removed on changing the role
	- fixed search icon display issue
	- fixed model reset bug on changing role
	- fixed Player:GiveItem bug used on round start
	- fixed dete glasses bug
	- fixed rare corpse bug
	- fixed Disguiser
	- Some more small fixes
	]])

	AddChange("0.3.7.2b", [[
	- reworked the credit system (Thanks to Nick!)
	- added possibility to override the init.lua and cl_init.lua file in TTT2

	- fixed server errors in combination with TTT Totem (now, TTT2 will just not work)
	- fixed ragdoll collision server crash (issue is still in the normal TTT)
	]])

	AddChange("0.3.7.3b", [[
	- reworked the selection system (balancing and bugfixes)

	- fixed playermodel issue
	- fixed toggling role issue
	- fixed loadout doubling issue
	]])

	AddChange("0.3.7.4b", [[
	- fixed playermodel reset bug (+ compatibility with PointShop 1)
	- fixed external HUD support
	- fixed credits bug
	- fixed detective hat bug
	- fixed selection and jester selection bug
	]])

	AddChange("0.3.8b", [[
	- added new TTT2 Logo
	- added ShopEditor missing icons (by Mineotopia)

	- reworked weaponshop -> ShopEditor
	- changed file based shopsystem into sql
	]])

	AddChange("0.3.8.1b", [[
	- fixed credit issue in ShopEditor (all Data will load and save correct now)
	- fixed item credits and minPlayers issue
	- fixed radar, disguiser and armor issue in ItemEditor
	- fixed shop syncing issue with ShopEditor

	- small performance improvements
	- cleaned up some useless functions
	- removed ALL_WEAPONS table (SWEP will cache the initialized data now in it's own table / entity data)
	- some function renaming
	]])

	AddChange("0.3.8.2b", [[
	- added russian translation (by Satton2)
	- added minPlayers indicator for the shop

	- replaced globalLimited param with limited param to toggle whether an item is just one time per round buyable for each player
	]])

	AddChange("0.3.8.3b", [[
	- ammoboxes will store the correct amount of ammo now
	- connected radio commands with scoreboard #tagging (https://github.com/Exho1/TTT-ScoreboardTagging/blob/master/lua/client/ttt_scoreboardradiocmd.lua)
	]])

	AddChange("0.3.9b", [[
	- reimplemented all these nice unaccepted PullRequest for TTT on GitHub:
	-> Custom Crosshairs [F1 -> Settings]: 'https://github.com/Facepunch/garrysmod/pull/1376/' by nubpro
	-> Performance improvements with the help of 'https://github.com/Facepunch/garrysmod/pull/1287' by markusmarkusz and Alf21

	- added possibility to use random shops! (ShopEditor -> Options)
	- balanced karma system (Roles that are aware of their teammates can't earn karma anymore. This will lower teamkilling)
	]])

	AddChange("0.4.0b", [[
	- ShopEditor:
	-> added .notBuyable param to hide item in the shops
	-> added .globalLimited and teamLimited params to limit equipment

	- added new shop (by tkindanight)
	-> you can toggle the shop everytime (your role doesn't matter)
	-> the shop will update in real time

	- added new icons
	- added warming up for randomness to make things happen... yea... random
	- added auto-converter for old items

	- decreased speed modification lags
	- improved performance
	- implemented new item system! TTT2 now supports more than 16 passive items!
	- huge amount of fixes
	]])

	AddChange("0.5.0", [[
	- added HUDSwitcher
	-> added old TTT HUD
	-> added PureSkin HUD

	- added possibility to give every player his own random shop
	- added sprint to TTT2
	- added a drowning indicator into TTT2
	- added possibility to toggle auto afk
	- added possibility to modify the time a player can dive
	- added parameter to the bindings to detect if a player released a key
	- added possibility to switch between team-synced and individual random shops
	- added some nice badges to the scoreboard

	- fixed TTT2 binding system
	- fixed Ammo pickup
	- fixed karma issue with detective
	- fixed DNA Scanner bug with the radar
	- fixed loading issue in the items module
	- fixed critical bug in the process of saving the items data
	- fixed the Sidekick color in corpses
	- fixed bug that detective were not able to transfer credits
	- fixed kill-list confirm role syncing bug
	- fixed crosshair reset bug
	- other small bugfixes

	- changed convar "ttt2_confirm_killlist" to default "1"
	- improved player-target add-on
	- improved the changelog (as you see :D)
	- reworked sql and created a sql library

	- reworked the slot system
	-> amount of carriable weapons are customizable
	-> weapons won't block slots anymore automatically
	-> slot positions are generated from weapon types
	]])

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

		local label = vgui.Create("DLabel", panel)
		label:SetText(change.text)
		label:SetTextColor(COLOR_BLACK)
		label:Dock(TOP)
		label:DockMargin(10, 10, 10, 10)
		label:SizeToContents()

		local leftBtn = sheet:AddSheet("Update " .. change.version, panel).Button

		local oldClick = leftBtn.DoClick
		leftBtn.DoClick = function(slf)
			if currentVersion == change.version then return end

			oldClick(slf)

			frame:SetTitle("TTT2 Update - " .. change.version)

			currentVersion = change.version
		end

		if change.version == currentVersion then
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
