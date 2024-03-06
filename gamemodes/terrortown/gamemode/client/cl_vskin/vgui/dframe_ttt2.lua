---
-- @class PANEL
-- @section DFrameTTT2

local PANEL = {}

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDraggable", "Draggable", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bSizable", "Sizable", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bScreenLock", "ScreenLock", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDeleteOnClose", "DeleteOnClose", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bPaintShadow", "PaintShadow", FORCE_BOOL)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iMinWidth", "MinWidth", FORCE_NUMBER)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iMinHeight", "MinHeight", FORCE_NUMBER)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBackgroundBlur", "BackgroundBlur", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
    self:SetFocusTopLevel(true)
    self:SetPaintShadow(true)

    self:InitButtons()

    self:SetDraggable(true)
    self:SetSizable(false)
    self:SetScreenLock(false)
    self:SetDeleteOnClose(true)

    self:SetMinWidth(50)
    self:SetMinHeight(50)

    -- This turns off the engine drawing
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)

    self:SetVisible(true)
    self:SetDraggable(true)
    self:ShowCloseButton(true)
    self:ShowBackButton(false)
    self:SetDeleteOnClose(true)
    self:SetBackgroundBlur(false)
    self:SetSkin("ttt2_default")

    self:MakePopup()
    self:SetKeyboardInputEnabled(false)

    self.m_fCreateTime = SysTime()

    self.title = {
        text = "Window",
        font = "DermaTTT2Title",
    }

    self:SetPadding(5, 5, 5, 5)

    self.panelData = {
        hidden = false,
        deleteOnClose = true,
        callbacks = {},
    }
end

---
-- Function to hide a frame without deleting the panel data.
-- @realm client
function PANEL:HideFrame()
    if self:IsFrameHidden() then
        return
    end

    if isfunction(self.OnHide) and self:OnHide() == false then
        return
    end

    self.panelData.hidden = true
    self.panelData.deleteOnClose = self:GetDeleteOnClose()

    self:SetDeleteOnClose(false)
    self:Close()
end

---
-- Function to unhide a previously hidden frame.
-- @realm client
function PANEL:ShowFrame()
    if not self:IsFrameHidden() then
        return
    end

    if isfunction(self.OnShow) and self:OnShow() == false then
        return
    end

    self.panelData.hidden = false

    self:SetDeleteOnClose(self.panelData.deleteOnClose)
    self:SetVisible(true)
end

---
-- Returns if a frame is hidden.
-- @return boolean Returns if this frame is hidden
-- @realm client
function PANEL:IsFrameHidden()
    return self.panelData.hidden
end

---
-- Checks if a visible frame should block TTT2 Binds
-- @return boolean Returns if this frame blocks TTT2 Binds
-- @realm client
function PANEL:IsBlockingBindings()
    return true
end

---
-- Clears the contents of this frame.
-- @note If a new size is given, the position of the frame is reset
-- @param[opt] number w The new width
-- @param[opt] number h The new height
-- @param[opt] string title The new title
-- @realm client
function PANEL:ClearFrame(w, h, title)
    if isfunction(self.OnClear) and self:OnClear() == false then
        return
    end

    local oldW, oldH = self:GetSize()
    local oldTitle = self:GetTitle()

    self:Clear()
    self:InitButtons()
    self:ShowBackButton(false)

    if (w and w ~= oldW) or (h and h ~= oldH) then
        self:SetSize(w or oldW, h or oldH)
        self:Center()
    end

    if title ~= oldTitle then
        self:SetTitle(title or oldTitle)
    end
end

---
-- Closes the frame.
-- @realm client
function PANEL:CloseFrame()
    self:SetDeleteOnClose(true)
    self:Close()
end

---
-- Function that is called when the frame is hidden, return false to cancel event.
-- @return boolean Return false to cancel this event
-- @hook
-- @realm client
function PANEL:OnHide() end

---
-- Function that is called when the frame is unhidden, return false to cancel event.
-- @return boolean Return false to cancel this event
-- @hook
-- @realm client
function PANEL:OnShow() end

---
-- Function that is called when the frame is rebuild
-- @hook
-- @realm client
function PANEL:OnRebuild() end

---
-- Function that is called when the frame is about to be cleared, return false to cancel event.
-- @return boolean Return false to cancel this event
-- @hook
-- @realm client
function PANEL:OnClear() end

---
-- Initializes the buttons
-- @realm client
function PANEL:InitButtons()
    -- add close button
    self.btnClose = vgui.Create("DButtonTTT2", self)
    self.btnClose:SetText("")
    self.btnClose:SetVisible(true)

    self.btnClose.DoClick = function(button)
        self:Close()
    end

    self.btnClose.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
    end

    -- add back button
    self.btnBack = vgui.Create("DButtonTTT2", self)
    self.btnBack:SetText("")
    self.btnBack:SetVisible(true)

    self.btnBack.DoClick = function(button) end

    self.btnBack.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "WindowBackButton", panel, w, h)
    end
end

---
-- @param string strTitle
-- @realm client
function PANEL:SetTitle(strTitle)
    self.title.text = strTitle
end

---
-- @return string
-- @realm client
function PANEL:GetTitle()
    return self.title.text
end

---
-- @param string fontName
-- @realm client
function PANEL:SetTitleFont(fontName)
    self.title.font = fontName
end

