---
-- @class PANEL
-- @section DDragBaseTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    DDragBase.Init(self)

    self:SetDropPos("2468")

    self.m_iLeftMargin = 0

    local oldMakeDroppable = self.MakeDroppable

    self.MakeDroppable = function(slf, name, allowCopy)
        slf.dropGroupName = name

        oldMakeDroppable(slf, name, allowCopy)
    end
end

---
-- Sets the size of the moveable children
-- @param[default=64] number w The width
-- @param[default=64] number h The height
-- @realm client
function PANEL:SetChildSize(w, h)
    self.childW = w
    self.childH = h
end

---
-- @return number The child width
-- @return number The child height
-- @realm client
function PANEL:GetChildSize()
    return self.childW or 64, self.childH or 64
end

---
-- @return number The left margin
-- @realm client
function PANEL:GetLeftMargin()
    return self.m_iLeftMargin
end

---
-- @param[default=0] number leftMargin The left margin
-- @realm client
function PANEL:SetLeftMargin(leftMargin)
    self.m_iLeftMargin = leftMargin
end

---
-- Gets the valid children that should be dragable
-- @return table A table of valid children (@{PANEL})
-- @realm client
function PANEL:GetDnDs()
    return {}
end

---
-- @param number x
-- @param number y
-- @return number
-- @realm client
function PANEL:GetDropMode(x, y)
    local closest = self:GetClosestChild(x, y)

    local h = closest:GetTall()
    local w = closest:GetWide()

    local disty = y - (closest.y + h * 0.5)
    local distx = x - (closest.x + w * 0.5)

    local drop = 0

    if self.bDropCenter then
        drop = 5
    end

    if disty < 0 and self.bDropTop and (drop == 0 or math.abs(disty) > h * 0.1) then
        drop = 8
    end

    if disty >= 0 and self.bDropBottom and (drop == 0 or math.abs(disty) > h * 0.1) then
        drop = 2
    end

    if distx < 0 and self.bDropLeft and (drop == 0 or math.abs(distx) > w * 0.1) then
        drop = 4
    end

    if distx >= 0 and self.bDropRight and (drop == 0 or math.abs(distx) > w * 0.1) then
        drop = 6
    end

    return drop
end

---
-- @param table drops
-- @param boolean bDoDrop
-- @param string command
-- @param number x
-- @param number y
-- @realm client
function PANEL:DropAction_Normal(drops, bDoDrop, command, x, y)
    local closest = self:GetClosestChild(x, y)

    if not IsValid(closest) then
        return self:DropAction_Simple(drops, bDoDrop, command, x, y)
    end

    -- This panel is only meant to be copied from, not edited
    if self:GetReadOnly() then
        return
    end

    local drop = self:GetDropMode(x, y)

    if not self:OnDropChildCheck(closest, drop) then
        return
    end

    self:UpdateDropTarget(drop, closest)

    if
        table.HasValue(drops, closest)
        or not bDoDrop and not self:GetUseLiveDrag()
        or #drops < 1
    then
        return
    end

    -- This keeps the drop order the same, whether we add it before an object or after
    if drop == 6 or drop == 2 then
        drops = table.Reverse(drops)
    end

    for i = 1, #drops do
        local v = drops[i]

        -- Don't drop one of our parents onto us because we'll be sucked into a vortex
        if v:IsOurChild(self) then
            continue
        end

        -- Copy the panel if we are told to from the DermaMenu(), or if we are moving from a read only panel to a not read only one.
        if
            v.Copy
            and (
                command and command == "copy"
                or (
                    IsValid(v:GetParent())
                    and v:GetParent().GetReadOnly
                    and v:GetParent():GetReadOnly()
                    and v:GetParent():GetReadOnly() ~= self:GetReadOnly()
                )
            )
        then
            v = v:Copy()
        end

        v = v:OnDrop(self)

        if drop == 5 then
            closest:DroppedOn(v)
        end

        if drop == 8 or drop == 4 then
            v:SetParent(self)
            v:MoveToBefore(closest)
        end

        if drop == 2 or drop == 6 then
            v:SetParent(self)
            v:MoveToAfter(closest)
        end

        self:OnDropped(v, drop, closest)
    end

    self:OnModified()
end

---
-- Callback that checks if dropping on this child should be possible.
-- @param PANEL closestChild
-- @param number direct
-- @return boolean
-- @realm client
function PANEL:OnDropChildCheck(closestChild, direction)
    return true
end

---
-- Callback that is called after the panel was dropped.
-- @param PANEL droppedPnl
-- @param number pos
-- @param PANEL closestPnl
-- @realm client
function PANEL:OnDropped(droppedPnl, pos, closestPnl) end

derma.DefineControl("DDragBaseTTT2", "", PANEL, "DIconLayout")
