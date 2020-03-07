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

function HELP_DATA:Exists(id)
	for i = 1, #self.menuTbl do
		if self.menuTbl[i].id == id then
			return true
		end
	end

	return false
end

function HELP_DATA_OBJECT:SetTitle(title)
	self.title = title
end

function HELP_DATA_OBJECT:SetDescription(description)
	self.description = description
end

function HELP_DATA_OBJECT:SetIcon(iconMat)
	self.iconMat = iconMat
end

function HELP_DATA_OBJECT:AdminOnly(andminOnly)
	self.andminOnly = andminOnly == nil and true or adminOnly
end

function HELP_DATA_OBJECT:ShouldShow(fn)
	self.shouldShowFn = fn
end

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

function SUB_HELP_DATA:Exists(id)
	for i = 1, #self.menuTbl do
		if self.menuTbl[i].id == id then
			return true
		end
	end

	return false
end

function SUB_HELP_DATA_OBJECT:SetTitle(title)
	self.title = title
end

function SUB_HELP_DATA_OBJECT:AdminOnly(andminOnly)
	self.andminOnly = andminOnly == nil and true or adminOnly
end

function SUB_HELP_DATA_OBJECT:PopulatePanel(fn)
	self.populateFn = fn
end

function SUB_HELP_DATA_OBJECT:PopulateButtonPanel(fn)
	self.populateButtonFn = fn
end

function SUB_HELP_DATA_OBJECT:ShouldShow(fn)
	self.shouldShowFn = fn
end

function SUB_HELP_DATA_OBJECT:OnClick(fn)
	self.onClickFn = fn
end
