local materialIcon = Material("vgui/ttt/vskin/helpscreen/legacy")

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
			ErrorNoHalt("DPropertySheet:AddSheet tried to add invalid panel!")
			debug.Trace()

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
	hook.Add("TTT2OnHelpSubMenuClear", "TTT2HandleLegacyClear", function(parent, nameMenuOpen, lastMenuData, menuData)
		if nameMenuOpen ~= "ttt2_legacy" or not elemStore then return end

		local children = parent:GetChildren()

		for i = 1, #children do
			children[i]:SetParent(elemStore)
		end
	end)
end

local function GetLegacyTabs()
	if not elemStore then
		return {}
	end

	elemStore:Clear()
	elemStore:ResetItems()

	hook.Run("TTTSettingsTabs", elemStore)

	return elemStore:GetItems()
end

-- check if there are any legacy menues by probing the hook
local function CheckForLegacyTabs()
	local dtabs = vgui.Create("DPropertySheet")

	hook.Run("TTTSettingsTabs", dtabs)

	local amount = #dtabs:GetItems()

	dtabs:Remove()

	return amount > 0
end

HELPSCRN.populate["ttt2_legacy"] = function(helpData, id)
	if not CheckForLegacyTabs() then return end

	-- register legacy tab cache
	RegisterLegacyTabCache()

	-- there is at least one item, use this
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_legacy_title")
	bindingsData:SetDescription("menu_legacy_description")
	bindingsData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_legacy"] = function(helpData, id)
	local legacyTabs = GetLegacyTabs()

	for i = 1, #legacyTabs do
		local legacyTab = legacyTabs[i]
		local name = legacyTab.name
		local panel = legacyTab.panel

		local convertedTab = helpData:PopulateSubMenu(id .. "_" .. name)

		convertedTab:SetTitle(name)
		convertedTab:PopulatePanel(function(parent)
			local psizeX, psizeY = parent:GetSize()
			local ppadLeft, _, ppadRight, _ = parent:GetDockPadding()

			panel:SetParent(parent)
			panel:SetSize(
				psizeX - ppadLeft - ppadRight,
				psizeY - 2 * HELPSCRN.padding
			)
			panel:Dock(FILL)
		end)
	end
end
