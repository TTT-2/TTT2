---
-- @class PANEL
-- @section DPiPPanelTTT2

local PANEL = {}

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "Padding", "Padding", FORCE_NUMBER)
---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "innerPadding", "InnerPadding", FORCE_NUMBER)
---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "pipOuterOffset", "OuterOffset", FORCE_NUMBER)

---
-- @ignore
function PANEL:Init()
    self:SetPadding(0)
    self:SetInnerPadding(2)
    self:SetOuterOffset(0)

    self.mainPanel = nil
    self.subPanels = {}
end

---
-- Adds a child panel. The first such panel is the "main" panel, and appears larger than the others. All others are positioned over the main, according to their alignment.
-- @param Panel|string|table pnl The panel to add. If it is an actual panel, added directly. Otherwise, the name/table of a panel to create.
-- @param DOCK ... Alignment. Only LEFT, RIGHT, TOP, and BOTTOM are valid. The first specified direction specifies the preferred axis (the axis along which it will be moved to prevent overlap).
-- @return The added panel.
-- @realm client
function PANEL:Add(pnl, ...)
    local realPnl
    if ispanel(pnl) then
        realPnl = pnl
        pnl:SetParent(self)
    elseif istable(pnl) then
        realPnl = vgui.CreateFromTable(pnl, self)
    else
        realPnl = vgui.Create(pnl, self)
    end

    if self.mainPanel == nil then
        -- the first panel added becomes the main panel
        self.mainPanel = realPnl
        self:InvalidateLayout()
        return realPnl
    end

    -- later panels become sub-panels
    self.subPanels[#self.subPanels + 1] = {
        pnl = realPnl,
        align = { ... },
    }

    self:InvalidateLayout()
    self:InvalidateChildren()

    return realPnl
end

---
-- Clears this panel.
-- @realm client
function PANEL:Clear()
    if self.mainPanel then
        self.mainPanel:Remove()
        self.mainPanel = nil
    end
    for _, pnl in pairs(self.subPanels) do
        pnl.pnl:Remove()
    end
    self.subPanels = {}
end

local function RectsOverlap(r1, r2)
    local x11, y11 = r1.x, r1.y
    local x12, y12 = r1.x + r1.w, r1.y + r1.h
    local x21, y21 = r2.x, r2.y
    local x22, y22 = r2.x + r2.w, r2.y + r2.h

    -- take the max/min coords, if width or height is negative there is no overlap
    local xn1 = math.max(x11, x21)
    local yn1 = math.max(y11, y21)
    local xn2 = math.min(x12, x22)
    local yn2 = math.min(y12, y22)

    -- note that exact edge meets are considered overlaps for this
    return xn2 >= xn1 and yn2 >= yn1
end

local axisX = 1
local axisY = 2
local axisCoordTbl = {
    [axisX] = "x",
    [axisY] = "y",
}
local axisSizeTbl = {
    [axisX] = "w",
    [axisY] = "h",
}

---
-- @ignore
function PANEL:PerformLayout()
    local mainPanel = self.mainPanel
    if not IsValid(mainPanel) then
        -- no main panel, nothing to actually layout
        return
    end

    local mw, mh = mainPanel:GetSize()
    local padding = self:GetPadding()
    local innerPadding = self:GetInnerPadding()
    local outerOffset = self:GetOuterOffset()

    -- we can't immediately set our own size or the main panel's position because we
    -- need to look at the sub-panels first
    local leftBound = -padding
    local rightBound = mw + padding
    local topBound = -padding
    local bottomBound = mh + padding

    -- subpanel positions relative to the TL corner of the main panel
    -- stores panel->hitbox index
    -- need this because we need to go through the subpanels to determine where the
    -- main panel will go
    local subPnlRelPos = {}
    local subPnlHitboxes = {}

    for i, pnl in ipairs(self.subPanels) do
        -- align center is 0, 0; -1 = left/top, +1 = right/bottom
        local alignx, aligny = 0, 0

        local preferAxis = 0 -- the preferred direction; the first one provided

        if istable(pnl.align) then
            -- loop through the alignments to identify it
            for _, align in ipairs(pnl.align) do
                local axis = 0
                if align == TOP then
                    axis = axisY
                    aligny = -1
                elseif align == BOTTOM then
                    axis = axisY
                    aligny = 1
                elseif align == LEFT then
                    axis = axisX
                    alignx = -1
                elseif align == RIGHT then
                    axis = axisX
                    alignx = 1
                end

                if axis ~= 0 and preferAxis == 0 then
                    preferAxis = axis
                end
            end
        end

        -- if no alignment axis was specified, use the X axis
        if preferAxis == 0 then
            preferAxis = axisX
        end

        -- we now have a usable understanding of the alignment request

        -- time to figure out where to put the subpanel
        local pw, ph = pnl.pnl:GetSize()

        -- start with the preferred position
        -- outermost corner/edge
        local outerx = (mw / 2) + alignx * (mw / 2)
        local outery = (mh / 2) + aligny * (mh / 2)
        -- then adjust because we need the top-left corner always
        local x = outerx - ((alignx + 1) * (pw / 2))
        local y = outery - ((aligny + 1) * (ph / 2))
        -- then adjust according to the outerOffset
        x = x + alignx * outerOffset
        y = y + aligny * outerOffset

        local rect = { x = x, y = y, w = pw, h = ph }

        -- now that we've used the alignment properly, make sure the axes are nonzero
        -- so that our preferred axis move actually moves it
        if alignx == 0 then
            alignx = -1
        end
        if aligny == 0 then
            aligny = -1
        end

        local paxisCoord = axisCoordTbl[preferAxis]
        local paxisSize = axisSizeTbl[preferAxis]
        local paxisAlign = preferAxis == axisX and alignx or aligny

        -- now that we have our target rectangle, check for intersections against all
        -- existing rectangles and adjust along the preferred axis to not overlap
        for j = 1, #subPnlHitboxes do
            local box = subPnlHitboxes[j]

            if RectsOverlap(rect, box) then
                -- overlap, move rect to be non-overlapping along the target axis

                -- to do so, we first set the relevant axis to the box
                rect[paxisCoord] = box[paxisCoord]

                -- then, we adjust position by the width accodring to the align value
                rect[paxisCoord] = rect[paxisCoord]
                    + -paxisAlign * ((paxisAlign < 0 and box or rect)[paxisSize] + innerPadding)
            end
        end

        -- we now have a good position for this item, update the bounds
        leftBound = math.min(leftBound, rect.x)
        rightBound = math.max(rightBound, rect.x + rect.w)
        topBound = math.min(topBound, rect.y)
        bottomBound = math.max(bottomBound, rect.y + rect.h)

        -- and add the box and panel entry
        subPnlHitboxes[#subPnlHitboxes + 1] = rect
        subPnlRelPos[pnl.pnl] = #subPnlHitboxes
    end

    -- we now know how to position and size everything, so do that
    local mainx, mainy = -leftBound, -topBound
    self:SetSize(rightBound - leftBound, bottomBound - topBound)
    mainPanel:SetPos(mainx, mainy)

    for pnl, recti in pairs(subPnlRelPos) do
        local rect = subPnlHitboxes[recti]
        pnl:SetPos(mainx + rect.x, mainy + rect.y)
    end
end

derma.DefineControl("DPiPPanelTTT2", "A panel-in-panel panel.", PANEL, "DPanelTTT2")
