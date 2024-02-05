---
-- A much requested darker scoreboard
-- @section scoreboard_manager

ttt_include("vgui__cl_sb_main")

sboard_panel = nil

local function ScoreboardRemove()
    if not sboard_panel then
        return
    end

    sboard_panel:Remove()

    sboard_panel = nil
end
hook.Add("TTTLanguageChanged", "RebuildScoreboard", ScoreboardRemove)

---
-- Called before (re)creating the scoreboard
-- @hook
-- @realm client
function GM:ScoreboardCreate()
    ScoreboardRemove()

    sboard_panel = vgui.Create("TTTScoreboard")
end

---
-- Called when player presses the scoreboard button (TAB by default).
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ScoreboardShow
-- @local
function GM:ScoreboardShow()
    self.ShowScoreboard = true

    if not sboard_panel then
        self:ScoreboardCreate()
    end

    gui.EnableScreenClicker(true)

    sboard_panel:SetVisible(true)
    sboard_panel:UpdateScoreboard(true)
    sboard_panel:StartUpdateTimer()
end

---
-- Called when player released the scoreboard button (TAB by default).
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ScoreboardHide
-- @local
function GM:ScoreboardHide()
    self.ShowScoreboard = false

    gui.EnableScreenClicker(false)

    if not sboard_panel then
        return
    end

    sboard_panel:SetVisible(false)
end

---
-- Returns the current stored scoreboard
-- @return Panel
-- @hook
-- @realm client
function GM:GetScoreboardPanel()
    return sboard_panel
end

---
-- Called every frame to render the scoreboard.<br />
-- It is recommended to use Derma and VGUI for this job instead of this hook.
-- Called right after @{GM:HUDPaint}.
-- @note Called every frame to render the scoreboard.
-- @2D
-- @hook
-- @realm client
-- @local
function GM:HUDDrawScoreBoard()
    -- replaced by panel version
end
