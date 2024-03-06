--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_gameplay_voiceandvolume_title"
CLGAMEMODESUBMENU.icon = Material("vgui/ttt/vskin/helpscreen/voiceandvolume")

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_soundeffect_settings")

    form:MakeCheckBox({
        label = "label_inferface_scues_enable",
        convar = "ttt_cl_soundcues",
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_voiceandvolume_settings")

    form2:MakeCheckBox({
        label = "label_gameplay_mute",
        convar = "ttt_mute_team_check",
    })

    form2:MakeComboBox({
        label = "label_voice_scaling",
        convar = "ttt2_voice_scaling",
        choices = VOICE.GetScalingFunctions(),
        OnChange = function()
            for _, ply in ipairs(player.GetAll()) do
                VOICE.UpdatePlayerVoiceVolume(ply)
            end
        end,
    })

    local enbSpecDuck = form2:MakeCheckBox({
        label = "label_voice_duck_spectator",
        convar = "ttt2_voice_duck_spectator",
    })

    form2:MakeSlider({
        label = "label_voice_duck_spectator_amount",
        convar = "ttt2_voice_duck_spectator_amount",
        min = 0,
        max = 1,
        decimal = 2,
        master = enbSpecDuck,
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_sounds_settings")

    form3:MakeHelp({
        label = "help_enable_sound_interact",
    })

    local enbSoundInteract = form3:MakeCheckBox({
        label = "label_enable_sound_interact",
        convar = "ttt2_enable_sound_interact",
    })

    form3:MakeSlider({
        label = "label_level_sound_interact",
        convar = "ttt2_level_sound_interact",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundInteract,
    })

    form3:MakeHelp({
        label = "help_enable_sound_buttons",
    })

    local enbSoundButtons = form3:MakeCheckBox({
        label = "label_enable_sound_buttons",
        convar = "ttt2_enable_sound_buttons",
    })

    form3:MakeSlider({
        label = "label_level_sound_buttons",
        convar = "ttt2_level_sound_buttons",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundButtons,
    })

    form3:MakeHelp({
        label = "help_enable_sound_message",
    })

    local enbSoundMessage = form3:MakeCheckBox({
        label = "label_enable_sound_message",
        convar = "ttt2_enable_sound_message",
    })

    form3:MakeSlider({
        label = "label_level_sound_message",
        convar = "ttt2_level_sound_message",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbSoundMessage,
    })
end
