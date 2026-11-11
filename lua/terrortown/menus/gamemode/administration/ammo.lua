--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_ammo_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_ammo_administration")

    form:MakeHelp({
        label = "help_ammo_administration",
    })

    local ammoTypes = {}

    for i, ammoType in ipairs(WEPS.GetAmmoTypes()) do
        local title = LANG.TryTranslation(ammoType.name)

        ammoTypes[i] = {
            data = ammoType,
            title = title == ammoType.name and ammoType.ammoType or title,
        }
    end

    table.SortByMember(ammoTypes, "title", true)

    for i = 1, #ammoTypes do
        local ammoType = ammoTypes[i].data
        local ammoForm = vgui.CreateTTT2Form(parent, ammoTypes[i].title)

        ammoForm:MakeSlider({
            serverConvar = WEPS.GetAmmoReserveConVarName(ammoType.ammoType),
            label = "label_ammo_reserve_max",
            min = 0,
            max = math.max(500, ammoType.reserveMax * 4),
            decimal = 0,
        })

        for j = 1, #ammoType.entities do
            local ammoBox = ammoType.entities[j]

            if #ammoType.entities > 1 then
                ammoForm:MakeHelp({
                    label = "label_ammo_entity_class",
                    params = { class = ammoBox.class },
                })
            end

            ammoForm:MakeCheckBox({
                serverConvar = WEPS.GetAmmoSettingsConVarName(ammoBox.class, "enabled"),
                label = "label_ammo_enable",
            })

            ammoForm:MakeSlider({
                serverConvar = WEPS.GetAmmoSettingsConVarName(ammoBox.class, "box_amount"),
                label = "label_ammo_box_amount",
                min = 1,
                max = math.max(200, ammoBox.boxAmount * 4),
                decimal = 0,
            })
        end
    end
end
