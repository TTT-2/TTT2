--- @ignore

local tableCopy = table.Copy
local TryT = LANG.TryTranslation

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/equipment")
CLGAMEMODEMENU.title = "menu_equipment_title"
CLGAMEMODEMENU.description = "menu_equipment_description"
CLGAMEMODEMENU.priority = 49

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.langConVar = nil
CLGAMEMODEMENU.lang = nil

function CLGAMEMODEMENU:InitializeVirtualMenus()
	-- add "virtual" submenus that are treated as real one even without files
	virtualSubmenus = {}

	local equipments = ShopEditor.GetEquipmentForRoleAll()
	local equipmentMenuBase = self:GetSubmenuByName("base_equipment")

	-- Assign all equipments to a virtual menu
	local counter = 0
	for i = 1, #equipments do
		local equipment = equipments[i]

		-- Only keep ttt-equipments that are cached
		if not equipment.ttt2_cached_material and not equipment.ttt2_cached_model then continue end

		counter = counter + 1

		virtualSubmenus[counter] = tableCopy(equipmentMenuBase)
		virtualSubmenus[counter].equipment = equipment
		virtualSubmenus[counter].isItem = items.IsItem(equipment)
		virtualSubmenus[counter].icon = equipment.ttt2_cached_material
		virtualSubmenus[counter].iconFullSize = true
	end
end

function CLGAMEMODEMENU:TranslateAndSortMenus()
	-- In a first pass translate all equipment names and assign them to a title
	for i = 1, #virtualSubmenus do
		local vMenu = virtualSubmenus[i]
		local equipment = vMenu.equipment
		local name = equipment.EquipMenuData and equipment.EquipMenuData.name

		vMenu.title = TryT(name) ~= name and TryT(name) or TryT(equipment.PrintName) or equipment.id or "UNDEFINED"
	end

	-- In a second pass we sort by their translated title
	table.SortByMember(virtualSubmenus, "title", true)
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
	if not self.isInitialized then
		self.isInitialized = true
		self.langConVar = GetConVar("ttt_language")

		self:InitializeVirtualMenus()
	end

	local lang = self.langConVar:GetString()

	if lang ~= self.lang then
		self.lang = lang

		self:TranslateAndSortMenus()
	end

	return virtualSubmenus
end

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end

-- overwrite and return true to enable a searchbar
function CLGAMEMODEMENU:HasSearchbar()
	return true
end
