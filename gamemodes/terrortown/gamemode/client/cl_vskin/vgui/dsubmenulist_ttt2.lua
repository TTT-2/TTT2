---
-- @class PANEL
-- @section DSubmenuListTTT2

local PANEL = {}

-- define sizes
local heightNavHeader = 15
local widthNavContent, heightNavContent = 299, 685
local widthNavButton, heightNavButton = 299, 50

local function SetSubmenuListHeight(slf, yPos, heightList)
	slf.navAreaContent:SetPos(0, yPos)
	slf.navAreaContent:SetSize(widthNavContent, heightList)
end

local function getHighestParent(slf)
	local parent = slf
	local checkParent = slf

	for i = 1, 100 do
		checkParent = parent:GetParent()

		if not checkParent then return parent end
		parent = checkParent
	end

	return parent
end

---
-- @ignore
function PANEL:Init()
	-- CREATE NAVIGATIONSAREA
	self.navAreaContent = vgui.Create("DPanel", self:GetParent())
	SetSubmenuListHeight(self, heightNavHeader, heightNavContent - vskin.GetHeaderHeight() - vskin.GetBorderSize())

	-- MAKE NAV AREA SCROLLABLE
	local navAreaScroll = vgui.Create("DScrollPanelTTT2", self.navAreaContent)
	navAreaScroll:SetVerticalScrollbarEnabled(true)
	navAreaScroll:Dock(FILL)
	self.navAreaScroll = navAreaScroll

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local navAreaScrollGrid = vgui.Create("DIconLayout", self.navAreaScroll)
	navAreaScrollGrid:Dock(FILL)
	self.navAreaScrollGrid = navAreaScrollGrid

	self.mainFrame = getHighestParent(self)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)
end

function PANEL:EnableSearchBar(active)
	local heightShift = active and heightNavButton or 0

	SetSubmenuListHeight(self, heightNavHeader + heightShift, heightNavContent - heightShift - vskin.GetHeaderHeight() - vskin.GetBorderSize())

	if not active then
		if self.searchBar then self.searchBar:Clear() end
		return
	end

	-- ADD SEARBACH ON TOP	
	--self.searchBar = vgui.Create("DSearchBarTTT2", self)
	local searchBar = vgui.Create("DPanel", self:GetParent())
	searchBar:SetPos(0, heightNavHeader )
	searchBar:SetSize(widthNavContent, heightNavButton)
	self.searchBar = searchBar

	local searchBarText = vgui.Create("DTextEntry", searchBar)
	searchBarText:SetUpdateOnType(true)
	searchBarText:Dock(FILL)
	searchBarText.OnValueChange = function(slf,text)
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
	searchBarText.OnGetFocus = function(slf)
		self.mainFrame:SetKeyboardInputEnabled(true)
	end
	searchBarText.OnLoseFocus = function(slf)
		self.mainFrame:SetKeyboardInputEnabled(false)
	end

	self.searchBarText = searchBarText
end

function PANEL:SetSearchFunction(searchFunction)
	self.searchFunction = searchFunction
end

function PANEL:GetSearchFunction()
	return self.searchFunction
end

function PANEL:AddSubmenuButton(submenuClass)
	local settingsButton = self.navAreaScrollGrid:Add("DSubmenuButtonTTT2")
	settingsButton:SetSize(widthNavButton, heightNavButton)
	settingsButton:SetTitle(submenuClass.title or submenuClass.type)
	settingsButton:SetIcon(submenuClass.icon, submenuClass.iconFullSize)

	settingsButton.DoClick = function(slf)
		HELPSCRN:SetupContentArea(self.contentArea, submenuClass)
		HELPSCRN:BuildContentArea()

		-- handle the set/unset of active buttons for the draw process
		if self.lastActive and self.lastActive.SetActive then self.lastActive:SetActive(false) end
		slf:SetActive()

		self.lastActive = slf
		print("Button Clicked.")
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
		print("\nChild Active.")

		self.lastActive = self.navAreaScrollGrid:GetChild(0)
	end
end

function PANEL:SetSubmenuClasses(submenuClasses, contentArea)
	self.submenuClasses = submenuClasses
	self.contentArea = contentArea

	self:GenerateSubmenuList(submenuClasses)
end

function PANEL:SetMainFrame(frame)
	self.mainFrame = frame
end

function PANEL:SetPadding(padding)
	self.padding = padding
	self.navAreaScrollGrid:SetSpaceY(padding)
end

function PANEL:GetPadding()
	return self.padding
end

---
-- @realm client
function PANEL:Rebuild()
	return
end

---
-- @ignore
function PANEL:PerformLayoutInternal()
	self:Rebuild()
end

---
-- @ignore
function PANEL:PerformLayout()
	self:PerformLayoutInternal()
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	return self.searchBar:Clear() and self.navAreaContent:Clear()
end

derma.DefineControl("DSubmenuListTTT2", "", PANEL, "DPanelTTT2")