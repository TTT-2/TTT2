--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_entspawn_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_entspawn_settings")

end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	local buttonReset = vgui.Create("DButtonTTT2", parent)

	buttonReset:SetText("button_reset")
	buttonReset:SetSize(100, 45)
	buttonReset:SetPos(675, 20)
	buttonReset.DoClick = function()
		entspawnscript.Init(true)
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
end

function CLGAMEMODESUBMENU:HasButtonPanel()
	return true
end
