---
-- HUD base class.
-- @class HUD
-- @author saibotk
-- @author LeBroomer

local table = table

HUD.forcedElements = {}
HUD.disabledTypes = {}

-- The preview image that is shown in the HUD-Switcher.
-- Has to be a GMOD Material!
HUD.previewImage = Material("vgui/ttt/score_logo_2")

HUD.savingKeys = {}

---
-- This function will return a table containing all keys that will be stored by
-- the @{HUD:SaveData} function.
-- @return table
-- @realm client
function HUD:GetSavingKeys()
    return self.savingKeys
end

---
-- This function will add an element to the forced elements for this HUD, so
-- this will define the implementation used for a type. Use this on knonw
-- elements you want to be shown in your HUD, so the HUD doesn't select the
-- first implementation it finds.
-- @param string elementID
-- @realm client
function HUD:ForceElement(elementID)
    local elem = hudelements.GetStored(elementID)

    if elem and elem.type and not self.forcedElements[elem.type] then
        self.forcedElements[elem.type] = elementID
    end
end

---
-- This will give you a copy of the forced elements table.
-- @return table
-- @realm client
function HUD:GetForcedElements()
    return table.Copy(self.forcedElements)
end

---
-- This will set a type to be hidden.
-- The element implementation for this type then will not be drawn anymore.
-- @param string elementType
-- @realm client
function HUD:HideType(elementType)
    self.disabledTypes[elementType] = true
end

---
-- This will determine if an element type is supposed to be displayed, by
-- checking if @{HUD:GetElementByType} will return an element table, so the
-- HUD actually "has" the element, and checking if the element is toggled on/off
-- with its clientside ConVar.
-- @param string elementType
-- @return boolean
-- @realm client
function HUD:ShouldShow(elementType)
    local elem = self:GetElementByType(elementType)
    if elem then
        if elem.togglable and not GetGlobalBool("ttt2_elem_toggled_" .. elem.id, false) then
            return false
        end

        return true
    else
        return false
    end
end

---
-- This will tell all elements in this HUD to recalculate their positions/sizes
-- and other dependent variables. This is called whenever the HUD changes or
-- loads new values either for itself (eg. basecolor) or for its children.
-- @realm client
function HUD:PerformLayout()
    local elems = self:GetElements()

    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            ErrorNoHaltWithStack("Error: Hudelement not found during PerformLayout: " .. elemName)

            continue
        end

        if not elem:IsChild() then
            elem:PerformLayout()
        end
    end
end

---
-- This will initialize the HUD, by calling @{HUDELEMENT:Initialize} on its
-- elements, respecting the parent -> child relations. It will also call
-- @{HUD:PerformLayout} before setting the HUDELEMENT.initialized parameter.
-- @realm client
function HUD:Initialize()
    local elems = self:GetElements()

    -- Initialize elements default values
    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            ErrorNoHaltWithStack(
                "Error: HUD "
                    .. (self.id or "?")
                    .. " has unknown element named "
                    .. elemName
                    .. "\n"
            )

            continue
        end

        if not elem:IsChild() then
            elem:Initialize()
        end
    end

    self:PerformLayout()

    -- Initialize elements default values
    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            ErrorNoHaltWithStack(
                "Error: HUD "
                    .. (self.id or "?")
                    .. " has unknown element named "
                    .. elemName
                    .. "\n"
            )

            continue
        end

        elem.initialized = true
    end

    -- Cache elements after initialization
    self.cachedElems = elems
end

---
-- Returns whether or not the HUD has an element for the given type.
-- See @{HUD:GetElementByType} for an explaination when a HUD 'has' an element.
-- @param string elementType
-- @return boolean
-- @realm client
function HUD:HasElementType(elementType)
    return self:GetElementByType(elementType) ~= nil
end

---
-- Determines if the given element instance is available/usable for this HUD.
-- This will respect the @{HUDELEMENT}.disabledUnlessForced property and check
-- if the parent element (if exists) is also available, otherwise this will
-- return false.
-- @param table elementTbl
-- @return boolean
-- @realm client
function HUD:CanUseElement(elementTbl)
    -- return false if the table is empty.
    if not elementTbl then
        return false
    end

    -- return false if the element is disabled unless it is forced and it is not forced in this HUD.
    if
        elementTbl.disabledUnlessForced and not table.HasValue(self.forcedElements, elementTbl.id)
    then
        return false
    end

    -- check if the element is a child and if it is parent element is a part of this HUD.
    if elementTbl:IsChild() then
        local parent, parentIsType = elementTbl:GetParentRelation()

        if not parent or parentIsType == nil then
            return false
        end

        -- find the parent element, if the element is bound to a type call this method again implicitly (check if element is used by the HUD) and if not,
        -- get the specific element and call this method on it.
        return (parentIsType and self:HasElementType(parent))
            or (not parentIsType and self:CanUseElement(hudelements.GetStored(parent)))
    end

    return true
end

