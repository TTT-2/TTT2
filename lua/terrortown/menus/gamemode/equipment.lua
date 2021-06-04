--- @ignore

local tableCopy = table.Copy

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/equipment")
CLGAMEMODEMENU.title = "menu_equipment_title"
CLGAMEMODEMENU.description = "menu_equipment_description"
CLGAMEMODEMENU.priority = 49

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.lang = "en"

function CLGAMEMODEMENU:Initialize()
	-- Don't create Submenus here as the needed data needs to be loaded later
	return
end

function CLGAMEMODEMENU:InitializeData()
	-- add "virtual" submenus that are treated as real one even without files
	virtualSubmenus = {}

	local items = ShopEditor.GetEquipmentForRoleAll()
	local equipmentMenuBase = self:GetSubmenuByName("base_equipment")

	-- In a first pass get all translated titles
	for i = 1, #items do
		local item = items[i]
		local name = item.EquipMenuData and LANG.TryTranslation(item.EquipMenuData.name)
		local printName = LANG.TryTranslation(item.PrintName)
		local title = item.EquipMenuData and name ~= item.EquipMenuData.name and name or printName or item.id or "UNDEFINED"
		item.title = title
	end

	-- In a second pass we insert all items sorted by their translated title
	local counter = 0
	for key, item in SortedPairsByMemberValue(items, "title") do
		counter = counter + 1
		virtualSubmenus[counter] = tableCopy(equipmentMenuBase)
		virtualSubmenus[counter].title = item.title
		virtualSubmenus[counter].item = item
	end
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
	lang = GetConVar("ttt_language"):GetString()
	if not self.isInitialized or lang ~= self.lang then
		self.isInitialized = true
		self.lang = lang
		self:InitializeData()
	end
	return virtualSubmenus
end

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end
