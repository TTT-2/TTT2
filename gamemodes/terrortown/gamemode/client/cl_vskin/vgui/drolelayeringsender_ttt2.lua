---
-- @class PANEL
-- @section DRoleLayeringSenderTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    DIconLayout.Init(self)

    self.cachedTable = {}
    self.m_iPadding = 0
    self.m_iLeftMargin = 0
end

---
-- @return number
-- @realm client
function PANEL:GetPadding()
    return self.m_iPadding
end

---
-- @param[default=0] number padding
-- @realm client
function PANEL:SetPadding(padding)
    self.m_iPadding = padding
end

---
-- @return number
-- @realm client
function PANEL:GetLeftMargin()
    return self.m_iLeftMargin
end

---
-- @param[default=0] number leftMargin
-- @realm client
function PANEL:SetLeftMargin(leftMargin)
    self.m_iLeftMargin = leftMargin
end

---
-- Gets the valid children that should be dragable
-- @return table A table of valid children (@{PANEL})
-- @realm client
function PANEL:GetDnDs()
    local children = self:GetChildren()
    local validChildren = {}

    for i = 1, #children do
        local child = children[i]

        -- not a valid child with a subrole, skip
        if not child.subrole then
            continue
        end

        validChildren[#validChildren + 1] = child
    end

    return validChildren
end

---
-- @param PANEL receiverPnl
-- @realm client
function PANEL:SetReceiver(receiverPnl)
    self.receiverPnl = receiverPnl
end

---
-- @realm client
function PANEL:OnModified()
    if not IsValid(self.receiverPnl) then
        return
    end

    local children = self:GetDnDs()

    for i = 1, #children do
        local child = children[i]

        -- already cached, skipping
        if self.cachedTable[child.subrole] then
            continue
        end

        -- remove from layer
        local dropLayer, dropDepth = self.receiverPnl:GetLayerAndDepthOfSubrole(child.subrole)

        -- not contained in layer
        if dropLayer == nil then
            continue
        end

        local layerList = self.receiverPnl:GetLayers()

        -- remove dropped panel from old position
        table.remove(layerList[dropLayer], dropDepth)

        -- clear old layer if empty
        if #layerList[dropLayer] < 1 then
            table.remove(layerList, dropLayer)
        end
    end

    -- update receiver
    self.receiverPnl:OnModified()
    self.receiverPnl:InvalidateLayout()

    -- update cache
    self.cachedTable = {}

    for i = 1, #children do
        local child = children[i]

        -- not a valid child with a subrole, skip
        if not child.subrole then
            continue
        end

        if not self.cachedTable[child.subrole] then
            self.cachedTable[child.subrole] = true
        end
    end

    self:InvalidateLayout()
end

---
-- @ignore
function PANEL:PerformLayout(width, height)
    local w = self:GetWide()
    local childW, childH = self:GetChildSize()

    local children = self:GetDnDs()

    local xStart = self:GetLeftMargin() + self.m_iPadding
    local x = xStart
    local row = 0

    for i = 1, #children do
        local child = children[i]

        if not IsValid(child) or not child:IsVisible() then
            continue
        end

        child:SetPos(x, self.m_iPadding + row * (childH + self.m_iPadding))

        if isfunction(child.ApplySchemeSettings) then
            child:ApplySchemeSettings()
        end

        -- skip to next row if row is full
        local xNext = x + child:GetWide() + self.m_iPadding

        if xNext + childW > w and i < #children then
            row = row + 1
            x = xStart
        else
            x = xNext
        end
    end

    self:SetTall((row + 1) * childH + (row + 2) * self.m_iPadding)
end

---
-- Callback that checks if dropping on this child should be possible.
-- @param PANEL closestChild
-- @param number direct
-- @return boolean
-- @realm client
function PANEL:OnDropChildCheck(closestChild, direction)
    if #self:GetDnDs() == 0 and direction == 6 then
        return true
    else
        return closestChild.subrole ~= nil
    end
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "RoleLayeringSenderTTT2", self, w, h)

    return true
end

derma.DefineControl("DRoleLayeringSenderTTT2", "", PANEL, "DDragBaseTTT2")
