--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 91
CLGAMEMODESUBMENU.title = "submenu_administration_voicechat_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_voicechat_general")

    form:MakeCheckBox({
        serverConvar = "sv_voiceenable",
        label = "label_voice_enable",
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_voicechat_battery")

    form2:MakeHelp({
        label = "help_voicechat_battery",
    })

    local enbBat = form2:MakeCheckBox({
        serverConvar = "ttt_voice_drain",
        label = "label_voice_drain",
    })

    form2:MakeSlider({
        serverConvar = "ttt_voice_drain_normal",
        label = "label_voice_drain_normal",
        min = 0,
        max = 1,
        decimal = 2,
        master = enbBat,
    })

    form2:MakeSlider({
        serverConvar = "ttt_voice_drain_admin",
        label = "label_voice_drain_admin",
        min = 0,
        max = 1,
        decimal = 2,
        master = enbBat,
    })

    form2:MakeSlider({
        serverConvar = "ttt_voice_drain_recharge",
        label = "label_voice_drain_recharge",
        min = 0,
        max = 1,
        decimal = 2,
        master = enbBat,
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_voicechat_locational")

    form3:MakeHelp({
        label = "help_locational_voice",
    })

    local enbLocVoice = form3:MakeCheckBox({
        serverConvar = "ttt_locational_voice",
        label = "label_locational_voice",
    })

    form3:MakeHelp({
        label = "help_locational_voice_prep",
        master = enbLocVoice,
    })

    form3:MakeCheckBox({
        serverConvar = "ttt_locational_voice_prep",
        label = "label_locational_voice_prep",
        master = enbLocVoice,
    })

    form3:MakeHelp({
        label = "help_locational_voice_range",
        master = enbLocVoice,
    })

    form3:MakeSlider({
        serverConvar = "ttt_locational_voice_range",
        label = "label_locational_voice_range",
        min = 0,
        max = 3000,
        decimal = 0,
        master = enbLocVoice,
    })

    form3:MakeCheckBox({
        serverConvar = "ttt_locational_voice_team",
        label = "label_locational_voice_team",
        master = enbLocVoice,
    })

    local form4 = vgui.CreateTTT2Form(parent, "header_textchat")

    form4:MakeCheckBox({
        serverConvar = "ttt_spectators_chat_globally",
        label = "label_spectator_chat",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_lastwords_chatprint",
        label = "label_lastwords_chatprint",
    })
end
