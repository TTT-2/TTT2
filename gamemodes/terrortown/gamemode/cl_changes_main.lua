local changesVersion = CreateClientConVar("changes_version", "v0.0.0.0")

local changesPanel
local changes

local function AddChange(version, text)
	changes = changes or {}

	table.insert(changes, 1, {version = version, text = text})
end

function CreateChanges()
	if changes then return end

	changes = {}

	AddChange("0.3.5.6b", [[
	- many fixes
	- enabled picking up grenades in prep time
	- end scoreboard fix
	- disabled useless prints that have spammed the console
	]])

	AddChange("0.3.5.7b", [[
	- code optimization
	- removed PLAYER:UpdateRole() function and hook "TTT2RoleTypeSet"
	- fixed loadout and model issue on changing the role
	- added different CVars
	- bugfixes
	]])

	AddChange("0.3.5.8b", [[
	- added different ConVars
	- bugfixes
	- selection system update
	- added possibility to force a role in the next roleselection
	]])

	AddChange("0.3.6b", [[
	- karma system improvement
	- new networking system
	- added credits
	- added changes window
	- added detection for registered incompatible add-ons
	- added autoslay support
	- huge amount of bugfixes
	- added gs_crazyphysics detector
	- added RoleVote support
	- added new multilayed icons (+ multilayer system)
	]])

	AddChange("0.3.7b", [[
	- fixed TTT spec label issue
	- removed Player:SetSubRole() and Player:SetBaseRole()
	- added hook TTT2ToggleRole
	- renamed hook "TTT_UseCustomPlayerModels" into "TTTUseCustomPlayerModels"
	- added GetActiveRoles()
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
	- agreed to all these nice unaccepted PullRequest for TTT on GitHub:
		- Custom Crosshairs [F1 -> Settings]: 'https://github.com/Facepunch/garrysmod/pull/1376/' by nubpro
		- Performance improvements with the help of 'https://github.com/Facepunch/garrysmod/pull/1287' by markusmarkusz and Alf21
	]])
end

function ShowChanges()
	if IsValid(changesPanel) then
		changesPanel:Remove()

		return
	end

	CreateChanges()

	local w = 630

	local frame = vgui.Create("DFrame")
	frame:SetSize(w, ScrH() - 50)
	frame:Center()
	frame:SetTitle("TTT2 Changes")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetMouseInputEnabled(true)
	frame:SetDeleteOnClose(true)

	local ttt2_changes = vgui.Create("DPanelList", frame)
	ttt2_changes:Dock(FILL)
	ttt2_changes:SetPadding(10)
	ttt2_changes:SetSpacing(10)

	for _, change in ipairs(changes) do
		local chng = vgui.Create("DForm")
		chng:SetSpacing(10)
		chng:SetName("Update " .. change.version)
		chng:SetWide(ttt2_changes:GetWide() - 30)

		ttt2_changes:AddItem(chng)

		chng:Help(change.text)

		chng:SizeToContents()
	end

	ttt2_changes:EnableVerticalScrollbar()

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
