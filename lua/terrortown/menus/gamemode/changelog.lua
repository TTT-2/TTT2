--- @ignore

local tableCopy = table.Copy

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
