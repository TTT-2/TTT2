--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_commands_commands_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local plys = player.GetAll()
    local roles = roles.GetSortedRoles()
    local plyChoices = {}
    local roleChoices = {}

    for i = 1, #plys do
        local ply = plys[i]

        plyChoices[i] = {
            title = ply:Nick(),
            value = ply,
        }
    end

    for i = 1, #roles do
        local role = roles[i]

        roleChoices[i] = {
            title = role.name,
            value = role.index,
        }
    end

    -- RESTART ROUND --

    local form = vgui.CreateTTT2Form(parent, "header_commands_round_restart")

    form:MakeHelp({
        label = "help_round_restart_reset",
    })

    form:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_round_restart",
        OnClick = function(slf)
            admin.RoundRestart()
        end,
    })

    form:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_level_reset",
        OnClick = function(slf)
            admin.LevelReset()
        end,
    })

    -- SLAY PLAYER --

    local form2 = vgui.CreateTTT2Form(parent, "header_commands_player_slay")

    local playerSlay = form2:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    form2:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_slay",
        OnClick = function(slf)
            local ply, _ = playerSlay:GetSelected()

            admin.PlayerSlay(ply)
        end,
        master = playerSlay,
    })

    -- TELEPORT PLAYER --

    local form3 = vgui.CreateTTT2Form(parent, "header_commands_player_teleport")

    local playerTeleport = form3:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    form3:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_teleport",
        OnClick = function(slf)
            local ply, _ = playerTeleport:GetSelected()

            admin.PlayerTeleport(ply, LocalPlayer():GetEyeTrace().HitPos)
        end,
        master = playerTeleport,
    })

    -- RESPAWN PLAYER --

    local form4 = vgui.CreateTTT2Form(parent, "header_commands_player_respawn")

    local playerRespawn = form4:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    form4:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_respawn",
        OnClick = function(slf)
            local ply, _ = playerRespawn:GetSelected()

            admin.PlayerRespawn(ply, LocalPlayer():GetEyeTrace().HitPos)
        end,
        master = playerRespawn,
    })

    -- ADD CREDITS --

    local form5 = vgui.CreateTTT2Form(parent, "header_commands_player_add_credits")

    local playerCredits = form5:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    local amountCredits = form5:MakeSlider({
        label = "label_slider_add_credits",
        min = 0,
        max = 25,
        decimal = 0,
        initial = 2,
        master = playerCredits,
    })

    form5:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_add_credits",
        OnClick = function(slf)
            local ply, _ = playerCredits:GetSelected()

            admin.PlayerAddCredits(ply, amountCredits:GetValue())
        end,
        master = playerCredits,
    })

    -- SET HEALTH --

    local form6 = vgui.CreateTTT2Form(parent, "header_commands_player_set_health")

    local playerHealth = form6:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    local amountHealth = form6:MakeSlider({
        label = "label_slider_set_health",
        min = 0,
        max = 200,
        decimal = 0,
        initial = 100,
        master = playerHealth,
    })

    form6:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_set_health",
        OnClick = function(slf)
            local ply, _ = playerHealth:GetSelected()

            admin.PlayerSetHealth(ply, amountHealth:GetValue())
        end,
        master = playerHealth,
    })

    -- SET ARMOR --

    local form7 = vgui.CreateTTT2Form(parent, "header_commands_player_set_armor")

    local playerArmor = form7:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    local amountArmor = form7:MakeSlider({
        label = "label_slider_set_armor",
        min = 0,
        max = 100,
        decimal = 0,
        initial = 30,
        master = playerArmor,
    })

    form7:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_set_armor",
        OnClick = function(slf)
            local ply, _ = playerArmor:GetSelected()

            admin.PlayerSetArmor(ply, amountArmor:GetValue())
        end,
        master = playerArmor,
    })

    -- FORCE PLAYER ROLE --

    local form8 = vgui.CreateTTT2Form(parent, "header_commands_player_force_role")

    local playerList = form8:MakeComboBox({
        label = "label_player_select",
        choices = plyChoices,
    })

    local playerRole = form8:MakeComboBox({
        label = "label_player_role",
        choices = roleChoices,
        master = playerList,
    })

    form8:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_button_player_force_role",
        OnClick = function(slf)
            local ply, _ = playerList:GetSelected()

            admin.PlayerForceRole(ply, playerRole:GetSelected())
        end,
        master = playerRole,
    })
end
