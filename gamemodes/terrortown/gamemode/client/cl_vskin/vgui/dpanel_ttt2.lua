---
-- @class PANEL
-- @section TTT2:DPanel

local PANEL = {}

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDisableTabbing", "TabbingDisabled", FORCE_BOOL) -- ??? needed in TTT2:DTextEntry?

---
-- @ignore
function PANEL:Init()
    self:SetEnabled(true)
    self:SetPaintBackground(true)

    -- set the default name for the paint hook
    self:SetPaintHookName("PanelTTT2")

    -- remove some hooks here so that it looks cleaner when the
    -- class table is printed
    self.OnToggled = nil
    self.OnLeftClick = nil
    self.OnLeftClickInternal = nil
    self.OnRightClick = nil
    self.OnMiddleClick = nil
    self.OnDoubleClick = nil
    self.OnDoubleClickInternal = nil

    -- TODO: maybe some engine hooks should be removed here as well?
end

---
-- @ignore
function PANEL:SetEnabled(state)
    self.m_bEnabled = state

    if state then
        self:SetAlpha(255)
        self:SetMouseInputEnabled(true)
    else
        self:SetAlpha(75)
        self:SetMouseInputEnabled(false)
    end

    return self
end

---
-- @ignore
function PANEL:OnMousePressed(mouseCode)
    if self:IsSelectionCanvas() and not dragndrop.IsDragging() then
        self:StartBoxSelection()

        return
    end

    if self:IsDraggable() then
        self:MouseCapture(true)
        self:DragMousePress(mouseCode)
    end

    self:TriggerOnWithBase("Depressed", mouseCode)
end

---
-- @ignore
function PANEL:OnMouseReleased(mouseCode)
    if self:EndBoxSelection() then
        return
    end

    self:MouseCapture(false)

    if self:DragMouseRelease(mouseCode) then
        return
    end

    self:TriggerOnWithBase("Released", mouseCode)
end

derma.DefineControl(
    "TTT2:DPanel",
    "The basic Panel everything in TTT2 is based on",
    PANEL,
    "TTT2:DLabel"
)
