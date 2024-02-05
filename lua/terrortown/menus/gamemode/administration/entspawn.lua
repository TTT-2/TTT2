--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 95
CLGAMEMODESUBMENU.title = "submenu_administration_entspawn_title"

local updateButtons = {}
local updateCheckBoxes = {}
local updateHelpBox = nil

local function UpdateButtons(state)
    for i = 1, #updateButtons do
        local updateElem = updateButtons[i]

        if not IsValid(updateElem) then
            continue
        end

        updateElem:SetEnabled(state)
    end
end

local function UpdateCheckBoxes(state)
    for i = 1, #updateCheckBoxes do
        local updateElem = updateCheckBoxes[i]

        if not IsValid(updateElem) then
            continue
        end

        updateElem:SetValue(state)
    end
end

-- set up variable change callback
ttt2net.OnUpdate({ "entspawnscript", "settings", "blacklisted" }, function(_, newval)
    local state = not tobool(newval)

    UpdateButtons(state)
    UpdateCheckBoxes(state)
end)

ttt2net.OnUpdate({ "entspawnscript", "spawnamount" }, function(_, newval, reversePath)
    local paramType = reversePath[1]

    if not IsValid(updateHelpBox) or not paramType then
        return
    end

    updateHelpBox:GetTextParams()[paramType] = newval
end)

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_entspawn_settings")

    form:MakeHelp({
        label = "help_spawn_editor_info",
    })

    -- store the reference to the checkbox in a variable
    -- because the other settings are enabled based on
    -- the state of this checkbox
    local dynSpawnEnable = form:MakeCheckBox({
        label = "label_dynamic_spawns_global_enable",
        serverConvar = "ttt_use_weapon_spawn_scripts",
        OnChange = function(_, value)
            -- make sure that both the checkbox value and the map setting value are considered
            UpdateButtons(
                tobool(value)
                    and not tobool(ttt2net.Get({ "entspawnscript", "settings", "blacklisted" }))
            )
        end,
    })

    form:MakeHelp({
        label = "help_spawn_editor_enable",
        master = dynSpawnEnable,
    })

    updateCheckBoxes[1] = form:MakeCheckBox({
        label = "label_dynamic_spawns_enable",
        initial = not tobool(ttt2net.Get({ "entspawnscript", "settings", "blacklisted" })),
        OnChange = function(_, value)
            entspawnscript.SetSetting("blacklisted", not value)
        end,
        default = true,
        master = dynSpawnEnable,
    })

    form:MakeHelp({
        label = "help_spawn_editor_hint",
        master = dynSpawnEnable,
    })

    updateHelpBox = form:MakeHelp({
        label = "help_spawn_editor_spawn_amount",
        params = {
            weapon = ttt2net.Get({ "entspawnscript", "spawnamount", "weapon" }) or 0,
            ammo = ttt2net.Get({ "entspawnscript", "spawnamount", "ammo" }) or 0,
            player = ttt2net.Get({ "entspawnscript", "spawnamount", "player" }) or 0,
            weaponrandom = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponrandom" }) or 0,
            weaponmelee = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponmelee" }) or 0,
            weaponnade = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponnade" }) or 0,
            weaponshotgun = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponshotgun" }) or 0,
            weaponheavy = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponheavy" }) or 0,
            weaponsniper = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponsniper" }) or 0,
            weaponpistol = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponpistol" }) or 0,
            weaponspecial = ttt2net.Get({ "entspawnscript", "spawnamount", "weaponspecial" }) or 0,
            ammorandom = ttt2net.Get({ "entspawnscript", "spawnamount", "ammorandom" }) or 0,
            ammodeagle = ttt2net.Get({ "entspawnscript", "spawnamount", "ammodeagle" }) or 0,
            ammopistol = ttt2net.Get({ "entspawnscript", "spawnamount", "ammopistol" }) or 0,
            ammomac10 = ttt2net.Get({ "entspawnscript", "spawnamount", "ammomac10" }) or 0,
            ammorifle = ttt2net.Get({ "entspawnscript", "spawnamount", "ammorifle" }) or 0,
            ammoshotgun = ttt2net.Get({ "entspawnscript", "spawnamount", "ammoshotgun" }) or 0,
            playerrandom = ttt2net.Get({ "entspawnscript", "spawnamount", "playerrandom" }) or 0,
        },
        master = dynSpawnEnable,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_entspawn_plyspawn")

    form2:MakeHelp({
        label = "help_spawn_waves",
    })

    form2:MakeSlider({
        serverConvar = "ttt_spawn_wave_interval",
        label = "label_spawn_wave_interval",
        min = 0,
        max = 30,
        decimal = 0,
    })

    -- REGISTER UNHIDE FUNCTION TO STOP SPAWN EDITOR
    HELPSCRN.menuFrame.OnShow = function(slf)
        if HELPSCRN:GetOpenMenu() ~= "administration_entspawn" then
            return
        end

        entspawnscript.StopEditing()
    end
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
    local buttonReset = vgui.Create("DButtonTTT2", parent)

    buttonReset:SetText("button_reset")
    buttonReset:SetSize(100, 45)
    buttonReset:SetPos(20, 20)
    buttonReset.DoClick = function()
        entspawnscript.ResetMapToDefault()

        cvars.ChangeServerConVar("ttt_use_weapon_spawn_scripts", "1")
    end

    local buttonDelete = vgui.Create("DButtonTTT2", parent)

    buttonDelete:SetText("button_delete_all_spawns")
    buttonDelete:SetSize(195, 45)
    buttonDelete:SetPos(parent:GetWide() - (195 + 20 + 180 + 20), 20)
    buttonDelete.DoClick = function(slf)
        entspawnscript.DeleteAllSpawns()
    end

    local buttonToggle = vgui.Create("DButtonTTT2", parent)

    buttonToggle:SetText("button_start_entspawn_edit")
    buttonToggle:SetSize(180, 45)

    buttonToggle:SetPos(parent:GetWide() - (180 + 20), 20)
    buttonToggle.DoClick = function(slf)
        entspawnscript.StartEditing()

        HELPSCRN.menuFrame:HideFrame()
    end

    updateButtons[1] = buttonToggle
    updateButtons[2] = buttonDelete

    -- set initial value for buttons dependant on convar request
    cvars.ServerConVarGetValue("ttt_use_weapon_spawn_scripts", function(wasSuccess, value)
        if not wasSuccess or not value then
            return
        end

        local state = tobool(value)
            and not tobool(ttt2net.Get({ "entspawnscript", "settings", "blacklisted" }))

        UpdateButtons(state)
    end)
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end
