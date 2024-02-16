---
-- @class PANEL
-- @desc Unlike sandbox, we have teams to deal with, so here's an extra panel in the
-- hierarchy that handles a set of player rows belonging to its team.
-- @section TTTScoreGroup

ttt_include("vgui__cl_sb_row")

local strlower = string.lower
local table = table
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local surface = surface
local draw = draw
local vgui = vgui

local PANEL = {}

local cv_ttt_scoreboard_sorting
local cv_ttt_scoreboard_ascending

---
-- @ignore
function PANEL:Init()
    self.name = "Unnamed"
    self.color = COLOR_WHITE
    self.rows = {}
    self.rowcount = 0
    self.rows_sorted = {}
    self.group = "spec"

    cv_ttt_scoreboard_sorting = GetConVar("ttt_scoreboard_sorting")
    cv_ttt_scoreboard_ascending = GetConVar("ttt_scoreboard_ascending")
end

---
-- @param string name
-- @param Color color
-- @param string group
-- @realm client
function PANEL:SetGroupInfo(name, color, group)
    self.name = name
    self.color = color
    self.group = group
end

local bgcolor = Color(20, 20, 20, 150)

---
-- @ignore
function PANEL:Paint()
    -- Darkened background
    draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), bgcolor)

    surface.SetFont("treb_small")

    -- Header bg
    local txt = self.name .. " (" .. self.rowcount .. ")"
    local w, h = surface.GetTextSize(txt)

    draw.RoundedBox(8, 0, 0, w + 24, 20, self.color)

    -- Shadow
    surface.SetTextPos(11, 11 - h * 0.5)
    surface.SetTextColor(0, 0, 0, 200)
    surface.DrawText(txt)

    -- Text
    surface.SetTextPos(10, 10 - h * 0.5)
    surface.SetTextColor(255, 255, 255, 255)
    surface.DrawText(txt)

    -- Alternating row background
    local y = 24

    for i = 1, #self.rows_sorted do
        local row = self.rows_sorted[i]

        if i % 2 ~= 0 then
            surface.SetDrawColor(75, 75, 75, 100)
            surface.DrawRect(0, y, self:GetWide(), row:GetTall())
        end

        y = y + row:GetTall() + 1
    end

    -- Column darkening
    local scr = sboard_panel.ply_frame.scroll.Enabled and 16 or 0

    surface.SetDrawColor(0, 0, 0, 80)

    if sboard_panel.cols then
        local cx = self:GetWide() - scr

        for k, v in ipairs(sboard_panel.cols) do
            cx = cx - v.Width

            if k % 2 == 1 then -- Draw for odd numbered columns
                surface.DrawRect(cx - v.Width * 0.5, 0, v.Width, self:GetTall())
            end
        end
    else
        -- If columns are not setup yet, fall back to darkening the areas for the
        -- default columns
        surface.DrawRect(self:GetWide() - 200 - scr, 0, 50, self:GetTall())
        surface.DrawRect(self:GetWide() - 100 - scr, 0, 50, self:GetTall())
    end
end

---
-- @param Player ply
-- @realm client
function PANEL:AddPlayerRow(ply)
    if ScoreGroup(ply) ~= self.group or self.rows[ply] then
        return
    end

    ---
    -- @realm client
    -- stylua: ignore
    hook.Run("TTT2ScoreboardAddPlayerRow", ply)

    local row = vgui.Create("TTTScorePlayerRow", self)
    row:SetPlayer(ply)

    self.rows[ply] = row
    self.rowcount = table.Count(self.rows)

    -- must force layout immediately or it takes its sweet time to do so
    self:PerformLayout()
end

---
-- @param Player ply
-- @realm client
function PANEL:HasPlayerRow(ply)
    return self.rows[ply] ~= nil
end

---
-- @realm client
function PANEL:HasRows()
    return self.rowcount > 0
end

local function FallbackSort(rowa, rowb)
    return tostring(rowa) < tostring(rowb)
end

local function SortFunc(rowa, rowb)
    if not IsValid(rowa) then
        if IsValid(rowb) then
            return false
        end
        return FallbackSort(rowa, rowb)
    end

    if not IsValid(rowb) then
        return true
    end

    local plya = rowa:GetPlayer()
    local plyb = rowb:GetPlayer()

    if not IsValid(plya) then
        if IsValid(plyb) then
            return false
        end
        return FallbackSort(rowa, rowb)
    end

    if not IsValid(plyb) then
        return true
    end

    local sort_mode = cv_ttt_scoreboard_sorting:GetString()
    local sort_func = _G.sboard_sort[sort_mode]

    local comp

    if isfunction(sort_func) then
        comp = sort_func(plya, plyb)
    end

    if comp == nil then
        comp = 0
    end

    if comp ~= 0 then
        if cv_ttt_scoreboard_ascending:GetBool() then
            return comp < 0
        else
            return comp > 0
        end
    else
        if cv_ttt_scoreboard_ascending:GetBool() then
            return strlower(plya:Nick()) < strlower(plyb:Nick())
        else
            return strlower(plya:Nick()) > strlower(plyb:Nick())
        end
    end
end

---
-- @realm client
function PANEL:UpdateSortCache()
    self.rows_sorted = {}

    for _, row in pairs(self.rows) do
        self.rows_sorted[#self.rows_sorted + 1] = row
    end

    if #self.rows_sorted < 2 then
        return
    end

    table.sort(self.rows_sorted, SortFunc)
end

---
-- @realm client
function PANEL:UpdatePlayerData()
    local to_remove = {}

    for k, v in pairs(self.rows) do
        -- Player still belongs in this group?
        if IsValid(v) and IsValid(v:GetPlayer()) and ScoreGroup(v:GetPlayer()) == self.group then
            v:UpdatePlayerData()
        else
            -- can't remove now, will break pairs
            to_remove[#to_remove + 1] = k
        end
    end

    local remCount = #to_remove

    if remCount == 0 then
        return
    end

    for i = 1, remCount do
        local ply = to_remove[i]
        local pnl = self.rows[ply]

        if IsValid(pnl) then
            pnl:Remove()
        end

        self.rows[ply] = nil
    end

    self.rowcount = table.Count(self.rows)

    self:UpdateSortCache()
    self:InvalidateLayout()
end

---
-- @ignore
function PANEL:PerformLayout()
    if self.rowcount < 1 then
        self:SetVisible(false)

        return
    end

    self:SetSize(self:GetWide(), 30 + self.rowcount + self.rowcount * SB_ROW_HEIGHT)

    -- Sort and layout player rows
    self:UpdateSortCache()

    local y = 24

    for i = 1, #self.rows_sorted do
        local v = self.rows_sorted[i]

        v:SetPos(0, y)
        v:SetSize(self:GetWide(), v:GetTall())

        y = y + v:GetTall() + 1
    end

    self:SetSize(self:GetWide(), 30 + (y - 24))
end

vgui.Register("TTTScoreGroup", PANEL, "Panel")

---
-- Hook that is called for every player on the creation of their row in the
-- scoreboard.
-- @param Player ply The player whose row is created
-- @hook
-- @realm client
function GM:TTT2ScoreboardAddPlayerRow(ply) end
