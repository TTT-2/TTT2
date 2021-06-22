---
-- @class PANEL
-- @section DSubmenuListTTT2

local PANEL = {}

-- define sizes
local heightNavHeader = 15
local widthNavContent, heightNavContent = 299, 685
local heightNavButton = 50

local function SetSubmenuListHeight(slf, yPos, heightList)
	slf.navAreaScroll:SetPos(0, yPos)
	slf.navAreaScroll:SetSize(widthNavContent, heightList)
end

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
	self.navAreaScroll = navAreaScroll
	SetSubmenuListHeight(self, heightNavHeader, heightNavContent)

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

function PANEL:EnableSearchBar(active)
	local heightShift = active and heightNavButton or 0

	SetSubmenuListHeight(self, heightNavHeader + heightShift, heightNavContent - heightShift)

	if not active then
		if self.searchBar then self.searchBar:Clear() end
		return
	end

	-- ADD SEARBACH ON TOP	
	--self.searchBar = vgui.Create("DSearchBarTTT2", self)
	local searchBar = vgui.Create("DTextEntry", self)
	searchBar:SetPos(0, heightNavHeader )
	searchBar:SetSize(widthNavContent, heightNavButton)
	searchBar:SetUpdateOnType(true)
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
	settingsButton:SetSize(widthNavContent, heightNavButton)
	settingsButton:SetTitle(submenuClass.title or submenuClass.type)
	settingsButton:SetIcon(submenuClass.icon, submenuClass.iconFullSize)

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

			self:AddSubmenuButton(submenuClass)
		end

		HELPSCRN:SetupContentArea(self.contentArea, submenuClasses[1])
		HELPSCRN:BuildContentArea()

		-- handle the set of active buttons for the draw process
		self.navAreaScrollGrid:GetChild(0):SetActive()

		self.lastActive = self.navAreaScrollGrid:GetChild(0)
	end

	self.navAreaScrollGrid:InvalidateLayout(true)
	self.navAreaScroll:InvalidateLayout(true)
end

function PANEL:SetSubmenuClasses(submenuClasses, contentArea)
	self.submenuClasses = submenuClasses
	self.contentArea = contentArea

	self:GenerateSubmenuList(submenuClasses)
end

function PANEL:SetPadding(padding)
	self:InvalidateParent(true)
	widthNavContent, heightNavContent = self:GetSize()
	self.padding = padding
	self.navAreaScrollGrid:SetSpaceY(padding)
end

function PANEL:GetPadding()
	return self.padding
end

---
-- @ignore
function PANEL:PerformLayout()
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	self.searchBar:Clear()
	self.navAreaScroll:Clear()
end

derma.DefineControl("DSubmenuListTTT2", "", PANEL, "DPanelTTT2")