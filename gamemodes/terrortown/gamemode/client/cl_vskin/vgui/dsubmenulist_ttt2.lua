---
-- @class PANEL
-- @section DSubmenuListTTT2

local PANEL = {}

-- Define sizes
local heightNavButton = 50

---
-- @ignore
function PANEL:Init()
    -- Make navArea scrollable
    local navAreaScroll = vgui.Create("DScrollPanelTTT2", self)
    navAreaScroll:SetVerticalScrollbarEnabled(true)
    navAreaScroll:Dock(BOTTOM)
    self.navAreaScroll = navAreaScroll

    local origScrollOnVScroll = navAreaScroll.OnVScroll
    navAreaScroll.OnVScroll = function(pnl, scrollOffset)
        origScrollOnVScroll(pnl, scrollOffset)
        if self.scrollTracker then
            local x, y = self.scrollTracker:GetPos()
            y = math.max(y + scrollOffset, 0)
            self.searchBar:SetPos(x, y)
        end
    end

    -- Split nav area into a grid layout
    local navAreaScrollGrid = vgui.Create("DIconLayout", self.navAreaScroll)
    navAreaScrollGrid:Dock(FILL)
    self.navAreaScrollGrid = navAreaScrollGrid

    self.scrollTracker = nil

    -- Get the frame to be able to enable keyboardinput on searchbar focus
    self.frame = util.getHighestPanelParent(self)

    -- This turns off the engine drawing
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)
    self:SetPaintBackground(false)
end

---
-- This function sets the size of the searchBar.
-- @param number widthBar
-- @param number heightBar
-- @realm client
function PANEL:SetSearchBarSize(widthBar, heightBar)
    if not self.searchBar then
        return
    end

    self.searchBar:SetSize(widthBar, heightBar)
    if self.scrollTracker then
        self.scrollTracker:SetSize(widthBar, heightBar)
    end
end

---
-- Sets the search bar's placeholder text.
-- @param string placeholder The placeholder text.
-- @realm client
function PANEL:SetSearchBarPlaceholderText(placeholder)
    if not self.searchBar then
        return
    end

    self.searchBar:SetPlaceholderText(placeholder)
    if self.searchBar:GetValue() == "" then
        self.searchBar:SetCurrentPlaceholderText(placeholder)
    end
end

---
-- This function enables or disables the searchBar.
-- @param boolean active
-- @realm client
function PANEL:EnableSearchBar(active)
    if not active then
        if self.searchBar then
            self.searchBar:Clear()
            self.searchBar = nil
        end

        return
    end

    -- Add searchbar on top
    local searchBar = vgui.Create("DSearchBarTTT2", self)
    searchBar:SetUpdateOnType(true)
    searchBar:SetHeightMult(1)
    searchBar:SetPos(0, heightNavHeader)

    searchBar.OnValueChange = function(slf, searchText)
        self:ResetSubmenuList()
        self:ExtendSubmenuList(self.basemenuClass:GetVisibleNonSearchedSubmenus())
        self:AddSearchTracker()
        local index = self.navAreaScrollGrid:ChildCount()
        self:ExtendSubmenuList(self.basemenuClass:GetMatchingSubmenus(searchText))
        self:SelectFirst(index)
        self:InvalidateLayout(true)
    end

    searchBar.OnGetFocus = function(slf)
        self.frame:SetKeyboardInputEnabled(true)
    end

    searchBar.OnLoseFocus = function(slf)
        self.frame:SetKeyboardInputEnabled(false)
    end

    self.searchBar = searchBar
end

---
-- This function adds a button for a submenu in the list.
-- @param menuClass submenuClass
-- @return panel
-- @realm client
function PANEL:AddSubmenuButton(submenuClass)
    local settingsButton = self.navAreaScrollGrid:Add("DSubmenuButtonTTT2")

    settingsButton:SetTitle(submenuClass.title or submenuClass.type)
    settingsButton:SetIcon(submenuClass.icon, submenuClass.iconFullSize)
    settingsButton:SetIconBadge(submenuClass.iconBadge)
    settingsButton:SetIconBadgeSize(submenuClass.iconBadgeSize)

    if submenuClass.tooltip then
        settingsButton:SetTooltip(submenuClass.tooltip)
    end

    settingsButton.PerformLayout = function(panel)
        panel:SetSize(panel:GetParent():GetWide(), heightNavButton)
    end

    settingsButton.DoClick = function(slf)
        HELPSCRN:SetupContentArea(self.contentArea, submenuClass)
        HELPSCRN:BuildContentArea()

        -- handle the set/unset of active buttons for the draw process
        if self.lastActive and self.lastActive.SetActive then
            self.lastActive:SetActive(false)
        end

        slf:SetActive()
        self.lastActive = slf
    end

    return settingsButton
end

---
-- Resets the submenu list, clearing both the nav buttons and associated content area.
-- @realm client
function PANEL:ResetSubmenuList()
    self.navAreaScrollGrid:Clear()
    self.contentArea:Clear()
    self.scrollTracker = nil
