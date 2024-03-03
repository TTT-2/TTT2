---
-- @class PANEL
-- @section DSubmenuListTTT2

local PANEL = {}

---
-- @accessor function
-- @realm client
AccessorFunc(PANEL, "searchFunction", "SearchFunction")

-- Define sizes
local heightNavHeader = 10
local heightNavButton = 50

---
-- @ignore
function PANEL:Init()
    -- Make navArea scrollable
    local navAreaScroll = vgui.Create("DScrollPanelTTT2", self)
    navAreaScroll:SetVerticalScrollbarEnabled(true)
    navAreaScroll:Dock(BOTTOM)
    self.navAreaScroll = navAreaScroll

    -- Split nav area into a grid layout
    local navAreaScrollGrid = vgui.Create("DIconLayout", self.navAreaScroll)
    navAreaScrollGrid:Dock(FILL)
    self.navAreaScrollGrid = navAreaScrollGrid

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
end

---
-- This function enables or disables the searchBar.
-- @param boolean active
-- @realm client
function PANEL:EnableSearchBar(active)
    if not active then
        if self.searchBar then
            self.searchBar:Clear()
        end

        return
    end

    -- Add searchbar on top
    local searchBar = vgui.Create("DSearchBarTTT2", self)
    searchBar:SetUpdateOnType(true)
    searchBar:SetPos(0, heightNavHeader)
    searchBar:SetHeightMult(1)

    searchBar.OnValueChange = function(slf, searchText)
        self:GenerateSubmenuList(self.basemenuClass:GetMatchingSubmenus(searchText))
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
    settingsButton:SetTooltip(submenuClass.tooltip)

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
-- This function generates the list of the submenus which are shown in the given contentArea.
-- @param menuClasses submenuClasses
-- @realm client
function PANEL:GenerateSubmenuList(submenuClasses)
    self.navAreaScrollGrid:Clear()
    self.contentArea:Clear()

    if #submenuClasses == 0 then
        local labelNoContent = vgui.Create("DLabelTTT2", self.contentArea)
        local widthContent = self.contentArea:GetSize()

        labelNoContent:SetText("label_menu_not_populated")
        labelNoContent:SetSize(widthContent - 40, 50)
        labelNoContent:SetFont("DermaTTT2Title")
        labelNoContent:SetPos(20, 0)
    else
        for i = 1, #submenuClasses do
            local submenuClass = submenuClasses[i]
            local settingsButton = self:AddSubmenuButton(submenuClass)

            -- Handle the set of active buttons for the draw process
            if i == 1 then
                settingsButton:SetActive()
                self.lastActive = settingsButton
            end
        end

        HELPSCRN:SetupContentArea(self.contentArea, submenuClasses[1])
        HELPSCRN:BuildContentArea()
    end

    -- Last refresh sizes depending on number of submenus added
    self:InvalidateLayout(true)
end

---
-- This function sets the submenus which are shown in the given contentArea.
-- @param menuClasses submenuClasses
-- @param panel contenArea
-- @realm client
function PANEL:SetBasemenuClass(basemenuClass, contentArea)
    self.basemenuClass = basemenuClass
    self.contentArea = contentArea

    self:GenerateSubmenuList(basemenuClass:GetVisibleSubmenus())
end

---
-- @param number padding
-- @realm client
function PANEL:SetPadding(padding)
    self.padding = padding

    self.navAreaScrollGrid:SetSpaceY(padding)
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
    local heightShift = heightNavHeader + (self.searchBar and heightNavButton + self.padding or 0)

    self:SetSearchBarSize(widthNavContent, heightNavButton)
    self.navAreaScroll:SetSize(widthNavContent, heightNavContent - heightShift)

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
