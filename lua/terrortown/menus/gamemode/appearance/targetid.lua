--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_appearance_targetid_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_targetid")

    form:MakeHelp({
        label = "help_targetid_info",
    })

    form:MakeCheckBox({
        label = "label_minimal_targetid",
        convar = "ttt_minimal_targetid",
    })
end
