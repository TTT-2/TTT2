--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 91
CLGAMEMODESUBMENU.title = "submenu_appearance_ammo_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_ammo_appearance")
    local scalingSlider

    form:MakeHelp({
        label = "help_ammo_appearance",
    })

    local scalingCheckbox = form:MakeCheckBox({
        convar = "ttt2_ammo_entity_scaling",
        label = "label_ammo_entity_scaling",
        OnChange = function(_, value)
            local sliderRow = scalingSlider and scalingSlider:GetParent()

            if not IsValid(sliderRow) then
                return
            end

            sliderRow:SetVisible(value)
            sliderRow:InvalidateLayout(true)
            form:InvalidateLayout(true)

            if IsValid(parent) then
                parent:InvalidateLayout(true)
            end
        end,
    })

    scalingSlider = form:MakeSlider({
        convar = "ttt2_ammo_entity_scaling_min",
        label = "label_ammo_entity_scaling_min",
        min = 0.25,
        max = 1,
        decimal = 2,
        master = scalingCheckbox,
    })

    local scalingSliderRow = scalingSlider:GetParent()
    local scalingConVar = GetConVar("ttt2_ammo_entity_scaling")

    if IsValid(scalingSliderRow) then
        scalingSliderRow:SetVisible(not scalingConVar or scalingConVar:GetBool())
    end

    form:MakeCheckBox({
        convar = "ttt2_ammo_targetid",
        label = "label_ammo_targetid",
    })
end