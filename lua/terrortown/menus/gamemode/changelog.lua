--- @ignore

local tableCopy = table.Copy
local stringLower = string.lower
local stringFind = string.find
local TryT = LANG.TryTranslation

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/changelog")
CLGAMEMODEMENU.title = "menu_changelog_title"
CLGAMEMODEMENU.description = "menu_changelog_description"
CLGAMEMODEMENU.priority = 100

function CLGAMEMODEMENU:Initialize()
    -- add "virtual" submenus that are treated as real one even without files
    local changelog = GetSortedChanges()
    local changelogMenuBase = self:GetSubmenuByName("base_changelog")

    for i = 1, #changelog do
        local change = changelog[i]

        virtualSubmenus[i] = tableCopy(changelogMenuBase)
        virtualSubmenus[i].title = change.version
        virtualSubmenus[i].change = change
    end
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
    return virtualSubmenus
end

-- overwrite and return true to enable a searchbar
function CLGAMEMODEMENU:HasSearchbar()
    return true
end

-- overwrite and do a custom search inside title, date and content
function CLGAMEMODEMENU:MatchesSearchString(submenuClass, searchText)
    local txt = stringLower(searchText)
    local change = submenuClass.change

    if stringFind(stringLower(TryT(submenuClass.title)), txt) then
        return true
    end

    if change.date > 0 and stringFind(stringLower(os.date("%Y/%m/%d", change.date)), txt) then
        return true
    end

    if stringFind(stringLower(submenuClass.change.text), txt) then
        return true
    end

    return false
end
