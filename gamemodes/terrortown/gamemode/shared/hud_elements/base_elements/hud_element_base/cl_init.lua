---
-- HUDELEMENT base class.
-- @class HUDELEMENT
-- @author saibotk
-- @author LeBroomer

local surface = surface
local table = table
local draw = draw
local sql = sql
local hudelements = hudelements
local math = math

local zero_tbl_pos = {
    x = 0,
    y = 0,
}

local zero_tbl_size = {
    w = 0,
    h = 0,
}

local zero_tbl_min_size = {
    w = 0,
    h = 0,
}

-- Basic position / dimension variables
HUDELEMENT.basepos = table.Copy(zero_tbl_pos)
HUDELEMENT.pos = table.Copy(zero_tbl_pos)
HUDELEMENT.size = table.Copy(zero_tbl_size)
HUDELEMENT.minsize = table.Copy(zero_tbl_min_size)

-- Parent / Child variables
-- These usually should not be set manually! Use the Getter / Setters, and for
-- adding a child use the hudelements.RegisterChildRelation(childid, parentid, parent_is_type)
-- which will also take care of adding a child to an element type instead of a specific element
HUDELEMENT.parent = nil
HUDELEMENT.parent_is_type = nil
HUDELEMENT.children = {}

HUDELEMENT.defaults = {
    -- resize area parameters
    click_area = 20,
    click_padding = 0,
}

HUDELEMENT.edit_live_data = {
    calc_new_click_area = false,
    old_row = nil,
    old_col = nil,
}

---
-- This function will try to call the function given with funcName on
-- all children of this hud element, while also passing extra parameters
-- to this the function.
-- @param string funcName
-- @param[opt] any ... parameters to call the given function with
-- @realm client
function HUDELEMENT:ApplyToChildren(funcName, ...)
    if not funcName then
        return
    end

    local children = self:GetChildren()

    for i = 1, #children do
        local elem = children[i]

        local elemtbl = hudelements.GetStored(elem)
        if not elemtbl then
            ErrorNoHaltWithStack(
                "ERROR: HUDElement "
                    .. (self.id or "?")
                    .. " has unknown child element named "
                    .. elem
                    .. " when applying a function to all children: "
                    .. funcName
                    .. " \n"
            )

            continue
        end

        if isfunction(elemtbl[funcName]) then
            elemtbl[funcName](elemtbl, ...)
        else
            ErrorNoHaltWithStack(
                "ERROR: HUDElement "
                    .. (self.id or "?")
                    .. " has child named "
                    .. elem
                    .. " with unknown function "
                    .. funcName
                    .. " \n"
            )
        end
    end
end

---
-- This function will be called after all hud elements have been loaded
-- and are registered. But be aware that the elements are still "raw", so
-- they did not execute any code or set any of their properties correct.
-- Use this function for example to register your child -> parent
-- relation, by calling
-- @{hudelements.RegisterChildRelation}(childid, parentid, parent_is_type)
-- and also to force your element to a specific HUD if needed etc...
-- @hook
-- @note Use this to set child<->parent relations and also to force your element to a specific HUD if needed etc,
-- this is called before Initialized and other objects can still be uninitialized!
-- @realm client
function HUDELEMENT:PreInitialize() end

---
-- This function will be called each time the HUD is loaded eg. when
-- switching to this HUD in the HUDManager, so expect this function to
-- be called multiple times and respect that within your code. Due to
-- this, the function should be used to reset your member variables and
-- temporary variables. Then you can set them to an useful inital value.
--
-- Remember that previously loaded values will be applied later and
-- dont forget to call BaseClass.@{HUDELEMENT:Initialize}(self), which will then call
-- @{HUDELEMENT:Initialize} on all children.
-- @realm client
function HUDELEMENT:Initialize()
    local defaults = self:GetDefaults()

    self:SetSize(defaults.size.w, defaults.size.h)
    self:SetMinSize(defaults.minsize.w, defaults.minsize.h)

    defaults = self:GetDefaults()

    self:SetBasePos(defaults.basepos.x, defaults.basepos.y)

    -- use this to set default values and dont forget to call BaseClass.Initialze(self)!!
    self:ApplyToChildren("Initialize")
end

---
-- This function is called when an element should draw its content.
-- Please use this function only to draw your element and dont calculate
-- any values if not explicitly needed.
-- @hook
-- @realm client
function HUDELEMENT:Draw() end

