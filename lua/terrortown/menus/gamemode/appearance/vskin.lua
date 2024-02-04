--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_appearance_vskin_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_vskin_select")

    form:MakeHelp({
        label = "help_vskin_info",
    })

    form:MakeComboBox({
        label = "label_vskin_select",
        choices = vskin.GetVSkinList(),
        selectName = vskin.GetVSkinName(),
        OnChange = function(value)
            vskin.SelectVSkin(value)
        end,
        default = vskin.GetDefaultVSkinName(),
    })

    form:MakeCheckBox({
        label = "label_blur_enable",
        initial = vskin.ShouldBlurBackground(),
        OnChange = function(_, value)
            vskin.SetBlurBackground(value)
        end,
        default = true,
    })

    form:MakeCheckBox({
        label = "label_color_enable",
        initial = vskin.ShouldColorBackground(),
        OnChange = function(_, value)
            vskin.SetColorBackground(value)
        end,
        default = true,
    })
end
