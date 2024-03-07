--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_gameplay_sounds_title"
CLGAMEMODESUBMENU.icon = Material("vgui/ttt/vskin/helpscreen/sounds")

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_sounds_settings")

    form:MakeHelp({
        label = "help_enable_sound_interact",
    })

    local enbSoundInteract = form:MakeCheckBox({
        label = "label_enable_sound_interact",
        convar = "ttt2_enable_sound_interact",
    })

    form:MakeSlider({
        label = "label_level_sound_interact",
        convar = "ttt2_level_sound_interact",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundInteract,
    })

    form:MakeHelp({
        label = "help_enable_sound_buttons",
    })

    local enbSoundButtons = form:MakeCheckBox({
        label = "label_enable_sound_buttons",
        convar = "ttt2_enable_sound_buttons",
    })

    form:MakeSlider({
        label = "label_level_sound_buttons",
        convar = "ttt2_level_sound_buttons",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundButtons,
    })

    form:MakeHelp({
        label = "help_enable_sound_message",
    })

    local enbSoundMessage = form:MakeCheckBox({
        label = "label_enable_sound_message",
        convar = "ttt2_enable_sound_message",
    })

    form:MakeSlider({
        label = "label_level_sound_message",
        convar = "ttt2_level_sound_message",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundMessage,
    })
end
