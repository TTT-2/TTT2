--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_gameplay_voiceandvolume_title"
CLGAMEMODESUBMENU.icon = Material("vgui/ttt/vskin/helpscreen/voiceandvolume")

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_voiceandvolume_settings")

    form:MakeHelp({
        label = "help_voice_activation",
    })

    form:MakeComboBox({
        label = "label_voice_activation",
        convar = "ttt2_voice_activation",
        choices = util.ComboBoxChoicesFromKeys(
            VOICE.ActivationModes,
            "label_voice_activation_mode_",
            VOICE.cv.activation_mode:GetString()
        ),
        OnChange = VOICE.ActivationModeFunc("OnJoin"),
    })

    form:MakeCheckBox({
        label = "label_gameplay_mute",
        convar = "ttt_mute_team_check",
    })

    form:MakeComboBox({
        label = "label_voice_scaling",
        convar = "ttt2_voice_scaling",
        choices = util.ComboBoxChoicesFromKeys(
            VOICE.ScalingFunctions,
            "label_voice_scaling_mode_",
            VOICE.cv.scaling_mode:GetString()
        ),
        OnChange = function()
            local plys = player.GetAll()

            for i = 1, #plys do
                VOICE.UpdatePlayerVoiceVolume(plys[i])
            end
        end,
    })

    form:MakeHelp({
        label = "help_voice_duck_spectator",
    })

    local enbSpecDuck = form:MakeCheckBox({
        label = "label_voice_duck_spectator",
        convar = "ttt2_voice_duck_spectator",
    })

    form:MakeSlider({
        label = "label_voice_duck_spectator_amount",
        convar = "ttt2_voice_duck_spectator_amount",
        min = 0,
        max = 1,
        decimal = 2,
        master = enbSpecDuck,
    })
end
