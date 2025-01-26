---
-- @class PANEL
-- @section DComboCardTTT2

local PANEL = {}

local TryT = LANG.TryTranslation

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "font", "Font", FORCE_STRING)
---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "title", "Title", FORCE_STRING)
---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "sortMode", "SortMode", FORCE_NUMBER)
---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "padding", "Padding", FORCE_NUMBER)
---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "minWidth", "MinWidth", FORCE_NUMBER)

GRAPH_SORT_MODE_NONE = 0
GRAPH_SORT_MODE_HIGHLIGHT_ORDER = 1
GRAPH_SORT_MODE_VALUE_ASC = 2
GRAPH_SORT_MODE_VALUE_DESC = 3
GRAPH_SORT_MODE_PLAYER_NAME = 4
local GRAPH_SORT_MODE_MAX = 4

local graphSortModeNames = {
    [GRAPH_SORT_MODE_NONE] = "graph_sort_mode_none",
    [GRAPH_SORT_MODE_HIGHLIGHT_ORDER] = "graph_sort_mode_highlight_order",
    [GRAPH_SORT_MODE_VALUE_ASC] = "graph_sort_mode_value_asc",
    [GRAPH_SORT_MODE_VALUE_DESC] = "graph_sort_mode_value_desc",
    [GRAPH_SORT_MODE_PLAYER_NAME] = "graph_sort_mode_player_name",
}

---
-- @ignore
function PANEL:Init()
    self.players = {}
    self:SetTitle("")
    self:SetFont("DermaTTT2TitleSmall")
    self:SetSortMode(GRAPH_SORT_MODE_NONE)

    self.button = nil
    self:AllowUserSort(true)

    self:SetPadding(5)
    self:SetMinWidth(100)
end

---
-- Gets or sets whether this pannel allows user-controlled sort mode.
-- @param nil|boolean allow Whether to allow user sorting. If nil, no change is made.
-- @return boolean Whether user sorting is currently allowed.
-- @realm client
function PANEL:AllowUserSort(allow)
    if allow == nil then
        return self.allowUserSort
    end
    self.allowUserSort = allow

    if allow then
        if not self.button then
            self.button = vgui.Create("DButtonTTT2", self)
            self.button.DoClick = function(slf)
                -- cycle between the sort modes
                local mode = self.sortMode + 1
                if mode > GRAPH_SORT_MODE_MAX then
                    mode = GRAPH_SORT_MODE_NONE
                end
                self.sortMode = mode
                self:InvalidateLayout()
            end
        end
    else
        if self.button then
            self.button:Clear()
            self.button:SetParent(nil)
            self.button = nil
        end
    end

    return allow
end

---
-- Adds a player to the graph.
-- @param Player ply The player to add.
-- @param number value The value associated with the player.
-- @param nil|boolean highlight Whether the player should be highlighted. Defaults to false.
-- @realm client
function PANEL:AddPlayer(ply, value, highlight)
    local plyIcon = vgui.Create("SimpleIconAvatar", self)
    plyIcon:SetPlayer(ply)
    plyIcon:SetTooltip(ply:GetName())
    plyIcon:SetMouseInputEnabled(true)

    self.players[#self.players + 1] = {
        player = ply,
        value = value,
        highlight = highlight or false,
        icon = plyIcon,
    }

    self:InvalidateLayout()
end

---
-- Clears the graph.
-- @realm client
function PANEL:Clear()
    self.players = {}
    local lastUserSort = self:AllowUserSort()
    self:AllowUserSort(false)
    local children = self:GetChildren()
    for i = 1, #children do
        children[i]:Remove()
    end
    self:AllowUserSort(lastUserSort)
    self:InvalidateLayout()
end

