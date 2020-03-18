---
-- @author Mineotopia

HELP_DATA = {}

local HELP_DATA_OBJECT = {}

---
-- Binds data table to the @{HELP_DATA} object
-- @param table data The data table with all submenues
-- @return @{HELP_DATA} The object to be used in the hook
-- @internal
-- @realm client
function HELP_DATA:BindData(menuTbl)
	self.menuTbl = menuTbl or {}

	return self
end

---
-- Creates a new submenu in the main menu
-- @param string id The unique ID of the submenu
-- @return table A reference to the new table
-- @realm client
function HELP_DATA:RegisterSubMenu(id)
	if self:Exists(id) then return end

	local pos = #self.menuTbl + 1

	self.menuTbl[pos] = table.Copy(HELP_DATA_OBJECT)
	self.menuTbl[pos].id = id

	return self.menuTbl[pos]
end

---
-- Checks if a menu with the given id is already registered
-- @param string id The unique menu identifier
-- @return boolean Returns if the identifier is already used
-- @realm client
function HELP_DATA:Exists(id)
	for i = 1, #self.menuTbl do
		if self.menuTbl[i].id == id then
			return true
		end
	end

	return false
end

---
-- Returns a list of all registered menues that are not admin only and
-- the should show function does not return false
-- @return table A table of all menues
-- @internal
-- @realm client
function HELP_DATA:GetNormalMenues()
	local menuTbl = {}

	for i = 1, #self.menuTbl do
		local menu = self.menuTbl[i]

		-- do not show if it is admin only
		if menu.adminOnly then continue end

		-- do not show if the shouldShow function returns false
		if isfunction(menu.shouldShowFn) and menu.shouldShowFn() == false then continue end

		menuTbl[#menuTbl + 1] = menu
	end

	return menuTbl
end

---
-- Returns a list of all registered menues that are admin only as
-- long as the local player is an admin himself and the should show
-- function does not return false
-- @return table A table of all menues
-- @internal
-- @realm client
function HELP_DATA:GetAdminMenues()
	local client = LocalPlayer()
	local menuTbl = {}

	for i = 1, #self.menuTbl do
		local menu = self.menuTbl[i]

		-- do not show if it is no admin menu
		if not menu.adminOnly then continue end

		-- do not show if the player is no admin
		if not client:IsAdmin() then continue end

		-- do not show if the shouldShow function returns false
		if isfunction(menu.shouldShowFn) and menu.shouldShowFn() == false then continue end

		menuTbl[#menuTbl + 1] = menu
	end

	return menuTbl
end

---
-- Sets the title of a menu element
-- @param string title The name, can be a language identifier
-- @realm client
function HELP_DATA_OBJECT:SetTitle(title)
	self.title = title
end

---
-- Sets the description of a menu element
-- @param string description The description, can be a language identifier
-- @realm client
function HELP_DATA_OBJECT:SetDescription(description)
	self.description = description
end

---
-- Sets the icon material of a menu element
-- @param Material iconMat The material of the icon
-- @realm client
function HELP_DATA_OBJECT:SetIcon(iconMat)
	self.iconMat = iconMat
end

---
-- Sets the admin only state of a menu element
-- @param [default=true] boolean adminOnly Set true to show this menu only to admins
-- @realm client
function HELP_DATA_OBJECT:AdminOnly(adminOnly)
	self.adminOnly = adminOnly == nil and true or adminOnly
end

---
-- Sets a callback function that can be used to descide at a
-- later point if a menu should be shown
-- @param function fn The callback function
-- @realm client
function HELP_DATA_OBJECT:ShouldShow(fn)
	self.shouldShowFn = fn
end

---
-- Sets a callback function that is called when the menu button
-- is clicked
-- @param function fn The callback function
-- @realm client
function HELP_DATA_OBJECT:OnClick(fn)
	self.onClickFn = fn
end


SUB_HELP_DATA = {}

local SUB_HELP_DATA_OBJECT = {}

---
-- Binds data table to the @{SUB_HELP_DATA} object
-- @param table data The data table with all navigation points
-- @return @{SUB_HELP_DATA} The object to be used in the hook
-- @internal
-- @realm client
function SUB_HELP_DATA:BindData(menuTbl)
	self.menuTbl = menuTbl or {}

	return self
end

---
-- Populates a given submenu with navigation points
-- @param string id The unique ID of the navigation point
-- @return table A reference to the new table
-- @realm client
function SUB_HELP_DATA:PopulateSubMenu(id)
	if self:Exists(id) then return end

	local pos = #self.menuTbl + 1

	self.menuTbl[pos] = table.Copy(SUB_HELP_DATA_OBJECT)
	self.menuTbl[pos].id = id

	return self.menuTbl[pos]
end

---
-- Checks if a submenu with the given id is already registered
-- @param string id The unique submenu identifier
-- @return boolean Returns if the identifier is already used
-- @realm client
function SUB_HELP_DATA:Exists(id)
	for i = 1, #self.menuTbl do
		if self.menuTbl[i].id == id then
			return true
		end
	end

	return false
end

---
-- Sets the title of a submenu element
-- @param string title The name, can be a language identifier
-- @realm client
function SUB_HELP_DATA_OBJECT:SetTitle(title)
	self.title = title
end

---
-- Sets the admin only state of a submenu element
-- @param [default=true] boolean adminOnly Set true to show this menu only to admins
-- @realm client
function SUB_HELP_DATA_OBJECT:AdminOnly(adminOnly)
	self.adminOnly = adminOnly == nil and true or adminOnly
end

---
-- Callback function that is used to call code to populate
-- the main panel of a submenu
-- @param function fn The callback function
-- @realm client
function SUB_HELP_DATA_OBJECT:PopulatePanel(fn)
	self.populateFn = fn
end

---
-- Callback function that is used to call code to populate
-- the button panel of a submenu, this panel is only created if
-- this callback function is set
-- @param function fn The callback function
-- @realm client
function SUB_HELP_DATA_OBJECT:PopulateButtonPanel(fn)
	self.populateButtonFn = fn
end

---
-- Sets a callback function that can be used to descide at a
-- later point if a submenu should be shown
-- @param function fn The callback function
-- @realm client
function SUB_HELP_DATA_OBJECT:ShouldShow(fn)
	self.shouldShowFn = fn
end

---
-- Sets a callback function that is called when the submenu button
-- is clicked
-- @param function fn The callback function
-- @realm client
function SUB_HELP_DATA_OBJECT:OnClick(fn)
	self.onClickFn = fn
end
