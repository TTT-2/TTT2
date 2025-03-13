---
-- @class PANEL
-- @section TTT2:DSubmenuList

local PANEL = {}

-- Define sizes
local heightNavButton = 50

---
-- @ignore
function PANEL:Init()
    DBase("TTT2:DPanel").Init(self)

    -- Make navArea scrollable
    self.navAreaScroll = vgui.Create("DScrollPanelTTT2", self)
    self.navAreaScroll:SetVerticalScrollbarEnabled(true) --TODO return self
    self.navAreaScroll:Dock(BOTTOM):On("VScroll", function(slf, scrollOffset)
        -- origScrollOnVScroll(pnl, scrollOffset) --TODO

        if self.searchTrackerPanel then
            local x, y = self.searchTrackerPanel:GetPos()
            y = math.max(y + scrollOffset, 0)
            self.searchBar:SetPos(x, y)
        end
    end)

    -- Split nav area into a grid layout
    self.navAreaScrollGrid = vgui.Create("DIconLayout", self.navAreaScroll) --TODO method chaining
    self.navAreaScrollGrid:Dock(FILL)

    -- By default there is no search tracker panel. It is used to differentiate between panels
    -- that should be fixed on top and panels that are searched.
    self.searchTrackerPanel = nil

    -- Get the frame to be able to enable keyboardinput on searchbar focus
    self.frame = util.GetHighestPanelParent(self)
end

---
-- This function sets the size of the search bar.
-- @param number width The width of the search bar
-- @param number height The height of the search bar
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetSearchBarSize(width, height)
    if not self.searchBar then
        return self
    end

    self.searchBar:SetSize(width, height)

    if self.searchTrackerPanel then
        self.searchTrackerPanel:SetSize(width, height)
    end

    return self
end

---
-- Sets the search bar's placeholder text.
-- @param string placeholder The placeholder text.
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetSearchBarPlaceholderText(placeholder)
    if not placeholder or not self.searchBar then
        return self
    end

    self.searchBar:SetPlaceholderText(placeholder)

    if self.searchBar:GetValue() == "" then
        self.searchBar:SetCurrentPlaceholderText(placeholder)
    end

    return self
end

---
-- This function enables or disables the search bar.
-- @param boolean active The new state, set to true to enable the search bar
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:EnableSearchBar(active)
    if not active then
        if self.searchBar then
            self.searchBar:Clear()
            self.searchBar = nil
        end

        return self
    end

    -- Add searchbar on top
    self.searchBar = vgui.Create("DSearchBarTTT2", self)
        :SetUpdateOnType(true)
        :SetHeightMult(1)
        :SetPos(0, heightNavHeader)
        :On("ValueChange", function(slf, searchText)
            self:ResetSubmenuList()
            self:ExtendSubmenuList(self.basemenuClass:GetVisibleNonSearchedSubmenus())
            self:AddSearchTracker()

            local index = self.navAreaScrollGrid:ChildCount()

            self:ExtendSubmenuList(self.basemenuClass:GetMatchingSubmenus(searchText))
            self:SelectFirst(index)
            self:InvalidateLayout(true)
        end)
        :On("GetFocus", function(slf)
            self.frame:SetKeyboardInputEnabled(true)
        end)
        :On("LoseFocus", function(slf)
            self.frame:SetKeyboardInputEnabled(false)
        end)

    return self
end

---
-- This function adds a button for a submenu in the list.
-- @param menuClass submenuClass
-- @return panel
-- @realm client
function PANEL:AddSubmenuButton(submenuClass)
    local settingsButton = self.navAreaScrollGrid:Add("TTT2:DSubmenuButton")
    settingsButton
        :SetText(submenuClass.title or submenuClass.type)
        :SetIcon(submenuClass.icon, not submenuClass.iconFullSize, not submenuClass.iconFullSize)
        :SetIconBadge(submenuClass.iconBadge)
        :SetIconBadgeSize(submenuClass.iconBadgeSize)
        :SetTooltip(submenuClass.tooltip)
        :On("LeftClick", function(slf)
            HELPSCRN:SetupContentArea(self.contentArea, submenuClass)
            HELPSCRN:BuildContentArea()

            -- handle the set/unset of active buttons for the draw process
            if self.lastActive and isfunction(self.lastActive.SetActive) then
                self.lastActive:SetToggle(false)
            end

            slf:SetToggle(true)

            self.lastActive = slf
        end)

    return settingsButton
