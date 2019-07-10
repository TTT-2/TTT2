------------
-- HUD base class.
-- @module HUD
-- @author saibotk
-- @author LeBroomer

HUD.forcedElements = {}
HUD.disabledTypes = {}

--- The preview image that is shown in the HUD-Switcher.
-- Has to be a GMOD Material!
HUD.previewImage = Material("vgui/ttt/score_logo_2")

local savingKeys = {}

--- This function will return a table containing all keys that will be stored by
-- the @{HUD:SaveData} function.
-- @treturn tab
function HUD:GetSavingKeys()
	return savingKeys
end

--- This function will add an element to the forced elements for this HUD, so
-- this will define the implementation used for a type. Use this on knonw
-- elements you want to be shown in your HUD, so the HUD doesn't select the
-- first implementation it finds.
-- @tparam string 'elementID'
function HUD:ForceElement(elementID)
	local elem = hudelements.GetStored(elementID)

	if elem and elem.type and not self.forcedElements[elem.type] then
		self.forcedElements[elem.type] = elementID
	end
end

--- This will give you a copy of the forced elements table.
-- @treturn tab
function HUD:GetForcedElements()
	return table.Copy(self.forcedElements)
end

--- This will set a type to be hidden.
-- The element implementation for this type then will not be drawn anymore.
-- @tparam string 'elementType'
function HUD:HideType(elementType)
	table.insert(self.disabledTypes, elementType)
end

--- This will determine if an element type is supposed to be displayed, by
-- checking if @{HUD:GetElementByType} will return an element table, so the
-- HUD actually "has" the element, and checking if the element is toggled on/off
-- with its clientside ConVar.
-- @tparam string 'elementType'
-- @treturn bool
function HUD:ShouldShow(elementType)
	local el = self:GetElementByType(elementType)
	if el then
		if el.togglable and not GetGlobalBool("ttt2_elem_toggled_" .. el.id, false) then
			return false
		end

		return true
	else
		return false
	end
end

--- This will tell all elements in this HUD to recalculate their positions/sizes
-- and other dependent variables. This is called whenever the HUD changes or
-- loads new values either for itself (eg. basecolor) or for its children.
function HUD:PerformLayout()
	for _, elemName in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(elemName)
		if elem then
			if not elem:IsChild() then
				elem:PerformLayout()
			end
		else
			Msg("Error: Hudelement not found during PerformLayout: " .. elemName)

			return
		end
	end
end

--- This will initialize the HUD, by calling @{HUDELEMENT:Initialize} on its
-- elements, respecting the parent -> child relations. It will also call
-- @{HUD:PerformLayout} before setting the HUDELEMENT.initialized parameter.
function HUD:Initialize()
	-- Initialize elements default values
	for _, v in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			if not elem:IsChild() then
				elem:Initialize()
			end
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unknown element named " .. v .. "\n")
		end
	end

	self:PerformLayout()

	-- Initialize elements default values
	for _, v in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem.initialized = true
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unknown element named " .. v .. "\n")
		end
	end
end

--- Returns wether or not the HUD has an element for the given type.
-- See @{HUD:GetElementByType} for an explaination when a HUD 'has' an element.
-- @tparam string 'elementType'
-- @treturn bool
function HUD:HasElementType(elementType)
	return self:GetElementByType(elementType) ~= nil
end

--- Determines if the given element instance is available/usable for this HUD.
-- This will respect the @{HUDELEMENT}.disabledUnlessForced property and check
-- if the parent element (if exists) is also available, otherwise this will
-- return false.
-- @tparam tab 'elementTbl'
-- @treturn bool
function HUD:CanUseElement(elementTbl)
	-- return false if the table is empty.
	if not elementTbl then return false end

	-- return false if the element is disabled unless it is forced and it is not forced in this HUD.
	if elementTbl.disabledUnlessForced and not table.HasValue(self.forcedElements, elementTbl.id) then return false end

	-- check if the element is a child and if it is parent element is a part of this HUD.
	if elementTbl:IsChild() then
		local parent, parentIsType = elementTbl:GetParentRelation()

		if not parent or parentIsType == nil then return false end

		-- find the parent element, if the element is bound to a type call this method again implicitly (check if element is used by the HUD) and if not,
		-- get the specific element and call this method on it.
		return (parentIsType and self:HasElementType(parent)) or (not parentIsType and self:CanUseElement(hudelements.GetStored(parent)))
	end

	return true
end

