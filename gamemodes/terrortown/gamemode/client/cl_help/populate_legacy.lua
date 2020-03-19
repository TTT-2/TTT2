local materialIcon = Material("vgui/ttt/vskin/helpscreen/legacy")

-- get all registered legacy tabs
local function GetLegacyTabs()
	local dtabs = vgui.Create("DPropertySheet")

	hook.Run("TTTSettingsTabs", dtabs)

	local items = dtabs:GetItems()

	dtabs:Remove()

	return items
end

-- check if there are any legacy menues by probing the hook
local function CheckForLegacyTabs()
	return #GetLegacyTabs() > 0
end


---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_legacy"] = function(helpData, id)
	if not CheckForLegacyTabs() then return end

	-- there is at least one item, use this
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_legacy_title")
	bindingsData:SetDescription("menu_legacy_description")
	bindingsData:SetIcon(materialIcon)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_legacy"] = function(helpData, id)
	local legacyTabs = GetLegacyTabs()

	for i = 1, #legacyTabs do
		local legacyTab = legacyTabs[i]

		local convertedTab = helpData:PopulateSubMenu(id .. "_" .. legacyTab.Name)
		convertedTab:SetTitle(legacyTab.Name)
		convertedTab:PopulatePanel(function(parent)
			local psizeX, _ = parent:GetSize()
			local _, lsizeY = legacyTab.Panel:GetSize()
			local ppadLeft, _, ppadRight, _ = parent:GetDockPadding()

			legacyTab.Panel:SetParent(parent)
			legacyTab.Panel:SetSize(
				psizeX - ppadLeft - ppadRight,
				lsizeY + 2 * HELPSCRN.pad
			)
			legacyTab.Panel:Dock(FILL)
		end)
	end
end
