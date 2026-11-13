--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_guide_roles_title"

local TryT = LANG.TryTranslation
local GetRawT = LANG.GetRawTranslation
local GetParamT = LANG.GetParamTranslation

local heightCard = 66
local widthCardMin = 220
local heightFilterRow = 30
local widthTeamFilter = 200

local spacing = 6
local padding = 10

local heightPointer = 8
local heightDetailLine = 3
local sizeDetailIcon = 64
local sizeCloseButton = 16
local heightTag = 20
local heightSectionTitle = 20
local heightProperty = 28
local widthEquipmentMin = 110
local heightEquipment = 70
local sizeEquipmentModel = 40

local fontBullets = "DermaTTT2Text"
local indentBullets = 14

local equipmentIconCache = {}

---
-- Returns all roles that are currently part of the game. Roles that are disabled in the
-- role settings are not included, as they cannot be assigned to any player.
-- @param function callback Called with the list of roles that should be shown and a table
-- with the server side settings of these roles, indexed by the role index
-- @realm client
local function GetVisibleRoles(callback)
    roles.RequestEnabledRoles(function(activeRoles)
        local visibleRoles = {}
        local sortedRoles = roles.GetSortedRoles()

        for i = 1, #sortedRoles do
            local roleData = sortedRoles[i]

            if activeRoles[roleData.index] then
                visibleRoles[#visibleRoles + 1] = roleData
            end
        end

        callback(visibleRoles, activeRoles)
    end)
end

---
-- Returns the color of a team, falls back to the color of the given role.
-- @param string team The team name
-- @param ROLE roleData The role that is part of this team
-- @return Color The team color
-- @realm client
local function GetTeamColor(team, roleData)
    local teamData = TEAMS[team]

    return teamData and teamData.color or roleData.color
end

---
-- Returns the shop fallback of a role. It is synced from the server and therefore up to date
-- with changes made in the shop editor.
-- @param ROLE roleData The role
-- @return string The shop fallback
-- @realm client
local function GetShopFallbackValue(roleData)
    return GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback", SHOP_DISABLED)
end

---
-- @param ROLE roleData The role
-- @return boolean Whether the role has access to a shop
-- @realm client
local function HasShop(roleData)
    local shopFallback = GetShopFallbackValue(roleData)

    return shopFallback ~= "" and shopFallback ~= SHOP_DISABLED
end

---
-- Returns a text that describes which shop a role uses.
-- @param ROLE roleData The role
-- @return string The translated text
-- @realm client
local function GetShopText(roleData)
    if not HasShop(roleData) then
        return TryT("guide_role_shop_none")
    end

    local shopFallback = GetShopFallbackValue(roleData)
    local fallbackRole = shopFallback ~= SHOP_UNSET and roles.GetStored(shopFallback)

    if not fallbackRole or fallbackRole == roleData then
        return TryT("guide_role_shop_own")
    end

    return GetParamT("guide_role_shop_linked", { role = TryT(fallbackRole.name) })
end

---
-- Returns the icon material of an equipment, the result is cached.
-- @param table equipment The equipment table
-- @return[opt] Material The icon material, nil if the equipment has no valid material
-- @realm client
local function GetEquipmentIcon(equipment)
    if equipment.iconMaterial then
        return equipment.iconMaterial
    end

    local materialPath = equipment.material

    if not materialPath or materialPath == "" then
        return
    end

    if equipmentIconCache[materialPath] == nil then
        local material = Material(materialPath)

        equipmentIconCache[materialPath] = not material:IsError() and material or false
    end

    return equipmentIconCache[materialPath] or nil
end

---
-- Returns the equipment that is available in the shop of a role, sorted by name.
-- @note The unmodified shop is used, therefore random shops do not affect the list.
-- @param ROLE roleData The role
-- @return table A list of tables with the `title`, `icon` and `model` of each equipment
-- @realm client
local function GetShopEquipment(roleData)
    local shopEquipment = {}

    if not HasShop(roleData) then
        return shopEquipment
    end

    local equipmentList = GetEquipmentForRole(LocalPlayer(), roleData.index, true) or {}

    for i = 1, #equipmentList do
        local equipment = equipmentList[i]

        shopEquipment[#shopEquipment + 1] = {
            title = GetEquipmentTranslation(equipment.name, equipment.PrintName) or equipment.id,
            icon = GetEquipmentIcon(equipment),
            model = equipment.itemModel or equipment.model,
        }
    end

    table.sort(shopEquipment, function(a, b)
        return a.title < b.title
    end)

    return shopEquipment
end

---
-- Creates a help box with wrapped text, it has the same look as the help boxes in forms.
-- @param Panel parent The parent panel
-- @param string text The language identifier of the text
-- @return Panel The created help box
-- @realm client
local function CreateHelpBox(parent, text)
    local box = vgui.Create("DLabelTTT2", parent)

    box:SetText(text)
    box:SetContentAlignment(7)

    box.paddingX = 10
    box.paddingY = 5

    box.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "HelpLabelTTT2", slf, w, h)

        return true
    end

    -- the size is set by the parent through UpdateSize
    box.PerformLayout = function() end

    box.UpdateSize = function(slf, width)
        local textWrapped =
            draw.GetWrappedText(TryT(slf:GetText()), width - 2 * slf.paddingX, slf:GetFont())
        local _, heightText = draw.GetTextSize("", slf:GetFont())

        slf:SetSize(width, heightText * #textWrapped + 2 * slf.paddingY)
    end

    return box
end

---
-- Creates a list of bullet points, every line of the given text is its own bullet point.
-- @param Panel parent The parent panel
-- @param string text The already translated text
-- @return Panel The created list
-- @realm client
local function CreateBulletList(parent, text)
    local list = vgui.Create("DPanelTTT2", parent)

    list.indent = indentBullets
    list.lines = {}

    list.GetFont = function()
        return fontBullets
    end

    list.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuideBulletListTTT2", slf, w, h)

        return true
    end

    list.UpdateSize = function(slf, width)
        local entries = string.Explode("\n", text)
        local lines = {}

        for i = 1, #entries do
            local entry = string.Trim(entries[i])

            if entry == "" then
                continue
            end

            local wrapped = draw.GetWrappedText(entry, width - slf.indent, fontBullets)

            for k = 1, #wrapped do
                lines[#lines + 1] = { text = wrapped[k], bullet = k == 1 }
            end
        end

        local _, heightText = draw.GetTextSize("", fontBullets)

        slf.lines = lines
        slf:SetSize(width, heightText * #lines)
    end

    return list
end

---
-- Creates a small uppercase title for a section of the role details.
-- @param Panel parent The parent panel
-- @param string text The language identifier of the title
-- @return Panel The created title
-- @realm client
local function CreateSectionTitle(parent, text)
    local title = vgui.Create("DLabelTTT2", parent)

    title:SetText(text)
    title:SetFont("DermaTTT2SmallBold")

    title.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuideSectionTitleTTT2", slf, w, h)

        return true
    end

    return title
end

---
-- Creates a colored tag that fits its text.
-- @param Panel parent The parent panel
-- @param string text The language identifier of the text
-- @param Color color The background color of the tag
-- @return Panel The created tag
-- @realm client
local function CreateTag(parent, text, color)
    local tag = vgui.Create("DLabelTTT2", parent)

    tag:SetText(text)
    tag:SetFont("DermaTTT2SmallBold")

    tag.color = color

    tag.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuideTagTTT2", slf, w, h)

        return true
    end

    tag:SetSize(draw.GetTextSize(TryT(text), "DermaTTT2SmallBold") + 2 * padding, heightTag)

    return tag
end

---
-- Creates a row that shows a property of a role.
-- @param Panel parent The parent panel
-- @param string title The language identifier of the property name
-- @param string value The already translated value
-- @return Panel The created row
-- @realm client
local function CreateProperty(parent, title, value)
    local property = vgui.Create("DPanelTTT2", parent)

    property.title = title
    property.value = value

    property.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuidePropertyTTT2", slf, w, h)

        return true
    end

    return property
end

---
-- Creates a tile that shows an equipment of a shop.
-- @param Panel parent The parent panel
-- @param table equipment A table with the `title`, `icon` and `model` of the equipment
-- @return Panel The created tile
-- @realm client
local function CreateEquipmentTile(parent, equipment)
    local tile = vgui.Create("DLabelTTT2", parent)

    tile:SetText(equipment.title)

    tile.icon = equipment.icon

    tile.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuideEquipmentTTT2", slf, w, h)

        return true
    end

    -- equipment without an icon is presented with its model
    if not tile.icon and equipment.model then
        local modelIcon = vgui.Create("SpawnIcon", tile)

        modelIcon:SetModel(equipment.model)
        modelIcon:SetSize(sizeEquipmentModel, sizeEquipmentModel)
        modelIcon:SetMouseInputEnabled(false)

        tile.modelIcon = modelIcon
    end

    tile.PerformLayout = function(slf, w)
        if IsValid(slf.modelIcon) then
            slf.modelIcon:SetPos(0.5 * (w - sizeEquipmentModel), 5)
        end
    end

    return tile
end

---
-- Creates the panel with the details of a role, it is shown below the row of the selected
-- role card.
-- @param Panel parent The panel that contains the role cards
-- @param Panel card The selected role card
-- @param[opt] table roleInfo The server side settings of the role
-- @param function onClose Called when the details should be closed
-- @return Panel The created panel
-- @realm client
local function CreateRoleDetail(parent, card, roleInfo, onClose)
    local roleData = card.roleData
    local team = roleData.defaultTeam
    local colorTag = util.GetChangedColor(vskin.GetBackgroundColor(), 75)

    local detail = vgui.Create("DPanelTTT2", parent)

    detail.card = card
    detail.heightPointer = heightPointer

    detail.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "RoleDetailTTT2", slf, w, h)

        return true
    end

    -- header with the role icon, its name and tags
    local icon = vgui.Create("DRoleImageTTT2", detail)
    icon:SetSize(sizeDetailIcon, sizeDetailIcon)
    icon:SetMaterial(roleData.iconMaterial)
    icon:SetColor(roleData.color)
    icon:SetValue(true)
    icon:SetMouseInputEnabled(false)

    local name = vgui.Create("DLabelTTT2", detail)
    name:SetText(roleData.name)
    name:SetFont("DermaTTT2TextLargest")

    local tags = {
        CreateTag(detail, team, GetTeamColor(team, roleData)),
    }

    if roleData.builtin then
        tags[#tags + 1] = CreateTag(detail, "guide_role_tag_builtin", colorTag)
    end

    if HasShop(roleData) then
        tags[#tags + 1] = CreateTag(detail, "guide_role_tag_shop", colorTag)
    end

    local buttonClose = vgui.Create("DButtonTTT2", detail)
    buttonClose:SetText("")
    buttonClose:SetSize(sizeCloseButton, sizeCloseButton)
    buttonClose:SetTooltip("close")

    buttonClose.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "GuideCloseButtonTTT2", slf, w, h)

        return true
    end

    buttonClose.DoClick = function()
        onClose()
    end

    -- role description, role addons provide it with the same language identifier the
    -- role settings menu uses
    local descriptionKey = "ttt2_desc_" .. roleData.name

    local description = CreateHelpBox(
        detail,
        GetRawT(descriptionKey) and descriptionKey or "guide_role_no_description"
    )

    -- how to play, role addons can provide it with a language identifier
    local howToPlay = GetRawT("ttt2_howtoplay_" .. roleData.name)
    local titleHowToPlay, bulletsHowToPlay

    if howToPlay then
        titleHowToPlay = CreateSectionTitle(detail, "guide_role_how_to_play")
        bulletsHowToPlay = CreateBulletList(detail, howToPlay)
    end

    -- properties of the role
    local titleProperties = CreateSectionTitle(detail, "guide_role_properties")
    local properties = {}

    -- subroles are based on another role, show which one
    local baseRole = roleData.baserole and roles.GetByIndex(roleData.baserole)

    if baseRole and baseRole ~= roleData then
        properties[#properties + 1] =
            CreateProperty(detail, "guide_role_property_baserole", TryT(baseRole.name))
    end

    properties[#properties + 1] =
        CreateProperty(detail, "guide_role_property_shop", GetShopText(roleData))

    local credits = roleInfo and roleInfo.credits or 0

    if HasShop(roleData) or credits > 0 then
        properties[#properties + 1] =
            CreateProperty(detail, "guide_role_property_credits", tostring(credits))
    end

    properties[#properties + 1] = CreateProperty(
        detail,
        "guide_role_property_public",
        TryT(roleData.isPublicRole and "guide_role_yes" or "guide_role_no")
    )

    -- equipment that can be bought in the shop of the role
    local shopEquipment = GetShopEquipment(roleData)
    local titleShop
    local equipmentTiles = {}

    if #shopEquipment > 0 then
        titleShop = CreateSectionTitle(detail, "guide_role_shop")

        for i = 1, #shopEquipment do
            equipmentTiles[i] = CreateEquipmentTile(detail, shopEquipment[i])
        end
    end

    -- the size of the details depends on the width, the parent therefore sets the width
    -- and the details calculate their height
    detail.UpdateSize = function(slf, width)
        local widthContent = width - 2 * padding
        local posY = heightPointer + heightDetailLine + padding

        icon:SetPos(padding, posY)

        local posText = padding + sizeDetailIcon + padding

        name:SetPos(posText, posY)
        name:SetSize(width - posText - sizeCloseButton - 2 * padding, 30)

        local posTag = posText

        for i = 1, #tags do
            tags[i]:SetPos(posTag, posY + 36)

            posTag = posTag + tags[i]:GetWide() + spacing
        end

        buttonClose:SetPos(width - padding - sizeCloseButton, posY)

        posY = posY + sizeDetailIcon + padding

        description:UpdateSize(widthContent)
        description:SetPos(padding, posY)

        posY = posY + description:GetTall() + padding

        -- how to play and the properties are shown next to each other
        local widthColumn = widthContent
        local posProperties = padding
        local posYHowToPlay = posY

        if howToPlay then
            widthColumn = math.floor(0.5 * (widthContent - padding))
            posProperties = padding + widthColumn + padding

            titleHowToPlay:SetPos(padding, posY)
            titleHowToPlay:SetSize(widthColumn, heightSectionTitle)

            bulletsHowToPlay:UpdateSize(widthColumn)
            bulletsHowToPlay:SetPos(padding, posY + heightSectionTitle + 4)

            posYHowToPlay = posY + heightSectionTitle + 4 + bulletsHowToPlay:GetTall()
        end

        titleProperties:SetPos(posProperties, posY)
        titleProperties:SetSize(widthColumn, heightSectionTitle)

        local posYProperties = posY + heightSectionTitle + 4

        for i = 1, #properties do
            properties[i]:SetPos(posProperties, posYProperties)
            properties[i]:SetSize(widthColumn, heightProperty)

            posYProperties = posYProperties + heightProperty + 4
        end

        posY = math.max(posYHowToPlay, posYProperties - 4) + padding

        if titleShop then
            titleShop:SetPos(padding, posY)
            titleShop:SetSize(widthContent, heightSectionTitle)

            posY = posY + heightSectionTitle + 4

            local columns =
                math.max(1, math.floor((widthContent + spacing) / (widthEquipmentMin + spacing)))
            local widthTile = math.floor((widthContent - (columns - 1) * spacing) / columns)

            for i = 1, #equipmentTiles do
                local column = (i - 1) % columns
                local row = math.floor((i - 1) / columns)

                equipmentTiles[i]:SetPos(
                    padding + column * (widthTile + spacing),
                    posY + row * (heightEquipment + spacing)
                )
                equipmentTiles[i]:SetSize(widthTile, heightEquipment)
            end

            local rows = math.ceil(#equipmentTiles / columns)

            posY = posY + rows * (heightEquipment + spacing) - spacing + padding
        end

        slf:SetSize(width, posY)
    end

    return detail
end

---
-- Creates the panel that contains the role cards of a team. The cards are arranged in rows,
-- the details of the selected role are shown below the row of its card.
-- @note The grid has to be created with the form as its parent, otherwise it does not use
-- the skin of the menu.
-- @param Panel parent The form the grid is added to
-- @return Panel The created panel
-- @realm client
local function CreateCardGrid(parent)
    local grid = vgui.Create("DPanelTTT2", parent)

    grid.cards = {}

    grid.PerformLayout = function(slf, w)
        local cards = slf.cards
        local detail = IsValid(slf.detail) and slf.detail or nil

        local columns = math.max(1, math.floor((w + spacing) / (widthCardMin + spacing)))
        local widthCard = math.floor((w - (columns - 1) * spacing) / columns)
        local posY = 0

        for i = 1, #cards, columns do
            local hasSelectedCard = false

            for column = 0, columns - 1 do
                local card = cards[i + column]

                if not card then
                    break
                end

                local posX = column * (widthCard + spacing)

                card:SetPos(posX, posY)
                card:SetSize(widthCard, heightCard)

                if detail and detail.card == card then
                    hasSelectedCard = true
                    detail.posPointer = posX + 0.5 * widthCard
                end
            end

            posY = posY + heightCard + spacing

            if hasSelectedCard then
                detail:SetPos(0, posY)
                detail:UpdateSize(w)

                posY = posY + detail:GetTall() + spacing
            end
        end

        posY = math.max(0, posY - spacing)

        if slf:GetTall() == posY then
            return
        end

        slf:SetTall(posY)

        -- the grid is wrapped by the form item and the form, both size themselves to their
        -- children and have to be updated right away, otherwise they keep the old height
        local parentPanel = slf:GetParent()

        for _ = 1, 2 do
            if not IsValid(parentPanel) then
                return
            end

            parentPanel:InvalidateLayout(true)
            parentPanel = parentPanel:GetParent()
        end

        -- the canvas of the scroll panel updates the scroll bar
        if IsValid(parentPanel) then
            parentPanel:InvalidateLayout()
        end
    end

    return grid
end

---
-- Returns the teams of the given roles in the order they should be shown. The innocent and
-- the traitor team come first, the other teams are sorted by their name.
-- @param table visibleRoles The roles that are shown
-- @return table The ordered team names
-- @realm client
local function GetOrderedTeams(visibleRoles)
    local teamOrder = {}
    local teamSeen = {}

    for i = 1, #visibleRoles do
        local team = visibleRoles[i].defaultTeam

        if team and not teamSeen[team] then
            teamSeen[team] = true
            teamOrder[#teamOrder + 1] = team
        end
    end

    local function GetPriority(team)
        if team == TEAM_INNOCENT then
            return 1
        elseif team == TEAM_TRAITOR then
            return 2
        elseif team == TEAM_NONE then
            return 4
        end

        return 3
    end

    table.sort(teamOrder, function(a, b)
        local priorityA, priorityB = GetPriority(a), GetPriority(b)

        if priorityA ~= priorityB then
            return priorityA < priorityB
        end

        return TryT(a) < TryT(b)
    end)

    return teamOrder
end

function CLGAMEMODESUBMENU:Populate(parent)
    -- the header with the search bar and the team filter
    local form = vgui.CreateTTT2Form(parent, "submenu_guide_roles_title")

    local helpBox = form:MakeHelp({
        label = "guide_roles_help",
    })

    local filterRow = vgui.Create("DPanelTTT2", form)
    filterRow:SetTall(heightFilterRow)

    local searchBar = vgui.Create("DSearchBarTTT2", filterRow)
    searchBar:SetPlaceholderText("searchbar_roles_placeholder")
    searchBar:SetCurrentPlaceholderText("searchbar_roles_placeholder")
    searchBar:SetUpdateOnType(true)

    -- the help menu frame does not take keyboard input by default, it is enabled while
    -- the search bar is focused, like it is done for the search bar of the submenu list
    local function SetFrameKeyboardInputEnabled(enabled)
        local frame = searchBar

        while IsValid(frame:GetParent()) and frame:GetParent() ~= vgui.GetWorldPanel() do
            frame = frame:GetParent()
        end

        frame:SetKeyboardInputEnabled(enabled)
    end

    searchBar.OnGetFocus = function()
        SetFrameKeyboardInputEnabled(true)
    end

    searchBar.OnLoseFocus = function()
        SetFrameKeyboardInputEnabled(false)
    end

    local teamFilter = vgui.Create("DComboBoxTTT2", filterRow)
    teamFilter:SetSortItems(false)

    filterRow.PerformLayout = function(slf, w, h)
        local widthSearchBar = w - widthTeamFilter - spacing

        searchBar:SetPos(0, 0)
        searchBar:SetSize(widthSearchBar, h)

        teamFilter:SetPos(widthSearchBar + spacing, 0)
        teamFilter:SetSize(widthTeamFilter, h)
    end

    form:AddItem(filterRow)

    local state = {
        visibleRoles = {},
        roleInfos = {},
        teamOrder = {},
        sections = {},
        filterTeam = nil,
        selectedRoleIndex = nil,
        detail = nil,
    }

    local function CloseDetail()
        local detail = state.detail

        state.detail = nil

        if not IsValid(detail) then
            return
        end

        if IsValid(detail.card) then
            detail.card:SetSelected(false)
        end

        local grid = detail:GetParent()

        detail:SetVisible(false)
        detail:Remove()

        if IsValid(grid) then
            grid.detail = nil
            grid:InvalidateLayout()
        end
    end

    -- makes sure the selected role card and as much as possible of its details are visible
    local function ScrollToDetail(detail)
        if not IsValid(detail) or not IsValid(detail.card) then
            return
        end

        local canvas = parent:GetCanvas()
        local _, posCard = canvas:GetChildPosition(detail.card)
        local _, posDetail = canvas:GetChildPosition(detail)

        local vBar = parent:GetVBar()
        local scroll = vBar:GetScroll()
        local heightView = parent:GetTall()
        local bottomDetail = posDetail + detail:GetTall()

        if posCard < scroll then
            vBar:AnimateTo(posCard, 0.3, 0, 0.5)
        elseif bottomDetail > scroll + heightView then
            vBar:AnimateTo(math.min(posCard, bottomDetail - heightView), 0.3, 0, 0.5)
        end
    end

    local function OpenDetail(card, scrollToDetail)
        CloseDetail()

        local grid = card:GetParent()
        local roleIndex = card.roleData.index

        state.selectedRoleIndex = roleIndex

        local detail = CreateRoleDetail(grid, card, state.roleInfos[roleIndex], function()
            state.selectedRoleIndex = nil

            CloseDetail()
        end)

        state.detail = detail
        grid.detail = detail

        card:SetSelected(true)
        grid:InvalidateLayout()

        if not scrollToDetail then
            return
        end

        -- wait for the layout to be updated before scrolling
        timer.Simple(0, function()
            if IsValid(parent) then
                ScrollToDetail(detail)
            end
        end)
    end

    local function MatchesFilter(roleData, search)
        if state.filterTeam and roleData.defaultTeam ~= state.filterTeam then
            return false
        end

        if search == "" then
            return true
        end

        return string.find(string.lower(TryT(roleData.name)), search, 1, true) ~= nil
    end

    local function CreateRoleCard(grid, roleData)
        local team = roleData.defaultTeam

        local card = vgui.Create("DRoleCardTTT2", grid)
        card:SetText(roleData.name)
        card:SetIcon(roleData.iconMaterial)
        card:SetColor(roleData.color)
        card:SetTeamText(team)
        card:SetTeamColor(GetTeamColor(team, roleData))

        local tags = {}

        if roleData.builtin then
            tags[#tags + 1] = "guide_role_tag_builtin"
        end

        if HasShop(roleData) then
            tags[#tags + 1] = "guide_role_tag_shop"
        end

        card:SetTags(tags)

        card.roleData = roleData

        card.DoClick = function(slf)
            if slf:IsSelected() then
                state.selectedRoleIndex = nil

                CloseDetail()

                return
            end

            OpenDetail(slf, true)
        end

        return card
    end

    -- the team sections are rebuilt whenever the filter changes
    local function BuildSections()
        CloseDetail()

        for i = 1, #state.sections do
            local section = state.sections[i]

            if IsValid(section) then
                section:SetVisible(false)
                section:Remove()
            end
        end

        state.sections = {}

        local search = string.lower(string.Trim(searchBar:GetValue() or ""))
        local selectedCard

        for i = 1, #state.teamOrder do
            local team = state.teamOrder[i]
            local teamRoles = {}

            for k = 1, #state.visibleRoles do
                local roleData = state.visibleRoles[k]

                if roleData.defaultTeam == team and MatchesFilter(roleData, search) then
                    teamRoles[#teamRoles + 1] = roleData
                end
            end

            if #teamRoles == 0 then
                continue
            end

            table.sort(teamRoles, function(a, b)
                return TryT(a.name) < TryT(b.name)
            end)

            local section = vgui.CreateTTT2Form(parent, team)
            local grid = CreateCardGrid(section)

            for k = 1, #teamRoles do
                local card = CreateRoleCard(grid, teamRoles[k])

                grid.cards[k] = card

                if teamRoles[k].index == state.selectedRoleIndex then
                    selectedCard = card
                end
            end

            section:AddItem(grid)

            state.sections[#state.sections + 1] = section
        end

        helpBox:SetText(#state.sections > 0 and "guide_roles_help" or "guide_roles_none_found")
        helpBox:InvalidateLayout()

        -- keep the details of the selected role open while it matches the filter
        if selectedCard then
            OpenDetail(selectedCard, false)
        end
    end

    searchBar.OnValueChange = function()
        BuildSections()
    end

    GetVisibleRoles(function(visibleRoles, roleInfos)
        -- the menu can be closed while the role settings are fetched from the server
        if not IsValid(parent) or not IsValid(teamFilter) then
            return
        end

        state.visibleRoles = visibleRoles
        state.roleInfos = roleInfos
        state.teamOrder = GetOrderedTeams(visibleRoles)

        -- an empty value is used for all teams, as it can not collide with a team name
        teamFilter:AddChoice(TryT("guide_roles_all_teams"), "", true)

        for i = 1, #state.teamOrder do
            local team = state.teamOrder[i]

            teamFilter:AddChoice(TryT(team), team)
        end

        teamFilter.OnSelect = function(_, _, value)
            state.filterTeam = value ~= "" and value or nil

            BuildSections()
        end

        BuildSections()
    end)
end