---
-- @return string
-- @realm client
function PANEL:GetTitleFont()
    return self.title.font
end

---
-- @param number left
-- @param number top
-- @param number right
-- @param number bottom
-- @realm client
function PANEL:SetPadding(left, top, right, bottom)
    self.padding = {
        left = left,
        top = top,
        right = right,
        bottom = bottom,
    }

    self:UpdatePadding()
end

---
-- @realm client
function PANEL:UpdatePadding()
    self:DockPadding(
        self.padding.left,
        vskin.GetHeaderHeight() + vskin.GetBorderSize() + self.padding.top,
        self.padding.right,
        self.padding.bottom
    )
end

---
-- @param boolean bShow
-- @realm client
function PANEL:ShowCloseButton(bShow)
    self.btnClose:SetVisible(bShow)
end

---
-- @param function fn
-- @realm client
function PANEL:CloseButtonClickOverride(fn)
    if not IsValid(self.btnClose) or not isfunction(fn) then
        return
    end

    self.btnClose.DoClick = function(button)
        fn(button)
    end
end

---
-- @param boolean bShow
-- @realm client
function PANEL:ShowBackButton(bShow)
    self.btnBack:SetVisible(bShow)
end

---
-- Sets a callback function that is called when
-- when the back button is clicked
-- @param function fn The callback function
-- @realm client
function PANEL:RegisterBackFunction(fn)
    self.btnBack.DoClick = fn
end

---
-- @realm client
function PANEL:Close()
    self:SetVisible(false)

    if self:GetDeleteOnClose() then
        self:Remove()
    end

    self:OnClose()
end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:OnClose() end

---
-- @realm client
function PANEL:Center()
    self:InvalidateLayout(true)
    self:CenterVertical()
    self:CenterHorizontal()
end

---
-- @return boolean
-- @realm client
function PANEL:IsActive()
    if self:HasFocus() or vgui.FocusedHasParent(self) then
        return true
    end

    return false
end

---
-- @ignore
function PANEL:Think()
    local scrW = ScrW()
    local scrH = ScrH()
    local mousex = math.Clamp(gui.MouseX(), 1, scrW - 1)
    local mousey = math.Clamp(gui.MouseY(), 1, scrH - 1)

    if self.dragging then
        local x = mousex - self.dragging[1]
        local y = mousey - self.dragging[2]

        -- Lock to screen bounds if screenlock is enabled
        if self:GetScreenLock() then
            x = math.Clamp(x, 0, scrW - self:GetWide())
            y = math.Clamp(y, 0, scrH - self:GetTall())
        end

        self:SetPos(x, y)
    end

    if self.sizing then
        local x = mousex - self.sizing[1]
        local y = mousey - self.sizing[2]
        local px, py = self:GetPos()

        if x < self.m_iMinWidth then
            x = self.m_iMinWidth
        elseif x > scrW - px and self:GetScreenLock() then
            x = scrW - px
        end

        if y < self.m_iMinHeight then
            y = self.m_iMinHeight
        elseif y > scrH - py and self:GetScreenLock() then
            y = scrH - py
        end

        self:SetSize(x, y)
        self:SetCursor("sizenwse")

        return
    end

    local screenX, screenY = self:LocalToScreen(0, 0)

    if
        self.Hovered
        and self.m_bSizable
        and mousex > (screenX + self:GetWide() - 20)
        and mousey > (screenY + self:GetTall() - vskin.GetHeaderHeight())
    then
        self:SetCursor("sizenwse")

        return
    end

    if self.Hovered and self:GetDraggable() and mousey < (screenY + vskin.GetHeaderHeight()) then
        self:SetCursor("sizeall")

        return
    end

    self:SetCursor("arrow")

    -- Don't allow the frame to go higher than 0
    if self.y < 0 then
        self:SetPos(self.x, 0)
    end
end

---
-- @ignore
function PANEL:Paint(w, h)
    if self.m_bBackgroundBlur then
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
    end

    derma.SkinHook("Paint", "FrameTTT2", self, w, h)

    return true
end

---
-- @realm client
function PANEL:OnMousePressed()
    local screenX, screenY = self:LocalToScreen(0, 0)

    if
        self.m_bSizable
        and gui.MouseX() > (screenX + self:GetWide() - 20)
        and gui.MouseY() > (screenY + self:GetTall() - vskin.GetHeaderHeight())
    then
        self.sizing = {
            gui.MouseX() - self:GetWide(),
            gui.MouseY() - self:GetTall(),
        }

        self:MouseCapture(true)

        return
    end

    if self:GetDraggable() and gui.MouseY() < (screenY + vskin.GetHeaderHeight()) then
        self.dragging = {
            gui.MouseX() - self.x,
            gui.MouseY() - self.y,
        }

        self:MouseCapture(true)
    end
end

---
-- @realm client
function PANEL:OnMouseReleased()
    self.dragging = nil
    self.sizing = nil

    self:MouseCapture(false)
end

---
-- @ignore
function PANEL:PerformLayout()
    local size = vskin.GetHeaderHeight()

    self.btnClose:SetPos(self:GetWide() - size, 0)
    self.btnClose:SetSize(size, size)

    self.btnBack:SetPos(0, 0)
    self.btnBack:SetSize(100, size)

    self:UpdatePadding()
end

derma.DefineControl("DFrameTTT2", "A simple window", PANEL, "EditablePanel")