---
-- @ignore
function PANEL:PerformLayout()
    local order = {}
    local orderFn

    for _, data in pairs(self.players) do
        order[#order + 1] = { data = data, x = 0, y = 0, w = 0, h = 0, valueWidth = 0 }
    end

    if self.sortMode == GRAPH_SORT_MODE_NONE then
        -- no need for special sorting
        orderFn = nil
    elseif self.sortMode == GRAPH_SORT_MODE_HIGHLIGHT_ORDER then
        -- put the highlighted values first
        orderFn = function(a, b)
            return a.data.highlight and not b.data.highlight
        end
    elseif self.sortMode == GRAPH_SORT_MODE_VALUE_ASC then
        -- but low-valued entries first
        orderFn = function(a, b)
            return a.data.value < b.data.value
        end
    elseif self.sortMode == GRAPH_SORT_MODE_VALUE_DESC then
        -- but high-valued entries first
        orderFn = function(a, b)
            return a.data.value > b.data.value
        end
    elseif self.sortMode == GRAPH_SORT_MODE_PLAYER_NAME then
        -- sort by player name
        orderFn = function(a, b)
            return string.upper(a.data.player:GetName()) < string.upper(b.data.player:GetName())
        end
    end

    if orderFn then
        table.sort(order, orderFn)
    end

    -- now we have the order, lets compute positioning

    local padding = self:GetPadding()

    local fontHeight = draw.GetFontHeight(self:GetFont())

    local y = padding
    local w = math.max(padding + self:GetMinWidth() + padding, self:GetWide())

    local titleX = 0
    local titleY = 0
    local sepY = nil

    -- first the tile space
    if self.button then
        local txt = TryT(graphSortModeNames[self.sortMode])
        self.button:SetText(txt)
        local tw, th = draw.GetTextSize(string.upper(txt), self.button:GetFont())
        self.button:SetSize(tw + 8, th + 4)
    end

    if self.title ~= "" then
        local titleHeight = fontHeight
        local tw, th = draw.GetTextSize(TryT(self.title), self:GetFont())
        titleX = padding
        titleY = y
        titleHeight = math.max(titleHeight, th)
        w = math.max(w, tw + padding)
        if self.button then
            self.button:SetPos(padding + tw, y)
            local bw, bh = self.button:GetSize()
            w = math.max(w, tw + padding + bw + padding)
            titleHeight = math.max(titleHeight, bh)
        end

        y = y + titleHeight + padding
    elseif self.button then
        self.button:SetPos(padding, y)
        local bw, bh = self.button:GetSize()
        w = math.max(w, bw + padding)
        y = y + bh + padding
    end

    -- next space out the graph rows
    local maxValue
    for i = 1, #order do
        local data = order[i]

        data.x = padding + fontHeight + padding -- this is the position of the actual bar
        data.y = y
        data.h = fontHeight
        data.data.icon:SetAvatarSize(fontHeight)
        data.data.icon:SetIconSize(fontHeight, fontHeight)
        data.data.icon:SetSize(fontHeight, fontHeight)
        data.data.icon:SetPos(padding, y)

        maxValue = isnumber(maxValue) and math.max(maxValue, data.data.value) or data.data.value

        local vw, vh = draw.GetTextSize(tostring(data.data.value))
        data.h = math.max(data.h, vh)
        data.valueWidth = vw
        -- we'll set width later, after we know the overall width, so we can know how much width to use for the bar

        w = math.max(w, data.x + vw + padding)

        y = y + data.h + padding
    end

    -- width includes padding on both sides already, so we can set our size
    self:SetSize(w, y)
    for i = 1, #order do
        local data = order[i]

        local proportionOfMax = data.data.value / maxValue
        local avail = w - padding - data.x
        -- now set the bar width
        data.w = proportionOfMax * avail
        data.pofmax = proportionOfMax
        data.avail = avail
    end

    -- record accumulated render data for the playergraph renderer
    self.renderData = {
        titleX = titleX,
        titleY = titleY,
        sepY = sepY,
        order = order,
    }
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "PlayerGraphTTT2", self, w, h)

    return true
end

derma.DefineControl("DPlayerGraphTTT2", "", PANEL, "DPanelTTT2")
