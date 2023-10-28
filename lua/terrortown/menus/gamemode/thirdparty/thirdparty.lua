--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_thirdparty_general_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_thirdparty_general")

	form:MakeHelp({
		label = "help_thirdparty_enable_workshop"
	})
	form:MakeCheckBox({
		serverConvar = "ttt2_thirdparty_enable_workshop",
		label = "label_thirdparty_enable_workshop"
	})
end
