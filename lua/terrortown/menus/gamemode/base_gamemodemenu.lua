---
-- @class CLGAMEMODEMENU

CLGAMEMODEMENU.type = "base_gamemodemenu"
CLGAMEMODEMENU.priority = 0
CLGAMEMODEMENU.icon = nil
CLGAMEMODEMENU.title = ""
CLGAMEMODEMENU.description = ""

CLGAMEMODEMENU.submenus = {}

function CLGAMEMODEMENU:ShouldShow()
	if not LocalPlayer():IsAdmin() and self:IsAdminMenu() then
		return false
	end

	return #self:GetSubmenus() > 0
end

function CLGAMEMODEMENU:IsAdminMenu()
	return false
end

function CLGAMEMODEMENU:GetSubmenus()
	return self.submenus
end

function CLGAMEMODEMENU:GetSubmenuByName(name)
	for i = 1, #self.submenus do
		local submenu = self.submenus[i]

		if submenu.type ~= name then continue end

		return submenu
	end
end

function CLGAMEMODEMENU:SetSubmenuTable(submenuTable)
	self.submenus = submenuTable
end

function CLGAMEMODEMENU:AddSubmenu(submenu)
	self.submenus[#self.submenus + 1] = submenu
end

function CLGAMEMODEMENU:Initialize()

end
