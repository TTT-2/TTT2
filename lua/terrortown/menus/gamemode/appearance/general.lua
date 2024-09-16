--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_appearance_general_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_global_color")

    form:MakeHelp({
        label = "help_color_desc",
    })

    -- store the reference to the checkbox in a variable
    -- because the other settings are enabled based on
    -- the state of this checkbox
    local enbColor = form:MakeCheckBox({
        label = "label_global_color_enable",
        initial = appearance.ShouldUseGlobalFocusColor(),
        OnChange = function(_, value)
            appearance.SetUseGlobalFocusColor(value)
        end,
        default = false,
    })

    form:MakeColorMixer({
        label = "label_global_color",
        initial = appearance.GetFocusColor(),
        OnChange = function(_, color)
            appearance.SetFocusColor(color)
        end,
        master = enbColor,
    })

    form:MakeHelp({
        label = "help_scale_factor",
    })

    form:MakeSlider({
        label = "label_global_scale_factor",
        min = 0.1,
        max = 3,
        decimal = 1,
        initial = appearance.GetGlobalScale(),
        OnChange = function(_, value)
            appearance.SetGlobalScale(value)
        end,
        default = appearance.GetDefaultGlobalScale(),
    })

    if GetConVar("ttt2_enable_loadingscreen_server"):GetBool() then
        local form2 = vgui.CreateTTT2Form(parent, "header_loadingscreen")

        form2:MakeHelp({
            label = "help_enable_loadingscreen",
        })

        local enbLoadingscreen = form2:MakeCheckBox({
            label = "label_enable_loadingscreen",
            convar = "ttt2_enable_loadingscreen",
        })

        form2:MakeCheckBox({
            label = "label_enable_loadingscreen_tips",
            convar = "ttt_tips_enable",
            master = enbLoadingscreen,
        })
    end
end
