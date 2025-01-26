---
-- @class PANEL
-- @section DRoleLayeringReceiverTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    DDragBaseTTT2.Init(self)

    self.layerList = {}
    self.layerBoxes = {}

    self.m_iPadding = 5
end

---
-- @param[default=5] number padding
-- @realm client
function PANEL:SetPadding(padding)
    self.m_iPadding = padding
end

---
-- Callback that is called after the panel was dropped.
-- @param PANEL droppedPnl
-- @param number pos
-- @param PANEL closestPnl
-- @realm client
function PANEL:OnDropped(droppedPnl, pos, closestPnl)
    local dropLayer, dropDepth = self:GetLayerAndDepthOfSubrole(droppedPnl.subrole)

    if dropLayer then
        -- remove dropped panel from old position
        table.remove(self.layerList[dropLayer], dropDepth)

        -- clear old layer if empty
        if #self.layerList[dropLayer] < 1 then
            table.remove(self.layerList, dropLayer)
        end
    end

    if pos == 6 or pos == 4 then -- right or left
        local newLayer, newDepth = self:GetLayerAndDepthOfSubrole(closestPnl.subrole)

        -- insert dropped panel into the existing layer
        table.insert(
            self.layerList[newLayer],
            pos == 4 and newDepth or newDepth + 1,
            droppedPnl.subrole
        )
    elseif pos == 8 or pos == 2 then -- top or bottom
        local newLayer = self:GetLayerAndDepthOfSubrole(closestPnl.subrole)

        -- insert dropped panel into a new layer
        table.insert(self.layerList, pos == 8 and newLayer or newLayer + 1, { droppedPnl.subrole })
    end

    if not IsValid(self.senderPnl) then
        return
    end

    -- remove from sender's cached list
    self.senderPnl.cachedTable[droppedPnl.subrole] = nil
end

---
-- @realm client
function PANEL:OnModified()
    -- needed if the first element is dropped from sender's cached list
    local children = self:GetDnDs()
    local layerCount = #self:GetLayers()

    if #children == 1 and layerCount == 0 then
        local droppedPnl = children[1]

        -- insert dropped panel into a new layer
        self.layerList[1] = { droppedPnl.subrole }

        if not IsValid(self.senderPnl) then
            return
        end

        -- remove from sender's cached list
        self.senderPnl.cachedTable[droppedPnl.subrole] = nil

        layerCount = 1
    end

    self:OnLayerUpdated()
end

---
-- @param table tbl
-- @realm client
function PANEL:SetLayers(tbl)
    self.layerList = tbl
end

---
-- @return table
-- @realm client
function PANEL:GetLayers()
    return self.layerList
end

---
-- @param number subrole
-- @return number
-- @return number
-- @realm client
function PANEL:GetLayerAndDepthOfSubrole(subrole)
    for layer = 1, #self.layerList do
        local currentLayerTable = self.layerList[layer]

        for depth = 1, #currentLayerTable do
            if currentLayerTable[depth] ~= subrole then
                continue
            end

            return layer, depth
        end
    end
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
-- @ignore
function PANEL:PerformLayout(width, height)
    local w = self:GetWide()
    local childW, childH = self:GetChildSize()

    local children = self:GetDnDs()

    local xStart = self:GetLeftMargin() + self.m_iPadding
    local x = xStart
    local y = self.m_iPadding

    local sortedChildren = {}

    self.layerBoxes = {}

    -- pre sort children so the rendering part is easier
    for i = 1, #children do
        local child = children[i]
        local layer, depth = self:GetLayerAndDepthOfSubrole(child.subrole)

        if not layer or not depth then
            continue
        end

        sortedChildren[layer] = sortedChildren[layer] or {}
        sortedChildren[layer][depth] = child
    end

    for i = 1, #sortedChildren do
        local layerChildren = sortedChildren[i]

        local yRow = y

        y = y + self.m_iPadding

        for k = 1, #layerChildren do
            local child = layerChildren[k]

            child:SetPos(x, y)

            -- skip to next row if row is full
            local xNext = x + child:GetWide() + self.m_iPadding

            if xNext + childW > w and k < #layerChildren then
                y = y + childH + self.m_iPadding
                x = xStart
            else
                x = xNext
            end
        end

        x = xStart
        y = y + (childH + self.m_iPadding)

        self.layerBoxes[i] = {
            y = yRow,
            h = y - yRow,
            label = yRow + 0.5 * (y - yRow),
        }

        y = y + self.m_iPadding
    end

    self:SetTall(y)
end

---
-- @param table layeredRoles
-- @realm client
function PANEL:InitRoles(layeredRoles)
    self:SetLayers(layeredRoles)

    local layerCount = #layeredRoles

    for layer = 1, layerCount do
        local currentLayerTable = layeredRoles[layer]

        for i = 1, #currentLayerTable do
            local subrole = currentLayerTable[i]
            local roleData = roles.GetByIndex(subrole)

            -- create the role icon
            local ic = vgui.Create("DRoleImageTTT2", self)
            ic:SetSize(64, 64)
            ic:SetMaterial(roleData.iconMaterial)
            ic:SetColor(roleData.color)
            ic:SetTooltip(roleData.name)
            ic:SetTooltipFixedPosition(0, 64)
            ic:SetServerConVar("ttt_" .. roleData.name .. "_enabled")
            ic:SetIsActiveIndicator(true)

            ic.subrole = subrole

            ic:Droppable(self.dropGroupName)

            self:Add(ic)
        end
    end
end

---
-- @param PANEL senderPnl
-- @realm client
function PANEL:SetSender(senderPnl)
    self.senderPnl = senderPnl
end

---
-- @return PANEL
-- @realm client
function PANEL:GetSender()
    return self.senderPnl
end

---
-- @param PANEL closestChild
-- @return boolean
-- @realm client
function PANEL:OnDropChildCheck(closestChild)
    return closestChild.subrole ~= nil
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "RoleLayeringReceiverTTT2", self, w, h)

    return true
end

derma.DefineControl("DRoleLayeringReceiverTTT2", "", PANEL, "DDragBaseTTT2")
