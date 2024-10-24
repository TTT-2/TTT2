--- @ignore

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

local function GetLegacyTabs(elemStore)
    if not elemStore then
        return {}
    end

    elemStore:Clear()
    elemStore:ResetItems()

    ---
    -- @realm client
    hook.Run("TTTSettingsTabs", elemStore)

    return elemStore:GetItems()
end

function CLGAMEMODESUBMENU:Populate(parent)
    -- Always recreate LegacyTabs to prevent a NULL panel from parent deletion
    local legacyTab = GetLegacyTabs(self.elemStore)[self.index]

    if not legacyTab then
        return
    end

    local panel = legacyTab.panel

    local psizeX, psizeY = parent:GetSize()
    local ppadLeft, _, ppadRight, _ = parent:GetDockPadding()

    panel:SetParent(parent)
    panel:SetSize(psizeX - ppadLeft - ppadRight, psizeY - 2 * HELPSCRN.padding)
    panel:Dock(FILL)
end