--- Returns an element the HUD wants to use for a given type.
-- It will only return an element, if the HUD 'has' the element.
-- This will first evaluate, if there is a forcedElement for the given type,
-- otherwise it will search all elements that match the type and find the first
-- instance that 'can' be used, please take a look at @{HUD:CanUseElement} for
-- the criteria / restrictions for the evaluation as if an element can be used.
-- @tparam string 'elementType'
-- @treturn tab
function HUD:GetElementByType(elementType)
	-- element type is hidden in this HUD so return nil
	if table.HasValue(self.disabledTypes, elementType) then return nil end

	local forcedElement = self.forcedElements[elementType]
	local elementTbl = nil

	-- Check if an element is forced by the HUD for the given type
	if forcedElement ~= nil then
		elementTbl = hudelements.GetStored(forcedElement)
	end

	-- Evaluate the forcedElement or try to find a usable element.
	if self:CanUseElement(elementTbl) then
		return elementTbl
	else
		-- fallback and search for the first usable element for this type
		local availableElements = hudelements.GetAllTypeElements(elementType)

		-- find first valid element
		for _, el in ipairs(availableElements) do
			if self:CanUseElement(el) then
				elementTbl = el
				break
			end
		end
	end

	return elementTbl
end

--- This returns a table with all the specific elements the HUD has. One element
-- per type, respecting the forcedElements and otherwise taking the first found
-- implementation.
-- @todo TODO optimize / cache maybe?!
-- @treturn tab
function HUD:GetElements()
	-- loop through all types and if the hud does not provide an element take the first found instance for the type
	local elems = {}

	for _, typ in ipairs(hudelements.GetElementTypes()) do
		local el = self:GetElementByType(typ)
		if el then
			elems[#elems + 1] = el.id
		end
	end

	return elems
end

--- Called to draw an element and all its children, by calling the
-- @{HUD:DrawElemAndChildren} function on them (recursive).
-- This will also respect the HUDELEMENT.initialized attribute, the
-- @{HUD:ShouldShow} result, the @{HUDELEMENT:ShouldDraw} result and the result
-- of the hook "HUDShouldDraw". Additionally this function will call
-- HUDEditor.DrawElem after the elements draw, to correctly display
-- the HUDEditors elements on top.
-- @tparam tab 'elem'
function HUD:DrawElemAndChildren(elem)
	if not elem.initialized or not elem.type or not hook.Call("HUDShouldDraw", GAMEMODE, elem.type) or not self:ShouldShow(elem.type) or not elem:ShouldDraw() then return end

	local children = elem:GetChildren()

	for _, v in ipairs(children) do
		local child = hudelements.GetStored(v)
		if not child then
			MsgN("Error: Hudelement with name " .. v .. " not found!")
		else
			self:DrawElemAndChildren(child)
		end
	end

	elem:Draw()

	if HUDEditor then
		HUDEditor.DrawElem(elem)
	end
end

--- Called to draw all elements, by calling the
-- @{HUD:DrawElemAndChildren} function on all elements which aren't
-- a child and have a HUDELEMENT.type (these are all non-base elements).
function HUD:Draw()
	for _, elemName in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(elemName)
		if not elem then
			MsgN("Error: Hudelement with name " .. elemName .. " not found!")
			return
		end

		if elem.type and not elem:IsChild() then
			self:DrawElemAndChildren(elem)
		end
	end
end

--- This will reset all elements of the HUD and call @{HUDELEMENT:Reset} on its
-- elements. This will respect the parent -> child relation and only call this
-- on non-child elements.
function HUD:Reset()
	for _, elemName in ipairs(self:GetElements()) do
		local elem = hudelements.GetStored(elemName)
		if elem then
			if not elem:IsChild() then
				elem:Reset()
			end
		else
			Msg("Error: Hudelement not found during Reset: " .. elemName)

			return
		end
	end
end

--- This will save all data of the HUD and its elements, by calling
-- @{HUDELEMENT:SaveData} on them. This is usually called when changing the
-- current HUD or editing a HUD in the HUDEditor.
function HUD:SaveData()
	-- save data for the HUD
	SQL.Save("ttt2_huds", self.id, self, self:GetSavingKeys())

	-- save data of all elements of this HUD
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el:SaveData()
		end
	end
end

--- This function will load all saved keys from the Database and will then call
-- @{HUDELEMENT:LoadData} on all elements, shown by the HUD. After that it will
-- call @{HUD:PerformLayout}. This function is called when the HUDManager loads
-- / changes to this HUD.
function HUD:LoadData()
	local skeys = self:GetSavingKeys()

	-- load and initialize all HUD data from database
	if SQL.CreateSqlTable("ttt2_huds", skeys) then
		local loaded = SQL.Load("ttt2_huds", self.id, self, skeys)

		if not loaded then
			SQL.Init("ttt2_huds", self.id, self, skeys)
		end
	end

	-- load data of all elements in this HUD
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el:LoadData()
		end
	end

	self:PerformLayout()
end
