--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 93
CLGAMEMODESUBMENU.title = "submenu_appearance_performance_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_performance_settings")

    form:MakeCheckBox({
        label = "label_performance_halo_enable",
        convar = "ttt_entity_draw_halo",
    })

    form:MakeCheckBox({
        label = "label_performance_spec_outline_enable",
        convar = "ttt2_enable_spectatorsoutline",
    })

    form:MakeCheckBox({
        label = "label_performance_ohicon_enable",
        convar = "ttt2_enable_overheadicons",
    })
end