---
-- Returns an element the HUD wants to use for a given type.
-- It will only return an element, if the HUD 'has' the element.
-- This will first evaluate, if there is a forcedElement for the given type,
-- otherwise it will search all elements that match the type and find the first
-- instance that 'can' be used, please take a look at @{HUD:CanUseElement} for
-- the criteria / restrictions for the evaluation as if an element can be used.
-- @param string elementType
-- @return table
-- @realm client
function HUD:GetElementByType(elementType)
    -- If elements are cached, only check them, instead of searching for a suitable one again.
    if self.cachedElems ~= nil then
        for i = 1, #self.cachedElems do
            local cachedElem = hudelements.GetStored(self.cachedElems[i])
            if cachedElem.type == elementType then
                return cachedElem
            end
        end

        return
    end

    -- element type is hidden in this HUD so return nil
    if self.disabledTypes[elementType] then
        return
    end

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
        for i = 1, #availableElements do
            local el = availableElements[i]

            if not self:CanUseElement(el) then
                continue
            end

            elementTbl = el

            break
        end
    end

    return elementTbl
end

---
-- This returns a table with all the specific elements the HUD has. One element
-- per type, respecting the forcedElements and otherwise taking the first found
-- implementation.
-- @return table
-- @realm client
function HUD:GetElements()
    if self.cachedElems then
        return self.cachedElems
    end

    -- loop through all types and if the hud does not provide an element take the first found instance for the type
    local elems = {}
    local elemTypes = hudelements.GetElementTypes()

    for i = 1, #elemTypes do
        local typ = elemTypes[i]

        local el = self:GetElementByType(typ)
        if not el then
            continue
        end

        elems[#elems + 1] = el.id
    end

    return elems
end

---
-- Called to draw an element and all its children, by calling the
-- @{HUD:DrawElemAndChildren} function on them (recursive).
-- This will also respect the HUDELEMENT.initialized attribute, the
-- @{HUD:ShouldShow} result, the @{HUDELEMENT:ShouldDraw} result and the result
-- of the hook "HUDShouldDraw". Additionally this function will call
-- HUDEditor.DrawElem after the elements draw, to correctly display
-- the HUDEditors elements on top.
-- @param table elem
-- @realm client
function HUD:DrawElemAndChildren(elem)
    ---
    -- @realm client
    if
        not elem.initialized
        or not elem.type
        or not hook.Run("HUDShouldDraw", elem.type)
        or not self:ShouldShow(elem.type)
        or not elem:ShouldDraw()
    then
        return
    end

    local children = elem:GetChildren()

    for i = 1, #children do
        local childName = children[i]

        local child = hudelements.GetStored(childName)
        if not child then
            Dev(1, "Error: Hudelement with name " .. childName .. " not found!")

            continue
        end

        self:DrawElemAndChildren(child)
    end

    elem:Draw()

    if HUDEditor then
        HUDEditor.DrawElem(elem)
    end
end

---
-- Called to draw all elements, by calling the
-- @{HUD:DrawElemAndChildren} function on all elements which aren't
-- a child and have a HUDELEMENT.type (these are all non-base elements).
-- @realm client
function HUD:Draw()
    local elems = self:GetElements()

    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            Dev(1, "Error: Hudelement with name " .. elemName .. " not found!")

            continue
        end

        if elem.type and not elem:IsChild() then
            self:DrawElemAndChildren(elem)
        end
    end
end

---
-- This will reset all elements of the HUD and call @{HUDELEMENT:Reset} on its
-- elements. This will respect the parent -> child relation and only call this
-- on non-child elements.
-- @realm client
function HUD:Reset()
    local elems = self:GetElements()

    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            ErrorNoHaltWithStack("Error: Hudelement not found during Reset: " .. elemName)

            continue
        end

        if not elem:IsChild() then
            elem:Reset()
        end
    end
end

---
-- This will save all data of the HUD and its elements, by calling
-- @{HUDELEMENT:SaveData} on them. This is usually called when changing the
-- current HUD or editing a HUD in the HUDEditor.
-- @realm client
function HUD:SaveData()
    -- save data for the HUD
    sql.Save("ttt2_huds", self.id, self, self:GetSavingKeys())

    local elems = self:GetElements()

    -- save data of all elements of this HUD
    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            continue
        end

        elem:SaveData()
    end
end

---
-- This function will load all saved keys from the Database and will then call
-- @{HUDELEMENT:LoadData} on all elements, shown by the HUD. After that it will
-- call @{HUD:PerformLayout}. This function is called when the HUDManager loads
-- / changes to this HUD.
-- @realm client
function HUD:LoadData()
    local skeys = self:GetSavingKeys()

    -- load and initialize all HUD data from database
    if sql.CreateSqlTable("ttt2_huds", skeys) then
        local loaded = sql.Load("ttt2_huds", self.id, self, skeys)

        if not loaded then
            sql.Init("ttt2_huds", self.id, self, skeys)
        end
    end

    local elems = self:GetElements()

    -- load data of all elements in this HUD
    for i = 1, #elems do
        local elemName = elems[i]

        local elem = hudelements.GetStored(elemName)
        if not elem then
            continue
        end

        elem:LoadData()
    end

    self:PerformLayout()
end
