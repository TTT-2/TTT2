--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 87
CLGAMEMODESUBMENU.title = "submenu_administration_sprint_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_sprint_general")

    local enbSprint = form:MakeCheckBox({
        serverConvar = "ttt2_sprint_enabled",
        label = "label_sprint_enabled",
    })

    form:MakeSlider({
        serverConvar = "ttt2_sprint_max",
        label = "label_sprint_max",
        min = 0,
        max = 2,
        decimal = 2,
        master = enbSprint,
    })

    form:MakeSlider({
        serverConvar = "ttt2_sprint_stamina_consumption",
        label = "label_sprint_stamina_consumption",
        min = 0,
        max = 2,
        decimal = 2,
        master = enbSprint,
    })

    form:MakeSlider({
        serverConvar = "ttt2_sprint_stamina_regeneration",
        label = "label_sprint_stamina_regeneration",
        min = 0,
        max = 2,
        decimal = 2,
        master = enbSprint,
    })

    form:MakeSlider({
        serverConvar = "ttt2_sprint_stamina_cooldown",
        label = "label_sprint_stamina_cooldown",
        min = 0,
        max = 2,
        decimal = 2,
        master = enbSprint,
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_sprint_forwards_only",
        label = "label_sprint_stamina_forwards_only",
        master = enbSprint,
    })
end
