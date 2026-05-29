--- @ignore

local mathMax = math.max
local SortByMember = table.SortByMember
local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_administration_ammo_title"

local function GetSortedAmmoEntities()
    local ammoEntities = WEPS.GetAmmoEntities()
    local sortedEntities = {}

    for i = 1, #ammoEntities do
        local ammoData = ammoEntities[i]
        local title = TryT(ammoData.typeName)

        sortedEntities[i] = {
            ammoType = ammoData.ammoType,
            class = ammoData.class,
            boxAmount = ammoData.boxAmount,
            reserveMax = ammoData.reserveMax,
            sortTitle = title .. " " .. ammoData.class,
            title = title,
        }
    end

    SortByMember(sortedEntities, "sortTitle", true)

    return sortedEntities
end

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_ammo_administration")

    form:MakeHelp({
        label = "help_ammo_administration",
    })

    local ammoEntries = GetSortedAmmoEntities()

    for i = 1, #ammoEntries do
        local ammoData = ammoEntries[i]
        local ammoForm = vgui.CreateTTT2Form(parent, ammoData.title)

        ammoForm:MakeHelp({
            label = "label_ammo_entity_class",
            params = {
                class = ammoData.class,
            },
        })

        ammoForm:MakeCheckBox({
            serverConvar = WEPS.GetAmmoSettingsConVarName(ammoData.class, "enabled"),
            label = "label_ammo_enable",
        })

        ammoForm:MakeSlider({
            serverConvar = WEPS.GetAmmoTypeSettingsConVarName(ammoData.ammoType, "reserve_max"),
            label = "label_ammo_reserve_max",
            min = 0,
            max = mathMax(500, ammoData.reserveMax * 4),
            decimal = 0,
        })

        ammoForm:MakeSlider({
            serverConvar = WEPS.GetAmmoSettingsConVarName(ammoData.class, "box_amount"),
            label = "label_ammo_box_amount",
            min = 1,
            max = mathMax(200, ammoData.boxAmount * 4),
            decimal = 0,
        })
    end
end