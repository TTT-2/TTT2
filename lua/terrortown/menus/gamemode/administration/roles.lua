--- @ignore

-- This file exists to override the file in the workshop version if it still has it here.
-- Accordingly, it can be removed for the workshop release.

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_roles_general_title"

local TryT = LANG.TryTranslation

function CLGAMEMODESUBMENU:Populate(parent) end

function CLGAMEMODESUBMENU:ShouldShow()
    return false
end