---
-- This function is called to decide whether or not an element should be drawn.
-- Override it to let your element be drawn only in specific situations.
-- @return[default=true] boolean
-- @hook
-- @realm client
function HUDELEMENT:ShouldDraw()
    return true
end

---
-- Checks whether an hud element is resizeable.
-- Override it to change the resizing behaviour.
-- @return[default=true] boolean
-- @return[default=true] boolean
-- @hook
-- @realm client
function HUDELEMENT:IsResizable()
    return true, true
end

---
-- Checks whether an hud element's aspect ratio is locked.
-- Override it to change the behaviour.
-- @return[default=false] boolean
-- @hook
-- @realm client
function HUDELEMENT:AspectRatioIsLocked()
    return false
end

---
-- Checks whether an hud element's borders are inherited by it's parent.
-- Override it to change the resizing behaviour.
-- @return[default=false] boolean
-- @hook
-- @realm client
function HUDELEMENT:InheritParentBorder()
    return false
end
-- parameter overwrites end

---
-- This function is called after all @{HUDELEMENT:Initialize} functions and
-- whenever the layout was changed, i.e., size, position.
-- @hook
-- @realm client
function HUDELEMENT:PerformLayout()
    self:ApplyToChildren("PerformLayout")
end

---
-- This function returns your basepos, the value which is used
-- to move the element.
-- @return table x and y value
-- @realm client
function HUDELEMENT:GetBasePos()
    return table.Copy(self.basepos)
end

---
-- This function sets your basepos, the value which is used
-- to move the element. It automatically updates the position as
-- well with @{HUDELEMENT:SetPos}
-- @param number x
-- @param number y
-- @realm client
function HUDELEMENT:SetBasePos(x, y)
    local pos_difference_x = self.pos.x - self.basepos.x
    local pos_difference_y = self.pos.y - self.basepos.y

    self.basepos.x = x
    self.basepos.y = y

    self:SetPos(x + pos_difference_x, y + pos_difference_y)
end

---
-- This function returns your pos, the value which is used
-- internally to define the upper left corner of the element
-- @return table with x and y value
-- @realm client
function HUDELEMENT:GetPos()
    return table.Copy(self.pos)
end

---
-- This function sets your pos, the value which is used
-- internally to define the upper left corner of the element
-- @param number x
-- @param number y
-- @realm client
function HUDELEMENT:SetPos(x, y)
    self.pos.x = x
    self.pos.y = y
end

---
-- This function returns your minsize, the value which is used
-- as a minimum when resizing the element.
-- @note Setting the size with @{HUDELEMENT:SetSize} allows smaller values.
-- @return table width and height value
-- @realm client
function HUDELEMENT:GetMinSize()
    return table.Copy(self.minsize)
end

---
-- This function sets your minsize, the value which is used
-- as a minimum when resizing the element.
-- @note Setting the size with @{HUDELEMENT:SetSize} allows smaller values.
-- @param number w
-- @param number h
-- @realm client
function HUDELEMENT:SetMinSize(w, h)
    self.minsize.w = w
    self.minsize.h = h
end

---
-- This function returns your size.
-- @return table with width and height value
-- @realm client
function HUDELEMENT:GetSize()
    return table.Copy(self.size)
end

---
-- This function sets your size.
-- @note When passing negative values it will call @{SetPos} to
-- shift your element by the value. This results in i.e. in a top growing element
-- instead of the default bottom growing when setting -h instead of h.
-- @param number w
-- @param number h
-- @realm client
function HUDELEMENT:SetSize(w, h)
    w = math.Round(w)
    h = math.Round(h)

    local nw, nh = w < 0, h < 0

    if nw then
        w = -w
    end

    if nh then
        h = -h
    end

    if nw or nh then
        if nw then
            self:SetPos(self:GetBasePos().x - w, self:GetPos().y)
        end

        if nh then
            self:SetPos(self:GetPos().x, self:GetBasePos().y - h)
        end
    end

    self.size.w = w
    self.size.h = h
end

---
-- This function returns the current parent together with its type.
-- @return string
-- @return boolean
-- @internal
-- @realm client
function HUDELEMENT:GetParentRelation()
    return self.parent, self.parent_is_type
end

---
-- This function is used internally and only has the full effect if
-- called by the @{hudelements.RegisterChildRelation} function.
-- @param string parent
-- @param boolean is_type
-- @internal
-- @realm client
function HUDELEMENT:SetParentRelation(parent, is_type)
    self.parent = parent
    self.parent_is_type = is_type