end

---
-- This function generates the list of the submenus which are shown in the given contentArea.
-- @param menuClasses submenuClasses
-- @realm client
function PANEL:GenerateSubmenuList(submenuClasses)
    self:ResetSubmenuList()
    self:ExtendSubmenuList(submenuClasses)
    self:SelectFirst()

    -- Last refresh sizes depending on number of submenus added
    self:InvalidateLayout(true)
end

---
-- Acts like PANEL:GenerateSubmenuList, but does not clear content area or scroll grid.
-- @note This function does NOT invalidate layout.
-- @param menuClasses submenuClasses
-- @realm client
function PANEL:ExtendSubmenuList(submenuClasses)
    for i = 1, #submenuClasses do
        local submenuClass = submenuClasses[i]
        self:AddSubmenuButton(submenuClass)
    end

    --self:InvalidateLayout(true)
end

---
-- Selects the first submenu added to this list.
-- @param index The index to select the first item at or after. This index is 0-based.
-- @realm client
function PANEL:SelectFirst(index)
    if not index then
        index = 0
    end

    for i = index, self.navAreaScrollGrid:ChildCount() do
        local child = self.navAreaScrollGrid:GetChild(i)
        if child and child.DoClick then
            child:DoClick()
            return
        end
    end

    -- If a non-zero index was specified, we don't want to present the unpopulated message, because we're doing a search.
    -- In that case, we want to display a message that there were no results.
    if index ~= 0 then
        local msgLabel = vgui.Create("DLabelTTT2", self.contentArea)
        msgLabel:SetText("label_menu_search_no_items")
        msgLabel:SetFont("DermaTTT2Title")
        msgLabel:Dock(FILL)

        local dummyPnl = vgui.Create("DPanel", self.contentArea)
        dummyPnl:Dock(LEFT)

        return
    end

    -- make sure the last active gets cleared in this case
    if self.lastActive and self.lastActive.SetActive then
        self.lastActive:SetActive(false)
    end

    -- no content, fill the content area appropriately
    local labelNoContent = vgui.Create("DLabelTTT2", self.contentArea)
    local widthContent = self.contentArea:GetSize()

    labelNoContent:SetText("label_menu_not_populated")
    labelNoContent:SetSize(widthContent - 40, 50)
    labelNoContent:SetFont("DermaTTT2Title")
    labelNoContent:SetPos(20, 0)
end

---
-- Adds the search tracker element to the scroll view. Elements added after the search tracker will be searched for.
-- @realm client
function PANEL:AddSearchTracker()
    if self.scrollTracker then
        ErrorNoHaltWithStack(
            "ERROR: DSubMenuListTTT2:AddSearchTracker() called multiple times without resetting!"
        )
        return
    end

    if not self.searchBar then
        self:EnableSearchBar(true)
    end
    local tracker = self.navAreaScrollGrid:Add("Panel")

    tracker.PerformLayout = function(panel)
        panel:SetSize(self.searchBar:GetSize())
    end

    self.scrollTracker = tracker
end

---
-- This function sets the submenus which are shown in the given contentArea.
-- @param menuClasses submenuClasses
-- @param panel contenArea
-- @realm client
function PANEL:SetBasemenuClass(basemenuClass, contentArea)
    self.basemenuClass = basemenuClass
    self.contentArea = contentArea

    self:ResetSubmenuList()
    self:ExtendSubmenuList(self.basemenuClass:GetVisibleNonSearchedSubmenus())
    if self.basemenuClass:HasSearchbar() then
        self:AddSearchTracker()
    end
    self:ExtendSubmenuList(self.basemenuClass:GetVisibleSubmenus())
    self:SelectFirst()
    self:InvalidateLayout(true)
end

---
-- @param number padding
-- @realm client
function PANEL:SetPadding(padding)
    self.padding = padding

    self.navAreaScrollGrid:SetSpaceY(padding)
    self.navAreaScrollGrid:DockPadding(0, padding, 0, padding)
end

---
-- @return number
-- @realm client
function PANEL:GetPadding()
    return self.padding
end

---
-- @ignore
function PANEL:PerformLayout()
    -- First invalidate Parent to get current correct docking size
    self:InvalidateParent(true)

    local widthNavContent, heightNavContent = self:GetSize()

    self.navAreaScroll:SetSize(widthNavContent, heightNavContent)
    self:SetSearchBarSize(self.navAreaScroll:InnerWidth(), heightNavButton)

    -- Last invalidate all buttons and then the scrolllist for correct size to contents
    self.navAreaScrollGrid:InvalidateChildren(true)
    self.navAreaScroll:InvalidateLayout(true)
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
    local cleared = self.searchBar:Clear()

    return tobool(cleared and self.navAreaScroll:Clear())
end

derma.DefineControl("DSubmenuListTTT2", "", PANEL, "DPanelTTT2")
