--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_guide_roles_title"

local TryT = LANG.TryTranslation
local GetRawT = LANG.GetRawTranslation
local GetParamT = LANG.GetParamTranslation

local builtinIcon = Material("vgui/ttt/vskin/markers/builtin")

local heightRoleButton = 50
local widthRoleListMin = 200
local widthRoleListMax = 320
local widthRoleListPercent = 0.33

local lastActive

---
-- Creates a label that wraps its text if it does not fit into a single line.
-- @note A plain `DLabel` is used here, because `DLabelTTT2` paints its text with
-- `draw.SimpleText`, which does not wrap long texts such as role descriptions.
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
-- Returns all roles that are currently part of the game. Roles that are disabled in the
-- role settings are not included, as they cannot be assigned to any player. The values are
-- requested from the server, as the server is authoritative for these convars.
-- @param function callback Called with the list of roles that should be shown
-- @realm client
local function GetVisibleRoles(callback)
    local sortedRoles = roles.GetSortedRoles()

    cvars.ServerConVarGetValue("ttt_newroles_enabled", function(newRolesSuccess, newRolesValue)
        local newRolesEnabled = not newRolesSuccess or tobool(newRolesValue)
        local visible = {}
        local rolesToCheck = {}

        for i = 1, #sortedRoles do
            local roleData = sortedRoles[i]

            if roleData.index == ROLE_NONE then
                continue
            end

            if roleData.index == ROLE_INNOCENT or roleData.index == ROLE_TRAITOR then
                visible[roleData.index] = true
            elseif roleData.notSelectable then
                -- these roles are not distributed, they are handed out during the round and
                -- have no enabled convar, so they are always part of the game
                visible[roleData.index] = true
            elseif not roleData.builtin and not newRolesEnabled then
                -- roles added on top of the built-in ones are disabled entirely
                visible[roleData.index] = false
            else
                rolesToCheck[#rolesToCheck + 1] = roleData
            end
        end

        local roleCount = #rolesToCheck
        local pending = roleCount

        local function Finish()
            local visibleRoles = {}

            -- preserve the order of the sorted roles
            for i = 1, #sortedRoles do
                local roleData = sortedRoles[i]

                if visible[roleData.index] then
                    visibleRoles[#visibleRoles + 1] = roleData
                end
            end

            callback(visibleRoles)
        end

        if pending < 1 then
            Finish()

            return
        end

        for i = 1, roleCount do
            local roleData = rolesToCheck[i]

            cvars.ServerConVarGetValue(
                "ttt_" .. roleData.name .. "_enabled",
                function(success, value)
                    -- a role without an enabled convar is not gated by one
                    visible[roleData.index] = not success or tobool(value)

                    pending = pending - 1

                    if pending < 1 then
                        Finish()
                    end
                end
            )
        end
    end)
end

---
-- Populates the info panel with the details of the given role.
-- @param Panel parent The parent panel
-- @param ROLE roleData The role whose details should be displayed
-- @realm client
local function PopulateRoleInfo(parent, roleData)
    -- header with the role icon, its name and its team
    local header = vgui.Create("DPanelTTT2", parent)
    header:Dock(TOP)
    header:SetTall(84)
    header:DockPadding(10, 10, 10, 10)

    local iconWrapper = vgui.Create("DPanelTTT2", header)
    iconWrapper:Dock(LEFT)
    iconWrapper:SetWide(64)

    local roleImage = vgui.Create("DRoleImageTTT2", iconWrapper)
    roleImage:Dock(FILL)
    roleImage:SetMaterial(roleData.iconMaterial)
    roleImage:SetColor(roleData.color)
    roleImage:SetValue(true)
    roleImage:SetMouseInputEnabled(false)

    local nameLabel = CreateWrappedLabel(header, TryT(roleData.name), "DermaTTT2TextLarger")
    nameLabel:DockMargin(10, 0, 10, 0)

    local teamLabel = CreateWrappedLabel(header, TryT(roleData.defaultTeam), "DermaTTT2TextLarge")
    teamLabel:DockMargin(10, 0, 10, 0)

    -- role description, role addons provide it with the same language identifier the
    -- role settings menu uses
    local description = GetRawT("ttt2_desc_" .. roleData.name) or TryT("guide_role_no_description")

    CreateWrappedLabel(parent, description, "DermaTTT2Text")

    if roleData.builtin then
        CreateWrappedLabel(parent, TryT("help_roles_builtin"), "DermaTTT2Text")
    end

    -- subroles are based on another role, show which one
    local baseRole = roleData.baserole and roles.GetByIndex(roleData.baserole)

    if baseRole then
        CreateWrappedLabel(
            parent,
            GetParamT("guide_role_baserole", {
                baserole = TryT(baseRole.name),
            }),
            "DermaTTT2Text"
        )
    end
end

---
-- Displays the details of the given role in the info panel.
-- @param Panel infoPanel The scroll panel that contains the role details
-- @param ROLE roleData The role whose details should be displayed
-- @param Panel roleButton The button that belongs to the role
-- @realm client
local function SelectRole(infoPanel, roleData, roleButton)
    infoPanel:Clear()

    PopulateRoleInfo(infoPanel, roleData)

    -- handle the set/unset of active buttons for the draw process
    if IsValid(lastActive) and lastActive.SetActive then
        lastActive:SetActive(false)
    end

    roleButton:SetActive()
    lastActive = roleButton

    -- always show the beginning of a role's description
    infoPanel:GetVBar():SetScroll(0)
    infoPanel:InvalidateLayout(true)
end

function CLGAMEMODESUBMENU:Populate(parent)
    lastActive = nil

    local width, height = parent:GetSize()

    -- the parent is a scroll panel, the container takes its size to prevent scrolling
    -- of the whole page, the role list and the role details scroll on their own
    local container = vgui.Create("DPanelTTT2", parent)
    container:Dock(TOP)
    container:SetTall(height)

    local widthRoleList =
        math.Clamp(width * widthRoleListPercent, widthRoleListMin, widthRoleListMax)

    local listPanel = vgui.Create("DScrollPanelTTT2", container)
    listPanel:Dock(LEFT)
    listPanel:SetWide(widthRoleList)
    listPanel:DockMargin(0, 0, 10, 0)

    local infoPanel = vgui.Create("DScrollPanelTTT2", container)
    infoPanel:Dock(FILL)

    GetVisibleRoles(function(visibleRoles)
        -- the menu can be closed while the role settings are fetched from the server
        if not IsValid(listPanel) or not IsValid(infoPanel) then
            return
        end

        local firstRole, firstRoleButton

        for i = 1, #visibleRoles do
            local roleData = visibleRoles[i]

            local roleButton = vgui.Create("DSubmenuButtonTTT2", listPanel)
            roleButton:Dock(TOP)
            roleButton:DockMargin(0, 0, 0, 5)
            roleButton:SetTitle(roleData.name)
            roleButton:SetIcon(roleData.iconMaterial, false)
            roleButton:SetIconBadge(roleData.builtin and builtinIcon)
            roleButton:SetIconBadgeSize(8)

            roleButton.PerformLayout = function(panel)
                panel:SetSize(panel:GetParent():GetWide(), heightRoleButton)
            end

            roleButton.DoClick = function(slf)
                SelectRole(infoPanel, roleData, slf)
            end

            if not firstRole then
                firstRole = roleData
                firstRoleButton = roleButton
            end
        end

        -- preselect the first role so the info panel is never empty
        if firstRole then
            SelectRole(infoPanel, firstRole, firstRoleButton)
        end
    end)
end