end

---
-- This function adds a child to your list of children.
-- Children functions will be called whenever a parent function is called,
-- e.g. in @{HUDELEMENT:PerformLayout}
-- @param number elementid
-- @realm client
function HUDELEMENT:AddChild(elementid)
    if not table.HasValue(self.children, elementid) then
        self.children[#self.children + 1] = elementid
    end
end

---
-- This function gives you information about whether it has a parent or not
-- @return boolean
-- @realm client
function HUDELEMENT:IsChild()
    return self.parent ~= nil
end

---
-- This function gives you information about whether it has child elements or not
-- @return boolean
-- @realm client
function HUDELEMENT:IsParent()
    return #self.children > 0
end

---
-- This function gives you a copy of all your children
-- @return table a copy of all your child elements
-- @realm client
function HUDELEMENT:GetChildren()
    return table.Copy(self.children)
end

---
-- Get the position and the size of an hud element
-- @return table position (<code>{@{number} x, @{number} y}</code>)
-- @return table size (<code>{@{number} w, @{number} h}</code>)
-- @realm client
function HUDELEMENT:GetBorderParams()
    if not self:IsParent() then
        return self:GetPos(), self:GetSize()
    end

    local pos = self:GetPos()
    local size = self:GetSize()
    local children = self:GetChildren()

    local x_min, y_min, x_max, y_max = pos.x, pos.y, pos.x + size.w, pos.y + size.h

    -- iterate over children
    for i = 1, #children do
        local elem_str = children[i]
        local elem = hudelements.GetStored(elem_str)

        local hud = huds.GetStored(HUDManager.GetHUD())

        if
            elem
            and elem:InheritParentBorder()
            and hud:ShouldShow(elem.type)
            and elem:ShouldDraw()
        then
            local c_pos = elem:GetPos()
            local c_size = elem:GetSize()

            x_min = math.min(x_min, c_pos.x)
            y_min = math.min(y_min, c_pos.y)
            x_max = math.max(x_max, c_pos.x + c_size.w)
            y_max = math.max(y_max, c_pos.y + c_size.h)
        end
    end

    return { x = x_min, y = y_min }, { w = x_max - x_min, h = y_max - y_min }
end

---
-- Checks whether an hud element is in range
-- @param number x
-- @param number y
-- @param number range
-- @return boolean
-- @realm client
function HUDELEMENT:IsInRange(x, y, range)
    range = range or 0

    local minX, minY = self.pos.x, self.pos.y
    local maxX, maxY = minX + self.size.w, minY + self.size.h

    return x - range <= maxX and x + range >= minX and y - range <= maxY and y + range >= minY
end

---
-- Checks whether an hud element is in position (same as @{HUDELEMENT:IsInRange}, but without any padding)
-- @param number x
-- @param number y
-- @return boolean
-- @realm client
function HUDELEMENT:IsInPos(x, y)
    return self:IsInRange(x, y, 0)
end

---
-- Returns the hovered area of an hud element
-- @param number x
-- @param number y
-- @return table ({@{boolean}, @{boolean}, @{boolean}})
-- @return table ({@{boolean}, @{boolean}, @{boolean}})
-- @local
-- @realm client
function HUDELEMENT:OnHovered(x, y)
    if self:IsChild() then -- children are not resizeable
        return { false, false, false }, { false, false, false }
    end

    local minX, minY = self.pos.x, self.pos.y
    local maxX, maxY = minX + self.size.w, minY + self.size.h

    local c_pad, c_area = self.defaults.click_padding, self.defaults.click_area
    local res_x, res_y = self:IsResizable()

    local row, col

    -- ROWS
    if res_y then
        row = {
            y > minY + c_pad and y < minY + c_pad + c_area, -- top row
            y > minY + 2 * c_pad + c_area and y < maxY - 2 * c_pad - c_area, -- center column
            y > maxY - c_pad - c_area and y < maxY - c_pad, -- right column
        }
    else
        row = {
            false, -- top row
            y > minY + c_pad and y < maxY - c_pad, -- center column
            false, -- right column
        }
    end

    -- COLUMS
    if res_x then
        col = {
            x > minX + c_pad and x < minX + c_pad + c_area, -- left column
            x > minX + 2 * c_pad + c_area and x < maxX - 2 * c_pad - c_area, -- center column
            x > maxX - c_pad - c_area and x < maxX - c_pad, -- right column
        }
    else
        col = {
            false, -- left column
            x > minX + c_pad and x < maxX - c_pad, -- center column
            false, -- right column
        }
    end

    -- locked aspect ratio has to be a special case to not break movement
    -- ignore if mouse is on center
    if self:AspectRatioIsLocked() and not (row[2] and col[2]) then
        row[2] = false
        col[2] = false
    end

    return row, col
end

---
-- Draws the hovered @{HUDELEMENT:OnHovered} areas of the hud element in a specific color
-- @param number x
-- @param number y
-- @local
-- @realm client
function HUDELEMENT:DrawHovered(x, y)
    if not self:IsInPos(x, y) then
        return false
    end

    local minX, minY = self.pos.x, self.pos.y
    local maxX, maxY = minX + self.size.w, minY + self.size.h
    local c_pad, c_area = self.defaults.click_padding, self.defaults.click_area
    local res_x, res_y = self:IsResizable()

    local row, col = self:OnHovered(x, y)
    local x1, x2, y1, y2 = 0, 0, 0, 0

    if row[1] then -- resizeable in all directions
        y1 = minY + c_pad
        y2 = minY + c_pad + c_area
    elseif row[2] and (col[1] or col[3]) and not res_y then -- only resizeable in X
        y1 = minY + c_pad
        y2 = maxY - c_pad
    elseif row[2] and not res_y then -- only resizeable in X / show center area
        y1 = minY + c_pad
        y2 = maxY - c_pad
    elseif row[2] then -- resizeable in all directions / show center area
        y1 = minY + 2 * c_pad + c_area
        y2 = maxY - 2 * c_pad - c_area
    elseif row[3] then -- resizeable in all directions
        y1 = maxY - c_pad - c_area
        y2 = maxY - c_pad
    end

    if col[1] then -- resizeable in all directions
        x1 = minX + c_pad
        x2 = minX + c_pad + c_area
    elseif col[2] and (row[1] or row[3]) and not res_x then -- only resizeable in Y
        x1 = minX + c_pad
        x2 = maxX - c_pad
    elseif col[2] and not res_x then -- only resizeable in Y / show center area
        x1 = minX + c_pad
        x2 = maxX - c_pad
    elseif col[2] then -- resizeable in all directions / show center area
        x1 = minX + 2 * c_pad + c_area
        x2 = maxX - 2 * c_pad - c_area
    elseif col[3] then -- resizeable in all directions
        x1 = maxX - c_pad - c_area
        x2 = maxX - c_pad
    end

    -- set color
    if row[2] and col[2] then
        surface.SetDrawColor(20, 150, 245, 155)
    else
        surface.SetDrawColor(245, 30, 80, 155)
    end

    -- draw rect
    surface.DrawRect(x1, y1, x2 - x1, y2 - y1)
end

---
-- Returns the clicked area of an hud element
-- @param number x
-- @param number y
-- @param boolean alt_pressed
-- @return boolean
-- @see OnHovered
-- @local
-- @realm client
function HUDELEMENT:GetClickedArea(x, y, alt_pressed)
    alt_pressed = alt_pressed or false

    local row, col

    if self.edit_live_data.calc_new_click_area then
        if not self:IsInPos(x, y) then
            return false
        end

        row, col = self:OnHovered(x, y)
        self.edit_live_data.old_row = row
        self.edit_live_data.old_col = col

        self.edit_live_data.calc_new_click_area = false
    else
        row = self.edit_live_data.old_row
        col = self.edit_live_data.old_col
    end

    if row == nil or col == nil then
        return false
    end

    -- cache for shorter access
    local x_p = col[3] and (row[1] or row[2] or row[3])
    local x_m = col[1] and (row[1] or row[2] or row[3])
    local y_p = row[3] and (col[1] or col[2] or col[3])
    local y_m = row[1] and (col[1] or col[2] or col[3])

    local ret_transform_axis = {
        x_p = x_p or (alt_pressed and x_m) or false,
        x_m = x_m or (alt_pressed and x_p) or false,
        y_p = y_p or (alt_pressed and y_m) or false,
        y_m = y_m or (alt_pressed and y_p) or false,
        edge = (col[1] or col[3]) and (row[1] or row[3]),
        direction_x = x_p and 1 or -1,
        direction_y = y_p and 1 or -1,
        move = row[2] and col[2],
    }

    return ret_transform_axis
end

-- @todo the active area should only be changed on mouse click

---
-- Sets the mouse clicked state
-- @param boolean mouse_clicked
-- @param number x
-- @param number y
-- @local
-- @realm client
function HUDELEMENT:SetMouseClicked(mouse_clicked, x, y)
    if self:IsInPos(x, y) then
        self.edit_live_data.calc_new_click_area = mouse_clicked
            or self.edit_live_data.calc_new_click_area
    end
end

---
-- Draws the size of the hud element (borders in red)
-- @local
-- @realm client
function HUDELEMENT:DrawSize()
    local x, y, w, h = self.pos.x, self.pos.y, self.size.w, self.size.h

    surface.SetDrawColor(255, 0, 0, 255)
    surface.DrawLine(x, y, x + w, y) -- top
    surface.DrawLine(x + 1, y + 1, x + w - 1, y + 1) -- top

    surface.DrawLine(x + w, y, x + w, y + h) -- right
    surface.DrawLine(x + w - 1, y + 1, x + w - 1, y + h - 1) -- right

    surface.DrawLine(x, y + h, x + w, y + h) -- bottom
    surface.DrawLine(x + 1, y + h - 1, x + w - 1, y + h - 1) -- bottom

    surface.DrawLine(x, y, x, y + h) -- left
    surface.DrawLine(x + 1, y + 1, x + 1, y + h - 1) -- left

    draw.DrawText(
        self.id,
        "DermaDefault",
        x + w * 0.5,
        y + h * 0.5 - 7,
        COLOR_WHITE,
        TEXT_ALIGN_CENTER
    )
end

---
-- This function is called when an element wants to now its original position.
-- This is the case at @{HUDELEMENT:Reset} and @{HUDELEMENT:Initialize}.
-- You should overwrite this with your own calculated values!
-- @return table basepos, size and minsize fields
-- @realm client
function HUDELEMENT:GetDefaults()
    return {
        basepos = table.Copy(self.basepos),
        size = table.Copy(self.size),
        minsize = table.Copy(self.minsize),
    }
end

---
-- This function uses @{HUDELEMENT:GetDefaults} to reset an element to its
-- original position.
-- @realm client
function HUDELEMENT:Reset()
    local defaults = self:GetDefaults()
    local defaultPos = defaults.basepos
    local defaultSize = defaults.size
    local defaultMinSize = defaults.minsize

    if defaultPos then
        self:SetBasePos(defaultPos.x, defaultPos.y)
    end

    if defaultMinSize then
        self:SetMinSize(defaultMinSize.w, defaultMinSize.h)
    end

    if defaultSize then
        self:SetSize(defaultSize.w, defaultSize.h)
    end

    self:ApplyToChildren("Reset")

    self:PerformLayout()
end

local savingKeys = {
    basepos = { typ = "pos" },
    size = { typ = "size" },
}

---
-- Getter for saving keys
-- @return table with savable keys
-- @realm client
function HUDELEMENT:GetSavingKeys()
    return table.Copy(savingKeys)
end

---
-- Saves the current savingkey values (position, size)
-- @realm client
function HUDELEMENT:SaveData()
    sql.Save("ttt2_hudelements", self.id, self, self:GetSavingKeys())
end

---
-- Loads the saved keys and applies them to the element
-- @realm client
function HUDELEMENT:LoadData()
    local skeys = self:GetSavingKeys()
    local loadedData = {}

    -- load and initialize the elements data from database
    if sql.CreateSqlTable("ttt2_hudelements", skeys) then
        local loaded = sql.Load("ttt2_hudelements", self.id, loadedData, skeys)
        if not loaded then
            sql.Init("ttt2_hudelements", self.id, self, skeys)
        end
    end

    if loadedData.pos then
        self:SetPos(loadedData.pos.x, loadedData.pos.y)

        loadedData.pos = nil
    end

    if loadedData.basepos then
        self:SetBasePos(loadedData.basepos.x, loadedData.basepos.y)

        loadedData.basepos = nil
    end

    if loadedData.size then
        self:SetSize(loadedData.size.w, loadedData.size.h)

        loadedData.size = nil
    end

    for k, v in pairs(loadedData) do
        if v ~= nil then
            self[k] = v
        end
    end
end
