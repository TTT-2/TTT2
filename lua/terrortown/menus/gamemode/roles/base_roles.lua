--- @ignore

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""
CLGAMEMODESUBMENU.searchable = true

local function PopulateInfo(parent, roleData)
    if roleData.builtin then
        parent:MakeHelp({
            label = "help_roles_builtin",
        })
    end

    parent:MakeHelp({
        label = "help_roles_default_team",
        params = roleData.defaultTeam,
    })

    parent:MakeHelp({
        label = roleData.notSelectable and "help_roles_unselectable" or "help_roles_selectable",
    })

    parent:MakeHelp({
        label = "ttt2_desc_" .. roleData.name,
    })
end

local function PopulateSelection(parent, roleData)
    if roleData.index == ROLE_INNOCENT or roleData.index == ROLE_TRAITOR then
        parent:MakeHelp({
            label = "help_roles_selection_short",
        })
    else
        parent:MakeHelp({
            label = "help_roles_selection",
        })
    end

    if roleData.index == ROLE_INNOCENT then
        parent:MakeSlider({
            serverConvar = "ttt_min_inno_pct",
            label = "label_roles_min_inno_pct",
            min = 0,
            max = 1,
            decimal = 2,
        })

        return
    end

    local masterEnb

    if roleData.index ~= ROLE_TRAITOR then
        masterEnb = parent:MakeCheckBox({
            serverConvar = "ttt_" .. roleData.name .. "_enabled",
            label = "label_roles_enabled",
        })
    end

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.name .. "_pct",
        label = "label_roles_pct",
        min = 0,
        max = 1,
        decimal = 2,
        master = masterEnb,
    })

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.name .. "_max",
        label = "label_roles_max",
        min = 0,
        max = 64,
        decimal = 0,
        master = masterEnb,
    })

    if roleData.index == ROLE_TRAITOR then
        return
    end

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.name .. "_random",
        label = "label_roles_random",
        min = 0,
        max = 100,
        decimal = 0,
        master = masterEnb,
    })

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.name .. "_min_players",
        label = "label_roles_min_players",
        min = 0,
        max = 64,
        decimal = 0,
        master = masterEnb,
    })

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.name .. "_karma_min",
        label = "label_roles_min_karma",
        min = 0,
        max = 1000,
        decimal = 0,
        master = masterEnb,
    })
end

local function PopulateMagnetoStick(parent, roleData)
    parent:MakeCheckBox({
        serverConvar = "ttt2_ragdoll_pinning_" .. roleData.name,
        label = "label_roles_ragdoll_pinning",
    })
end

local function PopulateTButtons(parent, roleData)
    parent:MakeCheckBox({
        serverConvar = "ttt_" .. roleData.name .. "_traitor_button",
        label = "label_roles_tbutton",
    })
end

local function PopulateCredits(parent, roleData)
    parent:MakeHelp({
        label = "help_roles_credits",
    })

    parent:MakeSlider({
        serverConvar = "ttt_" .. roleData.abbr .. "_credits_starting",
        label = "label_roles_credits_starting",
        min = 0,
        max = 10,
        decimal = 0,
    })

    parent:MakeHelp({
        label = "help_roles_credits_award",
    })

    parent:MakeCheckBox({
        serverConvar = "ttt_" .. roleData.abbr .. "_credits_award_dead_enb",
        label = "label_roles_credits_dead_award",
    })

    parent:MakeCheckBox({
        serverConvar = "ttt_" .. roleData.abbr .. "_credits_award_kill_enb",
        label = "label_roles_credits_kill_award",
    })

    -- run a hook to add role specific custom credit convars
    roleData:AddToSettingsMenuCreditsForm(parent)
end

function CLGAMEMODESUBMENU:Populate(parent)
    PopulateInfo(vgui.CreateTTT2Form(parent, "header_roles_info"), self.roleData)

    if not self.roleData.notSelectable then
        PopulateSelection(vgui.CreateTTT2Form(parent, "header_roles_selection"), self.roleData)
    end

    PopulateMagnetoStick(vgui.CreateTTT2Form(parent, "header_roles_magnetostick"), self.roleData)
    PopulateTButtons(vgui.CreateTTT2Form(parent, "header_roles_tbuttons"), self.roleData)
    PopulateCredits(vgui.CreateTTT2Form(parent, "header_roles_credits"), self.roleData)

    -- run a hook to add role specific custom convars
    self.roleData:AddToSettingsMenu(parent)

    hook.Run("TTT2OnRoleAddToSettingsMenu", self.roleData, parent)
end

-- Override this here, because we don't want auto-discovery to show this menu
function CLGAMEMODESUBMENU:ShouldShow()
    return false
end
