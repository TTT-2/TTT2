--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_entspawn_title"

local updateButtons = {}
local updateCheckBoxes = {}
local updateHelpBox = nil

-- set up variable change callback
ttt2net.OnUpdate({"entspawnscript", "settings", "blacklisted"}, function(_, newval)
	local state = not tobool(newval)

	for i = 1, #updateCheckBoxes do
		local updateElem = updateCheckBoxes[i]

		if not IsValid(updateElem) then continue end

		updateElem:SetValue(state)
	end

	for i = 1, #updateButtons do
		local updateElem = updateButtons[i]

		if not IsValid(updateElem) then continue end

		updateElem:SetEnabled(state)
	end
end)

ttt2net.OnUpdate({"entspawnscript", "spawnamount", "weapon"}, function(_, newval)
	if not IsValid(updateHelpBox) then return end

	updateHelpBox:GetParams().weapon = newval
end)

ttt2net.OnUpdate({"entspawnscript", "spawnamount", "ammo"}, function(_, newval)
	if not IsValid(updateHelpBox) then return end

	updateHelpBox:GetParams().ammo = newval
end)

ttt2net.OnUpdate({"entspawnscript", "spawnamount", "player"}, function(_, newval)
	if not IsValid(updateHelpBox) then return end

	updateHelpBox:GetParams().player = newval
end)

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_entspawn_settings")

	form:MakeHelp({
		label = "help_spawn_editor_info"
	})

	form:MakeHelp({
		label = "help_spawn_editor_enable"
	})

	updateCheckBoxes[1] = form:MakeCheckBox({
		label = "label_dynamic_spawns_enable",
		initial = not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})),
		OnChange = function(_, value)
			entspawnscript.SetSetting("blacklisted", not value)
		end,
		default = true
	})

	form:MakeHelp({
		label = "help_spawn_editor_hint"
	})

	updateHelpBox = form:MakeHelp({
		label = "help_spawn_editor_spawn_amount",
		params = {
			weapon = ttt2net.Get({"entspawnscript", "spawnamount", "weapon"}) or 0,
			ammo = ttt2net.Get({"entspawnscript", "spawnamount", "ammo"}) or 0,
			player = ttt2net.Get({"entspawnscript", "spawnamount", "player"}) or 0
		}
	})

	-- REGISTER UNHIDE FUNCTION TO STOP SPAWN EDITOR
	HELPSCRN.menuFrame.OnShow = function(slf)
		if HELPSCRN:GetOpenMenu() ~= "administration_entspawn" then return end

		entspawnscript.StopEditing()
	end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	local buttonReset = vgui.Create("DButtonTTT2", parent)

	buttonReset:SetText("button_reset")
	buttonReset:SetSize(100, 45)
	buttonReset:SetPos(675, 20)
	buttonReset.DoClick = function()
		entspawnscript.OnLoaded(true)
	end

	local buttonToggle = vgui.Create("DButtonTTT2", parent)

	buttonToggle:SetText("button_start_entspawn_edit")
	buttonToggle:SetSize(180, 45)
	buttonToggle:SetPos(20, 20)
	buttonToggle.DoClick = function(slf)
		entspawnscript.StartEditing()

		HELPSCRN.menuFrame:HideFrame()
	end
	buttonToggle:SetEnabled(not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})))

	local buttonDelete = vgui.Create("DButtonTTT2", parent)

	buttonDelete:SetText("button_delete_all_spawns")
	buttonDelete:SetSize(195, 45)
	buttonDelete:SetPos(220, 20)
	buttonDelete.DoClick = function(slf)
		entspawnscript.DeleteAllSpawns()
	end
	buttonDelete:SetEnabled(not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})))

	updateButtons[1] = buttonToggle
	updateButtons[2] = buttonDelete
end

function CLGAMEMODESUBMENU:HasButtonPanel()
	return true
end
