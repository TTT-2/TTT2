--- @ignore

local hudSwicherSettings = {
    ["color"] = function(parent, currentHUD, key, data)
        parent:MakeColorMixer({
            label = data.desc or key,
            initial = currentHUD[key],
            showAlphaBar = true,
            showPalette = true,
            OnChange = function(_, color)
                currentHUD[key] = color

                if isfunction(data.OnChange) then
                    data.OnChange(currentHUD, color)
                end
            end,
        })
    end,

    ["number"] = function(parent, currentHUD, key, data)
        parent:MakeSlider({
            label = data.desc or key,
            min = data.min or 0.1,
            max = data.max or 4,
            decimal = data.decimal or 1,
            initial = math.Round(currentHUD[key] or 1, 1),
            default = data.default,
            OnChange = function(_, value)
                value = math.Round(value, 1)
                currentHUD[key] = value

                if isfunction(data.OnChange) then
                    data.OnChange(currentHUD, value)
                end
            end,
        })
    end,

    ["bool"] = function(parent, currentHUD, key, data)
        parent:MakeCheckBox({
            label = data.desc or key,
            initial = currentHUD[key] == nil and true or currentHUD[key],
            default = data.default,
            OnChange = function(_, value)
                value = value or false
                currentHUD[key] = value

                if isfunction(data.OnChange) then
                    data.OnChange(currentHUD, value)
                end
            end,
        })
    end,
}

local function PopulateHUDSwitcherPanelSettings(parent, currentHUD)
    parent:Clear()

    parent:MakeHelp({
        label = "help_hud_special_settings",
    })

    for key, data in pairs(currentHUD:GetSavingKeys() or {}) do
        hudSwicherSettings[data.typ](parent, currentHUD, key, data)
    end
end

local function PopulateHUDSwitcherPanelSettingsElements(parent, currentHUD)
    parent:Clear()

    parent:MakeHelp({
        label = "help_hud_elements_special_settings",
    })

    local hudElements = huds.GetStored(HUDManager.GetHUD()):GetElements()
    for i = 1, #hudElements do
        local elemName = hudElements[i]

        local el = hudelements.GetStored(elemName)
        if not el then
            continue
        end

        for key, data in pairs(el:GetSavingKeys() or {}) do
            if not hudSwicherSettings[data.typ] then
                continue
            end
            hudSwicherSettings[data.typ](parent, el, key, data)
        end
    end
end

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_appearance_hudswitcher_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_hud_select")

    local currentHUDName = HUDManager.GetHUD()
    local currentHUD = huds.GetStored(currentHUDName)
    local hudList = huds.GetList()
    local restrictedHUDs = ttt2net.GetGlobal({ "hud_manager", "restrictedHUDs" })
    local forcedHUD = ttt2net.GetGlobal({ "hud_manager", "forcedHUD" })
    local validHUDs = {}

    if not currentHUD.GetSavingKeys then
        form:MakeHelp({
            label = "help_hud_game_reload",
        })

        return
    end

    if forcedHUD then
        validHUDs[1] = forcedHUD
    else
        for i = 1, #hudList do
            local hud = hudList[i]

            -- do not add HUD to the selection list if restricted
            if table.HasValue(restrictedHUDs, hud.id) then
                continue
            end

            validHUDs[#validHUDs + 1] = hud.id
        end
    end

    form:MakeComboBox({
        label = "label_hud_select",
        choices = validHUDs,
        selectName = currentHUDName,
        OnChange = function(value)
            HUDManager.SetHUD(value)
        end,
        default = ttt2net.GetGlobal({ "hud_manager", "defaultHUD" }),
    })

    PopulateHUDSwitcherPanelSettings(
        vgui.CreateTTT2Form(parent, "header_hud_customize"),
        currentHUD
    )
    PopulateHUDSwitcherPanelSettingsElements(
        vgui.CreateTTT2Form(parent, "header_hud_elements_customize"),
        currentHUD
    )

    -- REGISTER UNHIDE FUNCTION TO STOP HUD EDITOR
    HELPSCRN.menuFrame.OnShow = function(slf)
        if HELPSCRN:GetOpenMenu() ~= "appearance_hudswitcher" then
            return
        end

        HUDEditor.StopEditHUD()
    end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
    local currentHUDName = HUDManager.GetHUD()
    local currentHUD = huds.GetStored(currentHUDName)

    local buttonReset = vgui.Create("DButtonTTT2", parent)

    buttonReset:SetText("button_reset")
    buttonReset:SetSize(100, 45)
    buttonReset:SetPos(20, 20)
    buttonReset.DoClick = function(btn)
        if not currentHUD then
            return
        end

        currentHUD:Reset()
        currentHUD:SaveData()
    end
    buttonReset:SetEnabled(not currentHUD.disableHUDEditor)

    local buttonEditor = vgui.Create("DButtonTTT2", parent)

    buttonEditor:SetText("button_hud_editor")
    buttonEditor:SetSize(175, 45)
    buttonEditor:SetPos(parent:GetWide() - 195, 20)
    buttonEditor.DoClick = function(btn)
        if not currentHUDName then
            return
        end

        HUDEditor.EditHUD()

        HELPSCRN.menuFrame:HideFrame()
    end
    buttonEditor:SetEnabled(not currentHUD.disableHUDEditor)
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end

hook.Add("TTT2HUDUpdated", "UpdateHUDSwitcherData", function()
    if HELPSCRN:GetOpenMenu() ~= "appearance_hudswitcher" then
        return
    end

    -- rebuild the content area so that data is refreshed
    -- based on the newly selected HUD
    vguihandler.Rebuild()
end)
