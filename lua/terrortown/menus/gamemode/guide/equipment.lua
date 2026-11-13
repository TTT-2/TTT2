--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_guide_equipment_title"

local TryT = LANG.TryTranslation
local GetRawT = LANG.GetRawTranslation
local GetParamT = LANG.GetParamTranslation

local builtinIcon = Material("vgui/ttt/vskin/markers/builtin")

local heightEquipmentButton = 50
local widthEquipmentListMin = 200
local widthEquipmentListMax = 320
local widthEquipmentListPercent = 0.33

local lastActive

---
-- Creates a label that wraps its text if it does not fit into a single line.
-- @note A plain `DLabel` is used here, because `DLabelTTT2` paints its text with
-- `draw.SimpleText`, which does not wrap long texts such as equipment descriptions.
-- @param Panel parent The parent panel
-- @param string text The text that should be displayed
-- @param[opt] string font The font that should be used
-- @return Panel The created label
-- @realm client
local function CreateWrappedLabel(parent, text, font)
    local label = vgui.Create("DLabel", parent)
    label:Dock(TOP)
    label:SetText(text)
    label:SetFont(font or "DermaTTT2Text")
    label:SetWrap(true)
    label:SetAutoStretchVertical(true)
    label:DockMargin(10, 5, 10, 5)

    return label
end

---
-- Returns the translated name of the given equipment.
-- @param table equipment The equipment table
-- @return string The translated name
-- @realm client
local function GetEquipmentTitle(equipment)
    return GetEquipmentTranslation(equipment.name, equipment.PrintName) or equipment.id
end

