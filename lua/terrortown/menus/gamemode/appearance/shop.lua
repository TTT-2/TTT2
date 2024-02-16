--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_appearance_shop_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_shop_settings")

    form:MakeHelp({
        label = "help_shop_key_desc",
    })

    form:MakeCheckBox({
        label = "label_shop_always_show",
        convar = "ttt_bem_always_show_shop",
    })

    if GetConVar("ttt_bem_allow_change"):GetBool() then
        local form2 = vgui.CreateTTT2Form(parent, "header_shop_layout")

        form2:MakeSlider({
            label = "label_shop_num_col",
            convar = "ttt_bem_cols",
            min = 1,
            max = 20,
            decimal = 0,
        })

        form2:MakeSlider({
            label = "label_shop_num_row",
            convar = "ttt_bem_rows",
            min = 1,
            max = 20,
            decimal = 0,
        })

        form2:MakeSlider({
            label = "label_shop_item_size",
            convar = "ttt_bem_size",
            min = 32,
            max = 128,
            decimal = 0,
        })
    end

    local form3 = vgui.CreateTTT2Form(parent, "header_shop_marker")

    form3:MakeCheckBox({
        label = "label_shop_show_slot",
        convar = "ttt_bem_marker_slot",
    })

    form3:MakeCheckBox({
        label = "label_shop_show_custom",
        convar = "ttt_bem_marker_custom",
    })

    form3:MakeCheckBox({
        label = "label_shop_show_fav",
        convar = "ttt_bem_marker_fav",
    })
end
