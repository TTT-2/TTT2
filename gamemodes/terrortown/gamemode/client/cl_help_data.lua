---
-- @desc A collection of objects that are passed in the menu populate hooks.
-- @author Mineotopia

menuHelpData = {}

local menuHelpDataObject = {}

---
-- Binds data table to the @{menuHelpData} object
-- @param table data The data table with all submenues
-- @return @{menuHelpData} The object to be used in the hook to populate the menu
-- @internal
-- @realm client
function menuHelpData:BindData(menuTbl)
	self.menuTbl = menuTbl or {}

	return self
end

---
-- Creates a new submenu in the main menu
-- @param string id The unique ID of the submenu
-- @return table A reference to the new table
-- @realm client
function menuHelpData:RegisterSubMenu(id)
	if self:Exists(id) then return end

	local pos = #self.menuTbl + 1

	self.menuTbl[pos] = table.Copy(menuHelpDataObject)
	self.menuTbl[pos].id = id

	return self.menuTbl[pos]
end

---
-- Checks if a menu with the given ID is already registered
-- @param string id The unique menu identifier
-- @return boolean Returns if the identifier is already used
-- @realm client
function menuHelpData:Exists(id)
	for i = 1, #self.menuTbl do
		if self.menuTbl[i].id == id then
			return true
		end
	end

	return false
end

---
-- Returns a list of all registered menues that are not admin only and
-- whose should show function does not return false
-- @return table A table of all menues
-- @internal
-- @realm client
function menuHelpData:GetVisibleNormalMenues()
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
-- long as the local player is an admin himself and whose should show
-- function does not return false
-- @return table A table of all menues
-- @internal
-- @realm client
function menuHelpData:GetVisibleAdminMenues()
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
function menuHelpDataObject:SetTitle(title)
	self.title = title
end

---
-- Sets the description of a menu element
-- @param string description The description, can be a language identifier
-- @realm client
function menuHelpDataObject:SetDescription(description)
	self.description = description
end

---
-- Sets the icon material of a menu element
-- @param Material iconMat The material of the icon
-- @realm client
function menuHelpDataObject:SetIcon(iconMat)
	self.iconMat = iconMat
end

---
-- Sets the admin only state of a menu element
-- @param [default=true] boolean adminOnly Set true to show this menu only to admins
-- @realm client
function menuHelpDataObject:AdminOnly(adminOnly)
	self.adminOnly = adminOnly == nil and true or adminOnly
end

---
-- Sets a callback function that can be used to descide at a
-- later point if a menu should be shown
-- @param function fn The callback function
-- @realm client
function menuHelpDataObject:RegisterShouldShowCallback(fn)
	self.shouldShowFn = fn
end

---
-- Sets a callback function that is called when the menu button
-- is clicked
-- @param function fn The callback function
-- @realm client
function menuHelpDataObject:RegisterOnClickCallback(fn)
	self.onClickFn = fn
end


subMenuHelpData = {}

local subMenuHelpDataObject = {}

---
-- Binds data table to the @{subMenuHelpData} object
-- @param table data The data table with all navigation points
-- @return @{subMenuHelpData} The object to be used in the hook
-- @internal
-- @realm client
function subMenuHelpData:BindData(menuTbl)
	self.menuTbl = menuTbl or {}

	return self
end

---
-- Populates a given submenu with navigation points
-- @param string id The unique ID of the navigation point
-- @return table A reference to the new table
-- @realm client
function subMenuHelpData:PopulateSubMenu(id)
	if self:Exists(id) then return end

	local pos = #self.menuTbl + 1

	self.menuTbl[pos] = table.Copy(subMenuHelpDataObject)
	self.menuTbl[pos].id = id

	return self.menuTbl[pos]
end

---
-- Checks if a submenu with the given ID is already registered
-- @param string id The unique submenu identifier
-- @return boolean Returns if the identifier is already used
-- @realm client
function subMenuHelpData:Exists(id)
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
function subMenuHelpDataObject:SetTitle(title)
	self.title = title
end

---
-- Sets the admin only state of a submenu element
-- @param [default=true] boolean adminOnly Set true to show this menu only to admins
-- @realm client
function subMenuHelpDataObject:AdminOnly(adminOnly)
	self.adminOnly = adminOnly == nil and true or adminOnly
end

---
-- Callback function that is used to call code to populate
-- the main panel of a submenu
-- @param function fn The callback function
-- @realm client
function subMenuHelpDataObject:PopulatePanel(fn)
	self.populateFn = fn
end

---
-- Callback function that is used to call code to populate
-- the button panel of a submenu, this panel is only created if
-- this callback function is set
-- @param function fn The callback function
-- @realm client
function subMenuHelpDataObject:PopulateButtonPanel(fn)
	self.populateButtonFn = fn
end

---
-- Sets a callback function that can be used to descide at a
-- later point if a submenu should be shown
-- @param function fn The callback function
-- @realm client
function subMenuHelpDataObject:RegisterShouldShowCallback(fn)
	self.shouldShowFn = fn
end

---
-- Sets a callback function that is called when the submenu button
-- is clicked
-- @param function fn The callback function
-- @realm client
function subMenuHelpDataObject:RegisterOnClickCallback(fn)
	self.onClickFn = fn
end
