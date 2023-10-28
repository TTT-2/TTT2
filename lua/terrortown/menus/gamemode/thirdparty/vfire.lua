--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_thirdparty_vfire_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form2 = vgui.CreateTTT2Form(parent, "header_thirdparty_vfire")
	form2:MakeHelp({
		label = "help_thirdparty_vfire"
	})
end


