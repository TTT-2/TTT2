---
-- @class PANEL
-- @section DSubmenuListTTT2

local PANEL = {}

-- define sizes
local heightNavHeader = 10
local heightNavButton = 50

local function getHighestParent(slf)
	local parent = slf
	local checkParent = slf:GetParent()

	while ispanel(checkParent) do
		parent = checkParent
		checkParent = parent:GetParent()
	end

	return parent
end

---
-- @ignore
function PANEL:Init()
	-- MAKE NAV AREA SCROLLABLE
	local navAreaScroll = vgui.Create("DScrollPanelTTT2", self)
	navAreaScroll:SetVerticalScrollbarEnabled(true)
	navAreaScroll:Dock(BOTTOM)
	self.navAreaScroll = navAreaScroll

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local navAreaScrollGrid = vgui.Create("DIconLayout", self.navAreaScroll)
	navAreaScrollGrid:Dock(FILL)
	self.navAreaScrollGrid = navAreaScrollGrid

	self.frame = getHighestParent(self)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)
end

function PANEL:SetSearchBarSize(widthBar, heightBar)
	if not self.searchBar then return end

	self.searchBar:SetSize(widthBar, heightBar)
end

function PANEL:EnableSearchBar(active)
	if not active then
		if self.searchBar then self.searchBar:Clear() end
		return
	end

	-- ADD SEARBACH ON TOP	
	--self.searchBar = vgui.Create("DSearchBarTTT2", self)
	local searchBar = vgui.Create("DTextEntry", self)
	searchBar:SetUpdateOnType(true)
	searchBar:SetPos(0, heightNavHeader)
	searchBar.OnValueChange = function(slf,text)
		local submenuClasses = self.submenuClasses or {}
		local filteredSubmenuClasses = {}
		local filterFunction = self:GetSearchFunction()

		local counter = 0
		for i = 1, #submenuClasses do
			local submenuClass = submenuClasses[i]

			if text == "" or filterFunction(submenuClass, text) then
				counter = counter + 1
				filteredSubmenuClasses[counter] = submenuClass
			end
		end

		self:GenerateSubmenuList(filteredSubmenuClasses)
	end
	searchBar.OnGetFocus = function(slf)
		self.frame:SetKeyboardInputEnabled(true)
	end
	searchBar.OnLoseFocus = function(slf)
		self.frame:SetKeyboardInputEnabled(false)
	end

	self.searchBar = searchBar
end

function PANEL:SetSearchFunction(searchFunction)
	self.searchFunction = searchFunction
end

function PANEL:GetSearchFunction()
	return self.searchFunction
end

function PANEL:AddSubmenuButton(submenuClass)
	local settingsButton = self.navAreaScrollGrid:Add("DSubmenuButtonTTT2")
	settingsButton:SetTitle(submenuClass.title or submenuClass.type)
	settingsButton:SetIcon(submenuClass.icon, submenuClass.iconFullSize)
	settingsButton.PerformLayout = function(panel)
		local width = panel:GetParent():GetSize()
		panel:SetSize(width, heightNavButton)
	end

	settingsButton.DoClick = function(slf)
		HELPSCRN:SetupContentArea(self.contentArea, submenuClass)
		HELPSCRN:BuildContentArea()

		-- handle the set/unset of active buttons for the draw process
		if self.lastActive and self.lastActive.SetActive then self.lastActive:SetActive(false) end
		slf:SetActive()

		self.lastActive = slf
	end

	return settingsButton
end

function PANEL:GenerateSubmenuList(submenuClasses)
	self.navAreaScrollGrid:Clear()
	self.contentArea:Clear()

	if #submenuClasses == 0 then
		local labelNoContent = vgui.Create("DLabelTTT2", self.contentArea)
		labelNoContent:SetText("label_menu_not_populated")
		local widthContent = self.contentArea:GetSize()
		labelNoContent:SetSize(widthContent - 40, 50)
		labelNoContent:SetFont("DermaTTT2Title")
		labelNoContent:SetPos(20, 0)
	else
		for i = 1, #submenuClasses do
			local submenuClass = submenuClasses[i]

			local settingsButton = self:AddSubmenuButton(submenuClass)

			-- handle the set of active buttons for the draw process
			if i == 1 then
				settingsButton:SetActive()
				self.lastActive = settingsButton
			end
		end

		HELPSCRN:SetupContentArea(self.contentArea, submenuClasses[1])
		HELPSCRN:BuildContentArea()
	end

	self:InvalidateLayout(true)
end

function PANEL:SetSubmenuClasses(submenuClasses, contentArea)
	self.submenuClasses = submenuClasses
	self.contentArea = contentArea

	self:GenerateSubmenuList(submenuClasses)
end

function PANEL:SetPadding(padding)
	self.padding = padding
	self.navAreaScrollGrid:SetSpaceY(padding)
end

function PANEL:GetPadding()
	return self.padding
end

---
-- @ignore
function PANEL:PerformLayout()
	self:InvalidateParent(true)

	local widthNavContent, heightNavContent = self:GetSize()
	local heightShift = heightNavHeader + (self.searchBar and heightNavButton + self.padding or 0)

	self:SetSearchBarSize(widthNavContent, heightNavButton)
	self.navAreaScroll:SetSize(widthNavContent, heightNavContent - heightShift)

	self.navAreaScrollGrid:InvalidateChildren(true)
	self.navAreaScroll:InvalidateLayout(true)
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	self.searchBar:Clear()
	self.navAreaScroll:Clear()
end

derma.DefineControl("DSubmenuListTTT2", "", PANEL, "DPanelTTT2")