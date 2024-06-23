--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 94
CLGAMEMODESUBMENU.title = "submenu_administration_playermodels_title"

local boxCache = {}

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_playermodels_general")

    form:MakeHelp({
        label = "help_enforce_playermodel",
    })

    form:MakeCheckBox({
        label = "label_enforce_playermodel",
        serverConvar = "ttt_enforce_playermodel",
    })

    form:MakeHelp({
        label = "help_prefer_map_models",
    })

    form:MakeCheckBox({
        label = "label_prefer_map_models",
        serverConvar = "ttt2_prefer_map_models",
    })

    form:MakeHelp({
        label = "help_use_custom_models",
    })

    local customModelsEnb = form:MakeCheckBox({
        label = "label_use_custom_models",
        serverConvar = "ttt2_use_custom_models",
    })

    form:MakeCheckBox({
        label = "label_select_model_per_round",
        serverConvar = "ttt2_select_model_per_round",
        master = customModelsEnb,
    })

    form:MakeCheckBox({
        label = "label_select_unique_model_per_round",
        serverConvar = "ttt2_select_unique_model_per_player",
        master = customModelsEnb,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_playermodels_selection")

    form2:MakeHelp({
        label = "help_models_select",
    })

    local base = form2:MakeIconLayout()
    for name, model in SortedPairs(player_manager.AllValidModels()) do
        boxCache[name] = form2:MakeImageCheckBox({
            label = name,
            model = model,
            headbox = playermodels.HasHeadHitBox(name) or false,
            OnModelSelected = function(_, state)
                playermodels.UpdateModel(name, playermodels.state.selected, state)
            end,
            OnModelHattable = function(_, state)
                playermodels.UpdateModel(name, playermodels.state.hattable, state)
            end,
        }, base)

        playermodels.IsSelectedModel(name, function(value)
            if not boxCache[name] then
                return
            end

            boxCache[name]:SetModelSelected(value, false)
        end)

        playermodels.IsHattableModel(name, function(value)
            if not boxCache[name] then
                return
            end

            boxCache[name]:SetModelHattable(value, false)
        end)

        playermodels.RemoveChangeCallback(
            name,
            playermodels.state.selected,
            "TTT2F1MenuPlayermodels"
        )

        playermodels.AddChangeCallback(name, playermodels.state.selected, function(value)
            local box = boxCache[name]

            if not IsValid(box) then
                playermodels.RemoveChangeCallback(
                    name,
                    playermodels.state.selected,
                    "TTT2F1MenuPlayermodels"
                )

                return
            end

            box:SetModelSelected(value, false)
        end, "TTT2F1MenuPlayermodels")

        playermodels.RemoveChangeCallback(
            name,
            playermodels.state.hattable,
            "TTT2F1MenuPlayermodels"
        )

        playermodels.AddChangeCallback(name, playermodels.state.hattable, function(value)
            local box = boxCache[name]

            if not IsValid(box) then
                playermodels.RemoveChangeCallback(
                    name,
                    playermodels.state.hattable,
                    "TTT2F1MenuPlayermodels"
                )

                return
            end

            box:SetModelHattable(value, false)
        end, "TTT2F1MenuPlayermodels")
    end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
    local buttonReset = vgui.Create("DButtonTTT2", parent)

    buttonReset:SetText("button_reset_models")
    buttonReset:SetSize(225, 45)
    buttonReset:SetPos(20, 20)
    buttonReset.DoClick = function()
        playermodels.Reset()
    end
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end
