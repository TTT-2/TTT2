---
-- @class CLGAMEMODEMENU

CLGAMEMODEMENU.type = "base_gamemodemenu"
CLGAMEMODEMENU.priority = 0
CLGAMEMODEMENU.icon = nil
CLGAMEMODEMENU.title = ""
CLGAMEMODEMENU.description = ""

CLGAMEMODEMENU.submenus = {}

function CLGAMEMODEMENU:IsVisible()
	return true
end

function CLGAMEMODEMENU:IsAdminMenu()
	return false
end

function CLGAMEMODEMENU:GetSubMenus()
	return self.submenus
end

function CLGAMEMODEMENU:SetSubMenuTable(submenuTable)
	self.submenus = submenuTable
end

function CLGAMEMODEMENU:AddSubMenu(submenu)
	self.submenus[#self.submenus + 1] = submenu
end

function CLGAMEMODEMENU:Initialize()

end
