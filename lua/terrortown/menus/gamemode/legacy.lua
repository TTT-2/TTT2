--- @ignore

local tableCopy = table.Copy

local virtualSubmenus = {}

-- THIS IS A HACKY WORKAROUND TO KEEP SUPPORT FOR OLD TTT ADDONS
-- The problem that is solved here is, that children get removed
-- once their parent is removed. This happens on two occasions:
-- 1. once the DTab is removed because the children are moved to
--    to the new parents, the children are no longer valid as well
-- 2. once the submenu tab is changed, the content area gets cleared
--    and with the content area all connected children, throwing an
--    error by opening a submenu tab twice.
-- Feel free to improve if you got a better idea.
local elemStore

local function RegisterLegacyTabCache()
    elemStore = vgui.Create("DPropertySheet")
    elemStore:SetVisible(false)

    elemStore.AddSheet = function(slf, label, panel, material, noStretchX, noStretchY, tooltip)
        if not IsValid(panel) then
            ErrorNoHaltWithStack("DPropertySheet:AddSheet tried to add invalid panel!")

            return
        end

        local sheet = {}

        sheet.name = label
        sheet.panel = panel
        sheet.panel.NoStretchX = noStretchX
        sheet.panel.NoStretchY = noStretchY

        slf.Items[#slf.Items + 1] = sheet

        return sheet
    end

    elemStore.ResetItems = function(slf)
        slf.Items = {}
    end

    -- moves children to tab cache to prevent deleting of children
    hook.Add(
        "TTT2OnHelpSubMenuClear",
        "TTT2HandleLegacyClear",
        function(parent, nameMenuOpen, lastMenuData, menuData)
            if nameMenuOpen ~= "ttt2_legacy" or not elemStore then
                return
            end

            local children = parent:GetChildren()

            for i = 1, #children do
                children[i]:SetParent(elemStore)
            end
        end
    )
end

local function GetLegacyTabs()
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

-- check if there are any legacy menues by probing the hook
local function CheckForLegacyTabs()
    local dtabs = vgui.Create("DPropertySheet")

    ---
    -- @realm client
    hook.Run("TTTSettingsTabs", dtabs)

    local amount = #dtabs:GetItems()

    dtabs:Remove()

    return amount > 0
end

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/legacy")
CLGAMEMODEMENU.title = "menu_legacy_title"
CLGAMEMODEMENU.description = "menu_legacy_description"
CLGAMEMODEMENU.priority = 94

function CLGAMEMODEMENU:Initialize()
    -- add "virtual" submenus that are treated as real one even without files

    if not CheckForLegacyTabs() then
        return
    end

    -- register legacy tab cache
    RegisterLegacyTabCache()

    local legacyTabs = GetLegacyTabs()
    local legacyMenuBase = self:GetSubmenuByName("base_legacy")

    for i = 1, #legacyTabs do
        local legacyTab = legacyTabs[i]

        virtualSubmenus[i] = tableCopy(legacyMenuBase)
        virtualSubmenus[i].title = legacyTab.name
        virtualSubmenus[i].elemStore = elemStore
        virtualSubmenus[i].index = i
    end
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
    return virtualSubmenus
end

---
-- This hook was used in TTT to populate the F1 settings menu. It shouldn't be used
-- anymore as it is deprecated.
-- @deprecated
-- @hook
-- @realm client
function GM:TTTSettingsTabs() end