end

---
-- Resets the submenu list, clearing both the nav buttons and associated content area.
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:ResetSubmenuList()
    self.navAreaScrollGrid:Clear()
    self.contentArea:Clear()
    self.searchTrackerPanel = nil

    return self
end

---
-- This function generates the list of the submenus which are shown in the given contentArea.
-- @param menuClasses submenuClasses
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:GenerateSubmenuList(submenuClasses)
    self:ResetSubmenuList()
    self:ExtendSubmenuList(submenuClasses)
    self:SelectFirst()

    -- Last refresh sizes depending on number of submenus added
    self:InvalidateLayout(true)

    return self
end

---
-- Acts like PANEL:GenerateSubmenuList, but does not clear content area or scroll grid.
-- @note This function does NOT invalidate layout.
-- @param menuClasses submenuClasses A table of the submenu classes
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:ExtendSubmenuList(submenuClasses)
    for i = 1, #submenuClasses do
        self:AddSubmenuButton(submenuClasses[i])
    end

    return self
end

---
-- Selects the first submenu added to this list.
-- @param index The index to select the first item at or after. This index is 0-based
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SelectFirst(index)
    if not index then
        index = 0
    end

    for i = index, self.navAreaScrollGrid:ChildCount() do
        local child = self.navAreaScrollGrid:GetChild(i)

        if child and isfunction(child.DoClick) then
            child:DoClick()

            return self
        end
    end

    -- If a non-zero index was specified, we don't want to present the unpopulated message,
    -- because we're doing a search. In that case, we want to display a message that there
    -- were no results.
    if index ~= 0 then
        local msgLabel = vgui.Create("TTT2:DLabel", self.contentArea)
            :SetText("label_menu_search_no_items")
            :SetFont("DermaTTT2Title")
            :Dock(FILL)

        local dummyPnl = vgui.Create("TTT2:DPanel", self.contentArea):Dock(LEFT)

        return self
    end

    -- make sure the last active gets cleared in this case
    if self.lastActive and isfunction(self.lastActive.SetActive) then
        self.lastActive:SetActive(false)
    end

    -- no content, fill the content area appropriately
    vgui.Create("TTT2:DLabel", self.contentArea)
        :SetText("label_menu_not_populated")
        :SetSize(self.contentArea:GetSize() - 40, 50)
        :SetFont("DermaTTT2Title")
        :SetPos(20, 0)

    return self
end

---
-- Adds the search tracker element to the scroll view. Elements added after the search
-- tracker will be searched for.
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:AddSearchTracker()
    if self.searchTrackerPanel then
        ErrorNoHaltWithStack(
            "ERROR: TTT2:DSubmenuList:AddSearchTracker() called multiple times without resetting!"
        )

        return self
    end

    if not self.searchBar then
        self:EnableSearchBar(true)
    end

    self.searchTrackerPanel = self.navAreaScrollGrid:Add("Panel") -- todo: TTT2:DPanel?

    self.searchTrackerPanel.PerformLayout = function(panel)
        panel:SetSize(self.searchBar:GetSize())
    end

    return self
end

---
-- This function sets the submenus which are shown in the given contentArea.
-- @param menuClasses basemenuClass The base menu class
-- @param panel contentArea The contentArea panel
-- @return Panel Returns the panel itself
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

    return self
end

---
-- Sets thew spacing between and around the sub menu items.
-- @param number spacing The spacing
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetSpacing(spacing)
    self.navAreaScrollGrid:SetSpaceY(spacing)
    self.navAreaScrollGrid:DockPadding(0, spacing, 0, spacing)

    return self
end

---
-- @ignore
function PANEL:OnRebuildLayout(w, h)
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
-- Clears the submenu list.
-- @return boolean Returns true if clearing was a success, false if failed
-- @realm client
function PANEL:Clear()
    return tobool(self.searchBar:Clear() and self.navAreaScroll:Clear())
end

derma.DefineControl(
    "TTT2:DSubmenuList",
    "A very specific panel that handles the submenu list",
    PANEL,
    "TTT2:DPanel"
)