---
-- Returns the translated names of all roles that are able to buy the given equipment.
-- @note The buyable roles are synced from the server, custom shops are therefore respected.
-- @param table equipment The equipment table
-- @return table The translated role names, ordered by the role order
-- @realm client
local function GetBuyableRoles(equipment)
    local canBuy = equipment.CanBuy
    local buyableRoles = {}

    if not istable(canBuy) then
        return buyableRoles
    end

    local sortedRoles = roles.GetSortedRoles()

    for i = 1, #sortedRoles do
        local roleData = sortedRoles[i]

        if canBuy[roleData.index] then
            buyableRoles[#buyableRoles + 1] = TryT(roleData.name)
        end
    end

    return buyableRoles
end

---
-- Populates the info panel with the details of the given equipment.
-- @param Panel parent The parent panel
-- @param table equipment The equipment whose details should be displayed
-- @realm client
local function PopulateEquipmentInfo(parent, equipment)
    -- header with the equipment icon, its name and its type
    local header = vgui.Create("DPanelTTT2", parent)
    header:Dock(TOP)
    header:SetTall(84)
    header:DockPadding(10, 10, 10, 10)

    local iconWrapper = vgui.Create("DPanelTTT2", header)
    iconWrapper:Dock(LEFT)
    iconWrapper:SetWide(64)

    -- equipment is either displayed with an icon material or with its model
    local equipmentImage

    if equipment.iconMaterial then
        equipmentImage = vgui.Create("LayeredIcon", iconWrapper)
        equipmentImage:SetIconSize(64)
        equipmentImage:SetMaterial(equipment.iconMaterial)
    elseif equipment.itemModel then
        equipmentImage = vgui.Create("SpawnIcon", iconWrapper)
        equipmentImage:SetModel(equipment.itemModel)
    end

    if equipmentImage then
        equipmentImage:Dock(FILL)
        equipmentImage:SetMouseInputEnabled(false)
    end

    local nameLabel =
        CreateWrappedLabel(header, GetEquipmentTitle(equipment), "DermaTTT2TextLarger")
    nameLabel:DockMargin(10, 0, 10, 0)

    local typeLabel = CreateWrappedLabel(header, TryT(equipment.type), "DermaTTT2TextLarge")
    typeLabel:DockMargin(10, 0, 10, 0)

    -- equipment description, equipment addons provide it as a language identifier
    local description = GetRawT(equipment.desc) or TryT("guide_equipment_no_description")

    CreateWrappedLabel(parent, description, "DermaTTT2Text")

    if equipment.builtin then
        CreateWrappedLabel(parent, TryT("equipmenteditor_desc_builtin"), "DermaTTT2Text")
    end

    local buyableRoles = GetBuyableRoles(equipment)

    if #buyableRoles > 0 then
        CreateWrappedLabel(
            parent,
            GetParamT("guide_equipment_buyable_by", {
                roles = table.concat(buyableRoles, ", "),
            }),
            "DermaTTT2Text"
        )
    end
end

---
-- Displays the details of the given equipment in the info panel.
-- @param Panel infoPanel The scroll panel that contains the equipment details
-- @param table equipment The equipment whose details should be displayed
-- @param Panel equipmentButton The button that belongs to the equipment
-- @realm client
local function SelectEquipment(infoPanel, equipment, equipmentButton)
    infoPanel:Clear()

    PopulateEquipmentInfo(infoPanel, equipment)

    -- handle the set/unset of active buttons for the draw process
    if IsValid(lastActive) and lastActive.SetActive then
        lastActive:SetActive(false)
    end

    equipmentButton:SetActive()
    lastActive = equipmentButton

    -- always show the beginning of an equipment's description
    infoPanel:GetVBar():SetScroll(0)
    infoPanel:InvalidateLayout(true)
end

function CLGAMEMODESUBMENU:Populate(parent)
    lastActive = nil

    local width, height = parent:GetSize()

    -- the parent is a scroll panel, the container takes its size to prevent scrolling
    -- of the whole page, the equipment list and the equipment details scroll on their own
    local container = vgui.Create("DPanelTTT2", parent)
    container:Dock(TOP)
    container:SetTall(height)

    local widthEquipmentList =
        math.Clamp(width * widthEquipmentListPercent, widthEquipmentListMin, widthEquipmentListMax)

    local listPanel = vgui.Create("DScrollPanelTTT2", container)
    listPanel:Dock(LEFT)
    listPanel:SetWide(widthEquipmentList)
    listPanel:DockMargin(0, 0, 10, 0)

    local infoPanel = vgui.Create("DScrollPanelTTT2", container)
    infoPanel:Dock(FILL)

    -- sort the equipment by its translated name, the cache itself must not be modified
    local installedEquipment = ShopEditor.GetEquipmentForRoleAll()
    local sortedEquipment = {}

    for i = 1, #installedEquipment do
        local equipment = installedEquipment[i]

        sortedEquipment[#sortedEquipment + 1] = {
            equipment = equipment,
            title = GetEquipmentTitle(equipment),
        }
    end

    table.SortByMember(sortedEquipment, "title", true)

    local firstEquipment, firstEquipmentButton

    for i = 1, #sortedEquipment do
        local equipment = sortedEquipment[i].equipment

        local equipmentButton = vgui.Create("DSubmenuButtonTTT2", listPanel)
        equipmentButton:Dock(TOP)
        equipmentButton:DockMargin(0, 0, 0, 5)
        equipmentButton:SetTitle(sortedEquipment[i].title)
        equipmentButton:SetIcon(equipment.iconMaterial, true)
        equipmentButton:SetIconBadge(equipment.builtin and builtinIcon)
        equipmentButton:SetIconBadgeSize(8)

        equipmentButton.PerformLayout = function(panel)
            panel:SetSize(panel:GetParent():GetWide(), heightEquipmentButton)
        end

        equipmentButton.DoClick = function(slf)
            SelectEquipment(infoPanel, equipment, slf)
        end

        if not firstEquipment then
            firstEquipment = equipment
            firstEquipmentButton = equipmentButton
        end
    end

    -- preselect the first equipment so the info panel is never empty
    if firstEquipment then
        SelectEquipment(infoPanel, firstEquipment, firstEquipmentButton)
    end
end
