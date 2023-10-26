--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 91
CLGAMEMODESUBMENU.title = "submenu_appearance_miscellaneous_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_miscellaneous_settings")

    form:MakeCheckBox({
		label = "label_hud_pulsate_health_enable",
		convar = "ttt2_hud_pulsate_health"
	})

end
