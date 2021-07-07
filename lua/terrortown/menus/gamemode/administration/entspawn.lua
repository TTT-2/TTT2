--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_entspawn_title"

local updateButtons = {}
local updateCheckBoxes = {}

-- set up variable change callback
ttt2net.OnUpdate({"entspawnscript", "settings", "blacklisted"}, function(_, newval)
	local state = not tobool(newval)

	for i = 1, #updateCheckBoxes do
		updateCheckBoxes[i]:SetValue(state)
	end

	for i = 1, #updateButtons do
		updateButtons[i]:SetEnabled(state)
	end
end)

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_entspawn_settings")

	form:MakeHelp({
		label = "help_spawn_editor_info"
	})

	form:MakeHelp({
		label = "help_spawn_editor_enable"
	})

	local enableDynSpawns = form:MakeCheckBox({
		label = "label_dynamic_spawns_enable",
		initial = not tobool(ttt2net.Get({"entspawnscript", "settings", "blacklisted"})),
		OnChange = function(_, value)
			entspawnscript.SetSetting("blacklisted", not value)
		end,
		default = true
	})

	updateCheckBoxes[1] = enableDynSpawns
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

	buttonToggle:SetText(entspawnscript.IsEditing(LocalPlayer()) and "button_stop_entspawn_edit" or "button_start_entspawn_edit")
	buttonToggle:SetSize(180, 45)
	buttonToggle:SetPos(20, 20)
	buttonToggle.DoClick = function(slf)
		if slf:GetText() == "button_start_entspawn_edit" then
			slf:SetText("button_stop_entspawn_edit")

			entspawnscript.StartEditing()

			HELPSCRN.menuFrame:HideFrame()
		else
			slf:SetText("button_start_entspawn_edit")

			entspawnscript.StopEditing()
		end
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
